--- A faction is one faction on the campaign map.
--- It contains all the possible squads to call into
--- battle and their upgrades.
GermanEmpire = {
  id = "german_empire",
  name = "German Empire",
  description = "The German Empire is a faction in the campaign.",
  color = { 1, 0, 0 },
   -- used to draw the squads in order in campaign and battle...
  squads = {
    GermanEmpire_Squad1_LightInfantry,
    GermanEmpire_Squad2_MotorizedInfantry
  },
  global_technologies = {
    {
      id = "train_soldiers_i",
      name = "Train Soldiers I",
      description = "Increases the health of all soldiers by 10%.",
      costs = {
        order = 10,
        resources = 100,
        manpower = 0
      },
      fn = function()
        for _, squad in pairs(GermanEmpire.squads) do
          for unit, count in pairs(squad.units) do
            if UnitClass[unit].is_infantry then
              UnitClass[unit].hp = UnitClass[unit].hp * 1.1
            end
          end
        end
      end
    }
  }
}