repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players
repeat task.wait() until game:GetService("Players").LocalPlayer
LoadedScript = false

local fask = task 
setreadonly(fask,false)

local RunService =  game:GetService("RunService")
local myWait = function(n)
	if not n then
		return RunService.Heartbeat:Wait()
	else
		local lasted = 0
		repeat
			lasted = lasted + RunService.Heartbeat:Wait()
		until lasted >= n
		return lasted
	end
end
fask.wait = myWait

if not LPH_OBFUSCATED then
	LPH_JIT_MAX = (function(...) return ... end)
	LPH_NO_VIRTUALIZE = (function(...) return ... end)
	LPH_NO_UPVALUES = (function(...) return ... end)
end

for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do 
	v:Disable()
end

Config = {}
local HttpService = game:GetService("HttpService")
function Save(valuefunction, value)
    if valuefunction ~= nil then
        Config[valuefunction] = value
    end
    if not isfolder("ZenusX") then
        makefolder("ZenusX")
    end
    writefile("ZenusX" .. "/" .. game:GetService("Players").LocalPlayer.Name, HttpService:JSONEncode(Config))
end
function Read()
    local s, o = pcall(function()
        if not isfolder("ZenusX") then
            makefolder("ZenusX")
        end
        return HttpService:JSONDecode(readfile("ZenusX" .. "/" .. game:GetService("Players").LocalPlayer.Name))
    end)
    if s then
        return o
    else
        Save()
        return Read()
    end
end
Config = Read()

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
        return (cc.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    elseif typeof(cc) == "Vector3" then
        return (cc - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
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

function Bring(mob)
    for r, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
        if v.Name == mob then
            if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Parent and v.Humanoid.Health > 0 then
                if GetDistance(v.HumanoidRootPart.Position) <= 250 then
                    v.HumanoidRootPart.Size = Vector3.new(30, 30, 30)
                    v.HumanoidRootPart.CanCollide = false
                    v.Head.CanCollide = false
                    v.Humanoid.WalkSpeed = 0
                    v.HumanoidRootPart.CFrame = LockPos
                    if v.Humanoid:FindFirstChild("Animator") then
                        v.Humanoid.Animator:Destroy()
                    end
                    v.Humanoid:ChangeState(11)
                    if not v:FindFirstChild("Lock") then
                        local Lock = Instance.new("BodyVelocity")
                        Lock.Parent = v
                        Lock.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        Lock.Velocity = Vector3.new(0, 0, 0)
                        Lock.Name = "Lock"
                    end
                end
            end
        end
    end
end

game:GetService("RunService").RenderStepped:connect(function()
    sethiddenproperty(plr, "SimulationRadius", math.huge)
end)

local CombatFramework = require(game:GetService("Players").LocalPlayer.PlayerScripts:WaitForChild("CombatFramework"))
local CombatFrameworkR = getupvalues(CombatFramework)[2]
local Animation = Instance.new("Animation")
function CurrentWeapon()
    local ac = CombatFrameworkR.activeController
    local ret = ac.blades[1]
    if not ret then
        return game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Name
    end
    pcall(
        function()
            while ret.Parent ~= game.Players.LocalPlayer.Character do
                ret = ret.Parent
            end
        end
    )
    if not ret then
        return game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Name
    end
    return ret
end
function DoAttack()
    if game.Players.LocalPlayer.Character.Stun.Value ~= 0 then
        return nil
    end
    local ac = CombatFrameworkR.activeController
    ac.hitboxMagnitude = 55
    if ac and ac.equipped then
        for indexincrement = 1, 1 do
            local bladehit =require(game.ReplicatedStorage.CombatFramework.RigLib).getBladeHits(game.Players.LocalPlayer.Character,{game.Players.LocalPlayer.Character.HumanoidRootPart},60)
            if #bladehit > 0 then
                local AcAttack8 = debug.getupvalue(ac.attack, 5)
                local AcAttack9 = debug.getupvalue(ac.attack, 6)
                local AcAttack7 = debug.getupvalue(ac.attack, 4)
                local AcAttack10 = debug.getupvalue(ac.attack, 7)
                local NumberAc12 = (AcAttack8 * 798405 + AcAttack7 * 727595) % AcAttack9
                local NumberAc13 = AcAttack7 * 798405
                (function()
                    NumberAc12 = (NumberAc12 * AcAttack9 + NumberAc13) % 1099511627776
                    AcAttack8 = math.floor(NumberAc12 / AcAttack9)
                    AcAttack7 = NumberAc12 - AcAttack8 * AcAttack9
                end)()
                AcAttack10 = AcAttack10 + 1
                debug.setupvalue(ac.attack, 5, AcAttack8)
                debug.setupvalue(ac.attack, 6, AcAttack9)
                debug.setupvalue(ac.attack, 4, AcAttack7)
                debug.setupvalue(ac.attack, 7, AcAttack10)
                if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") and ac.blades and ac.blades[1] then
                    Animation.AnimationId = ac.anims.basic[2]
                    ac.humanoid:LoadAnimation(Animation):Play(1, 1)
                    game.ReplicatedStorage.Remotes.Validator:FireServer(math.floor(NumberAc12 / 1099511627776 * 16777215), AcAttack10)
                    game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("weaponChange", tostring(CurrentWeapon()))
                    game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("hit", bladehit, 2, "")
                end
            end
        end
    end
end

FireAttack = 0  
TickStartAttack = tick()
spawn(function()
    local MT = getrawmetatable(game)
    local OldNameCall = MT.__namecall
    setreadonly(MT, false)
    MT.__namecall = newcclosure(function(self, ...)
        local Method = getnamecallmethod()
        local Args = {...}
        if Method == 'FireServer' and self.Name == "RigControllerEvent" and  Args[1] == "hit"  then
            FireAttack = FireAttack + 1 
            TickStartAttack = tick()
        end
        return OldNameCall(self, unpack(Args))
    end)
end)

function Attack()
    pcall(function()
        DoAttack()
    end)
end

function Attack2()
    if FireAttack <= 70 then
        Attack()
        FireAttack = FireAttack + 1
    elseif FireAttack >= 70 then
        Attack()
        task.wait(0.1)
    end
end

spawn(function()
    while task.wait(0.0001) do
        repeat
            task.wait(0.0001)
            Attack2()
        until plr.Character.Stun.Value ~= 0
    end
end)

function KillMob(targetmob, valuestop)
    local path = GetMob(targetmob)
    if path:FindFirstChild("Humanoid") and path:FindFirstChild("HumanoidRootPart") and path.Parent and path.Humanoid.Health > 0 then
        repeat
            task.wait()
            local hmo = path.HumanoidRootPart
            LockPos = hmo.CFrame
            Tweento(hmo.CFrame * CFrame.new(0, 15, 0))
            EWeapon()
            EBuso()
            Bring(path.Name)
            NoClip = true
        until not path:FindFirstChild("Humanoid") or not path:FindFirstChild("HumanoidRootPart") or not path.Parent or path.Humanoid.Health <= 0 or not valuestop
        NoClip = false
    end
end

spawn(function()
    while wait() do
        if plr.Character:FindFirstChild("Head") then
            if NoClip == true then
                if not plr.Character.Head:FindFirstChild("BodyVelocity") then
                    local BodyVelocity = Instance.new("BodyVelocity")
                    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
                    BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    BodyVelocity.P = 1500
                    BodyVelocity.Parent = plr.Character.Head
                end
                for r, v in next, plr.Character:GetDescendants() do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            else
                if plr.Character.Head:FindFirstChild("BodyVelocity") then
                    plr.Character.Head:FindFirstChild("BodyVelocity"):Destroy()
                end
            end
        end
    end
end)

NoClip = true
spawn(function()
    while wait() do
        if GetMob("Bandit") then
            repeat task.wait()
                KillMob("Bandit", NoClip)
            until NoClip == false
        end
    end
end)
