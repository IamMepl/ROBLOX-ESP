local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local espEnabled = true

local function esp(player)
local character = player.Character
if character then
local highlight = Instance.new("Highlight")
highlight.Parent = character
highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
highlight.FillColor = Color3.new(0, 1, 0)
highlight.OutlineColor = Color3.new(0, 1, 0)

local billboard = Instance.new("BillboardGui")
billboard.Parent = character.Head
billboard.Size = UDim2.new(0, 200, 0, 50)
billboard.StudsOffset = Vector3.new(0, 2, 0)
billboard.AlwaysOnTop = true

local textlabel = Instance.new("TextLabel")
textlabel.Parent = billboard
textlabel.Size = UDim2.new(1, 0, 1, 0)
textlabel.BackgroundTransparency = 1
textlabel.Text = player.Name
textlabel.TextColor3 = Color3.new(1, 1, 1)
textlabel.TextSize = 14
end
end

local function removeEsp(player)
local character = player.Character
if character then
if character:FindFirstChild("Highlight") then
character:FindFirstChild("Highlight"):Destroy()
end
if character.Head:FindFirstChild("BillboardGui") then
character.Head:FindFirstChild("BillboardGui"):Destroy()
end
end
end

for _, player in pairs(Players:GetPlayers()) do
if player ~= Players.LocalPlayer then
if espEnabled then
esp(player)
end
end
end

Players.PlayerAdded:Connect(function(player)
player.CharacterAdded:Connect(function(character)
if espEnabled then
esp(player)
end
end)
end)

local function toggleEsp()
espEnabled = not espEnabled
for _, player in pairs(Players:GetPlayers()) do
if player ~= Players.LocalPlayer then
if espEnabled then
esp(player)
else
removeEsp(player)
end
end
end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Players.LocalPlayer.PlayerGui

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 150, 0, 100)
Frame.Position = UDim2.new(0.5, -75, 0.5, -50)
Frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
Frame.BackgroundTransparency = 0.5
Frame.BorderSizePixel = 1

local dragging = false
local dragInput, dragStart, startPos

Frame.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
dragStart = input.Position
startPos = Frame.Position

input.Changed:Connect(function()
if input.UserInputState == Enum.UserInputState.End then
dragging = false
end
end)
end
end)

Frame.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
dragInput = input
end
end)

UserInputService.InputChanged:Connect(function(input)
if input == dragInput and dragging then
local delta = input.Position - dragStart
Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
end)

local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = Frame
ToggleButton.Size = UDim2.new(0.8, 0, 0.4, 0)
ToggleButton.Position = UDim2.new(0.1, 0, 0.3, 0)
ToggleButton.Text = "ESP: On"

ToggleButton.MouseButton1Click:Connect(function()
toggleEsp()
if espEnabled then
ToggleButton.Text = "ESP: On"
else
ToggleButton.Text = "ESP: Off"
end
end)
