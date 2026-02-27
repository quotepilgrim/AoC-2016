local M = {}

local function decompress(s)
	local i = 1
	local result = {}

	while i <= #s do
		local c = s:sub(i, i)

		if c == "(" then
			::again::

			local marker = ""
			i = i + 1

			while c ~= ")" do
				c = s:sub(i, i)
				marker = marker .. c
				i = i + 1
			end

			local l, r = marker:match("(%d+)x(%d+)")
			local str = ""

			for _ = 1, tonumber(l) do
				c = s:sub(i, i)
				str = str .. c
				i = i + 1
			end

			for _ = 1, tonumber(r) do
				table.insert(result, str)
				c = s:sub(i, i)
			end

			if c == "(" then
				goto again -- yes, yes, I know
			end
		end

		table.insert(result, c)
		i = i + 1
	end

	return table.concat(result)
end

local function decompress_v2(s)
	return 0
end

function M.p1(file)
	if not file then
		return M.test(decompress)
	end

	local data = file:read()
	file:close()

	return #decompress(data)
end

function M.p2(file)
	if not file then
		return M.test(decompress_v2)
	end

	local data = file:read()
	file:close()

	return decompress_v2(data)
end

function M.test(decomp_fun)
	local test = {
		"ADVENT",
		"A(1x5)BC",
		"(3x3)XYZ",
		"A(2x2)BCD(2x2)EFG",
		"(6x1)(1x3)A",
		"X(8x2)(3x3)ABCY",
	}

	for _, s in ipairs(test) do
		local res = decomp_fun(s)
		local n = type(res) == "string" and #res or ""

		print(("%-24s %-24s %s"):format(s, res, n))
	end

	love.event.quit()
end

return M
