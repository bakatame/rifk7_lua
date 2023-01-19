
local print = function (text) general.log_to_console(tostring(text)) end

local enable = menu.add_keybind("Fake ping key", 0, 0, 0)
local value = menu.add_slider("Fake ping value", 0, 0, 200)

hooks.add_callback("on_draw", function ()

    local local_player = engine.get_local_player()
    if not local_player or not engine.is_ingame() and not engine.is_connected() or local_player:get_netvar_int("m_lifeState") ~= 0 or menu.get(enable):get_keybind_mode() == 3 or not menu.get(enable):is_keybind_active() then return end
    
    local ping = player_resource.get_netvar_int(local_player:get_index(), "m_iPing")
    local text = "Fake Ping: " .. ping

    renderer.draw_text(5, renderer.get_center().y + 15, text, 255, 255, 255, 255, font_flags.drop_shadow); 

    menu_ragebot.set_fakeping(menu.get(value):get_float() >= ping)
    
end)
