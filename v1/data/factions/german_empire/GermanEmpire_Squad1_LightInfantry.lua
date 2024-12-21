GermanEmpire_Squad1_LightInfantry = {
      id = "light_infantry_squad",
      name = "Light Infantry",
      icon = love.graphics.newImage("assets/squad_icons/light_inf.png"),
      costs = 11, -- costs in command points
      available = true,
      time_til_deployment = 1, -- time in seconds until it arrives on the battlefield
      units = { -- units that are sent on the battle-field
        [GermanLightSoldier] = 20
      },
      -- upgrade a single squad ...
      upgrades = {
        -- one upgrade row: the first need to be done before the second ...
        {
          {
            id = "more_soldiers_i",
            name = "More Soldiers I",
            description = "Increases the number of soldiers in the squad by 10.",
            costs = {
              order = 10,
              resources = 100,
              manpower = 0
            },
            fn = function()
              GermanEmpire.light_infantry.units.GermanLightSoldier = (
                GermanEmpire.light_infantry.units.GermanLightSoldier + 10
              )
            end
          },
          {
            id = "more_soldiers_ii",
            name = "More Soldiers II",
            description = "Increases the number of soldiers in the squad by 15.",
            costs = {
              order = 20,
              resources = 200,
              manpower = 0
            },
            fn = function()
              GermanEmpire.light_infantry.units.GermanLightSoldier = (
                GermanEmpire.light_infantry.units.GermanLightSoldier + 10
              )
            end
          },
        }
      }
    }