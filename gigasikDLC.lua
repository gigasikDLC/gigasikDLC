local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local mouse = player:GetMouse()

-- Настройки комбат функций
local Combat = {
    AimAssist = {
        Enabled = false,
        FOV = 50,
        Smoothing = 0.3,
        TargetPart = "Head",
        TeamCheck = true
    },
    TriggerBot = {
        Enabled = false,
        Delay = 0.1,
        TeamCheck = true
    },
    Hitboxes = {
        Enabled = false,
        Size = 6
    }
}

-- Переменные для хитбоксов
local originalSizes = {}

-- Улучшенный Aim Assist
local function findClosestTarget()
    if not Combat.AimAssist.Enabled then return nil end
    if not player.Character then return nil end
    
    local localHead = player.Character:FindFirstChild("Head")
    if not localHead then return nil end
    
    local closestTarget = nil
    local closestDistance = Combat.AimAssist.FOV
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer == player then continue end
        if Combat.AimAssist.TeamCheck and otherPlayer.Team == player.Team then continue end
        
        local character = otherPlayer.Character
        if not character then continue end
        
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then continue end
        
        local targetPart = character:FindFirstChild(Combat.AimAssist.TargetPart)
        if not targetPart then continue end
        
        -- Проверяем видимость через Raycast
        local rayOrigin = camera.CFrame.Position
        local rayDirection = (targetPart.Position - rayOrigin).Unit * 1000
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {player.Character, character}
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        
        local raycastResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
        if raycastResult and raycastResult.Instance:IsDescendantOf(character) then
            -- Цель видима, проверяем угол
            local screenPoint, onScreen = camera:WorldToViewportPoint(targetPart.Position)
            if onScreen then
                local viewportSize = camera.ViewportSize
                local center = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
                local targetPos = Vector2.new(screenPoint.X, screenPoint.Y)
                local distance = (center - targetPos).Magnitude
                
                if distance < closestDistance then
                    closestTarget = targetPart
                    closestDistance = distance
                end
            end
        end
    end
    
    return closestTarget
end

local function updateAimAssist()
    if not Combat.AimAssist.Enabled then return end
    
    local target = findClosestTarget()
    if not target then return end
    
    local screenPoint = camera:WorldToViewportPoint(target.Position)
    local targetPos = Vector2.new(screenPoint.X, screenPoint.Y)
    local viewportSize = camera.ViewportSize
    local center = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    local currentPos = Vector2.new(mouse.X, mouse.Y)
    
    -- Плавное перемещение мыши
    local delta = targetPos - currentPos
    local smoothedDelta = delta * Combat.AimAssist.Smoothing
    
    mousemoverel(smoothedDelta.X, smoothedDelta.Y)
end

-- Улучшенный Trigger Bot
local function updateTriggerBot()
    if not Combat.TriggerBot.Enabled then return end
    if not player.Character then return end
    
    local target = mouse.Target
    if not target then return end
    
    local targetPlayer = nil
    local model = target:FindFirstAncestorOfClass("Model")
    if model then
        targetPlayer = Players:GetPlayerFromCharacter(model)
    end
    
    -- Проверяем что это враг
    if targetPlayer then
        if targetPlayer == player then return end
        if Combat.TriggerBot.TeamCheck and targetPlayer.Team == player.Team then return end
    end
    
    -- Проверяем что это часть персонажа
    local humanoid = model and model:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health > 0 then
        -- Стреляем с задержкой
        mouse1click()
        wait(Combat.TriggerBot.Delay)
    end
end

-- Рабочие Hitboxes
local function updateHitboxes()
    if not Combat.Hitboxes.Enabled then
        -- Восстанавливаем оригинальные размеры
        for otherPlayer, parts in pairs(originalSizes) do
            if otherPlayer.Character then
                for partName, originalSize in pairs(parts) do
                    local part = otherPlayer.Character:FindFirstChild(partName)
                    if part and part:IsA("BasePart") then
                        part.Size = originalSize
                        part.Transparency = 1
                        part.Material = Enum.Material.Plastic
                    end
                end
            end
        end
        originalSizes = {}
        return
    end
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            if not originalSizes[otherPlayer] then
                originalSizes[otherPlayer] = {}
            end
            
            -- Увеличиваем основные части тела
            local partsToResize = {"Head", "HumanoidRootPart", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
            
            for _, partName in pairs(partsToResize) do
                local part = otherPlayer.Character:FindFirstChild(partName)
                if part and part:IsA("BasePart") then
                    -- Сохраняем оригинальный размер
                    if not originalSizes[otherPlayer][partName] then
                        originalSizes[otherPlayer][partName] = part.Size
                    end
                    
                    -- Увеличиваем размер
                    local newSize = Vector3.new(Combat.Hitboxes.Size, Combat.Hitboxes.Size, Combat.Hitboxes.Size)
                    part.Size = newSize
                    part.Transparency = 0.3
                    part.Material = Enum.Material.Neon
                    part.BrickColor = BrickColor.new("Bright red")
                end
            end
        end
    end
end

-- Главный цикл комбат функций
spawn(function()
    while true do
        updateAimAssist()
        updateTriggerBot()
        updateHitboxes()
        wait()
    end
end)

-- Обновляем меню для комбат функций
local function updateCombatMenu(combatContent)
    for _, child in pairs(combatContent:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    local combatFeatures = {
        {name = "Aim Assist", type = "toggle", setting = "AimAssist", value = "Enabled"},
        {name = "Trigger Bot", type = "toggle", setting = "TriggerBot", value = "Enabled"},
        {name = "Hitboxes", type = "toggle", setting = "Hitboxes", value = "Enabled"}
    }

    local yPosition = 0
    
    for i, feature in pairs(combatFeatures) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 35)
        button.Position = UDim2.new(0, 0, 0, yPosition)
        
        local isEnabled = Combat[feature.setting][feature.value]
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
            Combat[feature.setting][feature.value] = not Combat[feature.setting][feature.value]
            button.BackgroundColor3 = Combat[feature.setting][feature.value] and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(50, 50, 70)
            
            -- Особые действия для некоторых функций
            if feature.setting == "Hitboxes" and not Combat.Hitboxes.Enabled then
                updateHitboxes() -- Сбрасываем хитбоксы при выключении
            end
        end)

        yPosition = yPosition + 40
    end
    
    combatContent.CanvasSize = UDim2.new(0, 0, 0, yPosition)
end

print("Combat functions UPDATED!")
print("✅ Fixed Aim Assist - now works with raycast and team check")
print("✅ Fixed Trigger Bot - now only shoots at enemies")
print("✅ Fixed Hitboxes - now affects all body parts")
print("❌ Removed No Recoil and Rapid Fire")
