dofile_once('mods/low_health_alert/files/low_health_alert.lua')

function damage_received( damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible )
	local parent = GetUpdatedEntityID()
	lha_status_update( parent, damage )
end
