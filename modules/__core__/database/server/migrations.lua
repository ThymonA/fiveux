import 'modules'

local migrations = {}
local hasMigration = true

function migrations:exists(category, module, version)
    category = ensure(category, 'global')
    module = ensure(module, 'unknown')
    version = ensure(version, 'unknown')

    local query = "SELECT COUNT(*) AS 'exists' FROM `migrations` WHERE `category` = :category AND `module` = :module AND `name` = :name LIMIT 1"
    local dbResult = db:fetchScalar(query, {
        ['category'] = category,
        ['module'] = module,
        ['name'] = ('%s.lua'):format(version)
    })

    return ensure(dbResult, 0) == 1
end

function migrations:execute(category, module)
    category = ensure(category, 'global')
    module = ensure(module, 'unknown')
end

function migrations:init()
    local cfg = config('general')
    local db_name = ensure(cfg.databaseName, 'unknown')

    hasMigration = true

    local migrations, finished = nil, false
    local checkIfTableExists = "SELECT COUNT(*) AS 'exists' FROM `information_schema`.`tables` WHERE `table_schema` = :database AND `table_name` = :table LIMIT 1"
    local _migrationExists = db:fetchScalar(checkIfTableExists, {
        ['database'] = db_name,
        ['table'] = 'migrations'
    })

    if (not (ensure(_migrationExists, 0) == 1)) then
        local createTableQuery = [[
            CREATE TABLE `migrations` (
                `id` INT NOT NULL AUTO_INCREMENT,
                `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                `category` VARCHAR(100) NOT NULL,
                `module` VARCHAR(100) NOT NULL,
                `name` VARCHAR(100) NOT NULL,
                PRIMARY KEY (`id`)
            );
        ]]

        db:execute(createTableQuery)
    end

    migrations = db:fetchAll('SELECT * FROM `migrations`')
    migrations = ensure(migrations, {})

    local numberOfModules = sizeof(modules)
    local numberOfMigrationsDone = 0

    print_info(T('datebase_updating'))

    for _, module in pairs(modules) do
        module = ensure(module, {})

        Citizen.CreateThread(function()
            local m_name = ensure(module.name, 'unknown')
            local m_category = ensure(module.category, 'unknown')
            local index, hasMigration, hasAnyMigration = 0, true, false

            while (hasMigration) do
                local lua_exists = false
                local fileName = ('%s.lua'):format(index)
                local migrationPath, fileExists = ('modules/__%s__/%s/migrations/%s'):format(m_category, m_name, fileName)

                for _, migration in pairs(migrations) do
                    local dbName = ensure(migration.name, 'unknown')
                    local dbModule = ensure(migration.module, 'unknown')

                    if (dbName == fileName and dbModule == m_name) then
                        lua_exists = true
                    end
                end

                local rawMigration = LoadResourceFile(RESOURCE_NAME, migrationPath)

                if (rawMigration) then
                    hasAnyMigration = true

                    if (not lua_exists) then
                        local env = {}

                        for k, v in pairs(_G) do env[k] = v end
                        for k, v in pairs(_ENV) do env[k] = v end

                        env.CATEGORY = m_category
                        env.NAME = m_name
                        env.MODULE = m_name
                        env.DIRECTORY = ('modules/__%s__/%s/'):format(m_category, m_name)
                        env.PRIMARY = PRIMARY
                        env.ENVIRONMENT = ENVIRONMENT
                        env.RESOURCE_NAME = RESOURCE_NAME
                        env.migration = {}

                        local mt = setmetatable(env, {
                            __newindex = function(t, k, v)
                                rawset(env, k, v)
                                rawset(t, k, v)
                            end
                        })

                        env._ENV = mt

                        local migrationFinished = false
                        local migrationFunc, x = load(rawMigration, ('@%s:migration:%s:%s'):format(RESOURCE_NAME, m_name, index), 't', mt)

                        if (migrationFunc) then
                            local migration = xpcall(migrationFunc, print_error)

                            if (migration) then
                                mt.migration = ensure(mt.migration, {})

                                local dependencies = ensure(mt.migration.requirements, {})

                                for dependencyModule, sqlVersion in pairs(dependencies) do
                                    dependencyModule = ensure(dependencyModule, 'unknown')
                                    sqlVersion = ensure(sqlVersion, 0)

                                    if (dependencyModule == 'unknown') then
                                        print_error(T('migration_failed', m_name, fileName))
                                        return
                                    end

                                    while not self:migrationExists(dependencyModule, sqlVersion) do Citizen.Wait(0) end
                                end

                                local sqlQuery = ensure(env.migration.query, 'unknown')
                                local sqlParams = ensure(env.migration.params, {})

                                if (sqlQuery == 'unknown') then
                                    print_error(T('migration_failed', m_name, fileName))
                                    return
                                end

                                db:executeAsync(sqlQuery, sqlParams, function()
                                    db:insertAsync('INSERT INTO `migrations` (`category`, `module`, `name`) VALUES (:category, :module, :name)', {
                                        ['category'] = m_category,
                                        ['module'] = m_name,
                                        ['name'] = fileName
                                    }, function()
                                        migrationFinished = true
                                    end)
                                end)
                            else
                                print_error(T('migration_failed', m_name, fileName))
                                return
                            end
                        else
                            print_error(T('migration_failed', m_name, fileName))
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
                    print_success(T('migration_success', m_name))
                end
            end

            numberOfMigrationsDone = numberOfMigrationsDone + 1
        end)
    end

    repeat Citizen.Wait(0) until numberOfMigrationsDone == numberOfModules

    hasMigration = false
end

migrations:init()

repeat Citizen.Wait(0) until hasMigration == false