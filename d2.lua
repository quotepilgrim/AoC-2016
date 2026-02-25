local M = {}
local min, max = math.min, math.max

local function load_data(file)
	if not file then
		return {
			"ULL",
			"RRDDD",
			"LURDL",
			"UUUUD",
		}
	end

	local data = {}

	for line in file:lines() do
		table.insert(data, line)
	end

	file:close()
	return data
end

function M.p1(file)
	local data = load_data(file)
	local pos = { 2, 2 }
	local result = ""

	local keypad = {
		{ 1, 2, 3 },
		{ 4, 5, 6 },
		{ 7, 8, 9 },
	}

	for _, rule in ipairs(data) do
		for i = 1, #rule do
			local c = rule:sub(i, i)

			if c == "U" then
				pos[1], pos[2] = pos[1], max(1, pos[2] - 1)
			elseif c == "R" then
				pos[1], pos[2] = min(3, pos[1] + 1), pos[2]
			elseif c == "D" then
				pos[1], pos[2] = pos[1], min(3, pos[2] + 1)
			elseif c == "L" then
				pos[1], pos[2] = max(1, pos[1] - 1), pos[2]
			end
		end

		result = result .. keypad[pos[2]][pos[1]]
	end

	return result
end

function M.p2(file)
	local data = load_data(file)
	local result = ""
	local pos = { 1, 3 } -- 3,3 is wrong but gives the right answer for my input

	local keypad = {
		{ nil, nil, "1", nil, nil },
		{ nil, "2", "3", "4", nil },
		{ "5", "6", "7", "8", "9" },
		{ nil, "A", "B", "C", nil },
		{ nil, nil, "D", nil, nil },
	}

	-- The out-of-bounds check here is how I thought of doing part 1 at first.
	-- It would have saved me some time had I actually done it like that.
	for _, rule in ipairs(data) do
		for i = 1, #rule do
			local c = rule:sub(i, i)
			local nx, ny

			if c == "U" then
				nx, ny = pos[1], pos[2] - 1
			elseif c == "R" then
				nx, ny = pos[1] + 1, pos[2]
			elseif c == "D" then
				nx, ny = pos[1], pos[2] + 1
			elseif c == "L" then
				nx, ny = pos[1] - 1, pos[2]
			end

			if keypad[ny] and keypad[ny][nx] then
				pos[1], pos[2] = nx, ny
			end
		end

		result = result .. keypad[pos[2]][pos[1]]
	end

	return result
end

return M
