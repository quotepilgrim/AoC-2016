local M = {}

local function load_data(file)
	local pattern = "^(.+)-(%d+)%[(.+)]$"
	local data = {}

	if not file then
		local def = {
			"aaaaa-bbb-z-y-x-123[abxyz]",
			"a-b-c-d-e-f-g-h-987[abcde]",
			"not-a-real-room-404[oarel]",
			"totally-real-room-200[decoy]",
		}

		for i, v in ipairs(def) do
			local name, id, chksum = v:match(pattern)
			data[i] = { name, id, chksum }
		end

		return data
	end

	for line in file:lines() do
		local name, id, chksum = line:match(pattern)
		table.insert(data, { name, id, chksum })
	end

	file:close()
	return data
end

local function get_counts(s)
	local counts = {}
	s = s:gsub("-", "")

	for i = 1, #s do
		local c = s:sub(i, i)
		if not counts[c] then
			counts[c] = 1
		else
			counts[c] = counts[c] + 1
		end
	end

	local letter_counts = {}
	for k, v in pairs(counts) do
		table.insert(letter_counts, { k, v })
	end

	table.sort(letter_counts, function(a, b)
		--tried to implement this in one line, failed
		if a[2] == b[2] then
			return a[1] < b[1]
		else
			return a[2] > b[2]
		end
	end)

	return letter_counts
end

function M.p1(file)
	local data = load_data(file)
	local result = 0

	for _, t in ipairs(data) do
		local counts = get_counts(t[1])
		local chksum = {}

		for i = 1, 5 do
			chksum[i] = counts[i][1]
		end

		if table.concat(chksum) == t[3] then
			result = result + t[2]
		end
	end

	return result
end

local function shift(s, n)
	local st = {}

	for i = 1, #s do
		local c = s:sub(i, i)
		local byte = (c:byte() + n - 97) % 26 + 97

		st[i] = c == "-" and " " or string.char(byte)
	end

	return table.concat(st)
end

function M.p2(file)
	local data = load_data(file)

	for _, t in ipairs(data) do
		local shifted = shift(t[1], t[2])

		if shifted:find("northpole") then
			return t[2]
		end
	end
end

return M
