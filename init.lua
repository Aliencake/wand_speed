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

local function render_widget(x, y, header, gap)
    gui = gui or GuiCreate()

    local text_x_index = x
    local text_y_index = y

    local wands_speed_stats = GetInventoryWands()

    GuiStartFrame(gui)

    GuiBeginAutoBox(gui)

    GuiText(gui, text_x_index, text_y_index, header)

    text_y_index = text_y_index + gap

    for k, v in pairs(wands_speed_stats or {}) do
        GuiText(gui, text_x_index, text_y_index, (k .. ": " .. v))
        text_y_index = text_y_index + 10
    end

    GuiZSetForNextWidget(gui, 1000)
    GuiEndAutoBoxNinePiece(gui)
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
        render_widget(60, 31, "Speed multiplier of wands:", 20)
    end
end

function OnWorldPreUpdate()
    if GameIsInventoryOpen() == true then
        render_widget(522, 10, "sm:", 15)
    end
end