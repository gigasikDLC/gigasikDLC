local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- Настройки визуалов
local Visuals = {
    ESP = {
        Enabled = false,
        Players = {},
        ShowName = true,
        ShowDistance = true,
        ShowHealth = true,
        BoxColor = Color3.fromRGB(255, 50, 50)
    },
    Tracers = {
        Enabled = false,
        Lines = {}
    },
    Chams = {
        Enabled = false,
        Materials = {}
    },
    Boxes = {
        Enabled = false,
        Boxes = {}
    }
}

-- Функции ESP
local function createESP(targetPlayer)
    if not Visuals.ESP.Enabled then return end
    if targetPlayer == player then return end
    if not targetPlayer.Character then return end
    
    local character = targetPlayer.Character
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    
    if not rootPart or not head then return end

    -- Создаем ESP Box
    local box = Instance.new("BoxHandleAdornment")
    box.Name = targetPlayer.Name .. "_ESPBOX"
    box.Adornee = rootPart
    box.AlwaysOnTop = true
    box.ZIndex = 1
    box.Size = rootPart.Size + Vector3.new(0.1, 0.1, 0.1)
    box.Transparency = 0.3
    box.Color3 = Visuals.ESP.BoxColor
    box.Parent = Workspace

    -- Создаем BillboardGui для информации
    local billboard = Instance.new("BillboardGui")
    billboard.Name = targetPlayer.Name .. "_ESPINFO"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 80)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = Workspace

    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, 0, 1, 0)
    infoLabel.BackgroundTransparency = 0.7
    infoLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    infoLabel.Text = ""
    infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoLabel.TextSize = 14
    infoLabel.Font = Enum.Font.GothamBold
    infoLabel.Parent = billboard

    Visuals.ESP.Players[targetPlayer] = {
        Box = box,
        Billboard = billboard,
        InfoLabel = infoLabel,
        Character = character
    }

    -- Обновление информации в реальном времени
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not Visuals.ESP.Enabled or not character or not rootPart or not player.Character then
            if connection then
                connection:Disconnect()
            end
            return
        end

        local infoText = ""
        
        if Visuals.ESP.ShowName then
            infoText = targetPlayer.Name .. "\n"
        end
        
        if Visuals.ESP.ShowDistance and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (rootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            infoText = infoText .. "Distance: " .. math.floor(distance) .. " studs\n"
        end
        
        if Visuals.ESP.ShowHealth and humanoid then
            infoText = infoText .. "Health: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
        end

        infoLabel.Text = infoText
    end)
end

local function removeESP(targetPlayer)
    if Visuals.ESP.Players[targetPlayer] then
        if Visuals.ESP.Players[targetPlayer].Box then
            Visuals.ESP.Players[targetPlayer].Box:Destroy()
        end
        if Visuals.ESP.Players[targetPlayer].Billboard then
            Visuals.ESP.Players[targetPlayer].Billboard:Destroy()
        end
        Visuals.ESP.Players[targetPlayer] = nil
    end
end

local function toggleESP()
    if Visuals.ESP.Enabled then
        -- Включаем ESP для всех игроков
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                if otherPlayer.Character then
                    createESP(otherPlayer)
                end
                otherPlayer.CharacterAdded:Connect(function()
                    wait(1)
                    createESP(otherPlayer)
                end)
            end
        end
    else
        -- Выключаем ESP для всех игроков
        for targetPlayer, _ in pairs(Visuals.ESP.Players) do
            removeESP(targetPlayer)
        end
    end
end

-- Функции Tracers
local function createTracer(targetPlayer)
    if not Visuals.Tracers.Enabled then return end
    if targetPlayer == player then return end
    
    local tracer = Instance.new("Frame")
    tracer.Name = targetPlayer.Name .. "_TRACER"
    tracer.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    tracer.BorderSizePixel = 0
    tracer.Size = UDim2.new(0, 2, 0, 100)
    tracer.AnchorPoint = Vector2.new(0.5, 0)
    tracer.Visible = false
    tracer.Parent = CoreGui

    Visuals.Tracers.Lines[targetPlayer] = tracer

    -- Обновление позиции трассера
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not Visuals.Tracers.Enabled or not targetPlayer.Character then
            tracer.Visible = false
            if connection then
                connection:Disconnect()
            end
            return
        end

        local rootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if rootPart and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local screenPoint, onScreen = camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                tracer.Visible = true
                tracer.Position = UDim2.new(0, screenPoint.X, 0, screenPoint.Y)
                
                -- Вычисляем длину и угол
                local playerScreenPos = camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                local delta = Vector2.new(screenPoint.X - playerScreenPos.X, screenPoint.Y - playerScreenPos.Y)
                local length = math.sqrt(delta.X * delta.X + delta.Y * delta.Y)
                local angle = math.atan2(delta.Y, delta.X)
                
                tracer.Size = UDim2.new(0, 2, 0, length)
                tracer.Rotation = math.deg(angle) + 90
            else
                tracer.Visible = false
            end
        else
            tracer.Visible = false
        end
    end)
end

local function removeTracer(targetPlayer)
    if Visuals.Tracers.Lines[targetPlayer] then
        Visuals.Tracers.Lines[targetPlayer]:Destroy()
        Visuals.Tracers.Lines[targetPlayer] = nil
    end
end

local function toggleTracers()
    if Visuals.Tracers.Enabled then
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                createTracer(otherPlayer)
            end
        end
    else
        for targetPlayer, _ in pairs(Visuals.Tracers.Lines) do
            removeTracer(targetPlayer)
        end
    end
end

-- Функции Chams
local function applyChams(targetPlayer)
    if not Visuals.Chams.Enabled then return end
    if targetPlayer == player then return end
    if not targetPlayer.Character then return end
    
    for _, part in pairs(targetPlayer.Character:GetChildren()) do
        if part:IsA("BasePart") then
            local originalMaterial = part.Material
            local originalTransparency = part.Transparency
            
            part.Material = Enum.Material.ForceField
            part.Transparency = 0.3
            
            Visuals.Chams.Materials[part] = {
                OriginalMaterial = originalMaterial,
                OriginalTransparency = originalTransparency
            }
        end
    end
end

local function removeChams(targetPlayer)
    if not targetPlayer.Character then return end
    
    for part, materials in pairs(Visuals.Chams.Materials) do
        if part and part.Parent then
            part.Material = materials.OriginalMaterial
            part.Transparency = materials.OriginalTransparency
        end
    end
end

local function toggleChams()
    if Visuals.Chams.Enabled then
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                applyChams(otherPlayer)
            end
        end
    else
        for targetPlayer, _ in pairs(Players:GetPlayers()) do
            if targetPlayer ~= player then
                removeChams(targetPlayer)
            end
        end
    end
end

-- Функции Box ESP
local function createBox(targetPlayer)
    if not Visuals.Boxes.Enabled then return end
    if targetPlayer == player then return end
    if not targetPlayer.Character then return end
    
    local rootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    local box = Instance.new("BoxHandleAdornment")
    box.Name = targetPlayer.Name .. "_BOX"
    box.Adornee = rootPart
    box.AlwaysOnTop = true
    box.ZIndex = 0
    box.Size = rootPart.Size + Vector3.new(0.2, 0.2, 0.2)
    box.Transparency = 0.7
    box.Color3 = Color3.fromRGB(0, 255, 0)
    box.Parent = Workspace

    Visuals.Boxes.Boxes[targetPlayer] = box
end

local function removeBox(targetPlayer)
    if Visuals.Boxes.Boxes[targetPlayer] then
        Visuals.Boxes.Boxes[targetPlayer]:Destroy()
        Visuals.Boxes.Boxes[targetPlayer] = nil
    end
end

local function toggleBoxes()
    if Visuals.Boxes.Enabled then
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                createBox(otherPlayer)
            end
        end
    else
        for targetPlayer, _ in pairs(Visuals.Boxes.Boxes) do
            removeBox(targetPlayer)
        end
    end
end

-- Обработчики игроков
Players.PlayerAdded:Connect(function(newPlayer)
    if Visuals.ESP.Enabled then
        newPlayer.CharacterAdded:Connect(function()
            wait(1)
            createESP(newPlayer)
        end)
    end
    if Visuals.Tracers.Enabled then
        newPlayer.CharacterAdded:Connect(function()
            wait(1)
            createTracer(newPlayer)
        end)
    end
    if Visuals.Chams.Enabled then
        newPlayer.CharacterAdded:Connect(function()
            wait(1)
            applyChams(newPlayer)
        end)
    end
    if Visuals.Boxes.Enabled then
        newPlayer.CharacterAdded:Connect(function()
            wait(1)
            createBox(newPlayer)
        end)
    end
end)

Players.PlayerRemoving:Connect(function(leavingPlayer)
    removeESP(leavingPlayer)
    removeTracer(leavingPlayer)
    removeChams(leavingPlayer)
    removeBox(leavingPlayer)
end)

-- Создание меню
local function createGigasikDLC()
    if CoreGui:FindFirstChild("gigasikDLC") then
        CoreGui:FindFirstChild("gigasikDLC"):Destroy()
    end

    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "gigasikDLC"
    mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    mainGui.ResetOnSpawn = false
    mainGui.Parent = CoreGui

    -- Плавающая кнопка
    local openButton = Instance.new("TextButton")
    openButton.Size = UDim2.new(0, 60, 0, 60)
    openButton.Position = UDim2.new(0, 20, 0.5, -30)
    openButton.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
    openButton.Text = "☰"
    openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    openButton.TextSize = 20
    openButton.Font = Enum.Font.GothamBold
    openButton.Parent = mainGui
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1, 0)
    buttonCorner.Parent = openButton

    -- Основное меню
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 350, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.Parent = mainGui

    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0.05, 0)
    frameCorner.Parent = mainFrame

    -- Заголовок для перемещения
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    header.BorderSizePixel = 0
    header.Parent = mainFrame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "gigasikDLC"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Parent = header

    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0.5, -15)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 16
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = header

    -- Вкладки
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 0, 35)
    tabContainer.Position = UDim2.new(0, 0, 0, 40)
    tabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainFrame

    -- Контент
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -10, 1, -85)
    contentFrame.Position = UDim2.new(0, 5, 0, 80)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ClipsDescendants = true
    contentFrame.Parent = mainFrame

    -- Создаем вкладки
    local tabs = {"COMBAT", "VISUALS", "FUN"}
    local tabColors = {
        COMBAT = Color3.fromRGB(220, 80, 80),
        VISUALS = Color3.fromRGB(80, 150, 220), 
        FUN = Color3.fromRGB(80, 220, 120)
    }

    local currentTab = "VISUALS"
    local tabFrames = {}

    -- Создаем кнопки вкладок
    for i, tabName in pairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1/3, 0, 1, 0)
        tabButton.Position = UDim2.new((i-1) * (1/3), 0, 0, 0)
        tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        tabButton.BorderSizePixel = 0
        tabButton.Text = tabName
        tabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
        tabButton.TextSize = 12
        tabButton.Font = Enum.Font.GothamBold
        tabButton.Parent = tabContainer

        -- Создаем фрейм для контента вкладки
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.Position = UDim2.new((i-1), 0, 0, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 150)
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.Parent = contentFrame

        tabFrames[tabName] = {button = tabButton, content = tabContent}

        if tabName == "VISUALS" then
            tabButton.BackgroundColor3 = tabColors[tabName]
            tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        tabButton.MouseButton1Click:Connect(function()
            if currentTab == tabName then return end
            
            -- Анимация перехода
            for name, frame in pairs(tabFrames) do
                if name == tabName then
                    -- Показываем новую вкладку
                    TweenService:Create(frame.button, TweenInfo.new(0.2), {
                        BackgroundColor3 = tabColors[name],
                        TextColor3 = Color3.fromRGB(255, 255, 255)
                    }):Play()
                    
                    TweenService:Create(frame.content, TweenInfo.new(0.3), {
                        Position = UDim2.new(0, 0, 0, 0)
                    }):Play()
                else
                    -- Скрываем старые вкладки
                    TweenService:Create(frame.button, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(40, 40, 60),
                        TextColor3 = Color3.fromRGB(180, 180, 180)
                    }):Play()
                    
                    if name == currentTab then
                        TweenService:Create(frame.content, TweenInfo.new(0.3), {
                            Position = UDim2.new(-1, 0, 0, 0)
                        }):Play()
                    else
                        frame.content.Position = UDim2.new(1, 0, 0, 0)
                    end
                end
            end
            
            currentTab = tabName
        end)
    end

    -- Заполняем вкладку VISUALS
    local visualsFeatures = {
        {name = "Player ESP", type = "toggle", setting = "ESP", func = toggleESP},
        {name = "Tracers", type = "toggle", setting = "Tracers", func = toggleTracers},
        {name = "Chams", type = "toggle", setting = "Chams", func = toggleChams},
        {name = "Box ESP", type = "toggle", setting = "Boxes", func = toggleBoxes},
        {name = "Show Names", type = "toggle", setting = "ESP", value = "ShowName"},
        {name = "Show Distance", type = "toggle", setting = "ESP", value = "ShowDistance"},
        {name = "Show Health", type = "toggle", setting = "ESP", value = "ShowHealth"}
    }

    local visualsContent = tabFrames["VISUALS"].content
    local yPosition = 0
    
    for i, feature in pairs(visualsFeatures) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 35)
        button.Position = UDim2.new(0, 0, 0, yPosition)
        
        -- Определяем цвет кнопки в зависимости от состояния
        local isEnabled
        if feature.value then
            isEnabled = Visuals[feature.setting][feature.value]
        else
            isEnabled = Visuals[feature.setting].Enabled
        end
        
        button.BackgroundColor3 = isEnabled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(50, 50, 70)
        button.BorderSizePixel = 0
        button.Text = feature.name
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 14
        button.Font = Enum.Font.Gotham
        button.Parent = visualsContent
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0.1, 0)
        buttonCorner.Parent = button

        button.MouseButton1Click:Connect(function()
            if feature.value then
                -- Для настроек (Show Name, Distance, Health)
                Visuals[feature.setting][feature.value] = not Visuals[feature.setting][feature.value]
                button.BackgroundColor3 = Visuals[feature.setting][feature.value] and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(50, 50, 70)
            else
                -- Для основных функций (ESP, Tracers и т.д.)
                Visuals[feature.setting].Enabled = not Visuals[feature.setting].Enabled
                button.BackgroundColor3 = Visuals[feature.setting].Enabled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(50, 50, 70)
                
                if feature.func then
                    feature.func()
                end
            end
        end)

        yPosition = yPosition + 40
    end
    visualsContent.CanvasSize = UDim2.new(0, 0, 0, yPosition)

    -- Заполняем другие вкладки (заглушки)
    local combatFeatures = {"Aim Assist", "Trigger Bot", "No Recoil", "Rapid Fire", "Hitboxes"}
    local funFeatures = {"Fly Hack", "Speed Hack", "Bunny Hop", "Noclip", "Super Jump"}

    for i, feature in pairs(combatFeatures) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 35)
        button.Position = UDim2.new(0, 0, 0, (i-1)*40)
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        button.BorderSizePixel = 0
        button.Text = feature
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 14
        button.Font = Enum.Font.Gotham
        button.Parent = tabFrames["COMBAT"].content
    end
    tabFrames["COMBAT"].content.CanvasSize = UDim2.new(0, 0, 0, #combatFeatures * 40)

    for i, feature in pairs(funFeatures) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 35)
        button.Position = UDim2.new(0, 0, 0, (i-1)*40)
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        button.BorderSizePixel = 0
        button.Text = feature
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 14
        button.Font = Enum.Font.Gotham
        button.Parent = tabFrames["FUN"].content
    end
    tabFrames["FUN"].content.CanvasSize = UDim2.new(0, 0, 0, #funFeatures * 40)

    -- Функционал меню
    local menuOpen = false
    local dragging = false
    local dragStart, startPos

    -- Открытие/закрытие меню
    openButton.MouseButton1Click:Connect(function()
        menuOpen = not menuOpen
        mainFrame.Visible = menuOpen
    end)

    closeButton.MouseButton1Click:Connect(function()
        menuOpen = false
        mainFrame.Visible = false
    end)

    -- Перемещение меню за заголовок
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)

    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Перемещение кнопки открытия
    openButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = openButton.Position
        end
    end)

    openButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            openButton.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    openButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    return mainGui
end

-- Инициализация
local menu = createGigasikDLC()

-- Инициализация визуалов для существующих игроков
for _, otherPlayer in pairs(Players:GetPlayers()) do
    if otherPlayer ~= player then
        if otherPlayer.Character then
            if Visuals.ESP.Enabled then createESP(otherPlayer) end
            if Visuals.Tracers.Enabled then createTracer(otherPlayer) end
            if Visuals.Chams.Enabled then applyChams(otherPlayer) end
            if Visuals.Boxes.Enabled then createBox(otherPlayer) end
        end
        otherPlayer.CharacterAdded:Connect(function()
            wait(1)
            if Visuals.ESP.Enabled then createESP(otherPlayer) end
            if Visuals.Tracers.Enabled then createTracer(otherPlayer) end
            if Visuals.Chams.Enabled then applyChams(otherPlayer) end
            if Visuals.Boxes.Enabled then createBox(otherPlayer) end
        end)
    end
end

print("gigasikDLC LOADED! All visuals are working!")
