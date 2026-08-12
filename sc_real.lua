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

-- HELPER GET CHARACTER
local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

-- HELPER SHECKLES
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

-- ========================================================
-- HELPER: CEK STATUS DAILY DEALS (IMPROVED - v2)
-- ========================================================
local function checkDailyDeals()
    local isReady = false
    pcall(function()
        -- 1. Cek dari Data Pemain (BoolValue)
        local data = LocalPlayer:FindFirstChild("Data") 
            or LocalPlayer:FindFirstChild("PlayerData") 
            or LocalPlayer:FindFirstChild("leaderstats")

        if data then
            local daily = data:FindFirstChild("DailyDeals") 
                or data:FindFirstChild("DailyClaimed") 
                or data:FindFirstChild("DailyReward") 
                or data:FindFirstChild("Daily")
            
            if daily and daily:IsA("BoolValue") then
                -- INVERTED: If claimed (true) = NOT ready
                if daily.Value then
                    isReady = false
                    return
                else
                    -- If not claimed (false) = ready
                    isReady = true
                    return
                end
            end
        end

        -- 2. Cek Cooldown di ReplicatedStorage
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
                    -- Still on cooldown
                    isReady = false
                    return
                end
            end
        end

        -- 3. DISABLED - GUI text detection (too many false positives)
        -- Uncomment if needed, but usually Method 1 & 2 are more reliable
        
        --[[
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            for _, guiElement in ipairs(playerGui:GetDescendants()) do
                if guiElement:IsA("TextButton") and guiElement.Visible and guiElement.Active then
                    local text = string.lower(guiElement.Text)
                    local name = string.lower(guiElement.Name)
                    
                    -- Very strict: Button must say "Claim Daily" or similar
                    if (string.find(text, "^claim daily") or string.find(text, "^daily claim")) 
                        and not string.find(text, "claimed") 
                        and not string.find(text, "cooldown") 
                        and not string.find(text, "hours?")
                        and not string.find(text, "wait") then
                        isReady = true
                        break
                    end
                end
            end
        end
        ]]--
    end)
    return isReady
end

-- ========================================================
-- FUNGSI LOGIKA SELL BUAH (UPDATED - GitHub Method)
-- ========================================================
-- Source: https://github.com/Lutosys/opensrc/blob/main/gag2autosell.lua
-- Method: Networking.NPCS.SellAll:Fire()
-- ========================================================

local Networking = nil

-- Load Networking module once at startup
pcall(function()
    Networking = require(ReplicatedStorage.SharedModules.Networking)
end)

local function sellFruits()
    local success = false

    -- METHOD 1: GitHub Method (PROVEN WORKING)
    if Networking and Networking.NPCS and Networking.NPCS.SellAll then
        pcall(function()
            Networking.NPCS.SellAll:Fire()
            success = true
        end)
        
        if success then return end
    end

    -- METHOD 2: Fallback - Search for RemoteEvent/RemoteFunction
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

    -- METHOD 3: Last Resort - Tool-based selling
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
-- 1. PRE-OPTIMIZATION & TEXTURE/PARTICLE REMOVER
-- ========================================================
pcall(function()
    if CONFIG.Disable3DRendering then
        pcall(function() RunService:Set3dRenderingEnabled(false) end)
    end
    if CONFIG.DisableGameSounds then
        pcall(function() UserSettings():GetService("UserGameSettings").MasterVolume = 0 end)
    end
    if CONFIG.DisableCoreGui then
        pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false) end)
    end

    if CONFIG.DisableLightingEffects then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 0
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("Clouds") then
                v:Destroy()
            end
        end
    end

    if CONFIG.ExtremeDestroy then
        for _, v in pairs(Workspace:GetDescendants()) do
            if CONFIG.DisableParticles and (v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles")) then
                v:Destroy()
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            elseif v:IsA("BasePart") and not v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            end
        end
    end
end)

-- ========================================================
-- 2. OVERLAY UI
-- ========================================================
local fpsLabel, ramLabel, shecklesLabel, dailyDealsLabel, timerLabel
local startTime = os.time()

local function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local mins = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d:%02d", hours, mins, secs)
end

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

        -- 1. FPS Label
        fpsLabel = Instance.new("TextLabel")
        fpsLabel.Size = UDim2.new(1, -10, 0, 18)
        fpsLabel.Position = UDim2.new(0, 5, 0, 3)
        fpsLabel.BackgroundTransparency = 1
        fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
        fpsLabel.TextSize = 12
        fpsLabel.Font = Enum.Font.Code
        fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
        fpsLabel.Text = "FPS : " .. CONFIG.TargetFPS
        fpsLabel.Parent = infoContainer

        -- 2. RAM Label
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

        -- 3. Sheckles Label
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

        -- 4. Daily Deals Status
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

        -- 5. TOMBOL SELL
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

        -- 6. Time Elapsed Label
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
-- 3. LOOP UI & FPS
-- ========================================================
local lastUpdate = os.clock()
local frameCount = 0

RunService.Heartbeat:Connect(function()
    frameCount = frameCount + 1
    local now = os.clock()
    
    if now - lastUpdate >= 0.5 then
        if fpsLabel then fpsLabel.Text = "FPS : " .. math.floor(frameCount / (now - lastUpdate)) end
        if ramLabel then ramLabel.Text = "RAM : " .. math.floor(Stats:GetTotalMemoryUsageMb()) .. " MB" end
        if shecklesLabel then shecklesLabel.Text = "Sheckles : " .. formatNumber(getSheckles()) end
        
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
            timerLabel.Text = "Time: " .. formatTime(os.time() - startTime) 
        end
        
        frameCount = 0
        lastUpdate = now
    end
end)

-- ========================================================
-- 4. CLEANER RAM
-- ========================================================
if CONFIG.AutoCleanRAM then
    task.spawn(function()
        while task.wait(CONFIG.CleanRAMInterval) do
            pcall(function() collectgarbage("collect") end)
        end
    end)
end