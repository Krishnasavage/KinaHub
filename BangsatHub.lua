
local DiscordLib =
    loadstring(game:HttpGet "https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/discord")()

local win = DiscordLib:Window("XuaZ Hub")

local serv = win:Server("XuaZ Hub", "")

local btns = serv:Channel("Main")

btns:Button(
    "Auto Parry",
    function()

loadstring(game:HttpGet("https://raw.githubusercontent.com/Hosvile/Refinement/main/MC%3ABlade%20Ball%20Parry%20V4.0.0",true))()
        DiscordLib:Notification("Notification", "Auto Parry!", "Okay!")
    end
)
btns:Button(
    "Auto Parry V2",
    function()
   -- Open Source Blade Ball Auto Parry By PawsThePaw --
--// My Discord: pawsthepaw
--// Notes: I'm not giving Away my Freeze & Invisibility Detection, lmao, this is sort of decent, time based, Enjoy, Skid, or Learn, Its Your Choice.
getgenv().Paws = {
        ["AutoParry"] = true,
        ["PingBased"] = true,
        ["PingBasedOffset"] = 0,
        ["DistanceToParry"] = 0.5,
        ["BallSpeedCheck"] = true,
}

local Players = game:GetService("Players")
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local ReplicatedPaw = game:GetService("ReplicatedStorage")

local Paws = ReplicatedPaw:WaitForChild("Remotes", 9e9)
local PawsBalls = workspace:WaitForChild("Balls", 9e9)
local PawsTable = getgenv().Paws

local function IsTheTarget()
        return Player.Character:FindFirstChild("Highlight")
end

local function FindBall()
    local RealBall
    for i, v in pairs(PawsBalls:GetChildren()) do
        if v:GetAttribute("realBall") == true then
            RealBall = v
        end
    end
    return RealBall
end

game:GetService("RunService").PreRender:connect(function()
        if not FindBall() then 
                return
        end
        local Ball = FindBall()
        
        local BallPosition = Ball.Position
        
        local BallVelocity = Ball.AssemblyLinearVelocity.Magnitude
        
        local Distance = Player:DistanceFromCharacter(BallPosition)
        
        local Ping = BallVelocity * (game.Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000)
        
        if PawsTable.PingBased then
        Distance -= Ping + PawsTable.PingBasedOffset
        end
        
        if PawsTable.BallSpeedCheck and BallVelocity == 0 then return
        end
        
        if (Distance / BallVelocity) <= PawsTable.DistanceToParry and IsTheTarget() and PawsTable.AutoParry then
               Paws:WaitForChild("ParryButtonPress"):Fire()
           end
end)
        DiscordLib:Notification("Notification", "Auto Parry!", "Okay!")
    end
)
btns:Button(
    "Auto Parry V3",
    function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/Hosvile/Refinement/main/MC%3ABlade%20Ball%20Parry%20V3.0.0"))()
        DiscordLib:Notification("Notification", "Auto Parry!", "Okay!")
    end
)
btns:Button(
    "Auto Parry [RAGE MODE]",
    function()
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
)
btns:Button(
    "Hold Block To Spam",
    function()
   getgenv().SpamSpeed = 1
loadstring(game:HttpGet("https://raw.githubusercontent.com/Hosvile/Refinement/main/MC%3ABlade%20Ball%20Spam",true))()
        DiscordLib:Notification("Notification", "Auto Parry!", "Okay!")
    end
)
btns:Button(
    "Toggle Block To Spam",
    function()
getgenv().SpamSpeed = 5 -- 1-25

if not getgenv().exeSpam then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Hosvile/Refinement/main/Toggle%20Block%20Spam",true))()
end

getgenv().exeSpam = true
        DiscordLib:Notification("Notification", "Auto Parry!", "Okay!")
    end
)
win:Server("Main", "http://www.roblox.com/asset/?id=6031075938")
