local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

repeat wait() until game:IsLoaded()

local PlaceId = game.PlaceId
local JobId = game.JobId
local plr = Players.LocalPlayer

local startTime = tick()
local duration = 30 * 60
local Hopping = true

local function tweenToTarget(target)
	local distance = (target.PrimaryPart.Position - plr.Character.PrimaryPart.Position).Magnitude
	local time = distance / 350
	local info = TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local tween = TweenService:Create(plr.Character.PrimaryPart, info, {CFrame = CFrame.new(target.PrimaryPart.Position)})
	tween:Play()
end

local function serverHop()
	local servers = {}
	local req = game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true")
	local body = HttpService:JSONDecode(req)
	
	if body and body.data then
		for i, v in next, body.data do
			if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= JobId then
				table.insert(servers, 1, v.id)
			end
		end
	end
	
	if #servers > 0 then
		TeleportService:TeleportToPlaceInstance(PlaceId, servers[math.random(1, #servers)], plr)
	end
end

local ScreenGui = Instance.new("ScreenGui")
local Container = Instance.new("Frame")
local TimeLabel = Instance.new("TextLabel")
local ButtonsFrame = Instance.new("Frame")
local Hop = Instance.new("TextButton")
local Toggle = Instance.new("TextButton")
local ControlsFrame = Instance.new("Frame")
local IncreaseButton = Instance.new("TextButton")
local DecreaseButton = Instance.new("TextButton")
local UIListLayout = Instance.new("UIListLayout")
local ExtraButtonsFrame = Instance.new("Frame")
local AncientMonkButton = Instance.new("TextButton")
local PreviousHeroButton = Instance.new("TextButton")
local TrevorButton = Instance.new("TextButton")
local UzothButton = Instance.new("TextButton")
local SharkmanButton = Instance.new("TextButton")

ScreenGui.Parent = Players.LocalPlayer.PlayerGui

Container.Name = "Container"
Container.Parent = ScreenGui
Container.AnchorPoint = Vector2.new(1, 0)
Container.Position = UDim2.new(1, 0, 0, 0)
Container.Size = UDim2.new(0.2, 0, 0, 90)
Container.BackgroundTransparency = 1

UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

TimeLabel.Name = "TimeLabel"
TimeLabel.Parent = Container
TimeLabel.Size = UDim2.new(1, 0, 0, 28)
TimeLabel.BackgroundTransparency = 0.5
TimeLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimeLabel.Font = Enum.Font.SourceSans
TimeLabel.TextScaled = true
TimeLabel.Text = "Time: 0s"

ButtonsFrame.Name = "ButtonsFrame"
ButtonsFrame.Parent = Container
ButtonsFrame.Size = UDim2.new(1, 0, 0, 28)
ButtonsFrame.BackgroundTransparency = 1

Hop.Name = "Hop"
Hop.Parent = ButtonsFrame
Hop.AnchorPoint = Vector2.new(1, 0)
Hop.Position = UDim2.new(1, 0, 0, 0)
Hop.Size = UDim2.new(0.5, 0, 1, 0)
Hop.BackgroundTransparency = 0.5
Hop.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Hop.TextColor3 = Color3.fromRGB(255, 255, 255)
Hop.Font = Enum.Font.SourceSans
Hop.TextScaled = true
Hop.Text = "Hop Now"

Toggle.Name = "Toggle"
Toggle.Parent = ButtonsFrame
Toggle.AnchorPoint = Vector2.new(1, 0)
Toggle.Position = UDim2.new(0.5, 0, 0, 0)
Toggle.Size = UDim2.new(0.5, 0, 1, 0)
Toggle.BackgroundTransparency = 0.5
Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle.Font = Enum.Font.SourceSans
Toggle.TextScaled = true
Toggle.Text = "Hopping: ON"

ControlsFrame.Name = "ControlsFrame"
ControlsFrame.Parent = Container
ControlsFrame.Size = UDim2.new(1, 0, 0, 28)
ControlsFrame.BackgroundTransparency = 1

IncreaseButton.Name = "IncreaseButton"
IncreaseButton.Parent = ControlsFrame
IncreaseButton.AnchorPoint = Vector2.new(1, 0)
IncreaseButton.Position = UDim2.new(1, 0, 0, 0)
IncreaseButton.Size = UDim2.new(0.5, 0, 1, 0)
IncreaseButton.BackgroundTransparency = 0.5
IncreaseButton.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
IncreaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
IncreaseButton.Font = Enum.Font.SourceSans
IncreaseButton.TextScaled = true
IncreaseButton.Text = "+ 5 Min"

DecreaseButton.Name = "DecreaseButton"
DecreaseButton.Parent = ControlsFrame
DecreaseButton.AnchorPoint = Vector2.new(1, 0)
DecreaseButton.Position = UDim2.new(0.5, 0, 0, 0)
DecreaseButton.Size = UDim2.new(0.5, 0, 1, 0)
DecreaseButton.BackgroundTransparency = 0.5
DecreaseButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
DecreaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DecreaseButton.Font = Enum.Font.SourceSans
DecreaseButton.TextScaled = true
DecreaseButton.Text = "- 5 Min"

ExtraButtonsFrame.Name = "ExtraButtonsFrame"
ExtraButtonsFrame.Parent = Container
ExtraButtonsFrame.Size = UDim2.new(1, 0, 0, 28)
ExtraButtonsFrame.BackgroundTransparency = 1

AncientMonkButton.Name = "AncientMonkButton"
AncientMonkButton.Parent = ExtraButtonsFrame
AncientMonkButton.AnchorPoint = Vector2.new(1, 0)
AncientMonkButton.Position = UDim2.new(0.2, 0, 0, 0)
AncientMonkButton.Size = UDim2.new(0.2, 0, 1, 0)
AncientMonkButton.BackgroundTransparency = 0.5
AncientMonkButton.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
AncientMonkButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AncientMonkButton.Font = Enum.Font.SourceSans
AncientMonkButton.TextScaled = true
AncientMonkButton.Text = "TP To Ancient Monk"

PreviousHeroButton.Name = "PreviousHeroButton"
PreviousHeroButton.Parent = ExtraButtonsFrame
PreviousHeroButton.AnchorPoint = Vector2.new(1, 0)
PreviousHeroButton.Position = UDim2.new(0.4, 0, 0, 0)
PreviousHeroButton.Size = UDim2.new(0.2, 0, 1, 0)
PreviousHeroButton.BackgroundTransparency = 0.5
PreviousHeroButton.BackgroundColor3 = Color3.fromRGB(120, 60, 220)
PreviousHeroButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PreviousHeroButton.Font = Enum.Font.SourceSans
PreviousHeroButton.TextScaled = true
PreviousHeroButton.Text = "TP To Previous Hero"

TrevorButton.Name = "TrevorButton"
TrevorButton.Parent = ExtraButtonsFrame
TrevorButton.AnchorPoint = Vector2.new(1, 0)
TrevorButton.Position = UDim2.new(0.6, 0, 0, 0)
TrevorButton.Size = UDim2.new(0.2, 0, 1, 0)
TrevorButton.BackgroundTransparency = 0.5
TrevorButton.BackgroundColor3 = Color3.fromRGB(255, 100, 255)
TrevorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TrevorButton.Font = Enum.Font.SourceSans
TrevorButton.TextScaled = true
TrevorButton.Text = "TP To Trevor"

UzothButton.Name = "UzothButton"
UzothButton.Parent = ExtraButtonsFrame
UzothButton.AnchorPoint = Vector2.new(1, 0)
UzothButton.Position = UDim2.new(0.8, 0, 0, 0)
UzothButton.Size = UDim2.new(0.2, 0, 1, 0)
UzothButton.BackgroundTransparency = 0.5
UzothButton.BackgroundColor3 = Color3.fromRGB(255, 125, 0)
UzothButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UzothButton.Font = Enum.Font.SourceSans
UzothButton.TextScaled = true
UzothButton.Text = "TP To Uzoth"

SharkmanButton.Name = "SharkmanButton"
SharkmanButton.Parent = ExtraButtonsFrame
SharkmanButton.AnchorPoint = Vector2.new(1, 0)
SharkmanButton.Position = UDim2.new(1, 0, 0, 0)
SharkmanButton.Size = UDim2.new(0.2, 0, 1, 0)
SharkmanButton.BackgroundTransparency = 0.5
SharkmanButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
SharkmanButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SharkmanButton.Font = Enum.Font.SourceSans
SharkmanButton.TextScaled = true
SharkmanButton.Text = "TP To Sharkman Teacher"

Toggle.MouseButton1Click:Connect(function()
	if Toggle.Text == "Hopping: ON" then
		Toggle.Text = "Hopping: OFF"
		Hopping = false
	else
		Toggle.Text = "Hopping: ON"
		Hopping = true
	end
end)

Hop.MouseButton1Click:Connect(function()
	serverHop()
end)

IncreaseButton.MouseButton1Click:Connect(function()
	duration = duration + 300
end)

DecreaseButton.MouseButton1Click:Connect(function()
	duration = math.max(0, duration - 300)
end)

AncientMonkButton.MouseButton1Click:Connect(function()
	local AncientMonk = (RS.NPCs:FindFirstChild("Ancient Monk") or workspace.NPCs:FindFirstChild("Ancient Monk"))
	if not AncientMonk then return end
	tweenToTarget(AncientMonk)
end)

PreviousHeroButton.MouseButton1Click:Connect(function()
	local PreviousHero = (RS.NPCs:FindFirstChild("Previous Hero") or workspace.NPCs:FindFirstChild("Previous Hero"))
	if not PreviousHero then return end
	tweenToTarget(PreviousHero)
end)

TrevorButton.MouseButton1Click:Connect(function()
	local Trevor = (RS.NPCs:FindFirstChild("Trevor") or workspace.NPCs:FindFirstChild("Trevor"))
	if not Trevor then return end
	tweenToTarget(Trevor)
end)

UzothButton.MouseButton1Click:Connect(function()
	local Uzoth = (RS.NPCs:FindFirstChild("Uzoth") or workspace.NPCs:FindFirstChild("Uzoth"))
	if not Uzoth then return end
	tweenToTarget(Uzoth)
end)

SharkmanButton.MouseButton1Click:Connect(function()
	local SharkmanTeacher = (RS.NPCs:FindFirstChild("Sharkman Teacher") or workspace.NPCs:FindFirstChild("Sharkman Teacher"))
	if not SharkmanTeacher then return end
	tweenToTarget(SharkmanTeacher)
end)

spawn(function()
	while wait() do
		local elapsed = math.floor(tick() - startTime)
		TimeLabel.Text = "Time: " .. elapsed .. "/" .. duration .. "s"

		if Hopping and elapsed >= duration then
			serverHop()
			wait(3)
		end
	end
end)

spawn(function()
	while wait() do
		local camera = workspace and workspace.CurrentCamera
		local function updateLayout()
			if not camera then return end
			local vw = camera.ViewportSize
			local widthPx = math.clamp(math.floor(vw.X * 0.20), 220, 480)
			local heightPx = math.clamp(math.floor(vw.Y * 0.20), 72, 160)
			Container.Size = UDim2.new(0, widthPx, 0, heightPx)
			UIListLayout.Padding = UDim.new(0, math.max(2, 0))
		end

		if camera then
			updateLayout()
			camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateLayout)
		end
	end
end)