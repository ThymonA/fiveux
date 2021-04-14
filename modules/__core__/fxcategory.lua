name 'core'
description 'Framework core modules'

modules {
    { name = 'database', required = true },
    { name = 'logging', required = true },
    { name = 'ratelimit', required = true },
    { name = 'raycast', required = true },
    { name = 'wallet', required = true },
    { name = 'ban', required = true },
    { name = 'player', required = true },
    { name = 'marker', required = true },
    { name = 'command', required = true }
}