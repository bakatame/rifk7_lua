local print = function (text) general.log_to_console(tostring(text)) end

local scope_line = {}

scope_line.screen_side = {
    x = renderer.get_center().x,
    y = renderer.get_center().y,
}

scope_line.lib = {

    clamp = function(var, min, max)
        return math.min(math.max(min, var), max)
    end,

    lerp = function(start, vend, time)
        return start + (vend - start) * time
    end,

    lerp2 = function(start, target, time, center_delta)
        if (math.abs(start - target) < (center_delta or 0.01)) then
	        return target
        end

        local m_time = scope_line.lib.clamp(global_vars.get_frame_time() * (time * 175), 0.01, 1)
        return ((target - start) * m_time + start)
    end,

}

scope_line.data = {
    scale = 0,
    alpha = 0,
    offset = 0,
    position = 0,
    background_alpha = 0
}

scope_line.menu = function ()
    menu.add_checkbox("Custom Scope Lines", false)
    menu.add_colorpicker("Color", 255, 255, 255, 255, false)
    menu.add_checkbox("Fade Switch", false)
    menu.add_slider("Size", 320, 0, scope_line.screen_side.x)
    menu.add_slider("Position", 80, 0, scope_line.screen_side.x)
    menu.add_slider("Scale", 1, 1, 20)
    menu.add_slider("Animation Smooth", 30, 0, 100)
end scope_line.menu()

scope_line.menu_setting = function ()

    if not menu.is_visible() then return end

    menu.override_visibility("Custom Scope Lines", true)
    menu.override_visibility("Color", menu.get_checkbox("Custom Scope Lines"))
    menu.override_visibility("Fade Switch", menu.get_checkbox("Custom Scope Lines"))
    menu.override_visibility("Size", menu.get_checkbox("Custom Scope Lines"))
    menu.override_visibility("Position", menu.get_checkbox("Custom Scope Lines"))
    menu.override_visibility("Scale", menu.get_checkbox("Custom Scope Lines"))
    menu.override_visibility("Animation Smooth", menu.get_checkbox("Custom Scope Lines"))

end

scope_line.on_draw = function ()


    local local_player = engine.get_local_player()
	if not local_player or not engine.is_ingame() and not engine.is_connected() or engine.get_local_player():get_netvar_int("m_lifeState") ~= 0 then return end

    local Is_Scoped = local_player:get_netvar_int("m_bIsScoped") ~= 0
    local enable = menu.get_checkbox("Custom Scope Lines")
    local animation_smooth = menu.get_slider("Animation Smooth")
    scope_line.data.scale = scope_line.lib.lerp2(scope_line.data.scale, (enable and Is_Scoped) and menu.get_slider("Scale") or 0, animation_smooth / 100)
    scope_line.data.offset = scope_line.lib.lerp2(scope_line.data.offset, (enable and Is_Scoped) and menu.get_slider("Size") or 0, animation_smooth / 100)
    scope_line.data.position = scope_line.lib.lerp2(scope_line.data.position, (enable and Is_Scoped) and menu.get_slider("Position") or 0, animation_smooth / 100)
    print(scope_line.data.scale)
    local scale = scope_line.data.scale
    local position = scope_line.data.position
    local offset = scope_line.data.offset

    local getcolor = menu.get_colorpicker("Color")

    local back_color = {
        r = getcolor:r(), 
        g = getcolor:g(), 
        b = getcolor:b(), 
        a = 0
    }

    local width, height = scope_line.screen_side.x, scope_line.screen_side.y
    local frametime = (global_vars.get_frame_time() * (animation_smooth / 10))

    scope_line.data.alpha = scope_line.lib.lerp(scope_line.data.alpha, getcolor:a(), frametime)
    local internal_color = {
        r = getcolor:r(), 
        g = getcolor:g(), 
        b = getcolor:b(), 
        a = scope_line.data.alpha * 255
    }

    scope_line.data.background_alpha = scope_line.lib.lerp2(scope_line.data.background_alpha, back_color.a, frametime)
    local internal_back_color = {
        r = back_color.r, 
        g = back_color.g, 
        b = back_color.b, 
        a = scope_line.data.background_alpha * 255
    }

    if menu.get_checkbox("Fade Switch") then

        renderer.draw_rectangle_multicolored(
            width + 2 + position, 
            height + 1 - (scale / 2), 
            offset, 
            scale, 
            internal_back_color.r, internal_back_color.g, internal_back_color.b, internal_back_color.a, internal_color.r, internal_color.g, internal_color.b, internal_color.a, 
            true
        )

        renderer.draw_rectangle_multicolored(
            width - position, 
            height + 1 - (scale / 2), 
            -offset, 
            scale, 
            internal_back_color.r, internal_back_color.g, internal_back_color.b, internal_back_color.a, internal_color.r, internal_color.g, internal_color.b, internal_color.a, 
            true
        )

        renderer.draw_rectangle_multicolored(
            width + 1 - (scale / 2), 
            height + position, 
            scale, 
            offset, 
            internal_back_color.r, internal_back_color.g, internal_back_color.b, internal_back_color.a, internal_color.r, internal_color.g, internal_color.b, internal_color.a, 
            false
        )

        renderer.draw_rectangle_multicolored(
            width + 1 - (scale / 2), 
            height - position - 2, 
            scale, 
            -offset, 
            internal_back_color.r, internal_back_color.g, internal_back_color.b, internal_back_color.a, internal_color.r, internal_color.g, internal_color.b, internal_color.a, 
            false
        )

    else

        renderer.draw_rectangle_multicolored(
            width + 2 + position, 
            height + 1 - (scale / 2), 
            offset, 
            scale, 
            internal_color.r, internal_color.g, internal_color.b, internal_color.a, internal_back_color.r, internal_back_color.g, internal_back_color.b, internal_back_color.a,
            true
        )

        renderer.draw_rectangle_multicolored(
            width - position, 
            height + 1 - (scale / 2), 
            -offset, 
            scale, 
            internal_color.r, internal_color.g, internal_color.b, internal_color.a, internal_back_color.r, internal_back_color.g, internal_back_color.b, internal_back_color.a,
            true
        )

        renderer.draw_rectangle_multicolored(
            width + 1 - (scale / 2), 
            height + position, 
            scale, 
            offset, 
            internal_color.r, internal_color.g, internal_color.b, internal_color.a, internal_back_color.r, internal_back_color.g, internal_back_color.b, internal_back_color.a,
            false
        )

        renderer.draw_rectangle_multicolored(
            width + 1 - (scale / 2), 
            height - position - 2, 
            scale, 
            -offset, 
            internal_color.r, internal_color.g, internal_color.b, internal_color.a, internal_back_color.r, internal_back_color.g, internal_back_color.b, internal_back_color.a,
            false
        )

    end

end

local callback_table = {
	["on_paint"] = scope_line.menu_setting,
	["on_draw"] = scope_line.on_draw,

}

for key, value in pairs(callback_table) do
	hooks.add_hook(key, value);
end
