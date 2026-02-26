local M = {}

function M.load(argv)
	if argv.p ~= "2" then
		M.draw = nil
	end
end

local function load_data(file)
	local data = {}
	for line in file:lines() do
		local row = {}

		local matches = line:gmatch("[^%s]+")

		for match in matches do
			table.insert(row, match)
		end

		if row[1] == "rect" then
			local a, b = row[2]:match("^(%d+)x(%d+)$")
			table.insert(data, { row[1], tonumber(a), tonumber(b) })
		else
			local a, b = row[3]:match("^(.)=(%d+)$")
			table.insert(data, { row[1], a, tonumber(b), tonumber(row[#row]) })
		end
	end

	file:close()
	return data
end

local fun = {
	rect = function(grid, w, h)
		for y = 1, h do
			for x = 1, w do
				grid[y][x] = "#"
			end
		end
	end,

	rotate = function(grid, xy, i, c)
		if xy == "y" then
			local row = grid[i + 1]
			for _ = 1, c do
				local last = row[#row]
				for j = #row, 2, -1 do
					row[j] = row[j - 1]
				end
				row[1] = last
			end
		else
			local col = i + 1

			for _ = 1, c do
				local last = grid[#grid][col]
				for row = #grid, 2, -1 do
					grid[row][col] = grid[row - 1][col]
				end
				grid[1][col] = last
			end
		end
	end,
}

function M.p1(file)
	local data = load_data(file)
	local grid = {}
	local result = 0

	for _ = 1, 6 do
		table.insert(grid, {})
		for _ = 1, 50 do
			table.insert(grid[#grid], ".")
		end
	end

	for _, t in ipairs(data) do
		fun[t[1]](grid, select(2, unpack(t)))
	end

	for _, row in ipairs(grid) do
		for _, col in ipairs(row) do
			io.write(col)
			if col == "#" then
				result = result + 1
			end
		end
		print()
	end

	return result, grid
end

-- I had already printed the grid in part 1 so I didn't need
-- to do this; I just did it because why not.
local grid
function M.p2(file)
	_, grid = M.p1(file)
end

function M.draw()
	for y = 1, #grid do
		for x = 1, #grid[y] do
			if grid[y][x] == "#" then
				love.graphics.rectangle("fill", x * 12, y * 12, 11, 11)
			end
		end
	end
end

return M
