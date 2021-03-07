config.styles = {
    [constants.vehicleTypes.car] = {
        ['spawn'] = {
            type = 1,
            rgba = vec(0, 255, 139, 100),
            scale = vec(1.5, 1.5, 0.5),
            rangeToShow = 10
        },
        ['delete'] = {
            type = 1,
            rgba = vec(255, 0, 0, 100),
            scale = vec(5.0, 5.0, 0.5),
            rangeToShow = 10
        }
    },
    [constants.vehicleTypes.aircraft] = {
        ['spawn'] = {
            type = 1,
            rgba = vec(0, 255, 139, 100),
            scale = vec(1.5, 1.5, 0.5),
            rangeToShow = 10
        },
        ['delete'] = {
            type = 1,
            rgba = vec(255, 0, 0, 100),
            scale = vec(5.0, 5.0, 0.5),
            rangeToShow = 10
        }
    },
    [constants.vehicleTypes.boat] = {
        ['spawn'] = {
            type = 1,
            rgba = vec(0, 255, 139, 100),
            scale = vec(1.5, 1.5, 0.5),
            rangeToShow = 10
        },
        ['delete'] = {
            type = 1,
            rgba = vec(255, 0, 0, 100),
            scale = vec(5.0, 5.0, 0.5),
            rangeToShow = 10
        }
    }
}

config.locations = {
    ['blokkenpark'] = {
        garageType = 'car',
        location = vec(215.93, -809.83, 29.74),
        spawn = vec(229.5, -798.46, 29.59, 162.5),
        delete = vec(227.02, -750.03, 29.82),
        whitelist = {
            jobs = {
            },
            groups = {
                constants.groups.user
            } 
        }
    }
}