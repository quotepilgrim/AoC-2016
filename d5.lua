---@diagnostic disable: param-type-mismatch

local M = {}
local data

local function validate_hash(str, i)
	local hash = love.data.encode("string", "hex", love.data.hash("md5", str .. tostring(i)))
	return hash:sub(1, 5) == "00000", hash
end

function M.load(argv)
	data = argv.i
end

function M.p1(file, pt2)
	data = data or file:read()
	local result = {}

	if file then
		file:close()
	end

	local i = 0
	local char_count = 0
	while char_count < 8 do
		while true do
			i = i + 1
			local valid, hash = validate_hash(data, i)
			if valid then
				if not pt2 then
					table.insert(result, hash:sub(6, 6))
					char_count = char_count + 1
				else
					local pos, char = hash:sub(6, 7):match("(.)(.)") -- he he
					pos = pos < "8" and tonumber(pos)
					if pos and not result[pos + 1] then
						result[pos + 1] = char
						char_count = char_count + 1
					end
				end
				print(hash)
				break
			end
		end
	end

	return table.concat(result)
end

function M.p2(file)
	return M.p1(file, true)
end

return M
