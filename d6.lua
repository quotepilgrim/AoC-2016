local M = {}

local function load_data(file)
	local data = {}
	local line = file:read()

	for _ = 1, #line do
		table.insert(data, {})
	end

	while line do
		for i = 1, #line do
			table.insert(data[i], line:sub(i, i))
		end

		line = file:read()
	end

	file:close()
	return data
end

local function get_counts(t)
	local counts = {}
	local counts_t = {}

	for i, v in ipairs(t) do
		if not counts[v] then
			counts[v] = 1
		else
			counts[v] = counts[v] + 1
		end
	end

	for k, v in pairs(counts) do
		table.insert(counts_t, { k, v })
	end

	table.sort(counts_t, function(a, b)
		return a[2] < b[2]
	end)

	return counts_t
end

function M.p1(file, pt2)
	local result = {}

	local data = load_data(file)
	for _, t in ipairs(data) do
		local counts = get_counts(t)
		local i = pt2 and 1 or #counts
		table.insert(result, counts[i][1])
	end

	return table.concat(result)
end

function M.p2(file)
	return M.p1(file, true)
end

return M
