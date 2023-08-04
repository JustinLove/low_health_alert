lha_last_alert = nil

function lha_find_icon(parent)
	local children = EntityGetAllChildren( parent )
	for i = 1,#children do
		local com = EntityGetFirstComponentIncludingDisabled( children[i], 'UIIconComponent' )
		if com then
			if ComponentGetValue2( com, 'icon_sprite_file' ) == "data/ui_gfx/status_indicators/attacking_player.png" then
				return children[i]
			end
		end
	end
end

function lha_remove_icon(parent)
	--print('remove icon')
	local icon = lha_find_icon(parent)
	if icon then
		EntityKill(icon)
	end
end

function lha_add_icon(parent)
	--print('add icon')
	local icon = lha_find_icon(parent)
	if not icon then
		local x,y = EntityGetTransform(parent)
		icon = EntityLoad( "mods/low_health_alert/files/icon.xml", x, y )
		EntityAddChild( parent, icon )
		local event = ModSettingGet("low_health_alert.sound_event")
		lha_play_sound(event, x, y) -- side effect, but it's after an icon present check so poll and damage events agree
	end
end

function lha_play_sound( event, x, y )
	if event == 'none' then return end
	local bank = 'data/audio/Desktop/event_cues.bank'
	if event == 'animals/wizard/death' then
		bank = 'data/audio/Desktop/animals.bank'
	end
	GamePlaySound( bank, event, x, y )
end

function lha_status_update( parent, damage )
	local alert
	local percent_alert = ModSettingGet("low_health_alert.percent_alert")
	local absolute_alert = tonumber(ModSettingGet("low_health_alert.absolute_alert")) or 25
	if absolute_alert then
		absolute_alert = absolute_alert / 25
	end

	local damagemodels = EntityGetComponent( parent, "DamageModelComponent" )
	if( damagemodels ~= nil ) then
		for i,damagemodel in ipairs(damagemodels) do
			local hp = tonumber( ComponentGetValue( damagemodel, "hp" ) )
			local max_hp = tonumber( ComponentGetValue( damagemodel, "max_hp" ) )

			--print( hp, damage, max_hp )
			hp = hp - damage
			alert = hp < max_hp * percent_alert or hp < absolute_alert
		end
	end

	if lha_last_alert ~= nil and alert == lha_last_alert then return end
	lha_last_alert = alert

	if alert then
		lha_add_icon(parent)
	else
		lha_remove_icon(parent)
	end
end
