local _boot = boot
local hasMigration = true
local pendingMigrations = true

local function migrationExists(module, version)
    module = ensure(module, 'unknown')
    version = ensure(version, 0)

    local checkMigrationExists = "SELECT COUNT(*) AS 'exists' FROM `migrations` WHERE `module` = :module AND `name` = :name LIMIT 1"
    local result = db:fetchScalar(checkMigrationExists, {
        ['module'] = module,
        ['name'] = ('%s.lua'):format(version)
    })

    return ensure(result, 0) == 1
end

local function executeMigration()
    _boot = _boot or boot

    local modules = _boot:getModules()
    local generalCfg = config('general')
    local database = ensure(generalCfg.databaseName, 'dobberdam')

    db:ready(function()
        hasMigration = true

        local migrations, finished = nil, false
        local checkIfTableExists = "SELECT COUNT(*) AS 'exists' FROM `information_schema`.`tables` WHERE `table_schema` = :database AND `table_name` = :table LIMIT 1"
        local _migrationExists = db:fetchScalar(checkIfTableExists, {
            ['database'] = database,
            ['table'] = 'migrations'
        })

        if (not (ensure(_migrationExists, 0) == 1)) then
            local createMigrationTable = [[
                CREATE TABLE `migrations` (
                    `id` INT NOT NULL AUTO_INCREMENT,
                    `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    `module` VARCHAR(100) NOT NULL,
                    `name` VARCHAR(100) NOT NULL,

                    PRIMARY KEY (`id`)
                );
            ]]

            debug("Create table '~x~migrations~s~'")

            db:execute(createMigrationTable)
        end

        migrations = db:fetchAll('SELECT * FROM `migrations`')
        migrations = ensure(migrations, {})

        local numberOfModules = sizeof(modules)
        local numberOfMigrationsDone = 0

        print(T('datebase_updating'))

        for key, value in pairs(modules) do
            Citizen.CreateThread(function()
                local index, hasMigration, hasAnyMigration = 0, true, false

                while (hasMigration) do
                    local lua_exists = false
                    local fileName = ('%s.lua'):format(index)
                    local migrationPath, fileExists = ('modules/%s/%s/migrations/%s'):format(value, key, fileName)

                    for _, migration in pairs(migrations) do
                        local dbName = ensure(migration.name, 'unknown')
                        local dbModule = ensure(migration.module, 'unknown')

                        if (dbName == fileName and dbModule == key) then
                            lua_exists = true
                        end
                    end

                    local rawMigration = LoadResourceFile(RESOURCE_NAME, migrationPath)

                    if (rawMigration) then
                        hasAnyMigration = true

                        if (not lua_exists) then
                            local env = {}

                            for k, v in pairs(_ENV) do env[k] = v end

                            env.__CATEGORY__ = value
                            env.__NAME__ = key
                            env.__MODULE__ = key
                            env.__DIRECTORY__ = ensure(__DIRECTORY__, ('modules/%s/%s'):format(value, key))
                            env.__PRIMARY__ = __PRIMARY__
                            env.__TRANSLATIONS__ = ensure(__TRANSLATIONS__, {})
                            env._ENV = env
                            env.ENVIRONMENT = ENVIRONMENT
                            env.RESOURCE_NAME = RESOURCE_NAME
                            env.migration = {}

                            debug(("Execute migration '~x~%s~s~' for module '~x~%s~s~'"):format(fileName, key))

                            local migrationFinished = false
                            local migrationFunc, x = load(rawMigration, ('@%s:migration:%s:%s'):format(RESOURCE_NAME, key, index), 't', env)

                            if (migrationFunc) then
                                local migration = xpcall(migrationFunc, print_error)

                                if (migration) then
                                    env.migration = ensure(env.migration, {})

                                    local dependencies = ensure(env.migration.requirements, {})

                                    for dependencyModule, sqlVersion in pairs(dependencies) do
                                        dependencyModule = ensure(dependencyModule, 'unknown')
                                        sqlVersion = ensure(sqlVersion, 0)

                                        if (dependencyModule == 'unknown') then
                                            print_error(T('migration_failed', key, fileName))
                                            return
                                        end

                                        while not migrationExists(dependencyModule, sqlVersion) do Citizen.Wait(0) end
                                    end

                                    local sqlQuery = ensure(env.migration.query, 'unknown')
                                    local sqlParams = ensure(env.migration.params, {})

                                    if (sqlQuery == 'unknown') then
                                        print_error(T('migration_failed', key, fileName))
                                        return
                                    end

                                    db:executeAsync(sqlQuery, sqlParams, function()
                                        db:insertAsync('INSERT INTO `migrations` (`module`, `name`) VALUES (:module, :name)', {
                                            ['module'] = key,
                                            ['name'] = fileName
                                        }, function()
                                            migrationFinished = true
                                        end)
                                    end)
                                else
                                    print_error(T('migration_failed', key, fileName))
                                    return
                                end
                            else
                                print_error(T('migration_failed', key, fileName))
                                return
                            end

                            repeat Citizen.Wait(0) until migrationFinished == true
                        end
                    else
                        hasMigration = false
                    end

                    index = index + 1

                    Citizen.Wait(0)

                    if (not hasMigration and hasAnyMigration) then
                        print_success(T('migration_success', key, (index - 2)))
                    end
                end

                numberOfMigrationsDone = numberOfMigrationsDone + 1
            end)
        end

        repeat Citizen.Wait(0) until numberOfMigrationsDone == numberOfModules

        pendingMigrations = true
    end)
end

executeMigration()