--[[
	Rayfield Gen2 AI Suite  --  One Tap (FPS) build
	Game: One Tap, Place 90568084448279

	TARGETING
	- Aimbot (camera, FOV circle, smoothing; bone-based Hitbox lookup)
	- Silent Aim (redirects fired shot to target via WeaponPackets.startShoot.send
	  / WeaponManager.cast / rcast hooks)
	- Triggerbot, Auto Shoot, FOV circle, target dot

	COMBAT
	- Rapid Fire, No Reload, Infinite Ammo, Hitbox Expander, Wallbang(best-effort)

	VISUALS
	- Box / Name / Health / Distance ESP, Tracers, Bot detection

	MOVEMENT
	- Fly (velocity only), Noclip, Infinite Jump (scales w/ jump power), Bhop,
	  Spinbot (character-only), Third Person

	UTILITY
	- Unlock All, Godmode
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local Common = ReplicatedStorage:FindFirstChild("Common")
local Camera = Workspace.CurrentCamera

-- =========================== Config ===========================
local Config = {
	Aimbot = {
		Enabled = false,
		TeamCheck = false,
		IgnoreBots = false,
		AimPart = "Head",
		FOV = 300,
		Smoothness = 30,
		MaxDistance = 1200,
		VisCheck = false,
		Holding = false,
	},
	Combat = {
		SilentAim = false,
		Wallbang = false,
		Triggerbot = false,
		TriggerDelay = 0.1,
		AutoShoot = false,
		CPS = 10,
		Hitbox = false,
		HitboxScale = 1.25,
		RapidFire = false,
		NoReload = false,
		InfAmmo = false,
	},
	Movement = {
		Fly = false,
		Noclip = false,
		FlySpeed = 50,
		InfJump = false,
		JumpPower = 60,
		BHop = false,
		BHopAlways = false,
		Spinbot = false,
		SpinSpeed = 4,
		ThirdPerson = false,
		ThirdDist = 12,
	},
	Misc = {
		UnlockAll = false,
		Godmode = false,
	},
	ESP = {
		Enabled = false,
		Box = true,
		Name = true,
		Health = true,
		Distance = true,
		Tracer = true,
		ShowBots = true,
		TeamCheck = false,
		MaxDistance = 2000,
		EnemyColor = Color3.fromRGB(255, 80, 80),
		BotColor = Color3.fromRGB(255, 170, 0),
		TracerColor = Color3.fromRGB(255, 255, 255),
		NameColor = Color3.fromRGB(255, 255, 255),
	},
	FOV = {
		Circle = true,
		Color = Color3.fromRGB(255, 255, 255),
	},
	Detector = {
		Sensitivity = 50,
	},
}

local Connections = {}
local CleaningUp = false

-- =========================== Weapon hooks ===========================
local WeaponPackets, WeaponManager = nil, nil
local RealSend, RealCast, RealRcast = nil, nil, nil
local RealDec, RealGet, RealGetMax = nil, nil, nil
local WeaponClientRef = nil
local SilentTarget = nil

local function requireCommon(path)
	if not Common then return nil end
	local obj = Common
	for _, name in ipairs(path) do
		if not obj then return nil end
		obj = obj:FindFirstChild(name)
	end
	if not obj then return nil end
	local ok, res = pcall(require, obj)
	return ok and res or nil
end

local function getWeaponClient()
	if WeaponClientRef then return WeaponClientRef end
	local wc = nil
	pcall(function()
		local start = LocalPlayer:FindFirstChild("PlayerScripts") and LocalPlayer.PlayerScripts:FindFirstChild("Start")
		local g = start and start:FindFirstChild("Game")
		wc = g and require(g.WeaponClient)
	end)
	WeaponClientRef = wc
	return wc
end

local function setupWeaponHooks()
	WeaponPackets = requireCommon({ "Packets", "WeaponPackets" })
	if WeaponPackets and WeaponPackets.startShoot and WeaponPackets.startShoot.send then
		RealSend = WeaponPackets.startShoot.send
		WeaponPackets.startShoot.send = function(Data, ...)
			if CleaningUp then return RealSend and RealSend(Data, ...) end
			local T, P = nil, nil
			if Config.Combat.SilentAim and SilentTarget and SilentTarget.Character and SilentTarget.Part then
				T, P = SilentTarget.Character, SilentTarget.Part
			end
			if Data and T and P then
				local origin = Data.origin or Data.Origin or Camera.CFrame.Position
				local dir = (P.Position - origin).Unit
				Data.hitResult = T
				Data.hitPart = P
				Data.position = P.Position
				Data.direction = dir
				Data.HitResult = T
				Data.HitPart = P
				Data.Position = P.Position
				Data.Direction = dir
				pcall(function() LastValidData = { origin = origin, timestamp = Workspace:GetServerTimeNow() } end)
			elseif Data then
				pcall(function()
					LastValidData = {}
					for k, v in pairs(Data) do LastValidData[k] = v end
				end)
			end
			return RealSend and RealSend(Data, ...)
		end
	end

	WeaponManager = requireCommon({ "Managers", "WeaponManager" })
	if WeaponManager and type(WeaponManager.cast) == "function" then
		RealCast = WeaponManager.cast
		WeaponManager.cast = function(origin, direction, bullet_speed, max_distance, ...)
			if Config.Combat.SilentAim then
				local T, P = nil, nil
				if SilentTarget and SilentTarget.Character and SilentTarget.Part then
					T, P = SilentTarget.Character, SilentTarget.Part
				end
				if T and P then
					direction = (P.Position - origin).Unit
					bullet_speed = 9e9
					max_distance = 9e999
				end
			end
			return RealCast(origin, direction, bullet_speed, max_distance, ...)
		end
	end
	if WeaponManager and type(WeaponManager.rcast) == "function" then
		RealRcast = WeaponManager.rcast
		WeaponManager.rcast = function(origin, direction, bullet_speed, max_distance, filter, cb, ...)
			if Config.Combat.SilentAim then
				local T, P = nil, nil
				if SilentTarget and SilentTarget.Character and SilentTarget.Part then
					T, P = SilentTarget.Character, SilentTarget.Part
				end
				if T and P then direction = (P.Position - origin).Unit end
			end
			return RealRcast(origin, direction, bullet_speed, max_distance, filter, cb, ...)
		end
	end

	local wc = getWeaponClient()
	if wc then
		if wc.decreaseBullets and not RealDec then
			RealDec = wc.decreaseBullets
			wc.decreaseBullets = function(...)
				if Config.Combat.InfAmmo then return end
				if RealDec then return RealDec(...) end
			end
		end
		if wc.getBullets and not RealGet then
			RealGet = wc.getBullets
			wc.getBullets = function(...)
				if Config.Combat.InfAmmo then return 9999 end
				if RealGet then return RealGet(...) end
			end
		end
		if wc.getMaxBulletsForCurrentWeapon and not RealGetMax then
			RealGetMax = wc.getMaxBulletsForCurrentWeapon
			wc.getMaxBulletsForCurrentWeapon = function(...)
				if Config.Combat.InfAmmo then return 9999 end
				if RealGetMax then return RealGetMax(...) end
			end
		end
	end
	print("[RayfieldAI] Weapon hooks attached.")
end

local function restoreWeaponHooks()
	pcall(function()
		if WeaponPackets and WeaponPackets.startShoot then WeaponPackets.startShoot.send = RealSend end
	end)
	pcall(function()
		if WeaponManager then
			WeaponManager.cast = RealCast
			WeaponManager.rcast = RealRcast
		end
	end)
	pcall(function()
		local wc = getWeaponClient()
		if wc then
			if wc.decreaseBullets and RealDec then wc.decreaseBullets = RealDec end
			if wc.getBullets and RealGet then wc.getBullets = RealGet end
			if wc.getMaxBulletsForCurrentWeapon and RealGetMax then wc.getMaxBulletsForCurrentWeapon = RealGetMax end
		end
	end)
end

local SavedWeaponStats = nil
local function applyWeaponMods()
	if not WeaponManager then return end
	pcall(function()
		local C = WeaponManager.Constants
		if not C then return end
		if Config.Combat.RapidFire then
			C.DEFAULT_FIRERATE = 0.05
			C.DEFAULT_PISTOL_FIRERATE = 0.05
		else
			C.DEFAULT_FIRERATE = 0.25
			C.DEFAULT_PISTOL_FIRERATE = 0.25
		end
		if Config.Combat.NoReload then
			C.DEFAULT_RELOAD_TIME = 0
			C.DEFAULT_PISTOL_RELOAD_TIME = 0
		else
			C.DEFAULT_RELOAD_TIME = 0.75
			C.DEFAULT_PISTOL_RELOAD_TIME = 0.5
		end
		if Config.Combat.InfAmmo then C.DEFAULT_MAGAZINE = 9e9 else C.DEFAULT_MAGAZINE = 30 end
	end)
	local ok, weps = pcall(function() return WeaponManager.getWeapons and WeaponManager.getWeapons() end)
	if ok and type(weps) == "table" then
		if not SavedWeaponStats then
			SavedWeaponStats = {}
			for name, data in pairs(weps) do
				SavedWeaponStats[name] = {
					firerate = data.firerate,
					reloadTime = data.reloadTime,
					magazine = data.magazine,
				}
			end
		end
		for name, data in pairs(weps) do
			local orig = SavedWeaponStats[name]
			if orig then
				data.firerate = Config.Combat.RapidFire and 0.05 or orig.firerate
				data.reloadTime = Config.Combat.NoReload and 0 or orig.reloadTime
				data.magazine = Config.Combat.InfAmmo and 9e9 or orig.magazine
			end
		end
	end
end

local function nowTime()
	local ok, t = pcall(function() return Workspace:GetServerTimeNow() end)
	return ok and t or os.clock()
end

local function fireWeapon()
	local wc = getWeaponClient()
	if wc and wc.fire then
		pcall(function() wc.fire() end)
		return
	end
	local okSend, Data = pcall(function()
		if WeaponPackets and WeaponPackets.startShoot and WeaponPackets.startShoot.send then
			local d = { origin = Camera.CFrame.Position, timestamp = nowTime() }
			if Config.Combat.SilentAim and SilentTarget and SilentTarget.Character and SilentTarget.Part then
				d.hitResult = SilentTarget.Character
				d.hitPart = SilentTarget.Part
				d.position = SilentTarget.Part.Position
				d.direction = (SilentTarget.Part.Position - Camera.CFrame.Position).Unit
			else
				d.direction = Camera.CFrame.LookVector
			end
			return d
		end
	end)
	if okSend and Data then
		pcall(function() WeaponPackets.startShoot.send(Data) end)
	end
end

-- =========================== Target registry / bones ===========================
local Bones = {
	Head = { "Hitbox_Head", "Head" },
	Torso = { "Hitbox_Torso", "HumanoidRootPart", "Torso" },
	["Left Arm"] = { "Hitbox_Left Arm", "Left Arm" },
	["Right Arm"] = { "Hitbox_Right Arm", "Right Arm" },
	["Left Leg"] = { "Hitbox_Left Leg", "Left Leg" },
	["Right Leg"] = { "Hitbox_Right Leg", "Right Leg" },
}

local function findPart(char, name)
	if not char then return nil end
	local hb = char:FindFirstChild("Hitbox")
	if hb then
		local hit = hb:FindFirstChild(name)
		if hit then return hit end
	end
	return char:FindFirstChild(name) or char:FindFirstChild(name, true)
end

local function getBone(char, slot)
	local list = Bones[slot] or Bones["Head"]
	for _, n in ipairs(list) do
		local p = findPart(char, n)
		if p then return p end
	end
	return nil
end

local function findRootPart(char)
	return findPart(char, "HumanoidRootPart") or findPart(char, "Torso")
end

local function isBotName(name)
	local n = string.lower(name or "")
	for _, p in ipairs({ "bot", "clyde", "gpt", "npc", "dummy", "robot", "script", "test" }) do
		if string.find(n, p, 1, true) then return true end
	end
	return false
end

local function isAliveChar(char)
	if not char then return false end
	if not char:IsDescendantOf(Workspace) then return false end
	if char:GetAttribute("Ragdoll") then return false end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 then return false end
	if hum:GetState() == Enum.HumanoidStateType.Dead then return false end
	if char:FindFirstChildOfClass("ForceField") then return false end
	return true
end

local Targets = {}

local function rebuildEntities()
	local out = {}
	local MyChar = LocalPlayer.Character
	local seen = {}
	for _, Model in ipairs(Workspace:GetChildren()) do
		if Model:IsA("Model") and Model ~= MyChar and isAliveChar(Model) then
			local Plr = Players:GetPlayerFromCharacter(Model)
			seen[Model] = true
			out[#out + 1] = {
				Character = Model,
				Player = Plr,
				IsBot = (not Plr) or isBotName(Model.Name),
				Name = Plr and Plr.Name or Model.Name,
			}
		end
	end
	for _, Plr in ipairs(Players:GetPlayers()) do
		if Plr ~= LocalPlayer and Plr.Character and not seen[Plr.Character] and isAliveChar(Plr.Character) then
			local Model = Plr.Character
			seen[Model] = true
			out[#out + 1] = {
				Character = Model,
				Player = Plr,
				IsBot = false,
				Name = Plr.Name,
			}
		end
	end
	Targets = out
end

local function isVisible(origin, char, part)
	local dist = (part.Position - origin).Magnitude
	if dist <= 0 then return true end
	if Config.Combat.Wallbang then return true end
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	local filter = {}
	local myChar = LocalPlayer.Character
	if myChar then table.insert(filter, myChar) end
	local effects = Workspace:FindFirstChild("Effects")
	if effects then table.insert(filter, effects) end
	params.FilterDescendantsInstances = filter
	local hit = Workspace:Raycast(origin, (part.Position - origin).Unit * dist, params)
	if not hit then return true end
	local m = hit.Instance:FindFirstAncestorWhichIsA("Model")
	return m == char
end

local function isEnemyTarget(ent)
	if ent.IsBot then return not Config.Aimbot.IgnoreBots end
	if Config.Aimbot.TeamCheck then
		local p = ent.Player
		if p and p.Neutral == false and LocalPlayer.Neutral == false then
			return p.Team ~= LocalPlayer.Team
		end
	end
	return true
end

local function pickTarget(silent)
	local vpSize = Camera.ViewportSize
	local center = Vector2.new(vpSize.X / 2, vpSize.Y / 2)
	local best, bestScore = nil, math.huge
	local myChar = LocalPlayer.Character
	local myhp = myChar and findPart(myChar, "HumanoidRootPart")
	local origin = (myhp and myhp.Position) or Camera.CFrame.Position
	for _, ent in ipairs(Targets) do
		if not isEnemyTarget(ent) then continue end
		local slot = (Config.Aimbot.AimPart == "Random") and (math.random() < 0.5 and "Head" or "Torso") or Config.Aimbot.AimPart
		local part = getBone(ent.Character, slot)
		if not part then continue end
		if (not Config.Aimbot.VisCheck) or isVisible(origin, ent.Character, part) then
			local sp = Camera:WorldToViewportPoint(part.Position)
			local onScreen = select(2, Camera:WorldToViewportPoint(part.Position))
			if onScreen then
				local mouseDist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
				if silent or mouseDist < Config.Aimbot.FOV then
					local hum = ent.Character:FindFirstChildOfClass("Humanoid")
					if silent then
						best = { Character = ent.Character, Part = part, IsBot = ent.IsBot, Player = ent.Player }
						break
					end
					local score = mouseDist
					if score < bestScore then
						bestScore = score
						best = {
							Character = ent.Character, Part = part, IsBot = ent.IsBot,
							Player = ent.Player, Name = ent.Name,
							Distance = (part.Position - origin).Magnitude,
							Health = hum and hum.Health or 100,
						}
					end
				end
			end
		end
	end
	return best
end

-- =========================== Aim loop ===========================
local LastTrigger = 0
local LastAutoShoot = 0

RunService:BindToRenderStep("RF_AIM", 120, function()
	if Config.Aimbot.Enabled and Config.Aimbot.Holding then
		local t = pickTarget(false)
		if t then
			SilentTarget = t
			local pos = t.Part.Position
			local smooth = math.clamp(1 - (Config.Aimbot.Smoothness / 100), 0.02, 1)
			local targetCF = CFrame.lookAt(Camera.CFrame.Position, pos, Camera.CFrame.UpVector)
			Camera.CFrame = Camera.CFrame:Lerp(targetCF, smooth)
		end
	elseif Config.Combat.SilentAim then
		SilentTarget = pickTarget(true)
	elseif Config.Combat.Triggerbot then
		SilentTarget = pickTarget(true)
	else
		SilentTarget = nil
	end
end)

RunService:BindToRenderStep("RF_COMBAT", 150, function()
	local now = os.clock()
	if Config.Combat.Triggerbot and SilentTarget then
		local sp = Camera:WorldToViewportPoint(SilentTarget.Part.Position)
		local onScreen = select(2, Camera:WorldToViewportPoint(SilentTarget.Part.Position))
		if onScreen then
			local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
			if (Vector2.new(sp.X, sp.Y) - center).Magnitude < math.max(12, Config.Aimbot.FOV * 0.08) then
				if now - LastTrigger >= Config.Combat.TriggerDelay then
					LastTrigger = now
					fireWeapon()
				end
			end
		end
	end
	if Config.Combat.AutoShoot then
		local interval = 1 / math.max(1, Config.Combat.CPS)
		if now - LastAutoShoot >= interval then
			LastAutoShoot = now
			fireWeapon()
		end
	end
end)

-- =========================== Hitbox expander ===========================
local SavedHitboxSizes = {}
local LastHitboxOff = true

local function applyHitboxes()
	for _, ent in ipairs(Targets) do
		local char = ent.Character
		local hb = char and char:FindFirstChild("Hitbox")
		if hb then
			for _, part in ipairs(hb:GetChildren()) do
				if part:IsA("BasePart") then
					if not SavedHitboxSizes[part] then
						SavedHitboxSizes[part] = part.Size
						pcall(function() part.CanTouch = true; part.CanQuery = true end)
					end
					local wanted = SavedHitboxSizes[part] * Config.Combat.HitboxScale
					pcall(function()
						if part.Size ~= wanted then part.Size = wanted end
					end)
				end
			end
		end
	end
end

local function restoreHitboxes()
	for part, size in pairs(SavedHitboxSizes) do
		pcall(function()
			if part and part.Parent then part.Size = size end
		end)
	end
	SavedHitboxSizes = {}
end

-- =========================== ESP ===========================
local ESPCache = {}

local function eRemove(char)
	local e = ESPCache[char]
	if e then
		if e.Conn then for _, c in ipairs(e.Conn) do pcall(function() c:Disconnect() end) end end
		for _, obj in pairs(e) do
			if typeof(obj) == "userdata" and obj.Remove then pcall(function() obj:Remove() end) end
		end
		ESPCache[char] = nil
	end
end

local function eHide(char)
	local e = ESPCache[char]
	if not e then return end
	e.Box.Visible = false
	e.Name.Visible = false
	e.HealthBar.Visible = false
	e.HealthText.Visible = false
	e.DistText.Visible = false
	e.Tracer.Visible = false
end

local function eEnsure(char, isBot)
	if ESPCache[char] then return ESPCache[char] end
	if not Drawing then return nil end
	local e = {
		Box = Drawing.new("Quad"),
		Name = Drawing.new("Text"),
		HealthBar = Drawing.new("Quad"),
		HealthText = Drawing.new("Text"),
		DistText = Drawing.new("Text"),
		Tracer = Drawing.new("Line"),
		Conn = {},
	}
	local hum = char:FindFirstChildOfClass("Humanoid")
	local DC
	if hum then
		DC = hum.Died:Connect(function() if DC then DC:Disconnect() end eHide(char) end)
		table.insert(e.Conn, DC)
	end
	local RC
	if typeof(char.GetAttributeChangedSignal) == "function" then
		RC = char:GetAttributeChangedSignal("Ragdoll"):Connect(function()
			if char:GetAttribute("Ragdoll") then
				if RC then RC:Disconnect() end
				if DC then DC:Disconnect() end
				eHide(char)
			end
		end)
		table.insert(e.Conn, RC)
	end
	e.Box.Thickness = 1.5
	e.Box.Color = isBot and Config.ESP.BotColor or Config.ESP.EnemyColor
	e.Name.Size = 13
	e.Name.Center = true
	e.Name.Outline = true
	e.HealthBar.Filled = true
	e.HealthBar.Thickness = 1
	e.HealthBar.Color = Color3.fromRGB(0, 255, 0)
	e.HealthText.Size = 11
	e.HealthText.Center = true
	e.HealthText.Outline = true
	e.DistText.Size = 11
	e.DistText.Center = true
	e.DistText.Outline = true
	e.Tracer.Thickness = 1.5
	e.Tracer.Color = Config.ESP.TracerColor
	ESPCache[char] = e
	return e
end

RunService:BindToRenderStep("RF_ESP", 200, function()
	if not Drawing then return end
	local enabled = Config.ESP.Enabled and (Config.ESP.Box or Config.ESP.Name or Config.ESP.Health or Config.ESP.Distance or Config.ESP.Tracer)
	local screenSize = Camera.ViewportSize
	local bottomCenter = Vector2.new(screenSize.X / 2, screenSize.Y)
	local myChar = LocalPlayer.Character
	local myHRP = myChar and findRootPart(myChar)
	local centerPos = myHRP and myHRP.Position

	for _, ent in ipairs(Targets) do
		local char = ent.Character
		local show = enabled and char and char:IsDescendantOf(Workspace) and isAliveChar(char)
		if not show then
			if ESPCache[char] then eHide(char) end
			continue
		end
		if ent.IsBot and not Config.ESP.ShowBots then
			if ESPCache[char] then eHide(char) end
			continue
		end
		if not ent.IsBot and ent.Player and Config.ESP.TeamCheck then
			local p = ent.Player
			if p.Neutral == false and LocalPlayer.Neutral == false and p.Team == LocalPlayer.Team then
				if ESPCache[char] then eHide(char) end
				continue
			end
		end
		local head = findPart(char, "Head")
		local hrp = findRootPart(char)
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not head or not hrp then
			if ESPCache[char] then eHide(char) end
			continue
		end
		local dist = (hrp.Position - Camera.CFrame.Position).Magnitude
		if dist > Config.ESP.MaxDistance then
			if ESPCache[char] then eHide(char) end
			continue
		end

		local e = eEnsure(char, ent.IsBot)
		local topV, topOn = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.75, 0))
		local botV, botOn = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 0.8, 0))
		if not (topOn and botOn) then
			eHide(char)
			continue
		end
		local h = math.max(10, botV.Y - topV.Y)
		local w = h * 0.55
		local x, y = topV.X - w / 2, topV.Y
		local color = ent.IsBot and Config.ESP.BotColor or Config.ESP.EnemyColor

		if Config.ESP.Box then
			e.Box.Visible = true
			e.Box.Color = color
			e.Box.PointA = Vector2.new(x, y)
			e.Box.PointB = Vector2.new(x + w, y)
			e.Box.PointC = Vector2.new(x + w, y + h)
			e.Box.PointD = Vector2.new(x, y + h)
		else
			e.Box.Visible = false
		end
		if Config.ESP.Tracer and centerPos then
			e.Tracer.Visible = true
			e.Tracer.Color = Config.ESP.TracerColor
			e.Tracer.From = bottomCenter
			e.Tracer.To = Vector2.new(x + w / 2, y + h)
		else
			e.Tracer.Visible = false
		end
		if Config.ESP.Name then
			e.Name.Visible = true
			e.Name.Text = (ent.IsBot and "[BOT] " or "") .. ent.Name
			e.Name.Color = color
			e.Name.Position = Vector2.new(x + w / 2, y - 16)
		else
			e.Name.Visible = false
		end
		if Config.ESP.Health and hum then
			local frac = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
			e.HealthBar.Visible = true
			e.HealthBar.Color = Color3.fromRGB(255 * (1 - frac), 255 * frac, 0)
			e.HealthBar.PointA = Vector2.new(x - 5, y + h)
			e.HealthBar.PointB = Vector2.new(x - 2, y + h)
			e.HealthBar.PointC = Vector2.new(x - 2, y + h - (h * frac))
			e.HealthBar.PointD = Vector2.new(x - 5, y + h - (h * frac))
			e.HealthText.Visible = true
			e.HealthText.Text = tostring(math.floor(hum.Health))
			e.HealthText.Position = Vector2.new(x - 4, y + h - (h * frac) - 14)
		else
			e.HealthBar.Visible = false
			e.HealthText.Visible = false
		end
		if Config.ESP.Distance and centerPos then
			e.DistText.Visible = true
			e.DistText.Text = tostring(math.floor((head.Position - centerPos).Magnitude)) .. "m"
			e.DistText.Position = Vector2.new(x + w / 2, y + h + 3)
		else
			e.DistText.Visible = false
		end
	end

	for char in pairs(ESPCache) do
		local still = false
		for _, ent in ipairs(Targets) do
			if ent.Character == char then still = true break end
		end
		if not still then
			eHide(char)
			if not char:IsDescendantOf(Workspace) then eRemove(char) end
		end
	end
end)

-- =========================== FOV circle / target dot ===========================
local FOVObj, DotObj = nil, nil
if Drawing then
	FOVObj = Drawing.new("Circle")
	FOVObj.Thickness = 2
	FOVObj.NumSides = 64
	FOVObj.Transparency = 1
	FOVObj.Color = Color3.fromRGB(255, 255, 255)
	DotObj = Drawing.new("Circle")
	DotObj.Thickness = 1
	DotObj.NumSides = 16
	DotObj.Radius = 4
	DotObj.Filled = true
end

RunService:BindToRenderStep("RF_FOV", 210, function()
	if not Drawing then return end
	local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
	if Config.FOV.Circle and (Config.Aimbot.Enabled or Config.Combat.SilentAim) then
		FOVObj.Visible = true
		FOVObj.Radius = Config.Aimbot.FOV
		FOVObj.Color = Config.FOV.Color
		FOVObj.Position = center
	else
		FOVObj.Visible = false
	end
	if SilentTarget and (Config.Aimbot.Enabled or Config.Combat.SilentAim) then
		local sp = Camera:WorldToViewportPoint(SilentTarget.Part.Position)
		local on = select(2, Camera:WorldToViewportPoint(SilentTarget.Part.Position))
		if on then
			DotObj.Visible = true
			DotObj.Position = Vector2.new(sp.X, sp.Y)
			DotObj.Color = SilentTarget.IsBot and Config.ESP.BotColor or Config.ESP.EnemyColor
		else
			DotObj.Visible = false
		end
	else
		DotObj.Visible = false
	end
end)

-- =========================== Movement ===========================
local Keys = { W = false, A = false, S = false, D = false, Space = false }

table.insert(Connections, UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.W then Keys.W = true
	elseif input.KeyCode == Enum.KeyCode.A then Keys.A = true
	elseif input.KeyCode == Enum.KeyCode.S then Keys.S = true
	elseif input.KeyCode == Enum.KeyCode.D then Keys.D = true
	elseif input.KeyCode == Enum.KeyCode.Space then
		Keys.Space = true
		if Config.Movement.InfJump then
			local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if hum then pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end) end
		end
	end
end))

table.insert(Connections, UserInputService.InputEnded:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.W then Keys.W = false
	elseif input.KeyCode == Enum.KeyCode.A then Keys.A = false
	elseif input.KeyCode == Enum.KeyCode.S then Keys.S = false
	elseif input.KeyCode == Enum.KeyCode.D then Keys.D = false
	elseif input.KeyCode == Enum.KeyCode.Space then Keys.Space = false end
end))

local NoclipConn = nil
local FlyPrev = {}
local function rememberMoveState()
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		if not FlyPrev.WalkSpeed then FlyPrev.WalkSpeed = hum.WalkSpeed end
		if not FlyPrev.JumpPower then FlyPrev.JumpPower = hum.JumpPower end
	end
end
local function restoreMoveState()
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		if FlyPrev.WalkSpeed then hum.WalkSpeed = FlyPrev.WalkSpeed end
		if FlyPrev.JumpPower then hum.JumpPower = FlyPrev.JumpPower end
	end
end

-- Infinite Jump: re-jump each time Space is pressed, scaled by jump power
table.insert(Connections, UserInputService.JumpRequest:Connect(function()
	if not Config.Movement.InfJump then return end
	if Config.Movement.Fly then return end
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local hrp = char and findRootPart(char)
	if hum and hrp then
		local jp = hum.JumpPower + Config.Movement.JumpPower
		hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, jp, hrp.AssemblyLinearVelocity.Z)
	end
end))

	local WasFlying = false
	RunService:BindToRenderStep("RF_MOVE", 100, function(dt)
	local char = LocalPlayer.Character
	local hrp = char and findRootPart(char)
	local hum = char and char:FindFirstChildOfClass("Humanoid")

	-- Noclip
	if Config.Movement.Noclip and char and not NoclipConn then
		NoclipConn = RunService.Stepped:Connect(function()
			local c = LocalPlayer.Character
			if not c then return end
			for _, part in ipairs(c:GetDescendants()) do
				if part:IsA("BasePart") then pcall(function() part.CanCollide = false end) end
			end
		end)
	elseif not Config.Movement.Noclip and NoclipConn then
		NoclipConn:Disconnect()
		NoclipConn = nil
	end

	-- Fly (velocity only)
	if Config.Movement.Fly and hrp then
		if not WasFlying then WasFlying = true; rememberMoveState() end
		local move = Vector3.zero
		local look, right = Camera.CFrame.LookVector, Camera.CFrame.RightVector
		if Keys.W then move = move + look end
		if Keys.S then move = move - look end
		if Keys.A then move = move - right end
		if Keys.D then move = move + right end
		if Keys.Space then move = move + Vector3.new(0, 1, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, 1, 0) end
		if move.Magnitude > 0 then move = move.Unit * Config.Movement.FlySpeed end
		hrp.AssemblyLinearVelocity = move
		hrp.AssemblyAngularVelocity = Vector3.new()
		if hum then hum.WalkSpeed = Config.Movement.FlySpeed; hum.JumpPower = 0 end
	else
		if WasFlying then
			WasFlying = false
			restoreMoveState()
		end
	end

	-- Bhop
	if Config.Movement.BHop and hrp and hum then
		local wantJump = Config.Movement.BHopAlways or Keys.Space
		if wantJump and hum.FloorMaterial ~= Enum.Material.Air then
			pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
		end
	end

	-- Spinbot (character only)
	if Config.Movement.Spinbot and hrp then
		hrp.CFrame = hrp.CFrame * CFrame.Angles(0, Config.Movement.SpinSpeed * dt * 2, 0)
	end

	-- Third person
	if Config.Movement.ThirdPerson and hrp then
		pcall(function()
			Camera.CameraType = Enum.CameraType.Scriptable
			if Config.Movement.Spinbot then
				local camPos = hrp.Position + Vector3.new(0, 2, 0) + Vector3.new(0, 0, Config.Movement.ThirdDist)
				Camera.CFrame = CFrame.lookAt(camPos, hrp.Position)
			else
				Camera.CFrame = hrp.CFrame * CFrame.new(0, 2, Config.Movement.ThirdDist)
			end
		end)
	end
end)

-- =========================== Godmode ===========================
local function ensureGodmode()
	if not Config.Misc.Godmode then return end
	local char = LocalPlayer.Character
	if not char then return end
	if not char:FindFirstChildOfClass("ForceField") then
		local ff = Instance.new("ForceField")
		ff.Name = "ScriptForceField"
		ff.Parent = char
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.MaxHealth = 999999
		hum.Health = 999999
	end
end

-- =========================== Unlock all ===========================
local UnlockRan = false
local function unlockAll()
	if UnlockRan then return end
	UnlockRan = true
	local ok, data = pcall(function()
		return require(LocalPlayer.PlayerScripts.Start.Backend.DataClient).getData().Data
	end)
	if not ok then return end
	pcall(function()
		local names = {}
		local wm = requireCommon({ "Managers", "WeaponManager" })
		if wm and wm.getWeapons then
			for name in pairs(wm.getWeapons()) do
				if type(name) == "string" and not table.find(names, name) then
					table.insert(names, name)
				end
			end
		end
		local function fill(list)
			if type(list) ~= "table" then return end
			for _, n in ipairs(names) do
				if not table.find(list, n) then table.insert(list, n) end
			end
		end
		fill(data.primaries)
		fill(data.secondaries)
		pcall(function()
			if data.killEffects then
				fill(data.killEffects)
			end
		end)
		pcall(function()
			if data.nametags then
				fill(data.nametags)
			end
		end)
		-- refresh replicated signals so UI updates
		pcall(function()
			local rc = requireCommon({ "Components", "ReplicaClient" })
			if rc and rc.SetValues then
				rc.SetValues(data, { primaries = data.primaries, secondaries = data.secondaries })
			end
		end)
	end)
end

-- =========================== Upkeep loop ===========================
task.spawn(function()
	local lastScan = 0
	local lastMods = 0
	while not CleaningUp do
		task.wait(0.15)
		local now = os.clock()
		if now - lastScan > 2 then
			lastScan = now
			rebuildEntities()
		end
		if Config.Misc.Godmode then ensureGodmode() end
		if Config.Misc.UnlockAll then unlockAll() end
		if now - lastMods > 0.5 then
			lastMods = now
			if Config.Combat.RapidFire or Config.Combat.NoReload or Config.Combat.InfAmmo then
				applyWeaponMods()
			end
		end
		-- hitbox expander upkeep
		if Config.Combat.Hitbox then
			applyHitboxes()
			LastHitboxOff = false
		elseif not LastHitboxOff then
			LastHitboxOff = true
			restoreHitboxes()
		end
	end
end)

-- =========================== Character respawn handling ===========================
table.insert(Connections, LocalPlayer.CharacterAdded:Connect(function(char)
	task.defer(function()
		rebuildEntities()
		if Config.Misc.Godmode then ensureGodmode() end
	end)
end))

-- =========================== Cleanup ===========================
local function cleanup()
	CleaningUp = true
	for _, conn in ipairs(Connections) do
		pcall(conn.Disconnect, conn)
	end
	if NoclipConn then pcall(NoclipConn.Disconnect, NoclipConn); NoclipConn = nil end
	for _, name in ipairs({ "RF_AIM", "RF_COMBAT", "RF_ESP", "RF_FOV", "RF_MOVE" }) do
		RunService:UnbindFromRenderStep(name)
	end
	restoreWeaponHooks()
	restoreHitboxes()
	for char in pairs(ESPCache) do eRemove(char) end
	restoreMoveState()
	pcall(function() Camera.CameraType = Enum.CameraType.Custom end)
	pcall(function()
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("ScriptForceField") then
			LocalPlayer.Character.ScriptForceField:Destroy()
		end
	end)
	if WindowHandle then pcall(WindowHandle.Unload, WindowHandle) end
end

-- =========================== Rayfield Gen2 UI ===========================
local loadOK, Rayfield = pcall(function()
	return loadstring(game:HttpGet("https://sirius.menu/gen2"))()
end)
if not loadOK or type(Rayfield) ~= "table" then
	warn("[RF] Failed to load Rayfield Gen2:", loadOK and "bad return" or tostring(Rayfield))
	return
end

setupWeaponHooks()
rebuildEntities()

local WindowHandle = Rayfield:CreateWindow({
	name = "Rayfield AI Suite",
	subtitle = "One Tap - Aimbot / Combat / ESP / Movement",
	theme = "cobalt",
	configuration = {
		autoSave = true,
		autoLoad = true,
		fileName = "RayfieldAIM",
	},
})

local AimbotTab = WindowHandle:CreateTab({ name = "Aimbot", icon = 93364949241311 })
local CombatTab = WindowHandle:CreateTab({ name = "Combat", icon = 93364949241311 })
local MovementTab = WindowHandle:CreateTab({ name = "Movement", icon = 93364949241311 })
local ESPTab = WindowHandle:CreateTab({ name = "ESP", icon = 93364949241311 })
local MiscTab = WindowHandle:CreateTab({ name = "Misc", icon = 93364949241311 })
local SettingsTab = WindowHandle:CreateTab({ name = "Settings", icon = 93364949241311 })

-- =========================== Aimbot UI ===========================
AimbotTab:CreateSection({ name = "Aiming", icon = 93364949241311 })
AimbotTab:CreateToggle({
	name = "Enable Aimbot",
	value = Config.Aimbot.Enabled,
	flag = "aim_enable",
	callback = function(v) Config.Aimbot.Enabled = v end,
})
AimbotTab:CreateKeybind({
	name = "Hold to Aim",
	value = Enum.UserInputType.MouseButton2,
	hold = true,
	flag = "aim_key",
	callback = function(held) Config.Aimbot.Holding = held and true or false end,
})
AimbotTab:CreateToggle({
	name = "Team Check",
	value = Config.Aimbot.TeamCheck,
	flag = "aim_team",
	callback = function(v) Config.Aimbot.TeamCheck = v end,
})
AimbotTab:CreateToggle({
	name = "Ignore Bots",
	value = Config.Aimbot.IgnoreBots,
	flag = "aim_ignorebots",
	callback = function(v) Config.Aimbot.IgnoreBots = v end,
})
AimbotTab:CreateToggle({
	name = "Visibility Check",
	value = Config.Aimbot.VisCheck,
	flag = "aim_visible",
	callback = function(v) Config.Aimbot.VisCheck = v end,
})
AimbotTab:CreateDropdown({
	name = "Aim Part",
	options = { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "Random" },
	value = "Head",
	flag = "aim_part",
	callback = function(o) Config.Aimbot.AimPart = o end,
})
AimbotTab:CreateSlider({
	name = "Field of View (px)",
	range = { 10, 500 },
	increment = 1,
	value = Config.Aimbot.FOV,
	suffix = "px",
	flag = "aim_fov",
	callback = function(v) Config.Aimbot.FOV = v end,
})
AimbotTab:CreateSlider({
	name = "Smoothness",
	range = { 1, 100 },
	increment = 1,
	value = Config.Aimbot.Smoothness,
	suffix = "%",
	flag = "aim_smooth",
	callback = function(v) Config.Aimbot.Smoothness = v end,
})
AimbotTab:CreateSlider({
	name = "Max Distance",
	range = { 10, 2000 },
	increment = 10,
	value = Config.Aimbot.MaxDistance,
	suffix = "studs",
	flag = "aim_dist",
	callback = function(v) Config.Aimbot.MaxDistance = v end,
})
AimbotTab:CreateSection({ name = "FOV Circle", icon = 93364949241311 })
AimbotTab:CreateToggle({
	name = "Show FOV Circle",
	value = Config.FOV.Circle,
	flag = "fov_circle",
	callback = function(v) Config.FOV.Circle = v end,
})
AimbotTab:CreateColorPicker({
	name = "FOV Color",
	color = Config.FOV.Color,
	flag = "fov_color",
	callback = function(c) if c then Config.FOV.Color = c end end,
})

-- =========================== Combat UI ===========================
CombatTab:CreateSection({ name = "Aim", icon = 93364949241311 })
CombatTab:CreateToggle({
	name = "Silent Aim",
	description = "Redirects fired shots to the nearest target (bullet snaps to player).",
	value = Config.Combat.SilentAim,
	flag = "combat_silentaim",
	callback = function(v) Config.Combat.SilentAim = v end,
})
CombatTab:CreateToggle({
	name = "Wallbang",
	description = "Only matters vs servers that allow it. Shots ignore walls best-effort.",
	value = Config.Combat.Wallbang,
	flag = "combat_wallbang",
	callback = function(v) Config.Combat.Wallbang = v end,
})
CombatTab:CreateToggle({
	name = "Triggerbot",
	description = "Fires when crosshair is over an enemy.",
	value = Config.Combat.Triggerbot,
	flag = "combat_trigger",
	callback = function(v) Config.Combat.Triggerbot = v end,
})
CombatTab:CreateToggle({
	name = "Auto Shoot",
	description = "Automatically fires at the CPS rate.",
	value = Config.Combat.AutoShoot,
	flag = "combat_autoshoot",
	callback = function(v) Config.Combat.AutoShoot = v end,
})
CombatTab:CreateSlider({
	name = "CPS",
	range = { 1, 30 },
	increment = 1,
	value = Config.Combat.CPS,
	suffix = "/s",
	flag = "combat_cps",
	callback = function(v) Config.Combat.CPS = v end,
})
CombatTab:CreateSection({ name = "Gun Mods", icon = 93364949241311 })
CombatTab:CreateToggle({
	name = "Rapid Fire",
	value = Config.Combat.RapidFire,
	flag = "combat_rapid",
	callback = function(v) Config.Combat.RapidFire = v; if v then applyWeaponMods() end end,
})
CombatTab:CreateToggle({
	name = "No Reload",
	value = Config.Combat.NoReload,
	flag = "combat_noreload",
	callback = function(v) Config.Combat.NoReload = v; if v then applyWeaponMods() end end,
})
CombatTab:CreateToggle({
	name = "Infinite Ammo",
	value = Config.Combat.InfAmmo,
	flag = "combat_infammo",
	callback = function(v) Config.Combat.InfAmmo = v; if v then applyWeaponMods() end end,
})
CombatTab:CreateSection({ name = "Hitbox", icon = 93364949241311 })
CombatTab:CreateToggle({
	name = "Hitbox Expander",
	value = Config.Combat.Hitbox,
	flag = "combat_hitbox",
	callback = function(v) Config.Combat.Hitbox = v end,
})
CombatTab:CreateSlider({
	name = "Hitbox Size",
	range = { 1, 3 },
	increment = 0.05,
	value = Config.Combat.HitboxScale,
	suffix = "x",
	flag = "combat_hitboxscale",
	callback = function(v) Config.Combat.HitboxScale = v end,
})

-- =========================== Movement UI ===========================
MovementTab:CreateSection({ name = "Fly", icon = 93364949241311 })
MovementTab:CreateToggle({
	name = "Fly (Velocity)",
	value = Config.Movement.Fly,
	flag = "move_fly",
	callback = function(v) Config.Movement.Fly = v end,
})
MovementTab:CreateSlider({
	name = "Fly Speed",
	range = { 10, 250 },
	increment = 5,
	value = Config.Movement.FlySpeed,
	suffix = "studs/s",
	flag = "move_flyspeed",
	callback = function(v) Config.Movement.FlySpeed = v end,
})
MovementTab:CreateToggle({
	name = "Noclip",
	description = "Walk/fly through walls.",
	value = Config.Movement.Noclip,
	flag = "move_noclip",
	callback = function(v) Config.Movement.Noclip = v end,
})
MovementTab:CreateSection({ name = "Jump", icon = 93364949241311 })
MovementTab:CreateToggle({
	name = "Infinite Jump",
	value = Config.Movement.InfJump,
	flag = "move_infjump",
	callback = function(v) Config.Movement.InfJump = v end,
})
MovementTab:CreateSlider({
	name = "Jump Power",
	range = { 30, 300 },
	increment = 5,
	value = Config.Movement.JumpPower,
	suffix = "x",
	flag = "move_jumppower",
	callback = function(v) Config.Movement.JumpPower = v end,
})
MovementTab:CreateToggle({
	name = "Bunny Hop",
	value = Config.Movement.BHop,
	flag = "move_bhop",
	callback = function(v) Config.Movement.BHop = v end,
})
MovementTab:CreateToggle({
	name = "Auto Bhop",
	description = "Bhop without holding space.",
	value = Config.Movement.BHopAlways,
	flag = "move_bhopalways",
	callback = function(v) Config.Movement.BHopAlways = v end,
})
MovementTab:CreateSection({ name = "Camera", icon = 93364949241311 })
MovementTab:CreateToggle({
	name = "Spinbot",
	description = "Rotates your character (not camera).",
	value = Config.Movement.Spinbot,
	flag = "move_spinbot",
	callback = function(v) Config.Movement.Spinbot = v end,
})
MovementTab:CreateSlider({
	name = "Spin Speed",
	range = { 1, 10 },
	increment = 1,
	value = Config.Movement.SpinSpeed,
	suffix = "x",
	flag = "move_spinspeed",
	callback = function(v) Config.Movement.SpinSpeed = v end,
})
MovementTab:CreateToggle({
	name = "Third Person",
	value = Config.Movement.ThirdPerson,
	flag = "move_thirdperson",
	callback = function(v) Config.Movement.ThirdPerson = v end,
})
MovementTab:CreateSlider({
	name = "Third Person Distance",
	range = { 5, 25 },
	increment = 1,
	value = Config.Movement.ThirdDist,
	suffix = "studs",
	flag = "move_thirddist",
	callback = function(v) Config.Movement.ThirdDist = v end,
})

-- =========================== ESP UI ===========================
ESPTab:CreateSection({ name = "Display", icon = 93364949241311 })
ESPTab:CreateToggle({
	name = "Enable ESP",
	value = Config.ESP.Enabled,
	flag = "esp_enable",
	callback = function(v) Config.ESP.Enabled = v end,
})
ESPTab:CreateToggle({
	name = "Box",
	value = Config.ESP.Box,
	flag = "esp_box",
	callback = function(v) Config.ESP.Box = v end,
})
ESPTab:CreateToggle({
	name = "Name",
	value = Config.ESP.Name,
	flag = "esp_name",
	callback = function(v) Config.ESP.Name = v end,
})
ESPTab:CreateToggle({
	name = "Health Bar",
	value = Config.ESP.Health,
	flag = "esp_health",
	callback = function(v) Config.ESP.Health = v end,
})
ESPTab:CreateToggle({
	name = "Distance",
	value = Config.ESP.Distance,
	flag = "esp_dist",
	callback = function(v) Config.ESP.Distance = v end,
})
ESPTab:CreateToggle({
	name = "Tracer",
	value = Config.ESP.Tracer,
	flag = "esp_tracer",
	callback = function(v) Config.ESP.Tracer = v end,
})
ESPTab:CreateToggle({
	name = "Show Bots",
	value = Config.ESP.ShowBots,
	flag = "esp_showbots",
	callback = function(v) Config.ESP.ShowBots = v end,
})
ESPTab:CreateToggle({
	name = "Team Check",
	value = Config.ESP.TeamCheck,
	flag = "esp_team",
	callback = function(v) Config.ESP.TeamCheck = v end,
})
ESPTab:CreateSlider({
	name = "Max Distance",
	range = { 50, 5000 },
	increment = 50,
	value = Config.ESP.MaxDistance,
	suffix = "studs",
	flag = "esp_maxdist",
	callback = function(v) Config.ESP.MaxDistance = v end,
})
ESPTab:CreateSection({ name = "Colors", icon = 93364949241311 })
ESPTab:CreateColorPicker({
	name = "Enemy Color",
	color = Config.ESP.EnemyColor,
	flag = "esp_color_enemy",
	callback = function(c) if c then Config.ESP.EnemyColor = c end end,
})
ESPTab:CreateColorPicker({
	name = "Bot Color",
	color = Config.ESP.BotColor,
	flag = "esp_color_bot",
	callback = function(c) if c then Config.ESP.BotColor = c end end,
})
ESPTab:CreateColorPicker({
	name = "Tracer Color",
	color = Config.ESP.TracerColor,
	flag = "esp_color_tracer",
	callback = function(c) if c then Config.ESP.TracerColor = c end end,
})
ESPTab:CreateColorPicker({
	name = "Name Color",
	color = Config.ESP.NameColor,
	flag = "esp_color_name",
	callback = function(c) if c then Config.ESP.NameColor = c end end,
})

-- =========================== Misc UI ===========================
MiscTab:CreateSection({ name = "Utility", icon = 93364949241311 })
MiscTab:CreateToggle({
	name = "Unlock All",
	description = "Adds every weapon/knife/effect to your inventory (best-effort, client-side).",
	value = Config.Misc.UnlockAll,
	flag = "misc_unlockall",
	callback = function(v) Config.Misc.UnlockAll = v; if v then UnlockRan = false; unlockAll() end end,
})
MiscTab:CreateToggle({
	name = "Godmode",
	description = "ForceField + holds health at max.",
	value = Config.Misc.Godmode,
	flag = "misc_godmode",
	callback = function(v) Config.Misc.Godmode = v end,
})

-- =========================== Settings UI ===========================
SettingsTab:CreateSection({ name = "General", icon = 93364949241311 })
SettingsTab:CreateButton({
	name = "Rescan Targets",
	description = "Re-scan players and workspace models.",
	callback = function()
		rebuildEntities()
		WindowHandle:Toast({ title = "Rescan", subtitle = "Target list rebuilt." })
	end,
})
SettingsTab:CreateButton({
	name = "Unload Script",
	description = "Restores hooks, removes drawings, closes the interface.",
	callback = function()
		cleanup()
	end,
})
SettingsTab:CreateStat({
	name = "Load Status",
	value = "Ready",
})

rebuildEntities()
WindowHandle:Notify({
	title = "Rayfield AI Suite",
	content = "Loaded! Enabled per tab. Silent Aim redirects shots to the player.",
	duration = 5,
})

print("[RayfieldAI] Script loaded successfully.")
print(string.format("[RayfieldAI] Entities: %d", #Targets))