local M = {}

local bots = {}
local outputs = {}

local function load_data(file)
    local data = {}
    for line in file:lines() do
        local matches = line:gmatch("(%w+) (%d+)")
        local row = {}

        for a, b in matches do
            table.insert(row, a)
            table.insert(row, tonumber(b))
        end

        table.insert(data, row)
    end
    return data
end

function M.p1(file)
    local data = load_data(file)
    local result

    for i = #data, 1, -1 do
        local t = data[i]
        print(table.concat(t, " "))
        if t[1] == "value" then
            bots[t[4]] = bots[t[4]] or {}
            table.insert(bots[t[4]], t[2])
            table.remove(data, i)
        end
    end

    local moved = true
    while moved do
        moved = false
        for _, t in ipairs(data) do
            if bots[t[2]] and #bots[t[2]] == 2 then
                moved = true
                local low = table.remove(bots[t[2]])
                local high = table.remove(bots[t[2]])

                if low > high then
                    low, high = high, low
                    if low == 17 and high == 61 then
                        result = t[2]
                    end
                end

                if t[3] == "bot" then
                    bots[t[4]] = bots[t[4]] or {}
                    table.insert(bots[t[4]], low)
                else
                    outputs[t[4]] = outputs[t[4]] or {}
                    table.insert(outputs[t[4]], low)
                end

                if t[5] == "bot" then
                    bots[t[6]] = bots[t[6]] or {}
                    table.insert(bots[t[6]], high)
                else
                    outputs[t[6]] = outputs[t[6]] or {}
                    table.insert(outputs[t[6]], low)
                end
            end
        end
    end

    return result
end

function M.p2(file)
    M.p1(file)
    return outputs[0][1] * outputs[1][1] * outputs[2][1]
end

return M
