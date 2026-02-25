local result, day
local argv = {}
local drops = {}
local random = love.math.random
local max = math.max
local sqrt = math.sqrt

local function reset_drop(drop, init)
	if init then
		drop.w = love.graphics.getFont():getWidth(result)
		drop.h = love.graphics.getFont():getHeight()
		drop.y = random(-600, 600)
	else
		drop.y = -drop.h
	end

	drop.x = random(-drop.w, 800)
	drop.speed = random() * 400
	drop.opacity = drop.speed / 400
	drop.scale = max(0.15, drop.opacity ^ 2)
end

function love.load(_, arg)
	while #arg > 0 do
		local a = table.remove(arg, 1)
		local v

		if a:sub(1, 1) == "-" then
			if a:sub(2, 2) == "-" then
				assert(#a ~= 3)
				a = a:sub(3)
				a = a == "" and "--" or a
			elseif #a > 2 then
				v = a:sub(3)
				a = a:sub(2, 2)
			else
				a = a:sub(2, 2)
				a = a == "" and "-" or a
			end

			if not v and arg[1] and arg[1]:sub(1, 1) ~= "-" then
				v = table.remove(arg, 1)
			elseif not v then
				v = true
			end

			argv[a] = v
		end
	end

	day = require("d" .. (argv.d or argv.day))
	local part = argv.p or argv.part or "1"
	local filename = argv.f or argv.file

	if day.load then
		day.load(argv)
	end

	if day.draw then
		love.draw = day.draw
	end

	if day.update then
		love.update = day.update
	end

	love.window.setTitle(love.window.getTitle() .. " - Day " .. argv.d .. " Part " .. part)
	love.graphics.setFont(love.graphics.newFont(48))

	part = part:sub(1, 1):match("%d") == nil and part or "p" .. part
	filename = filename or ("inputs/d" .. argv.d .. ".txt")
	result = day[part] and day[part](io.open(filename))

	if result then
		love.system.setClipboardText(result)
	else
		result = "???"
	end

	for _ = 1, 250 do
		local drop = {}
		reset_drop(drop, true)
		table.insert(drops, drop)
	end

	if argv.v or argv.verbose then
		for k, v in pairs(argv) do
			print(k, v)
		end
		print(filename)
	end
end

function love.draw()
	for _, drop in ipairs(drops) do
		love.graphics.setColor(1, 1, 1, drop.opacity)
		love.graphics.print(result, drop.x, drop.y, 0, drop.scale)
	end
end

function love.update(dt)
	for _, drop in ipairs(drops) do
		drop.y = drop.y + drop.speed * dt
		if drop.y > 600 then
			reset_drop(drop)
		end
	end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end

	return day.keypressed and day.keypressed(key)
end
