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

net.Receive("mcs_notify", function()
	local tag = net.ReadString()

	local items = {}
	local itemCount = net.ReadUInt(MCS.NOTIFY_FORMAT_NET_SIZE)
	for i = 1, itemCount do
		table.insert(items, net.ReadString())
	end

	LocalPlayer():MCS_Notify(tag, unpack(items))
end)