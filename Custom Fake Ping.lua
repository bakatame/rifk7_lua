menu.add_keybind("Fake ping key", 0, 0, 1)
menu.add_slider("Fake ping value", 0, 0, 200)
hooks.add_hook("on_draw", function ()

    local local_player = engine.get_local_player()
	  if not local_player or not engine.is_ingame() and not engine.is_connected() or local_player:get_netvar_int("m_lifeState") ~= 0 or not menu.get_keybind("Fake ping key") then return end
    
    local ping = player_resource.get_netvar_int(local_player:get_index(), "m_iPing")
    menu_ragebot.set_fakeping(menu.get_slider("Fake ping value") >= ping)
    
end)
