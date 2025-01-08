
--- @type UnitClass
--- The tank itself has no weapon; the turret has the weapon.
GermanBaseTank = {
  speed = 100,
  hp = 100,
  attack = 0,
  pierce = 0,
  atlas = "mp_soldier",
  quad = "mp_soldier",
  collision_radius = 200,
  explosion_radius = 0,
  explosion_type = "none",
  can_throw_grenade = false,
  turrets = {
    --{
    --  relative_x = 10,
    --  relative_y = 10,
    --  unit_class = GermanDefaultTankTurret
    --}
  },
  is_infantry = false,
  armor_level = 4,
  accuracy = 0,
  weapon_range = 0,
  shooting_cooldown = 0
}
