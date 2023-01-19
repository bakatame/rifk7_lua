local enable = menu.add_checkbox("Enable Dt_speed changer", false)
local ticks = menu.add_slider("ticks", 16, 4, 20)

hooks.add_hook("on_createmove", function (cmd)
    
    local ticks = math.floor(menu.get(ticks):get_float())
    local enable = menu.get(enable):get_bool()
    local exploit = menu_ragebot.get_double_tap_key() and not menu_ragebot.get_fake_duck()

    general.get_convar("sv_maxusrcmdprocessticks"):set_int((enable and exploit) and ticks or 16)
    general.get_convar("cl_clock_correction"):set_int((enable and exploit) and 0 or 1)

end)
