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
	return string.format(lang, ...), lang ~= key
end