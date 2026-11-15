-- EggHub v1 - Roblox Studio learning project
-- Install as a LocalScript in StarterPlayer > StarterPlayerScripts.
-- This is NOT an executor cheat and does not interact with public-game internals.
-- Scanner only reads Egg-tagged BaseParts in an experience you own/control.

local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local existing = playerGui:FindFirstChild("EggHub")
if existing then existing:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "EggHub"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local function round(instance, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = instance
end

local panel = Instance.new("Frame")
panel.Name = "Window"
panel.Size = UDim2.fromOffset(540, 400)
panel.Position = UDim2.new(0.5, -270, 0.5, -200)
panel.BackgroundColor3 = Color3.fromRGB(17, 21, 31)
panel.BorderSizePixel = 0
panel.Parent = gui
round(panel, 12)

local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 52)
top.BackgroundColor3 = Color3.fromRGB(28, 36, 52)
top.BorderSizePixel = 0
top.Parent = panel
round(top, 12)

local heading = Instance.new("TextLabel")
heading.BackgroundTransparency = 1
heading.Position = UDim2.fromOffset(16, 0)
heading.Size = UDim2.new(1, -65, 1, 0)
heading.Font = Enum.Font.GothamBold
heading.Text = "EGGHUB  /  BREAK & STEAL"
heading.TextColor3 = Color3.fromRGB(240, 245, 255)
heading.TextSize = 17
heading.TextXAlignment = Enum.TextXAlignment.Left
heading.Parent = top

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(34, 30)
close.Position = UDim2.new(1, -46, 0, 11)
close.BackgroundColor3 = Color3.fromRGB(166, 62, 76)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.GothamBold
close.TextSize = 13
close.Parent = top
round(close, 7)
close.Activated:Connect(function() gui:Destroy() end)

-- Drag window
local UserInputService = game:GetService("UserInputService")
local dragging, dragStart, startPosition
top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = panel.Position
    end
end)
top.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
    end
end)

local nav = Instance.new("Frame")
nav.Position = UDim2.fromOffset(12, 64)
nav.Size = UDim2.fromOffset(132, 324)
nav.BackgroundColor3 = Color3.fromRGB(24, 30, 44)
nav.BorderSizePixel = 0
nav.Parent = panel
round(nav, 9)

local body = Instance.new("Frame")
body.Position = UDim2.fromOffset(156, 64)
body.Size = UDim2.new(1, -168, 1, -76)
body.BackgroundColor3 = Color3.fromRGB(24, 30, 44)
body.BorderSizePixel = 0
body.Parent = panel
round(body, 9)

local pages = {}
local function newPage(name)
    local p = Instance.new("Frame")
    p.Name = name
    p.Size = UDim2.fromScale(1, 1)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.Parent = body
    pages[name] = p
    return p
end

local function text(parent, value, y, height, size, color, bold)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.fromOffset(15, y)
    label.Size = UDim2.new(1, -30, 0, height)
    label.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    label.Text = value
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.TextSize = size or 12
    label.TextColor3 = color or Color3.fromRGB(198, 210, 229)
    label.Parent = parent
    return label
end

local function button(parent, value, y, callback)
    local b = Instance.new("TextButton")
    b.Position = UDim2.fromOffset(15, y)
    b.Size = UDim2.new(1, -30, 0, 36)
    b.BackgroundColor3 = Color3.fromRGB(48, 94, 130)
    b.Text = value
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 12
    b.Parent = parent
    round(b, 7)
    b.Activated:Connect(callback)
    return b
end

local function toggle(parent, value, y)
    local enabled = false
    local b
    b = button(parent, value .. " : OFF", y, function()
        enabled = not enabled
        b.Text = value .. (enabled and " : ON" or " : OFF")
        b.BackgroundColor3 = enabled and Color3.fromRGB(37, 126, 91)
            or Color3.fromRGB(48, 94, 130)
        print("[EggHub] Demo toggle", value, enabled)
    end)
end

-- Main
local main = newPage("Main")
text(main, "MAIN", 14, 25, 16, Color3.fromRGB(241, 246, 255), true)
text(main, "EggHub interface loaded. This starter is intended for a Roblox experience you own or are authorized to develop.", 48, 62)
button(main, "Print status to Output", 120, function()
    print("[EggHub] Loaded for " .. player.Name)
end)

-- Scanner: authorized, tagged objects only
local scanner = newPage("Scanner")
text(scanner, "EGG SCANNER", 14, 25, 16, Color3.fromRGB(241, 246, 255), true)
text(scanner, "Scans BaseParts tagged 'Egg' in your own experience. Add the Egg tag in Studio's Tag Editor.", 48, 58)
local result = text(scanner, "No scan performed yet.", 116, 65, 12, Color3.fromRGB(120, 218, 164))
button(scanner, "Scan tagged Eggs", 190, function()
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local count, nearestName, nearestDistance = 0, "none", math.huge
    for _, item in ipairs(CollectionService:GetTagged("Egg")) do
        if item:IsA("BasePart") then
            count += 1
            if root then
                local distance = (root.Position - item.Position).Magnitude
                if distance < nearestDistance then
                    nearestName, nearestDistance = item.Name, distance
                end
            end
        end
    end
    if nearestDistance < math.huge then
        result.Text = string.format("%d tagged egg(s). Nearest: %s — %.1f studs.", count, nearestName, nearestDistance)
    else
        result.Text = string.format("%d tagged egg(s). No nearest distance available.", count)
    end
end)

-- Farming placeholders only
local farming = newPage("Farming")
text(farming, "FARMING", 14, 25, 16, Color3.fromRGB(241, 246, 255), true)
text(farming, "Demo toggles only. Connect these to server-authorized mechanics in your own experience.", 48, 60)
toggle(farming, "Auto Break demo", 120)
toggle(farming, "Auto Collect demo", 166)

-- Inventory placeholder
local inventory = newPage("Inventory")
text(inventory, "INVENTORY", 14, 25, 16, Color3.fromRGB(241, 246, 255), true)
text(inventory, "Inventory, merge, and fuse operations should be validated by the server in your own experience.", 48, 70)
button(inventory, "Print inventory placeholder", 130, function()
    print("[EggHub] Inventory module placeholder")
end)

-- Settings placeholder
local settings = newPage("Settings")
text(settings, "SETTINGS", 14, 25, 16, Color3.fromRGB(241, 246, 255), true)
text(settings, "Future options: scan interval, UI scale, and theme.", 48, 50)
toggle(settings, "Demo setting", 112)

local tabNames = {"Main", "Scanner", "Farming", "Inventory", "Settings"}
for index, name in ipairs(tabNames) do
    local tab = Instance.new("TextButton")
    tab.Position = UDim2.fromOffset(7, 8 + (index - 1) * 44)
    tab.Size = UDim2.new(1, -14, 0, 36)
    tab.BackgroundColor3 = Color3.fromRGB(43, 54, 76)
    tab.Text = name
    tab.TextColor3 = Color3.fromRGB(226, 235, 249)
    tab.Font = Enum.Font.GothamSemibold
    tab.TextSize = 12
    tab.Parent = nav
    round(tab, 7)
    tab.Activated:Connect(function()
        for pageName, p in pairs(pages) do
            p.Visible = (pageName == name)
        end
    end)
end

pages.Main.Visible = true
print("[EggHub] Ready. This is a Studio LocalScript, not a Delta executor payload.")
