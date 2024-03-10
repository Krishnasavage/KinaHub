
local DiscordLib =
    loadstring(game:HttpGet "https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/discord")()

local win = DiscordLib:Window("XuaZ Hub")

local serv = win:Server("XuaZ Hub", "")

local btns = serv:Channel("Main")

btns:Button(
    "Auto Parry",
    function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/Hosvile/Refinement/main/MC%3ABlade%20Ball%20Parry",true))()
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
win:Server("Main", "http://www.roblox.com/asset/?id=6031075938")
