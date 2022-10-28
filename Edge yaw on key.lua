local print = function (text) general.log_to_console(tostring(text)) end

local temp = menu_antiaim.get_edge_yaw()

menu.add_keybind("Edge yaw on key", 0, 0, 0)

hooks.add_hook("on_draw", function ()

    local local_player = engine.get_local_player()
	if not local_player or not engine.is_ingame() and not engine.is_connected() or local_player:get_netvar_int("m_lifeState") ~= 0 then return end
    
    menu_antiaim.set_edge_yaw(menu.get_keybind_mode("Edge yaw on key") ~= 3 and menu.get_keybind("Edge yaw on key"))

end)

hooks.on_lua_unload(function ()
    menu_antiaim.set_edge_yaw(temp)
end)
