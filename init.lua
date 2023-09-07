function OnPlayerSpawned( player_entity ) -- This runs when player entity has been created
	if GameHasFlagRun('LHA_RUN_ONCE') then
		return
	end

	lha_self_test_translations()

	EntityAddComponent( player_entity, "LuaComponent", 
	{
		script_damage_received = "mods/low_health_alert/files/damage_received.lua",
	} )
	EntityAddComponent( player_entity, "LuaComponent", 
	{
		script_source_file = "mods/low_health_alert/files/status_update.lua",
		execute_every_n_frame = 60,
	} )

	--dofile('mods/low_health_alert/files/test.lua')
	--lha_test(player_entity)

	GameAddFlagRun('LHA_RUN_ONCE')
end

    name="$lha_status_low_health_alert"
    description="$lha_statusdesc_low_health_alert"
local translations = [[
lha_status_low_health_alert,Low Health,,,,,,,,,,,,,
lha_statusdesc_low_health_alert,It might be time to leave.\nChange alert level in settings.,,,,,,,,,,,,,
]]

local function append_translations(content)
	-- previous blank lines, copied from Noitavania
	while content:find("\r\n\r\n") do
		content = content:gsub("\r\n\r\n","\r\n");
	end
	--print(string.sub(content, -80))
	--print(string.byte(content, -3, string.len(content)))
	-- make sure our first line doesn't get appended to last line
	local joint = ""
	if (string.sub(content, -1) ~= "\n") then
		joint = "\r\n"
	end
	-- inline lua strings get \n only; compound seems to be more expected by othe other mods
	if (string.sub(translations, -2) ~= "\r\n") then
		translations = string.gsub(translations, "\n", "\r\n")
	end
	local text = content .. joint .. translations
	--print(string.sub(text, -(string.len(translations) + 80)))
	return text
end

local function edit_file(path, f, arg)
	local text = ModTextFileGetContent( path )
	if text then
		ModTextFileSetContent( path, f( text, arg ) )
	end
end

edit_file( "data/translations/common.csv", append_translations)

function lha_self_test_translations()
	if GameTextGet( "$lha_status_low_health_alert" ) == '' then
		GamePrint( 'Low Health Alert translations are broken, please report with your current mod list' )
	end
end
