-- AGALIK HUB v5.1 | UNIVERSAL EDITION
-- Поддержка всех инжекторов и исполнителей

-- ============================================
-- ОПРЕДЕЛЕНИЕ ИСПОЛНИТЕЛЯ И ЕГО ВОЗМОЖНОСТЕЙ
-- ============================================

-- Определяем, какой исполнитель используется
local Executor = {
    Name = "Unknown",
    IsSynapse = false,
    IsScriptWare = false,
    IsKrnl = false,
    IsFluxus = false,
    IsOxygen = false,
    IsElectron = false,
    IsComet = false,
    IsCelery = false,
    IsCocoZ = false,
    IsJJsploit = false,
    IsXeno = false,
    IsHydrogen = false
}

-- Автоматическое определение
if syn and syn.protect_gui then
    Executor.Name = "Synapse X"
    Executor.IsSynapse = true
elseif secure_load then
    Executor.Name = "Script-Ware"
    Executor.IsScriptWare = true
elseif KRNL_LOADED then
    Executor.Name = "Krnl"
    Executor.IsKrnl = true
elseif fluxus then
    Executor.Name = "Fluxus"
    Executor.IsFluxus = true
elseif oxygen and oxygen.request then
    Executor.Name = "Oxygen U"
    Executor.IsOxygen = true
elseif electron then
    Executor.Name = "Electron"
    Executor.IsElectron = true
elseif comet then
    Executor.Name = "Comet"
    Executor.IsComet = true
elseif IS_CELERY_LOADED then
    Executor.Name = "Celery"
    Executor.IsCelery = true
elseif Cocoz then
    Executor.Name = "CocoZ"
    Executor.IsCocoZ = true
elseif jjsploit then
    Executor.Name = "JJsploit"
    Executor.IsJJsploit = true
elseif xeno then
    Executor.Name = "Xeno"
    Executor.IsXeno = true
elseif hydrogen then
    Executor.Name = "Hydrogen"
    Executor.IsHydrogen = true
end

-- Универсальные функции для всех инжекторов
local Universal = {
    ProtectGUI = function(gui)
        if syn and syn.protect_gui then
            syn.protect_gui(gui)
            return true
        elseif gethui then
            -- Для Xeno и других
            return true
        elseif CoreGui and CoreGui:FindFirstChild("RobloxGui") then
            -- Для Script-Ware и подобных
            return true
        end
        return false
    end,
    
    SaveSettings = function(filename, data)
        if writefile then
            pcall(function()
                writefile(filename, data)
            end)
        elseif makefolder and writefile then
            -- Создаем папку если нужно
            if not isfolder("AgalikHub") then
                makefolder("AgalikHub")
            end
            pcall(function()
                writefile("AgalikHub/" .. filename, data)
            end)
        end
    end,
    
    LoadSettings = function(filename)
        if readfile then
            local success, result = pcall(function()
                return readfile(filename)
            end)
            return success and result
        elseif isfolder and isfile and readfile then
            if isfolder("AgalikHub") and isfile("AgalikHub/" .. filename) then
                local success, result = pcall(function()
                    return readfile("AgalikHub/" .. filename)
                end)
                return success and result
            end
        end
        return nil
    end
}

-- Получаем сервисы
local success, services = pcall(function()
    return {
        Players = game:GetService("Players"),
        UIS = game:GetService("UserInputService"),
        Workspace = game:GetService("Workspace"),
        RunService = game:GetService("RunService"),
        TweenService = game:GetService("TweenService"),
        Lighting = game:GetService("Lighting"),
        HttpService = game:GetService("HttpService"),
        CoreGui = game:GetService("CoreGui"),
        StarterGui = game:GetService("StarterGui"),
        TextService = game:GetService("TextService")
    }
end)

if not success then
    -- Альтернативный способ получения сервисов
    local game = game
    local Players = game:GetService("Players")
    local UIS = game:GetService("UserInputService")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local Lighting = game:GetService("Lighting")
    local HttpService = game:GetService("HttpService")
    local CoreGui = game:GetService("CoreGui")
    local StarterGui = game:GetService("StarterGui")
    local TextService = game:GetService("TextService")
    services = {
        Players = Players,
        UIS = UIS,
        Workspace = Workspace,
        RunService = RunService,
        TweenService = TweenService,
        Lighting = Lighting,
        HttpService = HttpService,
        CoreGui = CoreGui,
        StarterGui = StarterGui,
        TextService = TextService
    }
end

-- Короткие ссылки для удобства
local Players = services.Players
local UIS = services.UIS
local Workspace = services.Workspace
local RunService = services.RunService
local TweenService = services.TweenService
local Lighting = services.Lighting
local HttpService = services.HttpService
local CoreGui = services.CoreGui
local StarterGui = services.StarterGui

-- Получаем локального игрока
local player = Players.LocalPlayer
while not player do
    task.wait()
    player = Players.LocalPlayer
end

local mouse = player:GetMouse()

-- ============================================
-- КОНФИГУРАЦИЯ И НАСТРОЙКИ
-- ============================================

local Config = {
    Version = "5.1",
    ESP_UpdateRate = 0.15,
    SafeMode = true,
    Performance = {
        MaxCubes = 20,
        MaxESPPlayers = 12
    },
    SpeedValues = {16, 25, 50, 75, 100},
    DefaultLanguage = "english"
}

-- Настройки
local Settings = {
    Language = Config.DefaultLanguage,
    ESP = {
        Enabled = false,
        ShowNames = true,
        ShowDistance = true,
        ShowHealth = true,
        TeamColors = true,
        MaxDistance = 500
    },
    Visual = {
        XRay = false,
        FullBright = false,
        XRayTransparency = 0.6
    },
    Player = {
        SpeedIndex = 1,
        NoClip = false,
        Invisible = false
    }
}

-- Загрузка настроек
local function loadSettings()
    local data = Universal.LoadSettings("AgalikHub_Settings.json")
    if data then
        local success, decoded = pcall(function()
            return HttpService:JSONDecode(data)
        end)
        if success and decoded then
            for category, values in pairs(decoded) do
                if Settings[category] then
                    for key, value in pairs(values) do
                        Settings[category][key] = value
                    end
                end
            end
            return true
        end
    end
    return false
end

-- Сохранение настроек
local function saveSettings()
    local encoded = HttpService:JSONEncode(Settings)
    Universal.SaveSettings("AgalikHub_Settings.json", encoded)
end

-- Загружаем настройки
local settingsLoaded = loadSettings()
Settings.Language = settingsLoaded and Settings.Language or Config.DefaultLanguage

-- Тема
local theme = {
    main = Color3.fromRGB(25, 25, 35),
    secondary = Color3.fromRGB(35, 35, 45),
    accent = Color3.fromRGB(0, 150, 255),
    text = Color3.fromRGB(240, 240, 240),
    subtext = Color3.fromRGB(180, 180, 200),
    success = Color3.fromRGB(0, 200, 83),
    danger = Color3.fromRGB(255, 80, 90),
    warning = Color3.fromRGB(255, 184, 0),
    teamRed = Color3.fromRGB(255, 50, 50),
    teamBlue = Color3.fromRGB(50, 150, 255),
    neutral = Color3.fromRGB(200, 200, 200)
}

-- ============================================
-- УНИВЕРСАЛЬНАЯ СИСТЕМА GUI
-- ============================================

-- Создаем GUI с учетом всех инжекторов
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AgalikHub_" .. tick()
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- Универсальное размещение GUI
local function placeGUI(gui)
    -- Пробуем все методы
    local placed = false
    
    -- Метод 1: syn.protect_gui (Synapse X)
    if syn and syn.protect_gui then
        pcall(function()
            syn.protect_gui(gui)
            gui.Parent = CoreGui
            placed = true
        end)
    end
    
    -- Метод 2: gethui (Xeno, Krnl, Fluxus)
    if not placed and gethui then
        pcall(function()
            local hiddenUI = gethui()
            if hiddenUI then
                gui.Parent = hiddenUI
                placed = true
            end
        end)
    end
    
    -- Метод 3: CoreGui напрямую (Script-Ware, Electron)
    if not placed then
        pcall(function()
            gui.Parent = CoreGui
            placed = true
        end)
    end
    
    -- Метод 4: PlayerGui как запасной вариант
    if not placed and player and player:FindFirstChild("PlayerGui") then
        pcall(function()
            gui.Parent = player:WaitForChild("PlayerGui")
            placed = true
        end)
    end
    
    -- Метод 5: StarterGui как последний шанс
    if not placed then
        pcall(function()
            gui.Parent = StarterGui
            placed = true
        end)
    end
    
    return placed
end

-- Размещаем GUI
local guiPlaced = placeGUI(screenGui)

-- Если GUI не разместился, пробуем создать через 5 секунд
if not guiPlaced then
    task.wait(5)
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AgalikHub_" .. tick()
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    guiPlaced = placeGUI(screenGui)
end

-- ============================================
-- ГЛАВНОЕ МЕНЮ (УПРОЩЕННОЕ ДЛЯ СОВМЕСТИМОСТИ)
-- ============================================

-- Главный фрейм
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 450, 0, 400)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
mainFrame.BackgroundColor3 = theme.main
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = theme.accent
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = theme.secondary
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "AGALIK HUB v" .. Config.Version .. " | " .. Executor.Name
title.TextColor3 = theme.accent
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "Close"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextSize = 18
closeBtn.Parent = titleBar

-- Боковая панель
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 100, 1, -40)
sidebar.Position = UDim2.new(0, 0, 0, 40)
sidebar.BackgroundColor3 = theme.secondary
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

-- Область контента
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, -100, 1, -40)
contentFrame.Position = UDim2.new(0, 100, 0, 40)
contentFrame.BackgroundColor3 = theme.main
contentFrame.BorderSizePixel = 0
contentFrame.ClipsDescendants = true
contentFrame.Parent = mainFrame

-- ============================================
-- БАЗОВЫЕ ВКЛАДКИ (МИНИМАЛЬНЫЙ ФУНКЦИОНАЛ)
-- ============================================

local tabs = {
    {Name = "Player", Icon = "👤", Color = theme.accent},
    {Name = "Visual", Icon = "👁️", Color = Color3.fromRGB(0, 200, 255)},
    {Name = "TP", Icon = "📍", Color = Color3.fromRGB(255, 184, 0)},
    {Name = "Fun", Icon = "🎮", Color = Color3.fromRGB(235, 77, 75)}
}

local tabFrames = {}
local tabButtons = {}
local activeTab = 1

-- Создаем вкладки
for i, tab in ipairs(tabs) do
    -- Кнопка вкладки
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tab.Name .. "Tab"
    tabButton.Size = UDim2.new(1, 0, 0, 45)
    tabButton.Position = UDim2.new(0, 0, 0, (i-1) * 50)
    tabButton.BackgroundColor3 = i == 1 and Color3.fromRGB(45, 45, 60) or theme.secondary
    tabButton.BorderSizePixel = 0
    tabButton.Font = Enum.Font.Gotham
    tabButton.Text = tab.Icon .. " " .. tab.Name
    tabButton.TextColor3 = i == 1 and theme.text or theme.subtext
    tabButton.TextSize = 14
    tabButton.Parent = sidebar
    
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
    tabFrame.Parent = contentFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = tabFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = tabFrame
    
    tabButtons[i] = tabButton
    tabFrames[i] = tabFrame
    
    -- Обработчик клика
    tabButton.MouseButton1Click:Connect(function()
        if activeTab == i then return end
        
        activeTab = i
        
        for idx, btn in ipairs(tabButtons) do
            local isActive = idx == i
            btn.BackgroundColor3 = isActive and Color3.fromRGB(45, 45, 60) or theme.secondary
            btn.TextColor3 = isActive and theme.text or theme.subtext
            tabFrames[idx].Visible = isActive
        end
    end)
end

-- ============================================
-- УНИВЕРСАЛЬНАЯ ФУНКЦИЯ СОЗДАНИЯ КНОПОК
-- ============================================

local function createButton(parent, text, description, icon, color, callback)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = text .. "Button"
    buttonFrame.Size = UDim2.new(1, 0, 0, 50)
    buttonFrame.BackgroundColor3 = theme.secondary
    buttonFrame.BorderSizePixel = 0
    buttonFrame.LayoutOrder = #parent:GetChildren()
    buttonFrame.Parent = parent
    
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    button.BorderSizePixel = 0
    button.Font = Enum.Font.GothamBold
    button.Text = icon .. "  " .. text
    button.TextColor3 = color
    button.TextSize = 14
    button.Parent = buttonFrame
    
    if description and description ~= "" then
        button.Text = icon .. "  " .. text .. "\n" .. description
    end
    
    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    return button
end

-- ============================================
-- ВКЛАДКА ИГРОКА (PLAYER)
-- ============================================

local playerTab = tabFrames[1]

-- NOCHIP
createButton(playerTab, "NOCHIP", "Walk through walls", "🚶", theme.accent, function()
    if player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        createNotification("NOCHIP ON", theme.success)
    end
end)

-- SPEED HACK
createButton(playerTab, "SPEED HACK", "Speed: 50", "⚡", Color3.fromRGB(0, 200, 255), function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        local newSpeed = humanoid.WalkSpeed == 16 and 50 or 16
        humanoid.WalkSpeed = newSpeed
        createNotification("SPEED: " .. newSpeed, theme.accent)
    end
end)

-- INVISIBLE
createButton(playerTab, "INVISIBLE", "Become invisible", "👻", Color3.fromRGB(200, 100, 255), function()
    if player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = part.Transparency == 0 and 1 or 0
            end
        end
        createNotification("INVISIBLE TOGGLED", Color3.fromRGB(200, 100, 255))
    end
end)

-- FLY (упрощенный)
createButton(playerTab, "FLY", "Toggle flight", "🦅", Color3.fromRGB(255, 184, 0), function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        local fly = root:FindFirstChild("AgalikFly")
        
        if fly then
            fly:Destroy()
            createNotification("FLY OFF", theme.danger)
        else
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Name = "AgalikFly"
            bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = root
            
            -- Простое управление
            local connection
            connection = UIS.InputBegan:Connect(function(input)
                if input.KeyCode == Enum.KeyCode.Space then
                    bodyVelocity.Velocity = Vector3.new(0, 50, 0)
                elseif input.KeyCode == Enum.KeyCode.LeftControl then
                    bodyVelocity.Velocity = Vector3.new(0, -50, 0)
                end
            end)
            
            createNotification("FLY ON - Space/LCtrl", Color3.fromRGB(255, 184, 0))
        end
    end
end)

-- ============================================
-- ВКЛАДКА ВИЗУАЛА (VISUAL)
-- ============================================

local visualTab = tabFrames[2]

-- ESP (упрощенный)
local espEnabled = false
local espBoxes = {}

createButton(visualTab, "ESP", "See players", "👁️", Color3.fromRGB(255, 100, 200), function()
    espEnabled = not espEnabled
    
    if espEnabled then
        -- Создаем ESP для всех игроков
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "ESPBox"
                box.Adornee = p.Character.HumanoidRootPart
                box.Size = Vector3.new(4, 6, 2)
                box.Color3 = p.Team and p.Team.TeamColor.Color or Color3.new(1, 0, 0)
                box.Transparency = 0.5
                box.ZIndex = 10
                box.AlwaysOnTop = true
                box.Parent = p.Character.HumanoidRootPart
                
                espBoxes[p] = box
            end
        end
        
        -- Обновляем при появлении новых игроков
        local playerAddedConn = Players.PlayerAdded:Connect(function(p)
            task.wait(1)
            if espEnabled and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "ESPBox"
                box.Adornee = p.Character.HumanoidRootPart
                box.Size = Vector3.new(4, 6, 2)
                box.Color3 = p.Team and p.Team.TeamColor.Color or Color3.new(1, 0, 0)
                box.Transparency = 0.5
                box.ZIndex = 10
                box.AlwaysOnTop = true
                box.Parent = p.Character.HumanoidRootPart
                
                espBoxes[p] = box
            end
        end)
        
        createNotification("ESP ON", theme.success)
    else
        -- Удаляем ESP
        for p, box in pairs(espBoxes) do
            if box and box.Parent then
                box:Destroy()
            end
        end
        espBoxes = {}
        createNotification("ESP OFF", theme.danger)
    end
end)

-- X-RAY
createButton(visualTab, "X-RAY", "See through walls", "🔍", Color3.fromRGB(0, 200, 255), function()
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and (part.Name:lower():find("wall") or part.Name:lower():find("fence")) then
            part.LocalTransparencyModifier = part.LocalTransparencyModifier == 0 and 0.6 or 0
        end
    end
    createNotification("X-RAY TOGGLED", Color3.fromRGB(0, 200, 255))
end)

-- FULLBRIGHT
createButton(visualTab, "FULLBRIGHT", "Remove darkness", "💡", Color3.fromRGB(255, 255, 100), function()
    Lighting.GlobalShadows = not Lighting.GlobalShadows
    Lighting.Brightness = Lighting.Brightness == 1 and 2 or 1
    createNotification("FULLBRIGHT TOGGLED", Color3.fromRGB(255, 255, 100))
end)

-- ============================================
-- ВКЛАДКА ТЕЛЕПОРТОВ (TP)
-- ============================================

local tpTab = tabFrames[3]

-- Стандартные телепорты
local teleports = {
    {Name = "GUARD ROOM", Desc = "Police spawn", Icon = "👮", Color = theme.teamBlue, CFrame = CFrame.new(807.032, 99.99, 2307.153)},
    {Name = "PRISON YARD", Desc = "Main area", Icon = "🏀", Color = Color3.fromRGB(100, 255, 150), CFrame = CFrame.new(803, 98, 2457)},
    {Name = "CRIMINAL BASE", Desc = "Criminal spawn", Icon = "🔫", Color = theme.teamRed, CFrame = CFrame.new(-920, 94, 2137)},
    {Name = "ARMORY", Desc = "Weapons", Icon = "🎯", Color = Color3.fromRGB(255, 50, 50), CFrame = CFrame.new(842, 99, 2219)}
}

for _, tp in ipairs(teleports) do
    createButton(tpTab, tp.Name, tp.Desc, tp.Icon, tp.Color, function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = tp.CFrame
            createNotification("TP: " .. tp.Name, tp.Color)
        end
    end)
end

-- Телепорт к игроку
createButton(tpTab, "TELEPORT TO PLAYER", "Click to select", "👤", theme.accent, function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            createButton(tpTab, "→ " .. p.Name, "Click to teleport", "🎯", 
                p.Team and p.Team.TeamColor.Color or theme.accent, function()
                    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                        createNotification("TP to " .. p.Name, theme.success)
                    end
                end)
        end
    end
end)

-- ============================================
-- ВКЛАДКА FUN
-- ============================================

local funTab = tabFrames[4]

-- Spawn Cube
local cubes = {}
createButton(funTab, "SPAWN CUBE", "Create platform", "◼", Color3.fromRGB(100, 200, 255), function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local cube = Instance.new("Part")
        cube.Name = "AgalikCube"
        cube.Size = Vector3.new(5, 5, 5)
        cube.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, -5, 0)
        cube.Anchored = true
        cube.CanCollide = true
        cube.Color = Color3.fromRGB(math.random(50, 255), math.random(50, 255), math.random(50, 255))
        cube.Material = Enum.Material.Neon
        cube.Transparency = 0.3
        cube.Parent = Workspace
        table.insert(cubes, cube)
        createNotification("CUBE SPAWNED", Color3.fromRGB(100, 200, 255))
    end
end)

-- Grenade Rain
createButton(funTab, "GRENADE RAIN", "Explosions!", "💣", Color3.fromRGB(255, 50, 50), function()
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
            explosion.BlastPressure = 0
            explosion.Parent = Workspace
            
            task.wait(0.1)
        end
        createNotification("GRENADE RAIN!", Color3.fromRGB(255, 100, 100))
    end
end)

-- Clear Cubes
createButton(funTab, "CLEAR CUBES", "Remove all", "🗑️", Color3.fromRGB(255, 150, 50), function()
    local count = 0
    for _, cube in pairs(cubes) do
        if cube and cube.Parent then
            cube:Destroy()
            count = count + 1
        end
    end
    cubes = {}
    createNotification("CLEARED " .. count .. " CUBES", theme.success)
end)

-- ============================================
-- СИСТЕМА УВЕДОМЛЕНИЙ (ПРОСТАЯ)
-- ============================================

local function createNotification(text, color)
    spawn(function()
        local notification = Instance.new("TextLabel")
        notification.Name = "Notification"
        notification.Size = UDim2.new(0, 200, 0, 40)
        notification.Position = UDim2.new(0.5, -100, 0.1, 0)
        notification.BackgroundColor3 = theme.secondary
        notification.BorderSizePixel = 0
        notification.Font = Enum.Font.GothamBold
        notification.Text = text
        notification.TextColor3 = color
        notification.TextSize = 14
        notification.ZIndex = 1000
        notification.Parent = screenGui
        
        -- Анимация
        notification.Position = UDim2.new(0.5, -100, 0, -50)
        TweenService:Create(notification, TweenInfo.new(0.3), {
            Position = UDim2.new(0.5, -100, 0.1, 0)
        }):Play()
        
        task.wait(2)
        
        TweenService:Create(notification, TweenInfo.new(0.3), {
            Position = UDim2.new(0.5, -100, 0, -50)
        }):Play()
        
        task.wait(0.3)
        notification:Destroy()
    end)
end

-- ============================================
-- УПРАВЛЕНИЕ МЕНЮ
-- ============================================

-- Кнопка открытия
local openButton = Instance.new("TextButton")
openButton.Name = "OpenButton"
openButton.Size = UDim2.new(0, 40, 0, 40)
openButton.Position = UDim2.new(1, -50, 0, 10)
openButton.BackgroundColor3 = theme.accent
openButton.BorderSizePixel = 0
openButton.Font = Enum.Font.GothamBold
openButton.Text = "A"
openButton.TextColor3 = Color3.new(1, 1, 1)
openButton.TextSize = 16
openButton.Parent = screenGui

-- Переменные
local menuVisible = false
local dragging = false
local dragStart, startPos

-- Функция переключения меню
local function toggleMenu()
    menuVisible = not menuVisible
    mainFrame.Visible = menuVisible
    openButton.Visible = not menuVisible
end

-- Обработчики
openButton.MouseButton1Click:Connect(toggleMenu)
closeBtn.MouseButton1Click:Connect(toggleMenu)

-- Горячие клавиши (все возможные)
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl or 
       input.KeyCode == Enum.KeyCode.Insert or 
       input.KeyCode == Enum.KeyCode.F4 or
       input.KeyCode == Enum.KeyCode.F5 then
        toggleMenu()
    end
end)

-- Перетаскивание
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
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
-- ЗАГРУЗКА И ИНИЦИАЛИЗАЦИЯ
-- ============================================

-- Ждем полной загрузки игры
task.wait(2)

-- Отображаем информацию о загрузке
print(" ")
print("╔══════════════════════════════════════════════════╗")
print("║            AGALIK HUB v" .. Config.Version .. " - UNIVERSAL           ║")
print("║               Executor: " .. Executor.Name .. string.rep(" ", 19 - #Executor.Name) .. "║")
print("║               GUI Placed: " .. tostring(guiPlaced) .. string.rep(" ", 20) .. "║")
print("║               Settings Loaded: " .. tostring(settingsLoaded) .. string.rep(" ", 16) .. "║")
print("╚══════════════════════════════════════════════════╝")
print(" ")
print("📌 Hotkeys: RightControl, Insert, F4, F5")
print("📌 GUI Parent: " .. tostring(screenGui.Parent and screenGui.Parent.ClassName or "None"))
print(" ")

-- Стартовые уведомления
task.wait(0.5)
createNotification("AGALIK HUB v" .. Config.Version .. " LOADED", theme.accent)
createNotification("Executor: " .. Executor.Name, theme.accent)
createNotification("Press RightControl to open menu", Color3.fromRGB(255, 184, 0))

-- Добавляем функцию для перезагрузки GUI если не открывается
if not guiPlaced then
    warn("[AGALIK HUB] GUI placement failed! Trying alternative method...")
    
    task.wait(3)
    
    -- Пробуем еще раз
    local newGui = Instance.new("ScreenGui")
    newGui.Name = "AgalikHub_Alt_" .. tick()
    newGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    newGui.ResetOnSpawn = false
    
    -- Пробуем PlayerGui напрямую
    if player and player:FindFirstChild("PlayerGui") then
        newGui.Parent = player.PlayerGui
        createNotification("GUI LOADED (Alternative)", theme.success)
    else
        -- Последняя попытка - StarterGui
        newGui.Parent = StarterGui
        createNotification("GUI LOADED (Fallback)", theme.warning)
    end
    
    -- Копируем кнопку открытия
    local altOpenButton = openButton:Clone()
    altOpenButton.Parent = newGui
    altOpenButton.Visible = true
    
    altOpenButton.MouseButton1Click:Connect(function()
        if not mainFrame or not mainFrame.Parent then
            -- Пересоздаем главное меню
            mainFrame = Instance.new("Frame")
            mainFrame.Name = "MainFrame"
            mainFrame.Size = UDim2.new(0, 450, 0, 400)
            mainFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
            mainFrame.BackgroundColor3 = theme.main
            mainFrame.BorderSizePixel = 1
            mainFrame.BorderColor3 = theme.accent
            mainFrame.Visible = true
            mainFrame.Parent = newGui
            
            -- Добавляем заголовок
            local titleBar = Instance.new("Frame")
            titleBar.Name = "TitleBar"
            titleBar.Size = UDim2.new(1, 0, 0, 40)
            titleBar.BackgroundColor3 = theme.secondary
            titleBar.BorderSizePixel = 0
            titleBar.Parent = mainFrame
            
            local title = Instance.new("TextLabel")
            title.Name = "Title"
            title.Size = UDim2.new(1, -80, 1, 0)
            title.Position = UDim2.new(0, 10, 0, 0)
            title.BackgroundTransparency = 1
            title.Font = Enum.Font.GothamBold
            title.Text = "AGALIK HUB v" .. Config.Version .. " (ALT)"
            title.TextColor3 = theme.accent
            title.TextSize = 16
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = titleBar
            
            local closeBtn = Instance.new("TextButton")
            closeBtn.Name = "Close"
            closeBtn.Size = UDim2.new(0, 30, 0, 30)
            closeBtn.Position = UDim2.new(1, -35, 0, 5)
            closeBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
            closeBtn.BorderSizePixel = 0
            closeBtn.Font = Enum.Font.GothamBold
            closeBtn.Text = "×"
            closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
            closeBtn.TextSize = 18
            closeBtn.Parent = titleBar
            closeBtn.MouseButton1Click:Connect(function()
                mainFrame.Visible = false
                altOpenButton.Visible = true
            end)
            
            -- Простой контент
            local content = Instance.new("TextLabel")
            content.Name = "Content"
            content.Size = UDim2.new(1, -20, 1, -60)
            content.Position = UDim2.new(0, 10, 0, 50)
            content.BackgroundTransparency = 1
            content.Font = Enum.Font.Gotham
            content.Text = "Alternative GUI loaded!\n\nPress RightControl for main menu"
            content.TextColor3 = theme.text
            content.TextSize = 14
            content.TextWrapped = true
            content.Parent = mainFrame
        else
            mainFrame.Visible = not mainFrame.Visible
            altOpenButton.Visible = not mainFrame.Visible
        end
    end)
end

-- Универсальная команда для открытия меню
game:GetService("Players").LocalPlayer.Chatted:Connect(function(msg)
    if msg:lower() == "/agalik" or msg:lower() == "/menu" then
        toggleMenu()
    elseif msg:lower() == "/esp" then
        -- Быстрое включение ESP через чат
        espEnabled = not espEnabled
        createNotification("ESP: " .. (espEnabled and "ON" or "OFF"), 
            espEnabled and theme.success or theme.danger)
    end
end)

-- Завершающее сообщение
createNotification("Ready! Type /agalik or /menu in chat", theme.success)
