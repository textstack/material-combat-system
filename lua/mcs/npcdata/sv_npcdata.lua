util.AddNetworkString("mcs_npcdata")

if not file.Exists("mcs", "DATA") then
	file.CreateDir("mcs")
end

MCS1.DEFAULT_NPC_DATA_PATH = "mcs_data/default_npc_data.lua"
MCS1.NPC_DATA_PATH = "mcs/npc_data.txt"

-- initialize the data table for NPC health and armor types
local function initNPCData()
	if file.Exists(MCS1.NPC_DATA_PATH, "DATA") then
		MCS1.NPCData = util.JSONToTable(file.Read(MCS1.NPC_DATA_PATH, "DATA"))
	elseif file.Exists(MCS1.DEFAULT_NPC_DATA_PATH, "LUA") then
		MCS1.NPCData = util.JSONToTable(file.Read(MCS1.DEFAULT_NPC_DATA_PATH, "LUA"))
	else
		MCS1.NPCData = {}
	end
end

local function writeNPCData()
	file.Write(MCS1.NPC_DATA_PATH, util.TableToJSON(MCS1.NPCData))
end

local function bumpNPCData(class)
	local data = MCS1.GetNPCData(class)

	net.Start("mcs_npcdata")
	net.WriteBool(false)
	net.WriteUInt(1, MCS1.NPC_DATA_COUNT_NET_SIZE)
	net.WriteString(class)
	net.WriteString(data[1] or "")
	net.WriteString(data[2] or "")
	net.WriteString(data[3] or "")
	net.Broadcast()
end

local function sendNPCData(ply)
	net.Start("mcs_npcdata")
	net.WriteBool(true)

	net.WriteUInt(table.Count(MCS1.NPCData), MCS1.NPC_DATA_COUNT_NET_SIZE)
	for class, data in pairs(MCS1.NPCData) do
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
function MCS1.SetNPCData(class, healthID, armorID, augmentID)
	MCS1.NPCData[class] = MCS1.NPCData[class] or {}
	local data = MCS1.NPCData[class]

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
		MCS1.NPCData[class] = nil
	end

	if not MCS1.IsEquippableArmor(MCS1.ArmorType(data[2] or ""), data[1]) then
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

	MCS1.SetNPCData(class, healthType, armorType, augment)
end)
