-- AGALIK HUB v4.1 | Enhanced
-- Исправленная версия: кнопки пониже, без Combat вкладки

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Случайный ID
local randomID = HttpService:GenerateGUID(false):sub(1, 8)

-- Стиль как на скриншоте
local theme = {
    primary = Color3.fromRGB(15, 15, 25),
    secondary = Color3.fromRGB(25, 25, 35),
    accent = Color3.fromRGB(0, 120, 215),
    text = Color3.fromRGB(240, 240, 240),
    subtext = Color3.fromRGB(180, 180, 200),
    success = Color3.fromRGB(0, 200, 83),
    warning = Color3.fromRGB(255, 184, 0),
    danger = Color3.fromRGB(235, 77, 75),
    border = Color3.fromRGB(40, 40, 60)
}

-- Создание GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AgalikHub_" .. randomID
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

-- Размещение GUI
if gethui then
    screenGui.Parent = gethui()
elseif game:GetService("CoreGui") then
    screenGui.Parent = game:GetService("CoreGui")
else
    screenGui.Parent = player:WaitForChild("PlayerGui")
end

-- Основной контейнер
local mainContainer = Instance.new("Frame")
mainContainer.Name = "Main"
mainContainer.Size = UDim2.new(0, 500, 0, 400)
mainContainer.Position = UDim2.new(0.5, -250, 0.5, -200)
mainContainer.BackgroundColor3 = theme.primary
mainContainer.BackgroundTransparency = 0
mainContainer.BorderSizePixel = 1
mainContainer.BorderColor3 = Color3.fromRGB(40, 40, 60)
mainContainer.ClipsDescendants = true
mainContainer.Visible = false
mainContainer.Parent = screenGui

-- Заголовок как на скриншоте
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
header.BorderSizePixel = 0
header.Parent = mainContainer

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "AGALIK HUB v4.1 | Enhanced"
title.TextColor3 = theme.accent
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "Close"
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 20
closeBtn.Parent = header

-- Боковая панель с вкладками
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 120, 1, -40)
sidebar.Position = UDim2.new(0, 0, 0, 40)
sidebar.BackgroundColor3 = theme.secondary
sidebar.BorderSizePixel = 0
sidebar.Parent = mainContainer

-- Основная область контента
local contentArea = Instance.new("Frame")
contentArea.Name = "Content"
contentArea.Size = UDim2.new(1, -120, 1, -40)
contentArea.Position = UDim2.new(0, 120, 0, 40)
contentArea.BackgroundColor3 = theme.primary
contentArea.BorderSizePixel = 0
contentArea.ClipsDescendants = true
contentArea.Parent = mainContainer

-- Вкладки (без Combat)
local tabs = {
    {Name = "Player", Icon = "👤", Color = theme.accent},
    {Name = "Visual", Icon = "👁️", Color = Color3.fromRGB(0, 200, 255)},
    {Name = "Teleport", Icon = "📍", Color = Color3.fromRGB(255, 184, 0)},
    {Name = "Fun", Icon = "🎮", Color = Color3.fromRGB(235, 77, 75)},
    {Name = "Settings", Icon = "⚙️", Color = Color3.fromRGB(100, 200, 100)},
    {Name = "Credits", Icon = "⭐", Color = Color3.fromRGB(255, 215, 0)}
}

local tabFrames = {}
local tabButtons = {}
local activeTab = 1

-- Создаем вкладки
for i, tab in ipairs(tabs) do
    -- Кнопка вкладки
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tab.Name .. "Tab"
    tabButton.Size = UDim2.new(1, 0, 0, 50) -- Немного выше
    tabButton.Position = UDim2.new(0, 0, 0, (i-1) * 55)
    tabButton.BackgroundColor3 = i == 1 and Color3.fromRGB(30, 30, 50) or theme.secondary
    tabButton.BorderSizePixel = 0
    tabButton.AutoButtonColor = false
    tabButton.Font = Enum.Font.Gotham
    tabButton.Text = ""
    tabButton.Parent = sidebar
    
    local icon = Instance.new("TextLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 30, 0, 30)
    icon.Position = UDim2.new(0, 15, 0, 10)
    icon.BackgroundTransparency = 1
    icon.Font = Enum.Font.Gotham
    icon.Text = tab.Icon
    icon.TextColor3 = i == 1 and tab.Color or theme.subtext
    icon.TextSize = 18
    icon.Parent = tabButton
    
    local text = Instance.new("TextLabel")
    text.Name = "Text"
    text.Size = UDim2.new(1, -10, 0, 20)
    text.Position = UDim2.new(0, 5, 0, 30)
    text.BackgroundTransparency = 1
    text.Font = Enum.Font.Gotham
    text.Text = tab.Name
    text.TextColor3 = i == 1 and theme.text or theme.subtext
    text.TextSize = 12
    text.TextXAlignment = Enum.TextXAlignment.Center
    text.Parent = tabButton
    
    -- Индикатор выбранной вкладки
    if i == 1 then
        local indicator = Instance.new("Frame")
        indicator.Name = "Indicator"
        indicator.Size = UDim2.new(0, 3, 0.8, 0)
        indicator.Position = UDim2.new(1, -3, 0.1, 0)
        indicator.BackgroundColor3 = tab.Color
        indicator.BorderSizePixel = 0
        indicator.Parent = tabButton
    end
    
    -- Фрейм контента
    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Name = tab.Name .. "Content"
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.BorderSizePixel = 0
    tabFrame.ScrollBarThickness = 4
    tabFrame.ScrollBarImageColor3 = tab.Color
    tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabFrame.Visible = i == 1
    tabFrame.Parent = contentArea
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = tabFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 15)
    padding.PaddingLeft = UDim.new(0, 15)
    padding.PaddingRight = UDim.new(0, 15)
    padding.Parent = tabFrame
    
    tabButtons[i] = tabButton
    tabFrames[i] = tabFrame
    
    -- Обработчик клика
    tabButton.MouseButton1Click:Connect(function()
        activeTab = i
        for idx, btn in ipairs(tabButtons) do
            btn.BackgroundColor3 = idx == i and Color3.fromRGB(30, 30, 50) or theme.secondary
            btn:FindFirstChild("Icon").TextColor3 = idx == i and tabs[idx].Color or theme.subtext
            btn:FindFirstChild("Text").TextColor3 = idx == i and theme.text or theme.subtext
            tabFrames[idx].Visible = idx == i
            
            -- Индикатор
            local oldIndicator = btn:FindFirstChild("Indicator")
            if oldIndicator then
                oldIndicator:Destroy()
            end
            
            if idx == i then
                local indicator = Instance.new("Frame")
                indicator.Name = "Indicator"
                indicator.Size = UDim2.new(0, 3, 0.8, 0)
                indicator.Position = UDim2.new(1, -3, 0.1, 0)
                indicator.BackgroundColor3 = tabs[idx].Color
                indicator.BorderSizePixel = 0
                indicator.Parent = btn
            end
        end
    end)
end

-- Кнопка открытия меню
local openButton = Instance.new("TextButton")
openButton.Name = "OpenBtn"
openButton.Size = UDim2.new(0, 50, 0, 50)
openButton.Position = UDim2.new(1, -60, 0, 20)
openButton.BackgroundColor3 = theme.accent
openButton.BorderSizePixel = 0
openButton.AutoButtonColor = false
openButton.Font = Enum.Font.GothamBold
openButton.Text = "A"
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.TextSize = 20
openButton.Visible = true
openButton.Parent = screenGui

-- Функция создания чекбокса (кнопка пониже и правее)
local function createCheckbox(parent, text, description, icon, default)
    local checkboxFrame = Instance.new("Frame")
    checkboxFrame.Name = text .. "Checkbox"
    checkboxFrame.Size = UDim2.new(1, -30, 0, 60) -- Выше фрейм
    checkboxFrame.BackgroundColor3 = theme.secondary
    checkboxFrame.BorderSizePixel = 0
    checkboxFrame.LayoutOrder = #parent:GetChildren()
    checkboxFrame.Parent = parent
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Name = "Icon"
    iconLabel.Size = UDim2.new(0, 35, 0, 35)
    iconLabel.Position = UDim2.new(0, 15, 0.5, -17.5)
    iconLabel.AnchorPoint = Vector2.new(0, 0.5)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Font = Enum.Font.Gotham
    iconLabel.Text = icon
    iconLabel.TextColor3 = theme.accent
    iconLabel.TextSize = 20
    iconLabel.Parent = checkboxFrame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Text"
    textLabel.Size = UDim2.new(0.6, -60, 0, 25)
    textLabel.Position = UDim2.new(0, 60, 0, 10)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Text = text
    textLabel.TextColor3 = theme.text
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = checkboxFrame
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Name = "Description"
    descLabel.Size = UDim2.new(0.6, -60, 0, 25)
    descLabel.Position = UDim2.new(0, 60, 0, 30)
    descLabel.BackgroundTransparency = 1
    descLabel.Font = Enum.Font.Gotham
    descLabel.Text = description
    descLabel.TextColor3 = theme.subtext
    descLabel.TextSize = 11
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = checkboxFrame
    
    -- КНОПКА ПОНИЖЕ И ПРАВЕЕ
    local checkboxBtn = Instance.new("TextButton")
    checkboxBtn.Name = "Checkbox"
    checkboxBtn.Size = UDim2.new(0, 70, 0, 25) -- Уже и ниже
    checkboxBtn.Position = UDim2.new(1, -80, 0.5, -12.5) -- Правее и ниже
    checkboxBtn.AnchorPoint = Vector2.new(1, 0.5)
    checkboxBtn.BackgroundColor3 = default and theme.success or Color3.fromRGB(60, 60, 80)
    checkboxBtn.BorderSizePixel = 0
    checkboxBtn.AutoButtonColor = false
    checkboxBtn.Font = Enum.Font.Gotham
    checkboxBtn.Text = default and "ON" or "OFF" -- Без скобок
    checkboxBtn.TextColor3 = default and Color3.fromRGB(255, 255, 255) or theme.subtext
    checkboxBtn.TextSize = 12
    checkboxBtn.Parent = checkboxFrame
    
    local checkboxCorner = Instance.new("UICorner")
    checkboxCorner.CornerRadius = UDim.new(0, 4)
    checkboxCorner.Parent = checkboxBtn
    
    return checkboxBtn
end

-- Функция создания кнопки (правая часть)
local function createActionButton(parent, text, description, icon)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = text .. "Button"
    buttonFrame.Size = UDim2.new(1, -30, 0, 70) -- Чуть выше
    buttonFrame.BackgroundColor3 = theme.secondary
    buttonFrame.BorderSizePixel = 0
    buttonFrame.LayoutOrder = #parent:GetChildren()
    buttonFrame.Parent = parent
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Name = "Icon"
    iconLabel.Size = UDim2.new(0, 40, 0, 40)
    iconLabel.Position = UDim2.new(0, 15, 0.5, -20)
    iconLabel.AnchorPoint = Vector2.new(0, 0.5)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Font = Enum.Font.Gotham
    iconLabel.Text = icon
    iconLabel.TextColor3 = theme.accent
    iconLabel.TextSize = 22
    iconLabel.Parent = buttonFrame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Text"
    textLabel.Size = UDim2.new(0.6, -70, 0, 25)
    textLabel.Position = UDim2.new(0, 70, 0, 15)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Text = text
    textLabel.TextColor3 = theme.text
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = buttonFrame
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Name = "Description"
    descLabel.Size = UDim2.new(0.6, -70, 0, 30)
    descLabel.Position = UDim2.new(0, 70, 0, 35)
    descLabel.BackgroundTransparency = 1
    descLabel.Font = Enum.Font.Gotham
    descLabel.Text = description
    descLabel.TextColor3 = theme.subtext
    descLabel.TextSize = 11
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextWrapped = true
    descLabel.Parent = buttonFrame
    
    local actionBtn = Instance.new("TextButton")
    actionBtn.Name = "Action"
    actionBtn.Size = UDim2.new(0, 90, 0, 30) -- Уже
    actionBtn.Position = UDim2.new(1, -100, 0.5, -15) -- Правее
    actionBtn.AnchorPoint = Vector2.new(1, 0.5)
    actionBtn.BackgroundColor3 = theme.accent
    actionBtn.BorderSizePixel = 0
    actionBtn.AutoButtonColor = false
    actionBtn.Font = Enum.Font.Gotham
    actionBtn.Text = "Execute"
    actionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    actionBtn.TextSize = 12
    actionBtn.Parent = buttonFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = actionBtn
    
    return actionBtn
end

-- ============================================
-- ВКЛАДКА PLAYER (наши функции)
-- ============================================

local playerTab = tabFrames[1]

-- NOCHIP
local nochipCheck = createCheckbox(
    playerTab,
    "NOCHIP",
    "Walk through walls",
    "🚶",
    false
)

local nochipEnabled = false
local nochipConnection

nochipCheck.MouseButton1Click:Connect(function()
    nochipEnabled = not nochipEnabled
    nochipCheck.BackgroundColor3 = nochipEnabled and theme.success or Color3.fromRGB(60, 60, 80)
    nochipCheck.Text = nochipEnabled and "ON" or "OFF"
    nochipCheck.TextColor3 = nochipEnabled and Color3.fromRGB(255, 255, 255) or theme.subtext
    
    if nochipEnabled then
        if nochipConnection then nochipConnection:Disconnect() end
        nochipConnection = RunService.Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if nochipConnection then
            nochipConnection:Disconnect()
            nochipConnection = nil
        end
    end
end)

-- SPEED HACK
local speedCheck = createCheckbox(
    playerTab,
    "SPEED HACK",
    "Run faster",
    "⚡",
    false
)

local speedEnabled = false
speedCheck.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    speedCheck.BackgroundColor3 = speedEnabled and theme.success or Color3.fromRGB(60, 60, 80)
    speedCheck.Text = speedEnabled and "ON" or "OFF"
    speedCheck.TextColor3 = speedEnabled and Color3.fromRGB(255, 255, 255) or theme.subtext
    
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speedEnabled and 50 or 16
    end
end)

-- JUMP POWER
local jumpCheck = createCheckbox(
    playerTab,
    "JUMP POWER",
    "Jump higher",
    "🦘",
    false
)

jumpCheck.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        local newJump = humanoid.JumpPower == 50 and 100 or 50
        humanoid.JumpPower = newJump
        
        jumpCheck.BackgroundColor3 = newJump == 100 and theme.success or Color3.fromRGB(60, 60, 80)
        jumpCheck.Text = newJump == 100 and "ON" or "OFF"
        jumpCheck.TextColor3 = newJump == 100 and Color3.fromRGB(255, 255, 255) or theme.subtext
    end
end)

-- INVISIBLE
local invisibleCheck = createCheckbox(
    playerTab,
    "INVISIBLE",
    "Become invisible",
    "👻",
    false
)

invisibleCheck.MouseButton1Click:Connect(function()
    if player.Character then
        local character = player.Character
        local newTransparency = 0
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                if part.Transparency == 0 then
                    part.Transparency = 1
                    newTransparency = 1
                else
                    part.Transparency = 0
                    newTransparency = 0
                end
            end
        end
        
        invisibleCheck.BackgroundColor3 = newTransparency == 1 and theme.success or Color3.fromRGB(60, 60, 80)
        invisibleCheck.Text = newTransparency == 1 and "ON" or "OFF"
        invisibleCheck.TextColor3 = newTransparency == 1 and Color3.fromRGB(255, 255, 255) or theme.subtext
    end
end)

-- ============================================
-- ВКЛАДКА VISUAL
-- ============================================

local visualTab = tabFrames[2]

-- ESP
local espCheck = createCheckbox(
    visualTab,
    "PLAYER ESP",
    "See players through walls",
    "👁️",
    false
)

-- Рисуем ESP через Drawing API
local espDrawings = {}
espCheck.MouseButton1Click:Connect(function()
    local enabled = espCheck.Text == "OFF"
    espCheck.BackgroundColor3 = enabled and theme.success or Color3.fromRGB(60, 60, 80)
    espCheck.Text = enabled and "ON" or "OFF"
    espCheck.TextColor3 = enabled and Color3.fromRGB(255, 255, 255) or theme.subtext
    
    if enabled then
        -- Создаем Drawing объекты
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player then
                espDrawings[p] = {
                    box = Drawing.new("Square"),
                    name = Drawing.new("Text"),
                    health = Drawing.new("Text")
                }
                
                espDrawings[p].box.Visible = true
                espDrawings[p].box.Color = Color3.new(1, 0, 0)
                espDrawings[p].box.Thickness = 2
                espDrawings[p].box.Filled = false
                
                espDrawings[p].name.Visible = true
                espDrawings[p].name.Color = Color3.new(1, 1, 1)
                espDrawings[p].name.Size = 14
                espDrawings[p].name.Text = p.Name
                
                espDrawings[p].health.Visible = true
                espDrawings[p].health.Color = Color3.new(0, 1, 0)
                espDrawings[p].health.Size = 12
            end
        end
        
        -- Обновляем позиции
        RunService.RenderStepped:Connect(function()
            for p, drawings in pairs(espDrawings) do
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                    if onScreen then
                        drawings.box.Visible = true
                        drawings.box.Position = Vector2.new(pos.X - 25, pos.Y - 40)
                        drawings.box.Size = Vector2.new(50, 80)
                        
                        drawings.name.Visible = true
                        drawings.name.Position = Vector2.new(pos.X, pos.Y - 50)
                        
                        local health = p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health or 100
                        drawings.health.Text = math.floor(health) .. " HP"
                        drawings.health.Position = Vector2.new(pos.X, pos.Y + 45)
                    else
                        drawings.box.Visible = false
                        drawings.name.Visible = false
                        drawings.health.Visible = false
                    end
                end
            end
        end)
    else
        -- Удаляем Drawing объекты
        for _, drawings in pairs(espDrawings) do
            drawings.box:Remove()
            drawings.name:Remove()
            drawings.health:Remove()
        end
        espDrawings = {}
    end
end)

-- X-RAY
local xrayCheck = createCheckbox(
    visualTab,
    "X-RAY",
    "See through walls",
    "🔍",
    false
)

xrayCheck.MouseButton1Click:Connect(function()
    local enabled = xrayCheck.Text == "OFF"
    xrayCheck.BackgroundColor3 = enabled and theme.success or Color3.fromRGB(60, 60, 80)
    xrayCheck.Text = enabled and "ON" or "OFF"
    xrayCheck.TextColor3 = enabled and Color3.fromRGB(255, 255, 255) or theme.subtext
    
    if enabled then
        workspace.CurrentCamera.LocalTransparencyModifier = 0.5
    else
        workspace.CurrentCamera.LocalTransparencyModifier = 0
    end
end)

-- FULLBRIGHT
local brightCheck = createCheckbox(
    visualTab,
    "FULLBRIGHT",
    "Remove darkness",
    "💡",
    false
)

brightCheck.MouseButton1Click:Connect(function()
    local enabled = brightCheck.Text == "OFF"
    brightCheck.BackgroundColor3 = enabled and theme.success or Color3.fromRGB(60, 60, 80)
    brightCheck.Text = enabled and "ON" or "OFF"
    brightCheck.TextColor3 = enabled and Color3.fromRGB(255, 255, 255) or theme.subtext
    
    if enabled then
        Lighting.GlobalShadows = false
        Lighting.Brightness = 2
    else
        Lighting.GlobalShadows = true
        Lighting.Brightness = 1
    end
end)

-- ============================================
-- ВКЛАДКА TELEPORT (кнопки справа)
-- ============================================

local teleportTab = tabFrames[3]

-- Guard Room
local guardBtn = createActionButton(
    teleportTab,
    "GUARD ROOM",
    "Teleport to guard room",
    "👮"
)

guardBtn.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(807.032, 99.99, 2307.153)
    end
end)

-- Yard
local yardBtn = createActionButton(
    teleportTab,
    "PRISON YARD",
    "Teleport to yard",
    "🏀"
)

yardBtn.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(803, 98, 2457)
    end
end)

-- Criminal Base
local crimBtn = createActionButton(
    teleportTab,
    "CRIMINAL BASE",
    "Teleport to criminal spawn",
    "🔫"
)

crimBtn.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(-920, 94, 2137)
    end
end)

-- ============================================
-- ВКЛАДКА FUN
-- ============================================

local funTab = tabFrames[4]

-- Spawn Cube
local cubeBtn = createActionButton(
    funTab,
    "SPAWN CUBE",
    "Create platform",
    "◼"
)

local cubes = {}
cubeBtn.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local cube = Instance.new("Part")
        cube.Name = "Cube"
        cube.Size = Vector3.new(5, 5, 5)
        cube.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, -5, 0)
        cube.Anchored = true
        cube.CanCollide = true
        cube.Color = Color3.fromRGB(math.random(50, 255), math.random(50, 255), math.random(50, 255))
        cube.Material = Enum.Material.Neon
        cube.Parent = Workspace
        table.insert(cubes, cube)
    end
end)

-- Grenade Rain
local grenadeBtn = createActionButton(
    funTab,
    "GRENADE RAIN",
    "Spawn explosions",
    "💣"
)

grenadeBtn.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        for i = 1, 10 do
            local grenade = Instance.new("Part")
            grenade.Name = "Grenade"
            grenade.Shape = Enum.PartType.Ball
            grenade.Size = Vector3.new(2, 2, 2)
            grenade.Position = player.Character.HumanoidRootPart.Position + Vector3.new(
                math.random(-20, 20),
                math.random(20, 40),
                math.random(-20, 20)
            )
            grenade.Color = Color3.fromRGB(255, 50, 50)
            grenade.Parent = Workspace
            
            local explosion = Instance.new("Explosion")
            explosion.Position = grenade.Position
            explosion.BlastRadius = 10
            explosion.Parent = Workspace
            
            task.wait(0.1)
        end
    end
end)

-- Clear Cubes
local clearBtn = createActionButton(
    funTab,
    "CLEAR CUBES",
    "Remove all spawned cubes",
    "🗑️"
)

clearBtn.MouseButton1Click:Connect(function()
    for _, cube in pairs(cubes) do
        if cube and cube.Parent then
            cube:Destroy()
        end
    end
    cubes = {}
end)

-- ============================================
-- ВКЛАДКА SETTINGS
-- ============================================

local settingsTab = tabFrames[5]

-- UI Transparency
local transCheck = createCheckbox(
    settingsTab,
    "UI TRANSPARENCY",
    "Make menu transparent",
    "👁️",
    false
)

transCheck.MouseButton1Click:Connect(function()
    local enabled = transCheck.Text == "OFF"
    transCheck.BackgroundColor3 = enabled and theme.success or Color3.fromRGB(60, 60, 80)
    transCheck.Text = enabled and "ON" or "OFF"
    transCheck.TextColor3 = enabled and Color3.fromRGB(255, 255, 255) or theme.subtext
    
    mainContainer.BackgroundTransparency = enabled and 0.5 or 0
end)

-- Keybind
local keybindBtn = createActionButton(
    settingsTab,
    "CHANGE KEYBIND",
    "Change menu toggle key",
    "⌨️"
)

keybindBtn.MouseButton1Click:Connect(function()
    keybindBtn.Text = "Press key..."
    local connection
    connection = UIS.InputBegan:Connect(function(input)
        if input.KeyCode ~= Enum.KeyCode.Unknown then
            keybindBtn.Text = "Key: " .. input.KeyCode.Name
            connection:Disconnect()
        end
    end)
end)

-- Save Settings
local saveBtn = createActionButton(
    settingsTab,
    "SAVE SETTINGS",
    "Save current configuration",
    "💾"
)

-- ============================================
-- ВКЛАДКА CREDITS
-- ============================================

local creditsTab = tabFrames[6]

-- Текст в credits
local creditsText = Instance.new("TextLabel")
creditsText.Name = "CreditsText"
creditsText.Size = UDim2.new(1, -30, 1, -30)
creditsText.Position = UDim2.new(0, 15, 0, 15)
creditsText.BackgroundTransparency = 1
creditsText.Font = Enum.Font.Gotham
creditsText.Text = "AGALIK HUB v4.1 | Enhanced\n\n" ..
                   "Created by: " .. player.Name .. "\n\n" ..
                   "Special thanks to:\n" ..
                   "• Roblox Prison Life\n" ..
                   "• All testers\n" ..
                   "• Supporters\n\n" ..
                   "Version: 4.1.0\n" ..
                   "Last Updated: Today\n" ..
                   "Menu Style: Fixed & Improved"
creditsText.TextColor3 = theme.text
creditsText.TextSize = 14
creditsText.TextXAlignment = Enum.TextXAlignment.Left
creditsText.TextYAlignment = Enum.TextYAlignment.Top
creditsText.TextWrapped = true
creditsText.Parent = creditsTab

-- ============================================
-- УПРАВЛЕНИЕ МЕНЮ
-- ============================================

local menuVisible = false

local function toggleMenu()
    menuVisible = not menuVisible
    
    if menuVisible then
        mainContainer.Visible = true
        openButton.Visible = false
    else
        mainContainer.Visible = false
        openButton.Visible = true
    end
end

-- Кнопки
openButton.MouseButton1Click:Connect(toggleMenu)
closeBtn.MouseButton1Click:Connect(toggleMenu)

-- Горячая клавиша
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        toggleMenu()
    end
end)

-- Перетаскивание окна
local dragging = false
local dragStart, startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainContainer.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainContainer.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- ============================================
-- ЗАГРУЗКА
-- ============================================

task.wait(1)
print("========================================")
print("AGALIK HUB v4.1 | Enhanced")
print("========================================")
print("Menu Style: Fixed (buttons lower & right)")
print("No Combat tab (removed)")
print("Keybind: RightControl")
print("Tabs: Player, Visual, Teleport, Fun, Settings, Credits")
print("========================================")
