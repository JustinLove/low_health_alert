local icon_entity
local icon_component

function damage_received( damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible )
	local parent = GetUpdatedEntityID()
	if not icon_component then
		local children = EntityGetAllChildren( parent )
		for i = 1,#children do
			local com = EntityGetFirstComponentIncludingDisabled( children[i], 'UIIconComponent' )
			if com then
				if ComponentGetValue2( com, 'icon_sprite_file' ) == "data/ui_gfx/status_indicators/attacking_player.png" then
					icon_entity = children[i]
					icon_component = com
				end
			end
		end
	end

	if not icon_component then
		local x,y = EntityGetTransform(parent)
		icon_entity = EntityLoad( "mods/low_health_alert/files/icon.xml", x, y )
		icon_component = EntityGetFirstComponentIncludingDisabled( icon_entity, 'UIIconComponent' )
		EntityAddChild( parent, icon_entity )
	end

	if not icon_component then return end

	local alert

	local damagemodels = EntityGetComponent( parent, "DamageModelComponent" )
	if( damagemodels ~= nil ) then
		for i,damagemodel in ipairs(damagemodels) do
			local hp = tonumber( ComponentGetValue( damagemodel, "hp" ) )
			local max_hp = tonumber( ComponentGetValue( damagemodel, "max_hp" ) )

			hp = hp - damage
			alert = hp < max_hp * 0.25 or hp < 1
		end
	end

	if alert then
		EntitySetComponentIsEnabled( icon_entity, icon_component, true )
	else
		EntitySetComponentIsEnabled( icon_entity, icon_component, false )
	end
end
