repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players
repeat task.wait() until game:GetService("Players").LocalPlayer
LoadedScript = false

Config = {}
local HttpService = game:GetService("HttpService")
function Save()
    if not isfolder("ZenusX") then
        makefolder("ZenusX")
    end
    writefile("ZenusX\\" .. game:GetService("Players").LocalPlayer.Name .. " \\BloxFruits", HttpService:JSONDecode(Config))
end

function Read()
    if not isfolder("ZenusX") then
        Save()
    else
        HttpService:JSONDecode(readfile("ZenusX\\" .. game:GetService("Players").LocalPlayer.Name .. " \\BloxFruits"))
    end
end
Read()

local plr = game:GetService("Players").LocalPlayer
local Library = loadstring((game:HttpGet"https://raw.githubusercontent.com/xDarkZenus/ZenusX-Scripts/main/Source-Library.lua"))()

local Window = Library:AddWindows({
    Title = "ZenusX",
    Description = "- By xDark"
})

local GeneralTab = Window:AddTab({Name = "General", Icon = "rbxassetid://18977202941"})
local SettingsTab = Window:AddTab({Name = "Settings", Icon = "rbxassetid://18977223800"})

function CheckSea(number)
    if number == 1 then
        if game.PlaceId == 2753915549 then
            return true
        end
    elseif number == 2 then
        if game.PlaceId == 4442272183 then
            return true
        end 
    elseif number == 3 then
        if game.PlaceId == 7449423635 then
            return true
        end 
    end
    return false
end

function GetDistance(cc)
    if typeof(cc) == "CFrame" then
        return (cc.Position - game:GetService("Players").LocalPlayer.HumanoidRootPart.Position).Magnitude
    elseif typeof(cc) == "Vector3" then
        return (cc - game:GetService("Players").LocalPlayer.HumanoidRootPart.Position).Magnitude
    end
end

function Tweento(TargetCFrame)
    local Distance = GetDistance(TargetCFrame.Position)
    local tweenservice = game:GetService("TweenService")
    local info = TweenInfo.new(Distance/ 120, Enum.EasingStyle.Quad)
    local TargetWithY = CFrame.new(TargetCFrame.Position.X, TargetCFrame.Y + 80, TargetCFrame.Position.Z)
    tween = tweenservice:Create(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, info, {CFrame = TargetWithY})
    if Distance <= 250 then
        tween:Cancel()
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = TargetCFrame
    else
        if game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position.Y < TargetCFrame.Position.Y + 80 then
            tween:Cancel()
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position.Z, game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position.Y + 80, game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position.X)
        else
            tween:Play()
        end
    end
end

function GetCakePrinceSkills()
    for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
        if v.Name == "Cake Prince" then
            if game:GetService("Workspace").Enemies:FindFirstChild("Ring") or game:GetService("Workspace").Enemies:FindFirstChild("Fist") then
                if (v.HumanoidRootPart.CFrame.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame.Position).Magnitude <= 400 then
                    return true
                end
            end
        end
    end
    return false
end

function GetWeapon(type)
    for r, v in next, game:GetService("Players").LocalPlayer.Backpack:GetChildren() do
        if v:IsA("Tool") and v.ToolTip == type then
            return v.Name
        end
    end
    for r, v in next, game:GetService("Players").LocalPlayer.Character:GetChildren() do
        if v:IsA("Tool") and v.ToolTip == type then
            return v.Name
        end
    end
end

function EWeapon()
    if Config["Select Tool"] == nil or Config["Select Tool"] == "" then
        Config["Select Tool"] = "Melee"
        WeaponChoose = Config["Select Tool"]
    end
    local WP = GetWeapon(WeaponChoose)
    local nigger = game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(WP)
    if nigger then
        game:GetService("Players").LocalPlayer.Character.Humanoid:EquipTool(nigger)
    end
end

function EBuso()
    if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("HasBuso") then
        local args = {[1] = "Buso"}
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
end

function RemoveLv(m)
    return tostring(m:gsub(" %pLv. %d+%p", ""))
end

function GetMob(mobname, checkrep)
    for r, v in next, mobname do
        mobname[r] = RemoveLv(v)
    end
    for r , v in next, game:GetService("Workspace").Enemies:GetChildren() do
        if ((typeof(mobname) == "string" and v.Name == mobname or string.find(v.Name, mobname) or typeof(mobname) == "table" and table.find(mobname, v.Name))) and v.Parent and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            return v
        end
    end
    if checkrep == true then
        for r , v in next, game:GetService("ReplicatedStorage"):GetChildren() do
            if ((typeof(mobname) == "string" and v.Name == mobname or string.find(v.Name, mobname) or typeof(mobname) == "table" and table.find(mobname, v.Name))) and v.Parent and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                return v
            end
        end
    end
end

function IsAlive(v)
    if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Parent and v.Humanoid.Health > 0 then
        return "Is Alive"
    elseif not v:FindFirstChild("Humanoid") or not v:FindFirstChild("HumanoidRootPart") or not v.Parent or v.Humanoid.Health <= 0 then
        return "Is Not Alive"
    end
end

function Bring(mob)
    for r, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
        if v.Name == mob then
            if IsAlive(v) == "Is Alive" then
                if GetDistance(v.HumanoidRootPart.Position) <= 230 then
                    v.HumanoidRootPart.Size = Vector3.new(30, 30, 30)
                    v.HumanoidRootPart.CanCollide = false
                    v.Head.CanCollide = false
                    v.Humanoid.WalkSpeed = 0
                    if v.Humanoid:FindFirstChild("Animator") then
                        v.Humanoid.Animator:Destroy()
                    end
                    v.Humanoid:ChangeState(11)
                    if not v.HumanoidRootPart:FindFirstChild("Lock") then
                        local Lock = Instance.new("BodyVelocity")
                        Lock.Parent = v.HumanoidRootPart
                        Lock.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        Lock.Velocity = Vector3.new(0, 0, 0)
                        Lock.Name = "Lock"
                    end
                end
            end
        end
    end
end

function KillMob(targetmob, valuestop)
    local path = GetMob(targetmob)
    if IsAlive(path) == "Is Alive" then
        repeat
            if not valuestop then break end
            local hmo = path.HumanoidRootPart
            Tweento(hmo * CFrame.new(0, 15, 0))
            Bring(path.Name)
            task.wait()
        until IsAlive(path) == "Is Not Alive" or not valuestop
    end
end

spawn(function()
    while wait() do
        if plr.Character:FindFirstChild("Head") then
            if NoClip == true then
                if not plr.Head:FindFirstChild("BodyVelocity") then
                    local BodyVelocity = Instance.new("BodyVelocity")
                    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
                    BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    BodyVelocity.P = 9000
                    BodyVelocity.Parent = plr.Head
                end
                for r, v in next, plr.Character:GetDescendants() do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            else
                if plr.Head:FindFirstChild("BodyVelocity") then
                    plr.Head:FindFirstChild("BodyVelocity"):Destroy()
                end
            end
        end
    end
end)

NoClip = true
while wait() do
    if GetMob("Bandit") then
        repeat task.wait()
            KillMob("Bandit", NoClip)
        until NoClip == false
    end
end
