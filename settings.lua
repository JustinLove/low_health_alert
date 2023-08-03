dofile("data/scripts/lib/mod_settings.lua") -- see this file for documentation on some of the features.

local mod_id = "low_health_alert" -- This should match the name of your mod's folder.
mod_settings_version = 1 -- This is a magic global that can be used to migrate settings to new mod versions. call mod_settings_get_version() before mod_settings_update() to get the old value.
mod_settings = 
{
	{
		id = "percent_alert",
		ui_name = "Alert below percent health",
		value_default = 0.25,
		value_min = 0,
		value_max = 1,
		value_display_multiplier = 100,
		value_display_formatting = " $0",
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "absolute_alert",
		ui_name = "Alert below health",
		value_default = "25",
		text_max_length = 5,
		allowed_characters = "0123456789",
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "sound_event",
		ui_name = "Play a sound when falling below alert level",
		value_default = "none",
		values = {
			{"none","none"},
			{"event_cues/angered_the_gods/create","Angry gods"},
			{"event_cues/game_over/create","Game over"},
			{"event_cues/heartbeat/create","Heartbeat"},
			{"event_cues/chest_bad/create","Chest trap"},
			{"animals/wizard/death","Mage death"},
		},
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
}


function ModSettingsUpdate( init_scope )
	local old_version = mod_settings_get_version( mod_id ) -- This can be used to migrate some settings between mod versions.
	mod_settings_update( mod_id, mod_settings, init_scope )
end

function ModSettingsGuiCount()
	return mod_settings_gui_count( mod_id, mod_settings )
end

-- This function is called to display the settings UI for this mod. Your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
function ModSettingsGui( gui, in_main_menu )
	mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )
end
