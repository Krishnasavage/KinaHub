-- ==============================================================================
-- AURORA HUB - FLUENT UI VERSION (FULL LOGIC INTEGRATION)
-- ==============================================================================


-- Cache all services at start for better performance
local Services = setmetatable({}, {
    __index = function(self, serviceName)
        local service = game:GetService(serviceName)
        rawset(self, serviceName, service)
        return service
    end
})

-- ========================================
-- SAVE SYSTEM (Optimized)
-- ========================================
local HttpService = Services.HttpService
local FolderName = "Aurora Hub"
local FileName = "Settings.json"
local FullPath = FolderName .. "/" .. FileName

if makefolder and not isfolder(FolderName) then
    makefolder(FolderName)
end

_G.SaveData = _G.SaveData or {}

function SaveSettings()
    if not writefile then return false end
    local success = pcall(function()
        local json = HttpService:JSONEncode(_G.SaveData)
        writefile(FullPath, json)
    end)
    return success
end

function LoadSettings()
    if not (isfile and isfile(FullPath)) then return false end
    local success, result = pcall(function()
        local content = readfile(FullPath)
        return HttpService:JSONDecode(content)
    end)
    if success and result then
        _G.SaveData = result
        return true
    end
    return false
end

function GetSetting(name, default)
    return _G.SaveData[name] ~= nil and _G.SaveData[name] or default
end

LoadSettings()

-- ========================================
-- AUTO KEN (Observation Haki)
-- ========================================
local Players = Services.Players
local CollectionService = Services.CollectionService
local ReplicatedStorage = Services.ReplicatedStorage

local player = Players.LocalPlayer
local commE = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommE")

_G.AutoKen = true

local function HasKen()
    local char = player.Character
    return char and CollectionService:HasTag(char, "Ken")
end

task.spawn(function()
    while _G.AutoKen do
        task.wait(0.2)
        if not HasKen() then
            pcall(function()
                commE:FireServer("Ken", true)
            end)
        end
    end
end)

-- ========================================
-- AUTO TEAM & LIGHTING
-- ========================================
local desiredTeam = "Marines"

if not player.Team or player.Team.Name ~= desiredTeam then
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", desiredTeam)
    end)
end

local Lighting = Services.Lighting

-- Full bright (optimized lighting)
Lighting.Ambient = Color3.new(0.695, 0.695, 0.695)
Lighting.ColorShift_Bottom = Color3.new(0.695, 0.695, 0.695)
Lighting.ColorShift_Top = Color3.new(0.695, 0.695, 0.695)
Lighting.Brightness = 2
Lighting.FogEnd = 1e10

-- ========================================
-- GLOBAL VARIABLES (Cached & Organized)
-- ========================================
do
    ply = Services.Players
    plr = ply.LocalPlayer
    Root = plr.Character.HumanoidRootPart
    replicated = Services.ReplicatedStorage
    Lv = plr.Data.Level.Value
    TeleportService = Services.TeleportService
    TW = Services.TweenService
    Lighting = Services.Lighting
    Enemies = workspace.Enemies
    vim1 = Services.VirtualInputManager
    vim2 = Services.VirtualUser
    TeamSelf = plr.Team
    RunSer = Services.RunService
    Stats = Services.Stats
    Energy = plr.Character.Energy.Value

    -- Tables
    Boss = {}
    BringConnections = {}
    MaterialList = {}
    NPCList = {}

    -- Flags
    shouldTween = false
    SoulGuitar = false
    KenTest = true
    debug = false
    Brazier1 = false
    Brazier2 = false
    Brazier3 = false
    Sec = 0.1
    ClickState = 0
    Num_self = 25
end

-- Wait for game to load
repeat
    local loading = plr.PlayerGui:FindFirstChild("Main")
    loading = loading and loading:FindFirstChild("Loading")
    task.wait()
until game:IsLoaded() and not (loading and loading.Visible)
-- World Detection (Optimized)
local placeId = game.PlaceId
if placeId == 2753915549 or placeId == 85211729168715 then
    World1 = true
elseif placeId == 4442272183 or placeId == 79091703265657 then
    World2 = true
elseif placeId == 7449423635 or placeId == 100117331123089 then
    World3 = true
else
    plr:Kick("❌ Error Blox Fruits - World not recognized")
end

Sea = World1 or World2 or World3

Marines = function()
    replicated.Remotes.CommF_:InvokeServer("SetTeam", "Marines")
end

Pirates = function()
    replicated.Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
end
if World1 then
	Boss = {
			"The Gorilla King",
			"Bobby",
			"The Saw",
			"Yeti",
			"Mob Leader",
			"Vice Admiral",
			"Saber Expert",
			"Warden",
			"Chief Warden",
			"Swan",
			"Magma Admiral",
			"Fishman Lord",
			"Wysper",
			"Thunder God",
			"Cyborg",
			"Ice Admiral",
			"Greybeard",
		};
elseif World2 then
	Boss = {
			"Diamond",
			"Jeremy",
			"Fajita",
			"Don Swan",
			"Smoke Admiral",
			"Awakened Ice Admiral",
			"Tide Keeper",
			"Darkbeard",
			"Cursed Captain",
			"Order",
		};
elseif World3 then
	Boss = {
			"Stone",
			"Hydra Leader",
			"Kilo Admiral",
			"Captain Elephant",
			"Beautiful Pirate",
			"Cake Queen",
			"Longma",
			"Soul Reaper",
		};
end;
if World1 then
	MaterialList = {
			"Leather + Scrap Metal",
			"Angel Wings",
			"Magma Ore",
			"Fish Tail",
		};
elseif World2 then
	MaterialList = {
			"Leather + Scrap Metal",
			"Radioactive Material",
			"Ectoplasm",
			"Mystic Droplet",
			"Magma Ore",
			"Vampire Fang",
		};
elseif World3 then
	MaterialList = {
			"Scrap Metal",
			"Demonic Wisp",
			"Conjured Cocoa",
			"Dragon Scale",
			"Gunpowder",
			"Fish Tail",
			"Mini Tusk",
		};
end;
local e = {
		"Flame",
		"Ice",
		"Quake",
		"Light",
		"Dark",
		"String",
		"Rumble",
		"Magma",
		"Human: Buddha",
		"Sand",
		"Bird: Phoenix",
		"Dough",
	};
local K = {
		"Snow Lurker",
		"Arctic Warrior",
		"Hidden Key",
		"Awakened Ice Admiral",
	};
local n = {
		Mob = "Mythological Pirate",
		Mob2 = "Cursed Skeleton",
		"Hell\'s Messenger",
		Mob3 = "Cursed Skeleton",
		"Heaven\'s Guardian",
	};
local d = {
		"Part",
		"SpawnLocation",
		"Terrain",
		"WedgePart",
		"MeshPart",
	};
local z = { "Swan Pirate", "Jeremy" };
local H = { "Forest Pirate", "Captain Elephant" };
local F = { "Fajita", "Jeremy", "Diamond" };
local Q = {
		"Beast Hunter",
		"Lantern",
		"Guardian",
		"Grand Brigade",
		"Dinghy",
		"Sloop",
		"The Sentinel",
	};
local X = { "Cookie Crafter", "Head Baker", "Baking Staff", "Cake Guard" };
local P = { "Reborn Skeleton", "Posessed Mummy", "Demonic Soul", "Living Zombie" };
local w = {
		["Pirate Millionaire"] = CFrame.new(-712.82727050781, 98.577049255371, 5711.9541015625),
		["Pistol Billionaire"] = CFrame.new(-723.43316650391, 147.42906188965, 5931.9931640625),
		["Dragon Crew Warrior"] = CFrame.new(7021.5043945312, 55.762702941895, -730.12908935547),
		["Dragon Crew Archer"] = CFrame.new(6625, 378, 244),
		["Female Islander"] = CFrame.new(4692.7939453125, 797.97668457031, 858.84802246094),
		["Venomous Assailant"] = CFrame.new(4902, 670, 39),
		["Marine Commodore"] = CFrame.new(2401, 123, -7589),
		["Marine Rear Admiral"] = CFrame.new(3588, 229, -7085),
		["Fishman Raider"] = CFrame.new(-10941, 332, -8760),
		["Fishman Captain"] = CFrame.new(-11035, 332, -9087),
		["Forest Pirate"] = CFrame.new(-13446, 413, -7760),
		["Mythological Pirate"] = CFrame.new(-13510, 584, -6987),
		["Jungle Pirate"] = CFrame.new(-11778, 426, -10592),
		["Musketeer Pirate"] = CFrame.new(-13282, 496, -9565),
		["Reborn Skeleton"] = CFrame.new(-8764, 142, 5963),
		["Living Zombie"] = CFrame.new(-10227, 421, 6161),
		["Demonic Soul"] = CFrame.new(-9579, 6, 6194),
		["Posessed Mummy"] = CFrame.new(-9579, 6, 6194),
		["Peanut Scout"] = CFrame.new(-1993, 187, -10103),
		["Peanut President"] = CFrame.new(-2215, 159, -10474),
		["Ice Cream Chef"] = CFrame.new(-877, 118, -11032),
		["Ice Cream Commander"] = CFrame.new(-877, 118, -11032),
		["Cookie Crafter"] = CFrame.new(-2021, 38, -12028),
		["Cake Guard"] = CFrame.new(-2024, 38, -12026),
		["Baking Staff"] = CFrame.new(-1932, 38, -12848),
		["Head Baker"] = CFrame.new(-1932, 38, -12848),
		["Cocoa Warrior"] = CFrame.new(95, 73, -12309),
		["Chocolate Bar Battler"] = CFrame.new(647, 42, -12401),
		["Sweet Thief"] = CFrame.new(116, 36, -12478),
		["Candy Rebel"] = CFrame.new(47, 61, -12889),
		Ghost = CFrame.new(5251, 5, 1111),
	};
EquipWeapon = function(I)
		if not I then
			return;
		end;
		if plr.Backpack:FindFirstChild(I) then
			plr.Character.Humanoid:EquipTool(plr.Backpack:FindFirstChild(I));
		end;
	end;
weaponSc = function(I)
		for e, K in pairs(plr.Backpack:GetChildren()) do
			if K:IsA("Tool") then
				if K.ToolTip == I then
					EquipWeapon(K.Name);
				end;
			end;
		end;
	end;
hookfunction(require((game:GetService("ReplicatedStorage")).Effect.Container.Death), function()

end);
hookfunction((require((game:GetService("ReplicatedStorage")):WaitForChild("GuideModule"))).ChangeDisplayedNPC, function()

end);
hookfunction(error, function()

end);
hookfunction(warn, function()

end);
local O = workspace:FindFirstChild("Rocks");
if O then
	O:Destroy();
end;
gay = (function()
    local I = game:GetService("Lighting");
    local e = I:FindFirstChild("LightingLayers");

    -- NÃO remover DarkFog

    local K = workspace._WorldOrigin["Foam;"];
    if K and workspace._WorldOrigin["Foam;"] then
        K:Destroy();
    end;
end)();

local G = {};
G.__index = G;
G.Alive = function(I)
		if not I then
			return;
		end;
		local e = I:FindFirstChild("Humanoid");
		return e and e.Health > 0;
	end;
G.Pos = function(I, e)
		return (Root.Position - mode.Position).Magnitude <= e;
	end;
G.Dist = function(I, e)
		return (Root.Position - (I:FindFirstChild("HumanoidRootPart")).Position).Magnitude <= e;
	end;
G.DistH = function(I, e)
		return (Root.Position - (I:FindFirstChild("HumanoidRootPart")).Position).Magnitude > e;
	end;
-- ALTURA ÚNICA AJUSTÁVEL DO MOB
_G.MobHeight = _G.MobHeight or 30

G.Kill = function(I, e)
	if not (I and e) then return end

	local hrp = I:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	-- trava posição do mob
	if not I:GetAttribute("Locked") then
		I:SetAttribute("Locked", hrp.CFrame)
	end

	-- posição alvo do bring
	PosMon = (I:GetAttribute("Locked")).Position

	-- >>> FORÇA O BRING <<<
	_B = true
	BringEnemy()

	-- equipa arma
	EquipWeapon(_G.SelectWeapon)

	local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
	if not tool then return end

	-- TP acima do mob (altura única)
	_tp(hrp.CFrame * CFrame.new(0, _G.MobHeight, 0))
end
G.Kill2 = function(I, e)
		if I and e then
			if not I:GetAttribute("Locked") then
				I:SetAttribute("Locked", I.HumanoidRootPart.CFrame);
			end;
			PosMon = (I:GetAttribute("Locked")).Position;
			BringEnemy();
			EquipWeapon(_G.SelectWeapon);
			local e = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool");
			local K = e.ToolTip;
			if K == "Blox Fruit" then
				_tp((I.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)) * CFrame.Angles(0, math.rad(90), 0));
			else
				_tp((I.HumanoidRootPart.CFrame * CFrame.new(0, 20, 8)) * CFrame.Angles(0, math.rad(180), 0));
			end;
			if RandomCFrame then
				wait(.1);
				_tp(I.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25));
				wait(.1);
				_tp(I.HumanoidRootPart.CFrame * CFrame.new(25, 30, 0));
				wait(.1);
				_tp(I.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0));
				wait(.1);
				_tp(I.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25));
				wait(.1);
				_tp(I.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0));
			end;
		end;
	end;
G.KillSea = function(I, e)
		if I and e then
			if not I:GetAttribute("Locked") then
				I:SetAttribute("Locked", I.HumanoidRootPart.CFrame);
			end;
			PosMon = (I:GetAttribute("Locked")).Position;
			BringEnemy();
			EquipWeapon(_G.SelectWeapon);
			local e = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool");
			local K = e.ToolTip;
			if K == "Blox Fruit" then
				_tp((I.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)) * CFrame.Angles(0, math.rad(90), 0));
			else
				notween(I.HumanoidRootPart.CFrame * CFrame.new(0, 50, 8));
				wait(.85);
				notween(I.HumanoidRootPart.CFrame * CFrame.new(0, 400, 0));
				wait(1);
			end;
		end;
	end;
G.Sword = function(I, e)
		if I and e then
			if not I:GetAttribute("Locked") then
				I:SetAttribute("Locked", I.HumanoidRootPart.CFrame);
			end;
			PosMon = (I:GetAttribute("Locked")).Position;
			BringEnemy();
			weaponSc("Sword");
			_tp(I.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0));
			if RandomCFrame then
				wait(.1);
				_tp(I.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25));
				wait(.1);
				_tp(I.HumanoidRootPart.CFrame * CFrame.new(25, 30, 0));
				wait(.1);
				_tp(I.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0));
				wait(.1);
				_tp(I.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25));
				wait(.1);
				_tp(I.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0));
			end;
		end;
	end;
-- CONTROLE DE SKILLS DA FRUTA (MAESTRIA)
_G.FruitSkills = {
    Z = false,
    X = false,
    C = false,
    V = false,
    F = false
}

UseFruitSkills = function()
    weaponSc("Blox Fruit")

    if _G.FruitSkills.Z then
        Useskills("Blox Fruit", "Z")
    end
    if _G.FruitSkills.X then
        Useskills("Blox Fruit", "X")
    end
    if _G.FruitSkills.C then
        Useskills("Blox Fruit", "C")
    end
    if _G.FruitSkills.V then
        Useskills("Blox Fruit", "V")
    end
    if _G.FruitSkills.F then
        vim1:SendKeyEvent(true, "F", false, game)
        vim1:SendKeyEvent(false, "F", false, game)
    end
end

G.Mas = function(I, e)
		if I and e then
			if not I:GetAttribute("Locked") then
				I:SetAttribute("Locked", I.HumanoidRootPart.CFrame);
			end;
			PosMon = (I:GetAttribute("Locked")).Position;
			BringEnemy();
			if I.Humanoid.Health <= HealthM then
				_tp(I.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0));
				UseFruitSkills()
			else
				weaponSc("Melee");
				_tp(I.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0));
			end;
		end;
	end;
G.Masgun = function(I, e)
		if I and e then
			if not I:GetAttribute("Locked") then
				I:SetAttribute("Locked", I.HumanoidRootPart.CFrame);
			end;
			PosMon = (I:GetAttribute("Locked")).Position;
			BringEnemy();
			if I.Humanoid.Health <= HealthM then
				_tp(I.HumanoidRootPart.CFrame * CFrame.new(0, 35, 8));
				Useskills("Gun", "Z");
				Useskills("Gun", "X");
			else
				weaponSc("Melee");
				_tp(I.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0));
			end;
		end;
	end;
statsSetings = function(I, e)
		if I == "Melee" then
			if plr.Data.Points.Value ~= 0 then
				replicated.Remotes.CommF_:InvokeServer("AddPoint", "Melee", e);
			end;
		elseif I == "Defense" then
			if plr.Data.Points.Value ~= 0 then
				replicated.Remotes.CommF_:InvokeServer("AddPoint", "Defense", e);
			end;
		elseif I == "Sword" then
			if plr.Data.Points.Value ~= 0 then
				replicated.Remotes.CommF_:InvokeServer("AddPoint", "Sword", e);
			end;
		elseif I == "Gun" then
			if plr.Data.Points.Value ~= 0 then
				replicated.Remotes.CommF_:InvokeServer("AddPoint", "Gun", e);
			end;
		elseif I == "Devil" then
			if plr.Data.Points.Value ~= 0 then
				replicated.Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", e);
			end;
		end;
	end;




--==================================================
-- VARIÁVEIS DE CONTROLE NECESSÁRIAS
--==================================================
_G = _G or {}

_B = false
PosMon = nil

_G.BringRange = _G.BringRange or 250
_G.MaxBringMobs = _G.MaxBringMobs or 15 -- LIMITE DE MOBS

_G.FarmPriorityElf = _G.FarmPriorityElf or false
_G.FarmMastery_S   = _G.FarmMastery_S or false

local TweenService = game:GetService("TweenService")
local TweenInfoBring = TweenInfo.new(
    0.50, -- velocidade do tween
    Enum.EasingStyle.Linear,
    Enum.EasingDirection.Out
)

--==================================================
-- FUNÇÃO: VERIFICA SE QUALQUER FARM ESTÁ ATIVO
--==================================================
local function FarmAtivo()
    -- PRIORIDADE ABSOLUTA (ELF)
    if _G.FarmPriorityElf or _G.FarmElfLevelCustom then
        return true
    end

    -- AUTO MASTERY ALL SWORD (INDEPENDENTE DO START FARM)
    if _G.FarmMastery_S then
        return true
    end

    -- OUTROS FARMS (DEPENDENTES DO START FARM)
    return _G.StartFarm and (
        _G.Level or
        _G.AutoFarm_Bone or
        _G.AutoFarm_Cake or
        _G.FarmMastery_Dev or
        _G.FarmMastery_G or
        (getgenv()).AutoMaterial or
        _G.AutoTyrant or
        _G.SailBoat_Hydra or _G.WardenBoss or _G.AutoFactory or _G.HighestMirage or _G.HCM or _G.PGB or _G.Leviathan1 or _G.UPGDrago or _G.Complete_Trials or _G.TpDrago_Prehis or _G.BuyDrago or _G.AutoFireFlowers or _G.DT_Uzoth or _G.AutoBerry or _G.Prehis_Find or _G.Prehis_Skills or _G.Prehis_DB or _G.Prehis_DE or _G.FarmBlazeEM or _G.Dojoo or _G.CollectPresent or _G.AutoLawKak or _G.TpLab or _G.AutoPhoenixF or _G.AutoFarmChest or _G.AutoHytHallow or _G.LongsWord or _G.BlackSpikey or _G.AutoHolyTorch or _G.TrainDrago or _G.AutoSaber or _G.FarmMastery_Dev or _G.CitizenQuest or _G.AutoEctoplasm or _G.KeysRen or _G.Auto_Rainbow_Haki or _G.obsFarm or _G.AutoBigmom or _G.Doughv2 or _G.AuraBoss or _G.Raiding or _G.Auto_Cavender or _G.TpPly or _G.Bartilo_Quest or _G.Level or _G.FarmEliteHunt or _G.AutoZou or _G.AutoFarm_Bone or (getgenv()).AutoMaterial or _G.CraftVM or _G.FrozenTP or _G.TPDoor or _G.AcientOne or _G.AutoFarmNear or _G.AutoRaidCastle or _G.DarkBladev3 or _G.AutoFarmRaid or _G.Auto_Cake_Prince or _G.Addealer or _G.TPNpc or _G.TwinHook or _G.FindMirage or _G.FarmChestM or _G.Shark or _G.TerrorShark or _G.Piranha or _G.MobCrew or _G.SeaBeast1 or _G.FishBoat or _G.Auto or _G.AutoPoleV2 or _G.Auto_SuperHuman or _G.AutoDeathStep or _G.Auto_SharkMan_Karate or _G.Auto_Electric_Claw or _G.AutoDragonTalon or _G.Auto_Def_DarkCoat or _G.Auto_God_Human or _G.Auto_Tushita or _G.AutoMatSoul or _G.AutoKenVTWO or _G.AutoSerpentBow or _G.AutoFMon or _G.Auto_Soul_Guitar or _G.TPGEAR or _G.AutoSaw or _G.AutoTridentW2 or _G.Auto_StartRaid or _G.AutoEvoRace or _G.AutoGetQuestBounty or _G.MarinesCoat or _G.TravelDres or _G.Defeating or _G.DummyMan or _G.Auto_Yama or _G.Auto_SwanGG or _G.SwanCoat or _G.AutoEcBoss or _G.Auto_Mink or _G.Auto_Human or _G.Auto_Skypiea or _G.Auto_Fish or _G.CDK_TS or _G.CDK_YM or _G.CDK or _G.AutoFarmGodChalice or _G.AutoFistDarkness or _G.AutoMiror or _G.Teleport or _G.AutoKilo or _G.AutoGetUsoap or _G.Praying or _G.TryLucky or _G.AutoColShad or _G.AutoUnHaki or _G.Auto_DonAcces or _G.AutoRipIngay or _G.DragoV3 or _G.DragoV1 or _G.SailBoats or NextIs or _G.FarmGodChalice or _G.IceBossRen or senth or senth2 or _G.Lvthan or _G.beasthunter or _G.DangerLV or _G.Relic123 or _G.tweenKitsune or _G.Collect_Ember or _G.AutofindKitIs or _G.snaguine or _G.TwFruits or _G.tweenKitShrine or _G.Tp_LgS or _G.Tp_MasterA or _G.tweenShrine or _G.FarmMastery_G or _G.FarmMastery_S
    )
end

--==================================================
-- FUNÇÃO: IGNORA MOBS INDESEJADOS
--==================================================
local function IsRaidMob(mob)
    local n = mob.Name:lower()

    if n:find("raid") or n:find("microchip") or n:find("island") then
        return true
    end

    if mob:GetAttribute("IsRaid")
        or mob:GetAttribute("RaidMob")
        or mob:GetAttribute("IsBoss") then
        return true
    end

    local hum = mob:FindFirstChild("Humanoid")
    if hum and hum.WalkSpeed == 0 then
        return true
    end

    if mob.Parent and tostring(mob.Parent):lower():find("_worldorigin") then
        return true
    end

    return false
end

--==================================================
-- FUNÇÃO PRINCIPAL: BRING
--==================================================
BringEnemy = function()
    if not FarmAtivo() or not _B then return end

    local plr = game.Players.LocalPlayer
    local char = plr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Simulation Radius
    pcall(function()
        sethiddenproperty(plr, "SimulationRadius", math.huge)
    end)

    local targetPos = PosMon or hrp.Position
    local enemies = workspace.Enemies:GetChildren()
    local count = 0

    for _, mob in ipairs(enemies) do
        if count >= _G.MaxBringMobs then break end

        local hum = mob:FindFirstChild("Humanoid")
        local root = mob:FindFirstChild("HumanoidRootPart")

        if hum and root and hum.Health > 0 and not IsRaidMob(mob) then
            local dist = (root.Position - targetPos).Magnitude

            if dist <= _G.BringRange and not root:GetAttribute("Tweening") then
                count += 2
                root:SetAttribute("Tweening", true)

                local tween = TweenService:Create(
                    root,
                    TweenInfoBring,
                    { CFrame = CFrame.new(targetPos) }
                )

                tween:Play()
                tween.Completed:Once(function()
                    if root then
                        root:SetAttribute("Tweening", false)
                    end
                end)
            end
        end
    end
end

--==================================================
-- LOOP CONTROLADOR
--==================================================
task.spawn(function()
    while task.wait(1) do
        if FarmAtivo() then
            _B = true
            BringEnemy()
            task.wait(1)
            _B = false
            task.wait(1)
        else
            _B = false
            task.wait(1)
        end
    end
end)
Useskills = function(I, e)
		if I == "Melee" then
			weaponSc("Melee");
			if e == "Z" then
				vim1:SendKeyEvent(true, "Z", false, game);
				vim1:SendKeyEvent(false, "Z", false, game);
			elseif e == "X" then
				vim1:SendKeyEvent(true, "X", false, game);
				vim1:SendKeyEvent(false, "X", false, game);
			elseif e == "C" then
				vim1:SendKeyEvent(true, "C", false, game);
				vim1:SendKeyEvent(false, "C", false, game);
			end;
		elseif I == "Sword" then
			weaponSc("Sword");
			if e == "Z" then
				vim1:SendKeyEvent(true, "Z", false, game);
				vim1:SendKeyEvent(false, "Z", false, game);
			elseif e == "X" then
				vim1:SendKeyEvent(true, "X", false, game);
				vim1:SendKeyEvent(false, "X", false, game);
			end;
		elseif I == "Blox Fruit" then
			weaponSc("Blox Fruit");
			if e == "Z" then
				vim1:SendKeyEvent(true, "Z", false, game);
				vim1:SendKeyEvent(false, "Z", false, game);
			elseif e == "X" then
				vim1:SendKeyEvent(true, "X", false, game);
				vim1:SendKeyEvent(false, "X", false, game);
			elseif e == "C" then
				vim1:SendKeyEvent(true, "C", false, game);
				vim1:SendKeyEvent(false, "C", false, game);
			elseif e == "V" then
				vim1:SendKeyEvent(true, "V", false, game);
				vim1:SendKeyEvent(false, "V", false, game);
			end;
		elseif I == "Gun" then
			weaponSc("Gun");
			if e == "Z" then
				vim1:SendKeyEvent(true, "Z", false, game);
				vim1:SendKeyEvent(false, "Z", false, game);
			elseif e == "X" then
				vim1:SendKeyEvent(true, "X", false, game);
				vim1:SendKeyEvent(false, "X", false, game);
			end;
		end;
		if I == "nil" and e == "Y" then
			vim1:SendKeyEvent(true, "Y", false, game);
			vim1:SendKeyEvent(false, "Y", false, game);
		end;
	end;
local J = getrawmetatable(game);
local i = J.__namecall;
setreadonly(J, false);
J.__namecall = newcclosure(function(...)
		local I = getnamecallmethod();
		local e = { ... };
		if tostring(I) == "FireServer" then
			if tostring(e[1]) == "RemoteEvent" then
				if tostring(e[2]) ~= "true" and tostring(e[2]) ~= "false" then
					if _G.FarmMastery_G and not SoulGuitar or _G.FarmMastery_Dev or _G.FarmBlazeEM or _G.Prehis_Skills or _G.SeaBeast1 or _G.FishBoat or _G.PGB or _G.Leviathan1 or _G.Complete_Trials or _G.AimMethod and ABmethod == "AimBots Skill" or _G.AimMethod and ABmethod == "Auto Aimbots" then
						e[2] = MousePos;
						return i(unpack(e));
					end;
				end;
			end;
		end;
		return i(...);
	end);
GetConnectionEnemies = function(I)
		for e, K in pairs(replicated:GetChildren()) do
			if K:IsA("Model") and ((typeof(I) == "table" and table.find(I, K.Name) or K.Name == I) and (K:FindFirstChild("Humanoid") and K.Humanoid.Health > 0)) then
				return K;
			end;
		end;
		for e, K in next, game.Workspace.Enemies:GetChildren() do
			if K:IsA("Model") and ((typeof(I) == "table" and table.find(I, K.Name) or K.Name == I) and (K:FindFirstChild("Humanoid") and K.Humanoid.Health > 0)) then
				return K;
			end;
		end;
	end;
LowCpu = function()
		local I = true;
		local e = game;
		local K = e.Workspace;
		local n = e.Lighting;
		local d = K.Terrain;
		d.WaterWaveSize = 0;
		d.WaterWaveSpeed = 0;
		d.WaterReflectance = 0;
		d.WaterTransparency = 0;
		n.GlobalShadows = false;
		n.FogEnd = 9000000000.0;
		n.Brightness = 1;
		(settings()).Rendering.QualityLevel = "Level01";
		for e, K in pairs(e:GetDescendants()) do
			if K:IsA("Part") or K:IsA("Union") or K:IsA("CornerWedgePart") or K:IsA("TrussPart") then
				K.Material = "Plastic";
				K.Reflectance = 0;
			elseif K:IsA("Decal") or K:IsA("Texture") and I then
				K.Transparency = 1;
			elseif K:IsA("ParticleEmitter") or K:IsA("Trail") then
				K.Lifetime = NumberRange.new(0);
			elseif K:IsA("Explosion") then
				K.BlastPressure = 1;
				K.BlastRadius = 1;
			elseif K:IsA("Fire") or K:IsA("SpotLight") or K:IsA("Smoke") or K:IsA("Sparkles") then
				K.Enabled = false;
			elseif K:IsA("MeshPart") then
				K.Material = "Plastic";
				K.Reflectance = 0;
				K.TextureID = 10385902758728957;
			end;
		end;
		for I, e in pairs(n:GetChildren()) do
			if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
				e.Enabled = false;
			end;
		end;
	end;
CheckF = function()
		if GetBP("Dragon-Dragon") or GetBP("Gas-Gas") or GetBP("Yeti-Yeti") or GetBP("Kitsune-Kitsune") or GetBP("T-Rex-T-Rex") then
			return true;
		end;
	end;
CheckBoat = function()
		for I, e in pairs(workspace.Boats:GetChildren()) do
			if tostring(e.Owner.Value) == tostring(plr.Name) then
				return e;
			end;
		end;
		return false;
	end;
CheckEnemiesBoat = function()
		for I, e in pairs(workspace.Enemies:GetChildren()) do
			if e.Name == "FishBoat" and (e:FindFirstChild("Health")).Value > 0 then
				return true;
			end;
		end;
		return false;
	end;
CheckPirateGrandBrigade = function()
		for I, e in pairs(workspace.Enemies:GetChildren()) do
			if (e.Name == "PirateGrandBrigade" or e.Name == "PirateBrigade") and (e:FindFirstChild("Health")).Value > 0 then
				return true;
			end;
		end;
		return false;
	end;
CheckShark = function()
		for I, e in pairs(workspace.Enemies:GetChildren()) do
			if e.Name == "Shark" and G.Alive(e) then
				return true;
			end;
		end;
		return false;
	end;
CheckTerrorShark = function()
		for I, e in pairs(workspace.Enemies:GetChildren()) do
			if e.Name == "Terrorshark" and G.Alive(e) then
				return true;
			end;
		end;
		return false;
	end;
CheckPiranha = function()
		for I, e in pairs(workspace.Enemies:GetChildren()) do
			if e.Name == "Piranha" and G.Alive(e) then
				return true;
			end;
		end;
		return false;
	end;
CheckFishCrew = function()
		for I, e in pairs(workspace.Enemies:GetChildren()) do
			if (e.Name == "Fish Crew Member" or e.Name == "Haunted Crew Member") and G.Alive(e) then
				return true;
			end;
		end;
		return false;
	end;
CheckHauntedCrew = function()
		for I, e in pairs(workspace.Enemies:GetChildren()) do
			if e.Name == "Haunted Crew Member" and G.Alive(e) then
				return true;
			end;
		end;
		return false;
	end;
CheckSeaBeast = function()
		if workspace.SeaBeasts:FindFirstChild("SeaBeast1") then
			return true;
		end;
		return false;
	end;
CheckLeviathan = function()
		if workspace.SeaBeasts:FindFirstChild("Leviathan") then
			return true;
		end;
		return false;
	end;
UpdStFruit = function()
		for I, e in next, plr.Backpack:GetChildren() do
			StoreFruit = e:FindFirstChild("EatRemote", true);
			if StoreFruit then
				replicated.Remotes.CommF_:InvokeServer("StoreFruit", StoreFruit.Parent:GetAttribute("OriginalName"), plr.Backpack:FindFirstChild(e.Name));
			end;
		end;
	end;
collectFruits = function(I)
		if I then
			local I = plr.Character;
			for e, K in pairs(workspace:GetChildren()) do
				if string.find(K.Name, "Fruit") then
					K.Handle.CFrame = I.HumanoidRootPart.CFrame;
				end;
			end;
		end;
	end;
Getmoon = function()
		if World1 then
			return Lighting.FantasySky.MoonTextureId;
		elseif World2 then
			return Lighting.FantasySky.MoonTextureId;
		elseif World3 then
			return Lighting.Sky.MoonTextureId;
		end;
	end;
DropFruits = function()
		for I, e in next, plr.Backpack:GetChildren() do
			if string.find(e.Name, "Fruit") then
				EquipWeapon(e.Name);
				wait(.1);
				if plr.PlayerGui.Main.Dialogue.Visible == true then
					plr.PlayerGui.Main.Dialogue.Visible = false;
				end;
				EquipWeapon(e.Name);
				(plr.Character:FindFirstChild(e.Name)).EatRemote:InvokeServer("Drop");
			end;
		end;
		for I, e in pairs(plr.Character:GetChildren()) do
			if string.find(e.Name, "Fruit") then
				EquipWeapon(e.Name);
				wait(.1);
				if plr.PlayerGui.Main.Dialogue.Visible == true then
					plr.PlayerGui.Main.Dialogue.Visible = false;
				end;
				EquipWeapon(e.Name);
				(plr.Character:FindFirstChild(e.Name)).EatRemote:InvokeServer("Drop");
			end;
		end;
	end;
GetBP = function(I)
		return plr.Backpack:FindFirstChild(I) or plr.Character:FindFirstChild(I);
	end;
GetIn = function(I)
		for e, K in pairs(replicated.Remotes.CommF_:InvokeServer("getInventory")) do
			if type(K) == "table" then
				if K.Name == I or plr.Character:FindFirstChild(I) or plr.Backpack:FindFirstChild(I) then
					return true;
				end;
			end;
		end;
		return false;
	end;
GetM = function(I)
		for e, K in pairs(replicated.Remotes.CommF_:InvokeServer("getInventory")) do
			if type(K) == "table" then
				if K.Type == "Material" then
					if K.Name == I then
						return K.Count;
					end;
				end;
			end;
		end;
		return 0;
	end;
GetWP = function(I)
		for e, K in pairs(replicated.Remotes.CommF_:InvokeServer("getInventory")) do
			if type(K) == "table" then
				if K.Type == "Sword" then
					if K.Name == I or plr.Character:FindFirstChild(I) or plr.Backpack:FindFirstChild(I) then
						return true;
					end;
				end;
			end;
		end;
		return false;
	end;
getInfinity_Ability = function(I, e)
		if not Root then
			return;
		end;
		if I == "Soru" and e then
			for I, K in next, getgc() do
				if plr.Character.Soru then
					if typeof(K) == "function" and (getfenv(K)).script == plr.Character.Soru then
						for I, K in next, getupvalues(K) do
							if typeof(K) == "table" then
								repeat
									wait(Sec);
									K.LastUse = 0;
								until not e or plr.Character.Humanoid.Health <= 0;
							end;
						end;
					end;
				end;
			end;
		elseif I == "Energy" and e then
			plr.Character.Energy.Changed:connect(function()
				if e then
					plr.Character.Energy.Value = Energy;
				end;
			end);
		elseif I == "Observation" and e then
			local I = plr.VisionRadius;
			I.Value = math.huge;
		end;
	end;
Hop = function()
		pcall(function()
			for I = math.random(1, math.random(40, 75)), 100, 1 do
				local e = replicated.__ServerBrowser:InvokeServer(I);
				for I, e in next, e do
					if tonumber(e.Count) < 12 then
						TeleportService:TeleportToPlaceInstance(game.PlaceId, I);
					end;
				end;
			end;
		end);
	end;
local C = Instance.new("Part", workspace);
C.Size = Vector3.new(1, 1, 1);
C.Name = "Rip_Indra";
C.Anchored = true;
C.CanCollide = false;
C.CanTouch = false;
C.Transparency = 1;

local M = workspace:FindFirstChild(C.Name);
if M and M ~= C then
	M:Destroy();
end;

task.spawn(function()
	while task.wait() do
		if C and C.Parent == workspace then
			if shouldTween then
				(getgenv()).OnFarm = true;
			else
				(getgenv()).OnFarm = false;
			end;
		else
			(getgenv()).OnFarm = false;
		end;
	end;
end);

task.spawn(function()
	local I = game.Players.LocalPlayer;
	repeat task.wait() until I.Character and I.Character.PrimaryPart;

	C.CFrame = I.Character.PrimaryPart.CFrame;

	while task.wait() do
		pcall(function()
			if (getgenv()).OnFarm then
				if C and C.Parent == workspace then
					local e = I.Character and I.Character.PrimaryPart;
					if e and (e.Position - C.Position).Magnitude <= 200 then
						e.CFrame = C.CFrame;
					else
						C.CFrame = e.CFrame;
					end;
				end;

				local e = I.Character;
				if e then
					for _, v in pairs(e:GetChildren()) do
						if v:IsA("BasePart") then
							v.CanCollide = false;
						end;
					end;
				end;

			else
				local e = I.Character;
				if e then
					for _, v in pairs(e:GetChildren()) do
						if v:IsA("BasePart") then
							v.CanCollide = true;
						end;
					end;
				end;
			end;
		end);
	end;
end);

-- =======================
-- TWEEN AJUSTADO POR DISTÂNCIA
-- =======================

-- [[ VARIÁVEIS PARA O SEU INPUT ]] --
getgenv().TweenSpeedFar = 370   -- Velocidade Padrão (Longe)
getgenv().TweenSpeedNear = 370  -- Velocidade Boost (Perto <= 15 studs)

_tp = function(I)
local e = plr.Character;
if not e or not e:FindFirstChild("HumanoidRootPart") then
return;
end;

local HRP = e.HumanoidRootPart;

-- Desativar farm enquanto tweena
shouldTween = true
getgenv().OnFarm = false

-- Garantir que não está ancorado
if HRP.Anchored then
	HRP.Anchored = false
	task.wait()
end

local dist = (I.Position - HRP.Position).Magnitude

-- ===============================
--  SE ESTIVER ATÉ 15 STUDS → USA A VELOCIDADE DE PERTO
--  CASO CONTRÁRIO → USA A VELOCIDADE PADRÃO
-- ===============================
local speed = dist <= 15 and (getgenv().TweenSpeedNear or 370) or (getgenv().TweenSpeedFar or 370)

local info = TweenInfo.new(dist / speed, Enum.EasingStyle.Linear)
local tween = game:GetService("TweenService"):Create(C, info, { CFrame = I })

-- Caso esteja sentado
if e.Humanoid.Sit == true then
	C.CFrame = CFrame.new(C.Position.X, I.Y, C.Position.Z)
end

tween:Play()

-- Anti travamento / controle
task.spawn(function()
	while tween.PlaybackState == Enum.PlaybackState.Playing do
		if not shouldTween then
			tween:Cancel()
			break
		end
		task.wait(.1)
	end

	getgenv().OnFarm = true
end)

end

TeleportToTarget = function(I)
_tp(I)
end

notween = function(I)
plr.Character.HumanoidRootPart.CFrame = I
end


function BTP(I)
	local e = game.Players.LocalPlayer;
	local K = e.Character.HumanoidRootPart;
	local n = e.Character.Humanoid;
	local d = e.PlayerGui.Main;
	local z = I.Position;
	local H = K.Position;

	repeat
		n.Health = 0;
		K.CFrame = I;
		d.Quest.Visible = false;

		if (K.Position - H).Magnitude > 1 then
			H = K.Position;
			K.CFrame = I;
		end;

		task.wait(.5);
	until (I.Position - K.Position).Magnitude <= 2000;
end;
spawn(function()
	while task.wait() do
		pcall(function()
			if _G.SailBoat_Hydra or _G.WardenBoss or _G.AutoFactory or _G.HighestMirage or _G.HCM or _G.PGB or _G.Leviathan1 or _G.UPGDrago or _G.Complete_Trials or _G.TpDrago_Prehis or _G.BuyDrago or _G.AutoFireFlowers or _G.DT_Uzoth or _G.AutoBerry or _G.Prehis_Find or _G.Prehis_Skills or _G.Prehis_DB or _G.Prehis_DE or _G.FarmBlazeEM or _G.Dojoo or _G.CollectPresent or _G.AutoLawKak or _G.TpLab or _G.AutoPhoenixF or _G.AutoFarmChest or _G.AutoHytHallow or _G.LongsWord or _G.BlackSpikey or _G.AutoHolyTorch or _G.TrainDrago or _G.AutoSaber or _G.FarmMastery_Dev or _G.CitizenQuest or _G.AutoEctoplasm or _G.KeysRen or _G.Auto_Rainbow_Haki or _G.obsFarm or _G.AutoBigmom or _G.Doughv2 or _G.AuraBoss or _G.Raiding or _G.Auto_Cavender or _G.TpPly or _G.Bartilo_Quest or _G.Level or _G.FarmEliteHunt or _G.AutoZou or _G.AutoFarm_Bone or (getgenv()).AutoMaterial or _G.CraftVM or _G.FrozenTP or _G.TPDoor or _G.AcientOne or _G.AutoFarmNear or _G.AutoRaidCastle or _G.DarkBladev3 or _G.AutoFarmRaid or _G.Auto_Cake_Prince or _G.Addealer or _G.TPNpc or _G.TwinHook or _G.FindMirage or _G.FarmChestM or _G.Shark or _G.TerrorShark or _G.Piranha or _G.MobCrew or _G.SeaBeast1 or _G.FishBoat or _G.Auto or _G.AutoPoleV2 or _G.Auto_SuperHuman or _G.AutoDeathStep or _G.Auto_SharkMan_Karate or _G.Auto_Electric_Claw or _G.AutoDragonTalon or _G.Auto_Def_DarkCoat or _G.Auto_God_Human or _G.Auto_Tushita or _G.AutoMatSoul or _G.AutoKenVTWO or _G.AutoSerpentBow or _G.AutoFMon or _G.Auto_Soul_Guitar or _G.TPGEAR or _G.AutoSaw or _G.AutoTridentW2 or _G.Auto_StartRaid or _G.AutoEvoRace or _G.AutoGetQuestBounty or _G.MarinesCoat or _G.TravelDres or _G.Defeating or _G.DummyMan or _G.Auto_Yama or _G.Auto_SwanGG or _G.SwanCoat or _G.AutoEcBoss or _G.Auto_Mink or _G.Auto_Human or _G.Auto_Skypiea or _G.Auto_Fish or _G.CDK_TS or _G.CDK_YM or _G.CDK or _G.AutoFarmGodChalice or _G.AutoFistDarkness or _G.AutoMiror or _G.Teleport or _G.AutoKilo or _G.AutoGetUsoap or _G.Praying or _G.TryLucky or _G.AutoColShad or _G.AutoUnHaki or _G.Auto_DonAcces or _G.AutoRipIngay or _G.DragoV3 or _G.DragoV1 or _G.SailBoats or NextIs or _G.FarmGodChalice or _G.IceBossRen or senth or senth2 or _G.Lvthan or _G.beasthunter or _G.DangerLV or _G.Relic123 or _G.tweenKitsune or _G.Collect_Ember or _G.AutofindKitIs or _G.snaguine or _G.TwFruits or _G.tweenKitShrine or _G.Tp_LgS or _G.Tp_MasterA or _G.tweenShrine or _G.FarmMastery_G or _G.FarmMastery_S then
				shouldTween = true;
				if not plr.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
					local I = Instance.new("BodyVelocity");
					I.Name = "BodyClip";
					I.Parent = plr.Character.HumanoidRootPart;
					I.MaxForce = Vector3.new(100000, 100000, 100000);
					I.Velocity = Vector3.new(0, 0, 0);
				end;
				for I, e in pairs(plr.Character:GetDescendants()) do
					if e:IsA("BasePart") then
						e.CanCollide = false;
					end;
				end;
			else
				shouldTween = false;
				if plr.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
					(plr.Character.HumanoidRootPart:FindFirstChild("BodyClip")):Destroy();
				end;
				if plr.Character:FindFirstChild("highlight") then
					(plr.Character:FindFirstChild("highlight")):Destroy();
				end;
			end;
		end);
	end;
end);
QuestB = function()
		if World1 then
			if _G.FindBoss == "The Gorilla King" then
				bMon = "The Gorilla King";
				Qname = "JungleQuest";
				Qdata = 3;
				PosQBoss = CFrame.new(-1601.6553955078, 36.85213470459, 153.38809204102);
				PosB = CFrame.new(-1088.75977, 8.13463783, -488.559906, -0.707134247, 0, .707079291, 0, 1, 0, -0.707079291, 0, -0.707134247);
			elseif _G.FindBoss == "Bobby" then
				bMon = "Bobby";
				Qname = "BuggyQuest1";
				Qdata = 3;
				PosQBoss = CFrame.new(-1140.1761474609, 4.752049446106, 3827.4057617188);
				PosB = CFrame.new(-1087.3760986328, 46.949409484863, 4040.1462402344);
			elseif _G.FindBoss == "The Saw" then
				bMon = "The Saw";
				PosB = CFrame.new(-784.89715576172, 72.427383422852, 1603.5822753906);
			elseif _G.FindBoss == "Yeti" then
				bMon = "Yeti";
				Qname = "SnowQuest";
				Qdata = 3;
				PosQBoss = CFrame.new(1386.8073730469, 87.272789001465, -1298.3576660156);
				PosB = CFrame.new(1218.7956542969, 138.01184082031, -1488.0262451172);
			elseif _G.FindBoss == "Mob Leader" then
				bMon = "Mob Leader";
				PosB = CFrame.new(-2844.7307128906, 7.4180502891541, 5356.6723632813);
			elseif _G.FindBoss == "Vice Admiral" then
				bMon = "Vice Admiral";
				Qname = "MarineQuest2";
				Qdata = 2;
				PosQBoss = CFrame.new(-5036.2465820313, 28.677835464478, 4324.56640625);
				PosB = CFrame.new(-5006.5454101563, 88.032081604004, 4353.162109375);
			elseif _G.FindBoss == "Saber Expert" then
				bMon = "Saber Expert";
				PosB = CFrame.new(-1458.89502, 29.8870335, -50.633564);
			elseif _G.FindBoss == "Warden" then
				bMon = "Warden";
				Qname = "ImpelQuest";
				Qdata = 1;
				PosB = CFrame.new(5278.04932, 2.15167475, 944.101929, .220546961, -4.49946401e-06, .975376427, -1.95412576e-05, 1, 9.03162072e-06, -0.975376427, -2.10519756e-05, .220546961);
				PosQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, .681965172, 0, 1, 0, -0.681965172, 0, -0.731384635);
			elseif _G.FindBoss == "Chief Warden" then
				bMon = "Chief Warden";
				Qname = "ImpelQuest";
				Qdata = 2;
				PosB = CFrame.new(5206.92578, .997753382, 814.976746, .342041343, -0.00062915677, .939684749, .00191645394, .999998152, -2.80422337e-05, -0.939682961, .00181045406, .342041939);
				PosQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, .681965172, 0, 1, 0, -0.681965172, 0, -0.731384635);
			elseif _G.FindBoss == "Swan" then
				bMon = "Swan";
				Qname = "ImpelQuest";
				Qdata = 3;
				PosB = CFrame.new(5325.09619, 7.03906584, 719.570679, -0.309060812, 0, .951042235, 0, 1, 0, -0.951042235, 0, -0.309060812);
				PosQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, .681965172, 0, 1, 0, -0.681965172, 0, -0.731384635);
			elseif _G.FindBoss == "Magma Admiral" then
				bMon = "Magma Admiral";
				Qname = "MagmaQuest";
				Qdata = 3;
				PosQBoss = CFrame.new(-5314.6220703125, 12.262420654297, 8517.279296875);
				PosB = CFrame.new(-5765.8969726563, 82.92064666748, 8718.3046875);
			elseif _G.FindBoss == "Fishman Lord" then
				bMon = "Fishman Lord";
				Qname = "FishmanQuest";
				Qdata = 3;
				PosQBoss = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734);
				PosB = CFrame.new(61260.15234375, 30.950881958008, 1193.4329833984);
			elseif _G.FindBoss == "Wysper" then
				bMon = "Wysper";
				Qname = "SkyExp1Quest";
				Qdata = 3;
				PosQBoss = CFrame.new(-7861.947265625, 5545.517578125, -379.85974121094);
				PosB = CFrame.new(-7866.1333007813, 5576.4311523438, -546.74816894531);
			elseif _G.FindBoss == "Thunder God" then
				bMon = "Thunder God";
				Qname = "SkyExp2Quest";
				Qdata = 3;
				PosQBoss = CFrame.new(-7903.3828125, 5635.9897460938, -1410.923828125);
				PosB = CFrame.new(-7994.984375, 5761.025390625, -2088.6479492188);
			elseif _G.FindBoss == "Cyborg" then
				bMon = "Cyborg";
				Qname = "FountainQuest";
				Qdata = 3;
				PosQBoss = CFrame.new(5258.2788085938, 38.526931762695, 4050.044921875);
				PosB = CFrame.new(6094.0249023438, 73.770050048828, 3825.7348632813);
			elseif _G.FindBoss == "Ice Admiral" then
				bMon = "Ice Admiral";
				Qdata = nil;
				PosQBoss = CFrame.new(1266.08948, 26.1757946, -1399.57678, -0.573599219, 0, -0.81913656, 0, 1, 0, .81913656, 0, -0.573599219);
				PosB = CFrame.new(1266.08948, 26.1757946, -1399.57678, -0.573599219, 0, -0.81913656, 0, 1, 0, .81913656, 0, -0.573599219);
			elseif _G.FindBoss == "Greybeard" then
				bMon = "Greybeard";
				Qdata = nil;
				PosQBoss = CFrame.new(-5081.3452148438, 85.221641540527, 4257.3588867188);
				PosB = CFrame.new(-5081.3452148438, 85.221641540527, 4257.3588867188);
			end;
		end;
		if World2 then
			if _G.FindBoss == "Diamond" then
				bMon = "Diamond";
				Qname = "Area1Quest";
				Qdata = 3;
				PosQBoss = CFrame.new(-427.5666809082, 73.313781738281, 1835.4208984375);
				PosB = CFrame.new(-1576.7166748047, 198.59265136719, 13.724286079407);
			elseif _G.FindBoss == "Jeremy" then
				bMon = "Jeremy";
				Qname = "Area2Quest";
				Qdata = 3;
				PosQBoss = CFrame.new(636.79943847656, 73.413787841797, 918.00415039063);
				PosB = CFrame.new(2006.9261474609, 448.95666503906, 853.98284912109);
			elseif _G.FindBoss == "Fajita" then
				bMon = "Fajita";
				Qname = "MarineQuest3";
				Qdata = 3;
				PosQBoss = CFrame.new(-2441.986328125, 73.359344482422, -3217.5324707031);
				PosB = CFrame.new(-2172.7399902344, 103.32216644287, -4015.025390625);
			elseif _G.FindBoss == "Don Swan" then
				bMon = "Don Swan";
				PosB = CFrame.new(2286.2004394531, 15.177839279175, 863.8388671875);
			elseif _G.FindBoss == "Smoke Admiral" then
				bMon = "Smoke Admiral";
				Qname = "IceSideQuest";
				Qdata = 3;
				PosQBoss = CFrame.new(-5429.0473632813, 15.977565765381, -5297.9614257813);
				PosB = CFrame.new(-5275.1987304688, 20.757257461548, -5260.6669921875);
			elseif _G.FindBoss == "Awakened Ice Admiral" then
				bMon = "Awakened Ice Admiral";
				Qname = "FrostQuest";
				Qdata = 3;
				PosQBoss = CFrame.new(5668.9780273438, 28.519989013672, -6483.3520507813);
				PosB = CFrame.new(6403.5439453125, 340.29766845703, -6894.5595703125);
			elseif _G.FindBoss == "Tide Keeper" then
				bMon = "Tide Keeper";
				Qname = "ForgottenQuest";
				Qdata = 3;
				PosQBoss = CFrame.new(-3053.9814453125, 237.18954467773, -10145.0390625);
				PosB = CFrame.new(-3795.6423339844, 105.88877105713, -11421.307617188);
			elseif _G.FindBoss == "Darkbeard" then
				bMon = "Darkbeard";
				Qdata = nil;
				PosQBoss = CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531);
				PosB = CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531);
			elseif _G.FindBoss == "Cursed Captaim" then
				bMon = "Cursed Captain";
				Qdata = nil;
				PosQBoss = CFrame.new(916.928589, 181.092773, 33422);
				PosB = CFrame.new(916.928589, 181.092773, 33422);
			elseif _G.FindBoss == "Order" then
				bMon = "Order";
				Qdata = nil;
				PosQBoss = CFrame.new(-6217.2021484375, 28.047645568848, -5053.1357421875);
				PosB = CFrame.new(-6217.2021484375, 28.047645568848, -5053.1357421875);
			end;
		end;
		if World3 then
			if _G.FindBoss == "Stone" then
				bMon = "Stone";
				Qname = "PiratePortQuest";
				Qdata = 3;
				PosQBoss = CFrame.new(-289.76705932617, 43.819011688232, 5579.9384765625);
				PosB = CFrame.new(-1027.6512451172, 92.404174804688, 6578.8530273438);
			elseif _G.FindBoss == "Hydra Leader" then
				bMon = "Hydra Leader";
				Qname = "AmazonQuest2";
				Qdata = 3;
				PosQBoss = CFrame.new(5821.8979492188, 1019.0950927734, -73.719230651855);
				PosB = CFrame.new(5821.8979492188, 1019.0950927734, -73.719230651855);
			elseif _G.FindBoss == "Kilo Admiral" then
				bMon = "Kilo Admiral";
				Qname = "MarineTreeIsland";
				Qdata = 3;
				PosQBoss = CFrame.new(2179.3010253906, 28.731239318848, -6739.9741210938);
				PosB = CFrame.new(2764.2233886719, 432.46154785156, -7144.4580078125);
			elseif _G.FindBoss == "Captain Elephant" then
				bMon = "Captain Elephant";
				Qname = "DeepForestIsland";
				Qdata = 3;
				PosQBoss = CFrame.new(-13232.682617188, 332.40396118164, -7626.01171875);
				PosB = CFrame.new(-13376.7578125, 433.28689575195, -8071.392578125);
			elseif _G.FindBoss == "Beautiful Pirate" then
				bMon = "Beautiful Pirate";
				Qname = "DeepForestIsland2";
				Qdata = 3;
				PosQBoss = CFrame.new(-12682.096679688, 390.88653564453, -9902.1240234375);
				PosB = CFrame.new(5283.609375, 22.56223487854, -110.78285217285);
			elseif _G.FindBoss == "Cake Queen" then
				bMon = "Cake Queen";
				Qname = "IceCreamIslandQuest";
				Qdata = 3;
				PosQBoss = CFrame.new(-819.376709, 64.9259796, -10967.2832, -0.766061664, 0, .642767608, 0, 1, 0, -0.642767608, 0, -0.766061664);
				PosB = CFrame.new(-678.648804, 381.353943, -11114.2012, -0.908641815, .00149294338, .41757378, .00837114919, .999857843, .0146408929, -0.417492568, .0167988986, -0.90852499);
			elseif _G.FindBoss == "Longma" then
				bMon = "Longma";
				Qdata = nil;
				PosQBoss = CFrame.new(-10238.875976563, 389.7912902832, -9549.7939453125);
				PosB = CFrame.new(-10238.875976563, 389.7912902832, -9549.7939453125);
			elseif _G.FindBoss == "Soul Reaper" then
				bMon = "Soul Reaper";
				Qdata = nil;
				PosQBoss = CFrame.new(-9524.7890625, 315.80429077148, 6655.7192382813);
				PosB = CFrame.new(-9524.7890625, 315.80429077148, 6655.7192382813);
			end;
		end;
	end;
QuestBeta = function()
		local I = QuestB();
		return {
			[0] = _G.FindBoss,
			[1] = bMon,
			[2] = Qdata,
			[3] = Qname,
			[4] = PosB,
		};
	end;
QuestCheck = function()
    local I = game.Players.LocalPlayer.Data.Level.Value

    -- [CORREÇÃO] Fixar level dentro do limite da missão
    if World1 and I > 699 then
        I = 650 -- Força a missão do Galley Captain (Lv 650)
    end

    if World2 and I > 1499 then
        I = 1450 -- Força a missão do Water Fighter (Lv 1450)
    end

    if World1 then
        if I == 1 or I <= 9 then
            if tostring(TeamSelf) == "Marines" then
                Mon = "Trainee"
                Qname = "MarineQuest"
                Qdata = 1
                NameMon = "Trainee"
                PosM = CFrame.new(-2709.67944, 24.5206585, 2104.24585)
                PosQ = CFrame.new(-2709.67944, 24.5206585, 2104.24585)
            elseif tostring(TeamSelf) == "Pirates" then
                Mon = "Bandit"
                Qdata = 1
                Qname = "BanditQuest1"
                NameMon = "Bandit"
                PosM = CFrame.new(1045.9626464844, 27.002508163452, 1560.8203125)
                PosQ = CFrame.new(1045.9626464844, 27.002508163452, 1560.8203125)
            end
        elseif I >= 10 and I <= 14 then
            Mon = "Monkey"
            Qdata = 1
            Qname = "JungleQuest"
            NameMon = "Monkey"
            PosQ = CFrame.new(-1598.08911, 35.5501175, 153.377838)
            PosM = CFrame.new(-1448.5180664062, 67.853012084961, 11.465796470642)
        elseif I >= 15 and I <= 29 then
            Mon = "Gorilla"
            Qdata = 2
            Qname = "JungleQuest"
            NameMon = "Gorilla"
            PosQ = CFrame.new(-1598.08911, 35.5501175, 153.377838)
            PosM = CFrame.new(-1129.8836669922, 40.46354675293, -525.42370605469)
        elseif I >= 30 and I <= 39 then
            Mon = "Pirate"
            Qdata = 1
            Qname = "BuggyQuest1"
            NameMon = "Pirate"
            PosQ = CFrame.new(-1141.07483, 4.10001802, 3831.5498)
            PosM = CFrame.new(-1103.5134277344, 13.752052307129, 3896.0910644531)
        elseif I >= 40 and I <= 59 then
            Mon = "Brute"
            Qdata = 2
            Qname = "BuggyQuest1"
            NameMon = "Brute"
            PosQ = CFrame.new(-1141.07483, 4.10001802, 3831.5498)
            PosM = CFrame.new(-1140.0837402344, 14.809885025024, 4322.9213867188)
        elseif I >= 60 and I <= 74 then
            Mon = "Desert Bandit"
            Qdata = 1
            Qname = "DesertQuest"
            NameMon = "Desert Bandit"
            PosQ = CFrame.new(894.488647, 5.14000702, 4392.43359)
            PosM = CFrame.new(924.7998046875, 6.4486746788025, 4481.5859375)
        elseif I >= 75 and I <= 89 then
            Mon = "Desert Officer"
            Qdata = 2
            Qname = "DesertQuest"
            NameMon = "Desert Officer"
            PosQ = CFrame.new(894.488647, 5.14000702, 4392.43359)
            PosM = CFrame.new(1608.2822265625, 8.6142244338989, 4371.0073242188)
        elseif I >= 90 and I <= 99 then
            Mon = "Snow Bandit"
            Qdata = 1
            Qname = "SnowQuest"
            NameMon = "Snow Bandit"
            PosQ = CFrame.new(1389.74451, 88.1519318, -1298.90796)
            PosM = CFrame.new(1354.3479003906, 87.272773742676, -1393.9465332031)
        elseif I >= 100 and I <= 119 then
            Mon = "Snowman"
            Qdata = 2
            Qname = "SnowQuest"
            NameMon = "Snowman"
            PosQ = CFrame.new(1389.74451, 88.1519318, -1298.90796)
            PosM = CFrame.new(1201.6412353515625, 144.57958984375, -1550.0670166015625)
        elseif I >= 120 and I <= 149 then
            Mon = "Chief Petty Officer"
            Qdata = 1
            Qname = "MarineQuest2"
            NameMon = "Chief Petty Officer"
            PosQ = CFrame.new(-5039.58643, 27.3500385, 4324.68018)
            PosM = CFrame.new(-4881.2309570312, 22.652044296265, 4273.7524414062)
        elseif I >= 150 and I <= 174 then
            Mon = "Sky Bandit"
            Qdata = 1
            Qname = "SkyQuest"
            NameMon = "Sky Bandit"
            PosQ = CFrame.new(-4839.53027, 716.368591, -2619.44165)
            PosM = CFrame.new(-4953.20703125, 295.74420166016, -2899.2290039062)
        elseif I >= 175 and I <= 189 then
            Mon = "Dark Master"
            Qdata = 2
            Qname = "SkyQuest"
            NameMon = "Dark Master"
            PosQ = CFrame.new(-4839.53027, 716.368591, -2619.44165)
            PosM = CFrame.new(-5259.8447265625, 391.39767456055, -2229.0354003906)
        elseif I >= 190 and I <= 209 then
            Mon = "Prisoner"
            Qdata = 1
            Qname = "PrisonerQuest"
            NameMon = "Prisoner"
            PosQ = CFrame.new(5308.93115, 1.65517521, 475.120514)
            PosM = CFrame.new(5098.9736328125, -0.3204058110714, 474.23733520508)
        elseif I >= 210 and I <= 249 then
            Mon = "Dangerous Prisoner"
            Qdata = 2
            Qname = "PrisonerQuest"
            NameMon = "Dangerous Prisoner"
            PosQ = CFrame.new(5308.93115, 1.65517521, 475.120514)
            PosM = CFrame.new(5654.5634765625, 15.633401870728, 866.29919433594)
        elseif I >= 250 and I <= 274 then
            Mon = "Toga Warrior"
            Qdata = 1
            Qname = "ColosseumQuest"
            NameMon = "Toga Warrior"
            PosQ = CFrame.new(-1580.04663, 6.35000277, -2986.47534)
            PosM = CFrame.new(-1820.21484375, 51.683856964111, -2740.6650390625)
        elseif I >= 275 and I <= 299 then
            Mon = "Gladiator"
            Qdata = 2
            Qname = "ColosseumQuest"
            NameMon = "Gladiator"
            PosQ = CFrame.new(-1580.04663, 6.35000277, -2986.47534)
            PosM = CFrame.new(-1292.8381347656, 56.380882263184, -3339.0314941406)
        elseif I >= 300 and I <= 324 then
            Mon = "Military Soldier"
            Qdata = 1
            Qname = "MagmaQuest"
            NameMon = "Military Soldier"
            PosQ = CFrame.new(-5313.37012, 10.9500084, 8515.29395)
            PosM = CFrame.new(-5411.1645507812, 11.081554412842, 8454.29296875)
        elseif I >= 325 and I <= 374 then
            Mon = "Military Spy"
            Qdata = 2
            Qname = "MagmaQuest"
            NameMon = "Military Spy"
            PosQ = CFrame.new(-5313.37012, 10.9500084, 8515.29395)
            PosM = CFrame.new(-5802.8681640625, 86.262413024902, 8828.859375)
        elseif I >= 375 and I <= 399 then
            Mon = "Fishman Warrior"
            Qdata = 1
            Qname = "FishmanQuest"
            NameMon = "Fishman Warrior"
            PosQ = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
            PosM = CFrame.new(60878.30078125, 18.482830047607, 1543.7574462891)
            if _G.Level and (PosQ.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
            end
        elseif I >= 400 and I <= 449 then
            Mon = "Fishman Commando"
            Qdata = 2
            Qname = "FishmanQuest"
            NameMon = "Fishman Commando"
            PosQ = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
            PosM = CFrame.new(61922.6328125, 18.482830047607, 1493.9343261719)
            if _G.Level and (PosQ.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
            end
        elseif I >= 450 and I <= 474 then
            Mon = "God's Guard"
            Qdata = 1
            Qname = "SkyExp1Quest"
            NameMon = "God's Guard"
            PosQ = CFrame.new(-4721.88867, 843.874695, -1949.96643)
            PosM = CFrame.new(-4710.04296875, 845.27697753906, -1927.3079833984)
            if _G.Level and (PosQ.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-4607.82275, 872.54248, -1667.55688))
            end
        elseif I >= 475 and I <= 524 then
            Mon = "Shanda"
            Qdata = 2
            Qname = "SkyExp1Quest"
            NameMon = "Shanda"
            PosQ = CFrame.new(-7859.09814, 5544.19043, -381.476196)
            PosM = CFrame.new(-7678.4897460938, 5566.4038085938, -497.21560668945)
            if _G.Level and (PosQ.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047))
            end
        elseif I >= 525 and I <= 549 then
            Mon = "Royal Squad"
            Qdata = 1
            Qname = "SkyExp2Quest"
            NameMon = "Royal Squad"
            PosQ = CFrame.new(-7906.81592, 5634.6626, -1411.99194)
            PosM = CFrame.new(-7624.2524414062, 5658.1333007812, -1467.3542480469)
        elseif I >= 550 and I <= 624 then
            Mon = "Royal Soldier"
            Qdata = 2
            Qname = "SkyExp2Quest"
            NameMon = "Royal Soldier"
            PosQ = CFrame.new(-7906.81592, 5634.6626, -1411.99194)
            PosM = CFrame.new(-7836.7534179688, 5645.6640625, -1790.6236572266)
        elseif I >= 625 and I <= 649 then
            Mon = "Galley Pirate"
            Qdata = 1
            Qname = "FountainQuest"
            NameMon = "Galley Pirate"
            PosQ = CFrame.new(5259.81982, 37.3500175, 4050.0293)
            PosM = CFrame.new(5551.0219726562, 78.901351928711, 3930.4128417969)
        elseif I >= 650 then
            Mon = "Galley Captain"
            Qdata = 2
            Qname = "FountainQuest"
            NameMon = "Galley Captain"
            PosQ = CFrame.new(5259.81982, 37.3500175, 4050.0293)
            PosM = CFrame.new(5441.9516601562, 42.502059936523, 4950.09375)
        end
    elseif World2 then
        if I >= 700 and I <= 724 then
            Mon = "Raider"
            Qdata = 1
            Qname = "Area1Quest"
            NameMon = "Raider"
            PosQ = CFrame.new(-429.543518, 71.7699966, 1836.18188)
            PosM = CFrame.new(-728.32672119141, 52.779319763184, 2345.7705078125)
        elseif I >= 725 and I <= 774 then
            Mon = "Mercenary"
            Qdata = 2
            Qname = "Area1Quest"
            NameMon = "Mercenary"
            PosQ = CFrame.new(-429.543518, 71.7699966, 1836.18188)
            PosM = CFrame.new(-1004.3244018555, 80.158866882324, 1424.6193847656)
        elseif I >= 775 and I <= 799 then
            Mon = "Swan Pirate"
            Qdata = 1
            Qname = "Area2Quest"
            NameMon = "Swan Pirate"
            PosQ = CFrame.new(638.43811, 71.769989, 918.282898)
            PosM = CFrame.new(1068.6643066406, 137.61428833008, 1322.1060791016)
        elseif I >= 800 and I <= 874 then
            Mon = "Factory Staff"
            Qname = "Area2Quest"
            Qdata = 2
            NameMon = "Factory Staff"
            PosQ = CFrame.new(632.698608, 73.1055908, 918.666321)
            PosM = CFrame.new(73.078674316406, 81.863441467285, -27.470672607422)
        elseif I >= 875 and I <= 899 then
            Mon = "Marine Lieutenant"
            Qdata = 1
            Qname = "MarineQuest3"
            NameMon = "Marine Lieutenant"
            PosQ = CFrame.new(-2440.79639, 71.7140732, -3216.06812)
            PosM = CFrame.new(-2821.3723144531, 75.897277832031, -3070.0891113281)
        elseif I >= 900 and I <= 949 then
            Mon = "Marine Captain"
            Qdata = 2
            Qname = "MarineQuest3"
            NameMon = "Marine Captain"
            PosQ = CFrame.new(-2440.79639, 71.7140732, -3216.06812)
            PosM = CFrame.new(-1861.2310791016, 80.176582336426, -3254.6975097656)
        elseif I >= 950 and I <= 974 then
            Mon = "Zombie"
            Qdata = 1
            Qname = "ZombieQuest"
            NameMon = "Zombie"
            PosQ = CFrame.new(-5497.06152, 47.5923004, -795.237061)
            PosM = CFrame.new(-5657.7768554688, 78.969734191895, -928.68701171875)
        elseif I >= 975 and I <= 999 then
            Mon = "Vampire"
            Qdata = 2
            Qname = "ZombieQuest"
            NameMon = "Vampire"
            PosQ = CFrame.new(-5497.06152, 47.5923004, -795.237061)
            PosM = CFrame.new(-6037.66796875, 32.184638977051, -1340.6597900391)
        elseif I >= 1000 and I <= 1049 then
            Mon = "Snow Trooper"
            Qdata = 1
            Qname = "SnowMountainQuest"
            NameMon = "Snow Trooper"
            PosQ = CFrame.new(609.858826, 400.119904, -5372.25928)
            PosM = CFrame.new(549.14733886719, 427.38705444336, -5563.6987304688)
        elseif I >= 1050 and I <= 1099 then
            Mon = "Winter Warrior"
            Qdata = 2
            Qname = "SnowMountainQuest"
            NameMon = "Winter Warrior"
            PosQ = CFrame.new(609.858826, 400.119904, -5372.25928)
            PosM = CFrame.new(1142.7451171875, 475.63980102539, -5199.4165039062)
        elseif I >= 1100 and I <= 1124 then
            Mon = "Lab Subordinate"
            Qdata = 1
            Qname = "IceSideQuest"
            NameMon = "Lab Subordinate"
            PosQ = CFrame.new(-6064.06885, 15.2422857, -4902.97852)
            PosM = CFrame.new(-5707.4716796875, 15.951709747314, -4513.3920898438)
        elseif I >= 1125 and I <= 1174 then
            Mon = "Horned Warrior"
            Qdata = 2
            Qname = "IceSideQuest"
            NameMon = "Horned Warrior"
            PosQ = CFrame.new(-6064.06885, 15.2422857, -4902.97852)
            PosM = CFrame.new(-6341.3666992188, 15.951770782471, -5723.162109375)
        elseif I >= 1175 and I <= 1199 then
            Mon = "Magma Ninja"
            Qdata = 1
            Qname = "FireSideQuest"
            NameMon = "Magma Ninja"
            PosQ = CFrame.new(-5428.03174, 15.0622921, -5299.43457)
            PosM = CFrame.new(-5449.6728515625, 76.658744812012, -5808.2006835938)
        elseif I >= 1200 and I <= 1249 then
            Mon = "Lava Pirate"
            Qdata = 2
            Qname = "FireSideQuest"
            NameMon = "Lava Pirate"
            PosQ = CFrame.new(-5428.03174, 15.0622921, -5299.43457)
            PosM = CFrame.new(-5213.3315429688, 49.737880706787, -4701.451171875)
        elseif I >= 1250 and I <= 1274 then
            Mon = "Ship Deckhand"
            Qdata = 1
            Qname = "ShipQuest1"
            NameMon = "Ship Deckhand"
            PosQ = CFrame.new(1037.80127, 125.092171, 32911.6016)
            PosM = CFrame.new(1212.0111083984, 150.79205322266, 33059.24609375)
            if _G.Level and (PosQ.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 500 then
                replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif I >= 1275 and I <= 1299 then
            Mon = "Ship Engineer"
            Qdata = 2
            Qname = "ShipQuest1"
            NameMon = "Ship Engineer"
            PosQ = CFrame.new(1037.80127, 125.092171, 32911.6016)
            PosM = CFrame.new(919.47863769531, 43.544013977051, 32779.96875)
            if _G.Level and (PosQ.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 500 then
                replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif I >= 1300 and I <= 1324 then
            Mon = "Ship Steward"
            Qdata = 1
            Qname = "ShipQuest2"
            NameMon = "Ship Steward"
            PosQ = CFrame.new(968.80957, 125.092171, 33244.125)
            PosM = CFrame.new(919.43853759766, 129.55599975586, 33436.03515625)
            if _G.Level and (PosQ.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 500 then
                replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif I >= 1325 and I <= 1349 then
            Mon = "Ship Officer"
            Qdata = 2
            Qname = "ShipQuest2"
            NameMon = "Ship Officer"
            PosQ = CFrame.new(968.80957, 125.092171, 33244.125)
            PosM = CFrame.new(1036.0179443359, 181.4390411377, 33315.7265625)
            if _G.Level and (PosQ.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 500 then
                replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif I >= 1350 and I <= 1374 then
            Mon = "Arctic Warrior"
            Qdata = 1
            Qname = "FrostQuest"
            NameMon = "Arctic Warrior"
            PosQ = CFrame.new(5667.6582, 26.7997818, -6486.08984)
            PosM = CFrame.new(5966.24609375, 62.970020294189, -6179.3828125)
        elseif I >= 1375 and I <= 1424 then
            Mon = "Snow Lurker"
            Qdata = 2
            Qname = "FrostQuest"
            NameMon = "Snow Lurker"
            PosQ = CFrame.new(5667.6582, 26.7997818, -6486.08984)
            PosM = CFrame.new(5407.0737304688, 69.194374084473, -6880.8803710938)
        elseif I >= 1425 and I <= 1449 then
            Mon = "Sea Soldier"
            Qdata = 1
            Qname = "ForgottenQuest"
            NameMon = "Sea Soldier"
            PosQ = CFrame.new(-3054.44458, 235.544281, -10142.8193)
            PosM = CFrame.new(-3028.2236328125, 64.674514770508, -9775.4267578125)
        elseif I >= 1450 then
            Mon = "Water Fighter"
            Qdata = 2
            Qname = "ForgottenQuest"
            NameMon = "Water Fighter"
            PosQ = CFrame.new(-3054.44458, 235.544281, -10142.8193)
            PosM = CFrame.new(-3352.9013671875, 285.01556396484, -10534.841796875)
        end
    elseif World3 then
if I == 1500 or I <= 1524 then
Mon = "Pirate Millionaire"
Qdata = 1
Qname = "PiratePortQuest"
NameMon = "Pirate Millionaire"
PosQ = CFrame.new(-290.07, 42.90, 5581.59)
PosM = CFrame.new(-246.00, 47.31, 5584.10)
elseif I == 1525 or I <= 1574 then
Mon = "Pistol Billionaire"
Qdata = 2
Qname = "PiratePortQuest"
NameMon = "Pistol Billionaire"
PosQ = CFrame.new(-290.07, 42.90, 5581.59)
PosM = CFrame.new(-187.33, 86.24, 6013.51)
		elseif I == 1575 or I <= 1599 then
    Mon = "Dragon Crew Warrior"
    Qdata = 1
    Qname = "DragonCrewQuest"
    NameMon = "Dragon Crew Warrior"
    PosQ = CFrame.new(6737.06055,127.417763,-712.300659,-0.463954359,-7.19574755e-09,0.885859072,7.69187665e-08,1,4.84078626e-08,-0.885859072,9.05982276e-08,-0.463954359)
    PosM = CFrame.new(6709.76367,52.3442993,-1139.02966,-0.763515472,0,0.645789504,0,1,0,-0.645789504,0,-0.763515472)
elseif I == 1600 or I <= 1624 then
    Mon = "Dragon Crew Archer"
    Qdata = 2
    Qname = "DragonCrewQuest"
    NameMon = "Dragon Crew Archer"
    PosQ = CFrame.new(6737.06055,127.417763,-712.300659,-0.463954359,-7.19574755e-09,0.885859072,7.69187665e-08,1,4.84078626e-08,-0.885859072,9.05982276e-08,-0.463954359)
    PosM = CFrame.new(6668.76172,481.376923,329.12207,-0.121787429,0,-0.992556155,0,1,0,0.992556155,0,-0.121787429)
elseif I == 1625 or I <= 1649 then
    Mon = "Hydra Enforcer"
    Qname = "VenomCrewQuest"
    Qdata = 1
    NameMon = "Hydra Enforcer"
    PosQ = CFrame.new(5206.40185546875, 1004.10498046875, 748.3504638671875)
    PosM = CFrame.new(4547.11523, 1003.10217, 334.194824, 0.388810456, -0, -0.921317935, 0, 1, -0, 0.921317935, 0, 0.388810456)
elseif I == 1650 or I <= 1699 then
    Mon = "Venomous Assailant"
    Qname = "VenomCrewQuest"
    Qdata = 2
    NameMon = "Venomous Assailant"
    PosQ = CFrame.new(5206.40185546875, 1004.10498046875, 748.3504638671875)
    PosM = CFrame.new(4674.92676, 1134.82654, 996.308838, 0.731321394, -0, -0.682033002, 0, 1, -0, 0.682033002, 0, 0.731321394)
		elseif I == 1700 or I <= 1724 then
			Mon = "Marine Commodore"
			Qdata = 1
			Qname = "MarineTreeIsland"
			NameMon = "Marine Commodore"
			PosQ = CFrame.new(2180.54126, 27.8156815, -6741.5498, -0.965929747, 0, .258804798, 0, 1, 0, -0.258804798, 0, -0.965929747)
			PosM = CFrame.new(2286.0078125, 73.133918762207, -7159.8090820312)
		elseif I == 1725 or I <= 1774 then
			Mon = "Marine Rear Admiral"
			NameMon = "Marine Rear Admiral"
			Qname = "MarineTreeIsland"
			Qdata = 2
			PosQ = CFrame.new(2179.98828125, 28.731239318848, -6740.0551757813)
			PosM = CFrame.new(3656.7736816406, 160.52406311035, -7001.5986328125)
		elseif I == 1775 or I <= 1799 then
			Mon = "Fishman Raider"
			Qdata = 1
			Qname = "DeepForestIsland3"
			NameMon = "Fishman Raider"
			PosQ = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, 0, .469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
			PosM = CFrame.new(-10407.526367188, 331.76263427734, -8368.5166015625)
		elseif I == 1800 or I <= 1824 then
			Mon = "Fishman Captain"
			Qdata = 2
			Qname = "DeepForestIsland3"
			NameMon = "Fishman Captain"
			PosQ = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, 0, .469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
			PosM = CFrame.new(-10994.701171875, 352.38140869141, -9002.1103515625)
		elseif I == 1825 or I <= 1849 then
			Mon = "Forest Pirate"
			Qdata = 1
			Qname = "DeepForestIsland"
			NameMon = "Forest Pirate"
			PosQ = CFrame.new(-13234.04, 331.488495, -7625.40137, .707134247, 0, -0.707079291, 0, 1, 0, .707079291, 0, .707134247)
			PosM = CFrame.new(-13274.478515625, 332.37814331055, -7769.5805664062)
		elseif I == 1850 or I <= 1899 then
			Mon = "Mythological Pirate"
			Qdata = 2
			Qname = "DeepForestIsland"
			NameMon = "Mythological Pirate"
			PosQ = CFrame.new(-13234.04, 331.488495, -7625.40137, .707134247, 0, -0.707079291, 0, 1, 0, .707079291, 0, .707134247)
			PosM = CFrame.new(-13680.607421875, 501.08154296875, -6991.189453125)
		elseif I == 1900 or I <= 1924 then
			Mon = "Jungle Pirate"
			Qdata = 1
			Qname = "DeepForestIsland2"
			NameMon = "Jungle Pirate"
			PosQ = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, .996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002)
			PosM = CFrame.new(-12256.16015625, 331.73828125, -10485.836914062)
		elseif I == 1925 or I <= 1974 then
			Mon = "Musketeer Pirate"
			Qdata = 2
			Qname = "DeepForestIsland2"
			NameMon = "Musketeer Pirate"
			PosQ = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, .996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002)
			PosM = CFrame.new(-13457.904296875, 391.54565429688, -9859.177734375)
		elseif I == 1975 or I <= 1999 then
			Mon = "Reborn Skeleton"
			Qdata = 1
			Qname = "HauntedQuest1"
			NameMon = "Reborn Skeleton"
			PosQ = CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, 0, -1, 0, 0)
			PosM = CFrame.new(-8763.7236328125, 165.72299194336, 6159.8618164062)
		elseif I == 2000 or I <= 2024 then
			Mon = "Living Zombie"
			Qdata = 2
			Qname = "HauntedQuest1"
			NameMon = "Living Zombie"
			PosQ = CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, 0, -1, 0, 0)
			PosM = CFrame.new(-10144.131835938, 138.6266784668, 5838.0888671875)
		elseif I == 2025 or I <= 2049 then
			Mon = "Demonic Soul"
			Qdata = 1
			Qname = "HauntedQuest2"
			NameMon = "Demonic Soul"
			PosQ = CFrame.new(-9516.99316, 172.017181, 6078.46533, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			PosM = CFrame.new(-9505.8720703125, 172.10482788086, 6158.9931640625)
		elseif I == 2050 or I <= 2074 then
			Mon = "Posessed Mummy"
			Qdata = 2
			Qname = "HauntedQuest2"
			NameMon = "Posessed Mummy"
			PosQ = CFrame.new(-9516.99316, 172.017181, 6078.46533, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			PosM = CFrame.new(-9582.0224609375, 6.2515273094177, 6205.478515625)
		elseif I == 2075 or I <= 2099 then
			Mon = "Peanut Scout"
			Qdata = 1
			Qname = "NutsIslandQuest"
			NameMon = "Peanut Scout"
			PosQ = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			PosM = CFrame.new(-2143.2419433594, 47.721984863281, -10029.995117188)
		elseif I == 2100 or I <= 2124 then
			Mon = "Peanut President"
			Qdata = 2
			Qname = "NutsIslandQuest"
			NameMon = "Peanut President"
			PosQ = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			PosM = CFrame.new(-1859.3540039062, 38.103168487549, -10422.4296875)
		elseif I == 2125 or I <= 2149 then
			Mon = "Ice Cream Chef"
			Qdata = 1
			Qname = "IceCreamIslandQuest"
			NameMon = "Ice Cream Chef"
			PosQ = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			PosM = CFrame.new(-872.24658203125, 65.81957244873, -10919.95703125)
		elseif I == 2150 or I <= 2199 then
			Mon = "Ice Cream Commander"
			Qdata = 2
			Qname = "IceCreamIslandQuest"
			NameMon = "Ice Cream Commander"
			PosQ = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			PosM = CFrame.new(-558.06103515625, 112.04895782471, -11290.774414062)
		elseif I == 2200 or I <= 2224 then
			Mon = "Cookie Crafter"
			Qdata = 1
			Qname = "CakeQuest1"
			NameMon = "Cookie Crafter"
			PosQ = CFrame.new(-2021.32007, 37.7982254, -12028.7295, .957576931, -8.80302053e-08, .288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, .957576931)
			PosM = CFrame.new(-2374.13671875, 37.798263549805, -12125.30859375)
		elseif I == 2225 or I <= 2249 then
			Mon = "Cake Guard"
			Qdata = 2
			Qname = "CakeQuest1"
			NameMon = "Cake Guard"
			PosQ = CFrame.new(-2021.32007, 37.7982254, -12028.7295, .957576931, -8.80302053e-08, .288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, .957576931)
			PosM = CFrame.new(-1598.3070068359, 43.773197174072, -12244.581054688)
		elseif I == 2250 or I <= 2274 then
			Mon = "Baking Staff"
			Qdata = 1
			Qname = "CakeQuest2"
			NameMon = "Baking Staff"
			PosQ = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143e-08, .250778586, 4.74911062e-08, 1, 1.49904711e-08, -0.250778586, 2.64211941e-08, -0.96804446)
			PosM = CFrame.new(-1887.8099365234, 77.618507385254, -12998.350585938)
		elseif I == 2275 or I <= 2299 then
			Mon = "Head Baker"
			Qdata = 2
			Qname = "CakeQuest2"
			NameMon = "Head Baker"
			PosQ = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143e-08, .250778586, 4.74911062e-08, 1, 1.49904711e-08, -0.250778586, 2.64211941e-08, -0.96804446)
			PosM = CFrame.new(-2216.1882324219, 82.884521484375, -12869.293945312)
		elseif I == 2300 or I <= 2324 then
			Mon = "Cocoa Warrior"
			Qdata = 1
			Qname = "ChocQuest1"
			NameMon = "Cocoa Warrior"
			PosQ = CFrame.new(233.22836303711, 29.876001358032, -12201.233398438)
			PosM = CFrame.new(-21.553283691406, 80.574996948242, -12352.387695312)
		elseif I == 2325 or I <= 2349 then
			Mon = "Chocolate Bar Battler"
			Qdata = 2
			Qname = "ChocQuest1"
			NameMon = "Chocolate Bar Battler"
			PosQ = CFrame.new(233.22836303711, 29.876001358032, -12201.233398438)
			PosM = CFrame.new(582.59057617188, 77.188095092773, -12463.162109375)
		elseif I == 2350 or I <= 2374 then
			Mon = "Sweet Thief"
			Qdata = 1
			Qname = "ChocQuest2"
			NameMon = "Sweet Thief"
			PosQ = CFrame.new(150.50663757324, 30.693693161011, -12774.502929688)
			PosM = CFrame.new(165.1884765625, 76.058853149414, -12600.836914062)
		elseif I == 2375 or I <= 2399 then
			Mon = "Candy Rebel"
			Qdata = 2
			Qname = "ChocQuest2"
			NameMon = "Candy Rebel"
			PosQ = CFrame.new(150.50663757324, 30.693693161011, -12774.502929688)
			PosM = CFrame.new(134.86563110352, 77.247680664062, -12876.547851562)
		elseif I == 2400 or I <= 2449 then
			Mon = "Candy Pirate"
			Qdata = 1
			Qname = "CandyQuest1"
			NameMon = "Candy Pirate"
			PosQ = CFrame.new(-1150.0400390625, 20.378934860229, -14446.334960938)
			PosM = CFrame.new(-1310.5003662109, 26.016523361206, -14562.404296875)
		elseif I == 2450 or I <= 2474 then
			Mon = "Isle Outlaw"
			Qdata = 1
			Qname = "TikiQuest1"
			NameMon = "Isle Outlaw"
			PosQ = CFrame.new(-16548.8164, 55.6059914, -172.8125, .213092566, 0, -0.977032006, 0, 1, 0, .977032006, 0, .213092566)
			PosM = CFrame.new(-16479.900390625, 226.6117401123, -300.31143188477)
		elseif I == 2475 or I <= 2499 then
			Mon = "Island Boy"
			Qdata = 2
			Qname = "TikiQuest1"
			NameMon = "Island Boy"
			PosQ = CFrame.new(-16548.8164, 55.6059914, -172.8125, .213092566, 0, -0.977032006, 0, 1, 0, .977032006, 0, .213092566)
			PosM = CFrame.new(-16849.396484375, 192.86505126953, -150.78532409668)
		elseif I == 2500 or I <= 2524 then
			Mon = "Sun-kissed Warrior"
			Qdata = 1
			Qname = "TikiQuest2"
			NameMon = "kissed Warrior"
			PosM = CFrame.new(-16347, 64, 984)
			PosQ = CFrame.new(-16538, 55, 1049)
		elseif I == 2525 or I <= 2550 then
			Mon = "Isle Champion"
			Qdata = 2
			Qname = "TikiQuest2"
			NameMon = "Isle Champion"
			PosQ = CFrame.new(-16541.0215, 57.3082275, 1051.46118, .0410757065, 0, -0.999156058, 0, 1, 0, .999156058, 0, .0410757065)
			PosM = CFrame.new(-16602.1015625, 130.38734436035, 1087.2456054688)
		elseif I == 2551 or I <= 2574 then
			Mon = "Serpent Hunter"
			Qdata = 1
			Qname = "TikiQuest3"
			NameMon = "Serpent Hunter"
			PosQ = CFrame.new(-16668.03,105.32,1568.60)
			PosM = CFrame.new(-16645.64,163.09,1352.87)
		elseif I >= 2575 and I <= 2599 then
			Mon = "Skull Slayer"
			Qdata = 2
			Qname = "TikiQuest3"
			NameMon = "Skull Slayer"
			PosQ = CFrame.new(-16668.03,105.32,1568.60)
			PosM = CFrame.new(-16709.49,419.68,1751.09)
		elseif I >= 2600 and I <= 2624 then
			PosQ = CFrame.new(10778.875, -2087.72437, 9265.18359, 0.934615612, -9.33109447e-08, -0.355659455, 9.17655143e-08, 1, -2.12154276e-08, 0.355659455, -1.28090019e-08, 0.934615612)
			if (getgenv().AutoFarm or _G.Level) and (PosQ.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
				_tp(CFrame.new(-16269.7041, 25.2288494, 1373.65955, 0.997390985, 1.47309942e-09, -0.0721890926, -4.00651912e-09, 0.99999994, -2.51183763e-09, 0.0721890852, 5.75363091e-10, 0.997390926))
				task.wait(2)
				local args = {"TravelToSubmergedIsland"}
				game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/SubmarineWorkerSpeak"):InvokeServer(unpack(args))
				return
			end
			-- Código para executar SOMENTE se já estiver na ilha
			Mon = "Reef Bandit"
			Qdata = 1
			Qname = "SubmergedQuest1"
			NameMon = "Reef Bandit"
			PosM = CFrame.new(11019.1318, -2146.06812, 9342.3916, -0.719955266, -1.74275385e-08, 0.69402045, 5.76556367e-08, 1, 8.49211546e-08, -0.69402045, 1.01153624e-07, -0.719955266)
		elseif I >= 2625 and I <= 2649 then
			PosQ = CFrame.new(10778.875, -2087.72437, 9265.18359, 0.934615612, -9.33109447e-08, -0.355659455, 9.17655143e-08, 1, -2.12154276e-08, 0.355659455, -1.28090019e-08, 0.934615612)
			if (getgenv().AutoFarm or _G.Level) and (PosQ.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
				_tp(CFrame.new(-16269.7041, 25.2288494, 1373.65955, 0.997390985, 1.47309942e-09, -0.0721890926, -4.00651912e-09, 0.99999994, -2.51183763e-09, 0.0721890852, 5.75363091e-10, 0.997390926))
				task.wait(2)
				local args = {"TravelToSubmergedIsland"}
				game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/SubmarineWorkerSpeak"):InvokeServer(unpack(args))
				return
			end
			-- Código para executar SOMENTE se já estiver na ilha
			Mon = "Coral Pirate"
			Qdata = 2
			Qname = "SubmergedQuest1"
			NameMon = "Coral Pirate"
			PosM = CFrame.new(10808.6006, -2030.36145, 9364.2334, -0.775185347, -0.0359364748, 0.6307109, 0.0615428537, 0.989336014, 0.132010356, -0.628728986, 0.141148239, -0.764707148)
		elseif I >= 2650 and I <= 2674 then
			PosQ = CFrame.new(10880.6855, -2086.20044, 10032.624, -0.321384728, 9.87648434e-08, -0.946948707, 7.13271007e-08, 1, 8.00902953e-08, 0.946948707, -4.18033075e-08, -0.321384728)
			if (getgenv().AutoFarm or _G.Level) and (PosQ.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
				_tp(CFrame.new(-16269.7041, 25.2288494, 1373.65955, 0.997390985, 1.47309942e-09, -0.0721890926, -4.00651912e-09, 0.99999994, -2.51183763e-09, 0.0721890852, 5.75363091e-10, 0.997390926))
				task.wait(2)
				local args = {"TravelToSubmergedIsland"}
				game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/SubmarineWorkerSpeak"):InvokeServer(unpack(args))
				return
			end
			-- Código para executar SOMENTE se já estiver na ilha
			Mon = "Sea Chanter"
			Qdata = 1
			Qname = "SubmergedQuest2"
			NameMon = "Sea Chanter"
			PosM = CFrame.new(10671.2715, -2057.59155, 10047.2588, -0.846484065, -3.11045447e-08, 0.532414079, -5.55383117e-08, 1, -2.98785316e-08, -0.532414079, -5.48610757e-08, -0.846484065)
		elseif I >= 2675 and I <= 2699 then
			PosQ = CFrame.new(10880.6855, -2086.20044, 10032.624, -0.321384728, 9.87648434e-08, -0.946948707, 7.13271007e-08, 1, 8.00902953e-08, 0.946948707, -4.18033075e-08, -0.321384728)
			if (getgenv().AutoFarm or _G.Level) and (PosQ.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
				_tp(CFrame.new(-16269.7041, 25.2288494, 1373.65955, 0.997390985, 1.47309942e-09, -0.0721890926, -4.00651912e-09, 0.99999994, -2.51183763e-09, 0.0721890852, 5.75363091e-10, 0.997390926))
				task.wait(2)
				local args = {"TravelToSubmergedIsland"}
				game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/SubmarineWorkerSpeak"):InvokeServer(unpack(args))
				return
			end
			-- Código para executar SOMENTE se já estiver na ilha
			Mon = "Ocean Prophet"
			Qdata = 2
			Qname = "SubmergedQuest2"
			NameMon = "Ocean Prophet"
			PosM = CFrame.new(11008.5195, -2007.72839, 10223.0791, -0.688615739, 2.33523378e-09, -0.725126445, 2.99292546e-09, 1, 3.78221315e-10, 0.725126445, -1.90980032e-09, -0.688615739)
		elseif I >= 2700 and I <= 2724 then
			PosQ = CFrame.new(9640.08789, -1992.44507, 9613.65234, -0.957327187, 4.11991223e-08, 0.289006323, 1.5775445e-08, 1, -9.02985846e-08, -0.289006323, -8.18860855e-08, -0.957327187)
			if (getgenv().AutoFarm or _G.Level) and (PosQ.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
				_tp(CFrame.new(-16269.7041, 25.2288494, 1373.65955, 0.997390985, 1.47309942e-09, -0.0721890926, -4.00651912e-09, 0.99999994, -2.51183763e-09, 0.0721890852, 5.75363091e-10, 0.997390926))
				task.wait(2)
				local args = {"TravelToSubmergedIsland"}
				game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/SubmarineWorkerSpeak"):InvokeServer(unpack(args))
				return
			end
			-- Código para executar SOMENTE se já estiver na ilha
			Mon = "High Disciple"
			Qdata = 1
			Qname = "SubmergedQuest3"
			NameMon = "High Disciple"
			PosM = CFrame.new(9750.41602, -1966.93884, 9753.36035, -0.749824047, 5.57797613e-08, -0.661637306, 2.03500754e-08, 1, 6.1243199e-08, 0.661637306, 3.24572511e-08, -0.749824047)
		elseif I >= 2725 then
			PosQ = CFrame.new(9640.08789, -1992.44507, 9613.65234, -0.957327187, 4.11991223e-08, 0.289006323, 1.5775445e-08, 1, -9.02985846e-08, -0.289006323, -8.18860855e-08, -0.957327187)
			if (getgenv().AutoFarm or _G.Level) and (PosQ.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
				_tp(CFrame.new(-16269.7041, 25.2288494, 1373.65955, 0.997390985, 1.47309942e-09, -0.0721890926, -4.00651912e-09, 0.99999994, -2.51183763e-09, 0.0721890852, 5.75363091e-10, 0.997390926))
				task.wait(2)
				local args = {"TravelToSubmergedIsland"}
				game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/SubmarineWorkerSpeak"):InvokeServer(unpack(args))
				return
			end
			-- Código para executar SOMENTE se já estiver na ilha
			Mon = "Grand Devotee"
			Qdata = 2
			Qname = "SubmergedQuest3"
			NameMon = "Grand Devotee"
			PosM = CFrame.new(9611.70508, -1993.47119, 9882.68848, -0.591375351, 4.14332426e-08, -0.806396425, 4.73774868e-08, 1, 1.66361875e-08, 0.806396425, -2.83668058e-08, -0.591375351)
		end
	end
end

MaterialMon = function()
		local I = game.Players.LocalPlayer;
		local e = I.Character and I.Character:FindFirstChild("HumanoidRootPart");
		if not e then
			return;
		end;
		shouldRequestEntrance = function(I, K)
				local n = (e.Position - I).Magnitude;
				if n >= K then
					replicated.Remotes.CommF_:InvokeServer("requestEntrance", I);
				end;
			end;
		if World1 then
			if SelectMaterial == "Angel Wings" then
				MMon = {
						"Shanda",
						"Royal Squad",
						"Royal Soldier",
						"Wysper",
						"Thunder God",
					};
				MPos = CFrame.new(-4698, 845, -1912);
				SP = "Default";
				local I = Vector3.new(-4607.82275, 872.54248, -1667.55688);
				shouldRequestEntrance(I, 10000);
			elseif SelectMaterial == "Leather + Scrap Metal" then
				MMon = { "Brute", "Pirate" };
				MPos = CFrame.new(-1145, 15, 4350);
				SP = "Default";
			elseif SelectMaterial == "Magma Ore" then
				MMon = { "Military Soldier", "Military Spy", "Magma Admiral" };
				MPos = CFrame.new(-5815, 84, 8820);
				SP = "Default";
			elseif SelectMaterial == "Fish Tail" then
				MMon = { "Fishman Warrior", "Fishman Commando", "Fishman Lord" };
				MPos = CFrame.new(61123, 19, 1569);
				SP = "Default";
				local I = Vector3.new(61163.8515625, 5.342342376709, 1819.7841796875);
				shouldRequestEntrance(I, 17000);
			end;
		elseif World2 then
			if SelectMaterial == "Leather + Scrap Metal" then
				MMon = { "Marine Captain" };
				MPos = CFrame.new(-2010.5059814453, 73.001159667969, -3326.6208496094);
				SP = "Default";
			elseif SelectMaterial == "Magma Ore" then
				MMon = { "Magma Ninja", "Lava Pirate" };
				MPos = CFrame.new(-5428, 78, -5959);
				SP = "Default";
			elseif SelectMaterial == "Ectoplasm" then
    MMon = {
            "Ship Deckhand",
            "Ship Engineer",
            "Ship Steward",
            "Ship Officer",
        };
    MPos = CFrame.new(911.35827636719, 125.95812988281, 33159.5390625);
    SP = "Default";
    -- Coordenada CORRIGIDA para a entrada do Navio Assombrado (Sea 2)
    local I = Vector3.new(923.21252441406, 126.9760055542, 32852.83203125);

    -- Verifica se você está longe da entrada. Se estiver, pede para entrar.
    shouldRequestEntrance(I, 1000);

			elseif SelectMaterial == "Mystic Droplet" then
				MMon = { "Water Fighter" };
				MPos = CFrame.new(-3385, 239, -10542);
				SP = "Default";
			elseif SelectMaterial == "Radioactive Material" then
				MMon = { "Factory Staff" };
				MPos = CFrame.new(295, 73, -56);
				SP = "Default";
			elseif SelectMaterial == "Vampire Fang" then
				MMon = { "Vampire" };
				MPos = CFrame.new(-6033, 7, -1317);
				SP = "Default";
			end;
		elseif World3 then
			if SelectMaterial == "Scrap Metal" then
				MMon = { "Jungle Pirate", "Forest Pirate" };
				MPos = CFrame.new(-11975.78515625, 331.77340698242, -10620.030273438);
				SP = "Default";
			elseif SelectMaterial == "Fish Tail" then
				MMon = { "Fishman Raider", "Fishman Captain" };
				MPos = CFrame.new(-10993, 332, -8940);
				SP = "Default";
			elseif SelectMaterial == "Conjured Cocoa" then
				MMon = { "Chocolate Bar Battler", "Cocoa Warrior" };
				MPos = CFrame.new(620.63446044922, 78.936447143555, -12581.369140625);
				SP = "Default";
			elseif SelectMaterial == "Dragon Scale" then
				MMon = { "Dragon Crew Archer", "Dragon Crew Warrior" };
				MPos = CFrame.new(6594, 383, 139);
				SP = "Default";
			elseif SelectMaterial == "Gunpowder" then
				MMon = { "Pistol Billionaire" };
				MPos = CFrame.new(-84.855690002441, 85.620613098145, 6132.0087890625);
				SP = "Default";
			elseif SelectMaterial == "Mini Tusk" then
				MMon = { "Mythological Pirate" };
				MPos = CFrame.new(-13545, 470, -6917);
				SP = "Default";
			elseif SelectMaterial == "Demonic Wisp" then
				MMon = { "Demonic Soul" };
				MPos = CFrame.new(-9495.6806640625, 453.58624267578, 5977.3486328125);
				SP = "Default";
			end;
		end;
	end;
QuestNeta = function()
		local I = QuestCheck();
		return {
			[1] = Mon,
			[2] = Qdata,
			[3] = Qname,
			[4] = PosM,
			[5] = NameMon,
			[6] = PosQ,
		};
end;
-- ==============================================================================
-- 5. FLUENT UI INITIALIZATION
-- ==============================================================================
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Aurora Hub",
    SubTitle = "Premium Blox Fruits",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main Farming", Icon = "swords" }),
    Stats = Window:AddTab({ Title = "Auto Stats", Icon = "bar-chart" }),
    Boss = Window:AddTab({ Title = "Boss & Events", Icon = "skull" }),
    Misc = Window:AddTab({ Title = "Misc Features", Icon = "box" })
}

-- ================== TAB MAIN ==================
Tabs.Main:AddSection("Farming Settings")
local WpDropdown = Tabs.Main:AddDropdown("FarmWp", { Title = "Select Farm Weapon", Values = {"Melee", "Blox Fruit", "Sword", "Gun"}, Multi = false, Default = 1 })
WpDropdown:OnChanged(function(Value) _G.ChooseWP = Value end)

local ModeDropdown = Tabs.Main:AddDropdown("FarmMode", { Title = "Select Farm Mode", Values = {"Level", "Bone", "Cake Prince", "Tyrant Of The Skies"}, Multi = false, Default = 1 })
ModeDropdown:OnChanged(function(Value) _G.SelectedFarmMode = Value end)

local FarmToggle = Tabs.Main:AddToggle("StartFarmToggle", {Title = "Start Auto Farm", Default = false })
FarmToggle:OnChanged(function(Value) _G.StartFarm = Value end)

local KenToggle = Tabs.Main:AddToggle("KenToggle", {Title = "Accept Quest", Default = true })
KenToggle:OnChanged(function(Value) _G.AcceptQuest = Value end)

local FastToggle = Tabs.Main:AddToggle("FastToggle", {Title = "Super Attack", Default = true })
FastToggle:OnChanged(function(Value) _G.Seriality = Value end)

local BringToggle = Tabs.Main:AddToggle("BringToggle", {Title = "Bring Mob", Default = true })
BringToggle:OnChanged(function(Value) _B = Value end)

Window:SelectTab(1)
Fluent:Notify({ Title = "Aurora Hub", Content = "Semua Fungsi & Logic berhasil dimuat!", Duration = 5 })

-- ==============================================================================
-- 6. MAIN EXECUTION LOOPS (BACKGROUND)
-- ==============================================================================
-- ==============================================================================
-- STRUKTUR PENUTUP (Copy & Paste bagian ini ke paling bawah script kamu)
-- ==============================================================================


-- 1. [MAIN STATE CONTROLLER]
task.spawn(function()
    while task.wait(0.5) do
        if _G.StartFarm then
            _G.Level = (_G.SelectedFarmMode == "Level")
            _G.AutoFarm_Bone = (_G.SelectedFarmMode == "Bone")
            _G.AutoFarm_Cake = (_G.SelectedFarmMode == "Cake Prince")
            _G.AutoTyrant = (_G.SelectedFarmMode == "Tyrant Of The Skies")
        else
            _G.Level = false
            _G.AutoFarm_Bone = false
            _G.AutoFarm_Cake = false
            _G.AutoTyrant = false
        end
    end
end)




spawn(function()
    while wait(Sec) do
        pcall(function()
            for _, e in pairs(plr.Backpack:GetChildren()) do
                if e.ToolTip == _G.ChooseWP then
                    if plr.Backpack:FindFirstChild(e.Name) then
                        _G.SelectWeapon = e.Name
                    end
                end
            end
        end)
    end
end)

-- VARIAVEIS GLOBAIS
_G.SelectedFarmMode = "Level"
_G.StartFarm = false
_G.Level = false
_G.AutoFarm_Bone = false
_G.AutoFarm_Cake = false
_G.AutoTyrant = false -- Adicionado
_G.AcceptQuest = false

-- Variável para guardar o mob de Level Farm
local CurrentMobLevel = nil
local CurrentMobLevelSystem = nil

-- Define o limite de distância para teleporte condicional (em studs)
local TELEPORT_DISTANCE_THRESHOLD = 15

-- Função auxiliar para teleporte condicional
local function TeleportConditional(hrp, targetCFrame, threshold)
    if not hrp or not targetCFrame then return end

    local dist = (targetCFrame.Position - hrp.Position).Magnitude
    if dist > threshold then
        _tp(targetCFrame)
    end
end
--

----------------------------------------------------------------------------
-- 2. LÓGICA DO TYRANT (FARM, QUESTS E BOSS)
----------------------------------------------------------------------------

-- Configurações
local FarmHeight = 30 -- Altura segura para não bugar no mob

-- NoClip Reforçado (Para não travar nas paredes/mobs)
spawn(function()
    game:GetService("RunService").Stepped:Connect(function()
        if _G.AutoTyrant and _G.StartFarm then
            local char = game.Players.LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
                if char:FindFirstChild("Humanoid") then
                    char.Humanoid.AutoRotate = true
                    char.Humanoid:ChangeState(11)
                end
            end
        end
    end)
end)

-- Função Mágica: Seleciona o Mob/Quest exato pelo Nível
local function GetTargetByLevel()
    local myLevel = game.Players.LocalPlayer.Data.Level.Value

-- [LEVEL 2575+] SKULL SLAYER
if myLevel >= 2575 then
    return {
        Name = "Skull Slayer",
        QuestArgs = {"StartQuest", "TikiQuest3", 2},
        QuestPos = CFrame.new(
            -16665.0879, 105.27478, 1577.61743,
            -0.999621451, 3.5280582e-08, 0.0275127869,
             3.5990368e-08, 1, 2.53032191e-08,
            -0.0275127869, 2.62838356e-08, -0.999621451
        ),
        FarmPos = CFrame.new(-16709.49, 419.68, 1751.09)
    }

-- [LEVEL 2551 - 2574] SERPENT HUNTER
elseif myLevel > 2550 then
    return {
        Name = "Serpent Hunter",
        QuestArgs = {"StartQuest", "TikiQuest3", 1},
        QuestPos = CFrame.new(
            -16665.0879, 105.27478, 1577.61743,
            -0.999621451, 3.5280582e-08, 0.0275127869,
             3.5990368e-08, 1, 2.53032191e-08,
            -0.0275127869, 2.62838356e-08, -0.999621451
        ),
        FarmPos = CFrame.new(-16645.64, 163.09, 1352.87)
    }

-- [LEVEL 2525 - 2550] ISLE CHAMPION
elseif myLevel >= 2525 then
    return {
        Name = "Isle Champion",
        QuestArgs = {"StartQuest", "TikiQuest2", 2},
        QuestPos = CFrame.new(
            -16546.748, 55.7216759, -172.865311,
            -0.0595058464, 2.45485676e-08, 0.998227954,
            -5.3272025e-08, 1, -2.77677703e-08,
            -0.998227954, -5.48299717e-08, -0.0595058464
        ),
        FarmPos = CFrame.new(-16602.1015625, 130.38734436035, 1087.2456054688)
    }

-- [LEVEL 2500 - 2524] SUN-KISSED WARRIOR
elseif myLevel >= 2500 then
    return {
        Name = "Sun-kissed Warrior",
        QuestArgs = {"StartQuest", "TikiQuest2", 1},
        QuestPos = CFrame.new(
            -16546.748, 55.7216759, -172.865311,
            -0.0595058464, 2.45485676e-08, 0.998227954,
            -5.3272025e-08, 1, -2.77677703e-08,
            -0.998227954, -5.48299717e-08, -0.0595058464
        ),
        FarmPos = CFrame.new(-16347, 64, 984)
    }

-- [LEVEL 2475 - 2499] ISLAND BOY
elseif myLevel >= 2475 then
    return {
        Name = "Island Boy",
        QuestArgs = {"StartQuest", "TikiQuest1", 2},
        QuestPos = CFrame.new(
            -16546.748, 55.7216759, -172.865311,
            -0.0595058464, 2.45485676e-08, 0.998227954,
            -5.3272025e-08, 1, -2.77677703e-08,
            -0.998227954, -5.48299717e-08, -0.0595058464
        ),
        FarmPos = CFrame.new(-16670, 43, -270)
    }

-- [LEVEL < 2475] ISLE OUTLAW
else
    return {
        Name = "Isle Outlaw",
        QuestArgs = {"StartQuest", "TikiQuest1", 1},
        QuestPos = CFrame.new(
            -16546.748, 55.7216759, -172.865311,
            -0.0595058464, 2.45485676e-08, 0.998227954,
            -5.3272025e-08, 1, -2.77677703e-08,
            -0.998227954, -5.48299717e-08, -0.0595058464
        ),
        FarmPos = CFrame.new(-16350, 45, -180)
    }
end
end

-- Verifica quantos "Olhos" (Vasos) foram quebrados
local function GetEyesCount()
    local model = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("TikiOutpost") and workspace.Map.TikiOutpost:FindFirstChild("IslandModel")
    local count = 0
    if model then
        local eye1 = model:FindFirstChild("Eye1")
        local eye2 = model:FindFirstChild("Eye2")
        local chunks = model:FindFirstChild("IslandChunks")
        local eye3 = chunks and chunks:FindFirstChild("E") and chunks.E:FindFirstChild("Eye3")
        local eye4 = chunks and chunks:FindFirstChild("E") and chunks.E:FindFirstChild("Eye4")
        if eye1 and eye1.Transparency == 0 then count = count + 1 end
        if eye2 and eye2.Transparency == 0 then count = count + 1 end
        if eye3 and eye3.Transparency == 0 then count = count + 1 end
        if eye4 and eye4.Transparency == 0 then count = count + 1 end
    end
    return count
end

-- Usa skills para quebrar os vasos
local function UseAllCategorySkills()
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local VirtualUser = game:GetService("VirtualUser")
    local categories = {"Melee", "Blox Fruit", "Sword", "Gun"}
    local skills = {"Z", "X", "C"}

    pcall(function()
        game:GetService("VirtualInputManager"):SendKeyEvent(true, "RightControl", false, game)
        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, workspace.CurrentCamera.CFrame.Position + Vector3.new(0,-1,0))
    end)

    for _, toolType in ipairs(categories) do
        local tool = nil
        for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if v:IsA("Tool") and v.ToolTip == toolType then tool = v break end
        end
        if not tool then
            local charTool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if charTool and charTool.ToolTip == toolType then tool = charTool end
        end
        if tool then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
            task.wait(0.1)
            for i = 1, 3 do
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(851, 158))
                local skillKey = skills[i]
                if skillKey then
                    VirtualInputManager:SendKeyEvent(true, skillKey, false, game)
                    task.wait(0.05)
                    VirtualInputManager:SendKeyEvent(false, skillKey, false, game)
                end
                task.wait(0.1)
            end
        end
    end
end

-- LOOP PRINCIPAL DO FARM
spawn(function()
    local VaseIndex = 1 -- Índice para controlar qual vaso atacar

    while task.wait() do
        -- Só roda se a toggle estiver ativada E o modo for Tyrant
        if _G.AutoTyrant and _G.StartFarm then
            pcall(function()
                local plr = game.Players.LocalPlayer
                local boss = workspace.Enemies:FindFirstChild("Tyrant of the Skies")
                local eyes = GetEyesCount()

                -- [PRIORIDADE 1] MATAR BOSS
                if boss and boss.Humanoid.Health > 0 then
                    _tp(boss.HumanoidRootPart.CFrame * CFrame.new(0, FarmHeight, 0))
                    repeat task.wait()
                        if boss and boss:FindFirstChild("HumanoidRootPart") then
                            _tp(boss.HumanoidRootPart.CFrame * CFrame.new(0, FarmHeight, 0))
                            EquipWeapon(_G.SelectWeapon)
                            G.Kill(boss, true)
                        else
                            break
                        end
                    until not boss.Parent or boss.Humanoid.Health <= 0 or not _G.StartFarm or not _G.AutoTyrant

                -- [PRIORIDADE 2] QUEBRAR 4 VASOS PARA INVOCAR
                elseif eyes == 4 then
                    local targetsty = {
                        CFrame.new(-16335.1, 158.1, 1465.6), CFrame.new(-16288.6, 158.1, 1470.3),
                        CFrame.new(-16258.0, 156.7, 1461.4), CFrame.new(-16212.4, 158.1, 1466.3),
                        CFrame.new(-16335.0, 159.3, 1324.8), CFrame.new(-16286.0, 155.9, 1323.8),
                        CFrame.new(-16250.3, 159.3, 1316.3)
                    }

                    -- CORREÇÃO: Usa o VaseIndex para ciclar entre os vasos ao invés de resetar o loop
                    local pos = targetsty[VaseIndex]

                    if pos then
                        _tp(pos)

                        local char = plr.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            -- Só ataca se estiver perto
                            if (char.HumanoidRootPart.Position - pos.Position).Magnitude < 15 then
                                char.HumanoidRootPart.Anchored = true
                                UseAllCategorySkills()
                                task.wait(0.1)
                                char.HumanoidRootPart.Anchored = false

                                -- Passa para o próximo vaso
                                VaseIndex = VaseIndex + 1
                                if VaseIndex > #targetsty then
                                    VaseIndex = 1
                                end
                            end
                        end
                    end

                -- [PRIORIDADE 3] FARM NORMAL (TODOS OS MOBS + QUEST)
                else
                    local TargetData = GetTargetByLevel()
                    local QuestUI = plr.PlayerGui.Main.Quest
                    local hasQuest = QuestUI.Visible

                    -- A. PEGAR QUEST
                    if _G.AcceptQuest and not hasQuest then
                        local char = plr.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            local distToNPC = (char.HumanoidRootPart.Position - TargetData.QuestPos.Position).Magnitude

                            if distToNPC <= 3 then
                                char.HumanoidRootPart.CFrame = TargetData.QuestPos
                                task.wait(0.1)
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(TargetData.QuestArgs))
                                task.wait(0.5)
                            else
                                _tp(TargetData.QuestPos)
                            end
                        end

                    -- B. MATAR MOBS
                    else
                        local char = plr.Character or plr.CharacterAdded:Wait()
                        local hrp = char:WaitForChild("HumanoidRootPart", 1)

                        if hrp then
                            local closestEnemy = nil
                            local shortestDistance = math.huge

                            local AllMobs = {"Skull Slayer", "Serpent Hunter", "Isle Champion", "Sun-kissed Warrior", "Island Boy", "Isle Outlaw"}

                            for _, v in pairs(workspace.Enemies:GetChildren()) do
                                if table.find(AllMobs, v.Name) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                                    local distance = (hrp.Position - v.HumanoidRootPart.Position).Magnitude
                                    if distance < shortestDistance then
                                        shortestDistance = distance
                                        closestEnemy = v
                                    end
                                end
                            end

                            if closestEnemy then
                                local enemyPos = closestEnemy.HumanoidRootPart.CFrame
                                _tp(enemyPos * CFrame.new(0, FarmHeight, 0))
                                EquipWeapon(_G.SelectWeapon)
                                G.Kill(closestEnemy, true)
                             
                            else
                                _tp(TargetData.FarmPos)
                            end
                        end
                    end
                end
            end)
        end
    end
end)





-- 3. SISTEMA BONE FARM (CORRIGIDO)
spawn(function()
    while task.wait() do
        if _G.AutoFarm_Bone and _G.StartFarm then
            pcall(function()
                local plr = game.Players.LocalPlayer
                local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                local QuestUI = plr.PlayerGui.Main.Quest
                local MOBS = {"Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy"}
                local npcPos = CFrame.new(-9516.99, 172.01, 6078.46) -- Posição do NPC de Bones

                -- [PASSO 1] SE PRECISAR DE QUEST, VAI AO NPC PRIMEIRO
                if _G.AcceptQuest and not QuestUI.Visible then
                    local distToNPC = (npcPos.Position - hrp.Position).Magnitude

                    if distToNPC > 10 then
                        _tp(npcPos) -- Teleporta direto para o NPC
                    else
                        -- Se estiver perto, tenta pegar a quest
                        task.wait(0.1)
                        local quests = {
                            {"StartQuest","HauntedQuest1",1},
                            {"StartQuest","HauntedQuest1",2},
                            {"StartQuest","HauntedQuest2",1},
                            {"StartQuest","HauntedQuest2",2}
                        }
                        -- Tenta pegar a quest baseada no seu level (opcional: deixei aleatório como no seu original)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(quests[math.random(1,#quests)]))
                        task.wait(1) -- Espera a quest carregar na UI
                    end

                -- [PASSO 2] SE JÁ TEM QUEST OU NÃO QUER ACEITAR, VAI FARMAL
                else
                    local function GetClosestMob()
                        local closest, shortest = nil, math.huge
                        for _, mobName in pairs(MOBS) do
                            for _, mob in pairs(workspace.Enemies:GetChildren()) do
                                if mob.Name == mobName and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                                    local dist = (mob.PrimaryPart.Position - hrp.Position).Magnitude
                                    if dist < shortest then
                                        shortest = dist
                                        closest = mob
                                    end
                                end
                            end
                        end
                        return closest
                    end

                    local mob = GetClosestMob()
                    if mob then
                        -- Teleporta para o mob e mata
                        _tp(mob.PrimaryPart.CFrame)
                        EquipWeapon(_G.SelectWeapon)
                        G.Kill(mob, true)
                    else
                        -- Se não achar mobs, vai para o spot de spawn deles
                        _tp(CFrame.new(-9495.68, 453.58, 5977.34))
                    end
                end
            end)
        end
    end
end)

---

-- 4. SISTEMA LEVEL FARM

local CurrentMob = nil

local function GetNearestMob(TargetName)
    local plr = game.Players.LocalPlayer
    local Root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not Root then return nil end
    local Closest, Dist = nil, math.huge
    for _, Mob in pairs(workspace.Enemies:GetChildren()) do
        if G.Alive(Mob) and Mob.Name == TargetName and Mob:FindFirstChild("HumanoidRootPart") then
            local d = (Mob.HumanoidRootPart.Position - Root.Position).Magnitude
            if d < Dist then Dist = d Closest = Mob end
        end
    end
    return Closest
end

spawn(function()
    while task.wait() do
        if _G.Level and _G.StartFarm then
            pcall(function()
                local plr = game.Players.LocalPlayer
                local Root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if not Root then return end
                local QuestTitle = plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                local Q = QuestNeta()
                if not string.find(QuestTitle, Q[5]) then game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest") end
                if not plr.PlayerGui.Main.Quest.Visible then
                    TeleportConditional(Root, Q[6], TELEPORT_DISTANCE_THRESHOLD)
                    if (Root.Position - Q[6].Position).Magnitude <= 50 then
                        task.wait(1.9)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Q[3], Q[2])
                    end
                    return
                end
                local Nearest = GetNearestMob(Q[1])
                if CurrentMob and G.Alive(CurrentMob) and CurrentMob.Parent then
                    G.Kill(CurrentMob, true)
                    return
                else CurrentMob = nil end
                if not Nearest then TeleportConditional(Root, Q[4], TELEPORT_DISTANCE_THRESHOLD) return end
                CurrentMob = Nearest
                if CurrentMob and CurrentMob:FindFirstChild("HumanoidRootPart") then _tp(CurrentMob.HumanoidRootPart.CFrame) end
                repeat task.wait() G.Kill(CurrentMob, true) until not _G.StartFarm or not _G.Level or not CurrentMob.Parent or CurrentMob.Humanoid.Health <= 0
                CurrentMob = nil
            end)
        end
    end
end)

---

-- 5. SISTEMA CAKE PRINCE FARM

spawn(function()
    while task.wait() do
        if _G.AutoFarm_Cake and _G.StartFarm then
            pcall(function()
                local plr = game.Players.LocalPlayer
                local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local enemies = workspace:FindFirstChild("Enemies")
                if not enemies then return end
                local CakePos = CFrame.new(-2091.91, 70.00, -12142.83)
                local PortalEntrance = CFrame.new(-2151.82, 149.32, -12404.91)
                local mirror = workspace.Map:FindFirstChild("CakeLoaf")
                mirror = mirror and mirror:FindFirstChild("BigMirror")
                local other = mirror and mirror:FindFirstChild("Other")
                local portalOpen = other and other.Transparency == 0
                local boss = enemies:FindFirstChild("Cake Prince") or enemies:FindFirstChild("Dough King")

                if not boss and not portalOpen and (hrp.Position - CakePos.Position).Magnitude > 300000 then
                    _tp(CakePos)
                    return
                end

                if boss or portalOpen then
                    if boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 and boss.PrimaryPart then
                        local bossTarget = boss.PrimaryPart.CFrame * CFrame.new(0, 5, 0)
                        _tp(bossTarget)
                        local bossPos = boss.PrimaryPart.CFrame * CFrame.new(0, 25, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                        _tp(bossPos)
                        G.Kill(boss, true)
                        return
                    end
                    if (hrp.Position - PortalEntrance.Position).Magnitude < 500000 then
                        TeleportConditional(hrp, PortalEntrance, TELEPORT_DISTANCE_THRESHOLD)
                    end
                    return
                end

                local CAKE_MOBS = {"Cookie Crafter", "Cake Guard", "Baking Staff", "Head Baker"}
                if _G.AcceptQuest and not plr.PlayerGui.Main.Quest.Visible then
                    local questPos = CFrame.new(-1927.92, 37.80, -12842.54)
                    TeleportConditional(hrp, questPos, TELEPORT_DISTANCE_THRESHOLD)
                    if (hrp.Position - questPos.Position).Magnitude <= 40 then
                        local q = {{"StartQuest", "CakeQuest2", 2}, {"StartQuest", "CakeQuest2", 1}, {"StartQuest", "CakeQuest1", 1}, {"StartQuest", "CakeQuest1", 2}}
                        game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(q[math.random(1, 4)]))
                    end
                    return
                end

                local bestMob, bestDist = nil, math.huge
                for _, mob in ipairs(enemies:GetChildren()) do
                    if table.find(CAKE_MOBS, mob.Name) and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                        local dist = (mob.HumanoidRootPart.Position - hrp.Position).Magnitude
                        if dist < bestDist then bestDist = dist bestMob = mob end
                    end
                end
                if bestMob then
                    repeat task.wait()
                        if (workspace.Map.CakeLoaf.BigMirror.Other.Transparency == 0) or enemies:FindFirstChild("Cake Prince") then break end
                        if bestMob.Parent and bestMob.Humanoid.Health > 0 then
                            _tp(bestMob.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0) * CFrame.Angles(math.rad(-90), 0, 0))
                            G.Kill(bestMob, true)
                        else break end
                    until not _G.StartFarm or not _G.AutoFarm_Cake or not bestMob.Parent or bestMob.Humanoid.Health <= 0
                else
                    TeleportConditional(hrp, CFrame.new(-1927.92, 37.80, -12842.54), TELEPORT_DISTANCE_THRESHOLD)
                end
            end)
        end
    end
  end)
  
  
  

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
local RegisterAttack = Net:WaitForChild("RE/RegisterAttack")
local RegisterHit = Net:WaitForChild("RE/RegisterHit")

-- Pengaturan agar serangan lebih "Powerful"
local ATTACK_RANGE = 80 -- Ditingkatkan agar lebih luas
local ATTACK_DELAY = 0.01 -- Jeda sangat singkat

local function GetTargets()
    local targets = {}
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return targets end

    local folders = {workspace.Enemies, workspace.Characters}
    
    for _, folder in pairs(folders) do
        for _, v in pairs(folder:GetChildren()) do
            if v ~= LocalPlayer.Character and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                local dist = (v.HumanoidRootPart.Position - myRoot.Position).Magnitude
                if dist <= ATTACK_RANGE then
                    table.insert(targets, v)
                end
            end
        end
    end
    return targets
end

-- Fungsi utama untuk eksekusi serangan
local function FastAttack()
    local targets = GetTargets()
    if #targets == 0 then return end

    local hitData = {}
    local primaryTarget = targets[1].Head -- Mengambil target pertama sebagai fokus

    for i, v in pairs(targets) do
        hitData[i] = {v, v.HumanoidRootPart}
    end

    -- Mengirim request serangan dengan interval minimal
    pcall(function()
        RegisterAttack:FireServer(0) -- Menggunakan delay 0 atau nilai kecil
        RegisterHit:FireServer(primaryTarget, hitData)
    end)
end

-- Loop ultra-cepat
task.spawn(function()
    while task.wait(ATTACK_DELAY) do
        local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            FastAttack()
        end
    end
end)
