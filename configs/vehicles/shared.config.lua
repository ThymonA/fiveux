config.brands = {
    ['truffade'] = {
        name = 'Truffade',
        brand = 'truffade',
        image = 'https://static.wikia.nocookie.net/gtawiki/images/4/48/Truffade-Logo-GTAO.png/revision/latest/scale-to-width-down/512?cb=20181211210150'
    }
}

config.classes = {
    ['super'] = {
        name = 'super',
        label = T('class_super')
    },
    ['sport'] = {
        name = 'sport',
        label = T('class_sport')
    },
    ['classic'] = {
        name = 'classic',
        label = T('class_classic')
    },
    ['coupe'] = {
        name = 'coupe',
        label = T('class_coupe')
    },
    ['muscle'] = {
        name = 'muscle',
        label = T('class_muscle')
    },
    ['sedan'] = {
        name = 'sedan',
        label = T('class_sedan')
    },
    ['compact'] = {
        name = 'compact',
        label = T('class_compact')
    },
    ['suv'] = {
        name = 'suv',
        label = T('class_suv')
    },
    ['offroad'] = {
        name = 'offroad',
        label = T('class_offroad')
    },
    ['motorcycle'] = {
        name = 'motorcycle',
        label = T('class_motorcycle')
    }
}

config.vehicles = {
    ['adder'] = {
        name = 'Adder',
        brand = config.brands.truffade,
        class = config.classes.super,
        type = 'vehicle',
        price = 125000,
        hash = GetHashKey('adder'),
        trunk = 125000,
        image = 'https://vignette.wikia.nocookie.net/gtawiki/images/9/9e/Adder-GTAV-front.png'
    }
}
