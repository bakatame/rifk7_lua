local function doubletap_charged()
  if not menu_ragebot.get_double_tap_key() or menu_ragebot.get_fake_duck() then return false end

  local local_player = engine.get_local_player()
  if not local_player or not engine.is_ingame() and not engine.is_connected() or local_player:get_netvar_int("m_lifeState") ~= 0 then return end
  
  local weapon = local_player:get_active_weapon()
  if weapon == nil then return false end
  local next_attack = local_player:get_netvar_float("m_flNextAttack") + 0.25
  
  local next_primary_attack = weapon:get_netvar_float("m_flNextPrimaryAttack") + 0.25

  if next_attack == nil or next_primary_attack == nil then return false end

  return next_attack - global_vars.get_current_time() < 0 and next_primary_attack - global_vars.get_current_time() < 0
end
