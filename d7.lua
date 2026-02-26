local M = {}

local function load_data(file)
	local data = {}

	for line in file:lines() do
		table.insert(data, line)
	end

	file:close()
	return data
end

local function find_abba(s)
	local pattern = "%[[^%[%]]+%]"
	local outside = s:gsub(pattern, "[]")
	local inside = ""

	for match in s:gmatch(pattern) do
		inside = inside .. match
	end

	local abba_out, abba_in

	for i = 1, #outside - 3 do
		local a1, b1, b2, a2 = outside:sub(i, i + 3):match("(.)(.)(.)(.)")
		if a1 == a2 and b1 == b2 and not (a1 == b1) then
			abba_out = true
			break
		end
	end

	for i = 1, #inside - 3 do
		local a1, b1, b2, a2 = inside:sub(i, i + 3):match("(.)(.)(.)(.)")
		if a1 == a2 and b1 == b2 and not (a1 == b1) then
			abba_in = true
			break
		end
	end

	return abba_out and not abba_in
end

function M.p1(file)
	local data = load_data(file)
	local result = 0

	for _, s in ipairs(data) do
		if find_abba(s) then
			result = result + 1
		end
	end

	return result
end

return M
