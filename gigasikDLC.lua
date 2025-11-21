local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

local function createGigasikDLC()
    if CoreGui:FindFirstChild("gigasikDLC") then
        CoreGui:FindFirstChild("gigasikDLC"):Destroy()
    end

    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "gigasikDLC"
    mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    mainGui.ResetOnSpawn = false
    mainGui.Parent = CoreGui

    local openButton = Instance.new("TextButton")
    openButton.Size = UDim2.new(0, 60, 0, 60)
    openButton.Position = UDim2.new(0, 20, 0.5, -30)
    openButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    openButton.Text = "☰"
    openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    openButton.TextSize = 20
    openButton.Font = Enum.Font.GothamBold
    openButton.Parent = mainGui
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1, 0)
    buttonCorner.Parent = openButton

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

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    header.BorderSizePixel = 0
    header.Parent = mainFrame

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0.05, 0)
    headerCorner.Parent = header

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

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0.3, 0)
    closeCorner.Parent = closeButton

    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 0, 35)
    tabContainer.Position = UDim2.new(0, 0, 0, 40)
    tabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainFrame

    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, -10, 1, -85)
    contentFrame.Position = UDim2.new(0, 5, 0, 80)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 4
    contentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 150)
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentFrame.Parent = mainFrame

    local tabs = {
        {name = "COMBAT", color = Color3.fromRGB(220, 80, 80)},
        {name = "VISUALS", color = Color3.fromRGB(80, 150, 220)},
        {name = "FUN", color = Color3.fromRGB(80, 220, 120)}
    }

    local currentTab = "COMBAT"
    local tabButtons = {}

    for i, tab in pairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1/3, 0, 1, 0)
        tabButton.Position = UDim2.new((i-1) * (1/3), 0, 0, 0)
        tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        tabButton.BorderSizePixel = 0
        tabButton.Text = tab.name
        tabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
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
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                btn.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
            tabButton.BackgroundColor3 = tab.color
            tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            updateContent()
        end)

        tabButtons[tab.name] = tabButton
    end

    local combatFeatures = {
        "Aim Assist",
        "Trigger Bot", 
        "No Recoil",
        "Rapid Fire",
        "Hitboxes"
    }

    local visualsFeatures = {
        "Player ESP",
        "Item ESP",
        "Chams",
        "Tracers",
        "Radar"
    }

    local funFeatures = {
        "Fly Hack",
        "Speed Hack",
        "Bunny Hop",
        "Noclip",
        "Super Jump"
    }

    local function updateContent()
        for _, child in pairs(contentFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        local yPosition = 0
        local features = {}

        if currentTab == "COMBAT" then
            features = combatFeatures
        elseif currentTab == "VISUALS" then
            features = visualsFeatures
        elseif currentTab == "FUN" then
            features = funFeatures
        end

        for i, feature in pairs(features) do
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 0, 35)
            button.Position = UDim2.new(0, 0, 0, yPosition)
            button.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            button.BorderSizePixel = 0
            button.Text = feature
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 14
            button.Font = Enum.Font.Gotham
            button.Parent = contentFrame
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0.1, 0)
            buttonCorner.Parent = button

            button.MouseButton1Click:Connect(function()
                print(feature .. " clicked!")
            end)

            yPosition = yPosition + 40
        end
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, yPosition)
    end

    updateContent()

    local menuOpen = false

    openButton.MouseButton1Click:Connect(function()
        menuOpen = not menuOpen
        mainFrame.Visible = menuOpen
    end)

    closeButton.MouseButton1Click:Connect(function()
        menuOpen = false
        mainFrame.Visible = false
    end)

    return mainGui
end

local menu = createGigasikDLC()
print("gigasikDLC LOADED!")
