local Update = (loadstring(Game:HttpGet("https://raw.githubusercontent.com/Krishnasavage/KinaHub/refs/heads/main/UiLua")))();
if Update:LoadAnimation() then
	Update:StartLoad();
end;
if Update:LoadAnimation() then
	Update:Loaded();
end; 

local UserInputService = game:GetService("UserInputService");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Lighting = game:GetService("Lighting");
local workspace = game:GetService("Workspace");
local localPlayer = Players.LocalPlayer;
local workspaceDescendants = workspace:GetDescendants();
local highlightMode;
local currentEntity;
local renderConnection;
local aimbotTargetBodyPart = "Head";
local aimbotFallbackPart = "HumanoidRootPart";
local nightVisionOn = false;
local espOn = false;
local noclipEnabled = false;
local aimbotEnabled = false;
local addedESPModels = {};
local onlyWhenAlive = true;
local highlightEnabled = true;
local warnNPCLabels = {};
local frameCounter = 0;
local frameCount = 20;
local priorityRadius = 90;
local showAimbotCircle = true;
local fovAngleDegrees = 90;
local circleColor = Color3.fromRGB(255, 0, 0);
local circleThickness = 2;
local circleTransparency = 1;
local circle = Drawing.new("Circle");
circle.Color = circleColor;
circle.Thickness = circleThickness;
circle.Transparency = circleTransparency;
circle.Visible = showAimbotCircle;
circle.Filled = false;
local itemDefinitions = {};
local entityDefinitions = {
	Model_Unicorn = {
		name = "Unicorn",
		highlight = "highlight",
		tags = {}
	},
	Model_Banker = {
		name = "Banker",
		highlight = "highlight",
		tags = { "aimbot", "enemy" }
	},
	Model_Werewolf = {
		name = "Werewolf",
		highlight = "warn",
		tags = { "aimbot", "enemy" }
	},
	Model_RevolverOutlaw = {
		name = "Outlaw (Revolver)",
		highlight = "warn",
		tags = { "aimbot", "enemy" }
	},
	Model_RifleOutlaw = {
		name = "Outlaw (Rifle)",
		highlight = "warn",
		tags = { "aimbot", "enemy" }
	},
	Model_ShotgunOutlaw = {
		name = "Outlaw (Shotgun)",
		highlight = "warn",
		tags = { "aimbot", "enemy" }
	},
	Model_ZombieMiner = {
		name = "Bomber Zombie",
		highlight = "warn",
		tags = { "aimbot", "enemy", "kill-first" }
	},
	Model_ZombieSheriff = {
		name = "Sheriff Zombie",
		highlight = "warn",
		tags = { "aimbot", "enemy", "kill-first" }
	},
	Model_Vampire = {
		name = "Vampire",
		highlight = "warn",
		tags = { "aimbot", "enemy" }
	},
	Model_Runner = {
		name = "Zombie (Fast)",
		highlight = "ignore",
		tags = { "aimbot", "enemy" }
	},
	Model_Walker = {
		name = "Zombie (Slow)",
		highlight = "ignore",
		tags = { "aimbot", "enemy" }
	},
	Model_Horse = {
		name = "Horse",
		highlight = "ignore",
		tags = {}
	},
	Model_Wolf = {
		name = "Wolf",
		highlight = "ignore",
		tags = {}
	},
	Model_RifleSoldier = {
		name = "Ground Soldier",
		highlight = "none",
		tags = {}
	},
	Model_TurretSoldier = {
		name = "Turret Soldier",
		highlight = "none",
		tags = {}
	},
	Shopkeeper = {
		name = "Shopkeeper",
		highlight = "none",
		tags = {}
	},
	Model_ArmoredZombie = {
		name = "Zombie (Armor)",
		highlight = "none",
		tags = { "aimbot", "enemy" }
	},
	Model_ZombieRevolverSoldier = {
		name = "Zombie (Revolver)",
		highlight = "",
		tags = { "aimbot", "enemy" }
	},
	Model_ZombieRifleSoldier = {
		name = "Zombie (Rifle)",
		highlight = "",
		tags = { "aimbot", "enemy" }
	},
	Model_ZombieShotgunSoldier = {
		name = "Zombie (Shotgun)",
		highlight = "",
		tags = { "aimbot", "enemy" }
	}
};
local defaultEntityHighlightModes = {
	Model_Unicorn = "highlight",
	Model_Banker = "highlight",
	Model_Werewolf = "warn",
	Model_RevolverOutlaw = "warn",
	Model_RifleOutlaw = "warn",
	Model_ShotgunOutlaw = "warn",
	Model_ZombieMiner = "warn",
	Model_ZombieSheriff = "warn",
	Model_Vampire = "warn",
	Model_Runner = "ignore",
	Model_Walker = "ignore",
	Model_Horse = "ignore",
	Model_Wolf = "ignore",
	Model_RifleSoldier = "none",
	Model_TurretSoldier = "none",
	Shopkeeper = "none",
	Model_ZombieRevolverSoldier = "",
	Model_ZombieRifleSoldier = "",
	Model_ZombieShotgunSoldier = "",
	Model_ArmoredZombie = ""
};
local entityNames = {
	Model_Unicorn = "Unicorn",
	Model_Werewolf = "Werewolf",
	Model_Runner = "Zombie (Fast)",
	Model_Walker = "Zombie (Slow)",
	Model_Horse = "Horse",
	Model_RifleSoldier = "Ground Soldier",
	Model_TurretSoldier = "Turret Soldier",
	Shopkeeper = "Shopkeeper",
	Model_Wolf = "Wolf",
	Model_RevolverOutlaw = "Outlaw (Revolver)",
	Model_RifleOutlaw = "Outlaw (Rifle)",
	Model_ShotgunOutlaw = "Outlaw (Shotgun)",
	Model_Banker = "Banker",
	Model_ZombieMiner = "Bomber Zombie",
	Model_ZombieSheriff = "Sheriff Zombie",
	Model_ArmoredZombie = "Zombie (Armor)",
	Model_Vampire = "Vampire",
	Model_ZombieRevolverSoldier = "Zombie (Revolver)",
	Model_ZombieRifleSoldier = "Zombie (Rifle)",
	Model_ZombieShotgunSoldier = "Zombie (Shotgun)"
};
local entityTags = {
	Model_Unicorn = {},
	Model_Werewolf = {
		"aimbot",
		"enemy"
	},
	Model_Runner = {
		"aimbot",
		"enemy"
	},
	Model_Walker = {
		"aimbot",
		"enemy"
	},
	Model_Horse = {},
	Model_RifleSoldier = {},
	Model_TurretSoldier = {},
	Shopkeeper = {},
	Model_Wolf = {},
	Model_RevolverOutlaw = {
		"aimbot",
		"enemy"
	},
	Model_RifleOutlaw = {
		"aimbot",
		"enemy"
	},
	Model_ShotgunOutlaw = {
		"aimbot",
		"enemy"
	},
	Model_Banker = {
		"aimbot",
		"enemy"
	},
	Model_ZombieMiner = {
		"aimbot",
		"enemy",
		"kill-first"
	},
	Model_ZombieSheriff = {
		"aimbot",
		"enemy",
		"kill-first"
	},
	Model_ArmoredZombie = {
		"aimbot",
		"enemy"
	},
	Model_Vampire = {
		"aimbot",
		"enemy"
	},
	Model_ZombieRevolverSoldier = {
		"aimbot",
		"enemy"
	},
	Model_ZombieRifleSoldier = {
		"aimbot",
		"enemy"
	},
	Model_ZombieShotgunSoldier = {
		"aimbot",
		"enemy"
	}
};
local playerChosenEntityHighlightModes = table.clone(defaultEntityHighlightModes);
local entityHighlightModes = table.clone(playerChosenEntityHighlightModes);
local readableHighlightModes = {};
for internalName, mode in pairs(defaultEntityHighlightModes) do
	local readableName = entityNames[internalName] or internalName;
	readableHighlightModes[readableName] = mode;
end;
local readableToInternal = {};
for internalName, mode in pairs(playerChosenEntityHighlightModes) do
	local readableName = entityNames[internalName] or internalName;
	readableToInternal[readableName] = internalName;
end;
local Library = Update:Window({
	SubTitle = "Dead Rails",
	Size = UDim2.new(0, 450, 0, 300),
	TabWidth = 140
});

local function capitalizeFirst(str)
	return (str:sub(1, 1)):upper() .. (str:sub(2)):lower();
end;
local function enableLighting()
	Lighting.Ambient = Color3.new(1, 1, 1);
	Lighting.Brightness = 5;
	Lighting.OutdoorAmbient = Color3.new(1, 1, 1);
	Lighting.ClockTime = 12;
end;
local function resetLighting()
	Lighting.Ambient = Color3.new(0, 0, 0);
	Lighting.Brightness = 2;
	Lighting.OutdoorAmbient = Color3.new(0, 0, 0);
end;
local function addEntityESP(model)
	if model:FindFirstChild("Humanoid") and (not model:FindFirstChild("ESP_Added")) then
		if Players:GetPlayerFromCharacter(model) then
			return;
		end;
		local mode = entityHighlightModes[model.Name];
		local name = entityNames[model.Name] or model.Name;
		local color = Color3.new(1, 0, 0);
		if mode == "none" then
			return;
		end;
		if mode == "highlight" then
			color = Color3.fromRGB(0, 255, 0);
		elseif mode == "warn" then
			color = Color3.fromRGB(255, 255, 0);
		end;
		for _, part in pairs(model:GetDescendants()) do
			if part:IsA("BasePart") then
				local box = Instance.new("BoxHandleAdornment");
				box.Size = part.Size;
				box.Adornee = part;
				box.AlwaysOnTop = true;
				box.ZIndex = 10;
				box.Transparency = 0.5;
				box.Color3 = color;
				box.Name = "ESPBox";
				box.Parent = part;
			end;
		end;
		local head = model:FindFirstChild("Head");
		if head and mode ~= "ignore" then
			local billboard = Instance.new("BillboardGui");
			billboard.Name = "NameESP";
			billboard.Size = UDim2.new(0, 150, 0, 40);
			billboard.StudsOffset = Vector3.new(0, 2, 0);
			billboard.AlwaysOnTop = true;
			billboard.Adornee = head;
			billboard.Parent = head;
			local nameLabel = Instance.new("TextLabel");
			nameLabel.Size = UDim2.new(1, 0, 1, 0);
			nameLabel.BackgroundTransparency = 1;
			nameLabel.TextColor3 = Color3.new(1, 1, 1);
			nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0);
			nameLabel.TextStrokeTransparency = 0.5;
			nameLabel.TextScaled = true;
			nameLabel.Font = Enum.Font.SourceSansBold;
			nameLabel.Text = name;
			if mode == "warn" then
				warnNPCLabels[model] = nameLabel;
			end;
			nameLabel.Parent = billboard;
		end;
		local tag = Instance.new("BoolValue");
		tag.Name = "ESP_Added";
		tag.Parent = model;
		table.insert(addedESPModels, model);
	end;
end;
local function addItemESP(model)
	if not model:FindFirstChild("ESP_Added") then
        -- need to replace with itemDefinitions
		local mode = itemHighlightModes[model.Name];
		local name = itemNames[model.Name] or model.Name;
		local color = Color3.new(1, 0, 0);
		if mode == "none" then
			return;
		end;
		if mode == "highlight" then
			color = Color3.fromRGB(0, 255, 0);
		elseif mode == "warn" then
			color = Color3.fromRGB(255, 255, 0);
		end;
		for _, part in pairs(model:GetDescendants()) do
			if part:IsA("BasePart") then
				local box = Instance.new("BoxHandleAdornment");
				box.Size = part.Size;
				box.Adornee = part;
				box.AlwaysOnTop = true;
				box.ZIndex = 10;
				box.Transparency = 0.5;
				box.Color3 = color;
				box.Name = "ESPBox";
				box.Parent = part;
			end;
		end;
		local head = model:FindFirstChild("Head");
		if head and mode ~= "ignore" then
			local billboard = Instance.new("BillboardGui");
			billboard.Name = "NameESP";
			billboard.Size = UDim2.new(0, 150, 0, 40);
			billboard.StudsOffset = Vector3.new(0, 2, 0);
			billboard.AlwaysOnTop = true;
			billboard.Adornee = head;
			billboard.Parent = head;
			local nameLabel = Instance.new("TextLabel");
			nameLabel.Size = UDim2.new(1, 0, 1, 0);
			nameLabel.BackgroundTransparency = 1;
			nameLabel.TextColor3 = Color3.new(1, 1, 1);
			nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0);
			nameLabel.TextStrokeTransparency = 0.5;
			nameLabel.TextScaled = true;
			nameLabel.Font = Enum.Font.SourceSansBold;
			nameLabel.Text = name;
			if mode == "warn" then
				warnNPCLabels[model] = nameLabel;
			end;
			nameLabel.Parent = billboard;
		end;
		local tag = Instance.new("BoolValue");
		tag.Name = "ESP_Added";
		tag.Parent = model;
		table.insert(addedESPModels, model);
	end;
end;
local function clearESP()
	for _, model in pairs(addedESPModels) do
		if model and model:IsDescendantOf(workspace) then
			for _, part in pairs(model:GetDescendants()) do
				if part:IsA("BasePart") then
					local box = part:FindFirstChild("ESPBox");
					if box then
						box:Destroy();
					end;
				end;
				if part:IsA("BillboardGui") and part.Name == "NameESP" then
					part:Destroy();
				end;
			end;
			local tag = model:FindFirstChild("ESP_Added");
			if tag then
				tag:Destroy();
			end;
		end;
	end;
	for model, nameLabel in pairs(warnNPCLabels) do
		if nameLabel and nameLabel.Parent then
			nameLabel:Destroy();
		end;
	end;
	warnNPCLabels = {};
	addedESPModels = {};
end;
renderConnection = RunService.RenderStepped:Connect(function()
	if espOn then
		frameCounter = frameCounter + 1;
		if frameCounter % frameCount == 0 then
			workspaceDescendants = workspace:GetDescendants();
			for _, model in pairs(workspaceDescendants) do
				if model:IsA("Model") and model:FindFirstChild("Humanoid") then
					local humanoid = model.Humanoid;
					local tagged = model:FindFirstChild("ESP_Added");
					if not tagged and humanoid.Health > 0 then
						addEntityESP(model);
					elseif onlyWhenAlive and tagged and humanoid.Health <= 0 then
						for _, part in pairs(model:GetDescendants()) do
							if part:IsA("BasePart") then
								local box = part:FindFirstChild("ESPBox");
								if box then
									box:Destroy();
								end;
							end;
							if part:IsA("BillboardGui") and part.Name == "NameESP" then
								part:Destroy();
							end;
						end;
					end;
				end;
			end;
			for model, label in pairs(warnNPCLabels) do
				if model:IsDescendantOf(workspace) and localPlayer and localPlayer.Character then
					local distance = 0;
					local name = entityNames[model.Name] or model.Name;
					if localPlayer and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") and model:FindFirstChild("HumanoidRootPart") then
						distance = math.floor((localPlayer.Character.HumanoidRootPart.Position - model.HumanoidRootPart.Position).Magnitude);
					end;
					label.Text = ("⚠️ " or "") .. name .. " - " .. distance .. " meters";
				end;
			end;
		end;
	end;
	if aimbotEnabled then
		local camera = workspace.CurrentCamera;
		local character = localPlayer.Character;
		if character and character:FindFirstChild("HumanoidRootPart") then
			local rootPos = character.HumanoidRootPart.Position;
			local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2);
			local fovRadius = math.tan(math.rad(fovAngleDegrees / 2)) * camera.ViewportSize.X;
			local closestNormal, closestPriority = nil, nil;
			local closestNormalDist, closestPriorityDist = math.huge, math.huge;
			for _, model in pairs(workspaceDescendants) do
				if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") and model:FindFirstChild("Humanoid") then
					if not Players:GetPlayerFromCharacter(model) then
						local targetPartName = aimbotTargetBodyPart or aimbotFallbackPart;
						local targetPart = model:FindFirstChild(targetPartName) or model:FindFirstChild(aimbotFallbackPart);
						local tags = entityTags[model.Name];
						if targetPart and tags and table.find(tags, "aimbot") and model.Humanoid.Health > 0 then
							local dist = (targetPart.Position - rootPos).Magnitude;
							local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position);
							if not onScreen then
								continue;
							end;
							local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude;
							if screenDist > fovRadius then
								continue;
							end;
							if table.find(tags, "kill-first") and dist <= priorityRadius then
								if dist < closestPriorityDist then
									closestPriority = targetPart;
									closestPriorityDist = dist;
								end;
							elseif dist < closestNormalDist then
								closestNormal = targetPart;
								closestNormalDist = dist;
							end;
						end;
					end;
				end;
			end;
			local target = closestPriority or closestNormal;
			if target then
				local camPos = camera.CFrame.Position;
				local targetDir = (target.Position - camPos).Unit;
				local newLook = camPos + targetDir;
				local smoothedLook = camPos:Lerp(newLook, 0.2);
				camera.CFrame = CFrame.new(camPos, smoothedLook);
			end;
			circle.Visible = showAimbotCircle;
			circle.Position = screenCenter;
			circle.Radius = fovRadius;
		end;
	else
		circle.Visible = false;
	end;
	if noclipEnabled then
		local char = game.Players.LocalPlayer.Character;
		if char then
			for _, part in pairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false;
				end;
			end;
		end;
	end;
	if nightVisionOn then
		enableLighting();
	else
		resetLighting();
	end;
end);




local MainTab = Library:Tab("Main Feature", "rbxassetid://10723407389");
local FarmTab = Library:Tab("Farming", "rbxassetid://10723415335");
local ItemsTab = Library:Tab("Items", "rbxassetid://10709782497");
local SettingsTab = Library:Tab("Setting Farm", "rbxassetid://10734950309");
local LocalPlayerTab = Library:Tab("Local Player", "rbxassetid://10747373176");
local HoldTab = Library:Tab("Setting", "rbxassetid://10734984606");

FarmTab:Button("Farming Bonds", function()
		Update:Notify("Turning On Autobonds : " );
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Krishnasavage/KinaHub/refs/heads/main/BondsFarmBasic"))()
	end);
	
	MainTab:Toggle("Esp Mob",  function(value)
		espOn = value;
		if not value then
			clearESP();
			end;
	end);
	MainTab:Toggle("Night Vision",  function(Value)
		nightVisionOn = Value;
		if Value then
			enableLighting();
		else
			resetLighting();
		end;
	end);
	MainTab:Toggle("No Clip",  function(Value)
		noclipEnabled = Value;
	end);
	
	MainTab:Toggle("AimBot",   function(Value)
		aimbotEnabled = Value;
	end);
	
