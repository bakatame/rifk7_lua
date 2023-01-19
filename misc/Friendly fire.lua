local enable = menu.add_checkbox("Enable Friendly fire", false)

local cache = false
local mp_teammates_are_enemies = general.get_convar("mp_teammates_are_enemies")

hooks.add_callback("on_draw", function ()

    local local_player = engine.get_local_player()
	if not local_player or not engine.is_ingame() and not engine.is_connected() or engine.get_local_player():get_netvar_int("m_lifeState") ~= 0 then return end

    if cache == menu.get(enable):get_bool() then return end

    mp_teammates_are_enemies:set_int(menu.get(enable):get_bool() and 1 or 0)
    cache = menu.get(enable):get_bool()

end)

hooks.add_lua_unload_callback(function ()
    mp_teammates_are_enemies:set_int(0)
end)
