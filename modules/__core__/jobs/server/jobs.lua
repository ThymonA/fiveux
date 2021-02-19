local data = {}

jobs = {}

function jobs:load()
    local jobConfig = config('jobs')

    for name, job in pairs(jobConfig) do
        name = ensure(name, 'unknown')

        print_success(T('job_loaded', T(('job_%s'):format(name)), name))

        data[name] = job
    end
end

jobs:load()

register('jobs', jobs)