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

function menu_lib:get()
    
    if not self or not self.menu_type or not self.menu_name then return end

    if self.menu_type == "second_colorpicker" then
        return menu.get_colorpicker(self.menu_name)
    elseif self.menu_type == "multiselection" then
        return menu.get_multiselection_item(self.menu_name)
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
        menu.set_text(menu_name, menu_value1)
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
        menu_lib.add_combo(menu_name, menu_value1, combo_text(menu_value2))
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
        menu.add_multiselection(menu_name, combo_text(menu_value2))
    else
        return
    end

    return setmetatable({
        menu_type = menu_type,
        menu_name = menu_name,
    },menu_lib)

end

return menu_lib

--[[
    <<Example>>
]]
