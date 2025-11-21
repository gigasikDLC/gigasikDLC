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

    local currentTab = "COMBAT"
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

        if i == 1 then
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

    -- Заполняем вкладки
    local features = {
        COMBAT = {"Aim Assist", "Trigger Bot", "No Recoil", "Rapid Fire", "Hitboxes"},
        VISUALS = {"Player ESP", "Item ESP", "Chams", "Tracers", "Radar"},
        FUN = {"Fly Hack", "Speed Hack", "Bunny Hop", "Noclip", "Super Jump"}
    }

    for tabName, tabFeatures in pairs(features) do
        local tabContent = tabFrames[tabName].content
        local yPosition = 0
        
        for i, feature in pairs(tabFeatures) do
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 0, 35)
            button.Position = UDim2.new(0, 0, 0, yPosition)
            button.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            button.BorderSizePixel = 0
            button.Text = feature
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 14
            button.Font = Enum.Font.Gotham
            button.Parent = tabContent
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0.1, 0)
            buttonCorner.Parent = button

            yPosition = yPosition + 40
        end
        tabContent.CanvasSize = UDim2.new(0, 0, 0, yPosition)
    end

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

local menu = createGigasikDLC()
print("gigasikDLC LOADED!")
