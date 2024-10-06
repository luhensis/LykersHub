-- Covert Flux UI Integration for Evading Anticheat

-- Set up the core variables
local AntiCheatEvasion = {RainbowColorValue = 0, HueSelectionPosition = 0}
local StealthColor = Color3.fromRGB(66, 134, 255) -- Initial color for the UI, which blends with common Roblox UI
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local ActivationBind = Enum.KeyCode.RightAlt -- Changing to a less commonly used key for activation

-- Create a hidden Flux UI
local FluxLib = Instance.new("ScreenGui", game.CoreGui)
FluxLib.Name = "HiddenFluxHub"
FluxLib.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
FluxLib.DisplayOrder = 1000 -- Ensure it's visible when needed
FluxLib.ResetOnSpawn = false

-- UI will be invisible until activated
FluxLib.Enabled = false

-- Create the UI elements
local Window = Instance.new("Frame", FluxLib)
Window.Size = UDim2.new(0, 400, 0, 300)
Window.Position = UDim2.new(1, -420, 1, -320) -- Off-screen position
Window.AnchorPoint = Vector2.new(1, 1)
Window.BackgroundTransparency = 1 -- Completely transparent
Window.Parent = FluxLib

-- Prevent default UI from showing on game start
local function initializeUI()
    local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/fluxlib.txt"))(Window)
    UI.Window.Visible = false -- Start with UI hidden
    UI.Window.ToggleKey = ActivationBind -- Set the activation key

    -- UI activation bind
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if input.KeyCode == ActivationBind and not gameProcessedEvent then
            UI.ToggleWindow()
        end
    end)

    -- UI will only appear when toggled
    function UI.ToggleWindow()
        local isVisible = not UI.Window.Visible
        Window.Visible = isVisible
        Window.BackgroundTransparency = isVisible and 0 or 1 -- Show/Hide UI
        if isVisible then
            -- Tween UI into view on activation
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
            TweenService:Create(Window, tweenInfo, {Position = UDim2.new(1, -420, 1, -320)}):Play()
            UI.Window:SetActive(isVisible) -- Activate or deactivate UI
        else
            -- Tween UI out of view on deactivation
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
            TweenService:Create(Window, tweenInfo, {Position = UDim2.new(1.1, -420, 1, -320}):Play()
        end
    end

    -- Attach UI to the mouse for draggability without leaving traces
    Window.Draggable = true
    Window.Active = true
    Window.DragOffset = Vector2.new(0, 0)
    local lastMousePosition = Mouse.X, Mouse.Y
    Window.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local x, y = Mouse.X, Mouse.Y
            local dx, dy = x - lastMousePosition.X, y - lastMousePosition.Y
            Window:TweenPosition(UDim2.new(0, dx, 0, dy, "Out", "Quad", 0.2, true)
            lastMousePosition = Vector2.new(x, y)
        end
    end)
    Mouse.Move:Connect(function()
        local x, y = Mouse.X, Mouse.Y
        local dx, dy = x - lastMousePosition.X, y - lastMousePosition.Y
        Window.Position = UDim2.new(0, dx, 0, dy)
        lastMousePosition = Vector2.new(x, y)
    end)
end

-- Hide UI initially and set up activation mechanism
initializeUI()
