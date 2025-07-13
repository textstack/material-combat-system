--[[ Translate a key into its localized counterpart.
	inputs:
		key - the language key in the localization file
		... - items to be formatted into the localized string
	outputs:
		the formatted and translated string,
		whether the string is translated or not
	example:
		print(MCS.L("foo", "bar"))
		-- in mcs.properties, "foo" maps to "%s law"
		-- output would be "bar law"
--]]
function MCS.L(key, ...)
	local lang = language.GetPhrase(key)

	local format = {}
	for _, item in ipairs({...}) do
		local l = MCS.L(item)
		table.insert(format, l)
	end

	return string.format(lang, unpack(format)), lang ~= key
end

MCS.ICON_FALLBACK = Material("mcs_icons/armor/unarmored.png")

--[[ Gets the icon material for a type
	inputs:
		_type - the type object to get the icon from
		fallback - an optional fallback texture
	output:
		the material for the type's icon, or a fallback material
--]]
local fallbacks = {}
function MCS.GetIconMaterial(_type, fallback)
	if not _type or not _type.Icon then
		if type(fallback) ~= "string" then return MCS.ICON_FALLBACK end

		if not fallbacks[fallback] then
			fallbacks[fallback] = Material(fallback)
		end

		if fallbacks[fallback]:IsError() then
			fallbacks[fallback] = MCS.ICON_FALLBACK
		end

		return fallbacks[fallback]
	end

	local setMat = _type.Material ~= nil
	if not setMat and _type.Icon then
		_type.Material = Material(_type.Icon)
		setMat = true
	end

	if type(fallback) == "string" and (not setMat or _type.Material:IsError()) then
		_type.Material = Material(fallback)
		setMat = true
	end

	if not setMat or _type.Material:IsError() then
		_type.Material = MCS.ICON_FALLBACK
	end

	return _type.Material
end

net.Receive("mcs_notify", function()
	local tag = net.ReadString()

	local items = {}
	local itemCount = net.ReadUInt(MCS.NOTIFY_FORMAT_NET_SIZE)
	for i = 1, itemCount do
		table.insert(items, net.ReadString())
	end

	LocalPlayer():MCS_Notify(tag, unpack(items))
end)