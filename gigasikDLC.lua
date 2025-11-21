local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- Настройки всех функций
local Settings = {
    Visuals = {
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
    },
    Combat = {
        AimAssist = {Enabled = false, FOV = 30, Smoothing = 0.5},
        TriggerBot = {Enabled = false, Delay = 0.1},
        NoRecoil = {Enabled = false},
        RapidFire = {Enabled = false, Speed = 2},
        Hitboxes = {Enabled = false, Size = 6}
    },
    Fun = {
        Fly = {Enabled = false, Speed = 50},
        Speed = {Enabled = false, WalkSpeed = 40},
        BHop = {Enabled = false, Speed = 50},
        Noclip = {Enabled = false},
        SuperJump = {Enabled = false, Power = 100}
    }
}

-- Переменные для функций
local flyBV
local noclipConnection
local originalSizes = {}
local originalWalkSpeed = 16
local originalJumpPower = 50

-- Функции Visuals (остаются без изменений)
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

-- ESP функции
local function updateESP(targetPlayer)
    if not Settings.Visuals.ESP.Enabled then return end
    
    local data = getPlayerData(targetPlayer)
    if not data then return end
    
    if data.Distance > Settings.Visuals.ESP.MaxDistance then
        if Settings.Visuals.ESP.Players[targetPlayer] then
            Settings.Visuals.ESP.Players[targetPlayer].Box.Visible = false
            Settings.Visuals.ESP.Players[targetPlayer].Billboard.Enabled = false
        end
        return
    end
    
    if not Settings.Visuals.ESP.Players[targetPlayer] then
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

        Settings.Visuals.ESP.Players[targetPlayer] = {
            Box = box,
            Billboard = billboard,
            InfoLabel = infoLabel
        }
    end
    
    local espData = Settings.Visuals.ESP.Players[targetPlayer]
    if espData then
        espData.Box.Visible = true
        espData.Billboard.Enabled = true
        
        local infoText = ""
        if Settings.Visuals.ESP.ShowName then
            infoText = targetPlayer.Name .. "\n"
        end
        if Settings.Visuals.ESP.ShowDistance then
            infoText = infoText .. math.floor(data.Distance) .. " studs\n"
        end
        if Settings.Visuals.ESP.ShowHealth and data.Humanoid then
            local healthPercent = data.Humanoid.Health / data.Humanoid.MaxHealth
            local healthColor = healthPercent > 0.7 and "🟢" or healthPercent > 0.3 and "🟡" or "🔴"
            infoText = infoText .. healthColor .. " " .. math.floor(data.Humanoid.Health)
        end
        
        espData.InfoLabel.Text = infoText
        
        if espData.Box.Adornee ~= data.RootPart then
            espData.Box.Adornee = data.RootPart
        end
        if espData.Billboard.Adornee ~= data.Head then
            espData.Billboard.Adornee = data.Head
        end
    end
end

local function removeESP(targetPlayer)
    if Settings.Visuals.ESP.Players[targetPlayer] then
        if Settings.Visuals.ESP.Players[targetPlayer].Box then
            Settings.Visuals.ESP.Players[targetPlayer].Box:Destroy()
        end
        if Settings.Visuals.ESP.Players[targetPlayer].Billboard then
            Settings.Visuals.ESP.Players[targetPlayer].Billboard:Destroy()
        end
        Settings.Visuals.ESP.Players[targetPlayer] = nil
    end
end

local function toggleESP()
    if Settings.Visuals.ESP.Enabled then
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                spawn(function()
                    while Settings.Visuals.ESP.Enabled and otherPlayer.Parent do
                        updateESP(otherPlayer)
                        wait(0.1)
                    end
                end)
            end
        end
    else
        for targetPlayer, _ in pairs(Settings.Visuals.ESP.Players) do
            removeESP(targetPlayer)
        end
    end
end

-- Tracers функции
local function updateTracer(targetPlayer)
    if not Settings.Visuals.Tracers.Enabled then return end
    
    local data = getPlayerData(targetPlayer)
    if not data then return end
    
    if data.Distance > Settings.Visuals.Tracers.MaxDistance then
        if Settings.Visuals.Tracers.Lines[targetPlayer] then
            Settings.Visuals.Tracers.Lines[targetPlayer].Visible = false
        end
        return
    end
    
    if not Settings.Visuals.Tracers.Lines[targetPlayer] then
        local tracer = Instance.new("Frame")
        tracer.Name = targetPlayer.Name .. "_TRACER"
        tracer.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        tracer.BorderSizePixel = 0
        tracer.Size = UDim2.new(0, 2, 0, 100)
        tracer.AnchorPoint = Vector2.new(0.5, 0)
        tracer.Visible = false
        tracer.Parent = CoreGui

        Settings.Visuals.Tracers.Lines[targetPlayer] = tracer
    end
    
    local tracer = Settings.Visuals.Tracers.Lines[targetPlayer]
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
    if Settings.Visuals.Tracers.Lines[targetPlayer] then
        Settings.Visuals.Tracers.Lines[targetPlayer]:Destroy()
        Settings.Visuals.Tracers.Lines[targetPlayer] = nil
    end
end

local function toggleTracers()
    if Settings.Visuals.Tracers.Enabled then
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                spawn(function()
                    while Settings.Visuals.Tracers.Enabled and otherPlayer.Parent do
                        updateTracer(otherPlayer)
                        wait(0.1)
                    end
                end)
            end
        end
    else
        for targetPlayer, _ in pairs(Settings.Visuals.Tracers.Lines) do
            removeTracer(targetPlayer)
        end
    end
end

-- Chams функции
local function updateChams(targetPlayer)
    if not Settings.Visuals.Chams.Enabled then return end
    
    local data = getPlayerData(targetPlayer)
    if not data then return end
    
    if data.Distance > Settings.Visuals.Chams.MaxDistance then
        if Settings.Visuals.Chams.Materials[targetPlayer] then
            for part, original in pairs(Settings.Visuals.Chams.Materials[targetPlayer]) do
                if part and part.Parent then
                    part.Material = original.Material
                    part.Transparency = original.Transparency
                end
            end
            Settings.Visuals.Chams.Materials[targetPlayer] = nil
        end
        return
    end
    
    if not Settings.Visuals.Chams.Materials[targetPlayer] then
        Settings.Visuals.Chams.Materials[targetPlayer] = {}
        for _, part in pairs(data.Character:GetChildren()) do
            if part:IsA("BasePart") then
                Settings.Visuals.Chams.Materials[targetPlayer][part] = {
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
    if Settings.Visuals.Chams.Materials[targetPlayer] then
        for part, original in pairs(Settings.Visuals.Chams.Materials[targetPlayer]) do
            if part and part.Parent then
                part.Material = original.Material
                part.Transparency = original.Transparency
            end
        end
        Settings.Visuals.Chams.Materials[targetPlayer] = nil
    end
end

local function toggleChams()
    if Settings.Visuals.Chams.Enabled then
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                spawn(function()
                    while Settings.Visuals.Chams.Enabled and otherPlayer.Parent do
                        updateChams(otherPlayer)
                        wait(0.5)
                    end
                end)
            end
        end
    else
        for targetPlayer, _ in pairs(Settings.Visuals.Chams.Materials) do
            removeChams(targetPlayer)
        end
    end
end

-- Boxes функции
local function updateBox(targetPlayer)
    if not Settings.Visuals.Boxes.Enabled then return end
    
    local data = getPlayerData(targetPlayer)
    if not data then return end
    
    if data.Distance > Settings.Visuals.Boxes.MaxDistance then
        if Settings.Visuals.Boxes.Boxes[targetPlayer] then
            Settings.Visuals.Boxes.Boxes[targetPlayer].Visible = false
        end
        return
    end
    
    if not Settings.Visuals.Boxes.Boxes[targetPlayer] then
        local box = Instance.new("BoxHandleAdornment")
        box.Name = targetPlayer.Name .. "_BOX"
        box.Adornee = data.RootPart
        box.AlwaysOnTop = true
        box.ZIndex = 0
        box.Size = data.RootPart.Size + Vector3.new(0.2, 0.2, 0.2)
        box.Transparency = 0.7
        box.Color3 = Color3.fromRGB(0, 255, 0)
        box.Parent = Workspace

        Settings.Visuals.Boxes.Boxes[targetPlayer] = box
    end
    
    local box = Settings.Visuals.Boxes.Boxes[targetPlayer]
    if box then
        box.Visible = true
        if box.Adornee ~= data.RootPart then
            box.Adornee = data.RootPart
        end
    end
end

local function removeBox(targetPlayer)
    if Settings.Visuals.Boxes.Boxes[targetPlayer] then
        Settings.Visuals.Boxes.Boxes[targetPlayer]:Destroy()
        Settings.Visuals.Boxes.Boxes[targetPlayer] = nil
    end
end

local function toggleBoxes()
    if Settings.Visuals.Boxes.Enabled then
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                spawn(function()
                    while Settings.Visuals.Boxes.Enabled and otherPlayer.Parent do
                        updateBox(otherPlayer)
                        wait(0.1)
                    end
                end)
            end
        end
    else
        for targetPlayer, _ in pairs(Settings.Visuals.Boxes.Boxes) do
            removeBox(targetPlayer)
        end
    end
end

-- Combat функции
local function updateAimAssist()
    if not Settings.Combat.AimAssist.Enabled then return end
    if not player.Character then return end
    
    local mouse = player:GetMouse()
    local closestPlayer = nil
    local closestDistance = Settings.Combat.AimAssist.FOV
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local head = otherPlayer.Character:FindFirstChild("Head")
            if head then
                local screenPoint, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local mousePos = Vector2.new(mouse.X, mouse.Y)
                    local headPos = Vector2.new(screenPoint.X, screenPoint.Y)
                    local distance = (mousePos - headPos).Magnitude
                    
                    if distance < closestDistance then
                        closestPlayer = otherPlayer
                        closestDistance = distance
                    end
                end
            end
        end
    end
    
    if closestPlayer and closestPlayer.Character then
        local head = closestPlayer.Character:FindFirstChild("Head")
        if head then
            local screenPoint = camera:WorldToViewportPoint(head.Position)
            local targetPos = Vector2.new(screenPoint.X, screenPoint.Y)
            local currentPos = Vector2.new(mouse.X, mouse.Y)
            local newPos = currentPos:Lerp(targetPos, Settings.Combat.AimAssist.Smoothing)
            
            mousemoverel(newPos.X - currentPos.X, newPos.Y - currentPos.Y)
        end
    end
end

local function updateTriggerBot()
    if not Settings.Combat.TriggerBot.Enabled then return end
    if not player.Character then return end
    
    local mouse = player:GetMouse()
    local target = mouse.Target
    if target and target.Parent then
        local humanoid = target.Parent:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Parent ~= player.Character then
            mouse1click()
            wait(Settings.Combat.TriggerBot.Delay)
        end
    end
end

local function updateNoRecoil()
    if not Settings.Combat.NoRecoil.Enabled then return end
    
    -- Это зависит от игры, здесь базовая реализация
    for _, tool in pairs(player.Character:GetChildren()) do
        if tool:IsA("Tool") then
            local configuration = tool:FindFirstChild("Configuration")
            if configuration then
                local recoil = configuration:FindFirstChild("Recoil")
                if recoil then
                    recoil.Value = 0
                end
            end
        end
    end
end

local function updateRapidFire()
    if not Settings.Combat.RapidFire.Enabled then return end
    
    for _, tool in pairs(player.Character:GetChildren()) do
        if tool:IsA("Tool") then
            local configuration = tool:FindFirstChild("Configuration")
            if configuration then
                local fireRate = configuration:FindFirstChild("FireRate")
                if fireRate then
                    fireRate.Value = fireRate.Value * Settings.Combat.RapidFire.Speed
                end
            end
        end
    end
end

local function updateHitboxes()
    if not Settings.Combat.Hitboxes.Enabled then return end
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local root = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                if not originalSizes[otherPlayer] then
                    originalSizes[otherPlayer] = root.Size
                end
                
                root.Size = Vector3.new(Settings.Combat.Hitboxes.Size, Settings.Combat.Hitboxes.Size, Settings.Combat.Hitboxes.Size)
                root.Transparency = 0.5
                root.BrickColor = BrickColor.new("Bright red")
                root.Material = Enum.Material.Neon
            end
        end
    end
end

local function resetHitboxes()
    for otherPlayer, originalSize in pairs(originalSizes) do
        if otherPlayer.Character then
            local root = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.Size = originalSize
                root.Transparency = 1
                root.BrickColor = BrickColor.new("Medium stone grey")
                root.Material = Enum.Material.Plastic
            end
        end
    end
    originalSizes = {}
end

-- Fun функции
local function updateFly()
    if not Settings.Fun.Fly.Enabled then
        if flyBV then
            flyBV:Destroy()
            flyBV = nil
        end
        return
    end
    
    if not player.Character then return end
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    
    if not rootPart then return end
    
    if not flyBV then
        flyBV = Instance.new("BodyVelocity")
        flyBV.Velocity = Vector3.new(0, 0, 0)
        flyBV.MaxForce = Vector3.new(40000, 40000, 40000)
        flyBV.Parent = rootPart
        
        if humanoid then
            humanoid.PlatformStand = true
        end
    end
    
    local direction = Vector3.new(0, 0, 0)
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        direction = direction + camera.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        direction = direction - camera.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        direction = direction - camera.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        direction = direction + camera.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        direction = direction + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        direction = direction - Vector3.new(0, 1, 0)
    end
    
    flyBV.Velocity = direction * Settings.Fun.Fly.Speed
end

local function updateSpeed()
    if not player.Character then return end
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if humanoid then
        if Settings.Fun.Speed.Enabled then
            humanoid.WalkSpeed = Settings.Fun.Speed.WalkSpeed
        else
            humanoid.WalkSpeed = originalWalkSpeed
        end
    end
end

local function updateBHop()
    if not Settings.Fun.BHop.Enabled then return end
    if not player.Character then return end
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    
    if humanoid and rootPart and humanoid.FloorMaterial ~= Enum.Material.Air then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        
        local currentVel = rootPart.Velocity
        local lookVector = rootPart.CFrame.LookVector
        
        local newVelocity = Vector3.new(
            lookVector.X * Settings.Fun.BHop.Speed,
            currentVel.Y,
            lookVector.Z * Settings.Fun.BHop.Speed
        )
        
        rootPart.Velocity = newVelocity
    end
end

local function updateNoclip()
    if Settings.Fun.Noclip.Enabled then
        if not noclipConnection then
            noclipConnection = RunService.Stepped:Connect(function()
                if player.Character then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
    end
end

local function updateSuperJump()
    if not player.Character then return end
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if humanoid then
        if Settings.Fun.SuperJump.Enabled then
            humanoid.JumpPower = Settings.Fun.SuperJump.Power
        else
            humanoid.JumpPower = originalJumpPower
        end
    end
end

-- Обработчики игроков
Players.PlayerAdded:Connect(function(newPlayer)
    -- Visuals
    if Settings.Visuals.ESP.Enabled then
        spawn(function()
            while Settings.Visuals.ESP.Enabled and newPlayer.Parent do
                updateESP(newPlayer)
                wait(0.1)
            end
        end)
    end
    if Settings.Visuals.Tracers.Enabled then
        spawn(function()
            while Settings.Visuals.Tracers.Enabled and newPlayer.Parent do
                updateTracer(newPlayer)
                wait(0.1)
            end
        end)
    end
    if Settings.Visuals.Chams.Enabled then
        spawn(function()
            while Settings.Visuals.Chams.Enabled and newPlayer.Parent do
                updateChams(newPlayer)
                wait(0.5)
            end
        end)
    end
    if Settings.Visuals.Boxes.Enabled then
        spawn(function()
            while Settings.Visuals.Boxes.Enabled and newPlayer.Parent do
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

-- Главный цикл обновления
spawn(function()
    while true do
        -- Combat функции
        updateAimAssist()
        updateTriggerBot()
        updateNoRecoil()
        updateRapidFire()
        updateHitboxes()
        
        -- Fun функции
        updateFly()
        updateSpeed()
        updateBHop()
        updateNoclip()
        updateSuperJump()
        
        wait()
    end
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
        {name = "Player ESP", type = "toggle", setting = "Visuals", category = "ESP", value = "Enabled", func = toggleESP},
        {name = "Tracers", type = "toggle", setting = "Visuals", category = "Tracers", value = "Enabled", func = toggleTracers},
        {name = "Chams", type = "toggle", setting = "Visuals", category = "Chams", value = "Enabled", func = toggleChams},
        {name = "Box ESP", type = "toggle", setting = "Visuals", category = "Boxes", value = "Enabled", func = toggleBoxes},
        {name = "Show Names", type = "toggle", setting = "Visuals", category = "ESP", value = "ShowName"},
        {name = "Show Distance", type = "toggle", setting = "Visuals", category = "ESP", value = "ShowDistance"},
        {name = "Show Health", type = "toggle", setting = "Visuals", category = "ESP", value = "ShowHealth"}
    }

    local visualsContent = tabFrames["VISUALS"].content
    local yPosition = 0
    
    for i, feature in pairs(visualsFeatures) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 35)
        button.Position = UDim2.new(0, 0, 0, yPosition)
        
        local isEnabled = Settings[feature.setting][feature.category][feature.value]
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
            Settings[feature.setting][feature.category][feature.value] = not Settings[feature.setting][feature.category][feature.value]
            button.BackgroundColor3 = Settings[feature.setting][feature.category][feature.value] and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(50, 50, 70)
            
            if feature.func then
                feature.func()
            end
        end)

        yPosition = yPosition + 40
    end
    visualsContent.CanvasSize = UDim2.new(0, 0, 0, yPosition)

    -- Заполняем вкладку COMBAT
    local combatFeatures = {
        {name = "Aim Assist", type = "toggle", setting = "Combat", category = "AimAssist", value = "Enabled"},
        {name = "Trigger Bot", type = "toggle", setting = "Combat", category = "TriggerBot", value = "Enabled"},
        {name = "No Recoil", type = "toggle", setting = "Combat", category = "NoRecoil", value = "Enabled"},
        {name = "Rapid Fire", type = "toggle", setting = "Combat", category = "RapidFire", value = "Enabled"},
        {name = "Hitboxes", type = "toggle", setting = "Combat", category = "Hitboxes", value = "Enabled", func = function()
            if not Settings.Combat.Hitboxes.Enabled then
                resetHitboxes()
            end
        end}
    }

    local combatContent = tabFrames["COMBAT"].content
    yPosition = 0
    
    for i, feature in pairs(combatFeatures) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 35)
        button.Position = UDim2.new(0, 0, 0, yPosition)
        
        local isEnabled = Settings[feature.setting][feature.category][feature.value]
        button.BackgroundColor3 = isEnabled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(50, 50, 70)
        button.BorderSizePixel = 0
        button.Text = feature.name
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 14
        button.Font = Enum.Font.Gotham
        button.Parent = combatContent
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0.1, 0)
        buttonCorner.Parent = button

        button.MouseButton1Click:Connect(function()
            Settings[feature.setting][feature.category][feature.value] = not Settings[feature.setting][feature.category][feature.value]
            button.BackgroundColor3 = Settings[feature.setting][feature.category][feature.value] and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(50, 50, 70)
            
            if feature.func then
                feature.func()
            end
        end)

        yPosition = yPosition + 40
    end
    combatContent.CanvasSize = UDim2.new(0, 0, 0, yPosition)

    -- Заполняем вкладку FUN
    local funFeatures = {
        {name = "Fly Hack", type = "toggle", setting = "Fun", category = "Fly", value = "Enabled"},
        {name = "Speed Hack", type = "toggle", setting = "Fun", category = "Speed", value = "Enabled"},
        {name = "Bunny Hop", type = "toggle", setting = "Fun", category = "BHop", value = "Enabled"},
        {name = "Noclip", type = "toggle", setting = "Fun", category = "Noclip", value = "Enabled"},
        {name = "Super Jump", type = "toggle", setting = "Fun", category = "SuperJump", value = "Enabled"}
    }

    local funContent = tabFrames["FUN"].content
    yPosition = 0
    
    for i, feature in pairs(funFeatures) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 35)
        button.Position = UDim2.new(0, 0, 0, yPosition)
        
        local isEnabled = Settings[feature.setting][feature.category][feature.value]
        button.BackgroundColor3 = isEnabled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(50, 50, 70)
        button.BorderSizePixel = 0
        button.Text = feature.name
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 14
        button.Font = Enum.Font.Gotham
        button.Parent = funContent
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0.1, 0)
        buttonCorner.Parent = button

        button.MouseButton1Click:Connect(function()
            Settings[feature.setting][feature.category][feature.value] = not Settings[feature.setting][feature.category][feature.value]
            button.BackgroundColor3 = Settings[feature.setting][feature.category][feature.value] and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(50, 50, 70)
        end)

        yPosition = yPosition + 40
    end
    funContent.CanvasSize = UDim2.new(0, 0, 0, yPosition)

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
        if Settings.Visuals.ESP.Enabled then
            spawn(function()
                while Settings.Visuals.ESP.Enabled and otherPlayer.Parent do
                    updateESP(otherPlayer)
                    wait(0.1)
                end
            end)
        end
        if Settings.Visuals.Tracers.Enabled then
            spawn(function()
                while Settings.Visuals.Tracers.Enabled and otherPlayer.Parent do
                    updateTracer(otherPlayer)
                    wait(0.1)
                end
            end)
        end
        if Settings.Visuals.Chams.Enabled then
            spawn(function()
                while Settings.Visuals.Chams.Enabled and otherPlayer.Parent do
                    updateChams(otherPlayer)
                    wait(0.5)
                end
            end)
        end
        if Settings.Visuals.Boxes.Enabled then
            spawn(function()
                while Settings.Visuals.Boxes.Enabled and otherPlayer.Parent do
                    updateBox(otherPlayer)
                    wait(0.1)
                end
            end)
        end
    end
end

-- Сохранение оригинальных значений
if player.Character then
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if humanoid then
        originalWalkSpeed = humanoid.WalkSpeed
        originalJumpPower = humanoid.JumpPower
    end
end

player.CharacterAdded:Connect(function(character)
    wait(1)
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        originalWalkSpeed = humanoid.WalkSpeed
        originalJumpPower = humanoid.JumpPower
    end
end)

print("gigasikDLC FULLY LOADED! All features are working!")
