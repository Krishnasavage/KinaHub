-- Aurora UI Library
-- Simpan sebagai ModuleScript bernama "AuroraUI"

local AuroraUI = {}
AuroraUI.__index = AuroraUI

-- =====================
-- AURORA COLOR PALETTE
-- =====================
local Colors = {
    Background    = Color3.fromRGB(10, 12, 25),
    Surface       = Color3.fromRGB(18, 20, 40),
    Card          = Color3.fromRGB(25, 28, 55),
    Accent1       = Color3.fromRGB(80, 180, 255),   -- Biru aurora
    Accent2       = Color3.fromRGB(120, 80, 255),   -- Ungu aurora
    Accent3       = Color3.fromRGB(0, 220, 180),    -- Hijau toska aurora
    Text          = Color3.fromRGB(220, 225, 255),
    TextMuted     = Color3.fromRGB(120, 130, 170),
    Success       = Color3.fromRGB(60, 220, 140),
    Warning       = Color3.fromRGB(255, 190, 60),
    Error         = Color3.fromRGB(255, 80, 100),
    Info          = Color3.fromRGB(80, 180, 255),
}

local TweenService    = game:GetService("TweenService")
local Players         = game:GetService("Players")
local LocalPlayer     = Players.LocalPlayer
local PlayerGui       = LocalPlayer:WaitForChild("PlayerGui")

-- =====================
-- UTILITY FUNCTIONS
-- =====================
local function Tween(obj, props, duration, style, dir)
    local info = TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quart,
        dir or Enum.EasingDirection.Out
    )
    TweenService:Create(obj, info, props):Play()
end

local function AddCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    corner.Parent = parent
    return corner
end

local function AddStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Colors.Accent1
    stroke.Thickness = thickness or 1
    stroke.Transparency = 0.6
    stroke.Parent = parent
    return stroke
end

local function AddGradient(parent, color0, color1, rotation)
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color0 or Colors.Accent2),
        ColorSequenceKeypoint.new(1, color1 or Colors.Accent1),
    })
    grad.Rotation = rotation or 135
    grad.Parent = parent
    return grad
end

-- =====================
-- INIT SCREENGUI
-- =====================
function AuroraUI.new(title)
    local self = setmetatable({}, AuroraUI)

    -- ScreenGui utama
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "AuroraUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = PlayerGui

    -- Container notifikasi (pojok kanan bawah)
    self.NotifHolder = Instance.new("Frame")
    self.NotifHolder.Name = "NotifHolder"
    self.NotifHolder.Size = UDim2.new(0, 300, 1, 0)
    self.NotifHolder.Position = UDim2.new(1, -310, 0, 0)
    self.NotifHolder.BackgroundTransparency = 1
    self.NotifHolder.Parent = self.ScreenGui

    local notifLayout = Instance.new("UIListLayout")
    notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
    notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    notifLayout.Padding = UDim.new(0, 8)
    notifLayout.Parent = self.NotifHolder

    local notifPadding = Instance.new("UIPadding")
    notifPadding.PaddingBottom = UDim.new(0, 16)
    notifPadding.Parent = self.NotifHolder

    -- Window utama
    self.Window = Instance.new("Frame")
    self.Window.Name = "AuroraWindow"
    self.Window.Size = UDim2.new(0, 520, 0, 400)
    self.Window.Position = UDim2.new(0.5, -260, 0.5, -200)
    self.Window.BackgroundColor3 = Colors.Background
    self.Window.BorderSizePixel = 0
    self.Window.Parent = self.ScreenGui
    AddCorner(self.Window, 14)
    AddStroke(self.Window, Colors.Accent2, 1.5)

    -- Gradient subtle di background window
    local bgGrad = Instance.new("UIGradient")
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 14, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 15, 40)),
    })
    bgGrad.Rotation = 120
    bgGrad.Parent = self.Window

    -- Header
    self.Header = Instance.new("Frame")
    self.Header.Name = "Header"
    self.Header.Size = UDim2.new(1, 0, 0, 48)
    self.Header.BackgroundColor3 = Colors.Surface
    self.Header.BorderSizePixel = 0
    self.Header.Parent = self.Window
    AddCorner(self.Header, 14)
    AddGradient(self.Header, Colors.Accent2, Colors.Accent1, 90)

    -- Biar corner bawah header ga ikut rounded
    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0.5, 0)
    headerFix.Position = UDim2.new(0, 0, 0.5, 0)
    headerFix.BackgroundColor3 = Colors.Surface
    headerFix.BorderSizePixel = 0
    headerFix.ZIndex = self.Header.ZIndex - 1
    headerFix.Parent = self.Header
    AddGradient(headerFix, Colors.Accent2, Colors.Accent1, 90)

    -- Title text
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = "✦ " .. (title or "Aurora") .. " ✦"
    titleLabel.Size = UDim2.new(1, -50, 1, 0)
    titleLabel.Position = UDim2.new(0, 16, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Colors.Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = self.Header

    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "✕"
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -40, 0.5, -15)
    closeBtn.BackgroundTransparency = 1
    closeBtn.TextColor3 = Colors.Text
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.Parent = self.Header
    closeBtn.MouseButton1Click:Connect(function()
        Tween(self.Window, {Size = UDim2.new(0, 520, 0, 0), Position = UDim2.new(0.5, -260, 0.5, 0)}, 0.3)
        task.delay(0.32, function() self.Window.Visible = false end)
    end)

    -- Draggable
    self:_makeDraggable(self.Window, self.Header)

    -- Content area
    self.Content = Instance.new("ScrollingFrame")
    self.Content.Name = "Content"
    self.Content.Size = UDim2.new(1, -16, 1, -60)
    self.Content.Position = UDim2.new(0, 8, 0, 54)
    self.Content.BackgroundTransparency = 1
    self.Content.BorderSizePixel = 0
    self.Content.ScrollBarThickness = 3
    self.Content.ScrollBarImageColor3 = Colors.Accent1
    self.Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.Content.Parent = self.Window

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = self.Content

    local contentPad = Instance.new("UIPadding")
    contentPad.PaddingLeft = UDim.new(0, 6)
    contentPad.PaddingRight = UDim.new(0, 6)
    contentPad.PaddingTop = UDim.new(0, 6)
    contentPad.Parent = self.Content

    -- Animasi open
    self.Window.Size = UDim2.new(0, 520, 0, 0)
    Tween(self.Window, {Size = UDim2.new(0, 520, 0, 400)}, 0.4)

    return self
end

-- =====================
-- DRAGGABLE
-- =====================
function AuroraUI:_makeDraggable(frame, handle)
    local dragging, dragInput, mousePos, framePos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)
end

-- =====================
-- SECTION LABEL
-- =====================
function AuroraUI:Section(text)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 28)
    section.BackgroundTransparency = 1
    section.Parent = self.Content

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = Colors.Accent2
    line.BackgroundTransparency = 0.6
    line.BorderSizePixel = 0
    line.Parent = section

    local label = Instance.new("TextLabel")
    label.Text = " " .. text .. " "
    label.Size = UDim2.new(0, 0, 1, 0)
    label.AutomaticSize = Enum.AutomaticSize.X
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundColor3 = Colors.Background
    label.TextColor3 = Colors.Accent3
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.Parent = section
end

-- =====================
-- BUTTON
-- =====================
function AuroraUI:Button(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Colors.Card
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Colors.Text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = self.Content
    AddCorner(btn, 8)
    AddStroke(btn, Colors.Accent1, 1)

    btn.MouseEnter:Connect(function()
        Tween(btn, {BackgroundColor3 = Color3.fromRGB(35, 40, 75)}, 0.2)
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn, {BackgroundColor3 = Colors.Card}, 0.2)
    end)
    btn.MouseButton1Click:Connect(function()
        Tween(btn, {BackgroundColor3 = Colors.Accent2}, 0.1)
        task.delay(0.1, function()
            Tween(btn, {BackgroundColor3 = Colors.Card}, 0.2)
        end)
        if callback then callback() end
    end)

    return btn
end

-- =====================
-- TOGGLE
-- =====================
function AuroraUI:Toggle(text, default, callback)
    local state = default or false

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 38)
    container.BackgroundColor3 = Colors.Card
    container.BorderSizePixel = 0
    container.Parent = self.Content
    AddCorner(container, 8)
    AddStroke(container, Colors.Accent2, 1)

    local label = Instance.new("TextLabel")
    label.Text = text
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Colors.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    -- Track background
    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 40, 0, 20)
    track.Position = UDim2.new(1, -50, 0.5, -10)
    track.BackgroundColor3 = state and Colors.Accent3 or Color3.fromRGB(50, 50, 70)
    track.BorderSizePixel = 0
    track.Parent = container
    AddCorner(track, 10)

    -- Thumb
    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.new(0, 16, 0, 16)
    thumb.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    thumb.BackgroundColor3 = Colors.Text
    thumb.BorderSizePixel = 0
    thumb.Parent = track
    AddCorner(thumb, 8)

    local clickArea = Instance.new("TextButton")
    clickArea.Size = UDim2.new(1, 0, 1, 0)
    clickArea.BackgroundTransparency = 1
    clickArea.Text = ""
    clickArea.Parent = container
    clickArea.MouseButton1Click:Connect(function()
        state = not state
        Tween(track, {BackgroundColor3 = state and Colors.Accent3 or Color3.fromRGB(50, 50, 70)}, 0.2)
        Tween(thumb, {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2)
        if callback then callback(state) end
    end)

    return container
end

-- =====================
-- LABEL / INFO
-- =====================
function AuroraUI:Label(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 30)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Colors.TextMuted
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.AutomaticSize = Enum.AutomaticSize.Y
    label.Parent = self.Content
    return label
end

-- =====================
-- NOTIFICATION SYSTEM
-- =====================
function AuroraUI:Notify(options)
    --[[
        options = {
            title   = "Judul Notif",
            message = "Isi pesan singkat",
            type    = "success" | "error" | "warning" | "info",  -- default: info
            duration = 4,  -- detik
        }
    ]]

    local notifType = options.type or "info"
    local duration  = options.duration or 4

    local accentColor = ({
        success = Colors.Success,
        error   = Colors.Error,
        warning = Colors.Warning,
        info    = Colors.Info,
    })[notifType] or Colors.Info

    local icon = ({
        success = "✔",
        error   = "✖",
        warning = "⚠",
        info    = "ℹ",
    })[notifType] or "ℹ"

    -- Notif frame
    local notif = Instance.new("Frame")
    notif.Name = "Notification"
    notif.Size = UDim2.new(1, 0, 0, 70)
    notif.BackgroundColor3 = Colors.Surface
    notif.BorderSizePixel = 0
    notif.BackgroundTransparency = 0.05
    notif.LayoutOrder = tick()
    notif.Parent = self.NotifHolder
    AddCorner(notif, 10)
    AddStroke(notif, accentColor, 1.5)

    -- Subtle left accent bar
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 4, 1, -16)
    accentBar.Position = UDim2.new(0, 8, 0.5, 0)
    accentBar.AnchorPoint = Vector2.new(0, 0.5)
    accentBar.BackgroundColor3 = accentColor
    accentBar.BorderSizePixel = 0
    accentBar.Parent = notif
    AddCorner(accentBar, 2)

    -- Icon
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Text = icon
    iconLabel.Size = UDim2.new(0, 28, 0, 28)
    iconLabel.Position = UDim2.new(0, 20, 0.5, -14)
    iconLabel.BackgroundTransparency = 1
    iconLabel.TextColor3 = accentColor
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 16
    iconLabel.Parent = notif

    -- Title
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Text = options.title or "Notification"
    titleLbl.Size = UDim2.new(1, -70, 0, 22)
    titleLbl.Position = UDim2.new(0, 55, 0, 10)
    titleLbl.BackgroundTransparency = 1
    titleLbl.TextColor3 = Colors.Text
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 13
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = notif

    -- Message
    local msgLbl = Instance.new("TextLabel")
    msgLbl.Text = options.message or ""
    msgLbl.Size = UDim2.new(1, -70, 0, 24)
    msgLbl.Position = UDim2.new(0, 55, 0, 30)
    msgLbl.BackgroundTransparency = 1
    msgLbl.TextColor3 = Colors.TextMuted
    msgLbl.Font = Enum.Font.Gotham
    msgLbl.TextSize = 11
    msgLbl.TextXAlignment = Enum.TextXAlignment.Left
    msgLbl.TextWrapped = true
    msgLbl.Parent = notif

    -- Progress bar (countdown)
    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(1, -16, 0, 3)
    progressBg.Position = UDim2.new(0, 8, 1, -6)
    progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    progressBg.BorderSizePixel = 0
    progressBg.Parent = notif
    AddCorner(progressBg, 2)

    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(1, 0, 1, 0)
    progressFill.BackgroundColor3 = accentColor
    progressFill.BorderSizePixel = 0
    progressFill.Parent = progressBg
    AddCorner(progressFill, 2)

    -- Slide in dari kanan
    notif.Position = UDim2.new(1, 20, 1, 0) -- mulai di luar layar
    Tween(notif, {Position = UDim2.new(0, 0, 1, 0)}, 0.35)

    -- Animate progress bar
    Tween(progressFill, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

    -- Auto dismiss
    task.delay(duration, function()
        Tween(notif, {BackgroundTransparency = 1, Position = UDim2.new(1, 20, 1, 0)}, 0.3)
        Tween(titleLbl, {TextTransparency = 1}, 0.3)
        Tween(msgLbl, {TextTransparency = 1}, 0.3)
        Tween(iconLabel, {TextTransparency = 1}, 0.3)
        task.delay(0.35, function()
            notif:Destroy()
        end)
    end)

    return notif
end

return AuroraUI
