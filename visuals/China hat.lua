-- Thanks Smiley!!! > <
local enable_hat = menu.add_checkbox("Enable China hat", false)
local color_hat = menu.add_colorpicker("Hat Color", 255, 255, 255, 255, false)
local rgb_hat = menu.add_checkbox("Hat RGB", false)
local size_hat = menu.add_slider("Hat Size", 12, 1, 20)
local extra_z_hat = menu.add_slider("Hat Position Z", 1, 0, 20)
local height_hat = menu.add_slider("Hat Height", 7, 0, 20)

local print = function (...) local text = "" if type(text) == "table" then for index, value in ipairs(...) do text = tostring(value) .. ", " end else text = tostring(...) end general.log_to_console(text) end

local chinahat = {}
chinahat.func = {}

chinahat.lib = {

    vector = function (x, y ,z)
        return (function ()
            local vector_table = {}
            vector_table.__index = vector_table
            
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

    rgb = function()
        local r = math.floor(math.sin(global_vars.get_real_time() * 4) * 90 + 165)
        local g = math.floor(math.sin(global_vars.get_real_time() * 4 + 2) * 90 + 165)
        local b = math.floor(math.sin(global_vars.get_real_time() * 4 + 4) * 90 + 165)
        return chinahat.lib.color(r, g, b, 255)
    end,

}

chinahat.func.on_draw = function ()

    if not menu.get(enable_hat):get_bool() then return end

    local local_player = engine.get_local_player()
	if not local_player or not engine.is_ingame() and not engine.is_connected() or engine.get_local_player():get_netvar_int("m_lifeState") ~= 0 then return end

    if not input.is_cam_in_thirdperson() then return end

    local real_color
    local rgb = chinahat.lib.rgb()
    local accent = menu.get(color_hat):get_color()
    local size = menu.get(size_hat):get_float()
    local extra_z = menu.get(extra_z_hat):get_float()

    local headpos = esp_info.get_hitbox_position(local_player:get_index(), hitbox.head)

    local high_pos = chinahat.lib.vector(headpos.x, headpos.y, headpos.z + menu.get(height_hat):get_float())
    local w2s = high_pos:to_screen()
    
    if menu.get(rgb_hat):get_bool() then
        real_color = chinahat.lib.color(rgb.r, rgb.g, rgb.b, 255)
    else
        real_color = chinahat.lib.color(accent)
    end

    if w2s then

        for i = 1, 360, 1 do

            local current_head_position = chinahat.lib.vector(headpos.x + math.sin(math.rad(i)) * size, headpos.y + math.cos(math.rad(i)) * size, headpos.z + extra_z)
            local current_position_w2s = current_head_position:to_screen()

            local old_position = chinahat.lib.vector(headpos.x + math.sin(math.rad(i - 1)) * size, headpos.y + math.cos(math.rad(i - 1)) * size, headpos.z + extra_z)
            local old_position_w2s = old_position:to_screen()

            renderer.draw_line(current_position_w2s.x, current_position_w2s.y, old_position_w2s.x, old_position_w2s.y, real_color.r, real_color.g, real_color.b, real_color.a, 1)
            renderer.draw_line(current_position_w2s.x, current_position_w2s.y, w2s.x, w2s.y, real_color.r, real_color.g, real_color.b, real_color.a, 1)

        end

    end

end

hooks.add_callback("on_draw", chinahat.func.on_draw)