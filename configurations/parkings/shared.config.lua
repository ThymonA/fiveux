config.markers = {
    available = {
        type = 2,
        rangeToShow = 5.0,
        color = vec(255, 0, 0, 100),
        size = vec(0.5, 0.5, 0.5),
        bobUpAndDown = true,
        rotate = true
    }
}

config.parkings = {}
config.parkings['parking_01'] = {
    whitelist = { groups = { 'all' }, jobs = { 'all' } },
    blacklist = { groups = {}, jobs = {} },
    spawn = vec(-125.07, -2536.84, 5.0, 235.5),
    spots = {
        vec(-121.07, -2534.47, 5.0, 234.5),
        vec(-119.02, -2531.71, 5.0, 235.5),
        vec(-117.26, -2529.16, 4.99, 235.5),
        vec(-115.45, -2526.51, 4.99, 234.5),
        vec(-113.6, -2523.98, 4.99, 234.5),
        vec(-111.91, -2521.31, 5.0, 235.5),
        vec(-109.97, -2518.55, 5.0, 235.5)
    }
}