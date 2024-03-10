local KeySystemUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/MaGiXxScripter0/keysystemv2api/master/ui/xrer_mstudio45.lua"))()
KeySystemUI.New({
    ApplicationName = "XuaZHub", -- Your Key System Application Name
    Name = "XuaZ Hub", -- Your Script name
    Info = "Get Key || XuaZ Hub", -- Info text in the GUI, keep empty for default text.
    DiscordInvite = "https://discord.com/invite/HU4MjFSkbN", -- Optional.
    AuthType = "clientid" -- Can select verifycation with ClientId or IP ("clientid" or "ip")
})
repeat task.wait() until KeySystemUI.Finished() or KeySystemUI.Closed
if KeySystemUI.Finished() and KeySystemUI.Closed == false then
    print("Key Redeem, can load script")
    game.StarterGui:SetCore("SendNotification", {
Title = "XuaZ Hub";
Text = "XuaZ Hub Activating";
Icon = "http://www.roblox.com/asset/?id=16665265313";
Duration = "7";
})
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Krishnasavage/KinaHub/main/Asek.lua'))()
    
else
    print("Player closed the GUI.")
end
