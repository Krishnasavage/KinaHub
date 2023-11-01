local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/thanhdat4461/OrionMoblie/main/source')))()

local Window = OrionLib:MakeWindow({Name = "KinaHub || ⚽🗡️Blade Ball🗡️⚽", HidePremium = false, IntroText = "KinaHubLib",SaveConfig = false, ConfigFolder = "kina"})

local MainTab = Window:MakeTab({
Name = "Main Tab",
Icon = "rbxassetid://4483345998",
PremiumOnly = false
})



local Section = MainTab:AddSection({
Name = "#1"
})
OrionLib:MakeNotification({
Name = "System",
Content = "Hey This Is A Beta Version",
Image = "rbxassetid://4483345998",
Time = 5
})

MainTab : AddButton({
    Name = "Auto Parry [TESTING]",
    Callback = function()
      ToggleKey = ToggleKey or Enum.KeyCode.Z;

local Cloneref = cloneref or function(Object)return Object end;

local StatsService = Cloneref(game:GetService("Stats"));
local UserInputService = Cloneref(game:GetService("UserInputService"));
local ReplicatedStorage = Cloneref(game:GetService("ReplicatedStorage"));
local Players = Cloneref(game:GetService("Players"));
local Player = Players.LocalPlayer;

local Running = true;
local Saved = {
	LastTick = os.clock();
	LastBallPosition = nil;
	AttemptedParry = false,
};

local function GetBall()
	local RealBall, OtherBall = nil, nil;
	for Int, Object in pairs(workspace.Balls:GetChildren()) do
		if Object:GetAttribute("realBall") == true then
			RealBall = Object;
		else
			OtherBall = Object;
		end;
	end;
	return RealBall, OtherBall;
end;
local function AttemptParry(OtherBall)
	ReplicatedStorage.Remotes.ParryAttempt:FireServer(1.5, OtherBall.CFrame, (function()
		local Results = {};
		for Int, Character in pairs(workspace.Alive:GetChildren()) do
			Results[Character.Name] = Character.HumanoidRootPart.Position;
		end;
		return Results;
	end)(), {math.random(100, 999), math.random(100, 999)});
end;

UserInputService.InputBegan:Connect(function(Input, GameProcessed)
	if GameProcessed == false then
		if Input.KeyCode == ToggleKey then
			Running = not Running;
		end;
	end;
end);

while task.wait() do
	if Running == true then
		local RealBall, OtherBall = GetBall();
		if RealBall ~= nil and OtherBall ~= nil then
			if Saved.LastBallPosition ~= nil then
				if RealBall:GetAttribute("target") == Player.Name then
					local DeltaT = os.clock()-Saved.LastTick;
					local VelocityX = (OtherBall.Position.X-Saved.LastBallPosition.X)/DeltaT;
					local VelocityY = (OtherBall.Position.Y-Saved.LastBallPosition.Y)/DeltaT;
					local VelocityZ = (OtherBall.Position.Z-Saved.LastBallPosition.Z)/DeltaT;
					local VelocityMagnitude = math.sqrt(VelocityX^2+VelocityY^2+VelocityZ^2);

					local ServerPing = StatsService.Network.ServerStatsItem["Data Ping"]:GetValue();
					local DistanceToPlayer = (Player.Character.HumanoidRootPart.Position-OtherBall.Position).Magnitude;
					local EstimatedTimeToReachPlayer = (ServerPing/VelocityMagnitude)/(ServerPing/DistanceToPlayer);
					local TimeToParry = 0.3*(VelocityMagnitude/DistanceToPlayer);

					print(EstimatedTimeToReachPlayer, "<=", TimeToParry);

					if tostring(EstimatedTimeToReachPlayer) ~= "inf" and TimeToParry < 10 then
						if EstimatedTimeToReachPlayer <= TimeToParry then
							if Saved.AttemptedParry == false then
								warn("--firing");
								AttemptParry(OtherBall);
								Saved.AttemptedParry = true;
							else
								warn("--attempted");
							end;
						else
							Saved.AttemptedParry = false;
						end;
					end;
				else
					Saved.AttemptedParry = false;
				end;
			end;
			Saved.LastBallPosition = OtherBall.Position;
		end;
	end;
	Saved.LastTick = os.clock();
end;
    end
  })

MainTab : AddButton({
    Name = "Auto Parry #2",
    Callback = function()
			shared.config = {
   adjustment = 3.7, -- // Keep this between 3 to 4 \\ --
   hit_range = 0.5, -- // You can mess around with this \\ --

   mode = 'Hold', -- // Hold , Toggle , Always \\ --
   deflect_type = 'Remote', -- // Key Press , Remote \\ --
   notifications = true,
   keybind = Enum.KeyCode.Z	
}

loadstring(game:HttpGet(('https://raw.githubusercontent.com/cunning-sys/meowmeowscripts/main/bladeball.lua'),true))()
		end
	})

MainTab : AddButton({
    Name = "RAGE MODE AUTO PARRY (RISK)",
    Callback = function()
      getgenv().god = true
while getgenv().god and task.wait() do
    for _,ball in next, workspace.Balls:GetChildren() do
        if ball then
            if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position, ball.Position)
                if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Highlight") then
                    game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = ball.CFrame * CFrame.new(0, 0, (ball.Velocity).Magnitude * -0.5)
                    game:GetService("ReplicatedStorage").Remotes.ParryButtonPress:Fire()
                end
            end
        end
    end
      end
    end
  })
OrionLib:Init()
