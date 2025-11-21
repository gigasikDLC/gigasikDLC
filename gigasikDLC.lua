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
        MaxDistance = 200
    },
    Tracers = {
        Enabled = false,
        Lines = {},
        MaxDistance = 200
    },
    Chams = {
        Enabled = false,
        Materials = {},
        MaxDistance = 200
    },
    Boxes = {
        Enabled = false,
        Boxes = {},
        MaxDistance = 200
    }
}

-- Общие функции для работы с игроками
local function getPlayerData(targetPlayer)
    if not targetPlayer then return nil end
    if not targetPlayer.Character then return nil end
    
    local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
    local rootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not rootPart then return nil end
    
    local distance = 0
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        distance = (rootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
    end
    
    return {
        Character = targetPlayer.Character,
        Humanoid = humanoid,
        RootPart = rootPart,
        Head = targetPlayer.Character:FindFirstChild("Head"),
        Distance = distance,
        IsAlive = humanoid and humanoid.Health > 0 or false
    }
end

-- Функции ESP
local function updateESP(targetPlayer)
    if not Visuals.ESP.Enabled then return end
    
    local data = getPlayerData(targetPlayer)
    if not data then return end
    
    -- Проверяем дистанцию
    if data.Distance > Visuals.ESP.MaxDistance then
        if Visuals.ESP.Players[targetPlayer] then
            Visuals.ESP.Players[targetPlayer].Box.Visible = false
            Visuals.ESP.Players[targetPlayer].Billboard.Enabled = false
        end
        return
    end
    
    -- Создаем ESP если еще не создано
    if not Visuals.ESP.Players[targetPlayer] then
        local box = Instance.new("BoxHandleAdornment")
        box.Name = targetPlayer.Name .. "_ESPBOX"
        box.Adornee = data.RootPart
        box.AlwaysOnTop = true
        box.ZIndex = 1
        box.Size = data.RootPart.Size + Vector3.new(0.1, 0.1, 0.1)
        box.Transparency = 0.3
        box.Color3 = Color3.fromRGB(255, 50, 50)
        box.Parent = Workspace

        local billboard = Instance.new("BillboardGui")
        billboard.Name = targetPlayer.Name .. "_ESPINFO"
        billboard.Adornee = data.Head
        billboard.Size = UDim2.new(0, 200, 0, 60)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = Workspace

        local infoLabel = Instance.new("TextLabel")
        infoLabel.Size = UDim2.new(1, 0, 1, 0)
        infoLabel.BackgroundTransparency = 0.7
        infoLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        infoLabel.Text = ""
        infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        infoLabel.TextSize = 12
        infoLabel.Font = Enum.Font.GothamBold
        infoLabel.Parent = billboard

        Visuals.ESP.Players[targetPlayer] = {
            Box = box,
            Billboard = billboard,
            InfoLabel = infoLabel
        }
    end
    
    -- Обновляем информацию
    local espData = Visuals.ESP.Players[targetPlayer]
    if espData then
        espData.Box.Visible = true
        espData.Billboard.Enabled = true
        
        local infoText = ""
        if Visuals.ESP.ShowName then
            infoText = targetPlayer.Name .. "\n"
        end
        if Visuals.ESP.ShowDistance then
            infoText = infoText .. math.floor(data.Distance) .. " studs\n"
        end
        if Visuals.ESP.ShowHealth and data.Humanoid then
            local healthPercent = data.Humanoid.Health / data.Humanoid.MaxHealth
            local healthColor = healthPercent > 0.7 and "🟢" or healthPercent > 0.3 and "🟡" or "🔴"
            infoText = infoText .. healthColor .. " " .. math.floor(data.Humanoid.Health)
        end
        
        espData.InfoLabel.Text = infoText
        
        -- Обновляем позицию ESP если персонаж изменился
        if espData.Box.Adornee ~= data.RootPart then
            espData.Box.Adornee = data.RootPart
        end
        if espData.Billboard.Adornee ~= data.Head then
            espData.Billboard.Adornee = data.Head
        end
    end
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
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                spawn(function()
                    while Visuals.ESP.Enabled and otherPlayer.Parent do
                        updateESP(otherPlayer)
                        wait(0.1)
                    end
                end)
            end
        end
    else
        for targetPlayer, _ in pairs(Visuals.ESP.Players) do
            removeESP(targetPlayer)
        end
    end
end

-- Функции Tracers
local function updateTracer(targetPlayer)
    if not Visuals.Tracers.Enabled then return end
    
    local data = getPlayerData(targetPlayer)
    if not data then return end
    
    -- Проверяем дистанцию
    if data.Distance > Visuals.Tracers.MaxDistance then
        if Visuals.Tracers.Lines[targetPlayer] then
            Visuals.Tracers.Lines[targetPlayer].Visible = false
        end
        return
    end
    
    -- Создаем трассер если еще не создан
    if not Visuals.Tracers.Lines[targetPlayer] then
        local tracer = Instance.new("Frame")
        tracer.Name = targetPlayer.Name .. "_TRACER"
        tracer.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        tracer.BorderSizePixel = 0
        tracer.Size = UDim2.new(0, 2, 0, 100)
        tracer.AnchorPoint = Vector2.new(0.5, 0)
        tracer.Visible = false
        tracer.Parent = CoreGui

        Visuals.Tracers.Lines[targetPlayer] = tracer
    end
    
    local tracer = Visuals.Tracers.Lines[targetPlayer]
    if not tracer then return end
    
    local screenPoint, onScreen = camera:WorldToViewportPoint(data.RootPart.Position)
    
    if onScreen then
        tracer.Visible = true
        tracer.Position = UDim2.new(0, screenPoint.X, 0, screenPoint.Y)
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local playerScreenPos = camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            local delta = Vector2.new(screenPoint.X - playerScreenPos.X, screenPoint.Y - playerScreenPos.Y)
            local length = math.min(math.sqrt(delta.X * delta.X + delta.Y * delta.Y), 300)
            local angle = math.atan2(delta.Y, delta.X)
            
            tracer.Size = UDim2.new(0, 2, 0, length)
            tracer.Rotation = math.deg(angle) + 90
        end
    else
        tracer.Visible = false
    end
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
                spawn(function()
                    while Visuals.Tracers.Enabled and otherPlayer.Parent do
                        updateTracer(otherPlayer)
                        wait(0.1)
                    end
                end)
            end
        end
    else
        for targetPlayer, _ in pairs(Visuals.Tracers.Lines) do
            removeTracer(targetPlayer)
        end
    end
end

-- Функции Chams
local function updateChams(targetPlayer)
    if not Visuals.Chams.Enabled then return end
    
    local data = getPlayerData(targetPlayer)
    if not data then return end
    
    -- Проверяем дистанцию
    if data.Distance > Visuals.Chams.MaxDistance then
        if Visuals.Chams.Materials[targetPlayer] then
            for part, original in pairs(Visuals.Chams.Materials[targetPlayer]) do
                if part and part.Parent then
                    part.Material = original.Material
                    part.Transparency = original.Transparency
                end
            end
            Visuals.Chams.Materials[targetPlayer] = nil
        end
        return
    end
    
    -- Применяем Chams если еще не применены
    if not Visuals.Chams.Materials[targetPlayer] then
        Visuals.Chams.Materials[targetPlayer] = {}
        for _, part in pairs(data.Character:GetChildren()) do
            if part:IsA("BasePart") then
                Visuals.Chams.Materials[targetPlayer][part] = {
                    Material = part.Material,
                    Transparency = part.Transparency
                }
                part.Material = Enum.Material.ForceField
                part.Transparency = 0.3
            end
        end
    end
end

local function removeChams(targetPlayer)
    if Visuals.Chams.Materials[targetPlayer] then
        for part, original in pairs(Visuals.Chams.Materials[targetPlayer]) do
            if part and part.Parent then
                part.Material = original.Material
                part.Transparency = original.Transparency
            end
        end
        Visuals.Chams.Materials[targetPlayer] = nil
    end
end

local function toggleChams()
    if Visuals.Chams.Enabled then
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                spawn(function()
                    while Visuals.Chams.Enabled and otherPlayer.Parent do
                        updateChams(otherPlayer)
                        wait(0.5) -- Chams не нужно обновлять так часто
                    end
                end)
            end
        end
    else
        for targetPlayer, _ in pairs(Visuals.Chams.Materials) do
            removeChams(targetPlayer)
        end
    end
end

-- Функции Box ESP
local function updateBox(targetPlayer)
    if not Visuals.Boxes.Enabled then return end
    
    local data = getPlayerData(targetPlayer)
    if not data then return end
    
    -- Проверяем дистанцию
    if data.Distance > Visuals.Boxes.MaxDistance then
        if Visuals.Boxes.Boxes[targetPlayer] then
            Visuals.Boxes.Boxes[targetPlayer].Visible = false
        end
        return
    end
    
    -- Создаем бокс если еще не создан
    if not Visuals.Boxes.Boxes[targetPlayer] then
        local box = Instance.new("BoxHandleAdornment")
        box.Name = targetPlayer.Name .. "_BOX"
        box.Adornee = data.RootPart
        box.AlwaysOnTop = true
        box.ZIndex = 0
        box.Size = data.RootPart.Size + Vector3.new(0.2, 0.2, 0.2)
        box.Transparency = 0.7
        box.Color3 = Color3.fromRGB(0, 255, 0)
        box.Parent = Workspace

        Visuals.Boxes.Boxes[targetPlayer] = box
    end
    
    local box = Visuals.Boxes.Boxes[targetPlayer]
    if box then
        box.Visible = true
        -- Обновляем позицию бокса если персонаж изменился
        if box.Adornee ~= data.RootPart then
            box.Adornee = data.RootPart
        end
    end
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
                spawn(function()
                    while Visuals.Boxes.Enabled and otherPlayer.Parent do
                        updateBox(otherPlayer)
                        wait(0.1)
                    end
                end)
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
        spawn(function()
            while Visuals.ESP.Enabled and newPlayer.Parent do
                updateESP(newPlayer)
                wait(0.1)
            end
        end)
    end
    if Visuals.Tracers.Enabled then
        spawn(function()
            while Visuals.Tracers.Enabled and newPlayer.Parent do
                updateTracer(newPlayer)
                wait(0.1)
            end
        end)
    end
    if Visuals.Chams.Enabled then
        spawn(function()
            while Visuals.Chams.Enabled and newPlayer.Parent do
                updateChams(newPlayer)
                wait(0.5)
            end
        end)
    end
    if Visuals.Boxes.Enabled then
        spawn(function()
            while Visuals.Boxes.Enabled and newPlayer.Parent do
                updateBox(newPlayer)
                wait(0.1)
            end
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
                    TweenService:Create(frame.button, TweenInfo.new(0.2), {
                        BackgroundColor3 = tabColors[name],
                        TextColor3 = Color3.fromRGB(255, 255, 255)
                    }):Play()
                    
                    TweenService:Create(frame.content, TweenInfo.new(0.3), {
                        Position = UDim2.new(0, 0, 0, 0)
                    }):Play()
                else
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
                Visuals[feature.setting][feature.value] = not Visuals[feature.setting][feature.value]
                button.BackgroundColor3 = Visuals[feature.setting][feature.value] and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(50, 50, 70)
            else
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
        if Visuals.ESP.Enabled then
            spawn(function()
                while Visuals.ESP.Enabled and otherPlayer.Parent do
                    updateESP(otherPlayer)
                    wait(0.1)
                end
            end)
        end
        if Visuals.Tracers.Enabled then
            spawn(function()
                while Visuals.Tracers.Enabled and otherPlayer.Parent do
                    updateTracer(otherPlayer)
                    wait(0.1)
                end
            end)
        end
        if Visuals.Chams.Enabled then
            spawn(function()
                while Visuals.Chams.Enabled and otherPlayer.Parent do
                    updateChams(otherPlayer)
                    wait(0.5)
                end
            end)
        end
        if Visuals.Boxes.Enabled then
            spawn(function()
                while Visuals.Boxes.Enabled and otherPlayer.Parent do
                    updateBox(otherPlayer)
                    wait(0.1)
                end
            end)
        end
    end
end

print("gigasikDLC LOADED! Visuals working with distance limit!")
