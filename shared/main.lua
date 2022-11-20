Config = {}

Config.Locale = 'en' -- Language

Config.Command = 'fakeplate' -- Command to change plate (if you want to disable it, just put false)

Config.SQL = 'oxmysql' -- SQL type (oxmysql, ghmattimysql, mysql-async)

Config.PlateLetters  = 8 -- How many letters the plate will have (8 = 8 letters, 4 = 4 letters)

Config.PlateYear = '2022' -- The year of the plate (max 4 characters)

Config.PlateMonth = 'MAY' -- The month of the plate (max 3 characters)

Config.Time = 5000 -- Time to change plate (in ms)

Config.DataBaseChange = true -- If you want to change the plate in the database or only in the game (true/false)

Config.Item = { -- Item to change plate (if you want to use an item)
    useItem = true, -- If you want to use an item to change the plate (require restart server if you change this) (true/false)
    item = 'fakeplate', -- The item name (you can add it in your database) (require restart server if you change this)
    usableItem = true, -- If you want to use the item (require restart server if you change this) (true/false)
    removeItem = true, -- If you want to remove the item after changing the plate (true/false)
}

Config.BlackList = { -- Blacklist plates
    'example', -- Example
    'example2',
} 