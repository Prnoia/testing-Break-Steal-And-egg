from pathlib import Path
p = Path("/mnt/data/EggESP_Delta_Visual_Simulator.lua")
code = r'''--[[
EGG ESP — VISUAL SIMULATOR (mock data only)
Purpose: demonstrate a Delta-style hub UI and ESP-like screen labels using
synthetic/mock egg entries. This script DOES NOT scan Workspace, inspect game
internals, locate real eggs, automate stealing, or interact with the game.

Run in a Roblox client Lua environment for UI testing.
All marker positions and egg entries below are simulated.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local DATABASE = {
    {name="Rock Egg", zone="Forest", rarity="Common"},
    {name="Forest Egg", zone="Forest", rarity="Common"},
    {name="Cactus Egg", zone="Desert", rarity="Uncommon"},
    {name="Bones Egg", zone="Desert", rarity="Uncommon"},
    {name="Frozen Egg", zone="Snowy", rarity="Rare"},
    {name="Yeti Egg", zone="Snowy", rarity="Rare"},
    {name="Easter Bunny Egg", zone="Candy", rarity="Epic"},
    {name="Candy Egg", zone="Candy", rarity="Epic"},
    {name="Rainbow Egg", zone="Candy", rarity="Epic"},
    {name="Gooey Egg", zone="Swamp", rarity="Legendary"},
    {name="Tree Egg", zone="Swamp", rarity="Legendary"},
    {name="Lake Egg", zone="Swamp", rarity="Legendary"},
    {name="Sea Stones Egg", zone="Ocean", rarity="Mythic"},
    {name="Water Egg", zone="Ocean", rarity="Mythic"},
    {name="Sea Egg", zone="Ocean", rarity="Mythic"},
    {name="Fallen Angel Egg", zone="Hell", rarity="Divine"},
    {name="Angel Egg", zone="Hell", rarity="Divine"},
    {name="Volcanic Egg", zone="Hell", rarity="Divine"},
    {name="Blossom Egg", zone="Blossom", rarity="Cosmic"},
    {name="Bamboo Egg", zone="Blossom", rarity="Cosmic"},
    {name="Fortune Egg", zone="Blossom", rarity="Cosmic"},
    {name="Sun Egg", zone="Galaxy", rarity="Secret"},
    {name="Starry Egg", zone="Galaxy", rarity="Secret"},
    {name="Blackhole Egg", zone="Galaxy", rarity="Secret"},
}

local ZONES = {"All", "Forest", "Desert", "Snowy", "Candy", "Swamp", "Ocean", "Hell", "Blossom", "Galaxy"}
local RARITIES = {"All", "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Divine", "Cosmic", "Secret"}
local COLORS = {
    Common = Color3.fromRGB(190,190,190),
    Uncommon = Color3.fromRGB(95,210,115),
    Rare = Color3.fromRGB(75,155,255),
    Epic = Color3.fromRGB(190,105,255),
    Legendary = Color3.fromRGB(255,170,55),
    Mythic = Color3.fromRGB(255,85,105),
    Divine = Color3.fromRGB(255,225,100),
    Cosmic = Color3.fromRGB(90,220,255),
    Secret = Color3.fromRGB(255,100,220),
}

local old = playerGui:FindFirstChild("EggESP_VisualSimulator")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "EggESP_VisualSimulator"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = playerGui

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k,v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local main = make("Frame", {
    Name="Main", Size=UDim2.fromOffset(360, 430),
    Position=UDim2.new(0, 28, 0.5, -215),
    BackgroundColor3=Color3.fromRGB(19,21,29), BorderSizePixel=0,
}, gui)
make("UICorner", {CornerRadius=UDim.new(0,12)}, main)
make("UIStroke", {Color=Color3.fromRGB(70,76,100), Thickness=1}, main)

local top = make("Frame", {
    Size=UDim2.new(1,0,0,54), BackgroundColor3=Color3.fromRGB(29,32,44),
    BorderSizePixel=0,
}, main)
make("UICorner", {CornerRadius=UDim.new(0,12)}, top)
local title = make("TextLabel", {
    Position=UDim2.fromOffset(15,7), Size=UDim2.new(1,-60,0,22),
    BackgroundTransparency=1, Text="EGG ESP  /  SIMULATOR",
    TextColor3=Color3.fromRGB(245,246,255), Font=Enum.Font.GothamBold,
    TextSize=15, TextXAlignment=Enum.TextXAlignment.Left,
}, top)
make("TextLabel", {
    Position=UDim2.fromOffset(15,29), Size=UDim2.new(1,-30,0,15),
    BackgroundTransparency=1, Text="MOCK DATA • VISUAL DEMO ONLY",
    TextColor3=Color3.fromRGB(145,155,180), Font=Enum.Font.Gotham,
    TextSize=9, TextXAlignment=Enum.TextXAlignment.Left,
}, top)

local close = make("TextButton", {
    Size=UDim2.fromOffset(28,28), Position=UDim2.new(1,-38,0,12),
    BackgroundColor3=Color3.fromRGB(75,45,55), Text="×",
    TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=20,
    BorderSizePixel=0,
}, top)
make("UICorner", {CornerRadius=UDim.new(0,7)}, close)

local function sectionLabel(text, y)
    return make("TextLabel", {
        Position=UDim2.fromOffset(15,y), Size=UDim2.new(1,-30,0,18),
        BackgroundTransparency=1, Text=text, TextColor3=Color3.fromRGB(175,185,210),
        Font=Enum.Font.GothamBold, TextSize=10, TextXAlignment=Enum.TextXAlignment.Left,
    }, main)
end

sectionLabel("ZONE FILTER", 66)
local zoneIndex = 1
local rarityIndex = 1
local zoneButton = make("TextButton", {
    Position=UDim2.fromOffset(15,87), Size=UDim2.new(0.5,-20,0,32),
    BackgroundColor3=Color3.fromRGB(39,44,60), Text="Zone: All",
    TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamSemibold, TextSize=11,
    BorderSizePixel=0,
}, main)
make("UICorner", {CornerRadius=UDim.new(0,7)}, zoneButton)

local rarityButton = make("TextButton", {
    Position=UDim2.new(0.5,5,0,87), Size=UDim2.new(0.5,-20,0,32),
    BackgroundColor3=Color3.fromRGB(39,44,60), Text="Rarity: All",
    TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamSemibold, TextSize=11,
    BorderSizePixel=0,
}, main)
make("UICorner", {CornerRadius=UDim.new(0,7)}, rarityButton)

local espOn = true
local espButton = make("TextButton", {
    Position=UDim2.fromOffset(15,128), Size=UDim2.new(0.5,-20,0,32),
    BackgroundColor3=Color3.fromRGB(42,105,78), Text="ESP LABELS: ON",
    TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=10,
    BorderSizePixel=0,
}, main)
make("UICorner", {CornerRadius=UDim.new(0,7)}, espButton)

local countLabel = make("TextLabel", {
    Position=UDim2.new(0.5,5,0,128), Size=UDim2.new(0.5,-20,0,32),
    BackgroundColor3=Color3.fromRGB(39,44,60), Text="24 DATABASE ENTRIES",
    TextColor3=Color3.fromRGB(210,220,240), Font=Enum.Font.GothamBold,
    TextSize=9, BorderSizePixel=0,
}, main)
make("UICorner", {CornerRadius=UDim.new(0,7)}, countLabel)

sectionLabel("DETECTED EGGS  /  MOCK LIST", 171)
local listFrame = make("ScrollingFrame", {
    Position=UDim2.fromOffset(15,193), Size=UDim2.new(1,-30,0,145),
    BackgroundColor3=Color3.fromRGB(25,28,38), BorderSizePixel=0,
    ScrollBarThickness=4, CanvasSize=UDim2.fromOffset(0,0),
}, main)
make("UICorner", {CornerRadius=UDim.new(0,8)}, listFrame)
local listLayout = make("UIListLayout", {
    Padding=UDim.new(0,4), SortOrder=Enum.SortOrder.LayoutOrder,
}, listFrame)
make("UIPadding", {
    PaddingTop=UDim.new(0,7), PaddingBottom=UDim.new(0,7),
    PaddingLeft=UDim.new(0,7), PaddingRight=UDim.new(0,7),
}, listFrame)

sectionLabel("ESP PREVIEW  /  SYNTHETIC SCREEN MARKERS", 347)
local preview = make("Frame", {
    Position=UDim2.fromOffset(15,369), Size=UDim2.new(1,-30,0,45),
    BackgroundColor3=Color3.fromRGB(12,14,20), BorderSizePixel=0,
}, main)
make("UICorner", {CornerRadius=UDim.new(0,8)}, preview)
local markerLabels = {}

local function clearPreview()
    for _,v in ipairs(markerLabels) do
        if v and v.Parent then v:Destroy() end
    end
    table.clear(markerLabels)
end

local function refresh()
    for _,child in ipairs(listFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    clearPreview()
    local shown = {}
    for _,entry in ipairs(DATABASE) do
        local zoneOk = ZONES[zoneIndex] == "All" or entry.zone == ZONES[zoneIndex]
        local rarityOk = RARITIES[rarityIndex] == "All" or entry.rarity == RARITIES[rarityIndex]
        if zoneOk and rarityOk then table.insert(shown, entry) end
    end
    table.sort(shown, function(a,b) return a.name < b.name end)

    for i,entry in ipairs(shown) do
        local row = make("Frame", {
            Size=UDim2.new(1,-2,0,27), BackgroundColor3=Color3.fromRGB(34,38,51),
            BorderSizePixel=0, LayoutOrder=i,
        }, listFrame)
        make("UICorner", {CornerRadius=UDim.new(0,5)}, row)
        make("Frame", {
            Size=UDim2.fromOffset(3,17), Position=UDim2.fromOffset(6,5),
            BackgroundColor3=COLORS[entry.rarity], BorderSizePixel=0,
        }, row)
        make("TextLabel", {
            Position=UDim2.fromOffset(15,0), Size=UDim2.new(0.57,0,1,0),
            BackgroundTransparency=1, Text=entry.name, TextColor3=Color3.fromRGB(235,238,248),
            Font=Enum.Font.GothamSemibold, TextSize=10, TextXAlignment=Enum.TextXAlignment.Left,
        }, row)
        make("TextLabel", {
            Position=UDim2.new(0.60,0,0,0), Size=UDim2.new(0.40,-5,1,0),
            BackgroundTransparency=1, Text=entry.rarity, TextColor3=COLORS[entry.rarity],
            Font=Enum.Font.GothamBold, TextSize=9, TextXAlignment=Enum.TextXAlignment.Right,
        }, row)
    end
    listFrame.CanvasSize = UDim2.fromOffset(0, #shown * 31 + 14)
    countLabel.Text = tostring(#shown) .. " MOCK ENTRIES"

    if espOn then
        local previewCount = math.min(#shown, 3)
        for i=1,previewCount do
            local entry = shown[i]
            local marker = make("TextLabel", {
                Size=UDim2.fromOffset(112,30),
                Position=UDim2.new((i-1)*0.32 + 0.02,0,0,7),
                BackgroundColor3=Color3.fromRGB(27,31,42),
                BackgroundTransparency=0.08, BorderSizePixel=0,
                Text=entry.name .. "\n" .. entry.rarity,
                TextColor3=COLORS[entry.rarity], Font=Enum.Font.GothamBold,
                TextSize=8, TextWrapped=true,
            }, preview)
            make("UICorner", {CornerRadius=UDim.new(0,5)}, marker)
            make("UIStroke", {Color=COLORS[entry.rarity], Thickness=1}, marker)
            table.insert(markerLabels, marker)
        end
    end
end

zoneButton.MouseButton1Click:Connect(function()
    zoneIndex = zoneIndex % #ZONES + 1
    zoneButton.Text = "Zone: " .. ZONES[zoneIndex]
    refresh()
end)

rarityButton.MouseButton1Click:Connect(function()
    rarityIndex = rarityIndex % #RARITIES + 1
    rarityButton.Text = "Rarity: " .. RARITIES[rarityIndex]
    refresh()
end)

espButton.MouseButton1Click:Connect(function()
    espOn = not espOn
    espButton.Text = espOn and "ESP LABELS: ON" or "ESP LABELS: OFF"
    espButton.BackgroundColor3 = espOn and Color3.fromRGB(42,105,78) or Color3.fromRGB(85,55,60)
    refresh()
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Drag window by its header.
local dragging, dragStart, startPos
top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                  startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

refresh()
'''
p.write_text(code, encoding="utf-8")
print(p)
