-- AGALIK HUB v5.0 | WITH TUTORIAL
-- С инструкцией при первом запуске

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Проверяем, показывали ли уже инструкцию
local tutorialShown = false
local userLanguage = "english" -- язык по умолчанию

-- Тема
local theme = {
    main = Color3.fromRGB(25, 25, 35),
    secondary = Color3.fromRGB(35, 35, 45),
    accent = Color3.fromRGB(0, 150, 255),
    text = Color3.fromRGB(240, 240, 240),
    subtext = Color3.fromRGB(180, 180, 200),
    success = Color3.fromRGB(0, 200, 83),
    danger = Color3.fromRGB(255, 80, 90)
}

-- Создание GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AgalikHub"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

if gethui then
    screenGui.Parent = gethui()
else
    screenGui.Parent = player:WaitForChild("PlayerGui")
end

-- ============================================
-- ИНСТРУКЦИЯ ПРИ ЗАПУСКЕ
-- ============================================

local tutorialFrame = Instance.new("Frame")
tutorialFrame.Name = "Tutorial"
tutorialFrame.Size = UDim2.new(0, 500, 0, 450)
tutorialFrame.Position = UDim2.new(0.5, -250, 0.5, -225)
tutorialFrame.BackgroundColor3 = theme.main
tutorialFrame.BorderSizePixel = 1
tutorialFrame.BorderColor3 = Color3.fromRGB(50, 50, 70)
tutorialFrame.ClipsDescendants = true
tutorialFrame.Visible = true
tutorialFrame.Parent = screenGui

-- Заголовок инструкции
local tutorialTitle = Instance.new("TextLabel")
tutorialTitle.Name = "Title"
tutorialTitle.Size = UDim2.new(1, 0, 0, 60)
tutorialTitle.Position = UDim2.new(0, 0, 0, 0)
tutorialTitle.BackgroundColor3 = theme.secondary
tutorialTitle.BorderSizePixel = 0
tutorialTitle.Font = Enum.Font.GothamBold
tutorialTitle.Text = "AGALIK HUB - WELCOME"
tutorialTitle.TextColor3 = theme.accent
tutorialTitle.TextSize = 20
tutorialTitle.Parent = tutorialFrame

-- Вопрос о языке
local languageQuestion = Instance.new("TextLabel")
languageQuestion.Name = "LanguageQuestion"
languageQuestion.Size = UDim2.new(1, -40, 0, 50)
languageQuestion.Position = UDim2.new(0, 20, 0, 80)
languageQuestion.BackgroundTransparency = 1
languageQuestion.Font = Enum.Font.Gotham
languageQuestion.Text = "Please select your language / Пожалуйста, выберите язык:"
languageQuestion.TextColor3 = theme.text
languageQuestion.TextSize = 16
languageQuestion.TextWrapped = true
languageQuestion.Parent = tutorialFrame

-- Кнопка English
local englishBtn = Instance.new("TextButton")
englishBtn.Name = "EnglishBtn"
englishBtn.Size = UDim2.new(0, 200, 0, 40)
englishBtn.Position = UDim2.new(0.5, -220, 0, 150)
englishBtn.BackgroundColor3 = theme.accent
englishBtn.BorderSizePixel = 0
englishBtn.AutoButtonColor = false
englishBtn.Font = Enum.Font.GothamBold
englishBtn.Text = "🇺🇸 ENGLISH"
englishBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
englishBtn.TextSize = 16
englishBtn.Parent = tutorialFrame

-- Кнопка Russian
local russianBtn = Instance.new("TextButton")
russianBtn.Name = "RussianBtn"
russianBtn.Size = UDim2.new(0, 200, 0, 40)
russianBtn.Position = UDim2.new(0.5, 20, 0, 150)
russianBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
russianBtn.BorderSizePixel = 0
russianBtn.AutoButtonColor = false
russianBtn.Font = Enum.Font.GothamBold
russianBtn.Text = "🇷🇺 RUSSIAN"
russianBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
russianBtn.TextSize = 16
russianBtn.Parent = tutorialFrame

-- Область с инструкцией
local tutorialContent = Instance.new("ScrollingFrame")
tutorialContent.Name = "Content"
tutorialContent.Size = UDim2.new(1, -40, 0, 200)
tutorialContent.Position = UDim2.new(0, 20, 0, 210)
tutorialContent.BackgroundColor3 = theme.secondary
tutorialContent.BorderSizePixel = 0
tutorialContent.ScrollBarThickness = 6
tutorialContent.ScrollBarImageColor3 = theme.accent
tutorialContent.CanvasSize = UDim2.new(0, 0, 0, 0)
tutorialContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
tutorialContent.Visible = false
tutorialContent.Parent = tutorialFrame

local tutorialLayout = Instance.new("UIListLayout")
tutorialLayout.Padding = UDim.new(0, 10)
tutorialLayout.SortOrder = Enum.SortOrder.LayoutOrder
tutorialLayout.Parent = tutorialContent

local tutorialPadding = Instance.new("UIPadding")
tutorialPadding.PaddingTop = UDim.new(0, 15)
tutorialPadding.PaddingLeft = UDim.new(0, 15)
tutorialPadding.PaddingRight = UDim.new(0, 15)
tutorialPadding.Parent = tutorialContent

-- Кнопка принятия (справа снизу)
local acceptBtn = Instance.new("TextButton")
acceptBtn.Name = "AcceptBtn"
acceptBtn.Size = UDim2.new(0, 120, 0, 40)
acceptBtn.Position = UDim2.new(1, -140, 1, -60)
acceptBtn.BackgroundColor3 = theme.success
acceptBtn.BorderSizePixel = 0
acceptBtn.AutoButtonColor = false
acceptBtn.Font = Enum.Font.GothamBold
acceptBtn.Text = "ACCEPT"
acceptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
acceptBtn.TextSize = 16
acceptBtn.Visible = false
acceptBtn.Parent = tutorialFrame

-- Функция создания пункта инструкции
local function createTutorialItem(text, icon)
    local itemFrame = Instance.new("Frame")
    itemFrame.Name = "Item"
    itemFrame.Size = UDim2.new(1, 0, 0, 40)
    itemFrame.BackgroundTransparency = 1
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Name = "Icon"
    iconLabel.Size = UDim2.new(0, 30, 0, 30)
    iconLabel.Position = UDim2.new(0, 0, 0, 5)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Font = Enum.Font.Gotham
    iconLabel.Text = icon
    iconLabel.TextColor3 = theme.accent
    iconLabel.TextSize = 20
    iconLabel.Parent = itemFrame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Text"
    textLabel.Size = UDim2.new(1, -40, 0, 30)
    textLabel.Position = UDim2.new(0, 40, 0, 5)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.Gotham
    textLabel.Text = text
    textLabel.TextColor3 = theme.text
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextWrapped = true
    textLabel.Parent = itemFrame
    
    return itemFrame
end

-- Тексты инструкций на разных языках
local englishTutorial = {
    "🎮 Welcome to AGALIK HUB v5.0!",
    "✅ This is a premium script for Prison Life",
    "",
    "🔑 CONTROLS:",
    "• RightControl - Open/Close menu",
    "• Drag title bar - Move window",
    "",
    "🚀 MAIN FEATURES:",
    "• NOCHIP - Walk through walls",
    "• SPEED HACK - Run 3x faster",
    "• INVISIBLE - Become invisible",
    "• ESP - See all players (health & distance)",
    "• X-RAY - See through walls",
    "• FULLBRIGHT - Remove darkness",
    "",
    "📍 TELEPORT LOCATIONS:",
    "• Guard Room - Police spawn",
    "• Prison Yard - Main area",
    "• Criminal Base - Criminals spawn",
    "",
    "🎮 FUN FEATURES:",
    "• Spawn Cubes - Create platforms",
    "• Grenade Rain - Fun explosions",
    "",
    "⚠️ WARNING:",
    "Use at your own risk!",
    "For educational purposes only."
}

local russianTutorial = {
    "🎮 Добро пожаловать в AGALIK HUB v5.0!",
    "✅ Это премиум скрипт для Prison Life",
    "",
    "🔑 УПРАВЛЕНИЕ:",
    "• RightControl - Открыть/Закрыть меню",
    "• Тащить за заголовок - Перемещать окно",
    "",
    "🚀 ОСНОВНЫЕ ФУНКЦИИ:",
    "• NOCHIP - Ходить сквозь стены",
    "• SPEED HACK - Бегать в 3 раза быстрее",
    "• INVISIBLE - Стать невидимым",
    "• ESP - Видеть всех игроков (здоровье и дистанция)",
    "• X-RAY - Видеть сквозь стены",
    "• FULLBRIGHT - Убрать темноту",
    "",
    "📍 ТЕЛЕПОРТЫ:",
    "• Guard Room - Спавн полиции",
    "• Prison Yard - Главная зона",
    "• Criminal Base - Спавн криминалов",
    "",
    "🎮 РАЗВЛЕЧЕНИЯ:",
    "• Spawn Cubes - Создавать платформы",
    "• Grenade Rain - Веселые взрывы",
    "",
    "⚠️ ПРЕДУПРЕЖДЕНИЕ:",
    "Используйте на свой страх и риск!",
    "Только в образовательных целях."
}

-- Функция показа инструкции
local function showTutorial(language)
    userLanguage = language
    
    -- Очищаем предыдущий контент
    for _, child in pairs(tutorialContent:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Выбираем текст
    local tutorialText = language == "english" and englishTutorial or russianTutorial
    
    -- Заполняем инструкцию
    for i, text in ipairs(tutorialText) do
        if text == "" then
            -- Пропуск для пустых строк
            local spacer = Instance.new("Frame")
            spacer.Size = UDim2.new(1, 0, 0, 10)
            spacer.BackgroundTransparency = 1
            spacer.LayoutOrder = i
            spacer.Parent = tutorialContent
        else
            local icon = ""
            if text:find("Welcome") or text:find("Добро") then icon = "🎮"
            elseif text:find("CONTROLS") or text:find("УПРАВЛЕНИЕ") then icon = "🔑"
            elseif text:find("FEATURES") or text:find("ФУНКЦИИ") then icon = "🚀"
            elseif text:find("TELEPORT") or text:find("ТЕЛЕПОРТЫ") then icon = "📍"
            elseif text:find("FUN") or text:find("РАЗВЛЕЧЕНИЯ") then icon = "🎮"
            elseif text:find("WARNING") or text:find("ПРЕДУПРЕЖДЕНИЕ") then icon = "⚠️"
            elseif text:find("•") then icon = "✓"
            else icon = "📌" end
            
            local item = createTutorialItem(text, icon)
            item.LayoutOrder = i
            item.Parent = tutorialContent
        end
    end
    
    -- Показываем контент и кнопку принятия
    tutorialContent.Visible = true
    acceptBtn.Visible = true
    
    -- Меняем текст кнопки в зависимости от языка
    if language == "russian" then
        acceptBtn.Text = "ПРИНЯТЬ"
    else
        acceptBtn.Text = "ACCEPT"
    end
    
    -- Анимация появления
    tutorialContent.Position = UDim2.new(0, 20, 0.5, 0)
    tutorialContent.Size = UDim2.new(1, -40, 0, 0)
    
    TweenService:Create(tutorialContent, TweenInfo.new(0.4), {
        Position = UDim2.new(0, 20, 0, 210),
        Size = UDim2.new(1, -40, 0, 200)
    }):Play()
end

-- Обработчики кнопок языка
englishBtn.MouseButton1Click:Connect(function()
    showTutorial("english")
    tutorialTitle.Text = "AGALIK HUB - WELCOME"
    languageQuestion.Text = "Please select your language:"
end)

russianBtn.MouseButton1Click:Connect(function()
    showTutorial("russian")
    tutorialTitle.Text = "AGALIK HUB - ДОБРО ПОЖАЛОВАТЬ"
    languageQuestion.Text = "Пожалуйста, выберите язык:"
end)

-- ============================================
-- ОСНОВНОЕ МЕНЮ (ЧИТ)
-- ============================================

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 450, 0, 400)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
mainFrame.BackgroundColor3 = theme.main
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.fromRGB(50, 50, 70)
mainFrame.ClipsDescendants = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Панель заголовка
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
title.Text = "AGALIK HUB v5.0"
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
closeBtn.AutoButtonColor = false
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

-- Вкладки
local tabs = {
    {Name = "Player", Icon = "👤", Color = theme.accent},
    {Name = "Visual", Icon = "👁️", Color = Color3.fromRGB(0, 200, 255)},
    {Name = "Teleport", Icon = "📍", Color = Color3.fromRGB(255, 184, 0)},
    {Name = "Fun", Icon = "🎮", Color = Color3.fromRGB(235, 77, 75)},
    {Name = "Credits", Icon = "⭐", Color = Color3.fromRGB(255, 215, 0)}
}

local tabFrames = {}
local tabButtons = {}
local activeTab = 1

for i, tab in ipairs(tabs) do
    -- Кнопка вкладки
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tab.Name .. "Tab"
    tabButton.Size = UDim2.new(1, 0, 0, 45)
    tabButton.Position = UDim2.new(0, 0, 0, (i-1) * 50)
    tabButton.BackgroundColor3 = i == 1 and Color3.fromRGB(45, 45, 60) or theme.secondary
    tabButton.BorderSizePixel = 0
    tabButton.AutoButtonColor = false
    tabButton.Font = Enum.Font.Gotham
    tabButton.Text = ""
    tabButton.Parent = sidebar
    
    local icon = Instance.new("TextLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 25, 0, 25)
    icon.Position = UDim2.new(0, 10, 0, 10)
    icon.BackgroundTransparency = 1
    icon.Font = Enum.Font.Gotham
    icon.Text = tab.Icon
    icon.TextColor3 = i == 1 and tab.Color or theme.subtext
    icon.TextSize = 16
    icon.Parent = tabButton
    
    local text = Instance.new("TextLabel")
    text.Name = "Text"
    text.Size = UDim2.new(1, -10, 0, 20)
    text.Position = UDim2.new(0, 5, 0, 28)
    text.BackgroundTransparency = 1
    text.Font = Enum.Font.Gotham
    text.Text = tab.Name
    text.TextColor3 = i == 1 and theme.text or theme.subtext
    text.TextSize = 12
    text.TextXAlignment = Enum.TextXAlignment.Center
    text.Parent = tabButton
    
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
    layout.Padding = UDim.new(0, 8)
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
            
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = isActive and Color3.fromRGB(45, 45, 60) or theme.secondary
            }):Play()
            
            TweenService:Create(btn:FindFirstChild("Icon"), TweenInfo.new(0.2), {
                TextColor3 = isActive and tabs[idx].Color or theme.subtext
            }):Play()
            
            TweenService:Create(btn:FindFirstChild("Text"), TweenInfo.new(0.2), {
                TextColor3 = isActive and theme.text or theme.subtext
            }):Play()
            
            tabFrames[idx].Visible = isActive
        end
    end)
end

-- Кнопка открытия меню
local openButton = Instance.new("TextButton")
openButton.Name = "OpenButton"
openButton.Size = UDim2.new(0, 50, 0, 50)
openButton.Position = UDim2.new(1, -60, 0, 20)
openButton.BackgroundColor3 = theme.accent
openButton.BorderSizePixel = 0
openButton.AutoButtonColor = false
openButton.Font = Enum.Font.GothamBold
openButton.Text = "A"
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.TextSize = 18
openButton.Visible = false
openButton.Parent = screenGui

-- Функция для уведомлений
local function showNotification(text, color, icon)
    spawn(function()
        local notification = Instance.new("Frame")
        notification.Size = UDim2.new(0, 300, 0, 50)
        notification.Position = UDim2.new(0.5, -150, 0.1, 0)
        notification.AnchorPoint = Vector2.new(0.5, 0)
        notification.BackgroundColor3 = theme.secondary
        notification.BorderSizePixel = 0
        notification.ZIndex = 1000
        notification.Parent = screenGui
        
        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 8)
        notifCorner.Parent = notification
        
        local border = Instance.new("Frame")
        border.Size = UDim2.new(1, 0, 0, 3)
        border.Position = UDim2.new(0, 0, 1, -3)
        border.BackgroundColor3 = color
        border.BorderSizePixel = 0
        border.Parent = notification
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, -20, 1, 0)
        textLabel.Position = UDim2.new(0, 10, 0, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Font = Enum.Font.GothamBold
        textLabel.Text = icon .. " " .. text .. " " .. icon
        textLabel.TextColor3 = color
        textLabel.TextSize = 16
        textLabel.TextXAlignment = Enum.TextXAlignment.Center
        textLabel.Parent = notification
        
        -- Анимация
        notification.Position = UDim2.new(0.5, -150, -0.1, 0)
        notification.BackgroundTransparency = 1
        textLabel.TextTransparency = 1
        
        TweenService:Create(notification, TweenInfo.new(0.3), {
            Position = UDim2.new(0.5, -150, 0.1, 0),
            BackgroundTransparency = 0
        }):Play()
        
        TweenService:Create(textLabel, TweenInfo.new(0.3), {
            TextTransparency = 0
        }):Play()
        
        task.wait(1.5)
        
        TweenService:Create(notification, TweenInfo.new(0.3), {
            Position = UDim2.new(0.5, -150, -0.1, 0),
            BackgroundTransparency = 1
        }):Play()
        
        TweenService:Create(textLabel, TweenInfo.new(0.3), {
            TextTransparency = 1
        }):Play()
        
        task.wait(0.3)
        notification:Destroy()
    end)
end

-- Функция создания кнопки
local function createButton(parent, text, description, icon, color, isToggle)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = text .. "Button"
    buttonFrame.Size = UDim2.new(1, 0, 0, 60)
    buttonFrame.BackgroundColor3 = theme.secondary
    buttonFrame.BorderSizePixel = 0
    buttonFrame.LayoutOrder = #parent:GetChildren()
    buttonFrame.Parent = parent
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Name = "Icon"
    iconLabel.Size = UDim2.new(0, 35, 0, 35)
    iconLabel.Position = UDim2.new(0, 10, 0.5, -17.5)
    iconLabel.AnchorPoint = Vector2.new(0, 0.5)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Font = Enum.Font.Gotham
    iconLabel.Text = icon
    iconLabel.TextColor3 = color
    iconLabel.TextSize = 20
    iconLabel.Parent = buttonFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(0.6, -50, 0, 25)
    titleLabel.Position = UDim2.new(0, 55, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = text .. (isToggle and " [OFF]" or "")
    titleLabel.TextColor3 = theme.text
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = buttonFrame
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Name = "Description"
    descLabel.Size = UDim2.new(0.6, -50, 0, 20)
    descLabel.Position = UDim2.new(0, 55, 0, 35)
    descLabel.BackgroundTransparency = 1
    descLabel.Font = Enum.Font.Gotham
    descLabel.Text = description
    descLabel.TextColor3 = theme.subtext
    descLabel.TextSize = 11
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = buttonFrame
    
    local actionButton = Instance.new("TextButton")
    actionButton.Name = "Action"
    actionButton.Size = UDim2.new(0, 70, 0, 25)
    actionButton.Position = UDim2.new(1, -80, 0.5, -12.5)
    actionButton.AnchorPoint = Vector2.new(1, 0.5)
    actionButton.BackgroundColor3 = isToggle and Color3.fromRGB(60, 60, 80) or color
    actionButton.BorderSizePixel = 0
    actionButton.AutoButtonColor = false
    actionButton.Font = Enum.Font.Gotham
    actionButton.Text = isToggle and "OFF" or "USE"
    actionButton.TextColor3 = isToggle and theme.subtext or Color3.fromRGB(255, 255, 255)
    actionButton.TextSize = 12
    actionButton.Parent = buttonFrame
    
    -- Эффект при наведении
    actionButton.MouseEnter:Connect(function()
        TweenService:Create(actionButton, TweenInfo.new(0.2), {
            BackgroundColor3 = isToggle and Color3.fromRGB(70, 70, 90) or Color3.fromRGB(
                math.min(color.R * 255 + 20, 255)/255,
                math.min(color.G * 255 + 20, 255)/255,
                math.min(color.B * 255 + 20, 255)/255
            )
        }):Play()
    end)
    
    actionButton.MouseLeave:Connect(function()
        TweenService:Create(actionButton, TweenInfo.new(0.2), {
            BackgroundColor3 = isToggle and Color3.fromRGB(60, 60, 80) or color
        }):Play()
    end)
    
    return actionButton, buttonFrame
end

-- ================= PLAYER TAB =================
local playerTab = tabFrames[1]

-- NOCHIP
local nochipBtn, nochipFrame = createButton(
    playerTab,
    "NOCHIP",
    "Walk through walls",
    "🚶",
    theme.accent,
    true
)

local nochipEnabled = false
local nochipConnection

nochipBtn.MouseButton1Click:Connect(function()
    nochipEnabled = not nochipEnabled
    
    nochipBtn.Text = nochipEnabled and "ON" or "OFF"
    nochipBtn.BackgroundColor3 = nochipEnabled and theme.success or Color3.fromRGB(60, 60, 80)
    nochipBtn.TextColor3 = nochipEnabled and Color3.fromRGB(255, 255, 255) or theme.subtext
    nochipFrame:FindFirstChild("Title").Text = "NOCHIP" .. (nochipEnabled and " [ON]" or " [OFF]")
    
    if nochipEnabled then
        if nochipConnection then nochipConnection:Disconnect() end
        nochipConnection = RunService.Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        showNotification("NOCHIP ENABLED", theme.success, "✅")
    else
        if nochipConnection then
            nochipConnection:Disconnect()
            nochipConnection = nil
        end
        showNotification("NOCHIP DISABLED", theme.danger, "❌")
    end
end)

-- SPEED HACK
local speedBtn, speedFrame = createButton(
    playerTab,
    "SPEED HACK",
    "Run faster",
    "⚡",
    Color3.fromRGB(0, 200, 255),
    true
)

speedBtn.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        local newSpeed = humanoid.WalkSpeed == 16 and 50 or 16
        
        humanoid.WalkSpeed = newSpeed
        speedBtn.Text = newSpeed == 50 and "ON" or "OFF"
        speedBtn.BackgroundColor3 = newSpeed == 50 and theme.success or Color3.fromRGB(60, 60, 80)
        speedBtn.TextColor3 = newSpeed == 50 and Color3.fromRGB(255, 255, 255) or theme.subtext
        speedFrame:FindFirstChild("Title").Text = "SPEED HACK" .. (newSpeed == 50 and " [ON]" or " [OFF]")
        
        local notifText = userLanguage == "russian" and 
                         (newSpeed == 50 and "СКОРОСТЬ: 50" or "СКОРОСТЬ: 16") or
                         (newSpeed == 50 and "SPEED: 50" or "SPEED: 16")
        
        showNotification(notifText, 
                        newSpeed == 50 and theme.success or theme.danger, 
                        newSpeed == 50 and "⚡" or "🐢")
    end
end)

-- INVISIBLE
local invisibleBtn, invisibleFrame = createButton(
    playerTab,
    "INVISIBLE",
    "Become invisible",
    "👻",
    Color3.fromRGB(200, 100, 255),
    true
)

invisibleBtn.MouseButton1Click:Connect(function()
    if player.Character then
        local character = player.Character
        local isNowInvisible = false
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                if part.Transparency == 0 then
                    part.Transparency = 1
                    isNowInvisible = true
                else
                    part.Transparency = 0
                    isNowInvisible = false
                end
            elseif part:IsA("Accessory") and part.Handle then
                if part.Handle.Transparency == 0 then
                    part.Handle.Transparency = 1
                    isNowInvisible = true
                else
                    part.Handle.Transparency = 0
                    isNowInvisible = false
                end
            end
        end
        
        invisibleBtn.Text = isNowInvisible and "ON" or "OFF"
        invisibleBtn.BackgroundColor3 = isNowInvisible and theme.success or Color3.fromRGB(60, 60, 80)
        invisibleBtn.TextColor3 = isNowInvisible and Color3.fromRGB(255, 255, 255) or theme.subtext
        invisibleFrame:FindFirstChild("Title").Text = "INVISIBLE" .. (isNowInvisible and " [ON]" or " [OFF]")
        
        local notifText = userLanguage == "russian" and 
                         (isNowInvisible and "НЕВИДИМЫЙ ВКЛ" or "НЕВИДИМЫЙ ВЫКЛ") or
                         (isNowInvisible and "INVISIBLE ON" or "INVISIBLE OFF")
        
        showNotification(notifText, 
                        isNowInvisible and theme.success or theme.danger, 
                        isNowInvisible and "👻" or "👤")
    end
end)

-- ================= VISUAL TAB =================
local visualTab = tabFrames[2]

-- ESP
local espBtn, espFrame = createButton(
    visualTab,
    "PLAYER ESP",
    "See all players",
    "👁️",
    Color3.fromRGB(255, 100, 200),
    true
)

local espDrawings = {}
local espEnabled = false

espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    
    espBtn.Text = espEnabled and "ON" or "OFF"
    espBtn.BackgroundColor3 = espEnabled and theme.success or Color3.fromRGB(60, 60, 80)
    espBtn.TextColor3 = espEnabled and Color3.fromRGB(255, 255, 255) or theme.subtext
    espFrame:FindFirstChild("Title").Text = "PLAYER ESP" .. (espEnabled and " [ON]" or " [OFF]")
    
    if espEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player then
                espDrawings[p] = {
                    box = Drawing.new("Square"),
                    name = Drawing.new("Text"),
                    distance = Drawing.new("Text")
                }
                
                local drawings = espDrawings[p]
                drawings.box.Visible = true
                drawings.box.Color = Color3.new(1, 0, 0)
                drawings.box.Thickness = 2
                drawings.box.Filled = false
                
                drawings.name.Visible = true
                drawings.name.Color = Color3.new(1, 1, 1)
                drawings.name.Size = 14
                drawings.name.Text = p.Name
                
                drawings.distance.Visible = true
                drawings.distance.Color = Color3.new(0, 1, 0)
                drawings.distance.Size = 12
            end
        end
        
        RunService.RenderStepped:Connect(function()
            for p, drawings in pairs(espDrawings) do
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                    if onScreen then
                        drawings.box.Visible = true
                        drawings.box.Position = Vector2.new(pos.X - 25, pos.Y - 40)
                        drawings.box.Size = Vector2.new(50, 80)
                        
                        drawings.name.Visible = true
                        drawings.name.Position = Vector2.new(pos.X, pos.Y - 50)
                        
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local distance = (player.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                            drawings.distance.Text = math.floor(distance) .. " studs"
                            drawings.distance.Position = Vector2.new(pos.X, pos.Y + 45)
                        end
                    else
                        drawings.box.Visible = false
                        drawings.name.Visible = false
                        drawings.distance.Visible = false
                    end
                else
                    drawings.box.Visible = false
                    drawings.name.Visible = false
                    drawings.distance.Visible = false
                end
            end
        end)
        
        local notifText = userLanguage == "russian" and "ESP ВКЛЮЧЕН" or "ESP ENABLED"
        showNotification(notifText, theme.success, "👁️")
    else
        for _, drawings in pairs(espDrawings) do
            drawings.box:Remove()
            drawings.name:Remove()
            drawings.distance:Remove()
        end
        espDrawings = {}
        
        local notifText = userLanguage == "russian" and "ESP ВЫКЛЮЧЕН" or "ESP DISABLED"
        showNotification(notifText, theme.danger, "👁️")
    end
end)

-- X-RAY
local xrayBtn, xrayFrame = createButton(
    visualTab,
    "X-RAY",
    "See through walls",
    "🔍",
    Color3.fromRGB(0, 200, 255),
    true
)

xrayBtn.MouseButton1Click:Connect(function()
    local enabled = xrayBtn.Text == "OFF"
    xrayBtn.Text = enabled and "ON" or "OFF"
    xrayBtn.BackgroundColor3 = enabled and theme.success or Color3.fromRGB(60, 60, 80)
    xrayBtn.TextColor3 = enabled and Color3.fromRGB(255, 255, 255) or theme.subtext
    xrayFrame:FindFirstChild("Title").Text = "X-RAY" .. (enabled and " [ON]" or " [OFF]")
    
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and (part.Name:lower():find("wall") or part.Name:lower():find("fence")) then
            part.LocalTransparencyModifier = enabled and 0.5 or 0
        end
    end
    
    local notifText = userLanguage == "russian" and 
                     (enabled and "X-RAY ВКЛ" or "X-RAY ВЫКЛ") or
                     (enabled and "X-RAY ON" or "X-RAY OFF")
    
    showNotification(notifText, 
                    enabled and theme.success or theme.danger, 
                    enabled and "🔍" or "🚫")
end)

-- FULLBRIGHT
local brightBtn, brightFrame = createButton(
    visualTab,
    "FULLBRIGHT",
    "Remove darkness",
    "💡",
    Color3.fromRGB(255, 255, 100),
    true
)

brightBtn.MouseButton1Click:Connect(function()
    local enabled = brightBtn.Text == "OFF"
    brightBtn.Text = enabled and "ON" or "OFF"
    brightBtn.BackgroundColor3 = enabled and theme.success or Color3.fromRGB(60, 60, 80)
    brightBtn.TextColor3 = enabled and Color3.fromRGB(255, 255, 255) or theme.subtext
    brightFrame:FindFirstChild("Title").Text = "FULLBRIGHT" .. (enabled and " [ON]" or " [OFF]")
    
    if enabled then
        Lighting.GlobalShadows = false
        Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    else
        Lighting.GlobalShadows = true
        Lighting.Brightness = 1
        Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
    end
    
    local notifText = userLanguage == "russian" and 
                     (enabled and "FULLBRIGHT ВКЛ" or "FULLBRIGHT ВЫКЛ") or
                     (enabled and "FULLBRIGHT ON" or "FULLBRIGHT OFF")
    
    showNotification(notifText, 
                    enabled and theme.success or theme.danger, 
                    enabled and "💡" or "🌙")
end)

-- ================= TELEPORT TAB =================
local teleportTab = tabFrames[3]

-- Guard Room
local guardBtn = createButton(
    teleportTab,
    "GUARD ROOM",
    "Teleport to guards",
    "👮",
    Color3.fromRGB(100, 150, 255),
    false
)

guardBtn.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(807.032, 99.99, 2307.153)
        local notifText = userLanguage == "russian" and 
                         "ТЕЛЕПОРТ В КОМНАТУ ОХРАНЫ" or 
                         "TELEPORTED TO GUARD ROOM"
        showNotification(notifText, theme.success, "👮")
    end
end)

-- Yard
local yardBtn = createButton(
    teleportTab,
    "PRISON YARD",
    "Teleport to yard",
    "🏀",
    Color3.fromRGB(100, 255, 150),
    false
)

yardBtn.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(803, 98, 2457)
        local notifText = userLanguage == "russian" and 
                         "ТЕЛЕПОРТ В ДВОР" or 
                         "TELEPORTED TO YARD"
        showNotification(notifText, theme.success, "🏀")
    end
end)

-- Criminal Base
local crimBtn = createButton(
    teleportTab,
    "CRIMINAL BASE",
    "Teleport to criminal spawn",
    "🔫",
    Color3.fromRGB(255, 100, 100),
    false
)

crimBtn.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(-920, 94, 2137)
        local notifText = userLanguage == "russian" and 
                         "ТЕЛЕПОРТ В БАЗУ КРИМИНАЛОВ" or 
                         "TELEPORTED TO CRIMINAL BASE"
        showNotification(notifText, theme.success, "🔫")
    end
end)

-- ================= FUN TAB =================
local funTab = tabFrames[4]

-- Spawn Cube
local cubeBtn = createButton(
    funTab,
    "SPAWN CUBE",
    "Create platform",
    "◼",
    Color3.fromRGB(100, 200, 255),
    false
)

local cubes = {}
cubeBtn.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local cube = Instance.new("Part")
        cube.Name = "Cube"
        cube.Size = Vector3.new(5, 5, 5)
        cube.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, -5, 0)
        cube.Anchored = true
        cube.CanCollide = true
        cube.Color = Color3.fromRGB(math.random(50, 255), math.random(50, 255), math.random(50, 255))
        cube.Material = Enum.Material.Neon
        cube.Transparency = 0.3
        cube.Parent = Workspace
        table.insert(cubes, cube)
        
        local notifText = userLanguage == "russian" and 
                         "КУБ СОЗДАН" or 
                         "CUBE SPAWNED"
        showNotification(notifText, theme.success, "◼")
    end
end)

-- Grenade Rain
local grenadeBtn = createButton(
    funTab,
    "GRENADE RAIN",
    "Spawn explosions",
    "💣",
    Color3.fromRGB(255, 50, 50),
    false
)

grenadeBtn.MouseButton1Click:Connect(function()
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
        
        local notifText = userLanguage == "russian" and 
                         "ГРАНАТНЫЙ ДОЖДЬ!" or 
                         "GRENADE RAIN!"
        showNotification(notifText, Color3.fromRGB(255, 100, 100), "💣")
    end
end)

-- Clear Cubes
local clearBtn = createButton(
    funTab,
    "CLEAR CUBES",
    "Remove all spawned cubes",
    "🗑️",
    Color3.fromRGB(255, 150, 50),
    false
)

clearBtn.MouseButton1Click:Connect(function()
    local count = 0
    for _, cube in pairs(cubes) do
        if cube and cube.Parent then
            cube:Destroy()
            count = count + 1
        end
    end
    cubes = {}
    
    local notifText = userLanguage == "russian" and 
                     "УДАЛЕНО " .. count .. " КУБОВ" or 
                     "CLEARED " .. count .. " CUBES"
    showNotification(notifText, theme.success, "🗑️")
end)

-- ================= CREDITS TAB =================
local creditsTab = tabFrames[5]

-- Credits content
local creditsContent = Instance.new("TextLabel")
creditsContent.Name = "CreditsText"
creditsContent.Size = UDim2.new(1, -30, 1, -30)
creditsContent.Position = UDim2.new(0, 15, 0, 15)
creditsContent.BackgroundTransparency = 1
creditsContent.Font = Enum.Font.Gotham
creditsContent.Text = "🎮 AGALIK HUB v5.0 🎮\n\n" ..
                      "Created by: " .. player.Name .. "\n\n" ..
                      "🌟 Special Features:\n" ..
                      "• NOCHIP - Walk through walls\n" ..
                      "• SPEED HACK - 3x speed\n" ..
                      "• INVISIBLE - Become invisible\n" ..
                      "• ESP - See all players\n" ..
                      "• X-RAY - See through walls\n" ..
                      "• FULLBRIGHT - No darkness\n" ..
                      "• Teleports - Guard/Yard/Criminal\n" ..
                      "• Fun - Cubes & Grenades\n\n" ..
                      "🔥 Thanks for using AGALIK HUB!"
creditsContent.TextColor3 = theme.text
creditsContent.TextSize = 14
creditsContent.TextXAlignment = Enum.TextXAlignment.Left
creditsContent.TextYAlignment = Enum.TextYAlignment.Top
creditsContent.TextWrapped = true
creditsContent.Parent = creditsTab

-- ================= МЕНЮ УПРАВЛЕНИЕ =================
local menuVisible = false

local function toggleMenu()
    menuVisible = not menuVisible
    
    if menuVisible then
        mainFrame.Visible = true
        openButton.Visible = false
        
        mainFrame.Size = UDim2.new(0, 10, 0, 10)
        mainFrame.Position = UDim2.new(0.5, -5, 0.5, -5)
        mainFrame.BackgroundTransparency = 1
        
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 450, 0, 400),
            Position = UDim2.new(0.5, -225, 0.5, -200),
            BackgroundTransparency = 0
        }):Play()
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 10, 0, 10),
            Position = UDim2.new(0.5, -5, 0.5, -5),
            BackgroundTransparency = 1
        }):Play()
        
        task.wait(0.2)
        mainFrame.Visible = false
        mainFrame.Size = UDim2.new(0, 450, 0, 400)
        mainFrame.BackgroundTransparency = 0
        
        openButton.Visible = true
    end
end

-- Кнопка принятия инструкции
acceptBtn.MouseButton1Click:Connect(function()
    -- Анимация закрытия инструкции
    TweenService:Create(tutorialFrame, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 10, 0, 10),
        Position = UDim2.new(0.5, -5, 0.5, -5),
        BackgroundTransparency = 1
    }):Play()
    
    task.wait(0.3)
    tutorialFrame.Visible = false
    
    -- Показываем кнопку открытия меню
    openButton.Visible = true
    
    -- Показываем приветственное уведомление
    local welcomeText = userLanguage == "russian" and 
                       "AGALIK HUB v5.0 ЗАГРУЖЕН" or 
                       "AGALIK HUB v5.0 LOADED"
    showNotification(welcomeText, theme.accent, "🎮")
    
    local controlsText = userLanguage == "russian" and 
                        "Нажмите RightControl для открытия меню" or 
                        "Press RightControl to open menu"
    showNotification(controlsText, Color3.fromRGB(255, 184, 0), "⌨️")
    
    tutorialShown = true
end)

-- Обработчики кнопок
openButton.MouseButton1Click:Connect(toggleMenu)
closeBtn.MouseButton1Click:Connect(toggleMenu)

-- Горячая клавиша
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        if tutorialShown then
            toggleMenu()
        end
    end
end)

-- Перетаскивание
local dragging = false
local dragStart, startPos

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

-- Загрузка
task.wait(1)

print("=" .. string.rep("=", 50))
print("AGALIK HUB v5.0 | WITH TUTORIAL")
print("=" .. string.rep("=", 50))
print("✅ Tutorial system - показывается при первом запуске")
print("✅ Выбор языка - English / Russian")
print("✅ Все уведомления на выбранном языке")
print("✅ Все функции работают")
print("=" .. string.rep("=", 50))
