-- Create the ScreenGui for the toggle UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoChestUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create the main frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 100)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true -- Start with the main frame visible
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

-- Server hopping variables and functions
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local PlaceID = game.PlaceId
local AllIDs = {}
local wait_Time = 300  -- Server hop time interval in seconds

-- Load visited servers from the file or initialize it
local function LoadIDs()
    if pcall(function() readfile("NotSameServers.json") end) then
        AllIDs = HttpService:JSONDecode(readfile("NotSameServers.json"))
    else
        AllIDs = {}
    end
end

LoadIDs()

-- Function to handle server hopping without repeating servers and checking for full servers
local function ServerHop()
    local success, errorMessage = pcall(function()
        local serversList = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100"))
        for _, server in ipairs(serversList.data) do
            if server.playing < server.maxPlayers then  -- Only consider non-full servers
                local ID = tostring(server.id)
                if not table.find(AllIDs, ID) then
                    table.insert(AllIDs, ID)
                    writefile("NotSameServers.json", HttpService:JSONEncode(AllIDs))
                    TeleportService:TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)

                    -- Check after teleporting if the server is still full
                    task.wait(3) -- Wait a few seconds for the teleport to complete
                    if game.Players.NumPlayers < server.maxPlayers then
                        return  -- Successfully joined a non-full server
                    else
                        print("Server was full after joining. Retrying...")
                    end
                end
            end
        end
    end)

    if not success then
        warn("Server hop failed: " .. errorMessage)
        wait(5)  -- Wait before retrying
    end

    -- Retry if no suitable server was found
    ServerHop()
end

-- TPReturner function to call the ServerHop logic
function TPReturner()
    if #AllIDs >= 200 then  -- Clear file if it becomes too large
        AllIDs = {}
        writefile("NotSameServers.json", HttpService:JSONEncode(AllIDs))
    end
    ServerHop()
end

-- Auto Chest toggle and functionality
local autoChestEnabled = false
local autoChestConnection
local resetCoroutine

toggleButton.MouseButton1Click:Connect(function()
    autoChestEnabled = not autoChestEnabled
    getgenv().AutoChest = autoChestEnabled

    if autoChestEnabled then
        toggleButton.Text = "ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        countdownLabel.Text = "Next hop in: 05:00" 
        print("Auto Chest enabled")

        -- Start Auto Chest script
        autoChestConnection = spawn(function()
            getgenv().FistOfDarkness = false
            getgenv().GodChalice = false

            local function checkForItems()
                for _, item in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if item.Name == "Fist of Darkness" then
                        getgenv().FistOfDarkness = true
                        print("Fist of Darkness found! Stopping chest farm.")
                        getgenv().AutoChest = false
                        break
                    elseif item.Name == "God's Chalice" then
                        getgenv().GodChalice = true
                        print("God Chalice found! Stopping chest farm.")
                        getgenv().AutoChest = false
                        break
                    end
                end
            end

            local function serverHop()
                print("No chests left. Server hopping.")
                TPReturner()
            end

            spawn(function()
                while task.wait(0.1) do
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
                                    playerCharacter.HumanoidRootPart.CFrame = v.CFrame + Vector3.new(0, 2, 0)
                                    print("Teleporting to chest at:", v.Position)
                                    fireclickdetector(v:FindFirstChildOfClass("ClickDetector"))
                                    wait(0.1)
                                end
                            end
                        end
                    end)

                    if not chestsFound then
                        serverHop()
                    end
                end
            end)

            -- Countdown timer for server hopping
            local countdown = wait_Time
            while autoChestEnabled do
                wait(1)
                countdown = countdown - 1
                local minutes = math.floor(countdown / 60)
                local seconds = countdown % 60
                countdownLabel.Text = string.format("Next hop in: %02d:%02d", minutes, seconds)

                if countdown <= 0 then
                    TPReturner()
                    countdown = wait_Time
                end
            end
        end)

        -- Character reset coroutine
        resetCoroutine = coroutine.create(function()
            local resetCountdown = 8
            while true do
                wait(1)
                if not autoChestEnabled or getgenv().FistOfDarkness or getgenv().GodChalice then
                    resetCountdown = 8
                else
                    resetCountdown = resetCountdown - 1
                end
                
                if resetCountdown <= 0 then
                    print("Resetting character...")
                    local player = game.Players.LocalPlayer
                    pcall(function()
                        player.Character:BreakJoints()
                    end)
                    resetCountdown = 8
                end
            end
        end)
        coroutine.resume(resetCoroutine)

    else
        toggleButton.Text = "OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        print("Auto Chest disabled")

        if autoChestConnection then
            getgenv().AutoChest = false
            autoChestConnection = nil
        end

        if resetCoroutine then
            autoChestEnabled = false
            resetCoroutine = nil
        end

        countdownLabel.Text = "Next hop in: 00:00"
    end
end)

-- Rainbow color effect for the toggle button
coroutine.wrap(function()
    while true do
        for hue = 0, 1, 0.01 do
            toggleButton.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
            wait(0.1)
        end
    end
end)()

-- Initial button state
toggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

-- Toggle Icon (ImageButton) with URL image
local toggleIcon = Instance.new("ImageButton")
toggleIcon.Size = UDim2.new(0, 50, 0, 50)
toggleIcon.Position = UDim2.new(0, 10, 0, 10)
toggleIcon.BackgroundTransparency = 1
toggleIcon.Image = "rbxassetid://112438403962149"  -- Replace with your desired asset ID
toggleIcon.Parent = screenGui

-- Toggle the visibility of the main frame when the icon is clicked
toggleIcon.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

