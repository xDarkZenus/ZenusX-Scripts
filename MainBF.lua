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

NoAttackAnimation = true
local DmgAttack = game:GetService("ReplicatedStorage").Assets.GUI:WaitForChild("DamageCounter")
local PC = require(game.Players.LocalPlayer.PlayerScripts.CombatFramework.Particle)
local RL = require(game:GetService("ReplicatedStorage").CombatFramework.RigLib)
local oldRL = RL.wrapAttackAnimationAsync
RL.wrapAttackAnimationAsync = function(a,b,c,d,func)
	if not NoAttackAnimation then
		return oldRL(a,b,c,60,func)
	end

	local Hits = {}
	local Client = game.Players.LocalPlayer
	local Characters = game:GetService("Workspace").Characters:GetChildren()
	for i,v in pairs(Characters) do
		local Human = v:FindFirstChildOfClass("Humanoid")
		if v.Name ~= game.Players.LocalPlayer.Name and Human and Human.RootPart and Human.Health > 0 and Client:DistanceFromCharacter(Human.RootPart.Position) < 65 then
			table.insert(Hits,Human.RootPart)
		end
	end
	local Enemies = game:GetService("Workspace").Enemies:GetChildren()
	for i,v in pairs(Enemies) do
		local Human = v:FindFirstChildOfClass("Humanoid")
		if Human and Human.RootPart and Human.Health > 0 and Client:DistanceFromCharacter(Human.RootPart.Position) < 65 then
			table.insert(Hits,Human.RootPart)
		end
	end
	a:Play(0.01,0.01,0.01)
	pcall(func,Hits)
end

getAllBladeHits = LPH_NO_VIRTUALIZE(function(Sizes)
	local Hits = {}
	local Client = game.Players.LocalPlayer
	local Enemies = game:GetService("Workspace").Enemies:GetChildren()
	for i,v in pairs(Enemies) do
		local Human = v:FindFirstChildOfClass("Humanoid")
		if Human and Human.RootPart and Human.Health > 0 and Client:DistanceFromCharacter(Human.RootPart.Position) < Sizes+5 then
			table.insert(Hits,Human.RootPart)
		end
	end
	return Hits
end)

getAllBladeHitsPlayers = LPH_NO_VIRTUALIZE(function(Sizes)
	local Hits = {}
	local Client = game.Players.LocalPlayer
	local Characters = game:GetService("Workspace").Characters:GetChildren()
	for i,v in pairs(Characters) do
		local Human = v:FindFirstChildOfClass("Humanoid")
		if v.Name ~= game.Players.LocalPlayer.Name and Human and Human.RootPart and Human.Health > 0 and Client:DistanceFromCharacter(Human.RootPart.Position) < Sizes+5 then
			table.insert(Hits,Human.RootPart)
		end
	end
	return Hits
end)

local CombatFramework = require(game:GetService("Players").LocalPlayer.PlayerScripts:WaitForChild("CombatFramework"))
local CombatFrameworkR = getupvalues(CombatFramework)[2]
local RigEven = game:GetService("ReplicatedStorage").RigControllerEvent
local AttackAnim = Instance.new("Animation")
local AttackCoolDown = 0
local cooldowntickFire = 0
local MaxFire = 1000
local FireCooldown = 0.04
local FireL = 0

CancelCoolDown = LPH_JIT_MAX(function()
	local ac = CombatFrameworkR.activeController
	if ac and ac.equipped then
		AttackCoolDown = tick() + (FireCooldown or 0.288) + ((FireL/MaxFire)*0.2)
		RigEven.FireServer(RigEven,"weaponChange",ac.currentWeaponModel.Name)
		FireL = FireL + 1
		fask.delay((FireCooldown or 0.288) + ((FireL+0.3/MaxFire)*0.2),function()
			FireL = FireL - 1
		end)
	end
end)

AttackFunction = LPH_JIT_MAX(function(typef)
	local ac = CombatFrameworkR.activeController
	if ac and ac.equipped then
		local bladehit = {}
		if typef == 1 then
			bladehit = getAllBladeHits(60)
		elseif typef == 2 then
			bladehit = getAllBladeHitsPlayers(65)
		else
			for i2,v2 in pairs(getAllBladeHits(55)) do
				table.insert(bladehit,v2)
			end
			for i3,v3 in pairs(getAllBladeHitsPlayers(55)) do
				table.insert(bladehit,v3)
			end
		end
		if #bladehit > 0 then
			pcall(fask.spawn,ac.attack,ac)
			if tick() > AttackCoolDown then
				CancelCoolDown()
			end
			if tick() - cooldowntickFire > 0.4 then
				ac.timeToNextAttack = 0
				ac.hitboxMagnitude = 60
				pcall(fask.spawn,ac.attack,ac)
				cooldowntickFire = tick()
			end
			local AMI3 = ac.anims.basic[3]
			local AMI2 = ac.anims.basic[2]
			local REALID = AMI3 or AMI2
			AttackAnim.AnimationId = REALID
			local StartP = ac.humanoid:LoadAnimation(AttackAnim)
			StartP:Play(0.01,0.01,0.01)
			RigEven.FireServer(RigEven,"hit",bladehit,AMI3 and 3 or 2,"")
			fask.delay(0.5,function()
				StartP:Stop()
			end)
		end
	end
end)

function CheckStun()
	if game:GetService('Players').LocalPlayer.Character:FindFirstChild("Stun") then
		return game:GetService('Players').LocalPlayer.Character.Stun.Value ~= 0
	end
	return false
end

UseFast = true
LPH_JIT_MAX(function()
	spawn(function()
		while game:GetService("RunService").Stepped:Wait() do
			local ac = CombatFrameworkR.activeController
			if ac and ac.equipped and not CheckStun() then
				if UseFast then
					fask.spawn(function()
						pcall(fask.spawn,AttackFunction,1)
					end)
                end
			end
		end
	end)
end)()

local kkii = require(game.ReplicatedStorage.Util.CameraShaker)
kkii:Stop()

function KillMob(targetmob, valuestop)
    local path = GetMob(targetmob)
    if IsAlive(path) == "Is Alive" then
        repeat
            if not valuestop then break end
            local hmo = path.HumanoidRootPart
            local LockPos = hmo.CFrame
            Tweento(hmo.CFrame * CFrame.new(0, 15, 0))
            EWeapon()
            EBuso()
            Bring(path.Name)
            task.wait()
            NoClip = true
        until IsAlive(path) == "Is Not Alive" or not valuestop
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
                    BodyVelocity.P = 9000
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
while wait() do
    if GetMob("Bandit") then
        repeat task.wait()
            KillMob("Bandit", NoClip)
        until NoClip == false
    end
end
