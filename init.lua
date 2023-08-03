function OnPlayerSpawned( player_entity ) -- This runs when player entity has been created
	if GameHasFlagRun('LHA_RUN_ONCE') then
		return
	end

	EntityAddComponent( player_entity, "LuaComponent", 
	{
		script_damage_received = "mods/low_health_alert/files/damage_received.lua",
	} )

	--dofile('mods/low_health_alert/files/test.lua')
	--lha_test(player_entity)

	GameAddFlagRun('LHA_RUN_ONCE')
end

