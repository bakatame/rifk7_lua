--[[
    * Modified in Hitbox & Multipoint Selection.lua
    * Author: Smiley
    * https://rifk7.com/index.php?threads/hitbox-multipoint-selection.195/
]]

local print = function (...) local text = ""; if type(text) == "table" then for index, value in ipairs(...) do text = tostring(value) .. ", "; end; else text = tostring(...); end; general.log_to_console(text); end

local hitbox_c = {};

hitbox_c.lib = {

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

    get_weapon_index = function ()
        local local_player = engine.get_local_player()
        if not local_player or not engine.is_ingame() or not engine.is_connected() or local_player:get_netvar_int("m_lifeState") ~= 0 then return 6 end

        local weapon = local_player:get_active_weapon()
        if not weapon then return 6 end

        local weapon_class = weapon:get_class_id()
        if not weapon_class then return 6 end

        if weapon_class == 261 or weapon_class == 242 then
            return 1
        elseif weapon_class == 267 then
            return 2
        elseif weapon_class == 233 then
            return 3
        elseif weapon_class == 245 or weapon_class == 239 or weapon_class == 258 or weapon_class == 269 or weapon_class == 246 or weapon_class == 241 then
            return 4
        elseif weapon_class == 46 then
            return 5
        else
            return 6
        end
    end

};

hitbox_c.data = {

    hitbox = {"Head", "Chest", "Stomach", "Pelvis", "Legs", "Toes", "Arms"},
    weapon = {"Auto", "Scout", "AWP", "Pistol", "Heavy", "Other"},
    check_enable = false,
    check_hitbox = {
        head = false,
        chest = false,
        stomach = false,
        pelvis = false,
        legs = false,
        toes = false,
        arms = false,
    },
    check_multipoint = {
        head = false,
        chest = false,
        stomach = false,
        pelvis = false,
        legs = false,
        toes = false,
        arms = false,
    },

};

hitbox_c.menu = {

    enable = hitbox_c.lib.menu.checkbox("Enable"),
    keybinds_separator = hitbox_c.lib.menu.separator("keybinds_separator"),
    override_hitboxes_keybind = hitbox_c.lib.menu.keybind("Override Hitboxes Keybind", 0, 0, 0),
    override_multipoint_keybind = hitbox_c.lib.menu.keybind("Override Multipoints Keybind", 0, 0, 0),
    weapon_separator = hitbox_c.lib.menu.separator("weapon_separator"),
    weapon = hitbox_c.lib.menu.combo("Choose Weapons", 0, hitbox_c.data.weapon),
    setting = (function ()
        local out_table = {};
        for index, value in ipairs(hitbox_c.data.weapon) do
            out_table[index] = {
                separator = hitbox_c.lib.menu.separator(value),
                text = value,
                enable = hitbox_c.lib.menu.checkbox("Enable " .. value .. " Hitbox"),
                hitbox = hitbox_c.lib.menu.multiselection("[" .. value .. "] Choose Hitboxes", {"Head", "Chest", "Stomach", "Pelvis", "Legs", "Toes", "Arms"}),
                multipoint = hitbox_c.lib.menu.multiselection("[" .. value .. "] Choose Multipoints", {"Head", "Chest", "Stomach", "Pelvis", "Legs", "Toes", "Arms"}),
                override_hitbox = hitbox_c.lib.menu.multiselection("[" .. value .. "] Choose Override Hitboxes", {"Head", "Chest", "Stomach", "Pelvis", "Legs", "Toes", "Arms"}),
                override_multipoint = hitbox_c.lib.menu.multiselection("[" .. value .. "] Choose Override Multipoints", {"Head", "Chest", "Stomach", "Pelvis", "Legs", "Toes", "Arms"}),
            }
        end
        return out_table;
    end)(),

};

hitbox_c.func = {

    on_paint = function ()

        local enable = hitbox_c.menu.enable:get();
        local weapon = hitbox_c.menu.weapon:get();

        hitbox_c.menu.keybinds_separator:visible(enable);
        hitbox_c.menu.override_hitboxes_keybind:visible(enable);
        hitbox_c.menu.override_multipoint_keybind:visible(enable);
        hitbox_c.menu.weapon_separator:visible(enable);
        hitbox_c.menu.weapon:visible(enable);

        for index, value in ipairs(hitbox_c.data.weapon) do
            local show = index == (weapon + 1);
            local show2 = enable and show;
            hitbox_c.menu.setting[index].separator:visible(show2);
            hitbox_c.menu.setting[index].enable:visible(show2);
            hitbox_c.menu.setting[index].hitbox:visible(show2 and hitbox_c.menu.setting[index].enable:get());
            hitbox_c.menu.setting[index].multipoint:visible(show2 and hitbox_c.menu.setting[index].enable:get());
            hitbox_c.menu.setting[index].override_hitbox:visible(show2 and hitbox_c.menu.setting[index].enable:get());
            hitbox_c.menu.setting[index].override_multipoint:visible(show2 and hitbox_c.menu.setting[index].enable:get());
        end

    end,

    createmove = function (cmd)

        hitbox_c.data.check_enable = false;

        if not hitbox_c.menu.enable:get() then return; end

        local index = hitbox_c.lib.get_weapon_index()
        if not index then return end
        if not hitbox_c.menu.setting[index].enable:get() then return end

        hitbox_c.data.check_enable = true;
        
        local is_hitbox_override = hitbox_c.menu.override_hitboxes_keybind:get("mode") ~= 3 and hitbox_c.menu.override_hitboxes_keybind:get();
        local is_multipoint_override = hitbox_c.menu.override_multipoint_keybind:get("mode") ~= 3 and hitbox_c.menu.override_multipoint_keybind:get();
        local get_hitbox_item = function (value)
            local return_value = is_hitbox_override and hitbox_c.menu.setting[index].override_hitbox:get(value) or hitbox_c.menu.setting[index].hitbox:get(value)
            return return_value
        end

        local get_multipoint_item = function (value)
            local return_value = is_multipoint_override and hitbox_c.menu.setting[index].override_multipoint:get(value) or hitbox_c.menu.setting[index].multipoint:get(value)
            return return_value
        end
        
        hitbox_c.data.check_hitbox.head = get_hitbox_item(0);
        hitbox_c.data.check_hitbox.chest = get_hitbox_item(1);
        hitbox_c.data.check_hitbox.stomach = get_hitbox_item(2);
        hitbox_c.data.check_hitbox.pelvis = get_hitbox_item(3);
        hitbox_c.data.check_hitbox.legs = get_hitbox_item(4);
        hitbox_c.data.check_hitbox.toes = get_hitbox_item(5);
        hitbox_c.data.check_hitbox.arms = get_hitbox_item(6);

        hitbox_c.data.check_multipoint.head = get_multipoint_item(0);
        hitbox_c.data.check_multipoint.chest = get_multipoint_item(1);
        hitbox_c.data.check_multipoint.stomach = get_multipoint_item(2);
        hitbox_c.data.check_multipoint.pelvis = get_multipoint_item(3);
        hitbox_c.data.check_multipoint.legs = get_multipoint_item(4);
        hitbox_c.data.check_multipoint.toes = get_multipoint_item(5);
        hitbox_c.data.check_multipoint.arms = get_multipoint_item(6);

    end,

    hitscan = function (context)
        
        if not hitbox_c.data.check_enable then return end
        
        context.should_override = true;
        
        local check_hitbox_table = {
            {
                check = hitbox_c.data.check_hitbox.head,
                value = {
                    hitbox.head
                }
            },
            {
                check = hitbox_c.data.check_hitbox.chest,
                value = {
                    hitbox.upper_chest,
                    hitbox.chest,
                    hitbox.lower_chest,
                }
            },
            {
                check = hitbox_c.data.check_hitbox.stomach,
                value = {
                    hitbox.stomach
                }
            },
            {
                check = hitbox_c.data.check_hitbox.pelvis,
                value = {
                    hitbox.pelvis
                }
            },
            {
                check = hitbox_c.data.check_hitbox.legs,
                value = {
                    hitbox.left_thigh,
                    hitbox.right_thigh,
                    hitbox.left_calf,
                    hitbox.right_calf,
                }
            },
            {
                check = hitbox_c.data.check_hitbox.toes,
                value = {
                    hitbox.right_foot,
                    hitbox.left_foot
                }
            },
            {
                check = hitbox_c.data.check_hitbox.arms,
                value = {
                    hitbox.left_upper_arm,
                    hitbox.right_upper_arm
                }
            },
        }

        for index, check_value in ipairs(check_hitbox_table) do
            if check_value.check then
                for index2, value in ipairs(check_value.value) do
                    hitscan.add_hitbox(value);
                end
            end
        end

    end,

    multipoints = function (context)

        if not hitbox_c.data.check_enable then return end

        context.should_override = true;
        
        local check_table = {
            (context.hitbox == hitbox.head and hitbox_c.data.check_multipoint.head),
            ((context.hitbox == hitbox.upper_chest or context.hitbox == hitbox.chest or context.hitbox == hitbox.lower_chest) and hitbox_c.data.check_multipoint.chest),
            (context.hitbox == hitbox.stomach and hitbox_c.data.check_multipoint.stomach),
            (context.hitbox == hitbox.pelvis and hitbox_c.data.check_multipoint.pelvis),
            ((context.hitbox == hitbox.left_thigh or context.hitbox == hitbox.right_thigh or context.hitbox == hitbox.left_calf or context.hitbox == hitbox.right_calf) and hitbox_c.data.check_multipoint.legs),
            ((context.hitbox == hitbox.right_foot or context.hitbox == hitbox.left_foot) and hitbox_c.data.check_multipoint.toes),
            ((context.hitbox == hitbox.left_upper_arm or context.hitbox == hitbox.right_upper_arm) and hitbox_c.data.check_multipoint.arms),
        }

        for index, value in ipairs(check_table) do
            if value then
                context.should_multipoint_hitbox = true;
                return;
            end
        end

    end
};

hitbox_c.callbacks = {
    on_paint = hitbox_c.func.on_paint,
    on_createmove = hitbox_c.func.createmove,
    on_hitscan = hitbox_c.func.hitscan,
    on_multipoints = hitbox_c.func.multipoints,
}

hitbox_c.init = function ()
    hitbox_c.func.on_paint()
    for key, value in pairs(hitbox_c.callbacks) do
        hooks.add_callback(key, value);
    end
end;

hitbox_c.init();