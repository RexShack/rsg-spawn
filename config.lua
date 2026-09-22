Config = {}

Config.Debug = false

-- settings
Config.AutoDualWield = true

Config.SelectLocations = true

-- spawn location if Config.SelectLocations is false
Config.SpawnLocation = { coords = vector4(-169.47, 629.38, 114.03, 236.72) } -- valentine station

-- spawn locations if Config.SelectLocations is true
Config.SpawnLocations = {
    { id = 'valentine', label = 'Valentine', desc = 'The Heartlands', image = 'nui://rsg-spawn/html/img/valentine.jpg', coords = vec4(-169.47, 629.38, 114.03, 236.72) },
    { id = 'saintdenis', label = 'Saint Denis', desc = 'The Big City', image = 'nui://rsg-spawn/html/img/saintdenis.jpg', coords = vec4(2694.69, -1448.48, 46.27, 23.27) },
}

Config.RandomTips = {
    'TIP : use [LALT] to target',
    'TIP : use [H] to call your horse',
    'TIP : use [I] to open your inventory',
}

Config.SpawnChecks = {
    ["Character Creation"] = {
        badSpawn = {
            vector3(-550.2263, -3777.9907, 238.5975),
        },
        moveTo = {
            vector3(-171.6132, 625.8906, 114.0321),
        },
        Radius = 200,
    },
}
