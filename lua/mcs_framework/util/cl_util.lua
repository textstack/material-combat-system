--[[ Translate a key into its localized counterpart.
	inputs:
		key - the language key in the localization file
		... - items to be formatted into the localized string
	example:
		print(MCS.L("foo", "bar"))
		-- in mcs.properties, "foo" maps to "%s law"
		-- output would be "bar law"
--]]
function MCS.L(key, ...)
	local lang = language.GetPhrase(key)
	return string.format(lang, ...)
end