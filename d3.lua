local M = {}

local function load_data(file)
	local data = {}

	for line in file:lines() do
		local a, b, c = line:match("(%d+)%s+(%d+)%s+(%d+)")
		table.insert(data, { tonumber(a), tonumber(b), tonumber(c) })
	end

	file:close()
	return data
end

function M.p1(file)
	local data = load_data(file)
	local result = 0

	for _, t in ipairs(data) do
		table.sort(t)
		if t[1] + t[2] > t[3] then
			result = result + 1
		end
	end

	return result
end

function M.p2(file)
	local data = load_data(file)
	local result = 0
	local columns = { {}, {}, {} }

	for _, t in ipairs(data) do
		for i = 1, 3 do
			table.insert(columns[i], t[i])
		end
	end

	for _, col in ipairs(columns) do
		for i = 1, #col, 3 do
			local a, b, c = col[i], col[i + 1], col[i + 2]

			if not (a + b <= c or a + c <= b or b + c <= a) then
				result = result + 1
			end
		end
	end

	return result
end

return M
