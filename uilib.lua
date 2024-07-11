local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local UILib = {}
UILib.__index = UILib

-- Improved Tween function with easing styles
local function Tween(instance, properties, duration, style, direction)
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    return TweenService:Create(instance, TweenInfo.new(duration, style, direction), properties):Play()
end

-- Smooth drag function
local function SmoothDrag(frame, dragSpeed)
    dragSpeed = dragSpeed or 0.1
    local dragToggle, dragInput, dragStart, startPos
    
    local function UpdateDrag(input)
        local delta = input.Position - dragStart
        local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        Tween(frame, {Position = position}, dragSpeed)
    end
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            UpdateDrag(input)
        end
    end)
end

-- Create rounded corners
local function CreateRoundedCorners(instance, radius)
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, radius)
    uiCorner.Parent = instance
    return uiCorner
end

-- Create drop shadow
local function CreateDropShadow(instance, size, transparency)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "DropShadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, size, 1, size)
    shadow.ZIndex = instance.ZIndex - 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = transparency
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.Parent = instance
    return shadow
end

function UILib.new(title)
    local self = setmetatable({}, UILib)
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "AdvancedExploitUI"
    self.ScreenGui.Parent = CoreGui
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    self.Main = Instance.new("Frame")
    self.Main.Name = "Main"
    self.Main.Size = UDim2.new(0, 450, 0, 350)
    self.Main.Position = UDim2.new(0.5, -225, 0.5, -175)
    self.Main.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    self.Main.BorderSizePixel = 0
    self.Main.Parent = self.ScreenGui
    CreateRoundedCorners(self.Main, 10)
    CreateDropShadow(self.Main, 20, 0.5)
    
    self.TopBar = Instance.new("Frame")
    self.TopBar.Name = "TopBar"
    self.TopBar.Size = UDim2.new(1, 0, 0, 40)
    self.TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    self.TopBar.BorderSizePixel = 0
    self.TopBar.Parent = self.Main
    CreateRoundedCorners(self.TopBar, 10)
    
    self.Title = Instance.new("TextLabel")
    self.Title.Name = "Title"
    self.Title.Size = UDim2.new(1, -40, 1, 0)
    self.Title.Position = UDim2.new(0, 10, 0, 0)
    self.Title.BackgroundTransparency = 1
    self.Title.Text = title
    self.Title.TextColor3 = Color3.new(1, 1, 1)
    self.Title.TextSize = 18
    self.Title.Font = Enum.Font.GothamBold
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.Parent = self.TopBar
    
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Size = UDim2.new(0, 30, 0, 30)
    self.CloseButton.Position = UDim2.new(1, -35, 0, 5)
    self.CloseButton.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
    self.CloseButton.Text = ""
    self.CloseButton.Parent = self.TopBar
    CreateRoundedCorners(self.CloseButton, 15)
    
    self.CloseButton.MouseEnter:Connect(function()
        Tween(self.CloseButton, {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}, 0.2)
    end)
    
    self.CloseButton.MouseLeave:Connect(function()
        Tween(self.CloseButton, {BackgroundColor3 = Color3.fromRGB(255, 75, 75)}, 0.2)
    end)
    
    self.CloseButton.MouseButton1Click:Connect(function()
        Tween(self.Main, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        wait(0.5)
        self.ScreenGui:Destroy()
    end)
    
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Size = UDim2.new(1, 0, 1, -40)
    self.TabContainer.Position = UDim2.new(0, 0, 0, 40)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.Parent = self.Main
    
    self.TabButtons = Instance.new("Frame")
    self.TabButtons.Name = "TabButtons"
    self.TabButtons.Size = UDim2.new(0, 120, 1, 0)
    self.TabButtons.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    self.TabButtons.BorderSizePixel = 0
    self.TabButtons.Parent = self.TabContainer
    CreateRoundedCorners(self.TabButtons, 10)
    
    self.TabContent = Instance.new("Frame")
    self.TabContent.Name = "TabContent"
    self.TabContent.Size = UDim2.new(1, -130, 1, -10)
    self.TabContent.Position = UDim2.new(0, 125, 0, 5)
    self.TabContent.BackgroundTransparency = 1
    self.TabContent.Parent = self.TabContainer
    
    self.Tabs = {}
    self.ActiveTab = nil
    
    SmoothDrag(self.Main)
    
    return self
end

function UILib:AddTab(name)
    local tab = {}
    
    tab.Button = Instance.new("TextButton")
    tab.Button.Name = name
    tab.Button.Size = UDim2.new(1, -10, 0, 35)
    tab.Button.Position = UDim2.new(0, 5, 0, #self.Tabs * 40 + 5)
    tab.Button.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    tab.Button.BorderSizePixel = 0
    tab.Button.Text = name
    tab.Button.TextColor3 = Color3.new(1, 1, 1)
    tab.Button.TextSize = 14
    tab.Button.Font = Enum.Font.GothamSemibold
    tab.Button.Parent = self.TabButtons
    CreateRoundedCorners(tab.Button, 8)
    
    tab.Content = Instance.new("ScrollingFrame")
    tab.Content.Name = name
    tab.Content.Size = UDim2.new(1, 0, 1, 0)
    tab.Content.BackgroundTransparency = 1
    tab.Content.BorderSizePixel = 0
    tab.Content.ScrollBarThickness = 4
    tab.Content.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 65)
    tab.Content.Visible = false
    tab.Content.Parent = self.TabContent
    
    tab.Button.MouseEnter:Connect(function()
        if self.ActiveTab ~= tab then
            Tween(tab.Button, {BackgroundColor3 = Color3.fromRGB(55, 55, 60)}, 0.2)
        end
    end)
    
    tab.Button.MouseLeave:Connect(function()
        if self.ActiveTab ~= tab then
            Tween(tab.Button, {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}, 0.2)
        end
    end)
    
    tab.Button.MouseButton1Click:Connect(function()
        self:SelectTab(name)
    end)
    
    table.insert(self.Tabs, tab)
    
    if #self.Tabs == 1 then
        self:SelectTab(name)
    end
    
    return tab
end

function UILib:SelectTab(name)
    for _, tab in ipairs(self.Tabs) do
        if tab.Button.Name == name then
            Tween(tab.Button, {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}, 0.2)
            tab.Content.Visible = true
            self.ActiveTab = tab
        else
            Tween(tab.Button, {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}, 0.2)
            tab.Content.Visible = false
        end
    end
end

function UILib:AddButton(tab, text, callback)
    local button = Instance.new("TextButton")
    button.Name = text
    button.Size = UDim2.new(1, -10, 0, 30)
    button.Position = UDim2.new(0, 5, 0, #tab.Content:GetChildren() * 35)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 14
    button.Font = Enum.Font.GothamSemibold
    button.Parent = tab.Content
    CreateRoundedCorners(button, 8)
    
    button.MouseEnter:Connect(function()
        Tween(button, {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}, 0.2)
    end)
    
    button.MouseLeave:Connect(function()
        Tween(button, {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}, 0.2)
    end)
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

function UILib:AddToggle(tab, text, default, callback)
    local toggle = Instance.new("Frame")
    toggle.Name = text
    toggle.Size = UDim2.new(1, -10, 0, 30)
    toggle.Position = UDim2.new(0, 5, 0, #tab.Content:GetChildren() * 35)
    toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    toggle.BorderSizePixel = 0
    toggle.Parent = tab.Content
    CreateRoundedCorners(toggle, 8)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 14
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggle
    
    local switch = Instance.new("Frame")
    switch.Size = UDim2.new(0, 40, 0, 20)
    switch.Position = UDim2.new(1, -45, 0.5, -10)
    switch.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    switch.BorderSizePixel = 0
    switch.Parent = toggle
    CreateRoundedCorners(switch, 10)
    
    local switchButton = Instance.new("Frame")
    switchButton.Size = UDim2.new(0, 20, 0, 20)
    switchButton.Position = default and UDim2.new(1, -20, 0, 0) or UDim2.new(0, 0, 0, 0)
    switchButton.BackgroundColor3 = Color3.new(1, 1, 1)
    switchButton.BorderSizePixel = 0
    switchButton.Parent = switch
    CreateRoundedCorners(switchButton, 10)
    
    local value = default
    
    toggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            value = not value
            Tween(switchButton, {Position = value and UDim2.new(1, -20, 0, 0) or UDim2.new(0, 0, 0, 0)}, 0.1)
            Tween(switch, {BackgroundColor3 = value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)}, 0.1)
            callback(value)
        end
    end)
    
    return toggle
end

function UILib:AddSlider(tab, text, min, max, default, callback)
    local slider = Instance.new("Frame")
    slider.Name = text
    slider.Size = UDim2.new(1, -10, 0, 50)
    slider.Position = UDim2.new(0, 5, 0, #tab.Content:GetChildren() * 55)
    slider.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    slider.BorderSizePixel = 0
    slider.Parent = tab.Content
    CreateRoundedCorners(slider, 8)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 14
    label.Font = Enum.Font.GothamSemibold
    label.Parent = slider
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -20, 0, 5)
    sliderBar.Position = UDim2.new(0, 10, 0.5, 10)
    sliderBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = slider
    CreateRoundedCorners(sliderBar, 5)
    
    local sliderButton = Instance.new("Frame")
    sliderButton.Size = UDim2.new(0, 10, 0, 20)
    sliderButton.Position = UDim2.new((default - min) / (max - min), -5, 0.5, -10)
    sliderButton.BackgroundColor3 = Color3.new(1, 1, 1)
    sliderButton.BorderSizePixel = 0
    sliderButton.Parent = sliderBar
    CreateRoundedCorners(sliderButton, 10)
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -50, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.new(1, 1, 1)
    valueLabel.TextSize = 14
    valueLabel.Font = Enum.Font.GothamSemibold
    valueLabel.Parent = slider
    
    local value = default
    local dragging = false
    
    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    sliderButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local relativePos = mousePos - sliderBar.AbsolutePosition
            local percentage = math.clamp(relativePos.X / sliderBar.AbsoluteSize.X, 0, 1)
            value = min + (max - min) * percentage
            sliderButton.Position = UDim2.new(percentage, -5, 0.5, -10)
            valueLabel.Text = string.format("%.2f", value)
            callback(value)
        end
    end)
    
    return slider
end

function UILib:ShowKeySystem(correctKey, callback)
    local keySystem = Instance.new("Frame")
    keySystem.Name = "KeySystem"
    keySystem.Size = UDim2.new(0, 300, 0, 150)
    keySystem.Position = UDim2.new(0.5, -150, 0.5, -75)
    keySystem.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    keySystem.BorderSizePixel = 0
    keySystem.Parent = self.ScreenGui
    CreateRoundedCorners(keySystem, 10)
    CreateDropShadow(keySystem, 20, 0.5)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "Enter Key"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Parent = keySystem
    
    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(1, -20, 0, 30)
    keyInput.Position = UDim2.new(0, 10, 0, 60)
    keyInput.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    keyInput.BorderSizePixel = 0
    keyInput.Text = ""
    keyInput.PlaceholderText = "Enter key here..."
    keyInput.TextColor3 = Color3.new(1, 1, 1)
    keyInput.TextSize = 14
    keyInput.Font = Enum.Font.GothamSemibold
    keyInput.Parent = keySystem
    CreateRoundedCorners(keyInput, 8)
    
    local submitButton = Instance.new("TextButton")
    submitButton.Size = UDim2.new(1, -20, 0, 30)
    submitButton.Position = UDim2.new(0, 10, 1, -40)
    submitButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    submitButton.BorderSizePixel = 0
    submitButton.Text = "Submit"
    submitButton.TextColor3 = Color3.new(1, 1, 1)
    submitButton.TextSize = 14
    submitButton.Font = Enum.Font.GothamBold
    submitButton.Parent = keySystem
    CreateRoundedCorners(submitButton, 8)
    
    local function checkKey()
        if keyInput.Text == correctKey then
            keySystem:Destroy()
            callback(true)
        else
            keyInput.Text = ""
            keyInput.PlaceholderText = "Incorrect key, try again..."
            Tween(keyInput, {BackgroundColor3 = Color3.fromRGB(255, 0, 0)}, 0.2)
            wait(0.2)
            Tween(keyInput, {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}, 0.2)
        end
    end
    
    submitButton.MouseButton1Click:Connect(checkKey)
    keyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            checkKey()
        end
    end)
end

function UILib:AddDropdown(tab, text, options, callback)
    local dropdown = Instance.new("Frame")
    dropdown.Name = text
    dropdown.Size = UDim2.new(1, -10, 0, 30)
    dropdown.Position = UDim2.new(0, 5, 0, #tab.Content:GetChildren() * 35)
    dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    dropdown.BorderSizePixel = 0
    dropdown.Parent = tab.Content
    CreateRoundedCorners(dropdown, 8)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 14
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = dropdown
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 40, 1, 0)
    button.Position = UDim2.new(1, -40, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    button.BorderSizePixel = 0
    button.Text = "▼"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Parent = dropdown
    CreateRoundedCorners(button, 8)
    
    local optionsList = Instance.new("Frame")
    optionsList.Size = UDim2.new(1, 0, 0, #options * 30)
    optionsList.Position = UDim2.new(0, 0, 1, 0)
    optionsList.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    optionsList.BorderSizePixel = 0
    optionsList.Visible = false
    optionsList.ZIndex = 10
    optionsList.Parent = dropdown
    CreateRoundedCorners(optionsList, 8)
    
    local function toggleDropdown()
        optionsList.Visible = not optionsList.Visible
        button.Text = optionsList.Visible and "▲" or "▼"
    end
    
    button.MouseButton1Click:Connect(toggleDropdown)
    
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, 0, 0, 30)
        optionButton.Position = UDim2.new(0, 0, 0, (i-1) * 30)
        optionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        optionButton.BorderSizePixel = 0
        optionButton.Text = option
        optionButton.TextColor3 = Color3.new(1, 1, 1)
        optionButton.TextSize = 14
        optionButton.Font = Enum.Font.GothamSemibold
        optionButton.ZIndex = 11
        optionButton.Parent = optionsList
        CreateRoundedCorners(optionButton, 8)
        
        optionButton.MouseEnter:Connect(function()
            Tween(optionButton, {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}, 0.2)
        end)
        
        optionButton.MouseLeave:Connect(function()
            Tween(optionButton, {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}, 0.2)
        end)
        
        optionButton.MouseButton1Click:Connect(function()
            label.Text = text .. ": " .. option
            toggleDropdown()
            callback(option)
        end)
    end
    
    return dropdown
end

function UILib:AddColorPicker(tab, text, default, callback)
    local colorPicker = Instance.new("Frame")
    colorPicker.Name = text
    colorPicker.Size = UDim2.new(1, -10, 0, 30)
    colorPicker.Position = UDim2.new(0, 5, 0, #tab.Content:GetChildren() * 35)
    colorPicker.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    colorPicker.BorderSizePixel = 0
    colorPicker.Parent = tab.Content
    CreateRoundedCorners(colorPicker, 8)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 14
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = colorPicker
    
    local preview = Instance.new("Frame")
    preview.Size = UDim2.new(0, 30, 0, 30)
    preview.Position = UDim2.new(1, -35, 0, 0)
    preview.BackgroundColor3 = default
    preview.BorderSizePixel = 0
    preview.Parent = colorPicker
    CreateRoundedCorners(preview, 8)
    
    local pickerGui = Instance.new("Frame")
    pickerGui.Size = UDim2.new(0, 200, 0, 220)
    pickerGui.Position = UDim2.new(1, 10, 0, 0)
    pickerGui.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    pickerGui.BorderSizePixel = 0
    pickerGui.Visible = false
    pickerGui.ZIndex = 10
    pickerGui.Parent = colorPicker
    CreateRoundedCorners(pickerGui, 10)
    CreateDropShadow(pickerGui, 20, 0.5)
    

    local colorSpace = Instance.new("ImageLabel")
    colorSpace.Size = UDim2.new(1, -20, 0, 160)
    colorSpace.Position = UDim2.new(0, 10, 0, 10)
    colorSpace.Image = "rbxassetid://4155801252"
    colorSpace.BackgroundColor3 = Color3.new(1, 0, 0)
    colorSpace.BorderSizePixel = 0
    colorSpace.ZIndex = 11
    colorSpace.Parent = pickerGui

    local colorCursor = Instance.new("Frame")
    colorCursor.Size = UDim2.new(0, 4, 0, 4)
    colorCursor.AnchorPoint = Vector2.new(0.5, 0.5)
    colorCursor.BorderSizePixel = 0
    colorCursor.BackgroundColor3 = Color3.new(1, 1, 1)
    colorCursor.ZIndex = 12
    colorCursor.Parent = colorSpace

    local hueSlider = Instance.new("TextButton")
    hueSlider.Size = UDim2.new(1, -20, 0, 20)
    hueSlider.Position = UDim2.new(0, 10, 0, 180)
    hueSlider.BorderSizePixel = 0
    hueSlider.Text = ""
    hueSlider.ZIndex = 11
    hueSlider.Parent = pickerGui

    local hueGradient = Instance.new("UIGradient")
    hueGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.new(1, 0, 0)),
        ColorSequenceKeypoint.new(0.167, Color3.new(1, 1, 0)),
        ColorSequenceKeypoint.new(0.333, Color3.new(0, 1, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.new(0, 1, 1)),
        ColorSequenceKeypoint.new(0.667, Color3.new(0, 0, 1)),
        ColorSequenceKeypoint.new(0.833, Color3.new(1, 0, 1)),
        ColorSequenceKeypoint.new(1, Color3.new(1, 0, 0))
    }
    hueGradient.Parent = hueSlider

    local hueCursor = Instance.new("Frame")
    hueCursor.Size = UDim2.new(0, 4, 1, 0)
    hueCursor.BorderSizePixel = 0
    hueCursor.BackgroundColor3 = Color3.new(1, 1, 1)
    hueCursor.ZIndex = 12
    hueCursor.Parent = hueSlider

    local function updateColor()
        local hue = 1 - (hueCursor.Position.X.Scale)
        local saturation = colorCursor.Position.X.Scale
        local value = 1 - colorCursor.Position.Y.Scale
        local color = Color3.fromHSV(hue, saturation, value)
        preview.BackgroundColor3 = color
        colorSpace.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
        callback(color)
    end

    local function updateHue()
        local hue = 1 - (hueCursor.Position.X.Scale)
        colorSpace.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
        updateColor()
    end

    hueSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local connection
            connection = RunService.RenderStepped:Connect(function()
                if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                    local mousePos = UserInputService:GetMouseLocation()
                    local relativePos = mousePos - hueSlider.AbsolutePosition
                    local newXScale = math.clamp(relativePos.X / hueSlider.AbsoluteSize.X, 0, 1)
                    hueCursor.Position = UDim2.new(newXScale, -2, 0, 0)
                    updateHue()
                else
                    connection:Disconnect()
                end
            end)
        end
    end)

    colorSpace.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local connection
            connection = RunService.RenderStepped:Connect(function()
                if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                    local mousePos = UserInputService:GetMouseLocation()
                    local relativePos = mousePos - colorSpace.AbsolutePosition
                    local newXScale = math.clamp(relativePos.X / colorSpace.AbsoluteSize.X, 0, 1)
                    local newYScale = math.clamp(relativePos.Y / colorSpace.AbsoluteSize.Y, 0, 1)
                    colorCursor.Position = UDim2.new(newXScale, 0, newYScale, 0)
                    updateColor()
                else
                    connection:Disconnect()
                end
            end)
        end
    end)

    preview.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            pickerGui.Visible = not pickerGui.Visible
        end
    end)

    updateColor()
    return colorPicker
end

return UILib
