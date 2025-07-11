util.AddNetworkString("mcs_npcdata")

if not file.Exists("mcs", "DATA") then
	file.CreateDir("mcs")
end

MCS.DEFAULT_NPC_DATA_PATH = "mcs_data/default_npc_data.lua"
MCS.NPC_DATA_PATH = "mcs/npc_data.txt"

-- initialize the data table for NPC health and armor types
local function initNPCData()
	if file.Exists(MCS.NPC_DATA_PATH, "DATA") then
		MCS.NPCData = util.JSONToTable(file.Read(MCS.NPC_DATA_PATH, "DATA"))
	elseif file.Exists(MCS.DEFAULT_NPC_DATA_PATH, "LUA") then
		MCS.NPCData = util.JSONToTable(file.Read(MCS.DEFAULT_NPC_DATA_PATH, "LUA"))
	else
		MCS.NPCData = {}
	end
end

local function writeNPCData()
	file.Write(MCS.NPC_DATA_PATH, util.TableToJSON(MCS.NPCData))
end

local function bumpNPCData(class)
	local data = MCS.GetNPCData(class)

	net.Start("mcs_npcdata")
	net.WriteBool(false)
	net.WriteUInt(1, MCS.NPC_DATA_COUNT_NET_SIZE)
	net.WriteString(class)
	net.WriteString(data[1] or "")
	net.WriteString(data[2] or "")
	net.WriteString(data[3] or "")
	net.Broadcast()
end

local function sendNPCData(ply)
	net.Start("mcs_npcdata")
	net.WriteBool(true)

	net.WriteUInt(table.Count(MCS.NPCData), MCS.NPC_DATA_COUNT_NET_SIZE)
	for class, data in pairs(MCS.NPCData) do
		net.WriteString(class)
		net.WriteString(data[1] or "")
		net.WriteString(data[2] or "")
		net.WriteString(data[3] or "")
	end

	if ply then
		net.Send(ply)
	else
		net.Broadcast()
	end
end

gameevent.Listen("player_activate")
hook.Add("player_activate", "MCS_SendNPCData", function(data)
	local ply = Player(data.userid)
	sendNPCData(ply)
end)

--[[ Set the health and armor types for an entity class
	inputs:
		class - the class to set
		healthID - the health type id to set (optional)
		armorID - the armor type id to set (optional)
		augmentID - the damage type id to set for an augment (optional)
	notes:
		Set healthtype/armortype to an *empty string* to remove.
--]]
function MCS.SetNPCData(class, healthID, armorID, augmentID)
	MCS.NPCData[class] = MCS.NPCData[class] or {}
	local data = MCS.NPCData[class]

	if healthID then
		if healthID == "" then
			data[1] = nil
		else
			data[1] = healthID
		end
	end

	if armorID then
		if armorID == "" then
			data[2] = nil
		else
			data[2] = armorID
		end
	end

	if augmentID then
		if augmentID == "" then
			data[3] = nil
		else
			data[3] = augmentID
		end
	end

	if table.IsEmpty(data) then
		MCS.NPCData[class] = nil
	end

	local armorType = MCS.ArmorType(data[2] or "")
	if armorType and ((armorType.HealthTypes and not armorType.HealthTypes[data[1]]) or (armorType.HealthTypeBlacklist and armorType.HealthTypeBlacklist[data[1]])) then
		data[2] = nil
	end

	writeNPCData()
	bumpNPCData(class)
end

hook.Add("InitPostEntity", "MCS_InitNPCData", initNPCData)

-- hotload support
if MCS_LOADED then
	initNPCData()
	sendNPCData()
end

net.Receive("mcs_npcdata", function(_, ply)
	if not ply:IsSuperAdmin() then return end

	local class = net.ReadString()
	local healthType = net.ReadString()
	local armorType = net.ReadString()
	local augment = net.ReadString()

	MCS.SetNPCData(class, healthType, armorType, augment)
end)
