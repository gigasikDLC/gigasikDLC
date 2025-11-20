-- Premium Menu with Crosshair & All Features
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local isMobile = UserInputService.TouchEnabled

-- Settings
local Settings = {
    Menu = {Key = Enum.KeyCode.Y, Visible = false},
    BunnyHop = {Enabled = false, Speed = 50},
    Hitbox = {Enabled = false, Size = 6},
    ESP = {Enabled = false},
    Fly = {Enabled = false, Speed = 50},
    Speed = {Enabled = false, WalkSpeed = 40},
    ThirdPerson = {Enabled = false, Distance = 10},
    Crosshair = {
        Enabled = false,
        Type = "Dot",
        Color = Color3.fromRGB(255, 255, 255),
        Rainbow = false,
        Size = 8
    }
}

-- Crosshair
local crosshairGui = Instance.new("ScreenGui")
crosshairGui.Name = "Crosshair"
crosshairGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
crosshairGui.ResetOnSpawn = false
crosshairGui.Parent = CoreGui

local crosshairFrame = Instance.new("Frame")
crosshairFrame.Size = UDim2.new(0, Settings.Crosshair.Size, 0, Settings.Crosshair.Size)
crosshairFrame.Position = UDim2.new(0.5, -Settings.Crosshair.Size/2, 0.5, -Settings.Crosshair.Size/2)
crosshairFrame.BackgroundColor3 = Settings.Crosshair.Color
crosshairFrame.BorderSizePixel = 0
crosshairFrame.Visible = false
crosshairFrame.Parent = crosshairGui

local crosshairCorner = Instance.new("UICorner")
crosshairCorner.CornerRadius = UDim.new(1, 0)
crosshairCorner.Parent = crosshairFrame

-- Rainbow crosshair effect
local rainbowConnection
if Settings.Crosshair.Rainbow then
    rainbowConnection = RunService.Heartbeat:Connect(function()
        local time = tick()
        local r = math.sin(time * 2) * 0.5 + 0.5
        local g = math.sin(time * 2 + 2) * 0.5 + 0.5
        local b = math.sin(time * 2 + 4) * 0.5 + 0.5
        crosshairFrame.BackgroundColor3 = Color3.new(r, g, b)
    end)
end

local function updateCrosshair()
    crosshairFrame.Visible = Settings.Crosshair.Enabled
    
    if Settings.Crosshair.Type == "Dot" then
        crosshairCorner.CornerRadius = UDim.new(1, 0)
        crosshairFrame.Size = UDim2.new(0, Settings.Crosshair.Size, 0, Settings.Crosshair.Size)
    elseif Settings.Crosshair.Type == "Circle" then
        crosshairCorner.CornerRadius = UDim.new(1, 0)
        crosshairFrame.Size = UDim2.new(0, Settings.Crosshair.Size, 0, Settings.Crosshair.Size)
    end
    
    if not Settings.Crosshair.Rainbow then
        crosshairFrame.BackgroundColor3 = Settings.Crosshair.Color
    end
    
    crosshairFrame.Position = UDim2.new(0.5, -Settings.Crosshair.Size/2, 0.5, -Settings.Crosshair.Size/2)
end

-- Bunny Hop
local function bunnyHop()
    if not Settings.BunnyHop.Enabled then return end
    if not player.Character then return end
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    
    if humanoid and rootPart and humanoid.FloorMaterial ~= Enum.Material.Air then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        
        local currentVel = rootPart.Velocity
        local lookVector = rootPart.CFrame.LookVector
        
        local newVelocity = Vector3.new(
            lookVector.X * Settings.BunnyHop.Speed,
            currentVel.Y,
            lookVector.Z * Settings.BunnyHop.Speed
        )
        
        rootPart.Velocity = newVelocity
    end
end

-- Hitbox
local function updateHitboxes()
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local root = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                if Settings.Hitbox.Enabled then
                    root.Size = Vector3.new(Settings.Hitbox.Size, Settings.Hitbox.Size, Settings.Hitbox.Size)
                    root.Transparency = 0.5
                    root.BrickColor = BrickColor.new("Bright red")
                else
                    root.Size = Vector3.new(2, 2, 1)
                    root.Transparency = 1
                    root.BrickColor = BrickColor.new("Medium stone grey")
                end
            end
        end
    end
end

-- ESP
local espFolder = Instance.new("Folder")
espFolder.Name = "JOPAMOD_ESP"
espFolder.Parent = CoreGui

local function createESP(targetPlayer)
    if not targetPlayer.Character then return end
    
    local char = targetPlayer.Character
    local root = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    
    if not root or not head then return end

    local box = Instance.new("BoxHandleAdornment")
    box.Name = targetPlayer.Name .. "_BOX"
    box.Adornee = root
    box.AlwaysOnTop = true
    box.ZIndex = 1
    box.Size = root.Size + Vector3.new(0.2, 0.2, 0.2)
    box.Transparency = 0.3
    box.Color3 = Color3.fromRGB(255, 50, 50)
    box.Parent = espFolder

    local tag = Instance.new("BillboardGui")
    tag.Name = targetPlayer.Name .. "_TAG"
    tag.Adornee = head
    tag.Size = UDim2.new(0, 200, 0, 50)
    tag.StudsOffset = Vector3.new(0, 3, 0)
    tag.AlwaysOnTop = true
    tag.Parent = espFolder

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = targetPlayer.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = tag

    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    distLabel.TextStrokeTransparency = 0
    distLabel.TextSize = 12
    distLabel.Font = Enum.Font.Gotham
    distLabel.Parent = tag

    RunService.Heartbeat:Connect(function()
        if not char or not root then
            box:Destroy()
            tag:Destroy()
            return
        end
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (root.Position - player.Character.HumanoidRootPart.Position).Magnitude
            distLabel.Text = math.floor(dist) .. " studs"
        end
    end)
end

local function toggleESP()
    for _, child in pairs(espFolder:GetChildren()) do
        child:Destroy()
    end
    
    if Settings.ESP.Enabled then
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                spawn(function()
                    if otherPlayer.Character then
                        wait(0.5)
                        createESP(otherPlayer)
                    end
                    otherPlayer.CharacterAdded:Connect(function()
                        wait(0.5)
                        createESP(otherPlayer)
                    end)
                end)
            end
        end
    end
end

-- Fly
local flyBV
local function updateFly()
    if not Settings.Fly.Enabled then
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
        direction = direction + Workspace.CurrentCamera.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        direction = direction - Workspace.CurrentCamera.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        direction = direction - Workspace.CurrentCamera.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        direction = direction + Workspace.CurrentCamera.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        direction = direction + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        direction = direction - Vector3.new(0, 1, 0)
    end
    
    flyBV.Velocity = direction * Settings.Fly.Speed
end

-- Speed
local function updateSpeed()
    if not player.Character then return end
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if humanoid then
        if Settings.Speed.Enabled then
            humanoid.WalkSpeed = Settings.Speed.WalkSpeed
        else
            humanoid.WalkSpeed = 16
        end
    end
end

-- Third Person
local function toggleThirdPerson()
    if Settings.ThirdPerson.Enabled then
        Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    else
        Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    end
end

local function updateThirdPerson()
    if not Settings.ThirdPerson.Enabled then return end
    if not player.Character then return end
    
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if root then
        local offset = CFrame.new(Settings.ThirdPerson.Distance, 3, Settings.ThirdPerson.Distance)
        Workspace.CurrentCamera.CFrame = root.CFrame * offset
    end
end

-- Menu Creation
local function createPremiumMenu()
    if CoreGui:FindFirstChild("PremiumMenu") then
        CoreGui:FindFirstChild("PremiumMenu"):Destroy()
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "PremiumMenu"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    local mobileButton
    if isMobile then
        mobileButton = Instance.new("ImageButton")
        mobileButton.Size = UDim2.new(0, 70, 0, 70)
        mobileButton.Position = UDim2.new(0, 30, 0, 30)
        mobileButton.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
        mobileButton.Image = ""
        mobileButton.Parent = gui
        
        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(155, 89, 182)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(52, 152, 219))
        })
        gradient.Rotation = 45
        gradient.Parent = mobileButton
        
        local icon = Instance.new("TextLabel")
        icon.Size = UDim2.new(1, 0, 1, 0)
        icon.BackgroundTransparency = 1
        icon.Text = "✨"
        icon.TextColor3 = Color3.fromRGB(255, 255, 255)
        icon.TextSize = 24
        icon.Font = Enum.Font.GothamBold
        icon.Parent = mobileButton
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = mobileButton
        
        local shadow = Instance.new("ImageLabel")
        shadow.Size = UDim2.new(1, 20, 1, 20)
        shadow.Position = UDim2.new(0, -10, 0, -10)
        shadow.BackgroundTransparency = 1
        shadow.Image = "rbxassetid://5554236805"
        shadow.ImageColor3 = Color3.fromRGB(155, 89, 182)
        shadow.ImageTransparency = 0.7
        shadow.ScaleType = Enum.ScaleType.Slice
        shadow.SliceScale = 0.02
        shadow.Parent = mobileButton
    end

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 500, 0, 600)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    mainFrame.BackgroundTransparency = 0.95
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.Parent = gui

    local glass = Instance.new("ImageLabel")
    glass.Size = UDim2.new(1, 0, 1, 0)
    glass.BackgroundTransparency = 1
    glass.Image = "rbxassetid://8992230675"
    glass.ImageColor3 = Color3.fromRGB(255, 255, 255)
    glass.ImageTransparency = 0.9
    glass.ScaleType = Enum.ScaleType.Slice
    glass.SliceScale = 0.02
    glass.Parent = mainFrame

    local borderGlow = Instance.new("Frame")
    borderGlow.Size = UDim2.new(1, 4, 1, 4)
    borderGlow.Position = UDim2.new(0, -2, 0, -2)
    borderGlow.BackgroundColor3 = Color3.fromRGB(155, 89, 182)
    borderGlow.BackgroundTransparency = 0.8
    borderGlow.BorderSizePixel = 0
    borderGlow.Parent = mainFrame
    
    local borderCorner = Instance.new("UICorner")
    borderCorner.CornerRadius = UDim.new(0.08, 0)
    borderCorner.Parent = borderGlow

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.08, 0)
    corner.Parent = mainFrame

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 70)
    header.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    header.BorderSizePixel = 0
    header.Parent = mainFrame

    local headerGradient = Instance.new("UIGradient")
    headerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(155, 89, 182)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(52, 152, 219)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(46, 204, 113))
    })
    headerGradient.Rotation = 45
    headerGradient.Parent = header

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚡ PREMIUM MENU"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.TextStrokeTransparency = 0.8
    title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    title.Parent = header

    local closeBtn = Instance.new("ImageButton")
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -45, 0.5, -20)
    closeBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
    closeBtn.BorderSizePixel = 0
    closeBtn.Image = ""
    closeBtn.Parent = header

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0.3, 0)
    closeCorner.Parent = closeBtn

    local closeText = Instance.new("TextLabel")
    closeText.Size = UDim2.new(1, 0, 1, 0)
    closeText.BackgroundTransparency = 1
    closeText.Text = "×"
    closeText.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeText.TextSize = 28
    closeText.Font = Enum.Font.GothamBold
    closeText.Parent = closeBtn

    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 0, 50)
    tabContainer.Position = UDim2.new(0, 0, 0, 70)
    tabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainFrame

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -20, 1, -140)
    content.Position = UDim2.new(0, 10, 0, 130)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 3
    content.ScrollBarImageColor3 = Color3.fromRGB(155, 89, 182)
    content.CanvasSize = UDim2.new(0, 0, 0, 1000)
    content.Parent = mainFrame

    local tabs = {
        {name = "🎮 MAIN", color = Color3.fromRGB(52, 152, 219)},
        {name = "⚙️ SETTINGS", color = Color3.fromRGB(155, 89, 182)},
        {name = "🎯 CROSSHAIR", color = Color3.fromRGB(46, 204, 113)}
    }

    local currentTab = "🎮 MAIN"
    local tabButtons = {}

    for i, tab in pairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(0.33, -5, 1, 0)
        tabButton.Position = UDim2.new((i-1) * 0.33, 0, 0, 0)
        tabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        tabButton.BorderSizePixel = 0
        tabButton.Text = tab.name
        tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabButton.TextSize = 14
        tabButton.Font = Enum.Font.GothamBold
        tabButton.Parent = tabContainer

        if i == 1 then
            tabButton.BackgroundColor3 = tab.color
            tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        tabButton.MouseButton1Click:Connect(function()
            currentTab = tab.name
            for _, btn in pairs(tabButtons) do
                btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
                btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
            tabButton.BackgroundColor3 = tab.color
            tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            updateContent()
        end)

        tabButtons[tab.name] = tabButton
    end

    local mainFeatures = {
        {name = "🚀 Fly Hack", desc = "Free movement in air", enabled = false, setting = "Fly"},
        {name = "🎯 ESP", desc = "See players through walls", enabled = false, setting = "ESP"},
        {name = "💨 Speed", desc = "Move faster", enabled = false, setting = "Speed"},
        {name = "🛡️ Anti-AFK", desc = "Prevent AFK detection", enabled = false, setting = "AntiAFK"},
        {name = "🐰 Bunny Hop", desc = "Auto jump while moving", enabled = false, setting = "BunnyHop"},
        {name = "🎯 Hitbox", desc = "Expand player hitboxes", enabled = false, setting = "Hitbox"},
        {name = "📷 3rd Person", desc = "Third person view", enabled = false, setting = "ThirdPerson"}
    }

    local crosshairSettings = {
        {name = "Crosshair Enabled", type = "toggle", setting = "Crosshair", value = "Enabled"},
        {name = "Crosshair Type", type = "dropdown", options = {"Dot", "Circle"}, setting = "Crosshair", value = "Type"},
        {name = "Crosshair Color", type = "color", setting = "Crosshair", value = "Color"},
        {name = "Rainbow Effect", type = "toggle", setting = "Crosshair", value = "Rainbow"},
        {name = "Crosshair Size", type = "slider", min = 4, max = 20, setting = "Crosshair", value = "Size"}
    }

    local function updateContent()
        for _, child in pairs(content:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        if currentTab == "🎮 MAIN" then
            for i, feature in pairs(mainFeatures) do
                local buttonContainer = Instance.new("Frame")
                buttonContainer.Size = UDim2.new(1, 0, 0, 70)
                buttonContainer.Position = UDim2.new(0, 0, 0, (i-1) * 80)
                buttonContainer.BackgroundTransparency = 1
                buttonContainer.Parent = content

                local button = Instance.new("TextButton")
                button.Size = UDim2.new(1, 0, 0, 60)
                button.Position = UDim2.new(0, 0, 0, 5)
                button.BackgroundColor3 = Settings[feature.setting].Enabled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(35, 35, 50)
                button.BorderSizePixel = 0
                button.Text = ""
                button.Parent = buttonContainer
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0.1, 0)
                buttonCorner.Parent = button
                
                local icon = Instance.new("TextLabel")
                icon.Size = UDim2.new(0, 50, 0, 50)
                icon.Position = UDim2.new(0, 15, 0.5, -25)
                icon.BackgroundTransparency = 1
                icon.Text = string.sub(feature.name, 1, 3)
                icon.TextColor3 = Color3.fromRGB(255, 255, 255)
                icon.TextSize = 20
                icon.Font = Enum.Font.GothamBold
                icon.Parent = button
                
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(0.7, 0, 0, 30)
                nameLabel.Position = UDim2.new(0, 80, 0, 8)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = feature.name
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.TextSize = 18
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                nameLabel.Parent = button
                
                local descLabel = Instance.new("TextLabel")
                descLabel.Size = UDim2.new(0.7, 0, 0, 20)
                descLabel.Position = UDim2.new(0, 80, 0, 38)
                descLabel.BackgroundTransparency = 1
                descLabel.Text = feature.desc
                descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                descLabel.TextSize = 12
                descLabel.Font = Enum.Font.Gotham
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                descLabel.Parent = button

                button.MouseButton1Click:Connect(function()
                    Settings[feature.setting].Enabled = not Settings[feature.setting].Enabled
                    button.BackgroundColor3 = Settings[feature.setting].Enabled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(35, 35, 50)
                    
                    if feature.setting == "ESP" then
                        toggleESP()
                    elseif feature.setting == "Hitbox" then
                        updateHitboxes()
                    elseif feature.setting == "ThirdPerson" then
                        toggleThirdPerson()
                    end
                end)
            end
            content.CanvasSize = UDim2.new(0, 0, 0, #mainFeatures * 80)

        elseif currentTab == "🎯 CROSSHAIR" then
            for i, setting in pairs(crosshairSettings) do
                local settingContainer = Instance.new("Frame")
                settingContainer.Size = UDim2.new(1, 0, 0, 60)
                settingContainer.Position = UDim2.new(0, 0, 0, (i-1) * 70)
                settingContainer.BackgroundTransparency = 1
                settingContainer.Parent = content

                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(0.6, 0, 1, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = setting.name
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.TextSize = 14
                nameLabel.Font = Enum.Font.Gotham
                nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                nameLabel.Parent = settingContainer

                if setting.type == "toggle" then
                    local toggle = Instance.new("TextButton")
                    toggle.Size = UDim2.new(0, 80, 0, 30)
                    toggle.Position = UDim2.new(1, -90, 0.5, -15)
                    toggle.BackgroundColor3 = Settings[setting.setting][setting.value] and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
                    toggle.BorderSizePixel = 0
                    toggle.Text = Settings[setting.setting][setting.value] and "ON" or "OFF"
                    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
                    toggle.TextSize = 12
                    toggle.Font = Enum.Font.GothamBold
                    toggle.Parent = settingContainer

                    local toggleCorner = Instance.new("UICorner")
                    toggleCorner.CornerRadius = UDim.new(0.3, 0)
                    toggleCorner.Parent = toggle

                    toggle.MouseButton1Click:Connect(function()
                        Settings[setting.setting][setting.value] = not Settings[setting.setting][setting.value]
                        toggle.BackgroundColor3 = Settings[setting.setting][setting.value] and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
                        toggle.Text = Settings[setting.setting][setting.value] and "ON" or "OFF"
                        updateCrosshair()
                    end)
                end
            end
            content.CanvasSize = UDim2.new(0, 0, 0, #crosshairSettings * 70)
        end
    end

    updateContent()

    local isOpen = false
    local currentTween

    local function openMenu()
        if isOpen then return end
        isOpen = true
        
        mainFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        mainFrame.BackgroundTransparency = 1
        borderGlow.BackgroundTransparency = 1
        
        if currentTween then
            currentTween:Cancel()
        end
        
        currentTween = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 500, 0, 600),
            Position = UDim2.new(0.5, -250, 0.5, -300),
            BackgroundTransparency = 0.05
        })
        currentTween:Play()
        
        delay(0.2, function()
            TweenService:Create(borderGlow, TweenInfo.new(0.3), {BackgroundTransparency = 0.8}):Play()
        end)
    end

    local function closeMenu()
        if not isOpen then return end
        isOpen = false
        
        if currentTween then
            currentTween:Cancel()
        end
        
        TweenService:Create(borderGlow, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
        
        currentTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        })
        currentTween:Play()
        
        currentTween.Completed:Connect(function()
            mainFrame.Visible = false
        end)
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.Y then
            if isOpen then
                closeMenu()
            else
                openMenu()
            end
        end
    end)

    if isMobile then
        mobileButton.MouseButton1Click:Connect(function()
            if isOpen then
                closeMenu()
            else
                openMenu()
            end
        end)
    end

    closeBtn.MouseButton1Click:Connect(function()
        closeMenu()
    end)

    return {
        Open = openMenu,
        Close = closeMenu,
        IsOpen = function() return isOpen end
    }
end

-- Initialize everything
local menu = createPremiumMenu()

-- Main game loop
RunService.Heartbeat:Connect(function()
    pcall(function()
        bunnyHop()
        updateFly()
        updateSpeed()
        updateThirdPerson()
        updateCrosshair()
    end)
end)

-- Player handling
Players.PlayerAdded:Connect(function(newPlayer)
    if Settings.ESP.Enabled then
        spawn(function()
            newPlayer.CharacterAdded:Connect(function()
                wait(1)
                createESP(newPlayer)
            end)
        end)
    end
end)

player.CharacterAdded:Connect(function()
    if Settings.Hitbox.Enabled then
        wait(1)
        updateHitboxes()
    end
    if Settings.ESP.Enabled then
        wait(1)
        toggleESP()
    end
    if flyBV then
        flyBV:Destroy()
        flyBV = nil
    end
end)

-- Initial setup
delay(2, function()
    if Settings.ESP.Enabled then
        toggleESP()
    end
    if Settings.Hitbox.Enabled then
        updateHitboxes()
    end
    updateCrosshair()
end)

print("✨ FUESOS Optimazing Loaded!")
print(isMobile and "DIEGO SOLO")
