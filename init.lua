-- globals

local ezwand = dofile_once("mods/wand_speed/files/ezwand.lua")
local player = nil
local inventory_pause = false

--

local function reverseTable(origTable)
    local reversedTable = {}
    local itemCount = #origTable

    for i = itemCount, 1, -1 do
        table.insert(reversedTable, origTable[i])
    end

    return reversedTable
end

local function GetInventoryWands()
    local items = GameGetAllInventoryItems(player) or {}

    local _wands_speed_stats = {}

    for k, v in pairs(items) do
        if v ~= 0 and ezwand.IsWand(v) then
            local wand = ezwand(v)
            table.insert(_wands_speed_stats, tonumber(string.format("%.2f", wand.speedMultiplier)))
        end
    end

    return reverseTable(_wands_speed_stats)
end


function OnPlayerSpawned(player_entity)
    player = player_entity
end

function OnPausedChanged( is_paused, is_inventory_pause  )
    if is_inventory_pause then
        inventory_pause = true
    else
        inventory_pause = false
    end
end

function OnPausePreUpdate()
    if inventory_pause then
        gui = gui or GuiCreate()

        local text_x_index = 60
        local text_y_index = 31
        local gap = 20

        local wands_speed_stats = GetInventoryWands()

        GuiStartFrame(gui)

        GuiBeginAutoBox(gui)

        GuiText(gui, text_x_index, text_y_index, "Speed multiplier of wands:")

        text_y_index = text_y_index + gap

        for k, v in pairs(wands_speed_stats or {}) do
            GuiText(gui, text_x_index, text_y_index, (k .. ": " .. v))
            text_y_index = text_y_index + 10
        end

        GuiZSetForNextWidget(gui, 1)
        GuiEndAutoBoxNinePiece(gui)
    end
end

function OnWorldPreUpdate()
    if GameIsInventoryOpen() == true then
        gui = gui or GuiCreate()

        local text_x_index = 22
        local text_y_index = 330
        local gap = 12

        local wands_speed_stats = GetInventoryWands()

        GuiStartFrame(gui)

        GuiBeginAutoBox(gui)

        GuiText(gui, text_x_index, text_y_index, "Speed multiplier of wands:")

        text_y_index = text_y_index + gap

        for k, v in pairs(wands_speed_stats or {}) do
            local text = k .. ": " .. v
            GuiText(gui, text_x_index, text_y_index, text)
            local text_x_dimention, text_y_dimention = GuiGetTextDimensions(gui, text)

            text_x_index = text_x_index + text_x_dimention + 5
        end

        GuiZSetForNextWidget(gui, 1)
        GuiEndAutoBoxNinePiece(gui, 2)
    end
end