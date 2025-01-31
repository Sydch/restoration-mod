if not ModCore then
	restoration.log_shit("[ERROR] Unable to find ModCore from BeardLib! Is BeardLib installed correctly?")
	return
end

function restoration:Init()
	restoration.log_shit("SC: LOADING: " .. self.ModPath)
	restoration.disable_captain_camper = {
		--///BASE LEVELS\\\--
		"pbr2",
		"born",
		"nail",
		"peta",
		"skm_mus",
		"skm_red2",
		"skm_run",
		"skm_watchdogs_stage2",
		"crojob2",
		"mus",
		"big",
		"wwh",
		"pines",
		"hox_3",
		"framing_frame_1",
		--///CUSTOM HEISTS\\\--
		"hardware_store", 
		"office_strike",
		"spa_CD",
		--///REX'S HOLDOUT LEVELS\\\--
		"skmc_mad",
		"skmc_fish",
		"skmc_ovengrill",
		--///RESTORATION EDITS\\\--
		"firestarter_2_res"
	}
	restoration.captain_teamwork = {
		"pal", --counterfeit 
		"crojob2", --bomb dockyard
		"firestarter_3", --firestarter day 3
		"jolly", --aftershock
		"rvd1", --highland mortuary 
		"watchdogs_2", --watch dogs 2
		"jolly_CD", --jolly crackdown edit
		--custom heists		
		"office_strike", --office strike
		"firestarter_3_res" --firestarter day 3 res edit version
	}
	restoration.captain_murderdozer = {
		"firestarter_2", --firestarter day 2
		"framing_frame_3", --framing frame day 3
		"rat",	--cook off
		"arm_for",	--train heist
		"mus",	--the diamond
		"big", --big bank
		--custom heists		
		"firestarter_2_res" --firestarter day 2 res edit version
	}
	restoration.captain_stelf = {
		"nightclub", --and Autumn stay off the dance floor
		"gallery", --art gallery
		"framing_frame_1", --art gallery but ff
		"branchbank", --well the trees are orange
		"dah", --diamond heist
		"four_stores", --do i really need to make a comment here?
		"family", --diamond store
		--custom heists
		"wetwork", --res map package wetworks
		"lvl_fourmorestores", --four more stores
		"hntn" --harvest and trustee north
	}
	restoration.tiny_levels = {
		"peta",
		"rvd2",
		"hox_1",
		"chill_combat",
		"brb",
		"skm_mus",
		"skm_red2",
		"skm_run",
		"skm_watchdogs_stage2",
		"bph",
		"glace",
		"man",
		"pbr",
		"pbr2",
		"dinner",
		"wwh",
		"born",
		"cane",
		"dah",
		"run",
		"help",
		"arm_cro",
		"arm_hcm",
		"arm_fac",
		"arm_par",
		"arm_und",
		"arm_for",
		--Custom Heists below--
		"Victor Romeo",
		"junk",
		"wetwork_burn",
		"hardware_store",
		"skmc_mad", --rex's holdout maps
		"skmc_fish",
		"skmc_ovengrill",
		"spa_CD",		
		"wwh_CD",		
		"street" --whurr's hs edit
	}
	--Mostly for stuff like Cursed Killed Room and other crap heists
	restoration.very_tiny_levels = {
		"hvh",
		"chew",
		"sah",
		"nail",		
		"nmh",		
		"peta2",
		"des",		
		"vit",
		"spa",		
		"flat",	
		"mex",
		"mex_cooking",		
		"mia_2"
	}		

	_G.SC = _G.SC or {}
	SC._path = self.ModPath
	SC._data = {}

	if SystemFS:exists("mods/DMCWO/mod.txt") then
		SC._data.sc_player_weapon_toggle = false
	else
		SC._data.sc_player_weapon_toggle = true
	end

	if not restoration.Options:GetValue("SC/SC") then
		SC._data.sc_player_weapon_toggle = false
	end
end

function restoration:all_enabled(...)
	for _, opt in pairs({...}) do
		if self.Options:GetValue(opt) == false then
			return false
		end
	end
	return true
end

function restoration.log_shit(to_log)
	if restoration.we_log then
		log(to_log)
	end
end

function restoration:LoadSCAssets()
	if restoration and restoration.Options:GetValue("SC/SC") then
		return true
	end
end

restoration.assault_style = {
	"beta_assault",
	"alpha_assault"
}

-- These tables show the network messages we've modified in the network settings pdmod
-- We will use them for switching to RestorationMod prefixed messages when in SC Mode.
local connection_network_handler_funcs = {
	'sync_player_installed_mod'
}

local unit_network_handler_funcs = {
	'sync_grenades'
}

--[[ local unit_network_handler_funcs = {
	'set_unit',
	'remove_corpse_by_id',
	'mission_ended',
	'from_server_sentry_gun_place_result',
	'sync_equipment_setup',
	'sync_ammo_bag_setup',
	'on_sole_criminal_respawned',
	'sync_grenades',
	'sync_carry_data',
	'sync_throw_projectile',
	'sync_attach_projectile',
	'sync_unlock_asset',
	'sync_equipment_possession',
	'sync_remove_equipment_possession',
	'mark_minion',
	'suspicion',
	'server_secure_loot',
	'sync_secure_loot'
} ]]

-- Builds a single table from our two string based keys for each handler above
restoration.network_handler_funcs = {}
function restoration:add_handler_funcs(handler_funcs)
	for i = 1, #handler_funcs do
		self.network_handler_funcs[handler_funcs[i]] = true
	end
end

restoration:add_handler_funcs(connection_network_handler_funcs)
restoration:add_handler_funcs(unit_network_handler_funcs)


-- Takes the network keys we defined above and prefixes any matches on the given handler
function restoration:rename_handler_funcs(NetworkHandler)
	for key, value in pairs(restoration.network_handler_funcs) do
		if NetworkHandler[key] then
			NetworkHandler['RestorationMod__' .. key] = NetworkHandler[key]
		end
	end
end
