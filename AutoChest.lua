-- Create the ScreenGui for the toggle UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoChestUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create the main frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 100)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)  -- Set a solid background color
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Create title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "XuaZ Hub Auto Chest [BETA]"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.SourceSans
titleLabel.Parent = mainFrame

-- Create the toggle button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, -20, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 40)
toggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)  -- Start with red color
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 16
toggleButton.Font = Enum.Font.SourceSans
toggleButton.Text = "OFF"
toggleButton.Parent = mainFrame

-- Create countdown label
local countdownLabel = Instance.new("TextLabel")
countdownLabel.Size = UDim2.new(1, 0, 0, 30)
countdownLabel.Position = UDim2.new(0, 0, 0, 80)
countdownLabel.BackgroundTransparency = 1
countdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
countdownLabel.TextSize = 16
countdownLabel.Font = Enum.Font.SourceSans
countdownLabel.Parent = mainFrame

-- Make the UI movable
local dragging = false
local dragStart = nil
local startPos = nil

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Toggle function and Auto Chest logic
local autoChestEnabled = false
local autoChestConnection
local resetCoroutine  -- Store the reset coroutine
local serverHopTime = 300  -- Set to 5 minutes in seconds

toggleButton.MouseButton1Click:Connect(function()
    autoChestEnabled = not autoChestEnabled
    getgenv().AutoChest = autoChestEnabled  -- Update the global setting

    if autoChestEnabled then
        toggleButton.Text = "ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)  -- Green for enabled
        countdownLabel.Text = "Next hop in: 05:00"  -- Reset countdown display
        print("Auto Chest enabled")

        -- Start the Auto Chest script
        autoChestConnection = spawn(function()
            -- Settings
            getgenv().FistOfDarkness = false
            getgenv().GodChalice = false

            local function checkForItems()
                for _, item in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if item.Name == "Fist of darkness" then
                        getgenv().FistOfDarkness = true
                        print("Fist of Darkness found! Stopping chest farm.")
                        getgenv().AutoChest = false
                    elseif item.Name == "God's chalice" then
                        getgenv().GodChalice = true
                        print("God Chalice found! Stopping chest farm.")
                        getgenv().AutoChest = false
                    end
                end
            end

            local function serverHop()
                print("No chests left. Server hopping.")
                game:GetService("TeleportService"):Teleport(game.PlaceId)
            end

            local function autoRejoin()
                game.Players.LocalPlayer.PlayerGui.Disconnected.Frame.DisconnectButton.MouseButton1Click:Connect(function()
                    wait(2)
                    print("Rejoining the game...")
                    game:GetService("TeleportService"):Teleport(game.PlaceId)
                end)
            end

            

            spawn(function()
                while task.wait(1) do
                    if not getgenv().AutoChest then break end
                    
                    checkForItems()
                    if not getgenv().AutoChest then break end

                    local chestsFound = false
                    pcall(function()
                        for _, v in pairs(game:GetService("Workspace"):GetChildren()) do
                            if v.Name:find("Chest") and v:IsA("Part") then
                                chestsFound = true
                                local playerCharacter = game.Players.LocalPlayer.Character
                                if playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart") then
                                    -- Teleport to the chest without resetting to original position
                                    playerCharacter.HumanoidRootPart.CFrame = v.CFrame + Vector3.new(0, 3, 0)  -- Adjust position to be above the chest
                                    print("Teleporting to chest at:", v.Position)
                                    fireclickdetector(v:FindFirstChildOfClass("ClickDetector"))
                                    wait(0.5)
                                end
                                wait(1)
                            end
                        end
                    end)

                    if not chestsFound then
                        serverHop()
                    end
                end
            end)

            -- Countdown timer for server hopping
            local countdown = serverHopTime
            while autoChestEnabled do
                wait(1)
                countdown = countdown - 1
                local minutes = math.floor(countdown / 60)
                local seconds = countdown % 60
                countdownLabel.Text = string.format("Next hop in: %02d:%02d", minutes, seconds)

                if countdown <= 0 then
                    serverHop()  -- Trigger server hop
                    countdown = serverHopTime  -- Reset countdown
                end
            end
        end)

        -- Character reset coroutine
        resetCoroutine = coroutine.create(function()
            while autoChestEnabled do
                wait(10)
                if not getgenv().FistOfDarkness and not getgenv().GodChalice then
                    local player = game.Players.LocalPlayer
                    player.Character:BreakJoints()
                    print("Character reset after 10 seconds.")
                end
            end
        end)
        coroutine.resume(resetCoroutine)  -- Start the reset coroutine

    else
        toggleButton.Text = "Enable Auto Chest"
        toggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)  -- Red for disabled
        print("Auto Chest disabled")

        if autoChestConnection then
            getgenv().AutoChest = false
            autoChestConnection = nil
        end

        -- Stop the character reset coroutine if it's running
        if resetCoroutine then
            -- Set autoChestEnabled to false to exit the coroutine
            autoChestEnabled = false
            resetCoroutine = nil  -- Clean up the reset coroutine
        end

        -- Reset the countdown display
        countdownLabel.Text = "Next hop in: 00:00"
    end
end)

-- Rainbow color effect for the toggle button
coroutine.wrap(function()
    while true do
        for hue = 0, 1, 0.01 do
            toggleButton.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)  -- Change color based on HSV
            wait(0.1)  -- Adjust speed of color change
        end
    end
end)()

-- Initial button state
toggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
