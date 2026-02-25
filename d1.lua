local M = {}
local abs = math.abs

local function load_data(file)
	local data = {}

	for line in file:lines() do
		local matches = line:gmatch("[^%s,]+")
		for match in matches do
			table.insert(data, { match:sub(1, 1), tonumber(match:sub(2)) })
		end
	end

	file:close()
	return data
end

local dirs = {
	{ 0, -1 },
	{ 1, 0 },
	{ 0, 1 },
	{ -1, 0 },
}

function M.p1(file)
	local data = load_data(file)
	local facing = 1
	local pos = { 0, 0 }

	for _, t in ipairs(data) do
		if t[1] == "R" then
			facing = facing % #dirs + 1
		else
			facing = (facing - 2) % #dirs + 1
		end

		pos[1] = pos[1] + dirs[facing][1] * t[2]
		pos[2] = pos[2] + dirs[facing][2] * t[2]
	end

	return abs(pos[1]) + abs(pos[2])
end

function M.p2(file)
	local data = load_data(file)
	local facing = 1
	local pos = { 0, 0 }
	local visited = {}

	for _, t in ipairs(data) do
		if t[1] == "R" then
			facing = facing % #dirs + 1
		else
			facing = (facing - 2) % #dirs + 1
		end

		for _ = 1, t[2] do
			if visited[pos[1]] and visited[pos[1]][pos[2]] then
				return abs(pos[1]) + abs(pos[2])
			end

			visited[pos[1]] = visited[pos[1]] or {}
			visited[pos[1]][pos[2]] = true

			pos[1] = pos[1] + dirs[facing][1]
			pos[2] = pos[2] + dirs[facing][2]
		end
	end
end

return M
