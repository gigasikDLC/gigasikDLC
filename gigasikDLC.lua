
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

local Settings = {
    BunnyHop = {Enabled = false, Speed = 50},
    Hitbox = {Enabled = false, Size = 6},
    ESP = {Enabled = false, ShowDistance = true, ShowHealth = true},
    Fly = {Enabled = false, Speed = 50},
    Speed = {Enabled = false, WalkSpeed = 40},
    ThirdPerson = {Enabled = false, Distance = 10},
    Crosshair = {Enabled = false, Rainbow = false, Size = 8, Position = 0.55}
}

local crosshairGui = Instance.new("ScreenGui")
crosshairGui.Name = "Crosshair"
crosshairGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
crosshairGui.ResetOnSpawn = false
crosshairGui.Parent = CoreGui

local crosshairFrame = Instance.new("Frame")
crosshairFrame.Size = UDim2.new(0, Settings.Crosshair.Size, 0, Settings.Crosshair.Size)
crosshairFrame.Position = UDim2.new(0.5, -Settings.Crosshair.Size/2, Settings.Crosshair.Position, -Settings.Crosshair.Size/2)
crosshairFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
crosshairFrame.BorderSizePixel = 0
crosshairFrame.Visible = false
crosshairFrame.Parent = crosshairGui

local crosshairCorner = Instance.new("UICorner")
crosshairCorner.CornerRadius = UDim.new(1, 0)
crosshairCorner.Parent = crosshairFrame

local rainbowConnection
local function updateCrosshair()
    crosshairFrame.Visible = Settings.Crosshair.Enabled
    
    if Settings.Crosshair.Enabled and Settings.Crosshair.Rainbow then
        if not rainbowConnection then
            rainbowConnection = RunService.Heartbeat:Connect(function()
                if not Settings.Crosshair.Enabled or not Settings.Crosshair.Rainbow then
                    if rainbowConnection then
                        rainbowConnection:Disconnect()
                        rainbowConnection = nil
                    end
                    return
                end
                local time = tick()
                local r = math.sin(time * 2) * 0.5 + 0.5
                local g = math.sin(time * 2 + 2) * 0.5 + 0.5
                local b = math.sin(time * 2 + 4) * 0.5 + 0.5
                crosshairFrame.BackgroundColor3 = Color3.new(r, g, b)
            end)
        end
    else
        if rainbowConnection then
            rainbowConnection:Disconnect()
            rainbowConnection = nil
        end
        crosshairFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    crosshairFrame.Size = UDim2.new(0, Settings.Crosshair.Size, 0, Settings.Crosshair.Size)
    crosshairFrame.Position = UDim2.new(0.5, -Settings.Crosshair.Size/2, Settings.Crosshair.Position, -Settings.Crosshair.Size/2)
end

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

local originalSizes = {}
local function updateHitboxes()
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local root = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                if Settings.Hitbox.Enabled then
                    if not originalSizes[otherPlayer] then
                        originalSizes[otherPlayer] = root.Size
                    end
                    root.Size = Vector3.new(Settings.Hitbox.Size, Settings.Hitbox.Size, Settings.Hitbox.Size)
                    root.Transparency = 0.5
                    root.BrickColor = BrickColor.new("Bright red")
                    root.Material = Enum.Material.Neon
                else
                    if originalSizes[otherPlayer] then
                        root.Size = originalSizes[otherPlayer]
                        root.Transparency = 1
                        root.BrickColor = BrickColor.new("Medium stone grey")
                        root.Material = Enum.Material.Plastic
                    end
                end
            end
        end
    end
end

local espFolder = Instance.new("Folder")
espFolder.Name = "gigasikDLC_ESP"
espFolder.Parent = CoreGui

local function createESP(targetPlayer)
    if not Settings.ESP.Enabled then return end
    if not targetPlayer.Character then return end
    
    local char = targetPlayer.Character
    local root = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    local humanoid = char:FindFirstChild("Humanoid")
    
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

    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, 0, 0.5, 0)
    infoLabel.Position = UDim2.new(0, 0, 0.5, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    infoLabel.TextStrokeTransparency = 0
    infoLabel.TextSize = 12
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.Parent = tag

    local espConnection
    espConnection = RunService.Heartbeat:Connect(function()
        if not Settings.ESP.Enabled or not char or not root then
            if box then box:Destroy() end
            if tag then tag:Destroy() end
            if espConnection then espConnection:Disconnect() end
            return
        end
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (root.Position - player.Character.HumanoidRootPart.Position).Magnitude
            local infoText = ""
            
            if Settings.ESP.ShowDistance then
                infoText = math.floor(dist) .. " studs"
            end
            
            if Settings.ESP.ShowHealth and humanoid then
                if infoText ~= "" then infoText = infoText .. " | " end
                infoText = infoText .. math.floor(humanoid.Health) .. " HP"
            end
            
            infoLabel.Text = infoText
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
                if otherPlayer.Character then
                    spawn(function()
                        wait(0.5)
                        createESP(otherPlayer)
                    end)
                end
                otherPlayer.CharacterAdded:Connect(function(char)
                    wait(0.5)
                    createESP(otherPlayer)
                end)
            end
        end
    end
end

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

local function createMobileMenu()
    if CoreGui:FindFirstChild("gigasikDLC") then
        CoreGui:FindFirstChild("gigasikDLC"):Destroy()
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "gigasikDLC"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    local floatingButton = Instance.new("ImageButton")
    floatingButton.Size = UDim2.new(0, 60, 0, 60)
    floatingButton.Position = UDim2.new(0, 20, 0.5, -30)
    floatingButton.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
    floatingButton.Image = ""
    floatingButton.Parent = gui
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(155, 89, 182)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(52, 152, 219))
    })
    gradient.Rotation = 45
    gradient.Parent = floatingButton
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.BackgroundTransparency = 1
    icon.Text = "✨"
    icon.TextColor3 = Color3.fromRGB(255, 255, 255)
    icon.TextSize = 20
    icon.Font = Enum.Font.GothamBold
    icon.Parent = floatingButton
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = floatingButton
    
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 15, 1, 15)
    shadow.Position = UDim2.new(0, -7, 0, -7)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(155, 89, 182)
    shadow.ImageTransparency = 0.7
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceScale = 0.02
    shadow.Parent = floatingButton

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.85, 0, 0.7, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    mainFrame.BackgroundTransparency = 0.1
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

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.05, 0)
    corner.Parent = mainFrame

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    header.BorderSizePixel = 0
    header.Parent = mainFrame

    local headerGradient = Instance.new("UIGradient")
    headerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(155, 89, 182)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(52, 152, 219))
    })
    headerGradient.Parent = header

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "gigasikDLC"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.Parent = header

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
    closeBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = header

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0.3, 0)
    closeCorner.Parent = closeBtn

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -10, 1, -50)
    content.Position = UDim2.new(0, 5, 0, 45)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 3
    content.ScrollBarImageColor3 = Color3.fromRGB(155, 89, 182)
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.Parent = mainFrame

    local tabs = {
        {name = "MAIN", color = Color3.fromRGB(52, 152, 219)},
        {name = "SETTINGS", color = Color3.fromRGB(155, 89, 182)}
    }

    local currentTab = "MAIN"
    local tabButtons = {}

    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 0, 35)
    tabContainer.Position = UDim2.new(0, 0, 0, 0)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = content

    for i, tab in pairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(0.5, -5, 1, 0)
        tabButton.Position = UDim2.new((i-1) * 0.5, 0, 0, 0)
        tabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        tabButton.BorderSizePixel = 0
        tabButton.Text = tab.name
        tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabButton.TextSize = 12
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
        {name = "Fly", setting = "Fly"},
        {name = "ESP", setting = "ESP"},
        {name = "Speed", setting = "Speed"},
        {name = "BHop", setting = "BunnyHop"},
        {name = "Hitbox", setting = "Hitbox"},
        {name = "3rd Person", setting = "ThirdPerson"},
        {name = "Crosshair", setting = "Crosshair"}
    }

    local settingOptions = {
        {name = "Fly Speed", setting = "Fly", value = "Speed", min = 10, max = 100},
        {name = "Walk Speed", setting = "Speed", value = "WalkSpeed", min = 16, max = 100},
        {name = "BHop Speed", setting = "BunnyHop", value = "Speed", min = 10, max = 100},
        {name = "Hitbox Size", setting = "Hitbox", value = "Size", min = 2, max = 10},
        {name = "3rd Person Dist", setting = "ThirdPerson", value = "Distance", min = 5, max = 20},
        {name = "Crosshair Size", setting = "Crosshair", value = "Size", min = 4, max = 20},
        {name = "Crosshair Pos", setting = "Crosshair", value = "Position", min = 0.4, max = 0.7, step = 0.01},
        {name = "Show Distance", setting = "ESP", value = "ShowDistance", type = "toggle"},
        {name = "Show Health", setting = "ESP", value = "ShowHealth", type = "toggle"},
        {name = "Rainbow Crosshair", setting = "Crosshair", value = "Rainbow", type = "toggle"}
    }

    local function updateContent()
        for _, child in pairs(content:GetChildren()) do
            if child:IsA("Frame") and child ~= tabContainer then
                child:Destroy()
            end
        end

        local yPosition = 40

        if currentTab == "MAIN" then
            for i, feature in pairs(mainFeatures) do
                local button = Instance.new("TextButton")
                button.Size = UDim2.new(1, 0, 0, 35)
                button.Position = UDim2.new(0, 0, 0, yPosition)
                button.BackgroundColor3 = Settings[feature.setting].Enabled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(45, 45, 65)
                button.BorderSizePixel = 0
                button.Text = feature.name
                button.TextColor3 = Color3.fromRGB(255, 255, 255)
                button.TextSize = 14
                button.Font = Enum.Font.Gotham
                button.Parent = content
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0.1, 0)
                buttonCorner.Parent = button

                button.MouseButton1Click:Connect(function()
                    Settings[feature.setting].Enabled = not Settings[feature.setting].Enabled
                    button.BackgroundColor3 = Settings[feature.setting].Enabled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(45, 45, 65)
                    
                    if feature.setting == "ESP" then
                        toggleESP()
                    elseif feature.setting == "Hitbox" then
                        updateHitboxes()
                    elseif feature.setting == "ThirdPerson" then
                        toggleThirdPerson()
                    elseif feature.setting == "Crosshair" then
                        updateCrosshair()
                    end
                end)

                yPosition = yPosition + 40
            end
            content.CanvasSize = UDim2.new(0, 0, 0, yPosition)

        elseif currentTab == "SETTINGS" then
            for i, setting in pairs(settingOptions) do
                local settingContainer = Instance.new("Frame")
                settingContainer.Size = UDim2.new(1, 0, 0, 50)
                settingContainer.Position = UDim2.new(0, 0, 0, yPosition)
                settingContainer.BackgroundTransparency = 1
                settingContainer.Parent = content

                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(1, 0, 0, 20)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = setting.name
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.TextSize = 12
                nameLabel.Font = Enum.Font.Gotham
                nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                nameLabel.Parent = settingContainer

                if setting.type == "toggle" then
                    local toggleButton = Instance.new("TextButton")
                    toggleButton.Size = UDim2.new(0, 60, 0, 25)
                    toggleButton.Position = UDim2.new(1, -65, 0, 0)
                    toggleButton.BackgroundColor3 = Settings[setting.setting][setting.value] and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
                    toggleButton.BorderSizePixel = 0
                    toggleButton.Text = Settings[setting.setting][setting.value] and "ON" or "OFF"
                    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    toggleButton.TextSize = 12
                    toggleButton.Font = Enum.Font.GothamBold
                    toggleButton.Parent = settingContainer

                    local toggleCorner = Instance.new("UICorner")
                    toggleCorner.CornerRadius = UDim.new(0.3, 0)
                    toggleCorner.Parent = toggleButton

                    toggleButton.MouseButton1Click:Connect(function()
                        Settings[setting.setting][setting.value] = not Settings[setting.setting][setting.value]
                        toggleButton.BackgroundColor3 = Settings[setting.setting][setting.value] and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
                        toggleButton.Text = Settings[setting.setting][setting.value] and "ON" or "OFF"
                        
                        if setting.setting == "Crosshair" and setting.value == "Rainbow" then
                            updateCrosshair()
                        elseif setting.setting == "ESP" then
                            toggleESP()
                        end
                    end)
                else
                    local valueLabel = Instance.new("TextLabel")
                    valueLabel.Size = UDim2.new(0, 60, 0, 20)
                    valueLabel.Position = UDim2.new(1, -60, 0, 0)
                    valueLabel.BackgroundTransparency = 1
                    valueLabel.Text = tostring(Settings[setting.setting][setting.value])
                    valueLabel.TextColor3 = Color3.fromRGB(52, 152, 219)
                    valueLabel.TextSize = 12
                    valueLabel.Font = Enum.Font.GothamBold
                    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                    valueLabel.Parent = settingContainer

                    local sliderContainer = Instance.new("Frame")
                    sliderContainer.Size = UDim2.new(1, 0, 0, 20)
                    sliderContainer.Position = UDim2.new(0, 0, 0, 25)
                    sliderContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                    sliderContainer.BorderSizePixel = 0
                    sliderContainer.Parent = settingContainer

                    local sliderCorner = Instance.new("UICorner")
                    sliderCorner.CornerRadius = UDim.new(0.1, 0)
                    sliderCorner.Parent = sliderContainer

                    local currentValue = Settings[setting.setting][setting.value]
                    local normalizedValue = (currentValue - setting.min) / (setting.max - setting.min)
                    
                    local sliderFill = Instance.new("Frame")
                    sliderFill.Size = UDim2.new(normalizedValue, 0, 1, 0)
                    sliderFill.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
                    sliderFill.BorderSizePixel = 0
                    sliderFill.Parent = sliderContainer

                    local fillCorner = Instance.new("UICorner")
                    fillCorner.CornerRadius = UDim.new(0.1, 0)
                    fillCorner.Parent = sliderFill

                    local function updateSlider(value)
                        local newValue
                        if setting.step then
                            newValue = math.floor((value - setting.min) / setting.step) * setting.step + setting.min
                        else
                            newValue = math.floor(value)
                        end
                        newValue = math.clamp(newValue, setting.min, setting.max)
                        
                        Settings[setting.setting][setting.value] = newValue
                        valueLabel.Text = tostring(newValue)
                        
                        local newNormalized = (newValue - setting.min) / (setting.max - setting.min)
                        sliderFill.Size = UDim2.new(newNormalized, 0, 1, 0)

                        if setting.setting == "Crosshair" then
                            updateCrosshair()
                        end
                    end

                    sliderContainer.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.Touch then
                            local connection
                            connection = RunService.Heartbeat:Connect(function()
                                local mousePos = UserInputService:GetMouseLocation()
                                local sliderPos = sliderContainer.AbsolutePosition
                                local sliderSize = sliderContainer.AbsoluteSize
                                local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
                                local newValue = setting.min + relativeX * (setting.max - setting.min)
                                updateSlider(newValue)
                            end)
                            
                            UserInputService.InputEnded:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.Touch then
                                    connection:Disconnect()
                                end
                            end)
                        end
                    end)
                end

                yPosition = yPosition + 55
            end
            content.CanvasSize = UDim2.new(0, 0, 0, yPosition)
        end
    end

    updateContent()

    local isOpen = false

    local function openMenu()
        if isOpen then return end
        isOpen = true
        mainFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0.85, 0, 0.7, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
    end

    local function closeMenu()
        if not isOpen then return end
        isOpen = false
        
        TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        
        wait(0.2)
        mainFrame.Visible = false
    end

    floatingButton.MouseButton1Click:Connect(function()
        if isOpen then
            closeMenu()
        else
            openMenu()
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        closeMenu()
    end)

    local dragging = false
    local dragInput, dragStart, startPos
    
    floatingButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = floatingButton.Position
            
            TweenService:Create(floatingButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 55, 0, 55)}):Play()
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    TweenService:Create(floatingButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 60, 0, 60)}):Play()
                end
            end)
        end
    end)
    
    floatingButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            floatingButton.Position = UDim2.new(
                0, startPos.X.Offset + delta.X,
                0, startPos.Y.Offset + delta.Y
            )
        end
    end)

    return {
        Open = openMenu,
        Close = closeMenu,
        IsOpen = function() return isOpen end
    }
end

local menu = createMobileMenu()

RunService.Heartbeat:Connect(function()
    pcall(function()
        bunnyHop()
        updateFly()
        updateSpeed()
        updateThirdPerson()
    end)
end)

Players.PlayerAdded:Connect(function(newPlayer)
    if Settings.ESP.Enabled then
        newPlayer.CharacterAdded:Connect(function()
            wait(1)
            createESP(newPlayer)
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

delay(2, function()
    if Settings.ESP.Enabled then
        toggleESP()
    end
    if Settings.Hitbox.Enabled then
        updateHitboxes()
    end
    updateCrosshair()
end)

print("gigasikDLC LOADED!")
