-- LocalScript в StarterPlayerScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Создаем GUI для ввода пароля
local passwordGui = Instance.new("ScreenGui")
passwordGui.Name = "PasswordGui"
passwordGui.ResetOnSpawn = false

local passwordFrame = Instance.new("Frame")
passwordFrame.Size = UDim2.new(0.4, 0, 0.3, 0)
passwordFrame.Position = UDim2.new(0.3, 0, 0.35, 0)
passwordFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
passwordFrame.BorderSizePixel = 0
passwordFrame.Parent = passwordGui

local passwordCorner = Instance.new("UICorner")
passwordCorner.CornerRadius = UDim.new(0, 12)
passwordCorner.Parent = passwordFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.3, 0)
title.Position = UDim2.new(0, 0, 0.1, 0)
title.BackgroundTransparency = 1
title.Text = "ВВЕДИТЕ ПАРОЛЬ"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = passwordFrame

local passwordBox = Instance.new("TextBox")
passwordBox.Size = UDim2.new(0.8, 0, 0.2, 0)
passwordBox.Position = UDim2.new(0.1, 0, 0.5, 0)
passwordBox.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
passwordBox.TextColor3 = Color3.fromRGB(255, 255, 255)
passwordBox.PlaceholderText = "Пароль..."
passwordBox.TextScaled = true
passwordBox.ClearTextOnFocus = false
passwordBox.Parent = passwordFrame

local submitButton = Instance.new("TextButton")
submitButton.Size = UDim2.new(0.6, 0, 0.2, 0)
submitButton.Position = UDim2.new(0.2, 0, 0.75, 0)
submitButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.Text = "ПОДТВЕРДИТЬ"
submitButton.TextScaled = true
submitButton.Font = Enum.Font.GothamBold
submitButton.Parent = passwordFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = submitButton

passwordGui.Parent = playerGui

-- Создаем GUI для загрузки
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "LoadingGui"
loadingGui.ResetOnSpawn = false
loadingGui.Enabled = false

local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0.7, 0, 0.25, 0)
loadingFrame.Position = UDim2.new(0.15, 0, 0.35, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
loadingFrame.BorderSizePixel = 0
loadingFrame.Parent = loadingGui

local loadingCorner = Instance.new("UICorner")
loadingCorner.CornerRadius = UDim.new(0, 12)
loadingCorner.Parent = loadingFrame

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, 0, 0.25, 0)
loadingText.Position = UDim2.new(0, 0, 0.1, 0)
loadingText.BackgroundTransparency = 1
loadingText.Text = "ЗАГРУЗКА ДАННЫХ..."
loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingText.TextScaled = true
loadingText.Font = Enum.Font.GothamBold
loadingText.Parent = loadingFrame

local progressBarBackground = Instance.new("Frame")
progressBarBackground.Size = UDim2.new(0.9, 0, 0.15, 0)
progressBarBackground.Position = UDim2.new(0.05, 0, 0.45, 0)
progressBarBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
progressBarBackground.BorderSizePixel = 0
progressBarBackground.Parent = loadingFrame

local progressBarCorner = Instance.new("UICorner")
progressBarCorner.CornerRadius = UDim.new(0, 8)
progressBarCorner.Parent = progressBarBackground

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.Position = UDim2.new(0, 0, 0, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(0, 200, 83)
progressBar.BorderSizePixel = 0
progressBar.Parent = progressBarBackground

local progressBarCorner2 = Instance.new("UICorner")
progressBarCorner2.CornerRadius = UDim.new(0, 8)
progressBarCorner2.Parent = progressBar

local percentageText = Instance.new("TextLabel")
percentageText.Size = UDim2.new(1, 0, 0.25, 0)
percentageText.Position = UDim2.new(0, 0, 0.7, 0)
percentageText.BackgroundTransparency = 1
percentageText.Text = "0%"
percentageText.TextColor3 = Color3.fromRGB(255, 255, 255)
percentageText.TextScaled = true
percentageText.Font = Enum.Font.Gotham
percentageText.Parent = loadingFrame

loadingGui.Parent = playerGui

-- Функция для генерации большого количества данных (~1 ГБ)
local function generateLargeData()
    local data = ""
    -- Генерируем ~10KB данных за раз
    for i = 1, 100 do
        data = data .. "Секция данных " .. i .. ": " .. string.rep(tostring(math.random(1000000, 9999999)), 50) .. "\n"
    end
    return data
end

-- Функция для быстрого создания файлов
local function downloadFiles()
    local correctPassword = "1488"
    local totalFiles = 26 * 40  -- 1040 файлов (алфавит × 40)
    local filesCreated = 0
    local targetSize = 1 * 1024 * 1024 * 1024  -- 1 ГБ в байтах
    local currentSize = 0
    
    -- Создаем папку для файлов
    local filesFolder = Instance.new("Folder")
    filesFolder.Name = "DownloadedFiles"
    filesFolder.Parent = ReplicatedStorage
    
    -- Показываем GUI загрузки
    loadingGui.Enabled = true
    passwordGui.Enabled = false
    
    -- Быстрое создание файлов в нескольких потоках (корутинах)
    local function createFileBatch(letter, batchNumber)
        local fileData = generateLargeData()
        local fileSize = #fileData
        
        for i = 1, 40 do
            local fileName = letter .. "_" .. i
            local stringValue = Instance.new("StringValue")
            stringValue.Name = fileName
            stringValue.Value = fileData .. "\nBatch: " .. batchNumber
            stringValue.Parent = filesFolder
            
            filesCreated = filesCreated + 1
            currentSize = currentSize + fileSize
            
            -- Обновляем прогресс каждые 10 файлов для производительности
            if filesCreated % 10 == 0 then
                local progress = (filesCreated / totalFiles) * 100
                progressBar.Size = UDim2.new(progress / 100, 0, 1, 0)
                percentageText.Text = string.format("%.1f%%", progress)
                
                -- Небольшая задержка для плавности анимации
                wait(0.01)
            end
        end
    end
    
    -- Создаем файлы для каждой буквы алфавита
    local alphabet = {}
    for i = 1, 26 do
        alphabet[i] = string.char(96 + i)  -- a-z
    end
    
    -- Быстрое создание файлов (имитация многопоточности)
    for batch = 1, 5 do
        for _, letter in ipairs(alphabet) do
            spawn(function()
                createFileBatch(letter, batch)
            end)
        end
        wait(0.05) -- Короткая пауза между батчами
    end
    
    -- Ждем завершения всех операций
    while filesCreated < totalFiles do
        wait(0.1)
    end
    
    -- Завершаем загрузку
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    percentageText.Text = "100% - ЗАВЕРШЕНО!"
    loadingText.Text = "СКАЧАНО: " .. string.format("%.2f ГБ", currentSize / (1024^3))
    
    wait(2)
    loadingGui.Enabled = false
end

-- Обработчик кнопки подтверждения пароля
submitButton.MouseButton1Click:Connect(function()
    local enteredPassword = passwordBox.Text
    
    if enteredPassword == "1488" then
        -- Правильный пароль - начинаем загрузку
        passwordBox.Text = "Пароль верный!"
        passwordBox.TextColor3 = Color3.fromRGB(0, 255, 0)
        wait(1)
        downloadFiles()
    else
        -- Неправильный пароль
        passwordBox.Text = "НЕВЕРНЫЙ ПАРОЛЬ!"
        passwordBox.TextColor3 = Color3.fromRGB(255, 50, 50)
        
        -- Анимация тряски
        local startPos = passwordFrame.Position
        for i = 1, 10 do
            local offset = math.sin(i * 2) * 5
            passwordFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + offset, startPos.Y.Scale, startPos.Y.Offset)
            wait(0.02)
        end
        passwordFrame.Position = startPos
        
        wait(1)
        passwordBox.Text = ""
        passwordBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        passwordBox.PlaceholderText = "Попробуйте снова..."
    end
end)

-- Обработчик нажатия Enter в текстовом поле
passwordBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        submitButton.MouseButton1Click:Wait()
    end
end)

-- Анимация появления интерфейса
passwordFrame.BackgroundTransparency = 1
passwordText.BackgroundTransparency = 1
passwordBox.BackgroundTransparency = 1
submitButton.BackgroundTransparency = 1

wait(1)

local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local tween1 = TweenService:Create(passwordFrame, tweenInfo, {BackgroundTransparency = 0})
local tween2 = TweenService:Create(passwordText, tweenInfo, {BackgroundTransparency = 1})
local tween3 = TweenService:Create(passwordBox, tweenInfo, {BackgroundTransparency = 0})
local tween4 = TweenService:Create(submitButton, tweenInfo, {BackgroundTransparency = 0})

tween1:Play()
tween2:Play()
tween3:Play()
tween4:Play()
