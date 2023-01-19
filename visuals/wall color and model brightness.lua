local print = function (text) general.log_to_console(tostring(text)) end

local script = {}

script.ref = {
    mat_ambient_light_r = general.get_convar("mat_ambient_light_r"),
    mat_ambient_light_g = general.get_convar("mat_ambient_light_g"),
    mat_ambient_light_b = general.get_convar("mat_ambient_light_b"),
    r_modelAmbientMin = general.get_convar("r_modelAmbientMin"),
}

local enable = menu.add_checkbox("wall color", false)
local color = menu.add_colorpicker("wall effect color", 110, 205, 255, 255, true)
local brightness = menu.add_slider("Min model brightness", 0, 0, 1000)

script.data = {
    wallcolor_old = false,
    model_ambient_min_old = -1,
}

script.func = {

    on_paint = function()
        if not engine.get_map_name() then
            script.data.bloom_default, script.data.exposure_min_default, script.data.exposure_max_default = nil, nil, nil
            if script.data.post_processing_old then
                script.data.post_processing_old = false
            end
            return
        end
        
        local wallcolor = menu.get(enable):get_bool()
        if wallcolor or script.data.wallcolor_old then
            
            if wallcolor then
                
                local r_res, g_res, b_res
                local bloom_wall_color = menu.get(color):get_c_color()
                local alpha_temp = bloom_wall_color:a() / 128 - 1
                local wall_color_r, wall_color_g, wall_color_b = bloom_wall_color:r() / 255, bloom_wall_color:g() / 255, bloom_wall_color:b() / 255
                if alpha_temp > 0 then
                    local multiplier = 900 ^ (alpha_temp) - 1
                    alpha_temp = alpha_temp * multiplier
                    r_res, g_res, b_res = wall_color_r * alpha_temp, wall_color_g * alpha_temp, wall_color_b * alpha_temp
                else
                    alpha_temp = alpha_temp
                    r_res, g_res, b_res = (1 - wall_color_r) * alpha_temp, (1 - wall_color_g) * alpha_temp, (1 - wall_color_b) * alpha_temp
                end
                
                if script.ref.mat_ambient_light_r:get_float() ~= r_res or script.ref.mat_ambient_light_g:get_float() ~= g_res or script.ref.mat_ambient_light_b:get_float() ~= b_res then
                    script.ref.mat_ambient_light_r:set_float(r_res)
                    script.ref.mat_ambient_light_g:set_float(g_res)
                    script.ref.mat_ambient_light_b:set_float(b_res)
                end
            else
                script.ref.mat_ambient_light_r:set_float(0)
                script.ref.mat_ambient_light_g:set_float(0)
                script.ref.mat_ambient_light_b:set_float(0)
            end
        end

        script.data.wallcolor_old = wallcolor
        script.data.post_processing_old = true
        
        local model_ambient_min = menu.get(brightness):get_float()
        if model_ambient_min > 0 or (script.data.model_ambient_min_old ~= nil and script.data.model_ambient_min_old > 0) then
            if script.ref.r_modelAmbientMin:get_float() ~= model_ambient_min * 0.05 then
                script.ref.r_modelAmbientMin:set_float(model_ambient_min * 0.05)
            end
        end

        script.data.model_ambient_min_old = model_ambient_min

    end,

    on_unload = function()

        script.ref.mat_ambient_light_r:set_float(0)
        script.ref.mat_ambient_light_g:set_float(0)
        script.ref.mat_ambient_light_b:set_float(0)
        script.ref.r_modelAmbientMin:set_float(0)

    end,

}

local callback_table = {
    ["on_draw"] = function ()
        -- It will be very dropout, because Rifk7 has no UI Callback
        script.func.on_paint()
    end,

    ["on_unload"] = function ()
        script.func.on_unload()
    end
}

for key, value in pairs(callback_table) do
	if key == "on_unload" then
		hooks.add_lua_unload_callback(value);
	else
		hooks.add_callback(key, value);
	end
end
