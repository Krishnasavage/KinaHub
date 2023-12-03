local starterGui = game:GetService("StarterGui") wait(1) starterGui:SetCore("SendNotification", { Icon = "rbxassetid://15418211761" ,Title = "BETA VERSION", Text = "Join Our Discord Server To Get Full Version", Duration = 10 }) 
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "XDDCC HUB",IntroText = "XDDCC LIBRARY",IntroIcon = "rbxassetid://15418211761", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})


local Tab = Window:MakeTab({
	Name = "Info",
	Icon = "rbxassetid://15418211761",
	PremiumOnly = false
})
local Section = Tab:AddSection({
	Name = "This Script Make By DevZN"
	})
	local Section = Tab:AddSection({
	Name = "Beta Version!"
})


local Section = Tab:AddSection({
	Name = "Use This With low ping"
})



local Tab = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://15418211761",
	PremiumOnly = false
})

Tab:AddButton({
	Name = "Remove Particle",
	Callback = function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Hosvile/Refinement/main/Destroy%20Particle%20Emitters",true))()
      		print("button pressed")
  	end    
})
Tab:AddButton({
	Name = "Auto Spam",
	Callback = function()
	loadstring(game:HttpGet("https://pastebin.com/raw/t2391h1A"))()
  	end    
})

Tab:AddButton({
	Name = "Auto Spam V4",
	Callback = function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/DonGabrielle/AutoDetectV4/main/MainBalls"))()
  	end    
})


Tab:AddButton({
	Name = "Hold Block To Spam",
	Callback = function()
	getgenv().SpamSpeed = 9
loadstring(game:HttpGet("https://raw.githubusercontent.com/Hosvile/Refinement/main/MC%3ABlade%20Ball%20Spam",true))()
  	end    
})
	
	
	

Tab:AddButton({
	Name = "Auto Parry",
	Callback = function()

	loadstring(game:HttpGet("https://raw.githubusercontent.com/Hosvile/Refinement/main/MC%3ABlade%20Ball%20Parry",true))()
		
	end 
	})

Tab:AddButton({
	Name = "Aim Mechanical",
	Callback = function()
			
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Hosvile/Refinement/main/M%3ABlade%20Ball%20Mechanism"))()
		end
})

Tab:AddButton({
	Name = "Auto Detect BETA TEST",
	Callback = function()
		
loadstring(game:HttpGet("https://pastebin.com/raw/pjTTegEe"))()
		end
})
	
	Tab:AddToggle({
	Name = "Auto Clash OUTDATED",
	Default = false,
	Callback = function(Value)
	loadstring(game:HttpGet("https://pastebin.com/raw/t2391h1A"))();
	end 
	})
	OrionLib:Init()
