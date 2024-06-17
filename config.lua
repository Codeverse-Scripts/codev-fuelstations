Config = {
    Framework = 'qb', -- qb or esx

    Vehicles = {
        ["Rumpo"] = {
            Name = "Rumpo", -- Name of the vehicle
            Price = 40000, -- Price to buy the vehicle
            Capacity = 500, -- Max fuel liters
            imgName = "rumpo.png", -- Image name in ui/assets/vehicle
            carHash = "rumpo", -- Vehicle hash
        },
        ["Youga"] = {
            Name = "Youga", -- Name of the vehicle
            Price = 80000, -- Price to buy the vehicle
            Capacity = 1000, -- Max fuel liters
            imgName = "youga.png", -- Image name in ui/assets/vehicle
            carHash = "youga", -- Vehicle hash
        },
        ["Mule"] = {
            Name = "Mule", -- Name of the vehicle
            Price = 140000, -- Price to buy the vehicle
            Capacity = 2500, -- Max fuel liters
            imgName = "mule.png", -- Image name in ui/assets/vehicle
            carHash = "mule3", -- Vehicle hash
        },
        ["Truck"] = {
            Name = "Truck", -- Name of the vehicle
            Price = 200000, -- Price to buy the vehicle
            Capacity = 5000, -- Max fuel liters
            imgName = "truck.png", -- Image name in ui/assets/vehicle
            carHash = "truck", -- Vehicle hash
        },
    },

    FuelCenter = {
        Name = "Fuel Center", -- Name of the fuel center
        Coords = vector3(2891.5747, 4380.7568, 50.3400), -- Blip coords
        Blip = 361, -- Blip sprite
        BlipColor = 5, -- Blip color
        BlipScale = 0.8, -- Blip scale
    },

    Stations = {
        ["Station 1"] = {
            Name = "Station 1", -- Name of the station
            Price = 10000, -- Price to buy the station
            Capacity = 1000, -- Default fuel liters
            DefaultPrice = 1.2, -- Default price per liter
            StartFuel = 100, -- Default fuel liters

            VehicleSpawnCoords = {
                vector4(646.4896, 278.2758, 103.1506, 151.0490),
                vector4(643.0338, 280.0640, 103.2018, 154.0406),
                vector4(640.2499, 281.6044, 103.1882, 141.5911),
                vector4(637.4510, 283.2697, 103.1617, 149.9429),
            },

            Coords = {
                Blip = vector3(620.6737, 268.7852, 103.0895),
                Management = vector3(641.9258, 260.6900, 103.2956),
            }
        },
        ["Station 2"] = {
            Name = "Station 2", -- Name of the station
            Price = 5000, -- Price to buy the station
            Capacity = 500, -- Default fuel liters
            DefaultPrice = 1.0, -- Default price per liter
            StartFuel = 100, -- Default fuel liters

            VehicleSpawnCoords = {
                vector4(40.4147, 2796.9690, 57.8782, 144.1937),
                vector4(42.1255, 2806.1023, 57.8782, 140.1179),
            },

            Coords = {
                Blip = vector3(49.8012, 2779.3159, 58.0431),
                Management = vector3(46.2446, 2788.7515, 57.8783),
            }
        },
        ["Station 3"] = {
            Name = "Station 3", -- Name of the station
            Price = 4000, -- Price to buy the station
            Capacity = 400, -- Default fuel liters
            DefaultPrice = 0.5, -- Default price per liter
            StartFuel = 100, -- Default fuel liters

            VehicleSpawnCoords = {
                vector4(244.2273, 2599.6851, 45.1113, 278.4167),
                vector4(256.3364, 2599.5903, 44.8030, 280.0932),
            },

            Coords = {
                Blip = vector3(264.0502, 2606.4165, 44.9830),
                Management = vector3(265.8952, 2598.3223, 44.8352),
            }
        },
        ["Station 4"] = {
            Name = "Station 4", -- Name of the station
            Price = 8000, -- Price to buy the station
            Capacity = 800, -- Default fuel liters
            DefaultPrice = 1.8, -- Default price per liter
            StartFuel = 100, -- Default fuel liters

            VehicleSpawnCoords = {
                vector4(1022.7210, 2663.6482, 39.5511, 268.8333),
                vector4(1022.6290, 2667.2991, 39.5511, 272.6640),
                vector4(1022.5136, 2671.5815, 39.5306, 291.6922),
            },

            Coords = {
                Blip = vector3(1040.2164, 2671.7681, 39.5510),
                Management = vector3(1039.4434, 2664.7192, 39.5511),
            }
        },
        ["Station 5"] = {
            Name = "Station 5", -- Name of the station
            Price = 10000, -- Price to buy the station
            Capacity = 1000, -- Default fuel liters
            DefaultPrice = 1.5, -- Default price per liter
            StartFuel = 100, -- Default fuel liters

            VehicleSpawnCoords = {
                vector4(2665.4360, 3256.9802, 55.2405, 151.1246),
                vector4(2662.0667, 3258.3257, 55.2405, 150.0652),
                vector4(2658.0532, 3260.2200, 55.2405, 150.1353),
            },

            Coords = {
                Blip = vector3(2679.1819, 3264.0283, 55.4093),
                Management = vector3(2674.3342, 3266.7122, 55.2406),
            }
        },
        ["Station 6"] = {
            Name = "Station 6", -- Name of the station
            Price = 10000, -- Price to buy the station
            Capacity = 1000, -- Default fuel liters
            DefaultPrice = 1.5, -- Default price per liter
            StartFuel = 100, -- Default fuel liters

            VehicleSpawnCoords = {
                vector4(1981.9819, 3783.8269, 32.1808, 211.8671),
                vector4(1978.5818, 3777.5801, 32.1814, 214.5740),
            },

            Coords = {
                Blip = vector3(2004.8384, 3774.1194, 32.4039),
                Management = vector3(2002.1727, 3779.5449, 32.1808),
            }
        },
        ["Station 7"] = {
            Name = "Station 7", -- Name of the station
            Price = 12000, -- Price to buy the station
            Capacity = 1200, -- Default fuel liters
            DefaultPrice = 1.5, -- Default price per liter
            StartFuel = 100, -- Default fuel liters

            VehicleSpawnCoords = {
                vector4(1697.2673, 4914.9067, 42.0781, 57.4835),
                vector4(1688.2684, 4915.4678, 42.0782, 53.0116),
                vector4(1678.3765, 4922.0869, 42.0674, 16.2448),
            },

            Coords = {
                Blip = vector3(1687.3427, 4929.8501, 42.0781),
                Management = vector3(1702.0839, 4936.9478, 42.0781),
            }
        },
        ["Station 8"] = {
            Name = "Station 8", -- Name of the station
            Price = 10000, -- Price to buy the station
            Capacity = 1000, -- Default fuel liters
            DefaultPrice = 1.5, -- Default price per liter
            StartFuel = 100, -- Default fuel liters

            VehicleSpawnCoords = {
                vector4(1720.2991, 6424.4253, 33.4389, 151.1981),
                vector4(1718.4543, 6408.0132, 33.8638, 153.3856),
            },

            Coords = {
                Blip = vector3(1702.2002, 6417.8179, 32.640),
                Management = vector3(1705.5975, 6424.9966, 32.6354),
            }
        },
        ["Station 9"] = {
            Name = "Station 9", -- Name of the station
            Price = 20000, -- Price to buy the station
            Capacity = 3000, -- Default fuel liters
            DefaultPrice = 1.5, -- Default price per liter
            StartFuel = 100, -- Default fuel liters

            VehicleSpawnCoords = {
                vector4(150.6823, 6611.8750, 31.8594, 175.6757),
                vector4(145.6441, 6600.3491, 31.8469, 175.2391),
                vector4(145.5245, 6612.2930, 31.8216, 356.7521),
                vector4(156.0598, 6606.1265, 31.8747, 178.0500),
            },

            Coords = {
                Blip = vector3(180.4696, 6602.8564, 31.8640),
                Management = vector3(162.2781, 6636.3232, 31.5586),
            }
        },
        ["Station 10"] = {
            Name = "Station 10", -- Name of the station
            Price = 30000, -- Price to buy the station
            Capacity = 5000, -- Default fuel liters
            DefaultPrice = 1.5, -- Default price per liter
            StartFuel = 100, -- Default fuel liters

            VehicleSpawnCoords = {
                vector4(-2535.3533, 2342.6096, 33.0599, 209.1102),
                vector4(-2535.3533, 2342.6096, 33.0599, 209.1102),
                vector4(-2523.0520, 2335.8977, 33.0599, 212.2273),
                vector4(-2528.9736, 2333.3296, 33.0599, 212.9529),
            },

            Coords = {
                Blip = vector3(-2555.3298, 2330.9797, 33.0600),
                Management = vector3(-2544.1426, 2316.0566, 33.2161),
            }
        },
        ["Station 11"] = {
            Name = "Station 11", -- Name of the station
            Price = 20000, -- Price to buy the station
            Capacity = 2000, -- Default fuel liters
            DefaultPrice = 1.5, -- Default price per liter
            StartFuel = 100, -- Default fuel liters

            VehicleSpawnCoords = {
                vector4(-1407.8317, -274.7151, 46.3823, 130.3547),
                vector4(-1416.5688, -282.1089, 46.2396, 130.7797),
            },

            Coords = {
                Blip = vector3(-1436.4069, -274.8047, 46.2077),
                Management = vector3(-1428.7955, -269.0994, 46.2077),
            }
        },
        ["Station 12"] = {
            Name = "Station 12", -- Name of the station
            Price = 20000, -- Price to buy the station
            Capacity = 2000, -- Default fuel liters
            DefaultPrice = 1.5, -- Default price per liter
            StartFuel = 100, -- Default fuel liters

            VehicleSpawnCoords = {
                vector4(-2080.0576, -330.7923, 13.1192, 82.2907),
                vector4(-2078.9001, -323.4716, 13.1268, 86.4141),
            },

            Coords = {
                Blip = vector3(-2093.2839, -320.9021, 13.0272),
                Management = vector3(-2073.3540, -327.1919, 13.3096),
            }
        },
        ["Station 13"] = {
            Name = "Station 13", -- Name of the station
            Price = 20000, -- Price to buy the station
            Capacity = 2000, -- Default fuel liters
            DefaultPrice = 1.5, -- Default price per liter
            StartFuel = 100, -- Default fuel liters

            VehicleSpawnCoords = {
                vector4(-710.8945, -921.9550, 19.0139, 179.5949),
                vector4(-714.9492, -922.0057, 19.0139, 179.5162),
                vector4(-718.5616, -921.9171, 19.0139, 179.2050),
            },

            Coords = {
                Blip = vector3(-720.3494, -934.8868, 19.0170),
                Management = vector3(-702.9544, -916.9776, 19.2140),
            }
        },
        ["Station 14"] = {
            Name = "Station 14", -- Name of the station
            Price = 20000, -- Price to buy the station
            Capacity = 2000, -- Default fuel liters
            DefaultPrice = 1.5, -- Default price per liter
            StartFuel = 100, -- Default fuel liters

            VehicleSpawnCoords = {
                vector4(-517.8981, -1196.5121, 19.1797, 296.1675),
                vector4(-511.1763, -1202.8373, 19.1998, 339.8442),
            },

            Coords = {
                Blip = vector3(-526.0135, -1211.0129, 18.1808),
                Management = vector3(-531.4419, -1221.1511, 18.4535),
            }
        },
        ["Station 15"] = {
            Name = "Station 15", -- Name of the station
            Price = 20000, -- Price to buy the station
            Capacity = 2000, -- Default fuel liters
            DefaultPrice = 1.5, -- Default price per liter
            StartFuel = 100, -- Default fuel liters

            VehicleSpawnCoords = {
                vector4(-61.4785, -1744.7173, 29.3383, 50.0005),
                vector4(-59.0142, -1741.8547, 29.3304, 48.7892),
            },

            Coords = {
                Blip = vector3(-71.1301, -1761.5087, 29.6555),
                Management = vector3(-57.6993, -1754.7046, 29.2029),
            }
        },
        ["Station 16"] = {
            Name = "Station 16", -- Name of the station
            Price = 20000, -- Price to buy the station
            Capacity = 2000, -- Default fuel liters
            DefaultPrice = 1.5, -- Default price per liter
            StartFuel = 100, -- Default fuel liters

            VehicleSpawnCoords = {
                vector4(282.1235, -1274.2532, 29.2444, 87.4304),
                vector4(282.1993, -1268.7278, 29.2344, 90.6920),
                vector4(282.2623, -1262.7427, 29.2351, 86.0700),
            },

            Coords = {
                Blip = vector3(268.9026, -1261.0104, 29.1429),
                Management = vector3(288.2523, -1266.8630, 29.4407),
            }
        },
        ["Station 17"] = {
            Name = "Station 17", -- Name of the station
            Price = 20000, -- Price to buy the station
            Capacity = 2000, -- Default fuel liters
            DefaultPrice = 1.5, -- Default price per liter
            StartFuel = 100, -- Default fuel liters

            VehicleSpawnCoords = {
                vector4(808.6020, -1043.3870, 26.5604, 94.5485),
            },

            Coords = {
                Blip = vector3(819.6274, -1029.1078, 26.4043),
                Management = vector3(818.3270, -1040.1888, 26.7507),
            }
        },
        ["Station 18"] = {
            Name = "Station 18", -- Name of the station
            Price = 20000, -- Price to buy the station
            Capacity = 2000, -- Default fuel liters
            DefaultPrice = 1.5, -- Default price per liter
            StartFuel = 100, -- Default fuel liters

            VehicleSpawnCoords = {
                vector4(2566.4089, 392.3275, 108.4625, 357.4342),
                vector4(2565.5212, 378.7365, 108.4632, 176.8271),
            },

            Coords = {
                Blip = vector3(2581.3167, 362.0280, 108.4641),
                Management = vector3(2560.0452, 373.4524, 108.6208),
            }
        },
        ["Station 19"] = {
            Name = "Station 19", -- Name of the station
            Price = 20000, -- Price to buy the station
            Capacity = 2000, -- Default fuel liters
            DefaultPrice = 1.5, -- Default price per liter
            StartFuel = 100, -- Default fuel liters

            VehicleSpawnCoords = {
                vector4(-337.1403, -1458.9626, 30.5612, 276.3359),
            },

            Coords = {
                Blip = vector3(-319.2874, -1471.7256, 30.544),
                Management = vector3(-341.2664, -1482.5524, 30.6676),
            }
        },
    },

    PumpProps = {
        "prop_gas_pump_old2",
        "prop_gas_pump_1a",
        "prop_vintage_pump",
        "prop_gas_pump_old3",
        "prop_gas_pump_1c",
        "prop_gas_pump_1b",
        "prop_gas_pump_1d",
    },

    FuelExports = {
        ["SetFuel"] = function(veh, fuel)
            return exports["LegacyFuel"]:SetFuel(veh, fuel)
        end,
        
        ["GetFuel"] = function(veh)
            return exports["LegacyFuel"]:GetFuel(veh)
        end,
    },

    Notify = function(message, title, ttype, length)
        if Config.Framework == "qb" then
            Framework.Functions.Notify(message, ttype, length)
        else
            Framework.ShowNotification(message)
        end
    end
}