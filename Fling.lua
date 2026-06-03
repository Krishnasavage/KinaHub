-- ⚠️ IMPORTANT: Put this code at the VERY TOP of your Main Script (before obfuscating) ⚠️

local ProtectionConfig = {
    -- 🔴 CRITICAL: This MUST exactly match the 'Secret' value in your Key System's Config!
    -- If your Key System has: Secret = "Test"
    -- Then this must also be: SecretKey = "Test"
    SecretKey = "mrPENIS",
    
    -- The name of your Hub (shown in the kick message if they try to bypass)
    HubName = "Aurora HUB"
}

-- Anti-Bypass Logic: Checks if the Key System successfully set the global variable
if not _G[ProtectionConfig.SecretKey] then
    local player = game:GetService("Players").LocalPlayer
    if player then
        player:Kick("\n🛡️ Unauthorized Execution 🛡️\n\nPlease use the official Key System to run " .. ProtectionConfig.HubName)
    end
    return -- Stops the rest of the script from loading!
end

-------------------------------------------------------------------------------
-- 👇 YOUR MAIN SCRIPT CODE STARTS HERE 👇
-------------------------------------------------------------------------------

print(ProtectionConfig.HubName .. " Loaded Successfully!")


-- AuroraHub (Original Fling + Aurora Borealis UI)
-- Version: 3.0

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner_Main = Instance.new("UICorner")
local TitleLabel = Instance.new("TextLabel")
local UIGradient_Title = Instance.new("UIGradient")
local ActionButton = Instance.new("TextButton")
local UICorner_Button = Instance.new("UICorner")
local UIGradient_ButtonText = Instance.new("UIGradient")

-- Setup GUI
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Frame Utama (Tema Hitam)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14) -- Hitam pekat
MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.4, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 160, 0, 110)

UICorner_Main.CornerRadius = UDim.new(0, 6)
UICorner_Main.Parent = MainFrame

-- Teks Judul dengan Efek Aurora
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1.000
TitleLabel.Position = UDim2.new(0, 0, 0, 5)
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.Text = "AuroraHub"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18.000

-- Gradasi Warna Aurora (Hijau -> Cyan -> Ungu)
UIGradient_Title.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 255, 128)),
	ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 200, 255)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(170, 0, 255))
}
UIGradient_Title.Parent = TitleLabel

-- Tombol Fling
ActionButton.Name = "ActionButton"
ActionButton.Parent = MainFrame
ActionButton.BackgroundColor3 = Color3.fromRGB(22, 22, 26) -- Abu-abu sangat gelap
ActionButton.Position = UDim2.new(0.1, 0, 0.45, 0)
ActionButton.Size = UDim2.new(0, 128, 0, 40)
ActionButton.BorderSizePixel = 0
ActionButton.Font = Enum.Font.GothamBold
ActionButton.Text = "FLING: OFF"
ActionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ActionButton.TextSize = 14.000

UICorner_Button.CornerRadius = UDim.new(0, 6)
UICorner_Button.Parent = ActionButton

-- Gradasi Teks pada Tombol (Bawaan Merah/Mati)
UIGradient_ButtonText.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 150, 150)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 100))
}
UIGradient_ButtonText.Parent = ActionButton

--- SCRIPT DRAGGING ---
local function DragScript()
	local script = Instance.new('LocalScript', MainFrame)
	local UserInputService = game:GetService("UserInputService")
	local gui = script.Parent
	local dragging, dragInput, dragStart, startPos

	local function update(input)
		local delta = input.Position - dragStart
		gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	gui.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	gui.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end
coroutine.wrap(DragScript)()

--- SCRIPT FLING (Original Logic Diperhalus) ---
local function FlingScript()
	local script = Instance.new('LocalScript', ActionButton)
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	 
	local toggleButton = script.Parent
	local grad = toggleButton:FindFirstChildOfClass("UIGradient")
	local hiddenfling = false
	local flingThread
	
	local function fling()
		local lp = Players.LocalPlayer
		local c, hrp, vel
		local movel = 0.1
	 
		while hiddenfling do
			RunService.Heartbeat:Wait()
			c = lp.Character
			hrp = c and c:FindFirstChild("HumanoidRootPart")
	 
			if hrp then
				-- Logika persis seperti script aslimu namun lebih stabil
				vel = hrp.Velocity
				hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
				RunService.RenderStepped:Wait()
				
				hrp.Velocity = vel
				RunService.Stepped:Wait()
				
				hrp.Velocity = vel + Vector3.new(0, movel, 0)
				movel = -movel
			end
		end
	end
	 
	toggleButton.MouseButton1Click:Connect(function()
		hiddenfling = not hiddenfling
		
		if hiddenfling then
			toggleButton.Text = "FLING: ON"
			-- Warna teks tombol berubah jadi Aurora Borealis saat aktif
			grad.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 255, 128)),
				ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 200, 255)),
				ColorSequenceKeypoint.new(1.00, Color3.fromRGB(170, 0, 255))
			}
			flingThread = coroutine.create(fling)
			coroutine.resume(flingThread)
		else
			toggleButton.Text = "FLING: OFF"
			-- Warna teks tombol kembali abu-abu saat mati
			grad.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 150, 150)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 100))
			}
			hiddenfling = false
		end
	end)
end
coroutine.wrap(FlingScript)()
