-- ========================================================
-- ROBLOX OPTIMIZATION SCRIPT V3
-- With GitHub Auto-Sell + Improved Optimizations
-- ========================================================
-- 0. JEDA SINGKAT (3 DETIK)
-- ========================================================
task.wait(3)

local CONFIG = {
    TargetFPS              = 2,     
    ShowBlackOverlay      = true,  
    ExtremeDestroy        = true,  
    AntiFallPlatform      = true,  
    DisableGameSounds     = true,  
    DisableParticles      = true,  
    DisableLightingEffects= true,  
    Disable3DRendering    = true,  
    DisableCoreGui        = true,  
    AutoCleanRAM          = true,  
    CleanRAMInterval      = 15     
}

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- ========================================================
-- HELPER FUNCTIONS
-- ========================================================

local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function formatNumber(n)
    local num = tostring(n)
    return num:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

local function getSheckles()
    if LocalPlayer then
        local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
        if leaderstats then
            local money = leaderstats:FindFirstChild("Sheckles") 
                or leaderstats:FindFirstChild("Sheckel") 
                or leaderstats:FindFirstChild("Money") 
                or leaderstats:FindFirstChild("Coins")
            if money then return money.Value end
        end
        local dataFolder = LocalPlayer:FindFirstChild("Data") or LocalPlayer:FindFirstChild("PlayerData")
        if dataFolder then
            local money = dataFolder:FindFirstChild("Sheckles") or dataFolder:FindFirstChild("Sheckel")
            if money then return money.Value end
        end
    end
    return 0
end

local function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local mins = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d:%02d", hours, mins, secs)
end

-- ========================================================
-- HELPER: CEK STATUS DAILY DEALS (IMPROVED - v2)
-- ========================================================
local function checkDailyDeals()
    local isReady = false
    pcall(function()
        local data = LocalPlayer:FindFirstChild("Data") 
            or LocalPlayer:FindFirstChild("PlayerData") 
            or LocalPlayer:FindFirstChild("leaderstats")

        if data then
            local daily = data:FindFirstChild("DailyDeals") 
                or data:FindFirstChild("DailyClaimed") 
                or data:FindFirstChild("DailyReward") 
                or data:FindFirstChild("Daily")
            
            if daily and daily:IsA("BoolValue") then
                if daily.Value then
                    isReady = false
                    return
                else
                    isReady = true
                    return
                end
            end
        end

        local shopData = ReplicatedStorage:FindFirstChild("ShopData") 
            or ReplicatedStorage:FindFirstChild("DailyDeals") 
            or ReplicatedStorage:FindFirstChild("DailyShop")

        if shopData then
            local resetTime = shopData:FindFirstChild("ResetTime") or shopData:FindFirstChild("Cooldown")
            if resetTime then
                if resetTime.Value <= 0 then
                    isReady = true
                    return
                else
                    isReady = false
                    return
                end
            end
        end
    end)
    return isReady
end

-- ========================================================
-- FUNGSI LOGIKA SELL BUAH (GitHub Method)
-- ========================================================
local Networking = nil
pcall(function()
    Networking = require(ReplicatedStorage.SharedModules.Networking)
end)

local function sellFruits()
    local success = false

    if Networking and Networking.NPCS and Networking.NPCS.SellAll then
        pcall(function()
            Networking.NPCS.SellAll:Fire()
            success = true
        end)
        if success then return end
    end

    pcall(function()
        local sellRemote = ReplicatedStorage:FindFirstChild("Sell", true) 
            or ReplicatedStorage:FindFirstChild("SellFruit", true)
            or ReplicatedStorage:FindFirstChild("SellFruits", true)
            or ReplicatedStorage:FindFirstChild("SellAll", true)

        if sellRemote then
            if sellRemote:IsA("RemoteEvent") then
                sellRemote:FireServer()
                success = true
            elseif sellRemote:IsA("RemoteFunction") then
                sellRemote:InvokeServer()
                success = true
            end
        end
    end)

    if success then return end

    pcall(function()
        local char = getCharacter()
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        
        if backpack then
            for _, item in pairs(backpack:GetChildren()) do
                if item:IsA("Tool") and char then
                    item.Parent = char
                    task.wait(0.1)
                    
                    local toolRemote = item:FindFirstChildOfClass("RemoteEvent") 
                        or item:FindFirstChildOfClass("RemoteFunction")
                    
                    if toolRemote then
                        if toolRemote:IsA("RemoteEvent") then
                            toolRemote:FireServer()
                        elseif toolRemote:IsA("RemoteFunction") then
                            toolRemote:InvokeServer()
                        end
                    end
                end
            end
        end
    end)
end

-- ========================================================
-- 1. PRE-OPTIMIZATION (ENGINE LEVEL)
-- ========================================================
pcall(function()
    if CONFIG.Disable3DRendering then
        RunService:Set3dRenderingEnabled(false)
    end

    if CONFIG.DisableGameSounds then
        UserSettings():GetService("UserGameSettings").MasterVolume = 0
    end

    -- Force Graphics Quality to Level 1 (Lowest)
    UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualityLevel.Level01

    if CONFIG.DisableCoreGui then
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    end
end)

-- ========================================================
-- 2. FPS LIMITER (Manual Frame Timing)
-- ========================================================
local TARGET_FPS = CONFIG.TargetFPS
local FRAME_TIME = 1 / TARGET_FPS
local lastFrame = os.clock()

-- ========================================================
-- 3. BLACK OVERLAY UI
-- ========================================================
local fpsLabel, ramLabel, shecklesLabel, dailyDealsLabel, timerLabel
local startTime = os.time()

if CONFIG.ShowBlackOverlay then
    pcall(function()
        local parentGui = gethui and gethui() or game:GetService("CoreGui")
        if not pcall(function() local t = parentGui.Name end) then
            parentGui = LocalPlayer:WaitForChild("PlayerGui")
        end

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "BlackOverlayGui_Fixed"
        screenGui.ResetOnSpawn = false
        screenGui.DisplayOrder = 2147483647
        screenGui.IgnoreGuiInset = true
        screenGui.Parent = parentGui

        local background = Instance.new("Frame")
        background.Size = UDim2.new(1, 0, 1, 0)
        background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        background.BorderSizePixel = 0
        background.Active = true
        background.Parent = screenGui

        local infoContainer = Instance.new("Frame")
        infoContainer.Size = UDim2.new(0, 195, 0, 138)
        infoContainer.Position = UDim2.new(0, 10, 0, 10)
        infoContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        infoContainer.BackgroundTransparency = 0.3
        infoContainer.BorderSizePixel = 0
        infoContainer.Parent = screenGui

        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, 8)
        uiCorner.Parent = infoContainer

        fpsLabel = Instance.new("TextLabel")
        fpsLabel.Size = UDim2.new(1, -10, 0, 18)
        fpsLabel.Position = UDim2.new(0, 5, 0, 3)
        fpsLabel.BackgroundTransparency = 1
        fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
        fpsLabel.TextSize = 12
        fpsLabel.Font = Enum.Font.Code
        fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
        fpsLabel.Text = "FPS : " .. TARGET_FPS
        fpsLabel.Parent = infoContainer

        ramLabel = Instance.new("TextLabel")
        ramLabel.Size = UDim2.new(1, -10, 0, 18)
        ramLabel.Position = UDim2.new(0, 5, 0, 21)
        ramLabel.BackgroundTransparency = 1
        ramLabel.TextColor3 = Color3.fromRGB(0, 191, 255)
        ramLabel.TextSize = 12
        ramLabel.Font = Enum.Font.Code
        ramLabel.TextXAlignment = Enum.TextXAlignment.Left
        ramLabel.Text = "RAM : Measuring..."
        ramLabel.Parent = infoContainer

        shecklesLabel = Instance.new("TextLabel")
        shecklesLabel.Size = UDim2.new(1, -10, 0, 18)
        shecklesLabel.Position = UDim2.new(0, 5, 0, 39)
        shecklesLabel.BackgroundTransparency = 1
        shecklesLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
        shecklesLabel.TextSize = 12
        shecklesLabel.Font = Enum.Font.Code
        shecklesLabel.TextXAlignment = Enum.TextXAlignment.Left
        shecklesLabel.Text = "Sheckles : 0"
        shecklesLabel.Parent = infoContainer

        dailyDealsLabel = Instance.new("TextLabel")
        dailyDealsLabel.Size = UDim2.new(1, -10, 0, 18)
        dailyDealsLabel.Position = UDim2.new(0, 5, 0, 57)
        dailyDealsLabel.BackgroundTransparency = 1
        dailyDealsLabel.TextSize = 12
        dailyDealsLabel.Font = Enum.Font.Code
        dailyDealsLabel.TextXAlignment = Enum.TextXAlignment.Left
        dailyDealsLabel.Text = "Daily Deals : Checking..."
        dailyDealsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        dailyDealsLabel.Parent = infoContainer

        local sellButton = Instance.new("TextButton")
        sellButton.Name = "SellButton"
        sellButton.Size = UDim2.new(1, -10, 0, 22)
        sellButton.Position = UDim2.new(0, 5, 0, 80)
        sellButton.BackgroundColor3 = Color3.fromRGB(0, 170, 85)
        sellButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        sellButton.TextSize = 12
        sellButton.Font = Enum.Font.SourceSansBold
        sellButton.Text = "SELL ALL FRUITS"
        sellButton.Parent = infoContainer

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = sellButton

        sellButton.MouseButton1Click:Connect(function()
            sellButton.Text = "SELLING..."
            sellButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
            sellFruits()
            task.wait(1)
            sellButton.Text = "SELL ALL FRUITS"
            sellButton.BackgroundColor3 = Color3.fromRGB(0, 170, 85)
        end)

        timerLabel = Instance.new("TextLabel")
        timerLabel.Size = UDim2.new(1, -10, 0, 18)
        timerLabel.Position = UDim2.new(0, 5, 0, 107)
        timerLabel.BackgroundTransparency = 1
        timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        timerLabel.TextSize = 12
        timerLabel.Font = Enum.Font.Code
        timerLabel.TextXAlignment = Enum.TextXAlignment.Left
        timerLabel.Text = "Time: 00:00:00"
        timerLabel.Parent = infoContainer
    end)
end

-- ========================================================
-- 4. FPS LIMITER & UI UPDATE LOOP (PreRender)
-- ========================================================
local lastFpsUpdate = os.clock()
local frameCount = 0

RunService.PreRender:Connect(function()
    local now = os.clock()
    local delta = now - lastFrame
    
    -- FPS Limiter: Hold frame until target frame time
    if delta < FRAME_TIME then
        local waitTill = now + (FRAME_TIME - delta)
        while os.clock() < waitTill do
            -- Hold Frame
        end
    end
    
    lastFrame = os.clock()
    frameCount = frameCount + 1
    
    -- UI Update: Every 0.5 seconds
    if CONFIG.ShowBlackOverlay and (now - lastFpsUpdate >= 0.5) then
        if fpsLabel then
            local currentFps = math.floor(frameCount / (now - lastFpsUpdate))
            fpsLabel.Text = "FPS : " .. currentFps
        end
        
        if ramLabel then
            local memoryMB = math.floor(Stats:GetTotalMemoryUsageMb())
            ramLabel.Text = "RAM : " .. memoryMB .. " MB"
        end
        
        if shecklesLabel then 
            shecklesLabel.Text = "Sheckles : " .. formatNumber(getSheckles()) 
        end
        
        if dailyDealsLabel then
            local isReady = checkDailyDeals()
            if isReady then
                dailyDealsLabel.Text = "Daily Deals : READY"
                dailyDealsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            else
                dailyDealsLabel.Text = "Daily Deals : NOT READY"
                dailyDealsLabel.TextColor3 = Color3.fromRGB(255, 75, 75)
            end
        end

        if timerLabel then
            local elapsedTime = os.time() - startTime
            timerLabel.Text = "Time: " .. formatTime(elapsedTime)
        end
        
        frameCount = 0
        lastFpsUpdate = now
    end
end)

-- ========================================================
-- 5. AUTO RAM CLEANER
-- ========================================================
if CONFIG.AutoCleanRAM then
    task.spawn(function()
        while task.wait(CONFIG.CleanRAMInterval) do
            pcall(function() collectgarbage("collect") end)
        end
    end)
end

-- ========================================================
-- 6. ANTI-FALL PLATFORM
-- ========================================================
if CONFIG.AntiFallPlatform then
    task.spawn(function()
        pcall(function()
            local hrp = Character and Character:WaitForChild("HumanoidRootPart", 5)
            if hrp then
                local platform = Instance.new("Part")
                platform.Name = "SafePlatform"
                platform.Size = Vector3.new(10000, 5, 10000)
                platform.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 3.5, hrp.Position.Z)
                platform.Anchored = true
                platform.CanCollide = true
                platform.Transparency = 0.8
                platform.Color = Color3.fromRGB(0, 150, 255)
                platform.Material = Enum.Material.SmoothPlastic
                platform.Parent = Workspace
            end
        end)
    end)
end

-- ========================================================
-- 7. EXTREME OPTIMIZATION (AGGRESSIVE CLEANUP)
-- ========================================================
task.spawn(function()
    pcall(function()
        -- Lighting cleanup
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 1
        
        if CONFIG.DisableLightingEffects then
            for _, v in ipairs(Lighting:GetChildren()) do
                pcall(function() v:Destroy() end)
            end
        end
        
        -- Clear terrain
        if Workspace.Terrain then
            Workspace.Terrain:Clear()
        end
    end)

    -- Destroy workspace objects (except character)
    if CONFIG.ExtremeDestroy then
        local children = Workspace:GetChildren()
        for i, child in ipairs(children) do
            pcall(function()
                if child ~= Character 
                   and not Players:GetPlayerFromCharacter(child) 
                   and child.Name ~= "Camera" 
                   and child.Name ~= "Terrain" 
                   and child.Name ~= "SafePlatform" then
                   
                    child:Destroy()
                end
            end)
            
            if i % 20 == 0 then
                task.wait(0.03)
            end
        end
    end

    -- Clean descendants (particles, sounds, textures)
    local descendants = Workspace:GetDescendants()
    for i, v in ipairs(descendants) do
        pcall(function()
            if CONFIG.DisableParticles and (
                v:IsA("ParticleEmitter") or v:IsA("Trail") or 
                v:IsA("Beam") or v:IsA("Smoke") or 
                v:IsA("Fire") or v:IsA("Sparkles")) then
                v:Destroy()
            elseif CONFIG.DisableGameSounds and v:IsA("Sound") then
                v:Stop()
                v:Destroy()
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            elseif v:IsA("BasePart") and not v:IsDescendantOf(Character) and v.Name ~= "SafePlatform" then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
                v.CastShadow = false
            end
        end)
        
        if i % 30 == 0 then
            task.wait(0.03)
        end
    end

    -- Final cleanup
    pcall(function()
        collectgarbage("collect")
    end)
end)
