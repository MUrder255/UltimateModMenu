debugX = true
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Ultimate Roblox Mod Menu",
    Icon = 4483362458, -- Using an icon for better visibility
    LoadingTitle = "Ultimate Mod Menu",
    LoadingSubtitle = "by ModMaster",
    Theme = "Midnight", -- Using a dark theme for better visibility
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = true,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "UltimateModMenu",
        FileName = "ModMenuConfig"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Ultimate Mod Menu",
        Subtitle = "Key System",
        Note = "Join our Discord for the key",
        FileName = "ModMenuKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"ModMenu2024"}
    }
})

-- Local player reference
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Function to get character when it changes
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
end)

-- Utility functions
local function notify(title, content, duration)
    Rayfield:Notify({
        Title = title,
        Content = content,
        Duration = duration or 3,
        Image = 4483362458
    })
end

-- Player Modifications Tab
local PlayerTab = Window:CreateTab("Player", 4483362458)
local PlayerSection = PlayerTab:CreateSection("Character Modifications")

-- Health and Stamina
local healthRegenToggle = PlayerTab:CreateToggle({
    Name = "Health Regeneration",
    CurrentValue = false,
    Flag = "HealthRegen",
    Callback = function(Value)
        if Value then
            notify("Enabled", "Health Regeneration activated")
            
            -- Create a loop that regenerates health
            _G.healthRegenLoop = game:GetService("RunService").Heartbeat:Connect(function()
                if character and humanoid and humanoid.Health < humanoid.MaxHealth then
                    humanoid.Health = humanoid.Health + 0.1
                end
            end)
        else
            notify("Disabled", "Health Regeneration deactivated")
            if _G.healthRegenLoop then
                _G.healthRegenLoop:Disconnect()
                _G.healthRegenLoop = nil
            end
        end
    end,
})

local healOnKillToggle = PlayerTab:CreateToggle({
    Name = "Heal on Kill",
    CurrentValue = false,
    Flag = "HealOnKill",
    Callback = function(Value)
        if Value then
            notify("Enabled", "Heal on Kill activated")
            
            -- Connect to character deaths to heal player
            _G.healOnKillConnection = game.Players.PlayerRemoving:Connect(function(plr)
                if plr ~= player and character and humanoid then
                    humanoid.Health = humanoid.MaxHealth
                    notify("Healed", "Full health restored after kill")
                end
            end)
        else
            notify("Disabled", "Heal on Kill deactivated")
            if _G.healOnKillConnection then
                _G.healOnKillConnection:Disconnect()
                _G.healOnKillConnection = nil
            end
        end
    end,
})

local superStaminaToggle = PlayerTab:CreateToggle({
    Name = "Super Stamina/Endurance",
    CurrentValue = false,
    Flag = "SuperStamina",
    Callback = function(Value)
        if Value then
            notify("Enabled", "Super Stamina activated")
            -- This is a placeholder as stamina systems vary by game
            -- Will attempt to find and modify stamina values
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" and rawget(v, "Stamina") then
                    v.Stamina = math.huge
                    v.MaxStamina = math.huge
                end
            end
        else
            notify("Disabled", "Super Stamina deactivated")
            -- Would need game-specific reset logic
        end
    end,
})

-- Movement Modifications
local MovementSection = PlayerTab:CreateSection("Movement Modifications")

local speedSlider = PlayerTab:CreateSlider({
    Name = "Speed Multiplier",
    Range = {16, 500},
    Increment = 1,
    Suffix = "x",
    CurrentValue = 16,
    Flag = "SpeedMultiplier",
    Callback = function(Value)
        if humanoid then
            humanoid.WalkSpeed = Value
        end
    end,
})

local jumpSlider = PlayerTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 500},
    Increment = 5,
    Suffix = "x",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        if humanoid then
            humanoid.JumpPower = Value
        end
    end,
})

local superJumpToggle = PlayerTab:CreateToggle({
    Name = "Super Jump/Moon Jump",
    CurrentValue = false,
    Flag = "SuperJump",
    Callback = function(Value)
        if Value then
            notify("Enabled", "Super Jump activated")
            
            _G.superJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                if character and rootPart then
                    rootPart.Velocity = Vector3.new(rootPart.Velocity.X, 200, rootPart.Velocity.Z)
                end
            end)
        else
            notify("Disabled", "Super Jump deactivated")
            if _G.superJumpConnection then
                _G.superJumpConnection:Disconnect()
                _G.superJumpConnection = nil
            end
        end
    end,
})

local flyToggle = PlayerTab:CreateToggle({
    Name = "Fly Mode",
    CurrentValue = false,
    Flag = "FlyMode",
    Callback = function(Value)
        if Value then
            notify("Enabled", "Fly Mode activated")
            
            local flySpeed = 2
            local flyBv = Instance.new("BodyVelocity")
            flyBv.Velocity = Vector3.new(0, 0, 0)
            flyBv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            flyBv.Parent = rootPart
            
            _G.flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
                local camera = workspace.CurrentCamera
                local moveDirection = player:GetMouse().Hit.Position - rootPart.Position
                moveDirection = moveDirection.Unit * flySpeed
                
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                    flyBv.Velocity = camera.CFrame.LookVector * 100
                elseif game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                    flyBv.Velocity = camera.CFrame.LookVector * -100
                elseif game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                    flyBv.Velocity = camera.CFrame.RightVector * -100
                elseif game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                    flyBv.Velocity = camera.CFrame.RightVector * 100
                else
                    flyBv.Velocity = Vector3.new(0, 0, 0)
                end
            end)
        else
            notify("Disabled", "Fly Mode deactivated")
            if _G.flyConnection then
                _G.flyConnection:Disconnect()
                _G.flyConnection = nil
            end
            
            for _, v in pairs(rootPart:GetChildren()) do
                if v:IsA("BodyVelocity") then
                    v:Destroy()
                end
            end
        end
    end,
})

local noClipToggle = PlayerTab:CreateToggle({
    Name = "No Clip",
    CurrentValue = false,
    Flag = "NoClip",
    Callback = function(Value)
        if Value then
            notify("Enabled", "No Clip activated")
            
            _G.noClipLoop = game:GetService("RunService").Stepped:Connect(function()
                if character then
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            notify("Disabled", "No Clip deactivated")
            if _G.noClipLoop then
                _G.noClipLoop:Disconnect()
                _G.noClipLoop = nil
            end
            
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
        end
    end,
})

local bunnyHopToggle = PlayerTab:CreateToggle({
    Name = "Bunny Hop",
    CurrentValue = false,
    Flag = "BunnyHop",
    Callback = function(Value)
        if Value then
            notify("Enabled", "Bunny Hop activated")
            
            _G.bunnyHopLoop = game:GetService("RunService").Heartbeat:Connect(function()
                if character and humanoid and humanoid:GetState() == Enum.HumanoidStateType.Running then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            notify("Disabled", "Bunny Hop deactivated")
            if _G.bunnyHopLoop then
                _G.bunnyHopLoop:Disconnect()
                _G.bunnyHopLoop = nil
            end
        end
    end,
})

local blinkTeleportToggle = PlayerTab:CreateToggle({
    Name = "Blink/Teleport",
    CurrentValue = false,
    Flag = "BlinkTeleport",
    Callback = function(Value)
        if Value then
            notify("Enabled", "Blink Teleport activated (Press T)")
            
            _G.blinkConnection = game:GetService("UserInputService").InputBegan:Connect(function(input)
                if input.KeyCode == Enum.KeyCode.T and character and rootPart then
                    local mouse = player:GetMouse()
                    local targetPos = mouse.Hit.Position
                    rootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
                end
            end)
        else
            notify("Disabled", "Blink Teleport deactivated")
            if _G.blinkConnection then
                _G.blinkConnection:Disconnect()
                _G.blinkConnection = nil
            end
        end
    end,
})

-- Combat Tab
local CombatTab = Window:CreateTab("Combat", 4483362458)
local CombatSection = CombatTab:CreateSection("Combat Modifications")

local infiniteAmmoToggle = CombatTab:CreateToggle({
    Name = "Infinite Ammo/No Reload",
    CurrentValue = false,
    Flag = "InfiniteAmmo",
    Callback = function(Value)
        if Value then
            notify("Enabled", "Infinite Ammo activated")
            
            -- Hook into weapon systems (generic approach)
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" and rawget(v, "Ammo") then
                    v.Ammo = math.huge
                    v.MaxAmmo = math.huge
                    v.StoredAmmo = math.huge
                    v.ReloadTime = 0
                end
            end
        else
            notify("Disabled", "Infinite Ammo deactivated")
            -- Would need game-specific reset logic
        end
    end,
})

local oneHitKillToggle = CombatTab:CreateToggle({
    Name = "One-Hit Kill",
    CurrentValue = false,
    Flag = "OneHitKill",
    Callback = function(Value)
        if Value then
            notify("Enabled", "One-Hit Kill activated")
            
            -- Hook into damage systems (generic approach)
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" and rawget(v, "Damage") then
                    v.Damage = 9999
                end
            end
        else
            notify("Disabled", "One-Hit Kill deactivated")
            -- Would need game-specific reset logic
        end
    end,
})

local noRecoilToggle = CombatTab:CreateToggle({
    Name = "No Recoil",
    CurrentValue = false,
    Flag = "NoRecoil",
    Callback = function(Value)
        if Value then
            notify("Enabled", "No Recoil activated")
            
            -- Hook into recoil systems (generic approach)
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" and rawget(v, "Recoil") then
                    v.Recoil = 0
                    v.RecoilX = 0
                    v.RecoilY = 0
                end
            end
        else
            notify("Disabled", "No Recoil deactivated")
            -- Would need game-specific reset logic
        end
    end,
})

local critChanceSlider = CombatTab:CreateSlider({
    Name = "Critical Hit Chance",
    Range = {0, 100},
    Increment = 5,
    Suffix = "%",
    CurrentValue = 0,
    Flag = "CritChance",
    Callback = function(Value)
        -- Hook into crit systems (generic approach)
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "CritChance") then
                v.CritChance = Value / 100
            end
        end
    end,
})

local damageMultiplierSlider = WeaponsTab:CreateSlider({
    Name = "Damage Multiplier",
    Range = {1, 100},
    Increment = 1,
    Suffix = "x",
    CurrentValue = 1,
    Flag = "WeaponDamageMultiplier",
    Callback = function(Value)
        -- Hook into weapon systems (generic approach)
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" then
                if rawget(v, "Damage") then
                    v.Damage = v.Damage * Value
                end
                if rawget(v, "BaseDamage") then
                    v.BaseDamage = v.BaseDamage * Value
                end
            end
        end
        
        notify("Updated", "Damage Multiplier set to " .. Value .. "x")
    end,
})

-- Aimbot Section
local AimbotSection = CombatTab:CreateSection("Aimbot & Targeting")

local aimbotToggle = CombatTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "Aimbot",
    Callback = function(Value)
        if Value then
            notify("Enabled", "Aimbot activated")
            
            _G.aimbotLoop = game:GetService("RunService").RenderStepped:Connect(function()
                local closestPlayer = nil
                local shortestDistance = math.huge
                
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                        local distance = (p.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                        if distance < shortestDistance then
                            closestPlayer = p
                            shortestDistance = distance
                        end
                    end
                end
                
                if closestPlayer and closestPlayer.Character:FindFirstChild("Head") then
                    workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closestPlayer.Character.Head.Position)
                end
            end)
        else
            notify("Disabled", "Aimbot deactivated")
            if _G.aimbotLoop then
                _G.aimbotLoop:Disconnect()
                _G.aimbotLoop = nil
            end
        end
    end,
})

local headshotAimbotToggle = CombatTab:CreateToggle({
    Name = "Headshot Aimbot",
    CurrentValue = false,
    Flag = "HeadshotAimbot",
    Callback = function(Value)
        if Value then
            notify("Enabled", "Headshot Aimbot activated")
            
            _G.headshotAimbotLoop = game:GetService("RunService").RenderStepped:Connect(function()
                local closestPlayer = nil
                local shortestDistance = math.huge
                
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= player and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                        local distance = (p.Character.Head.Position - character.HumanoidRootPart.Position).Magnitude
                        if distance < shortestDistance then
                            closestPlayer = p
                            shortestDistance = distance
                        end
                    end
                end
                
                if closestPlayer and closestPlayer.Character:FindFirstChild("Head") then
                    workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closestPlayer.Character.Head.Position)
                end
            end)
        else
            notify("Disabled", "Headshot Aimbot deactivated")
            if _G.headshotAimbotLoop then
                _G.headshotAimbotLoop:Disconnect()
                _G.headshotAimbotLoop = nil
            end
        end
    end,
})

local wallAimbotToggle = CombatTab:CreateToggle({
    Name = "Aim Through Walls",
    CurrentValue = false,
    Flag = "WallAimbot",
    Callback = function(Value)
        if Value then
            notify("Enabled", "Aim Through Walls activated")
            -- This feature is typically handled by the aimbot logic
            -- but we can add specific wall detection bypass here
            _G.wallAimbot = true
        else
            notify("Disabled", "Aim Through Walls deactivated")
            _G.wallAimbot = false
        end
    end,
})

local hitboxSlider = CombatTab:CreateSlider({
    Name = "Hitbox Size",
    Range = {1, 20},
    Increment = 0.5,
    Suffix = "x",
    CurrentValue = 1,
    Flag = "HitboxSize",
    Callback = function(Value)
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(2 * Value, 2 * Value, 1 * Value)
                p.Character.HumanoidRootPart.Transparency = 0.5
            end
        end
    end,
})

-- Visual Tab
local VisualTab = Window:CreateTab("Visuals", 4483362458)
local ESPSection = VisualTab:CreateSection("ESP & Visual Enhancements")

local espToggle = VisualTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "PlayerESP",
    Callback = function(Value)
        if Value then
            notify("Enabled", "Player ESP activated")
            
            -- Create ESP
            _G.espEnabled = true
            
            -- Remove existing ESP
            for _, v in pairs(game.CoreGui:GetChildren()) do
                if v.Name == "ESPFolder" then
                    v:Destroy()
                end
            end
            
            local ESPFolder = Instance.new("Folder", game.CoreGui)
            ESPFolder.Name = "ESPFolder"
            
            _G.espUpdateLoop = game:GetService("RunService").RenderStepped:Connect(function()
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                        local espBox = p.Character:FindFirstChild("ESPBox")
                        
                        if not espBox then
                            espBox = Instance.new("BoxHandleAdornment")
                            espBox.Name = "ESPBox"
                            espBox.Adornee = p.Character.HumanoidRootPart
                            espBox.AlwaysOnTop = true
                            espBox.ZIndex = 10
                            espBox.Size = p.Character.HumanoidRootPart.Size * 2
                            espBox.Transparency = 0.7
                            espBox.Color3 = Color3.fromRGB(255, 0, 0)
                            espBox.Parent = p.Character
                            
                            local espName = Instance.new("BillboardGui")
                            espName.Name = "ESPName"
                            espName.Adornee = p.Character.Head
                            espName.AlwaysOnTop = true
                            espName.ExtentsOffset = Vector3.new(0, 2, 0)
                            espName.Size = UDim2.new(0, 100, 0, 30)
                            espName.Parent = p.Character
                            
                            local nameLabel = Instance.new("TextLabel")
                            nameLabel.BackgroundTransparency = 1
                            nameLabel.Position = UDim2.new(0, 0, 0, 0)
                            nameLabel.Size = UDim2.new(1, 0, 1, 0)
                            nameLabel.Font = Enum.Font.GothamBold
                            nameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                            nameLabel.TextStrokeTransparency = 0.5
                            nameLabel.TextSize = 14
                            nameLabel.Text = p.Name
                            nameLabel.Parent = espName
                        end
                    end
                end
            end)
        else
            notify("Disabled", "Player ESP deactivated")
            _G.espEnabled = false
            
            if _G.espUpdateLoop then
                _G.espUpdateLoop:Disconnect()
                _G.espUpdateLoop = nil
            end
            
            -- Remove ESP
            for _, p in pairs(game.Players:GetPlayers()) do
                if p.Character then
                    for _, v in pairs(p.Character:GetChildren()) do
                        if v.Name == "ESPBox" or v.Name == "ESPName" then
                            v:Destroy()
                        end
                    end
                end
            end
        end
    end,
})

local ghostModeToggle = VisualTab:CreateToggle({
    Name = "Ghost Mode",
    CurrentValue = false,
    Flag = "GhostMode",
    Callback = function(Value)
        if Value then
            notify("Enabled", "Ghost Mode activated")
            
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 0.7
                    end
                end
            end
        else
            notify("Disabled", "Ghost Mode deactivated")
            
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.Transparency = 0
                    end
                end
            end
        end
    end,
})

local xrayToggle = VisualTab:CreateToggle({
    Name = "X-Ray Vision",
    CurrentValue = false,
    Flag = "XRayVision",
    Callback = function(Value)
        if Value then
            notify("Enabled", "X-Ray Vision activated")
            
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v:IsDescendantOf(character) and not v.Parent:FindFirstChild("Humanoid") then
                    v.Transparency = 0.8
                end
            end
        else
            notify("Disabled", "X-Ray Vision deactivated")
            
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v:IsDescendantOf(character) and not v.Parent:FindFirstChild("Humanoid") then
                    v.Transparency = 0
                end
            end
        end
    end,
})

-- Game Modifications Tab
local GameTab = Window:CreateTab("Game Mods", 4483362458)
local GameSection = GameTab:CreateSection("Game Modifications")

local godModeToggle = GameTab:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,
    Flag = "GodMode",
    Callback = function(Value)
        if Value then
            notify("Enabled", "God Mode activated")
            
            _G.godModeLoop = game:GetService("RunService").Stepped:Connect(function()
                if character and humanoid then
                    humanoid.MaxHealth = math.huge
                    humanoid.Health = math.huge
                end
            end)
        else
            notify("Disabled", "God Mode deactivated")
            if _G.godModeLoop then
                _G.godModeLoop:Disconnect()
                _G.godModeLoop = nil
            end
            
            if character and humanoid then
                humanoid.MaxHealth = 100
                humanoid.Health = 100
            end
        end
    end,
})

local noFallDamageToggle = GameTab:CreateToggle({
    Name = "No Fall Damage",
    CurrentValue = false,
    Flag = "NoFallDamage",
    Callback = function(Value)
        if Value then
            notify("Enabled", "No Fall Damage activated")
            
            _G.noFallDamageConnection = character.ChildAdded:Connect(function(child)
                if child.Name == "FallDamage" or child.Name:find("Fall") then
                    child:Destroy()
                end
            end)
        else
            notify("Disabled", "No Fall Damage deactivated")
            if _G.noFallDamageConnection then
                _G.noFallDamageConnection:Disconnect()
                _G.noFallDamageConnection = nil
            end
        end
    end,
})

local infiniteMoneyButton = GameTab:CreateButton({
    Name = "Infinite Money (May not work in all games)",
    Callback = function()
        notify("Attempting", "Trying to add infinite money...")
        
        -- Try different approaches for different games
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" then
                if rawget(v, "Money") then
                    v.Money = 999999
                    notify("Success", "Added 999999 Money")
                elseif rawget(v, "Cash") then
                    v.Cash = 999999
                    notify("Success", "Added 999999 Cash")
                elseif rawget(v, "Points") then
                    v.Points = 999999
                    notify("Success", "Added 999999 Points")
                end
            end
        end
        
        -- Try player stats
        if player:FindFirstChild("leaderstats") then
            for _, stat in pairs(player.leaderstats:GetChildren()) do
                if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                    local success, err = pcall(function()
                        stat.Value = 999999
                    end)
                    
                    if success then
                        notify("Success", "Modified " .. stat.Name .. " to 999999")
                    end
                end
            end
        end
    end,
})

local infiniteXPButton = GameTab:CreateButton({
    Name = "XP Multiplier (May not work in all games)",
    Callback = function()
        notify("Attempting", "Trying to multiply XP gains...")
        
        -- Try different approaches for different games
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" then
                if rawget(v, "XP") then
                    v.XP = v.XP * 100
                    notify("Success", "Multiplied XP by 100")
                elseif rawget(v, "Experience") then
                    v.Experience = v.Experience * 100
                    notify("Success", "Multiplied Experience by 100")
                elseif rawget(v, "XPMultiplier") then
                    v.XPMultiplier = 100
                    notify("Success", "Set XP Multiplier to 100")
                end
            end
        end
    end,
})

-- Teleportation Section
local TeleportSection = GameTab:CreateSection("Teleportation")

local teleportToPlayersDropdown = GameTab:CreateDropdown({
    Name = "Teleport to Player",
    Options = {},
    CurrentOption = "",
    Flag = "TeleportToPlayer",
    Callback = function(Option)
        local targetPlayer = game.Players:FindFirstChild(Option)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            character:SetPrimaryPartCFrame(CFrame.new(targetPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0)))
            notify("Teleported", "Teleported to " .. targetPlayer.Name)
        else
            notify("Error", "Could not teleport to player")
        end
    end,
})

-- Update player list for teleport dropdown
local function updatePlayerList()
    local playerNames = {}
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player then
            table.insert(playerNames, p.Name)
        end
    end
    teleportToPlayersDropdown:Refresh(playerNames, true)
end

-- Initial update
updatePlayerList()

-- Update when players join/leave
game.Players.PlayerAdded:Connect(updatePlayerList)
game.Players.PlayerRemoving:Connect(updatePlayerList)

-- Map Modifications Tab
local MapTab = Window:CreateTab("Map Mods", 4483362458)
local MapSection = MapTab:CreateSection("Map Modifications")

local removeMapBoundariesToggle = MapTab:CreateToggle({
    Name = "Remove Map Boundaries",
    CurrentValue = false,
    Flag = "RemoveMapBoundaries",
    Callback = function(Value)
        if Value then
            notify("Enabled", "Removing Map Boundaries...")
            
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and (v.Name:lower():find("bound") or v.Name:lower():find("barrier") or v.Name:lower():find("wall")) then
                    v.CanCollide = false
                    v.Transparency = 0.8
                end
            end
        else
            notify("Disabled", "Restoring Map Boundaries...")
            
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and (v.Name:lower():find("bound") or v.Name:lower():find("barrier") or v.Name:lower():find("wall")) then
                    v.CanCollide = true
                    v.Transparency = 0
                end
            end
        end
    end,
})

local noCollisionToggle = MapTab:CreateToggle({
    Name = "No Collision With Objects",
    CurrentValue = false,
    Flag = "NoCollision",
    Callback = function(Value)
        if Value then
            notify("Enabled", "No Collision activated")
            
            _G.noCollisionLoop = game:GetService("RunService").Stepped:Connect(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and not v:IsDescendantOf(character) and not v.Parent:FindFirstChild("Humanoid") then
                        v.CanCollide = false
                    end
                end
            end)
        else
            notify("Disabled", "No Collision deactivated")
            if _G.noCollisionLoop then
                _G.noCollisionLoop:Disconnect()
                _G.noCollisionLoop = nil
            end
            
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v:IsDescendantOf(character) and not v.Parent:FindFirstChild("Humanoid") then
                    v.CanCollide = true
                end
            end
        end
    end,
})

local noGravityToggle = MapTab:CreateToggle({
    Name = "No Gravity",
    CurrentValue = false,
    Flag = "NoGravity",
    Callback = function(Value)
        if Value then
            notify("Enabled", "No Gravity activated")
            
            workspace.Gravity = 0
            
            if character and rootPart then
                for _, v in pairs(character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.Massless = true
                    end
                end
            end
        else
            notify("Disabled", "No Gravity deactivated")
            
            workspace.Gravity = 196.2
            
            if character and rootPart then
                for _, v in pairs(character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.Massless = false
                    end
                end
            end
        end
    end,
})

local terrainModificationToggle = MapTab:CreateToggle({
    Name = "Terrain Modification",
    CurrentValue = false,
    Flag = "TerrainModification",
    Callback = function(Value)
        if Value then
            notify("Enabled", "Terrain Modification activated (Click to modify)")
            
            _G.terrainModification = true
            
            _G.terrainModificationConnection = game:GetService("UserInputService").InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and _G.terrainModification then
                    local mouse = player:GetMouse()
                    local terrain = workspace.Terrain
                    
                    terrain:FillBall(mouse.Hit.Position, 5, Enum.Material.Air)
                    notify("Terrain Modified", "Created hole at position")
                end
            end)
        else
            notify("Disabled", "Terrain Modification deactivated")
            _G.terrainModification = false
            
            if _G.terrainModificationConnection then
                _G.terrainModificationConnection:Disconnect()
                _G.terrainModificationConnection = nil
            end
        end
    end,
})

-- Appearance Tab
local AppearanceTab = Window:CreateTab("Appearance", 4483362458)
local AppearanceSection = AppearanceTab:CreateSection("Character Appearance")

local skinColorPicker = AppearanceTab:CreateColorPicker({
    Name = "Skin Color",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "SkinColor",
    Callback = function(Color)
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name:lower():find("torso") or part.Name:lower():find("arm") or part.Name:lower():find("leg") or part.Name:lower():find("head") then
                    part.Color = Color
                end
            end
        end
    end,
})

local characterScaleSlider = AppearanceTab:CreateSlider({
    Name = "Character Scale",
    Range = {0.5, 5},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = 1,
    Flag = "CharacterScale",
    Callback = function(Value)
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Size = part.Size * (Value / character.Humanoid.ScaleDeterminingParts[part.Name])
                    character.Humanoid.ScaleDeterminingParts[part.Name] = Value
                end
            end
            
            -- Attempt to scale the character using BodyDepthScale etc.
            pcall(function()
                character.Humanoid.BodyDepthScale.Value = Value
                character.Humanoid.BodyWidthScale.Value = Value
                character.Humanoid.BodyHeightScale.Value = Value
                character.Humanoid.HeadScale.Value = Value
            end)
        end
    end,
})

local invisibilityToggle = AppearanceTab:CreateToggle({
    Name = "Invisibility",
    CurrentValue = false,
    Flag = "Invisibility",
    Callback = function(Value)
        if Value then
            notify("Enabled", "Invisibility activated")
            
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") or part:IsA("Decal") then
                        part.Transparency = 1
                    end
                end
            end
        else
            notify("Disabled", "Invisibility deactivated")
            
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.Transparency = 0
                    elseif part:IsA("Decal") then
                        part.Transparency = 0
                    end
                end
            end
        end
    end,
})

-- Miscellaneous Tab
local MiscTab = Window:CreateTab("Misc", 4483362458)
local MiscSection = MiscTab:CreateSection("Miscellaneous Features")

local serverHopButton = MiscTab:CreateButton({
    Name = "Server Hop (Join Different Server)",
    Callback = function()
        notify("Server Hopping", "Finding a new server...")
        
        local TeleportService = game:GetService("TeleportService")
        local HttpService = game:GetService("HttpService")
        local servers = {}
        
        local req = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
        local data = HttpService:JSONDecode(req)
        
        if data and data.data then
            for _, server in pairs(data.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    table.insert(servers, server.id)
                end
            end
            
            if #servers > 0 then
                notify("Server Found", "Teleporting to new server...")
                TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)])
            else
                notify("Error", "No suitable servers found")
            end
        else
            notify("Error", "Failed to fetch server list")
        end
    end,
})

local fullbrightToggle = MiscTab:CreateToggle({
    Name = "Fullbright (No Darkness)",
    CurrentValue = false,
    Flag = "Fullbright",
    Callback = function(Value)
        if Value then
            notify("Enabled", "Fullbright activated")
            
            _G.originalAmbient = game.Lighting.Ambient
            _G.originalBrightness = game.Lighting.Brightness
            _G.originalClockTime = game.Lighting.ClockTime
            _G.originalFogEnd = game.Lighting.FogEnd
            
            game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            game.Lighting.Brightness = 2
            game.Lighting.ClockTime = 14
            game.Lighting.FogEnd = 100000
            
            for _, v in pairs(game.Lighting:GetDescendants()) do
                if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") then
                    v.Enabled = false
                end
            end
        else
            notify("Disabled", "Fullbright deactivated")
            
            if _G.originalAmbient and _G.originalBrightness and _G.originalClockTime and _G.originalFogEnd then
                game.Lighting.Ambient = _G.originalAmbient
                game.Lighting.Brightness = _G.originalBrightness
                game.Lighting.ClockTime = _G.originalClockTime
                game.Lighting.FogEnd = _G.originalFogEnd
            end
            
            for _, v in pairs(game.Lighting:GetDescendants()) do
                if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") then
                    v.Enabled = true
                end
            end
        end
    end,
})

local antiAfkToggle = MiscTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(Value)
        if Value then
            notify("Enabled", "Anti-AFK activated")
            
            _G.antiAfkConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
                local VirtualUser = game:GetService("VirtualUser")
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
                notify("Anti-AFK", "Prevented AFK kick")
            end)
        else
            notify("Disabled", "Anti-AFK deactivated")
            if _G.antiAfkConnection then
                _G.antiAfkConnection:Disconnect()
                _G.antiAfkConnection = nil
            end
        end
    end,
})

local fpsBoostToggle = MiscTab:CreateToggle({
    Name = "FPS Boost",
    CurrentValue = false,
    Flag = "FPSBoost",
    Callback = function(Value)
        if Value then
            notify("Enabled", "FPS Boost activated")
            
            -- Disable unnecessary rendering
            settings().Rendering.QualityLevel = 1
            
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
                    v.Material = Enum.Material.Plastic
                    v.Reflectance = 0
                elseif v:IsA("Decal") then
                    v.Transparency = 1
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Lifetime = NumberRange.new(0)
                elseif v:IsA("Explosion") then
                    v.BlastPressure = 1
                    v.BlastRadius = 1
                end
            end
            
            -- Disable post-processing effects
            for _, v in pairs(game.Lighting:GetDescendants()) do
                if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                    v.Enabled = false
                end
            end
            
            -- Set other properties
            game.Lighting.GlobalShadows = false
            game.Lighting.FogEnd = 9e9
            
            -- Disable other effects
            settings().Rendering.QualityLevel = 1
        else
            notify("Disabled", "FPS Boost deactivated")
            
            -- Reset rendering settings
            settings().Rendering.QualityLevel = 7
            game.Lighting.GlobalShadows = true
            
            -- Note: We don't restore all effects as it would be too complex
            notify("Note", "Some visual settings may need to be manually restored")
        end
    end,
})

-- Admin Commands Tab
local AdminTab = Window:CreateTab("Admin", 4483362458)
local AdminSection = AdminTab:CreateSection("Admin Commands")

local commandPromptInput = AdminTab:CreateInput({
    Name = "Command Prompt",
    PlaceholderText = "Enter command here...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        notify("Command", "Executing: " .. Text)
        
        local args = {}
        for arg in string.gmatch(Text, "%S+") do
            table.insert(args, arg)
        end
        
        local command = args[1]:lower()
        table.remove(args, 1)
        
        if command == "kill" then
            local targetName = args[1] or ""
            local targetPlayer = game.Players:FindFirstChild(targetName)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
                targetPlayer.Character.Humanoid.Health = 0
                notify("Command", "Killed " .. targetPlayer.Name)
            else
                notify("Error", "Player not found")
            end
        elseif command == "bring" then
            local targetName = args[1] or ""
            local targetPlayer = game.Players:FindFirstChild(targetName)
            
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and character and rootPart then
                targetPlayer.Character.HumanoidRootPart.CFrame = rootPart.CFrame * CFrame.new(0, 0, -5)
                notify("Command", "Brought " .. targetPlayer.Name)
            else
                notify("Error", "Player not found")
            end
        elseif command == "goto" or command == "tp" then
            local targetName = args[1] or ""
            local targetPlayer = game.Players:FindFirstChild(targetName)
            
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and character and rootPart then
                rootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                notify("Command", "Teleported to " .. targetPlayer.Name)
            else
                notify("Error", "Player not found")
            end
        elseif command == "speed" or command == "walkspeed" then
            local speed = tonumber(args[1]) or 16
            
            if character and humanoid then
                humanoid.WalkSpeed = speed
                notify("Command", "Set speed to " .. speed)
            else
                notify("Error", "Character not found")
            end
        elseif command == "jump" or command == "jumppower" then
            local power = tonumber(args[1]) or 50
            
            if character and humanoid then
                humanoid.JumpPower = power
                notify("Command", "Set jump power to " .. power)
            else
                notify("Error", "Character not found")
            end
        elseif command == "fly" then
            local flySpeed = tonumber(args[1]) or 2
            
            if _G.flyEnabled then
                notify("Command", "Fly disabled")
                _G.flyEnabled = false
                
                if _G.flyConnection then
                    _G.flyConnection:Disconnect()
                    _G.flyConnection = nil
                end
                
                for _, v in pairs(rootPart:GetChildren()) do
                    if v:IsA("BodyVelocity") then
                        v:Destroy()
                    end
                end
            else
                notify("Command", "Fly enabled with speed " .. flySpeed)
                _G.flyEnabled = true
                
                local flyBv = Instance.new("BodyVelocity")
                flyBv.Velocity = Vector3.new(0, 0, 0)
                flyBv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                flyBv.Parent = rootPart
                
                _G.flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
                    local camera = workspace.CurrentCamera
                    
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                        flyBv.Velocity = camera.CFrame.LookVector * (flySpeed * 50)
                    elseif game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                        flyBv.Velocity = camera.CFrame.LookVector * (-flySpeed * 50)
                    elseif game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                        flyBv.Velocity = camera.CFrame.RightVector * (-flySpeed * 50)
                    elseif game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                        flyBv.Velocity = camera.CFrame.RightVector * (flySpeed * 50)
                    elseif game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                        flyBv.Velocity = Vector3.new(0, flySpeed * 50, 0)
                    elseif game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then
                        flyBv.Velocity = Vector3.new(0, -flySpeed * 50, 0)
                    else
                        flyBv.Velocity = Vector3.new(0, 0, 0)
                    end
                end)
            end
        elseif command == "noclip" then
            if _G.noclipEnabled then
                notify("Command", "Noclip disabled")
                _G.noclipEnabled = false
                
                if _G.noclipConnection then
                    _G.noclipConnection:Disconnect()
                    _G.noclipConnection = nil
                end
            else
                notify("Command", "Noclip enabled")
                _G.noclipEnabled = true
                
                _G.noclipConnection = game:GetService("RunService").Stepped:Connect(function()
                    if character then
                        for _, part in pairs(character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end)
            end
        elseif command == "god" or command == "godmode" then
            if _G.godModeEnabled then
                notify("Command", "God mode disabled")
                _G.godModeEnabled = false
                
                if _G.godModeConnection then
                    _G.godModeConnection:Disconnect()
                    _G.godModeConnection = nil
                end
                
                if character and humanoid then
                    humanoid.MaxHealth = 100
                    humanoid.Health = 100
                end
            else
                notify("Command", "God mode enabled")
                _G.godModeEnabled = true
                
                _G.godModeConnection = game:GetService("RunService").Stepped:Connect(function()
                    if character and humanoid then
                        humanoid.MaxHealth = math.huge
                        humanoid.Health = math.huge
                    end
                end)
            end
        elseif command == "reset" or command == "respawn" then
            if character and humanoid then
                humanoid.Health = 0
                notify("Command", "Character reset")
            else
                notify("Error", "Character not found")
            end
        elseif command == "esp" then
            if _G.espCommandEnabled then
                notify("Command", "ESP disabled")
                _G.espCommandEnabled = false
                
                -- Remove ESP
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p.Character then
                        for _, v in pairs(p.Character:GetChildren()) do
                            if v.Name == "ESPBox" or v.Name == "ESPName" then
                                v:Destroy()
                            end
                        end
                    end
                end
                
                if _G.espCommandConnection then
                    _G.espCommandConnection:Disconnect()
                    _G.espCommandConnection = nil
                end
            else
                notify("Command", "ESP enabled")
                _G.espCommandEnabled = true
                
                -- Create ESP
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                        local espBox = Instance.new("BoxHandleAdornment")
                        espBox.Name = "ESPBox"
                        espBox.Adornee = p.Character.HumanoidRootPart
                        espBox.AlwaysOnTop = true
                        espBox.ZIndex = 10
                        espBox.Size = p.Character.HumanoidRootPart.Size * 2
                        espBox.Transparency = 0.7
                        espBox.Color3 = Color3.fromRGB(255, 0, 0)
                        espBox.Parent = p.Character
                        
                        local espName = Instance.new("BillboardGui")
                        espName.Name = "ESPName"
                        espName.Adornee = p.Character.Head
                        espName.AlwaysOnTop = true
                        espName.ExtentsOffset = Vector3.new(0, 2, 0)
                        espName.Size = UDim2.new(0, 100, 0, 30)
                        espName.Parent = p.Character
                        
                        local nameLabel = Instance.new("TextLabel")
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.Position = UDim2.new(0, 0, 0, 0)
                        nameLabel.Size = UDim2.new(1, 0, 1, 0)
                        nameLabel.Font = Enum.Font.GothamBold
                        nameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                        nameLabel.TextStrokeTransparency = 0.5
                        nameLabel.TextSize = 14
                        nameLabel.Text = p.Name
                        nameLabel.Parent = espName
                    end
                end
                
                _G.espCommandConnection = game:GetService("RunService").RenderStepped:Connect(function()
                    for _, p in pairs(game.Players:GetPlayers()) do
                        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                            if not p.Character:FindFirstChild("ESPBox") then
                                local espBox = Instance.new("BoxHandleAdornment")
                                espBox.Name = "ESPBox"
                                espBox.Adornee = p.Character.HumanoidRootPart
                                espBox.AlwaysOnTop = true
                                espBox.ZIndex = 10
                                espBox.Size = p.Character.HumanoidRootPart.Size * 2
                                espBox.Transparency = 0.7
                                espBox.Color3 = Color3.fromRGB(255, 0, 0)
                                espBox.Parent = p.Character
                                
                                local espName = Instance.new("BillboardGui")
                                espName.Name = "ESPName"
                                espName.Adornee = p.Character.Head
                                espName.AlwaysOnTop = true
                                espName.ExtentsOffset = Vector3.new(0, 2, 0)
                                espName.Size = UDim2.new(0, 100, 0, 30)
                                espName.Parent = p.Character
                                
                                local nameLabel = Instance.new("TextLabel")
                                nameLabel.BackgroundTransparency = 1
                                nameLabel.Position = UDim2.new(0, 0, 0, 0)
                                nameLabel.Size = UDim2.new(1, 0, 1, 0)
                                nameLabel.Font = Enum.Font.GothamBold
                                nameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                                nameLabel.TextStrokeTransparency = 0.5
                                nameLabel.TextSize = 14
                                nameLabel.Text = p.Name
                                nameLabel.Parent = espName
                            end
                        end
                    end
                end)
            end
        elseif command == "help" then
            notify("Command Help", "Available commands: kill, bring, goto/tp, speed/walkspeed, jump/jumppower, fly, noclip, god/godmode, reset/respawn, esp, help")
        else
            notify("Error", "Unknown command: " .. command)
        end
    end,
})

local commandHelpButton = AdminTab:CreateButton({
    Name = "Show Command Help",
    Callback = function()
        notify("Command Help", "Available commands:")
        task.wait(1)
        notify("Basic Commands", "kill [player], bring [player], goto/tp [player]")
        task.wait(1)
        notify("Movement Commands", "speed/walkspeed [value], jump/jumppower [value], fly [speed], noclip")
        task.wait(1)
        notify("Other Commands", "god/godmode, reset/respawn, esp, help")
    end,
})

-- Weapons Tab
local WeaponsTab = Window:CreateTab("Weapons", 4483362458)
local WeaponsSection = WeaponsTab:CreateSection("Weapon Modifications")

local infiniteAmmoToggle = WeaponsTab:CreateToggle({
    Name = "Infinite Ammo/No Reload",
    CurrentValue = false,
    Flag = "WeaponInfiniteAmmo",
    Callback = function(Value)
        if Value then
            notify("Enabled", "Infinite Ammo activated")
            
            -- Hook into weapon systems (generic approach)
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" then
                    if rawget(v, "Ammo") then
                        v.Ammo = math.huge
                    end
                    if rawget(v, "MaxAmmo") then
                        v.MaxAmmo = math.huge
                    end
                    if rawget(v, "StoredAmmo") then
                        v.StoredAmmo = math.huge
                    end
                    if rawget(v, "ReloadTime") then
                        v.ReloadTime = 0
                    end
                end
            end
        else
            notify("Disabled", "Infinite Ammo deactivated")
            -- Would need game-specific reset logic
        end
    end,
})

local rapidFireToggle = WeaponsTab:CreateToggle({
    Name = "Rapid Fire",
    CurrentValue = false,
    Flag = "RapidFire",
    Callback = function(Value)
        if Value then
            notify("Enabled", "Rapid Fire activated")
            
            -- Hook into weapon systems (generic approach)
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" then
                    if rawget(v, "FireRate") then
                        v.FireRate = 0.05
                    end
                    if rawget(v, "FireDelay") then
                        v.FireDelay = 0.05
                    end
                    if rawget(v, "ReloadTime") then
                        v.ReloadTime = 0.05
                    end
                    if rawget(v, "Cooldown") then
                        v.Cooldown = 0.05
                    end
                end
            end
        else
            notify("Disabled", "Rapid Fire deactivated")
            -- Would need game-specific reset logic
        end
    end,
})

local noSpreadToggle = WeaponsTab:CreateToggle({
    Name = "No Spread/Perfect Accuracy",
    CurrentValue = false,
    Flag = "NoSpread",
    Callback = function(Value)
        if Value then
            notify("Enabled", "No Spread activated")
            
            -- Hook into weapon systems (generic approach)
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" then
                    if rawget(v, "Spread") then
                        v.Spread = 0
                    end
                    if rawget(v, "MaxSpread") then
                        v.MaxSpread = 0
                    end
                    if rawget(v, "MinSpread") then
                        v.MinSpread = 0
                    end
                    if rawget(v, "Accuracy") then
                        v.Accuracy = 100
                    end
                end
            end
        else
            notify("Disabled", "No Spread deactivated")
            -- Would need game-specific reset logic
        end
    end,
})

local noRecoilToggle = WeaponsTab:CreateToggle({
    Name = "No Recoil",
    CurrentValue = false,
    Flag = "NoRecoil",
    Callback = function(Value)
        if Value then
            notify("Enabled", "No Recoil activated")
            
            -- Hook into weapon systems (generic approach)
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" then
                    if rawget(v, "Recoil") then
                        v.Recoil = 0
                    end
                    if rawget(v, "RecoilX") then
                        v.RecoilX = 0
                    end
                    if rawget(v, "RecoilY") then
                        v.RecoilY = 0
                    end
                    if rawget(v, "RecoilZ") then
                        v.RecoilZ = 0
                    end
                end
            end
        else
            notify("Disabled", "No Recoil deactivated")
            -- Would need game-specific reset logic
        end
    end,
})

local damageMultiplierSlider = WeaponsTab:CreateSlider({
    Name = "Damage Multiplier",
    Range = {1, 100},
    Increment = 1,
    Suffix = "x",
    CurrentValue = 1,
    Flag = "WeaponDamageMultiplier",
    Callback = function(Value)
        -- Hook into weapon systems (generic approach)
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" then
                if rawget(v, "Damage") then
                    v.Damage = v.Damage * Value
                end
                if rawget(v, "BaseDamage") then
                    v.BaseDamage = v.BaseDamage * Value
                end
            end
        end})
        
        notify("Updated", "Damage Multiplier set to " .. Value .. "x")
    end,
})

local fireRateSlider = WeaponsTab:CreateSlider({
    Name = "Fire Rate Multiplier",
    Range = {1, 10},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = 1,
    Flag = "FireRateMultiplier",
    Callback = function(Value)
        -- Hook into weapon systems (generic approach)
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" then
                if rawget(v, "FireRate") then
                    v.FireRate = v.FireRate / Value
                end
            end
        end
        
        notify("Updated", "Fire Rate Multiplier set to " .. Value .. "x")
    end,
})

local rangeMultiplierSlider = WeaponsTab:CreateSlider({
    Name = "Range Multiplier",
    Range = {1, 10},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = 1,
    Flag = "RangeMultiplier",
    Callback = function(Value)
        -- Hook into weapon systems (generic approach)
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" then
                if rawget(v, "Range") then
                    v.Range = v.Range * Value
                end
                if rawget(v, "MaxRange") then
                    v.MaxRange = v.MaxRange * Value
                end
            end
        end
        
        notify("Updated", "Range Multiplier set to " .. Value .. "x")
    end,
})

-- Settings Tab
local SettingsTab = Window:CreateTab("Settings", 4483362458)
local SettingsSection = SettingsTab:CreateSection("Menu Settings")

local themeDropdown = SettingsTab:CreateDropdown({
    Name = "Menu Theme",
    Options = {"Default", "Light", "Dark", "Midnight", "Sentinel", "Synapse"},
    CurrentOption = "Midnight",
    Flag = "MenuTheme",
    Callback = function(Option)
        Rayfield:ChangeTheme(Option)
    end,
})

local keybindInput = SettingsTab:CreateInput({
    Name = "Toggle Menu Keybind",
    PlaceholderText = "Enter key (e.g. RightControl)",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local success, result = pcall(function()
            return Enum.KeyCode[Text]
        end)
        
        if success and result then
            Rayfield.Bind = result
            notify("Keybind Updated", "Menu toggle keybind set to " .. Text)
        else
            notify("Error", "Invalid key name. Try keys like RightControl, RightAlt, etc.")
        end
    end,
})

local creditsButton = SettingsTab:CreateButton({
    Name = "Credits",
    Callback = function()
        notify("Credits", "Ultimate Mod Menu created by ModMaster")
        task.wait(1)
        notify("Credits", "UI Library: Rayfield Interface Suite")
        task.wait(1)
        notify("Credits", "Thanks for using the Ultimate Mod Menu!")
    end,
})

local resetButton = SettingsTab:CreateButton({
    Name = "Reset All Settings",
    Callback = function()
        Rayfield:Destroy()
        
        -- Clear all connections and loops
        for _, connection in pairs({
            _G.healthRegenLoop,
            _G.healOnKillConnection,
            _G.superJumpConnection,
            _G.flyConnection,
            _G.noClipLoop,
            _G.bunnyHopLoop,
            _G.blinkConnection,
            _G.aimbotLoop,
            _G.headshotAimbotLoop,
            _G.espUpdateLoop,
            _G.godModeLoop,
            _G.noFallDamageConnection,
            _G.noCollisionLoop,
            _G.terrainModificationConnection,
            _G.antiAfkConnection,
            _G.noclipConnection,
            _G.godModeConnection,
            _G.espCommandConnection
        }) do
            if connection then
                connection:Disconnect()
            end
        end
        
        -- Reset global variables
        _G.wallAimbot = false
        _G.espEnabled = false
        _G.terrainModification = false
        _G.flyEnabled = false
        _G.noclipEnabled = false
        _G.godModeEnabled = false
        _G.espCommandEnabled = false
        
        -- Reset character
        if character and humanoid then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
            humanoid.Health = 100
            humanoid.MaxHealth = 100
            
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 0
                    part.CanCollide = true
                    part.Massless = false
                end
            end
        end
        
        -- Reset workspace
        workspace.Gravity = 196.2
        
        -- Reset lighting
        if _G.originalAmbient and _G.originalBrightness and _G.originalClockTime and _G.originalFogEnd then
            game.Lighting.Ambient = _G.originalAmbient
            game.Lighting.Brightness = _G.originalBrightness
            game.Lighting.ClockTime = _G.originalClockTime
            game.Lighting.FogEnd = _G.originalFogEnd
        end
        
        -- Notify user
        notify("Reset", "All settings have been reset to default")
        
        -- Reload the script
        loadstring(game:HttpGet('https://raw.githubusercontent.com/YourUsername/UltimateModMenu/main/ModMenu.lua'))()
    end,
})

-- Initialize the menu
notify("Loaded", "Ultimate Mod Menu has been loaded!")
notify("Usage", "Press RightControl to toggle the menu")

-- Setup menu toggle keybind
Rayfield.Bind = Enum.KeyCode.RightControl

-- Auto-save configuration
game:GetService("Players").PlayerRemoving:Connect(function(plr)
    if plr == player then
        Rayfield:SaveConfiguration()
    end
end)

-- Load saved configuration
Rayfield:LoadConfiguration()
