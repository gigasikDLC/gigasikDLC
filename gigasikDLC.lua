local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local isMobile = UserInputService.TouchEnabled

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
    content.CanvasSize = UDim2.new(0, 0, 0, 800)
    content.Parent = mainFrame

    local tabs = {
        {name = "🎮 MAIN", color = Color3.fromRGB(52, 152, 219)},
        {name = "⚙️ SETTINGS", color = Color3.fromRGB(155, 89, 182)},
        {name = "🔧 CONFIG", color = Color3.fromRGB(46, 204, 113)}
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
        {name = "🚀 Fly Hack", desc = "Free movement in air", enabled = false},
        {name = "🎯 Aimbot", desc = "Auto aim at enemies", enabled = false},
        {name = "👁️ ESP", desc = "See players through walls", enabled = false},
        {name = "💨 Speed", desc = "Move faster", enabled = false},
        {name = "🛡️ Anti-AFK", desc = "Prevent AFK detection", enabled = false},
        {name = "🐰 Bunny Hop", desc = "Auto jump while moving", enabled = false}
    }

    local settings = {
        {name = "Hitbox Size", type = "slider", value = 5, min = 1, max = 10},
        {name = "Fly Speed", type = "slider", value = 50, min = 10, max = 100},
        {name = "Speed Value", type = "slider", value = 30, min = 16, max = 100},
        {name = "ESP Distance", type = "slider", value = 500, min = 100, max = 1000}
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
                button.BackgroundColor3 = feature.enabled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(35, 35, 50)
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
                    feature.enabled = not feature.enabled
                    button.BackgroundColor3 = feature.enabled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(35, 35, 50)
                end)
            end
            content.CanvasSize = UDim2.new(0, 0, 0, #mainFeatures * 80)

        elseif currentTab == "⚙️ SETTINGS" then
            for i, setting in pairs(settings) do
                local settingContainer = Instance.new("Frame")
                settingContainer.Size = UDim2.new(1, 0, 0, 80)
                settingContainer.Position = UDim2.new(0, 0, 0, (i-1) * 90)
                settingContainer.BackgroundTransparency = 1
                settingContainer.Parent = content

                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(1, 0, 0, 30)
                nameLabel.Position = UDim2.new(0, 0, 0, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = setting.name
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.TextSize = 16
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                nameLabel.Parent = settingContainer

                local valueLabel = Instance.new("TextLabel")
                valueLabel.Size = UDim2.new(0, 100, 0, 30)
                valueLabel.Position = UDim2.new(1, -100, 0, 0)
                valueLabel.BackgroundTransparency = 1
                valueLabel.Text = tostring(setting.value)
                valueLabel.TextColor3 = Color3.fromRGB(52, 152, 219)
                valueLabel.TextSize = 16
                valueLabel.Font = Enum.Font.GothamBold
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                valueLabel.Parent = settingContainer

                local sliderContainer = Instance.new("Frame")
                sliderContainer.Size = UDim2.new(1, 0, 0, 30)
                sliderContainer.Position = UDim2.new(0, 0, 0, 40)
                sliderContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                sliderContainer.BorderSizePixel = 0
                sliderContainer.Parent = settingContainer

                local sliderCorner = Instance.new("UICorner")
                sliderCorner.CornerRadius = UDim.new(0.1, 0)
                sliderCorner.Parent = sliderContainer

                local sliderFill = Instance.new("Frame")
                sliderFill.Size = UDim2.new((setting.value - setting.min) / (setting.max - setting.min), 0, 1, 0)
                sliderFill.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
                sliderFill.BorderSizePixel = 0
                sliderFill.Parent = sliderContainer

                local fillCorner = Instance.new("UICorner")
                fillCorner.CornerRadius = UDim.new(0.1, 0)
                fillCorner.Parent = sliderFill

                local function updateSlider(value)
                    local newValue = math.clamp(value, setting.min, setting.max)
                    setting.value = newValue
                    valueLabel.Text = tostring(newValue)
                    sliderFill.Size = UDim2.new((newValue - setting.min) / (setting.max - setting.min), 0, 1, 0)
                end

                sliderContainer.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local connection
                        connection = RunService.Heartbeat:Connect(function()
                            local mousePos = UserInputService:GetMouseLocation()
                            local sliderPos = sliderContainer.AbsolutePosition
                            local sliderSize = sliderContainer.AbsoluteSize
                            local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
                            local newValue = math.floor(setting.min + relativeX * (setting.max - setting.min))
                            updateSlider(newValue)
                        end)
                        
                        UserInputService.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                connection:Disconnect()
                            end
                        end)
                    end
                end)
            end
            content.CanvasSize = UDim2.new(0, 0, 0, #settings * 90)
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

local menu = createPremiumMenu()

if isMobile then
    local mobileButton = CoreGui.PremiumMenu:FindFirstChildWhichIsA("ImageButton")
    if mobileButton then
        local dragging = false
        local dragInput, dragStart, startPos
        
        mobileButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = mobileButton.Position
                
                TweenService:Create(mobileButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 60, 0, 60)}):Play()
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        TweenService:Create(mobileButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 70, 0, 70)}):Play()
                    end
                end)
            end
        end)
        
        mobileButton.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input == dragInput then
                local delta = input.Position - dragStart
                mobileButton.Position = UDim2.new(
                    startPos.X.Scale, 
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale, 
                    startPos.Y.Offset + delta.Y
                )
            end
        end)
    end
end

print("✨ Fuesos Optimizing Version Loaded!")
print(isMobile and "DIEGO SOLO")
