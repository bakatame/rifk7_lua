local print = function (text) general.log_to_console(tostring(text)) end

local temp = menu_antiaim.get_edge_yaw()

local enable = menu.add_keybind("Edge yaw on key", 0, 0, 0)

hooks.add_callback("on_draw", function ()

    local local_player = engine.get_local_player()
	if not local_player or not engine.is_ingame() and not engine.is_connected() or local_player:get_netvar_int("m_lifeState") ~= 0 then return end
    
    menu_antiaim.set_edge_yaw(menu.get(enable):get_keybind_mode() ~= 3 and menu.get(enable):is_keybind_active())

end)

hooks.add_lua_unload_callback(function ()
    menu_antiaim.set_edge_yaw(temp)
end)
