-- Premium Mobile Menu - Compact Version
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
    Menu = {Visible = false},
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
local function updateCrosshair()
    crosshairFrame.Visible = Settings.Crosshair.Enabled
    
    if Settings.Crosshair.Rainbow then
        if not rainbowConnection then
            rainbowConnection = RunService.Heartbeat:Connect(function()
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
        crosshairFrame.BackgroundColor3 = Settings.Crosshair.Color
    end
    
    if Settings.Crosshair.Type == "Dot" then
        crosshairCorner.CornerRadius = UDim.new(1, 0)
        crosshairFrame.Size = UDim2.new(0, Settings.Crosshair.Size, 0, Settings.Crosshair.Size)
    elseif Settings.Crosshair.Type == "Circle" then
        crosshairCorner.CornerRadius = UDim.new(1, 0)
        crosshairFrame.Size = UDim2.new(0, Settings.Crosshair.Size, 0, Settings.Crosshair.Size)
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

-- Mobile Menu Creation
local function createMobileMenu()
    if CoreGui:FindFirstChild("MobileMenu") then
        CoreGui:FindFirstChild("MobileMenu"):Destroy()
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "MobileMenu"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    -- Floating button
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

    -- Compact menu
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

    -- Header
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
    title.Text = "📱 MOBILE MENU"
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

    -- Content
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -10, 1, -50)
    content.Position = UDim2.new(0, 5, 0, 45)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 3
    content.ScrollBarImageColor3 = Color3.fromRGB(155, 89, 182)
    content.CanvasSize = UDim2.new(0, 0, 0, 600)
    content.Parent = mainFrame

    -- Features for mobile
    local features = {
        {name = "🚀 Fly", setting = "Fly"},
        {name = "👁️ ESP", setting = "ESP"},
        {name = "💨 Speed", setting = "Speed"},
        {name = "🐰 BHop", setting = "BunnyHop"},
        {name = "🎯 Hitbox", setting = "Hitbox"},
        {name = "📷 3rd Person", setting = "ThirdPerson"},
        {name = "🎯 Crosshair", setting = "Crosshair"}
    }

    for i, feature in pairs(features) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 35)
        button.Position = UDim2.new(0, 0, 0, (i-1) * 40)
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
    end

    content.CanvasSize = UDim2.new(0, 0, 0, #features * 40)

    -- Menu open/close
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

    -- Floating button click
    floatingButton.MouseButton1Click:Connect(function()
        if isOpen then
            closeMenu()
        else
            openMenu()
        end
    end)

    -- Close button
    closeBtn.MouseButton1Click:Connect(function()
        closeMenu()
    end)

    -- Make floating button draggable
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

-- Initialize mobile menu
local menu = createMobileMenu()

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

print("FUESOS Menu Loaded!")
print("DIEGO SOLO")
