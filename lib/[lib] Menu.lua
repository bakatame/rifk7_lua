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