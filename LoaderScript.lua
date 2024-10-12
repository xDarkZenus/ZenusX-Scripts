if not Config or Config == nil then
    Config = {
        ["Team"] = "Pirates",
        ["Settings"] = {
            ["Auto Awakening Race"] = true,
            ["Bounty Locked"] = {
                ["Value"] = 3000000,
                ["Enalbed"] = true,
            },
            ["Panic Mode"] = {true, 3000, 4000},
            ["Skip Race V4"] = true,
            ["Fruit Skip"] = {
                "Portal-Portal",
                "Leopard-Leopard",
                "Kitsune-Kitsune",
                "Chop-Chop",
                "Nigger-Nigger"
            },
            ["Camera Mode"] = {
                ["Specated"] = false,
                ["Lock"] = true
            },
            ["Ultra Gun Gay Mode"] = {
                ["Enalbed Click Gun"] = true, -- Beta
                ["Enemy Health"] = 2000
            },
        },
        ["Weapon"] = {
            ["Melee"] = {
                ["Enable"] = true,
                ["Z"] = {
                    ["Enable"] = true,
                    ["Hold"] = 0
                },
                ["X"] = {
                    ["Enable"] = true,
                    ["Hold"] = 0
                },
                ["C"] = {
                    ["Enable"] = true,
                    ["Hold"] = 0
                },
            },
            ["Sword"] = {
                ["Enable"] = true,
                ["Z"] = {
                    ["Enable"] = true,
                    ["Hold"] = 0
                },
                ["X"] = {
                    ["Enable"] = true,
                    ["Hold"] = 0
                },
            },
            ["Gun"] = {
                ["Enable"] = false,
                ["Z"] = {
                    ["Enable"] = true,
                    ["Hold"] = 0
                },
                ["X"] = {
                    ["Enable"] = true,
                    ["Hold"] = 0
                },
            },
            ["Blox Fruit"] = {
                ["Enable"] = true,
                ["Z"] = {
                    ["Enable"] = true,
                    ["Hold"] = 0
                },
                ["X"] = {
                    ["Enable"] = false,
                    ["Hold"] = 0
                },
                ["C"] = {
                    ["Enable"] = false,
                    ["Hold"] = 0
                },
                ["V"] = {
                    ["Enable"] = false,
                    ["Hold"] = 0
                },
                ["F"] = {
                    ["Enable"] = false,
                    ["Hold"] = 0
                },
            },
        },
    }
end

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players
repeat task.wait() until game.Players.LocalPlayer

repeat wait() -- muahahahahahahah
    pcall(function() 
        for i, v in pairs(getconnections(game.Players.LocalPlayer.PlayerGui.Main.ChooseTeam.Container[Config["Team"]].Frame.TextButton.Activated)) do
            v.Function()
        end 
    end) 
until tostring(game.Players.LocalPlayer.Team) == Config.Team

local plr = game.Players.LocalPlayer
NPCBypass = {}
for i, v in pairs(game.Workspace.NPCs:GetChildren()) do 
    if string.find(string.lower(v.Name), "home point") then
        table.insert(NPCBypass, v:GetModelCFrame())
    end
end
for i, v in pairs(getnilinstances()) do 
    if string.find(string.lower(v.Name), "home point") then
        table.insert(NPCBypass, v:GetModelCFrame())
    end
end

function GetWeaponType(cc)
    for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") and v.ToolTip == cc then
            return v.Name
        end
    end
    for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if v:IsA("Tool") and v.ToolTip == cc then
            return v.Name
        end
    end
end

ToolName = ""
function EquipTool(toolname)
    for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") and tostring(v) == toolname or v.ToolTip == toolname then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
            ToolName = tostring(v)
        end
    end
end

function GetSkillsByWeapon()
    v2 = game.Players.LocalPlayer.PlayerGui.Main.Skills
    for _, v in next, Config.Weapon do
        if v.Enable then
            ToolName = GetWeaponType(_)
            for i1, v1 in next, v do
                if i1 == "Enable" then
                else
                    v175 = not ToolName or not v2:FindFirstChild(ToolName) or v2:FindFirstChild(ToolName)[i1].Cooldown.AbsoluteSize.X < 5  
                    if v175 and v1.Enable then
                        return {_, i1, v1}
                    end
                end
            end
        end
    end
end

function SendKey(nah, ilose)
    pcall(function()
        set_thread_identity(8) 
        game:service("VirtualInputManager"):SendKeyEvent(true, nah, false, game)
        task.wait(ilose)
        game:service("VirtualInputManager"):SendKeyEvent(false, nah, false, game)
    end)
end

enemytable = {}
function GetEnemy()
    cucac = {}
    for _, v in next, game.Players:GetPlayers() do
        if v.Name ~= game.Players.LocalPlayer.Name and v.Character and v.Parent then
            if v.Character.Humanoid.Health > 0 and v.Character:FindFirstChild("HumanoidRootPart") then
                for a, b in next, Config["Settings"]["Fruit Skip"] do
                    if v.Data.DevilFruit.Value ~= b then
                        if v.Character.Humanoid.Sit == false and v.Data.Race.Value ~= "Mink" and v.Data.Race.Value ~= "Cyborg" then
                            if not table.find(cucac, v) and not table.find(enemytable, v) then
                                table.insert(cucac, v)
                            end
                        end
                    end
                end
            end    
        end
    end
    return cucac
end
Hop = false
function FindNewEnemy()
    dist, targetselected = math.huge, nil
    for _, v in next, GetEnemy() do
        if v.Character and v.Parent and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid").Health > 0 and v.Character:FindFirstChild("HumanoidRootPart") then
            for i, a in next, NPCBypass do
                if v:DistanceFromCharacter(a.p) <= 2500 then
                    if (v.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude < dist then
                        targetselected = v
                        dist = (v.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                    end
                end
            end
        end
    end
    if targetselected ~= nil then
        enemy = targetselected
        table.insert(enemytable, targetselected)
    else
        Hop = true
    end
end

spawn(function()
    local gg = getrawmetatable(game)
    local old = gg.__namecall
    setreadonly(gg, false)
    gg.__namecall = newcclosure(function(...)
        local method = getnamecallmethod()
        local args = {...}
        if tostring(method) == "FireServer" then
            if tostring(args[1]) == "RemoteEvent" then
                if tostring(args[2]) ~= "true" and tostring(args[2]) ~= "false" then
                    if enemy and enemy and enemy.Character.HumanoidRootPart then
                        args[2] = enemy.Character.HumanoidRootPart.Position
                        return old(unpack(args))
                    end
                end
            end
        end
        return old(...)
    end)
end)

function CheckNofify(terubedai)
    for r, v in pairs(plr.PlayerGui.Notifications:GetChildren()) do
        if v and v.Text and string.find(string.lower(v.Text), terubedai) then
            return true
        end
    end
    return false
end

function BigHitbox() 
    pcall(function()
       local old = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework)
       local com = getupvalue(old, 2)
       com.activeController.hitboxMagnitude = 6000
   end) 
end

function NoStun() 
    for _, v in game.Players.LocalPlayer.Character.HumanoidRootPart:GetChildren() do 
        if v.Name == "BodyGyro" or v.Name == "BodyPosition" then 
            v:Destroy() 
        end 
    end 
end 

function GetPortal(nig)
    ccp = nig.Position
    min = math.huge
    min2 = math.huge
    if game.PlaceId == 7449423635 then
        TableLocations = {
            ["Caslte On The Sea"] = Vector3.new(-5058.77490234375, 314.5155029296875, -3155.88330078125),
            ["Hydra"] = Vector3.new(5756.83740234375, 610.4240112304688, -253.9253692626953),
            ["Mansion"] = Vector3.new(-12463.8740234375, 374.9144592285156, -7523.77392578125),
            ["Great Tree"] = Vector3.new(28282.5703125, 14896.8505859375, 105.1042709350586),
            ["Hydra 1"] = Vector3.new(-11993.580078125, 334.7812805175781, -8844.1826171875),
            ["Hydra 2"] = Vector3.new(5314.58203125, 25.419387817382812, -125.94227600097656)
        }
    elseif game.PlaceId == 4442272183 then
        TableLocations = {
            ["Mansion"] = Vector3.new(-288.46246337890625, 306.130615234375, 597.9988403320312),
            ["Flamingo"] = Vector3.new(2284.912109375, 15.152046203613281, 905.48291015625),
            ["Out Ship"] = Vector3.new(923.21252441406, 126.9760055542, 32852.83203125),
            ["In Ship"] = Vector3.new(-6508.5581054688, 89.034996032715, -132.83953857422)
        }
    elseif game.PlaceId == 2753915549 then
        TableLocations = {
            ["Sky 3"] = Vector3.new(-7894.6201171875, 5545.49169921875, -380.2467346191406),
            ["Sky 2"] = Vector3.new(-4607.82275390625, 872.5422973632812, -1667.556884765625),
            ["In WaterCity"] = Vector3.new(61163.8515625, 11.759522438049316, 1819.7841796875),
            ["Out WaterCity"] = Vector3.new(3876.280517578125, 35.10614013671875, -1939.3201904296875)
        }
    end
    TableLocations2 = {}
    for r, v in pairs(TableLocations) do
        TableLocations2[r] = (v - ccp).Magnitude
    end
    for r, v in pairs(TableLocations2) do
        if v < min then
            min = v
            min2 = v
        end
    end
    for r, v in pairs(TableLocations2) do
        if v < min then
            min = v
            min2 = v
        end
    end
    for r, v in pairs(TableLocations2) do
        if v <= min then
            choose = TableLocations[r]
        end
    end
    min3 = (ccp - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if min2 <= min3 then
        return choose
    end
end

function GetBypassCFrame(pos)
    pos = Vector3.new(pos.X, pos.Y, pos.Z)
    local lll, mmm = nil, math.huge
    for i, v in pairs(NPCBypass) do
        if (v.p - pos).Magnitude < mmm then
            lll = v
            mmm = (v.p - pos).Magnitude
        end
    end
    return lll
end

local plr = game.Players.LocalPlayer
function CheckInComBat()
    return plr.PlayerGui.Main.InCombat.Visible and plr.PlayerGui.Main.InCombat.Text and (string.find(string.lower(plr.PlayerGui.Main.InCombat.Text),"risk"))
end 

function bypass(Pos)
    if canthop == true then return end
    wait(.5)
    pcall(function()
        repeat
            task.wait()
            tween:Cancel()
            game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid"):ChangeState(15)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = GetBypassCFrame(Pos)
        until game.Players.LocalPlayer.Character.PrimaryPart.CFrame == GetBypassCFrame(Pos) or canthop == true
        game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid", 9):ChangeState(15)
        game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(GetBypassCFrame(Pos))
        wait(0.1)
        game.Players.LocalPlayer.Character.Head:Destroy()
        repeat
            task.wait()
        until game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Health <= 0
        repeat
            task.wait()
        until game.Players.LocalPlayer.Character:FindFirstChild("Head")
        wait(0.5)
    end)
end

canthop = false

function to(TargetCFrame)
    local dit = (TargetCFrame.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    local tweenservice = game:GetService("TweenService")
    local inf = TweenInfo.new(dit / 185, Enum.EasingStyle.Linear)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X, TargetCFrame.Y, game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z)
    if not plr.Character:FindFirstChild("Nigger") then
        local Part = Instance.new("Part", plr.Character)
        Part.Name = "Nigger"
        Part.CanCollide = false
        Part.Transparency = 1
        Part.Size = Vector3.new(10, 1, 10)
        Part.Anchored = true
        Part:GetPropertyChangedSignal("CFrame"):Connect(function()
            task.wait(0.01)
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = Part.CFrame * CFrame.new(0, 2, 0)
        end)
    end
    tween = tweenservice:Create(plr.Character.Nigger, inf ,{CFrame = TargetCFrame})
    if not game.Players.LocalPlayer.Character.Head:FindFirstChild("cac") then
        local buu = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character.Head)
        buu.Velocity = Vector3.new(0, 0, 0)
        buu.P = 1500
        buu.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        buu.Name = "cac"
    end
    for i, v in pairs(plr.Character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
    if plr.Character.Humanoid.Sit == true then
        plr.Character.Humanoid.Sit = false
    end
    if dist >= 2500 and GetPortal(TargetCFrame) then
        args = {"requestEntrance", GetPortal(TargetCFrame)}
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
        task.wait(.5)
    end
    if dist > 2500 and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - GetBypassCFrame(TargetCFrame).Position).Magnitude > 2500 and not CheckInComBat() and canthop == false then
        return bypass(TargetCFrame)
    end
    tween:Play()
end 

spawn(function()
    while wait() do
        while wait() do
            if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid") and game:GetService("Players").LocalPlayer.Character.Humanoid.Health <= 0 or (plr.Character.Nigger.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude >= 200 then
                plr.Character.Nigger.CFrame = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame
            end
        end
    end
end)

function HopSivi() 
    function bQ(v)
        if v.Name == "ErrorPrompt" then
            if v.Visible then
                if v.TitleFrame.ErrorTitle.Text == "Teleport Failed" then
                    v.Visible = false
                end
            end
            v:GetPropertyChangedSignal("Visible"):Connect(function()
                if v.Visible then
                    if v.TitleFrame.ErrorTitle.Text == "Teleport Failed" then
                        v.Visible = false
                    end
                end
            end)
        end
    end
    for i, v in game.CoreGui.RobloxPromptGui.promptOverlay:GetChildren() do
        bQ(v) 
    end
    game.CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(bQ)
    
    while wait() do
    canthop = true
        to(CFrame.new(0, math.random(9999, 99999), 0))
        if not CheckInComBat() then
            plr.PlayerGui.ServerBrowser.Frame.Filters.SearchRegion.TextBox.Text = "Singapore"
            for r = 1, math.huge do
                for k, v in game.ReplicatedStorage.__ServerBrowser:InvokeServer(r) do
                    if k ~= game.JobId and v["Count"] <= 10 then
                        game.ReplicatedStorage.__ServerBrowser:InvokeServer("teleport", k)
                    end
                end
            end
        end
    end
end

function FireRemotes(number, ...)
    arg = ({"CommF_", "Redeem"})[number]
    return game:GetService("ReplicatedStorage").Remotes[arg]:InvokeServer(unpack({...}))
end

function GaySec()
    pcall(function()
        while task.wait() do
            if Hop == true then
                HopSivi()
            else
                if plr:FindFirstChild("PlayerGui") and plr.PlayerGui:FindFirstChild("ScreenGui") and plr.PlayerGui.ScreenGui:FindFirstChild("ImageLabel") then
                else
                    game:service("VirtualUser"):CaptureController()
                    game:service("VirtualUser"):SetKeyDown("0x65")
                    game:service("VirtualUser"):SetKeyUp("0x65")
                    wait(.3)
                end 
                BigHitbox()
                NoStun()
                plr.Character:SetAttribute("DashLength", 100)
                if not enemy or not enemy.Parent or enemy.Character.Humanoid.Health <= 0 or not enemy.Character.Head then
                    FindNewEnemy()
                end
                if Config["Settings"]["Camera Mode"]["Specated"] then 
                    workspace.CurrentCamera.CameraSubject = enemy.Character 
                else 
                    workspace.CurrentCamera.CameraSubject = plr.Character 
                end 
                if plr.PlayerGui.Main.BottomHUDList.SafeZone.Visible and enemy:DistanceFromCharacter(plr.Character.Head.Position) <= 100 then
                    FindNewEnemy()
                end
                if Config["Settings"]["Camera Mode"]["Lock"] == true then
                    game.Workspace.CurrentCamera.CFrame = CFrame.new(game.Workspace.CurrentCamera.CFrame.Position, enemy.Character.HumanoidRootPart.Position)
                end
                if plr.PlayerGui.Main.PvpDisabled.Visible then
                    FireRemotes(1, "EnablePvp")
                end 
                if plr.Character.Humanoid.Health < Config["Settings"]["Panic Mode"][2] and plr.Character.Humanoid.Health < Config["Settings"]["Panic Mode"][3] and Config["Settings"]["Panic Mode"][1] then
                    to(enemy.Character.HumanoidRootPart.CFrame * CFrame.new(math.random(9999, 99999), math.random(9999, 99999), math.random(9999, 99999)))
                elseif ((plr.Character.Humanoid.Health > Config["Settings"]["Panic Mode"][2] and plr.Character.Humanoid.Health > Config["Settings"]["Panic Mode"][3] and Config["Settings"]["Panic Mode"][1]) or (not Config["Settings"]["Panic Mode"][1])) then 
                    if (enemy.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude > 300 then
                        to(enemy.Character.HumanoidRootPart.CFrame * CFrame.new(0, 25, 0))
                    else
                        if GetSkillsByWeapon() then
                            local concac = GetSkillsByWeapon()
                            EquipTool(concac[1])
                            SendKey(concac[2], concac[2][4])
                            to(enemy.Character.HumanoidRootPart.CFrame * CFrame.new(7, 12, 4))
                        else
                            if enemy.Character.Humanoid.Health >= 3000 then
                                game:GetService("VirtualUser"):CaptureController()
                                game:GetService("VirtualUser"):Button1Down(Vector2.new(0,1,0,1))
                            end
                            to(enemy.Character.HumanoidRootPart.CFrame * CFrame.new(7, 12, 4))
                        end
                    end
                end
            end
        end
    end)
end
GaySec()
