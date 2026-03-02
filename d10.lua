local M = {}

local s = "aaaaaaaaa"

local i = 1

while i < #s do
	print(s:sub(i))
	i = i + 1
end

return M
