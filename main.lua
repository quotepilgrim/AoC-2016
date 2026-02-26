local result, day, fg, bg, font, small_font, big_font
local argv = {}
local drops = {}
local random = love.math.random
local max = math.max
local ww, wh = 800, 600

local function reset_drop(drop, init)
	if init then
		drop.w = love.graphics.getFont():getWidth(result)
		drop.h = love.graphics.getFont():getHeight()
		drop.y = random(-wh, wh)
	else
		drop.y = -drop.h
	end

	drop.x = random(-drop.w, ww)
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
				if #a == 2 then
					break
				end
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

	local function dark_color()
		local t = {}
		for _ = 1, 3 do
			table.insert(t, random() / 3)
		end
		return t
	end

	local function light_color()
		local t = {}
		for _ = 1, 3 do
			table.insert(t, (random() / 2.5 + 0.6))
		end
		return t
	end

	argv.day = argv.day or argv.d
	argv.part = argv.part or argv.p
	argv.file = argv.file or argv.f
	argv.input = argv.input or argv.i

	day = require("d" .. (argv.d or argv.day))
	local part = argv.part or "1"
	local filename = argv.file
	local nofile = argv.nofile or argv.input

	local color = argv.color or (not argv.mono and random() < 0.25)
	local light = argv.light or (not argv.dark and random() < 0.1)
	bg = color and dark_color() or { 0, 0, 0 }
	fg = color and light_color() or { 1, 1, 1 }

	if light then
		bg, fg = fg, bg
	end

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
	small_font = love.graphics.newFont(48)
	big_font = love.graphics.newFont(128)
	love.graphics.setFont(small_font)

	part = part:sub(1, 1):match("%d") == nil and part or "p" .. part
	filename = filename or ("inputs/d" .. argv.d .. ".txt")
	result = day[part] and day[part](not nofile and assert(io.open(filename)))

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
		print(love.filesystem.isFused())
	end
end

function love.draw()
	love.graphics.clear(bg)
	for _, drop in ipairs(drops) do
		love.graphics.setColor(fg[1], fg[2], fg[3], drop.opacity)
		love.graphics.print(result, drop.x, drop.y, 0, drop.scale)
	end
end

function love.update(dt)
	for _, drop in ipairs(drops) do
		drop.y = drop.y + drop.speed * dt
		if drop.y > wh then
			reset_drop(drop)
		end
	end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	elseif key == "f" then
		local flags = select(3, love.window.getMode())

		love.window.setMode(
			800,
			600,
			{ fullscreen = not flags.fullscreen, fullscreentype = "desktop", resizable = true }
		)

		love.resize(love.window:getMode())

		if not flags.fullscreen then
			love.graphics.setFont(big_font)
		else
			love.graphics.setFont(small_font)
		end

		for _, drop in ipairs(drops) do
			reset_drop(drop, true)
		end
	end

	return day.keypressed and day.keypressed(key)
end

function love.resize(w, h)
	ww = w
	wh = h
end
