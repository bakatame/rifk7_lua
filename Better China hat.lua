local print = function (...) local text = "" if type(text) == "table" then for index, value in ipairs(...) do text = tostring(value) .. ", " end else text = tostring(...) end general.log_to_console(text) end

local chinahat = {}
chinahat.func = {}

chinahat.lib = {

    vector = function (x, y ,z)
        return (function ()

            local vector_table = {}
            vector_table.__index = vector_table

            vector_table.__add = function (a, b)

                local x = a.x + b.x
                local y = a.y + b.y
                local z = a.z + b.z
                return vector_table.new(x, y, z)

            end
        
            vector_table.__sub = function (a, b)

                local x = a.x - b.x
                local y = a.y - b.y
                local z = a.z - b.z
                return vector_table.new(x, y, z)

            end

            vector_table.__mul = function (a, b)
                local x = a.x * b.x
                local y = a.y * b.y
                local z = a.z * b.z
                return vector_table.new(x, y, z)
            end
    
            vector_table.__div = function (a, b)

                local x = a.x / b.x
                local y = a.y / b.y
                local z = a.z / b.z
                return vector_table.new(x, y, z)

            end
    
            function vector_table:set(x, y, z)
    
                if not z then
                    z = 0
                end
    
                self.x = x
                self.y = y
                self.z = z
    
            end
    
            function vector_table:get()
        
                return {
                    x = self.x,
                    y = self.y,
                    z = self.z
                }
    
            end
            
            function vector_table:unpack()
                return self.x, self.y, self.z
            end
    
            function vector_table:to_screen()
                local vector_to_screen = renderer.get_world_to_screen(self.x, self.y, self.z)
                return {
                    x = vector_to_screen.x,
                    y = vector_to_screen.y,
                }
            end
    
            function vector_table.new(x, y, z)
    
                if not z then
                    z = 0
                end
    
                return setmetatable({
                    x = x,
                    y = y,
                    z = z,
                }, vector_table)
    
            end
    
            return vector_table
            
        end)().new(x, y ,z)
    end,

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

    hsv_to_rgb = function (h, s, v)
        local r, g, b

        local i = math.floor(h * 6);
        local f = h * 6 - i;
        local p = v * (1 - s);
        local q = v * (1 - f * s);
        local t = v * (1 - (1 - f) * s);

        i = i % 6

        if i == 0 then r, g, b = v, t, p
        elseif i == 1 then r, g, b = q, v, p
        elseif i == 2 then r, g, b = p, v, t
        elseif i == 3 then r, g, b = p, q, v
        elseif i == 4 then r, g, b = t, p, v
        elseif i == 5 then r, g, b = v, p, q
        end
        
        return chinahat.lib.color(r * 255, g * 255, b * 255, 255)
    end,

    renderer_triangle = function(v2_A, v2_B, v2_C, r, g, b, a)
        local function i(j,k,l)
            local m=(k.y-j.y)*(l.x-k.x)-(k.x-j.x)*(l.y-k.y)
            if m<0 then return true end
            return false
        end
        if i(v2_A,v2_B,v2_C) then renderer.draw_triangle_filled(v2_A.x,v2_A.y,v2_B.x,v2_B.y,v2_C.x,v2_C.y,r,g,b,a)
        elseif i(v2_A,v2_C,v2_B) then renderer.draw_triangle_filled(v2_A.x,v2_A.y,v2_C.x,v2_C.y,v2_B.x,v2_B.y,r,g,b,a)
        elseif i(v2_B,v2_C,v2_A) then renderer.draw_triangle_filled(v2_B.x,v2_B.y,v2_C.x,v2_C.y,v2_A.x,v2_A.y,r,g,b,a)
        elseif i(v2_B,v2_A,v2_C) then renderer.draw_triangle_filled(v2_B.x,v2_B.y,v2_A.x,v2_A.y,v2_C.x,v2_C.y,r,g,b,a)
        elseif i(v2_C,v2_A,v2_B) then renderer.draw_triangle_filled(v2_C.x,v2_C.y,v2_A.x,v2_A.y,v2_B.x,v2_B.y,r,g,b,a)
        else renderer.draw_triangle_filled(v2_C.x,v2_C.y,v2_B.x,v2_B.y,v2_A.x,v2_A.y,r,g,b,a)end
    end,
    
}

chinahat.menu = function ()
    menu.add_checkbox("Enable China hat", false)
    menu.add_colorpicker("Hat Color", 0, 255, 255, 255, false)
    menu.add_checkbox("Hat Gradient", false)
    menu.add_slider("Hat Color Speed", 5, 1, 10)
end chinahat.menu()

chinahat.func.on_draw = function ()
    
    if not menu.get_checkbox("Enable China hat") then return end
    
    local local_player = engine.get_local_player()
	if not local_player or not engine.is_ingame() and not engine.is_connected() or engine.get_local_player():get_netvar_int("m_lifeState") ~= 0 then return end

    if not input.is_cam_in_thirdperson() then return end
    
    local headpos = esp_info.get_hitbox_position(local_player:get_index(), hitbox.head)
    if not headpos.x then return end
    local origin = chinahat.lib.vector(headpos.x, headpos.y, headpos.z)
    if not origin.x then return end

    local size = 10
    local last_point = nil

    local gradient_g = menu.get_checkbox("Hat Gradient")
    local color_g = chinahat.lib.color(menu.get_colorpicker("Hat Color"))
    local speed_g = menu.get_slider("Hat Color Speed")

    for i = 0, 360, 5 do

        local new_point = chinahat.lib.vector( --Rotate point
            origin.x - (math.sin(math.rad(i)) * size),
            origin.y - (math.cos(math.rad(i)) * size),
            origin.z
        )

        if (gradient_g) then
            local hue_offset = 0

            hue_offset = ((global_vars.get_real_time() * (speed_g * 50)) + i) % 360
            hue_offset = math.min(360, math.max(0, hue_offset))

            local r, g, b = chinahat.lib.hsv_to_rgb(hue_offset / 360, 1, 1)

            color_g:set(r, g, b, 255)
        end

        if last_point ~= nil then

            local old_screen_point = last_point:to_screen()
            local new_screen_point = new_point:to_screen()
            local new_origin = origin + chinahat.lib.vector(0, 0, 8)
            local origin_screen_point = new_origin:to_screen()

            if old_screen_point.x ~= nil and new_screen_point.x ~= nil and origin_screen_point.x ~= nil then
                chinahat.lib.renderer_triangle(old_screen_point, new_screen_point , origin_screen_point, color_g.r, color_g.g, color_g.b, 50)     
                renderer.draw_line(old_screen_point.x, old_screen_point.y, new_screen_point.x, new_screen_point.y, color_g.r, color_g.g, color_g.b, 255, 1)
            end

        end

        last_point = new_point
    end

end

hooks.add_hook("on_draw", chinahat.func.on_draw)
