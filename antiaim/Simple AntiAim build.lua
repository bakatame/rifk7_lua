local print = general.log_to_console

local script = {}

script.cache = {
	pitch = menu_antiaim.get_pitch(),
	viewangles = menu_antiaim.get_viewangles(),
	max_fov = menu_antiaim.get_max_fov(),
	yaw_offset = menu_antiaim.get_yaw_offset(),
	fake_mode = menu_antiaim.get_fake_mode(),
	fake_min = menu_antiaim.get_fake_min(),
	fake_max = menu_antiaim.get_fake_max(),
	real_mode = menu_antiaim.get_real_mode(),
	desync = menu_antiaim.get_desync(),
	real_min = menu_antiaim.get_real_min(),
	real_max = menu_antiaim.get_real_max() ,
	jitter_delay = menu_antiaim.get_jitter_delay(),
}

script.menu_table = {
	
	mode = {
		"Default",
		"Standing",
		"Slow motion",
		"Moving",
		"Air",
		"Crouching",
		"Courch Air",
	},

	pitch = {
		"Down",
		"Minimal",
		"Jitter",
		"Default"
	},

	viewangles = {
		"View",
		"At-Target Distance",
		"At-Target FOV",
		"At-Target Mix",
		"At-Target 1 Target",
		"Freestanding Fake",
		"Freestanding Real",
	},

	jitter_mode = {
		"Static",
		"Jitter Side",
		"Random Jitter Side",
		"Jitter Center",
		"Random Jitter Center"
	}

}

script.lib = {

    menu = (function ()
        local combo_text = function (...)
    
            if not ... then return; end
            local check_type = type(...) == "table" and ... or {...};
        
            if #check_type == 0 then return; end
        
            local out_text = "";
            for index, value in ipairs(check_type) do
                out_text = out_text .. value .. "\0";
            end
        
            out_text = out_text .. "\0";
            return out_text;
        end
        
        local menu_lib = {}
        menu_lib.__index = menu_lib
        
        function menu_lib:visible(bool)
            if not self or not self.value then return; end
            
            if bool then
                menu.get(self.value):set_visible()
            else
                menu.get(self.value):set_invisible()
            end
        end
        
        function menu_lib:get(value)
                
            if not self or not self.type or not self.value then return; end
            local menu_get_item = menu.get(self.value)
        
            if self.type == "text" or self.type == "text_input" then
                return menu_get_item:get_name();
            elseif self.type == "slider" then
                return menu_get_item:get_float();
            elseif self.type == "combo" then
                return menu_get_item:get_int();
            elseif self.type == "checkbox" then
                return menu_get_item:get_bool();
            elseif self.type == "keybind" then
                if value == "button" then
                    return menu_get_item:get_keybind_button();
                elseif value == "mode" then
                    return menu_get_item:get_keybind_mode();
                end
                return menu_get_item:is_keybind_active();
            elseif self.type == "flex_checkbox" then
                if value == "button" then
                    return menu_get_item:get_flex_checkbox_button();
                elseif value == "mode" then
                    return menu_get_item:get_flex_checkbox_mode();
                end
                return menu_get_item:is_flex_checkbox_active();
            elseif self.type == "colorpicker" or self.type == "second_colorpicker" then
                return menu_get_item:get_color();
            elseif self.type == "multiselection" then
                return menu_get_item:get_multiselection_item(value);
            end
        
        end
        
        function menu_lib:set(value1, value2, value3, value4)
            
            if not self or not self.type or not self.value then return; end
            if self.type == "separator" then return; end
        
            local menu_get_item = menu.get(self.value)
        
            if self.type == "text" or self.type == "text_input" then
                return menu_get_item:set_name(value1);
            elseif self.type == "slider" then
                return menu_get_item:set_float(value1);
            elseif self.type == "combo" then
                return menu_get_item:set_int(value1);
			elseif self.type == "checkbox" then
                return menu_get_item:set_bool(value1);
            elseif self.type == "keybind" then
                if value1 == "button" then
                    return menu_get_item:set_keybind_button(value2);
                elseif value1 == "mode" then
                    return menu_get_item:set_keybind_mode(value2);
                end
                return menu_get_item:is_keybind_active();
            elseif self.type == "flex_checkbox" then
                if value1 == "button" then
                    return menu_get_item:set_flex_checkbox_button(value2);
                elseif value1 == "mode" then
                    return menu_get_item:set_flex_checkbox_mode(value2);
                end
                return menu_get_item:is_flex_checkbox_active();
            elseif self.type == "colorpicker" or self.type == "second_colorpicker" then
                return menu_get_item:set_color(value1, value2, value3, value4);
            elseif self.type == "multiselection" then
                return menu_get_item:set_multiselection_item(value1, value2);
            end
        
        end
        
        function menu_lib.separator(menu_name)
        
            if not menu_name or type(menu_name) ~= "string" then
                return;
            end
        
            local menu_item = menu.add_separator(menu_name);
        
            return setmetatable({
                type = "separator",
                value = menu_item
            },menu_lib);
        
        end
        
        function menu_lib.text(menu_name, default_value)
            
            if not menu_name or type(menu_name) ~= "string" then
                return;
            end
        
            local menu_item = menu.add_text(menu_name);
            if default_value then
                menu.get(menu_item):set_name(default_value);
            end
        
            return setmetatable({
                type = "text",
                value = menu_item,
            },menu_lib);
        
        end
        
        function menu_lib.slider(menu_name, default_value, min_value, max_value)
            
            if not menu_name or type(menu_name) ~= "string" then
                return;
            end
        
            if not default_value or type(default_value) ~= "number" then 
                default_value = 0;
            end
        
            if not min_value or type(min_value) ~= "number" then 
                min_value = 0;
            end
        
            if not max_value or type(max_value) ~= "number" then 
                max_value = 0;
            end
        
            local menu_item = menu.add_slider(menu_name, default_value, min_value, max_value);
        
            return setmetatable({
                type = "slider",
                value = menu_item,
            },menu_lib);
        
        end
        
        function menu_lib.keybind(menu_name, default_button, mode, keybind_options)
                
            if not menu_name or type(menu_name) ~= "string" then
                return;
            end
        
            if not default_button or type(default_button) ~= "number" then default_button = 0; end
            if not mode or type(mode) ~= "number" then mode = 0; end
            if not keybind_options or type(keybind_options) ~= "number" then keybind_options = 0; end
        
            local menu_item = menu.add_keybind(menu_name, default_button, mode, keybind_options);
        
            return setmetatable({
                type = "keybind",
                value = menu_item,
            },menu_lib);
        
        end
        
        function menu_lib.checkbox(menu_name, default_value)
        
            if not menu_name or type(menu_name) ~= "string" then
                return;
            end
        
            if not default_value or type(default_value) ~= "boolean" then 
                default_value = false;
            end
        
            local menu_item = menu.add_checkbox(menu_name, default_value)
        
            return setmetatable({
                type = "checkbox",
                value = menu_item,
            }, menu_lib);
        
        end
        
        function menu_lib.combo(menu_name, default_value, combo_table)
            
            if not menu_name or type(menu_name) ~= "string" then
                return;
            end
        
            if not default_value or type(default_value) ~= "number" then
                default_value = 0;
            end
        
            if not combo_table or type(combo_table) ~= "table" then
                return;
            end
        
            local menu_item = menu.add_combo(menu_name, default_value, combo_text(combo_table));
        
            return setmetatable({
                type = "combo",
                value = menu_item,
            },menu_lib);
        
        end
        
        function menu_lib.flex_checkbox(menu_name, default_button, mode)
                
            if not menu_name or type(menu_name) ~= "string" then
                return;
            end
        
            if not default_button or type(default_button) ~= "number" then default_button = 0; end
            if not mode or type(mode) ~= "number" then mode = 0; end
        
            local menu_item = menu.add_flex_checkbox(menu_name, default_button, mode)
        
            return setmetatable({
                type = "flex_checkbox",
                value = menu_item,
            },menu_lib);
        
        end
        
        function menu_lib.colorpicker(menu_name, r, g, b, a, alpha_slider)
                
            if not menu_name or type(menu_name) ~= "string" then
                return;
            end
        
            if not r or type(r) ~= "number" then r = 255; end
            if not g or type(g) ~= "number" then g = 255; end
            if not b or type(b) ~= "number" then b = 255; end
            if not a or type(a) ~= "number" then a = 255; end
            if not alpha_slider or type(alpha_slider) ~= "boolean" then alpha_slider = false; end
        
            local menu_item = menu.add_colorpicker(menu_name, r, g, b, a, alpha_slider);
        
            return setmetatable({
                type = "colorpicker",
                value = menu_item,
            },menu_lib);
        
        end
        
        function menu_lib.second_colorpicker(menu_name, r, g, b, a, alpha_slider)
                
            if not menu_name or type(menu_name) ~= "string" then
                return;
            end
        
            if not r or type(r) ~= "number" then r = 255; end
            if not g or type(g) ~= "number" then g = 255; end
            if not b or type(b) ~= "number" then b = 255; end
            if not a or type(a) ~= "number" then a = 255; end
            if not alpha_slider or type(alpha_slider) ~= "boolean" then alpha_slider = false; end
        
            local menu_item = menu.add_second_colorpicker(menu_name, r, g, b, a, alpha_slider);
        
            return setmetatable({
                type = "second_colorpicker",
                value = menu_item,
            },menu_lib);
        
        end
        
        function menu_lib.multiselection(menu_name, combo_table)
                
            if not menu_name or type(menu_name) ~= "string" then
                return;
            end
        
            if not combo_table or type(combo_table) ~= "table" then 
                return;
            end
        
            local menu_item = menu.add_multiselection(menu_name, combo_text(combo_table));
        
            return setmetatable({
                type = "multiselection",
                value = menu_item,
            },menu_lib);
        
        end
        
        function menu_lib.text_input_box(menu_name, default_text)
                
            if not menu_name or type(menu_name) ~= "string" then
                return;
            end
        
            if not default_text or type(default_text ) ~= "string" then 
                default_text = "";
            end
        
            local menu_item = menu.add_text_input_box(menu_name, default_text);
        
            return setmetatable({
                type = "text_input",
                value = menu_item,
            },menu_lib);
        
        end
        
        function menu_lib.buttom(menu_name, buttom_function)
        
            if not menu_name or type(menu_name) ~= "string" then
                return;
            end
        
            if not buttom_function or type(buttom_function) ~= "function" then
                return;
            end
        
            local menu_item = menu.add_button_callback(menu_name, buttom_function);
        
            return setmetatable({
                type = "button",
                value = menu_item,
            },menu_lib);
        
        end
        
        return menu_lib
    end)(),

	round = function (number, precision)
	    local mult = 10 ^ (precision or 0)

	    return math.floor(number * mult + 0.5) / mult
    end,

	get_speed = function(player)

		local velocity = {
			x = player:get_netvar_float("m_vecVelocity[0]"),
			y = player:get_netvar_float("m_vecVelocity[1]"),
			z = player:get_netvar_float("m_vecVelocity[2]"),
		}

		local speed = math.floor(math.min(10000, math.sqrt(velocity.x ^ 2 + velocity.y ^ 2) + 0.5));
		return speed
	end,

	get_air = function (player)
		return player:get_netvar_float("m_vecVelocity[2]") ~= 0
	end,

	duck_amount = function (player)
		return player:get_netvar_float("m_flDuckAmount")
	end,

}

script.get_player_status = {
	standing = function (player)
		local velocity = script.lib.get_speed(player)
		return velocity <= 5
	end,

	running = function (player)
		local velocity = script.lib.get_speed(player)
		local get_air = script.lib.get_air(player)
		return velocity > 85 and not get_air
	end,

	slowwalk = function (player)
		local velocity = script.lib.get_speed(player)
		return velocity >= 6 and velocity <= 85
	end,

	inair = function (player)
		local get_air = script.lib.get_air(player)
		return get_air
	end,
 
	crouch = function (player)
		local DuckAmount = script.lib.duck_amount(player)
		local get_air = script.lib.get_air(player)
		return (DuckAmount >= 0.7 and not get_air)
	end,

	courch_air = function (player)
		local DuckAmount = script.lib.duck_amount(player)
		local get_air = script.lib.get_air(player)
		return (DuckAmount >= 0.7 and get_air)
	end,

}

script.menu = (function ()
	local out_menu = {}
	out_menu.custom = {}
	out_menu.select = script.lib.menu.combo("Select Anti-Aim Mode", 0, script.menu_table.mode)
	for index, value in ipairs(script.menu_table.mode) do
		out_menu.custom[index] = {
			enable = script.lib.menu.checkbox("[" .. value .. "] Enable", false),
			pitch = script.lib.menu.combo("[" .. value .. "] Pitch", 0, script.menu_table.pitch),
			viewangles = script.lib.menu.combo("[" .. value .. "] Viewangles", 0, script.menu_table.viewangles),
			fov = script.lib.menu.slider("[" .. value .. "] Max FOV", 1, 1, 45),
			yaw = script.lib.menu.slider("[" .. value .. "] Yaw Offset", 0, -180, 180),
			fake_mode = script.lib.menu.combo("[" .. value .. "] Fake Mode", 0, script.menu_table.jitter_mode),
			fake_min = script.lib.menu.slider("[" .. value .. "] Fake Min", 0, 0, 60),
			fake_max = script.lib.menu.slider("[" .. value .. "] Fake Max", 0, 0, 60),
			fake_max_2 = script.lib.menu.slider("[" .. value .. "] Fake Max2", 0, 0, 90),
			real_mode = script.lib.menu.combo("[" .. value .. "] Real Mode", 0, script.menu_table.jitter_mode),
			desync = script.lib.menu.slider("[" .. value .. "] Desync", 0, 0, 60),
			real_min = script.lib.menu.slider("[" .. value .. "] Real Min", 0, 0, 60),
			real_max = script.lib.menu.slider("[" .. value .. "] Real Max", 0, 0, 60),
			jitter_delay = script.lib.menu.slider("[" .. value .. "] Jitter Delay", 0, 0, 100),
		}
	end
	return out_menu
end)()

script.menu_setting = function ()

	if not menu.is_visible() then return end

	local mode = script.menu.select:get()

	if script.menu.custom[1].enable:get() == false then script.menu.custom[1].enable:set(true) end

	for index, value in ipairs(script.menu_table.mode) do
		local now_index = index - 1
		local show = now_index == mode
		local show2 = now_index == mode and script.menu.custom[index].enable:get()


		script.menu.custom[index].enable:visible(now_index ~= 0 and show)
		script.menu.custom[index].pitch:visible(show2)
		script.menu.custom[index].viewangles:visible(show2)
		script.menu.custom[index].fov:visible(show2 and script.menu.custom[index].viewangles:get() == 3)

		script.menu.custom[index].yaw:visible(show2)
		script.menu.custom[index].fake_mode:visible(show2)
		script.menu.custom[index].fake_min:visible(show2 and (script.menu.custom[index].fake_mode:get() == 1 or script.menu.custom[index].fake_mode:get() == 2))
		script.menu.custom[index].fake_max:visible(show2 and (script.menu.custom[index].fake_mode:get() == 1 or script.menu.custom[index].fake_mode:get() == 2))
		script.menu.custom[index].fake_max_2:visible(show2 and (script.menu.custom[index].fake_mode:get() == 3 or script.menu.custom[index].fake_mode:get() == 4))
		script.menu.custom[index].real_mode:visible(show2)

		script.menu.custom[index].desync:visible(show2 and script.menu.custom[index].real_mode:get() == 0)
		script.menu.custom[index].real_min:visible(show2 and (script.menu.custom[index].real_mode:get() == 1 or script.menu.custom[index].real_mode:get() == 2))
		script.menu.custom[index].real_max:visible(show2 and script.menu.custom[index].real_mode:get() ~= 0)
		script.menu.custom[index].jitter_delay:visible(show2 and (script.menu.custom[index].real_mode:get() ~= 0 or script.menu.custom[index].fake_mode:get() ~= 0))

	end

end

script.antiaim_status = function ()

	local local_player = engine.get_local_player()

	if script.get_player_status.courch_air(local_player) then
		return 7
	elseif script.get_player_status.inair(local_player) then
		return 5
	elseif script.get_player_status.crouch(local_player) then
		return 6
	elseif script.get_player_status.slowwalk(local_player) and not script.get_player_status.crouch(local_player) then
		return 3
	elseif script.get_player_status.running(local_player) then
		return 4
	elseif script.get_player_status.standing(local_player) then
		return 2
	else
		return 1
	end

end

script.on_createmove_pre_antiaim = function (cmd)

	local local_player = engine.get_local_player()
	if not local_player or not engine.is_ingame() and not engine.is_connected() or engine.get_local_player():get_netvar_int("m_lifeState") ~= 0 then return end

	local status = script.antiaim_status()
	local index = script.menu.custom[status].enable:get() and status or 1
	local fake_mode = script.menu.custom[index].fake_mode:get()
	local fake_max_value = (fake_mode == 1 or fake_mode == 2) and script.menu.custom[index].fake_max:get() or script.menu.custom[index].fake_max_2:get()

	menu_antiaim.set_pitch(script.menu.custom[index].pitch:get())
	menu_antiaim.set_viewangles(script.menu.custom[index].viewangles:get())
	menu_antiaim.set_max_fov(script.menu.custom[index].fov:get())
	menu_antiaim.set_yaw_offset(script.menu.custom[index].yaw:get())
	menu_antiaim.set_fake_mode(script.menu.custom[index].fake_mode:get())
	menu_antiaim.set_fake_min(script.menu.custom[index].fake_min:get())
	menu_antiaim.set_fake_max(fake_max_value)
	menu_antiaim.set_real_mode(script.menu.custom[index].real_mode:get())
	menu_antiaim.set_desync(script.menu.custom[index].desync:get())
	menu_antiaim.set_real_min(script.menu.custom[index].real_min:get())
	menu_antiaim.set_real_max(script.menu.custom[index].real_max:get()) 
	menu_antiaim.set_jitter_delay(script.menu.custom[index].jitter_delay:get())
end

script.unload = function ()
	menu_antiaim.set_pitch(script.cache.pitch)
	menu_antiaim.set_viewangles(script.cache.viewangles)
	menu_antiaim.set_max_fov(script.cache.max_fov)
	menu_antiaim.set_yaw_offset(script.cache.yaw_offset)
	menu_antiaim.set_fake_mode(script.cache.fake_mode)
	menu_antiaim.set_fake_min(script.cache.fake_min)
	menu_antiaim.set_fake_max(script.cache.fake_max)
	menu_antiaim.set_real_mode(script.cache.real_mode)
	menu_antiaim.set_desync(script.cache.desync)
	menu_antiaim.set_real_min(script.cache.real_min)
	menu_antiaim.set_real_max(script.cache.real_max)
	menu_antiaim.set_jitter_delay(script.cache.jitter_delay)
end

local callback_table = {
	["on_paint"] = script.menu_setting,
	["on_createmove_pre_antiaim"] = script.on_createmove_pre_antiaim,
	["on_unload"] = script.unload
}

for key, value in pairs(callback_table) do
	if key == "on_unload" then
		hooks.add_lua_unload_callback(value);
	else
		hooks.add_callback(key, value);
	end
end

