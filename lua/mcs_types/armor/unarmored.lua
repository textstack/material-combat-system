local TYPE = {}

TYPE.Vanilla = true
TYPE.Set = "armor"
TYPE.ID = "unarmored"
TYPE.ServerName = "Unarmored"
TYPE.Icon = "icons/armor/unarmored.png"
TYPE.Color = Color(128, 128, 128)

--TYPE.HideOnHud = true
TYPE.HideOnTargetID = true

if SERVER then
	local noArmorEnts = {}

	hook.Add("Think", "MCS_Unarmored", function()
		for id, ent in pairs(noArmorEnts) do
			if not IsValid(ent) then
				noArmorEnts[id] = nil
				continue
			end

			ent:MCS_SetArmor(0)
		end
	end)

	local function enable(ent)
		if ent:IsPlayer() then
			noArmorEnts[ent:EntIndex()] = ent
		end
	end

	local function disable(ent)
		noArmorEnts[ent:EntIndex()] = nil
	end

	TYPE.OnEnabled = enable
	TYPE.OnSwitchTo = enable

	TYPE.OnDisabled = disable
	TYPE.OnSwitchFrom = disable
end

local function noArmor()
	return 0
end

TYPE.EntityGetArmor = noArmor
TYPE.EntityGetMaxArmor = noArmor

MCS.RegisterType(TYPE)