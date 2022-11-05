menu.add_checkbox("enable", false);
menu.add_multiselection("Choose Hitboxes", "Head\0Chest\0Stomach\0Pelvis\0Legs\0Toes\0Arms\0\0");
menu.add_multiselection("Choose Multipoints", "Head\0Chest\0Stomach\0Pelvis\0Legs\0Arms\0\0");
menu.add_keybind("Keybind", 0, 0, 0);

local is_enabled = false;
local add_head, add_chest, add_stomach, add_pelvis, add_legs, add_toes, add_arms = false;
local add_head_multipoint, add_chest_multipoint, add_stomach_multipoint, add_pelvis_multipoint, add_legs_multipoint, add_arms_multipoint = false;

-- lua_hitscan
function hitscan_func(context)

    if (is_enabled == false) then
        return;
    end

    -- override cheat selection.
    context.should_override = true;

    if (add_head) then  
    hitscan.add_hitbox(hitbox.head);
    end
  
    if (add_chest) then  
    hitscan.add_hitbox(hitbox.upper_chest);
    hitscan.add_hitbox(hitbox.chest);
    hitscan.add_hitbox(hitbox.lower_chest);
    end

    if (add_stomach) then  
    hitscan.add_hitbox(hitbox.stomach);
    end

    if (add_pelvis) then  
    hitscan.add_hitbox(hitbox.pelvis);
    end

    if (add_legs) then  
    hitscan.add_hitbox(hitbox.left_thigh);
    hitscan.add_hitbox(hitbox.right_thigh);
    hitscan.add_hitbox(hitbox.left_calf);
    hitscan.add_hitbox(hitbox.right_calf);
    end

    if (add_toes) then  
    hitscan.add_hitbox(hitbox.right_foot);
    hitscan.add_hitbox(hitbox.left_foot);
    end

    if (add_arms) then  
    hitscan.add_hitbox(hitbox.left_upper_arm);
    hitscan.add_hitbox(hitbox.right_upper_arm);
    end
end

hooks.add_hook("on_hitscan", hitscan_func);

-- on_createmove gets called right before ragebot stuff.
-- since we are not using player specific stuff ( from the context of hitscan ) we don't have to get our menu vars on hitscan ( which gets called multiple times per player ).
-- getting these menu vars here is much cheaper.

-- c_user_cmd*
function createmove_func()

    is_enabled = false;

    if (menu.get_checkbox("enable") == false) then
        return;
    end

    if (menu.get_keybind_button("Keybind") > 0 and menu.get_keybind("Keybind") == false) then
        return;
    end

    is_enabled = true;
    add_head = menu.get_multiselection_item("Choose Hitboxes", 0);
    add_chest = menu.get_multiselection_item("Choose Hitboxes", 1);
    add_stomach = menu.get_multiselection_item("Choose Hitboxes", 2);
    add_pelvis = menu.get_multiselection_item("Choose Hitboxes", 3);
    add_legs = menu.get_multiselection_item("Choose Hitboxes", 4);
    add_toes = menu.get_multiselection_item("Choose Hitboxes", 5);
    add_arms = menu.get_multiselection_item("Choose Hitboxes", 6);

    add_head_multipoint = menu.get_multiselection_item("Choose Multipoints", 0);
    add_chest_multipoint = menu.get_multiselection_item("Choose Multipoints", 1);
    add_stomach_multipoint = menu.get_multiselection_item("Choose Multipoints", 2);
    add_pelvis_multipoint = menu.get_multiselection_item("Choose Multipoints", 3);
    add_legs_multipoint = menu.get_multiselection_item("Choose Multipoints", 4);
    add_arms_multipoint = menu.get_multiselection_item("Choose Multipoints", 5);
end

hooks.add_hook("on_createmove", createmove_func);

-- lua_multipoints
function multipoints_func(context)

    if (is_enabled == false) then
        return;
    end
  
    -- lets override the cheats multipoint selection.
    context.should_override = true;
  
    if (context.hitbox == hitbox.head) then
        if (add_head_multipoint) then
        context.should_multipoint_hitbox = true;
        end
        return;
    end
  
    if (context.hitbox == hitbox.upper_chest or context.hitbox == hitbox.chest or context.hitbox == hitbox.lower_chest) then
        if (add_chest_multipoint) then
        context.should_multipoint_hitbox = true;
        end
        return;
    end
  
    if (context.hitbox == hitbox.stomach) then
        if (add_stomach_multipoint) then
        context.should_multipoint_hitbox = true;
        end
        return;
    end
  
    if (context.hitbox == hitbox.pelvis) then
        if (add_pelvis_multipoint) then
        context.should_multipoint_hitbox = true;
        end
        return;
    end
  
    if (context.hitbox == hitbox.left_thigh or context.hitbox == hitbox.right_thigh or context.hitbox == hitbox.left_calf or context.hitbox == hitbox.right_calf) then
        if (add_legs_multipoint) then
        context.should_multipoint_hitbox = true;
        end
        return;
    end
  
    if (context.hitbox == hitbox.left_upper_arm or context.hitbox == hitbox.right_upper_arm) then
        if (add_arms_multipoint) then
        context.should_multipoint_hitbox = true;
        end
        return;
    end
end

hooks.add_hook("on_multipoints", multipoints_func);
