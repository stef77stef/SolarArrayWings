local item_sounds = require("__base__.prototypes.item_sounds")
local hit_effects = require ("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")

local tech = data.raw.technology["rocket-silo"]
if tech and tech.effects then
    table.insert(tech.effects, {
        type = "unlock-recipe",
        recipe = "space-solar-panel"
    })
else
    log("Technology 'rocket-silo' or its effects table is missing.")
end

local space_panel_graphics = {
    north =
    {
        layers =
        {{
            filename = "__space-panels__/graphics/panel_north.png",
            priority = "high",
            width = 480,
            height = 960,
            shift = util.by_pixel(0, -230),
            scale = 0.5
        },},
    },
    east =
    {
        layers =
        {{
            filename = "__space-panels__/graphics/panel_east.png",
            priority = "high",
            width = 960,
            height = 480,
            shift = util.by_pixel(230, 0),
            scale = 0.5
        },},
    },
    south =
    {
        layers =
        {{
            filename = "__space-panels__/graphics/panel_south.png",
            priority = "high",
            width = 480,
            height = 960,
            shift = util.by_pixel(0, 230),
            scale = 0.5
        },},
    },
    west =
    {
        layers =
        {{
            filename = "__space-panels__/graphics/panel_west.png",
            priority = "high",
            width = 960,
            height = 480,
            shift = util.by_pixel(-230, 0),
            scale = 0.5
        },},
    }
}

local function create_directional_panel(cdir)
	local panel = util.table.deepcopy(data.raw["solar-panel"]["solar-panel"])
	panel.name = "space-solar-panel-" .. cdir
	panel.minable = {mining_time = 0.1, result = "space-solar-panel"}
	panel.fast_replaceable_group = "space-solar-panel"
	panel.localised_name = { "entity-name.space-solar-panel" }
	panel.localised_description = { "entity-description.space-solar-panel" }
	panel.icon = "__space-panels__/graphics/panel-icon.png"
    panel.icon_size = 256
	panel.impact_category = "metal"
	panel.max_health = 50
	panel.placeable_by = {item = "space-solar-panel", count = 1}
	panel.surface_conditions = {
		{ property = "pressure", min = 0, max = 0 }
	}
	panel.production = "600kW"
	panel.picture = space_panel_graphics[cdir]
	if (cdir == "north") then
        panel.selection_box = {{-3.5, -14.5}, {3.5, 0.4}}
        panel.collision_box = {{-3.4, -14.4}, {3.4, 0.4}}
	elseif (cdir == "south") then
        panel.selection_box = {{-3.5, -0.4}, {3.5, 14.5}}
        panel.collision_box = {{-3.4, -0.4}, {3.4, 14.4}}
	elseif (cdir == "west") then
        panel.selection_box = {{-14.5, -3.5}, {0.4, 3.5}}
        panel.collision_box = {{-14.4, -3.4}, {0.4, 3.4}}	
	elseif (cdir == "east") then
        panel.selection_box = {{-0.4, -3.5}, {14.5, 3.5}}
        panel.collision_box = {{-0.4, -3.4}, {14.4, 3.4}}	
	end
	return panel
end
  

data.extend{
    {
        type = "recipe",
        name = "space-solar-panel",
        enabled = false,
        energy_required = 10,
        ingredients =
        {
          {type = "item", name = "solar-panel", amount = 10},
          {type = "item", name = "processing-unit", amount = 2},
          {type = "item", name = "low-density-structure", amount = 5}
        },
        results = {{type="item", name="space-solar-panel", amount=1}},
        icon = "__space-panels__/graphics/panel-icon.png",
        icon_size = 256,
    },
    {
    type = "item",
    name = "space-solar-panel",
    icon = "__space-panels__/graphics/panel-icon.png",
    icon_size = 256,
    subgroup = "space-platform",
    order = "d[solar-panel]-a[space-solar-panel]",
    inventory_move_sound = item_sounds.electric_large_inventory_move,
    pick_sound = item_sounds.electric_large_inventory_pickup,
    drop_sound = item_sounds.electric_large_inventory_move,
    place_result = "space-solar-panel",
    stack_size = 10
    },
    {
        type = "electric-energy-interface",
        name = "space-solar-panel",
        icon = "__space-panels__/graphics/panel-icon.png",
        icon_size = 256,
        flags = {"placeable-neutral", "placeable-player", "player-creation"},
        minable = {mining_time = 0.1, result = "space-solar-panel"},
        fast_replaceable_group = "space-solar-panel",
        max_health = 50,
        corpse = "solar-panel-remnants",
        dying_explosion = "solar-panel-explosion",
        selection_box = {{-3.5, -14.5}, {3.5, 0.4}},
        collision_box = {{-3.4, -14.4}, {3.4, 0.4}},
        collision_mask = {layers={is_object = true, is_lower_object = true, transport_belt = true}},
        --collision_mask = {layers={item=true, object=true, train=true, is_lower_object = true, is_object = true}},
        tile_buildability_rules =
        {
          {area = {{-0.4, 0.6}, {0.4, 1.4}}, required_tiles = {layers = {ground_tile = true}}, colliding_tiles = {layers = {empty_space = true}}, remove_on_collision = true},
          {area = {{-3.4, -14.4}, {3.4, 0.4}}, required_tiles = {layers = {empty_space = true}}, remove_on_collision = true},
        },
        impact_category = "metal",
        surface_conditions =
        {
          {
            property = "pressure",
            min = 0,
            max = 0
          }
        },
        damaged_trigger_effect = hit_effects.entity(),

        energy_source = {
            buffer_capacity = "1J",
            type = "electric",
            usage_priority = "secondary-output",
        },

        --energy_usage = "-600kW", -- Generates power

        pictures = space_panel_graphics,

        impact_category = "glass",
        energy_production = "600kW",
        energy_usage = "0kW",
        gui_mode = "none",
    },
	
	create_directional_panel("north"),
	create_directional_panel("south"),
	create_directional_panel("east"),
	create_directional_panel("west"),
}
