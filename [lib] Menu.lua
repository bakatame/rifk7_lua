local print = function (...) 
    local text = "" 
    if type(text) == "table" then 
        for index, value in ipairs(...) do 
            text = tostring(value) .. ", " 
        end 
    else 
        text = tostring(...) 
    end 
    general.log_to_console(text) 
end


local combo_text = function (...)

    if not ... then return end
    local check_type = type(...) == "table" and ... or {...}

    if #check_type == 0 then return end

    local out_text = ""
    for index, value in ipairs(check_type) do
        out_text = out_text .. value .. "\0"
    end

    out_text = out_text .. "\0"

    return out_text

end

local menu_lib = {}

menu_lib.__index = menu_lib

function menu_lib:visible(bool)
    if not self or not self.menu_name then return end
    menu.override_visibility(self.menu_name, bool)
end

function menu_lib:get(value)
    
    if not self or not self.menu_type or not self.menu_name then return end

    if self.menu_type == "second_colorpicker" then
        return menu.get_colorpicker(self.menu_name)
    elseif self.menu_type == "multiselection" then
        return menu.get_multiselection_item(self.menu_name, value)
    elseif menu["get_" .. self.menu_type] ~= nil then
        return menu["get_" .. self.menu_type](self.menu_name)
    end
    
    return

end

function menu_lib:set(menu_value1, menu_value2, menu_value3, menu_value4)

    if not self or not self.menu_type or not self.menu_name then return end
    if self.menu_type == "separator" then return end

    if self.menu_type == "colorpicker" or self.menu_type == "second_colorpicker" then
        menu.set_colorpicker(self.menu_name, menu_value1, menu_value2, menu_value3, menu_value4)
    elseif self.menu_type == "keybind" then
        if menu_value1 then
            menu.set_keybind_button(self.menu_name, menu_value1)
        end

        if menu_value2 then
            menu.set_keybind_mode(self.menu_name, menu_value2)
        end
    elseif self.menu_type == "flex_checkbox" then
        if menu_value1 then
            menu.set_flex_checkbox_button(self.menu_name, menu_value1)
        end

        if menu_value2 then
            menu.set_flex_checkbox_mode(self.menu_name, menu_value2)
        end
    elseif self.menu_type == "multiselection" then
        menu.set_multiselection(self.menu_name, menu_value1, menu_value2)
    elseif menu["set_" .. self.menu_type] ~= nil then
        menu["set_" .. self.menu_type](self.menu_name, menu_value1)
    end
    
end

menu_lib.new = function(menu_type, menu_name, menu_value1, menu_value2, menu_value3, menu_value4, menu_value5)

    if not menu_type or not menu_name or type(menu_type) ~= "string" or type(menu_name) ~= "string" then
        return
    end

    if menu_type == "separator" then
        menu.add_separator(menu_name)
    elseif menu_type == "text" then
        menu.add_text(menu_name)
        if menu_value1 then
            menu.set_text(menu_name, menu_value1)
        end
    elseif menu_type == "checkbox" then
        if not menu_value1 or type(menu_value1) ~= "boolean" then menu_value1 = false end
        menu.add_checkbox(menu_name, menu_value1)
    elseif menu_type == "slider" then
        if not menu_value1 or type(menu_value1) ~= "number" then menu_value1 = 0 end
        if not menu_value2 or type(menu_value2) ~= "number" then menu_value2 = 0 end
        if not menu_value3 or type(menu_value3) ~= "number" then menu_value3 = 0 end
        menu.add_slider(menu_name, menu_value1, menu_value2, menu_value3)
    elseif menu_type == "combo" then
        if not menu_value1 or type(menu_value1) ~= "number" then menu_value1 = 0 end
        if not menu_value2 or type(menu_value2) ~= "table" then return end
        menu.add_combo(menu_name, menu_value1, combo_text(menu_value2))
    elseif menu_type == "keybind" then
        if not menu_value1 or type(menu_value1) ~= "number" then menu_value1 = 0 end
        if not menu_value2 or type(menu_value2) ~= "number" then menu_value2 = 0 end
        if not menu_value3 or type(menu_value3) ~= "number" then menu_value3 = 0 end
        menu.add_keybind(menu_name, menu_value1, menu_value2, menu_value3)
    elseif menu_type == "flex_checkbox" then
        if not menu_value1 or type(menu_value1) ~= "number" then menu_value1 = 0 end
        if not menu_value2 or type(menu_value2) ~= "number" then menu_value2 = 0 end
        menu.add_flex_checkbox(menu_name, menu_value1, menu_value2)
    elseif menu_type == "colorpicker" then
        if not menu_value1 or type(menu_value1) ~= "number" then menu_value1 = 255 end
        if not menu_value2 or type(menu_value2) ~= "number" then menu_value2 = 255 end
        if not menu_value3 or type(menu_value3) ~= "number" then menu_value3 = 255 end
        if not menu_value4 or type(menu_value4) ~= "number" then menu_value4 = 255 end
        if not menu_value5 or type(menu_value5) ~= "boolean" then menu_value5 = false end
        menu.add_colorpicker(menu_name, menu_value1, menu_value2, menu_value3, menu_value4, menu_value5)
    elseif menu_type == "second_colorpicker" then
        if not menu_value1 or type(menu_value1) ~= "number" then menu_value1 = 255 end
        if not menu_value2 or type(menu_value2) ~= "number" then menu_value2 = 255 end
        if not menu_value3 or type(menu_value3) ~= "number" then menu_value3 = 255 end
        if not menu_value4 or type(menu_value4) ~= "number" then menu_value4 = 255 end
        if not menu_value5 or type(menu_value5) ~= "boolean" then menu_value5 = false end
        menu.add_second_colorpicker(menu_name, menu_value1, menu_value2, menu_value3, menu_value4, menu_value5)
    elseif menu_type == "multiselection" then
        if not menu_value1 or type(menu_value1) ~= "table" then return end
        menu.add_multiselection(menu_name, combo_text(menu_value1))
    else
        return
    end

    return setmetatable({
        menu_type = menu_type,
        menu_name = menu_name,
    },menu_lib)

end

--[[
    <<Example>>
    
    local example_text = menu_lib.new("text", "Example Text")
    local example_checkbox = menu_lib.new("checkbox", "Example Checkbox", false)
    local example_slider = menu_lib.new("slider", "Example Slider", 0, 0, 100)
    local example_combo = menu_lib.new("combo", "Example Combo", 0, {"First Value", "Second Value", "Third Value"})
    local example_multiselection = menu_lib.new("multiselection", "Example Multiselection", {"First Value", "Second Value", "Third Value"})
    local example_flex_checkbox = menu_lib.new("flex_checkbox", "Example Flex Checkbox", 0, 0)
    local example_keybind_full = menu_lib.new("keybind", "Example Keybind FULL", 0, 0, 0)
    local example_flex_2modes = menu_lib.new("keybind", "Example Keybind 2 MODES", 0, 0, 1)
    local example_flex_hold = menu_lib.new("keybind", "Example Keybind HOLD", 0, 0, 2)
    local example_colorpicker = menu_lib.new("colorpicker", "Example Colorpicker value", 255, 255, 255, 255, false)
    local example_colorpicker_text = menu_lib.new("text", "Example Colorpicker")
    local example_colorpicker_alpha = menu_lib.new("colorpicker", "Example Colorpicker alpha", 255, 255, 255, 255, true)
    local example_colorpicker_alpha_text = menu_lib.new("text", "Example Colorpicker with alpha")
    local example_2_colorpickers_value = menu_lib.new("colorpicker", "Example 2 Colorpickers value", 255, 255, 255, 255, false)
    local example_2_colorpickers_value2 = menu_lib.new("second_colorpicker", "Example 2 Colorpickers value2", 255, 255, 255, 255, true)
    local example_colorpicker_3_text = menu_lib.new("text", "Example Colorpicker 3")
    local example_separator = menu_lib.new("separator", "example_separator_1")
    local dynamic_text_1 = menu_lib.new("text", "dynamic_text_1", "Checkbox Active: False")
    local dynamic_text_2 = menu_lib.new("text", "dynamic_text_2", "Slider Value: 0")
    local dynamic_text_3 = menu_lib.new("text", "dynamic_text_3", "Combo Value: 0")
    local dynamic_text_4 = menu_lib.new("text", "dynamic_text_4", "MultiSelection 1. Item Active: False")
    local dynamic_text_5 = menu_lib.new("text", "dynamic_text_5", "MultiSelection 2. Item Active: False")
    local dynamic_text_6 = menu_lib.new("text", "dynamic_text_6", "MultiSelection 3. Item Active: False")



    local function menu_checks()
        
        dynamic_text_1:set(example_checkbox:get() and "Checkbox Active: True" or "Checkbox Active: False")
        dynamic_text_2:set("Slider Value: " .. example_slider:get())
        dynamic_text_3:set("Combo Value: " .. example_combo:get())
        dynamic_text_4:set(example_multiselection:get(0) and "MultiSelection 1. Item Active: True" or "MultiSelection 1. Item Active: False")
        dynamic_text_5:set(example_multiselection:get(1) and "MultiSelection 2. Item Active: True" or "MultiSelection 2. Item Active: False")
        dynamic_text_6:set(example_multiselection:get(2) and "MultiSelection 3. Item Active: True" or "MultiSelection 3. Item Active: False")

    end

    hooks.add_hook("on_draw", menu_checks);
]]

