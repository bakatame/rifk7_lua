-- A gift for SkuLz
-- (Forum Emoji) :uidissue:

local print = function (...) local text = "" if type(text) == "table" then for index, value in ipairs(...) do text = tostring(value) .. ", " end else text = tostring(...) end general.log_to_console(text) end

local skulz = {}

skulz.lib = {
    color = function (color_r, color_g, color_b, color_a)

        return (function ()
            local color_function = {};
            color_function.__index = color_function;
        
            function color_function:get()
                return {
                    r = self.r,
                    g = self.g,
                    b = self.b,
                    a = self.a
                }
            end
        
            function color_function:unpack()
                return self.r, self.g, self.b, self.a
            end
        
            function color_function:set(color, color_2, color_3, color_4)
        
                local color_r, color_g, color_b, color_a
                if type(color) == "userdata" then
                    color_r, color_g, color_b, color_a = color:r(), color:g(), color:b(), color:a()
                elseif type(color) == "table" then
                    if color.r ~= nil then
                        color_r, color_g, color_b, color_a = color.r, color.g, color.b, color.a
                    else
                        color_r, color_g, color_b, color_a = color[1], color[2], color[3], color[4]
                    end
                elseif type(color) == "number" then
                    color_r, color_g, color_b, color_a = color, color_2, color_3, color_4
                else
                    return
                end
        
                self.r = color_r;
                self.g = color_g;
                self.b = color_b;
                self.a = color_a;
    
            end
        
            function color_function.new(color_r, color_g, color_b, color_a)
    
                if type(color_r) == "userdata" then
                    color_r, color_g, color_b, color_a = color_r:r(), color_r:g(), color_r:b(), color_r:a()
                elseif type(color_r) == "table" then
                    if color_r.r ~= nil then
                        color_r, color_g, color_b, color_a = color_r.r, color_r.g, color_r.b, color_r.a
                    else
                        color_r, color_g, color_b, color_a = color_r[1], color_r[2], color_r[3], color_r[4]
                    end
                elseif type(color_r) == "number" then
                    color_r, color_g, color_b, color_a = color_r, color_g, color_b, color_a
                else
                    return
                end
    
                return setmetatable({
                    r = color_r,
                    g = color_g,
                    b = color_b,
                    a = color_a,
                 }, color_function)
            end
    
            return color_function
    
        end)().new(color_r, color_g, color_b, color_a)
    
    end,
    
    pulse_alpha = function ()
        local time = -math.pi + (global_vars.get_current_time() * 1.5)
        local abs = math.abs(time % (math.pi * 1.5))
        return math.sin(abs)
    end,

    lerp = function(start, target, time, center_delta)
        if (math.abs(start - target) < (center_delta or 0.01)) then
	        return target
        end
        
        local m_time = math.min(math.max(0.01, global_vars.get_frame_time() * (time * 175)), 1)
        return ((target - start) * m_time + start)
    end,

    get_weapon_index = function ()
        local local_player = engine.get_local_player()
        if not local_player or not engine.is_ingame() or not engine.is_connected() or local_player:get_netvar_int("m_lifeState") ~= 0 then return 5 end

        local weapon = local_player:get_active_weapon()
        if not weapon then return 5 end

        local weapon_class = weapon:get_class_id()
        if not weapon_class then return 5 end

        if weapon_class == 261 or weapon_class == 242 then
            return 0
        elseif weapon_class == 267 then
            return 1
        elseif weapon_class == 233 then
            return 2
        elseif weapon_class == 245 or weapon_class == 239 or weapon_class == 258 or weapon_class == 269 or weapon_class == 246 or weapon_class == 241 then
            return 3
        elseif weapon_class == 46 then
            return 4
        else
            return 5
        end
    end

}

skulz.data = {
    name = "SkuLz.lua",
    rank = "Beta",
    ind_alpha = 0,
    old_x = 0,
    call_table = {
        [1] = {
            text = "DT",
            pos = {x = 0, y = 0},
            keybinds = function ()
                return menu_ragebot.get_double_tap_key()
            end,
            color = function ()
                return ragebot.is_charged() and skulz.lib.color(102, 204, 51, 255) or skulz.lib.color(179, 0, 0, 255)
            end
        },
        [2] = {
            text = "DMG",
            pos = {x = 0, y = 0},
            keybinds = function () 
                return menu_ragebot.get_damage_override()
            end,
            color = function ()
                return skulz.lib.color(255, 178, 179, 255)
            end
        },
        [3] = {
            text = "BAIM",
            pos = {x = 0, y = 0},
            keybinds = function () 
                return menu_ragebot.get_force_baim()
            end,
            color = function ()
                return skulz.lib.color(135, 185, 170, 255)
            end
        },
        [4] = {
            text = "DUCK",
            pos = {x = 0, y = 0},
            keybinds = function () 
                return ragebot.is_fakeducking()
            end,
            color = function ()
                return skulz.lib.color(255, 204, 255, 255)
            end
        },
    }

}

skulz.screen_center = renderer.get_center()

skulz.menu = function ()

    menu.add_slider("Arrow interval", 50, 1, 300)
    menu.add_slider("Desync box height", 2, 1, 10)
    menu.add_colorpicker("Logo_Color", 255, 255, 255, 255, false)
    menu.add_text("Logo Color")
    menu.add_colorpicker("Rank_Color", 65, 190, 59, 255, false)
    menu.add_text("Rank Color")
    menu.add_colorpicker("Fake_yaw_arrow_Color", 255, 255, 255, 255, false)
    menu.add_text("Fake yaw arrow Color")
    menu.add_colorpicker("Real_yaw_arrow_Color", 42, 42, 42, 255, false)
    menu.add_text("Real yaw arrow Color")
    menu.add_colorpicker("Desync_box_Color", 255, 255, 255, 255, false)
    menu.add_text("Desync box Color")
    
end skulz.menu()

local render = {
    draw_text = function (x, y, text, flags, color, color_2, color_3, color_4)
        local color_r, color_g, color_b, color_a
                
        if type(color) == "table" then
            if color.r ~= nil then
                color_r, color_g, color_b, color_a = color.r, color.g, color.b, color.a
            else
                color_r, color_g, color_b, color_a = color[1], color[2], color[3], color[4]
            end
        elseif type(color) == "number" then
            color_r, color_g, color_b, color_a = color, color_2, color_3, color_4
        else
            return
        end
        
        renderer.draw_text(x, y, tostring(text), color_r, color_g, color_b, color_a, flags); 
    end,

    draw_triangle_filled = function (x1, y1, x2, y2, x3, y3, color, color_2, color_3, color_4)
        
        local color_r, color_g, color_b, color_a
                
        if type(color) == "table" then
            if color.r ~= nil then
                color_r, color_g, color_b, color_a = color.r, color.g, color.b, color.a
            else
                color_r, color_g, color_b, color_a = color[1], color[2], color[3], color[4]
            end
        elseif type(color) == "number" then
            color_r, color_g, color_b, color_a = color, color_2, color_3, color_4
        else
            return
        end

        renderer.draw_triangle_filled(x1, y1, x2, y2, x3, y3, color_r, color_g, color_b, color_a)

    end
}

hooks.add_hook("on_draw", function()

    local local_player = engine.get_local_player()
	if not local_player or not engine.is_ingame() and not engine.is_connected() or local_player:get_netvar_int("m_lifeState") ~= 0 then return end

    local lp_bodyyaw = (math.floor(math.min(60, (local_player:get_pose_parameter(poses.body_yaw) * 120 - 60)))) > 0

    local logo_color = skulz.lib.color(menu.get_colorpicker("Logo_Color"))
    local rank_color = skulz.lib.color(menu.get_colorpicker("Rank_Color"))
    local fake_color = skulz.lib.color(menu.get_colorpicker("Fake_yaw_arrow_Color"))
    local real_color = skulz.lib.color(menu.get_colorpicker("Real_yaw_arrow_Color"))
    local desync_box_color = skulz.lib.color(menu.get_colorpicker("Desync_box_Color"))
    local pulse_rank_color = skulz.lib.color(rank_color.r, rank_color.g, rank_color.b, skulz.lib.pulse_alpha() * 255)
    local arrow_interval = menu.get_slider("Arrow interval")
    local box_height = menu.get_slider("Desync box height")
    local left_color = lp_bodyyaw and fake_color or real_color
    local right_color = not lp_bodyyaw and fake_color or real_color
    local get_name_size = renderer.get_text_size(skulz.data.name.." [" .. skulz.data.rank .. "]")

    local base_y = 35
    local y_offset = -9
    
    render.draw_text(skulz.screen_center.x - get_name_size.x / 4, skulz.screen_center.y + 25, skulz.data.name, font_flags.centered_x, logo_color)
    render.draw_text(skulz.screen_center.x + get_name_size.x / 4, skulz.screen_center.y + 25, " [" .. skulz.data.rank .. "]", font_flags.centered_x, pulse_rank_color)
    
    renderer.draw_rectangle_multicolored(
        skulz.screen_center.x, skulz.screen_center.y + 35 + get_name_size.y, 
        antiaim.get_last_desync_amount() * 0.9, box_height,
        desync_box_color.r, desync_box_color.g, desync_box_color.b, 255,
        desync_box_color.r, desync_box_color.g, desync_box_color.b, 0,
        true
    )
    renderer.draw_rectangle_multicolored(
        skulz.screen_center.x, skulz.screen_center.y + 35 + get_name_size.y, 
        -antiaim.get_last_desync_amount() * 0.9, box_height,
        desync_box_color.r, desync_box_color.g, desync_box_color.b, 255,
        desync_box_color.r, desync_box_color.g, desync_box_color.b, 0,
        true
    )

    render.draw_triangle_filled(
        skulz.screen_center.x - arrow_interval - 10, skulz.screen_center.y - 8,
        skulz.screen_center.x - arrow_interval - 10, skulz.screen_center.y + 8,
        skulz.screen_center.x - arrow_interval - 25, skulz.screen_center.y,
        left_color
    )

    render.draw_triangle_filled(
        skulz.screen_center.x + arrow_interval + 10, skulz.screen_center.y - 7,
        skulz.screen_center.x + arrow_interval + 10, skulz.screen_center.y + 7,
        skulz.screen_center.x + arrow_interval + 24, skulz.screen_center.y,
        right_color
    )

    local list = skulz.data.call_table

    for i = 1, #list do

        if list[i].keybinds() then
            list[i].pos.y = 15
            list[i].pos.x = skulz.lib.lerp(list[i].pos.x, 1, 0.095, 0.05)
        else
            list[i].pos.x = skulz.lib.lerp(list[i].pos.x, 0 ,0.095, 0.05)
            list[i].pos.y = list[i].pos.x == 0 and 0 or 15
        end

        y_offset = y_offset + list[i].pos.y
        if list[i].pos.x > 0 then
            local col = skulz.lib.color(list[i].color().r, list[i].color().g, list[i].color().b , list[i].color().a * list[i].pos.x)
            render.draw_text(skulz.screen_center.x + skulz.data.old_x, skulz.screen_center.y + base_y + list[i].pos.y + y_offset, list[i].text, font_flags.centered_x, col)
        end
    end

end)
