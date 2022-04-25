# zxn-recycleproducts
Item selling system for recycle items received from qb-recyclejob.

# License

    QBCore Framework
    Copyright (C) 2021 Joshua Eger

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>

## Dependencies
- [qb-core](https://github.com/qbcore-framework/qb-core)
- [PolyZone](https://github.com/mkafrin/PolyZone)
- [qb-menu](https://github.com/qbcore-framework/qb-menu) - Menu System for the QBCore Framework
- [qb-target](https://github.com/BerkieBb/qb-target) - Targeting solution for the QBCore Framework

## Demo
- [With qb-target](https://streamable.com/bk5ooj)
- [With PolyZone](https://streamable.com/mo3wjb)

## Features
- Sell all recycled items from qb-recyclejob

## Installation
### Manual
- Download the script and put it in the `[qb]` directory.

## Configuration
```
Config = {}

Config.UseTarget = true

Config.Location =  {x = -52.46, y = 6395.56, z = 31.49, h = 56.89}

Config.PedModel = "s_m_y_garbage"

Config.InteractionKey = 'E'

Config.ItemList = {
    ["metalscrap"] = math.random(3, 6),
    ["rubber"] = math.random(3,6),
    ["copper"] = math.random(3, 6),
    ["plastic"] = math.random(3, 6),
    ["iron"] = math.random(3, 6),
    ["aluminum"] = math.random(3, 6),
}
```
