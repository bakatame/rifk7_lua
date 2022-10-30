local print = function (...) local text = "" if type(text) == "table" then for index, value in ipairs(...) do text = tostring(value) .. ", " end else text = tostring(...) end general.log_to_console(text) end

local entity_table = {}

entity_table.get_players = function (enemies_only, skip_dormant)

    if not enemies_only then enemies_only = false end
    if not skip_dormant then skip_dormant = false end

    local players = {}
    
    for i = 1, entity_list.get_max_entities() do
        
        local entity = entity_list.get_entity(i)

        if not entity then goto skip end

        local player = entity:is_player()

        if not player or (enemies_only and not entity:is_enemy()) or (skip_dormant and entity:is_dormant()) then
            goto skip
        end
        
        players[i] = entity

        ::skip::

    end

    return players

end

entity_table.get_class = function (class)

    local class_table = {}

    if not class then return class_table end

    for i = 1, entity_list.get_max_entities() do

        local class_entity = entity_list.get_entity(i)
        
        if not class_entity or (type(class) == "string" and class_entity:get_class_name() ~= tostring(class)) or (type(class) == "number" and class_entity:get_class_id() ~= tonumber(class)) then
            goto skip
        end

        class_table[i] = class_entity

        ::skip::

    end

    return class_table

end

for i, v in pairs(entity_table.get_players(true, true)) do
    print(engine.get_player_info(v:get_index()).name)
end
