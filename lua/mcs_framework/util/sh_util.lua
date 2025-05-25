--- Capitalize a string in simple title case
local function tchelper(first, rest)
	return first:upper() .. rest:lower()
end
function MCS.ToCapital(str)
	str = str:gsub("(%a)([%w_']*)", tchelper)
	return str
end