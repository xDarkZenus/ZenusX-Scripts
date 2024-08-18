getgenv().Config = {
    ["Team"] = "Pirates",
    ["Config"] = {
        ["Auto V4"] = true,
        ["Skip Race V4 Players"] = true
    },
    ["Weapon"] = {
        ["Melee"] = {["Enable"] = true,
            ["Z"] = {["Enable"] = true, ["Hold"] = 1.5},
            ["X"] = {["Enable"] = false, ["Hold"] = 0.0},
            ["C"] = {["Enable"] = false, ["Hold"] = 0.0}
        },
        ["Blox Fruit"] = {["Enable"] = true,
            ["Z"] = {["Enable"] = true, ["Hold"] = 0},
            ["X"] = {["Enable"] = false, ["Hold"] = 0},
            ["C"] = {["Enable"] = false, ["Hold"] = 0},
            ["V"] = {["Enable"] = false, ["Hold"] = 0},
            ["F"] = {["Enable"] = false, ["Hold"] = 0}
        },
        ["Sword"] = {["Enable"] = true,
            ["Z"] = {["Enable"] = true, ["Hold"] = 1.5},
            ["X"] = {["Enable"] = true, ["Hold"] = 0.0}
        },
        ["Gun"] = {["Enable"] = false,
            ["Z"] = {["Enable"] = true, ["Hold"] = 0.1},
            ["X"] = {["Enable"] = true, ["Hold"] = 0.0}
        },
    },
}

repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players
repeat task.wait() until game:GetService("Players").LocalPlayer

for i,v in pairs(game.Workspace:GetChildren()) do
    if v.Name == "Script" then
        v:Destroy()
    end
end

game.Workspace.ChildAdded:Connect(function(child)
    if child.Name == "Script" then
        child:Destroy()
    end
end)
local plr = game.Players.LocalPlayer
if game:GetService("Players").LocalPlayer.PlayerGui.Main:FindFirstChild("ChooseTeam") then
    repeat task.wait()
        if game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("Main").ChooseTeam.Visible == true then
            for i, v in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container[getgenv().Config].Frame.TextButton.Activated)) do
                for a, b in pairs(getconnections(game:GetService("UserInputService").TouchTapInWorld)) do
                    b:Fire() 
                end
                v.Function()
            end 
        end
    until game.Players.LocalPlayer.Team ~= nil and game:IsLoaded()
end

NpcList = {}
for i, v in pairs(game.Workspace.NPCs:GetChildren()) do 
    if string.find(string.lower(v.Name), "home point") then
        table.insert(NpcList, v:GetModelCFrame())
    end
end
for i, v in pairs(getnilinstances()) do 
    if string.find(string.lower(v.Name), "home point") then
        table.insert(NpcList, v:GetModelCFrame())
    end
end

if game.PlaceId == 2753915549 then
    World1 = true
    TableRequestentrance = {
        Vector3.new(-7894.6201171875, 5545.49169921875, -380.246346191406),
        Vector3.new(-4607.82275390625, 872.5422973632812, -1667.556884765625),
        Vector3.new(61163.8515625, 11.759522438049316, 1819.7841796875),
        Vector3.new(3876.280517578125, 35.10614013671875, -1939.3201904296875)
    }
elseif game.PlaceId == 4442272183 then
    World2 = true
    TableRequestentrance = {
        Vector3.new(-288.46246337890625, 306.130615234375, 597.9988403320312),
        Vector3.new(2284.912109375, 15.152046203613281, 905.48291015625),
        Vector3.new(923.21252441406, 126.9760055542, 32852.83203125),
        Vector3.new(-6508.5581054688, 89.034996032715, -132.83953857422)
    }
elseif game.PlaceId == 7449423635 then
    World3 = true
    TableRequestentrance = {
        Vector3.new(-5058.77490234375, 314.5155029296875, -3155.88330078125),
        Vector3.new(5756.83740234375, 610.4240112304688, -253.9253692626953),
        Vector3.new(-12463.8740234375, 374.9144592285156, -7523.77392578125),
        Vector3.new(28282.5703125, 14896.8505859375, 105.1042709350586),
        Vector3.new(-11993.580078125, 334.7812805175781, -8844.1826171875),
        Vector3.new(5314.58203125, 25.419387817382812, -125.94227600097656)
    }
end

function GetPortal(PortalPos)
    local aM, aN = Vector3.new(0, 0 ,0), math.huge
    for r, v in pairs(TableRequestentrance) do
        if (v - PortalPos.Position).Magnitude < aN and aM ~= v then
            aM, aN = v, (v - PortalPos.Position).Magnitude
        end
    end
    return aM
end 

function CheckInComBat()
    return plr.PlayerGui.Main.InCombat.Visible and plr.PlayerGui.Main.InCombat.Text and (string.find(string.lower(plr.PlayerGui.Main.InCombat.Text),"risk"))
end 

function BypassTeleport(Pos)
    repeat
        task.wait()
        if CheckInComBat() then
            return
        end
        plr.Character.HumanoidRootPart.CFrame = Pos
        task.wait(0.1)
        plr.Character.PrimaryPart.CFrame = Pos   
        plr.Character:WaitForChild("Humanoid"):ChangeState(15)
        task.wait(0.5)
    until CheckInComBat() or plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0
end

function GetDistance(cc)
    if typeof(cc) == "CFrame" then
        return (cc.Position - plr.Character.HumanoidRootPart.Position).Magnitude
    elseif typeof(cc) == "Vector3" then
        return (cc - plr.Character.HumanoidRootPart.Position).Magnitude
    end
end

function RequestEntrance(ac)
    game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack({"requestEntrance", ac}))
    task.wait(0.01)
end

function GetBypassPos(cc)
    dis = math.huge
    ci = nil
    for r, v in pairs(NpcList) do
        if (v.Position - cc.Position).Magnitude < dis then
            ci = v
            dist = (v.Position - cc.Position).Magnitude
        end
    end
    return ci
end

function Tweento(TargetCFrame)
    pcall(function()
        local tweenservice = game:GetService("TweenService")
        local Distance = (plr.Character.HumanoidRootPart.Position - TargetCFrame.Position).Magnitude
        local info = TweenInfo.new(Distance / 180, Enum.EasingStyle.Linear)
        tween = tweenservice:Create(plr.Character.HumanoidRootPart, info, {CFrame = TargetCFrame})
        if Distance <= 250 then
            pcall(function()
                tween:Cancel()
            end)
            plr.Character.HumanoidRootPart.CFrame = TargetCFrame
        end
        if GetDistance(GetPortal(TargetCFrame).Position) - GetDistance(TargetCFrame.Position) < GetDistance(TargetCFrame.Position) and GetDistance(TargetCFrame.Position) > 500 then
            return RequestEntrance(GetPortal(TargetCFrame))
        end
        if GetDistance(TargetCFrame.Position) >= 3000 and not CheckInComBat() then
            return BypassTeleport(GetBypassPos(TargetCFrame))
        end
        tween:Play()
    end)
end

spawn(function()
    while task.wait() do
        if tween and tween.PlaybackState == Enum.PlaybackState.Playing then
            NoClip = true
        elseif tween then
            NoClip = false
        end
    end
end)

function equip(tooltip)
    local character = plr.Character or plr.CharacterAdded:Wait()
    for _, item in pairs(plr.Backpack:GetChildren()) do 
        if tostring(item.ToolTip) == "" then 
            item.Parent = character
        end 
        if item:IsA("Tool") and item.ToolTip == tooltip then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and not humanoid:IsDescendantOf(item) then
                if not game.Players.LocalPlayer.Character:FindFirstChild(item.Name) then
                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(item)
                    return item
                end
            end
        end 
    end 
end

ThisTarget = {} 
table.insert(ThisTarget, plr)
function GetTarget()
    playertarget = {}
    for r, v in pairs(game.Players:GetPlayers()) do
        if v and v.Name ~= plr.Name and v.Parent and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 and
        tostring(v.Team) == "Pirates" and v.Data.Level.Value - plr.Data.Level.Value < 300 and not table.find(ThisTarget, v) and not table.find(playertarget, v) and
        (getgenv().Config.Config["Skip Race V4 Players"] and not (v.Backpack:FindFirstChild("Awakening") or v.Character:FindFirstChild("Awakening")) or not getgenv().Config.Config["Skip Race V4 Players"]) then
            table.insert(playertarget, v)
        end
    end
    return playertarget
end

function FindTarget()
    dist = math.huge
    returnenemy = nil
    for r, v in pairs(GetTarget()) do
        if v and v.Parent and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            if GetDistance(v.Character.HumanoidRootPart.Position) < dist then
                returnenemy = v
                dist = GetDistance(v.Character.HumanoidRootPart.Position)
            end
        end
    end
    if returnenemy ~= nil then
        table.insert(ThisTarget, returnenemy)
        target = returnenemy
    else
        print("HOP")
    end
end

function CheckRaidTarget(q0) 
    for a=1,5,1 do 
        local a0 = game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island"..a) 
        if a0 and WaitHRP(q0, a0:GetModelCFrame()) < 3000 then 
            return true 
        end 
    end 
    return false
end 
NotifyList = {}
function checkNotify(msg)
    for r, k in pairs(game.Players.LocalPlayer.PlayerGui.Notifications:GetChildren()) do
        if k and k.Text and string.find(string.lower(k.Text), msg) and not table.find(NotifyList, k) then
            table.insert(NotifyList, k)
            return true
        end
    end
    return false
end
fromtime = 0
function checktarget() 
    if not target then 
        return FindTarget() 
    end 
    if not target.Parent then 
        return FindTarget() 
    end 
    if not target.Character then 
        return FindTarget() 
    end   
    if target.Character.Humanoid.Health <= 0 then
        return FindTarget() 
    end
    if (checkNotify("died") or checkNotify("tử trận") or checkNotify("safe") or checkNotify("an toàn")) and target:DistanceFromCharacter(plr.Character:WaitForChild("Head", 9).Position) <= 15 then
        return FindTarget() 
    end 
    if CheckRaidTarget(target) then
        return FindTarget() 
    end
    if plr.PlayerGui.Main.BottomHUDList.SafeZone.Visible and target:DistanceFromCharacter(plr.Character:WaitForChild("Head", 9).Position) <= 15 then
        return FindTarget()
    end
    if target:DistanceFromCharacter(plr.Character:WaitForChild("Head").Position) < 300 then 
        if os.time() - fromtime > 100 then 
            if not CheckInComBat() then
                return FindTarget()
            end
        end
    else 
        fromtime = os.time() 
    end
    return true
end

function Click()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):Button1Down(Vector2.new(0,1,0,1))
end
function getAvailableSkills(Setting) 
    local V = game.Players.LocalPlayer.PlayerGui.Main.Skills
    local Cache = {}
    for i, v in pairs(plr.Character:GetChildren()) do 
        if v:IsA("Tool") then 
            table.insert(Cache, v)
        end 
    end 
    for i, v in pairs(plr.Backpack:GetChildren()) do 
        if v:IsA("Tool") then 
            table.insert(Cache, v)
        end 
    end 
    for i, v in pairs(Cache) do 
        -- warn(v, v.ToolTip , Setting.Weapon[v.ToolTip]    )
        if v.ToolTip and Setting.Weapon[v.ToolTip] and Setting.Weapon[v.ToolTip].Enable then
            -- warn(1)
            for i2, v2 in pairs(Setting.Weapon[v.ToolTip]) do
                if i2 ~= "Enable" and v2.Enable then 
                    if V:FindFirstChild(v.Name) and V[v.Name]:FindFirstChild(i2) then 
                        local GuiData = V[v.Name][i2]
                        if GuiData.Cooldown.AbsoluteSize.X <= 0 then
                            return {i2, v2, v.ToolTip}
                        end
                    else
                        equip(v.ToolTip)
                    end
                end
            end 
        end 
    end
    return false
end

function down(use, cooldown)
    pcall(function()
        game:GetService("VirtualInputManager"):SendKeyEvent(true,use,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
        task.wait(cooldown)
        game:GetService("VirtualInputManager"):SendKeyEvent(false,use,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
    end)
end

spawn(function()
    while task.wait() do
        if checktarget() then
            if GetDistance(target.Character.HumanoidRootPart.Position) <= 30 then
                local Skills = getAvailableSkills(getgenv().Config)
                if Skills then
                    equip(Skills[3])
                    down(Skills[1], Skills[2]["Hold"])
                end
            end
        end
    end
end)

while task.wait() do
    if checktarget() then
        if target and target.Character and target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health > 4 then
            if game:GetService("Players").LocalPlayer.PlayerGui.Main.PvpDisabled.Visible == true then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
            end
            if (not (game.Players.LocalPlayer.Character:FindFirstChild("HasBuso"))) then
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
            end
            if game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui") and game.Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGui") and game.Players.LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("ImageLabel") then
            else
                game:service("VirtualUser"):CaptureController()
                game:service("VirtualUser"):SetKeyDown("0x65")
                game:service("VirtualUser"):SetKeyUp("0x65")
            end 
            if target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.MoveDirection.Magnitude > 0 then
                Tweento(target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4))
                if (not plr.Character:FindFirstChild("Busy") or not plr.Character.Busy.Value) and not game:GetService("Players").LocalPlayer.PlayerGui.Main.InCombat.Visible then
                    Click()
                end
            else
                Tweento(target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4))
            end
        end
    end
end
