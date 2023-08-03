local function damage_player( player_entity )
	local damagemodels = EntityGetComponent( player_entity, "DamageModelComponent" )

	if( damagemodels ~= nil ) then
		for _,damagemodel in ipairs(damagemodels) do
			local hp = ComponentGetValue2( damagemodel, "hp" )

			hp = math.max( 0.04, hp - math.max( hp * 0.75, 0.8 ) )

			ComponentSetValue2( damagemodel, "hp", hp )
		end
	end
end

local function regen( x, y )
	local field = EntityLoad( "data/entities/projectiles/deck/regeneration_field.xml", x, y )
	local life = EntityGetFirstComponentIncludingDisabled( field, 'LifetimeComponent')
	if life then
		ComponentSetValue2( life, 'lifetime', -1 )
	end
end

function lha_test( player_entity )
	damage_player( player_entity )
	local x,y = EntityGetTransform(player_entity)
	EntityLoad( "mods/low_health_alert/files/tox.xml", x + 100, y )
	EntityLoad( "data/entities/projectiles/deck/touch_water.xml", x - 100, y + 50 )
	regen( x - 100, y )
end

