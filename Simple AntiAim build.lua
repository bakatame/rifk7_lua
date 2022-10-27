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

	combo_text = function (...)

		if not ... then return end
		local check_type = type(...) == "table" and ... or {...}

		if #check_type == 0 then return end

		local out_text = ""
		for index, value in ipairs(check_type) do
			out_text = out_text .. value .. "\0"
		end

		out_text = out_text .. "\0"

		return out_text

	end,

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

script.menu_create = function ()
	menu.add_combo("Selete Anti-Aim Mode", 0 , script.lib.combo_text(script.menu_table.mode))
	for index, value in ipairs(script.menu_table.mode) do
		menu.add_checkbox("[" .. value .. "] Enable", false)
		menu.add_combo("[" .. value .. "] Pitch", 0, script.lib.combo_text(script.menu_table.pitch))
		menu.add_combo("[" .. value .. "] Viewangles", 0, script.lib.combo_text(script.menu_table.viewangles))
		menu.add_slider("[" .. value .. "] Max FOV", 1, 1, 45)
		menu.add_slider("[" .. value .. "] Yaw Offset", 0, -180, 180)
		menu.add_combo("[" .. value .. "] Fake Mode", 0, script.lib.combo_text(script.menu_table.jitter_mode))
		menu.add_slider("[" .. value .. "] Fake Min", 0, 0, 60)
		menu.add_slider("[" .. value .. "] Fake Max", 0, 0, 60)
		menu.add_slider("[" .. value .. "] Fake Max2", 0, 0, 90)
		menu.add_combo("[" .. value .. "] Real Mode", 0, script.lib.combo_text(script.menu_table.jitter_mode))
		menu.add_slider("[" .. value .. "] Desync", 0, 0, 60)
		menu.add_slider("[" .. value .. "] Real Min", 0, 0, 60)
		menu.add_slider("[" .. value .. "] Real Max", 0, 0, 60)
		menu.add_slider("[" .. value .. "] Jitter Delay", 0, 0, 100)
	end
end script.menu_create()

script.menu_setting = function ()

	if not menu.is_visible() then return end

	local mode = menu.get_combo("Selete Anti-Aim Mode")

	if menu.get_checkbox("[Default] Enable") == false then
		menu.set_checkbox("[Default] Enable", true)
	end

	for index, value in ipairs(script.menu_table.mode) do
		local now_index = index - 1
		local show = now_index == mode
		local show2 = now_index == mode and menu.get_checkbox("[" .. value .. "] Enable")

		menu.override_visibility("[" .. value .. "] Enable", now_index ~= 0 and show)
		menu.override_visibility("[" .. value .. "] Pitch", show2)
		menu.override_visibility("[" .. value .. "] Viewangles", show2)
		menu.override_visibility("[" .. value .. "] Max FOV", show2 and menu.get_combo("[" .. value .. "] Viewangles") == 3)
		menu.override_visibility("[" .. value .. "] Yaw Offset", show2)
		menu.override_visibility("[" .. value .. "] Fake Mode", show2)
		menu.override_visibility("[" .. value .. "] Fake Min", show2 and (menu.get_combo("[" .. value .. "] Fake Mode") == 1 or menu.get_combo("[" .. value .. "] Fake Mode") == 2))
		menu.override_visibility("[" .. value .. "] Fake Max", show2 and (menu.get_combo("[" .. value .. "] Fake Mode") == 1 or menu.get_combo("[" .. value .. "] Fake Mode") == 2))
		menu.override_visibility("[" .. value .. "] Fake Max2", show2 and (menu.get_combo("[" .. value .. "] Fake Mode") == 3 or menu.get_combo("[" .. value .. "] Fake Mode") == 4))
		menu.override_visibility("[" .. value .. "] Real Mode", show2)
		menu.override_visibility("[" .. value .. "] Desync", show2 and menu.get_combo("[" .. value .. "] Real Mode") == 0)
		menu.override_visibility("[" .. value .. "] Real Min", show2 and (menu.get_combo("[" .. value .. "] Real Mode") == 1 or menu.get_combo("[" .. value .. "] Real Mode") == 2))
		menu.override_visibility("[" .. value .. "] Real Max", show2 and menu.get_combo("[" .. value .. "] Real Mode") ~= 0)
		menu.override_visibility("[" .. value .. "] Jitter Delay", show2 and menu.get_combo("[" .. value .. "] Real Mode") ~= 0)
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
	
	local value = menu.get_checkbox("[".. script.menu_table.mode[script.antiaim_status()] .."] Enable") and script.menu_table.mode[script.antiaim_status()] or "Default"
	local fake_mode = menu.get_combo("[" .. value .. "] Fake Mode")
	local fake_max_value = (fake_mode == 1 or fake_mode == 2) and menu.get_slider("[" .. value .. "] Fake Max") or menu.get_slider("[" .. value .. "] Fake Max2")

	menu_antiaim.set_pitch(menu.get_combo("[" .. value .. "] Pitch"))
	menu_antiaim.set_viewangles(menu.get_combo("[" .. value .. "] Viewangles"))
	menu_antiaim.set_max_fov(menu.get_slider("[" .. value .. "] Max FOV"))
	menu_antiaim.set_yaw_offset(menu.get_slider("[" .. value .. "] Yaw Offset"))
	menu_antiaim.set_fake_mode(menu.get_combo("[" .. value .. "] Fake Mode"))
	menu_antiaim.set_fake_min(menu.get_slider("[" .. value .. "] Fake Min"))
	menu_antiaim.set_fake_max(fake_max_value)
	menu_antiaim.set_real_mode(menu.get_combo("[" .. value .. "] Real Mode"))
	menu_antiaim.set_desync(menu.get_slider("[" .. value .. "] Desync"))
	menu_antiaim.set_real_min(menu.get_slider("[" .. value .. "] Real Min"))
	menu_antiaim.set_real_max(menu.get_slider("[" .. value .. "] Real Max")) 
	menu_antiaim.set_jitter_delay(menu.get_slider("[" .. value .. "] Jitter Delay"))
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
		hooks.on_lua_unload(value);
	else
		hooks.add_hook(key, value);
	end
	
end

