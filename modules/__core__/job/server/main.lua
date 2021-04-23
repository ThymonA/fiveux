import 'db'
import 'logs'
import 'wallets'

--- Configuration
local cfg = ensure(config('general'), {})
local jobCfg = ensure(config('jobs'), {})

--- Local storage
local data = {}
local saveInterval = ensure(cfg.saveJobsInterval, 1)

---@class jobs
jobs = {}

--- Generates a job object
---@param name string Name of job
---@return job Generated job
function jobs:loadByName(name)
    name = ensure(name, 'unknown'):lower()

    if (name == 'unknown') then return nil end
    if (data == nil) then data = {} end
    if (data[name] ~= nil) then return data[name] end
    if (jobCfg == nil) then jobCfg = {} end
    if (jobCfg[name] == nil) then return nil end

    local jobConfig = ensure(jobCfg[name], {})
    local grades = ensure(jobConfig.grades, {})
    local categories = ensure(jobConfig.categories, {})
    local buyables = ensure(jobConfig.buyables, {})
    local sellables = ensure(jobConfig.sellables, {})
    local webhooks = ensure(jobConfig.webhooks, {})
    local locations = ensure(jobConfig.locations, {})

    ---@class job
    local job = {
        name = name,
        label = T(('job_%s'):format(name)),
        allowed = ensure(jobConfig.allowed, {}),
        denied = ensure(jobConfig.denied, {}),
        publicAllowed = ensure(jobConfig.publicAllowed, {}),
        grades = {},
        categories = {
            weapons = ensure(categories.weapons, {}),
            items = ensure(categories.items, {}),
            vehicles = ensure(categories.vehicles, {})
        },
        buyables = {
            weapons = ensure(buyables.weapons, {}),
            items = ensure(buyables.items, {}),
            vehicles = ensure(buyables.vehicles, {})
        },
        sellables = {
            weapons = ensure(sellables.weapons, {}),
            items = ensure(sellables.items, {}),
            vehicles = ensure(sellables.vehicles, {})
        },
        clothes = ensure(jobConfig.clothes, {}),
        vehicles = ensure(jobConfig.vehicles, {}),
        blips = ensure(jobConfig.blips, {}),
        webhooks = {
            action = ensure(webhooks.action, {}),
            safe = ensure(webhooks.safe, {}),
            money = ensure(webhooks.money, {}),
            employee = ensure(webhooks.employee, {}),
            sale = ensure(webhooks.sale, {}),
            moneyTransaction = ensure(webhooks.moneyTransaction, {}),
            itemTransaction = ensure(webhooks.itemTransaction, {}),
            weaponTransaction = ensure(webhooks.weaponTransaction, {})
        },
        locations = {
            safe_weapons = ensure(locations.safe_weapons, {}),
            safe_items = ensure(locations.safe_items, {}),
            wardrobes = ensure(locations.wardrobes, {}),
            garages = ensure(locations.garages, {}),
            parkings = ensure(locations.parkings, {}),
            vehicle_showrooms = ensure(locations.vehicle_showrooms, {}),
            weapon_showrooms = ensure(locations.weapon_showrooms, {}),
            item_showrooms = ensure(locations.item_showrooms, {}),
            vehicle_sells = ensure(locations.vehicle_sells, {}),
            weapon_sells = ensure(locations.weapon_sells, {}),
            item_sells = ensure(locations.item_sells, {}),
            vehicle_catalogues = ensure(locations.vehicle_catalogues, {}),
            weapon_catalogues = ensure(locations.weapon_catalogues, {}),
            item_catalogues = ensure(locations.item_catalogues, {})
        },
        wallets = wallets:loadAllByIdentifier(name),
        logger = logs:create('job', name),
    }

    for _, grade in pairs(grades) do
        local gradeName = ensure(grade.name, 'unknown')

        ---@class grade
        local grade = {
            grade = ensure(grade.grade, 0),
            name = gradeName,
            label = T(('job_%s_%s'):format(name, gradeName)),
            denied = ensure(grade.denied, {})
        }

        for _, allow in pairs(job.allowed) do
            ExecuteCommand(('add_ace job.%s:%s %s allow'):format(job.name, grade.name, ensure(allow, 'unknown')))
        end

        for _, deny in pairs(grade.denied) do
            ExecuteCommand(('add_ace job.%s:%s %s deny'):format(job.name, grade.name, ensure(deny, 'unknown')))
        end

        job.grades[grade.grade] = grade
    end

    for _, allow in pairs(job.allowed) do
        ExecuteCommand(('add_ace job.%s %s allow'):format(job.name, ensure(allow, 'unknown')))
    end

    for _, deny in pairs(job.denied) do
        ExecuteCommand(('add_ace job.%s %s deny'):format(job.name, ensure(deny, 'unknown')))
    end

    function job:triggerLocal(event, ...)
        return TriggerEvent(event, self, ...)
    end

    function job:triggerEvent(event, ...)
        return TriggerClientEvent(event, -1, ...)
    end

    function job:allowed(ace)
        ace = ensure(ace, 'unknown')

        local name = ensure(self.name, 'unknown')
        local allowed = IsPrincipalAceAllowed(('job.%s'):format(name), ace)

        return ensure(allowed, false)
    end

    function job:gradeAllowed(grade, ace)
        if (typeof(grade) == 'number') then
            grade = ensure(self.grades[grade], {}).name
        end
        grade = ensure(grade, 'unknown')
        ace = ensure(ace, 'unknown')

        local name = ensure(self.name, 'unknown')
        local allowed = IsPrincipalAceAllowed(('job.%s:%s'):format(name, grade), ace)

        return ensure(allowed, false)
    end

    function job:getWallet(name)
        name = ensure(name, 'unknown')

        if (self.wallets ~= nil and self.wallets[name] ~= nil) then
            return self.wallets[name].balance
        end
    end

    function job:setWallet(name, amount)
        name = ensure(name, 'unknown')
        amount = round(ensure(amount, 0))

        if (self.wallets ~= nil and self.wallets[name] ~= nil) then
            if (amount <= -2147483647) then amount = -2147483647 end
            if (amount >= 2147483647) then amount = 2147483647 end

            local prevBalance = ensure(self.wallets[name].balance, 0)

            self.wallets[name]:setBalance(amount)

            local newBalance = ensure(self.wallets[name].balance, 0)

            self:triggerLocal('job:wallet:set', name, self.wallets[name].balance, amount)
            self:triggerEvent('job:wallet:set', name, self.wallets[name].balance, amount)
            self:logWallet('set', name, amount, prevBalance, newBalance)
        end
    end

    function job:addWallet(name, amount)
        name = ensure(name, 'unknown')
        amount = round(ensure(amount, 0))

        if (self.wallets ~= nil and self.wallets[name] ~= nil) then
            if (amount <= -2147483647) then amount = -2147483647 end
            if (amount >= 2147483647) then amount = 2147483647 end

            local prevBalance = ensure(self.wallets[name].balance, 0)

            self.wallets[name]:addBalance(amount)

            local newBalance = ensure(self.wallets[name].balance, 0)

            self:triggerLocal('job:wallet:add', name, self.wallets[name].balance, amount)
            self:triggerEvent('job:wallet:add', name, self.wallets[name].balance, amount)
            self:logWallet('add', name, amount, prevBalance, newBalance)
        end
    end

    function job:removeWallet(name, amount)
        name = ensure(name, 'unknown')
        amount = round(ensure(amount, 0))

        if (self.wallets ~= nil and self.wallets[name] ~= nil) then
            if (amount <= -2147483647) then amount = -2147483647 end
            if (amount >= 2147483647) then amount = 2147483647 end

            local prevBalance = ensure(self.wallets[name].balance, 0)

            self.wallets[name]:removeBalance(amount)

            local newBalance = ensure(self.wallets[name].balance, 0)

            self:triggerLocal('job:wallet:remove', name, newBalance, amount)
            self:triggerEvent('job:wallet:remove', name, newBalance, amount)
            self:logWallet('remove', name, amount, prevBalance, newBalance)
        end
    end

    function job:logWallet(type, name, amount, prevBalance, newBalance)
        type = ensure(type, 'add')
        name = ensure(name, 'unknown')
        amount = ensure(amount, 0)
        prevBalance = ensure(prevBalance, 0)
        newBalance = ensure(newBalance, 0)

        self:log({
            arguments = { amount = amount, name = name, prev = prevBalance, new = newBalance },
            action = ('money.%s.%s'):format(name, type),
            discord = false
        })
    end

    function job:log(object)
        if (self.logger == nil) then return nil end

        return self.logger:log(object)
    end

    function job:save()
        for _, wallet in pairs(ensure(self.wallets, {})) do
            if (wallet ~= nil) then
                wallet:save()
            end
        end

        print_success(T('job_saved', name))
    end

    data[job.name] = job

    return job
end

--- Save all jobs
function jobs:saveAll()
    for name, job in pairs(data) do
        if (job ~= nil) then
            job:save()
        end
    end

    print_success(T('jobs_saved'))
end

--- Thread to save jobs every `x` time
Citizen.CreateThread(function()
    while db:hasMigration(NAME) do
        Citizen.Wait(0)
    end

    while true do
        Citizen.Wait(round(saveInterval * (60 * 1000)))

        jobs:saveAll()
    end
end)

--- Load all jobs by default
Citizen.CreateThread(function()
    while db:hasMigration(NAME) do
        Citizen.Wait(0)
    end

    for name, _ in pairs(jobCfg) do
        jobs:loadByName(ensure(name, 'unknown'))
    end
end)

--- Export jobs
export('jobs', jobs)