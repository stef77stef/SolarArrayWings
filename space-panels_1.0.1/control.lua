function panel_built(event)
	local panel = event.entity
	if (panel and panel.valid) then
		local surf = panel.surface
		local directional_name
		
		if (panel.direction == defines.direction.north) then directional_name = "north"
		elseif (panel.direction == defines.direction.south) then directional_name = "south"
		elseif (panel.direction == defines.direction.east) then directional_name = "east"
		elseif (panel.direction == defines.direction.west) then directional_name = "west"
		else
			game.print("Unknown panel direction?!")
			return
		end
		
		local new_entity_tbl = {
			name = "space-solar-panel-" .. directional_name,
			position = panel.position,
			quality = panel.quality,
			force = panel.force,
			create_build_effect_smoke = false,
		}
		
		panel.destroy()
		surf.create_entity(new_entity_tbl)
		
	end
end

script.on_event(defines.events.on_built_entity, panel_built, {{filter = "name", name = "space-solar-panel"}})
script.on_event(defines.events.on_robot_built_entity, panel_built, {{filter = "name", name = "space-solar-panel"}})
script.on_event(defines.events.script_raised_built, panel_built, {{filter = "name", name = "space-solar-panel"}})
script.on_event(defines.events.script_raised_revive, panel_built, {{filter = "name", name = "space-solar-panel"}})
script.on_event(defines.events.on_space_platform_built_entity, panel_built, {{filter = "name", name = "space-solar-panel"}})