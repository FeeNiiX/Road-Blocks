local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local PlaceId = game.PlaceId
local JobId = game.JobId
local plr = Players.LocalPlayer

local startTime = tick()
local duration = 30 * 60
local Hopping = true

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
local TimeLabel = Instance.new("TextLabel")
local Hop = Instance.new("TextButton")
local Toggle = Instance.new("TextButton")
local IncreaseButton = Instance.new("TextButton")
local DecreaseButton = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
TimeLabel.Parent = ScreenGui
TimeLabel.Size = UDim2.new(0, 200, 0, 50)
TimeLabel.Position = UDim2.new(0, 10, 0, 10)
TimeLabel.BackgroundTransparency = 0.5
TimeLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimeLabel.Font = Enum.Font.SourceSans
TimeLabel.TextSize = 24
TimeLabel.Text = "Time: 0s"

Hop.Parent = ScreenGui
Hop.Size = UDim2.new(0, 99, 0, 25)
Hop.Position = UDim2.new(0, 10, 0, 62)
Hop.BackgroundTransparency = 0.5
Hop.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Hop.TextColor3 = Color3.fromRGB(255, 255, 255)
Hop.Font = Enum.Font.SourceSans
Hop.TextSize = 22
Hop.Text = "Hop Now"

Toggle.Parent = ScreenGui
Toggle.Size = UDim2.new(0, 99, 0, 25)
Toggle.Position = UDim2.new(0, 111, 0, 62)
Toggle.BackgroundTransparency = 0.5
Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle.Font = Enum.Font.SourceSans
Toggle.TextSize = 22
Toggle.Text = "Toggle: ON"

IncreaseButton.Parent = ScreenGui
IncreaseButton.Size = UDim2.new(0, 40, 0, 36)
IncreaseButton.Position = UDim2.new(0, 215, 0, 10)
IncreaseButton.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
IncreaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
IncreaseButton.Font = Enum.Font.SourceSans
IncreaseButton.TextSize = 28
IncreaseButton.Text = "+"

DecreaseButton.Parent = ScreenGui
DecreaseButton.Size = UDim2.new(0, 40, 0, 36)
DecreaseButton.Position = UDim2.new(0, 215, 0, 50)
DecreaseButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
DecreaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DecreaseButton.Font = Enum.Font.SourceSans
DecreaseButton.TextSize = 28
DecreaseButton.Text = "-"

Toggle.MouseButton1Click:Connect(function()
	if Toggle.Text == "Toggle: ON" then
		Toggle.Text = "Toggle: OFF"
		Hopping = false
	else
		Toggle.Text = "Toggle: ON"
		Hopping = true
	end
end)

Hop.MouseButton1Click:Connect(function()
	serverHop()
end)

IncreaseButton.MouseButton1Click:Connect(function()
	duration = duration + 60
end)

DecreaseButton.MouseButton1Click:Connect(function()
	duration = math.max(0, duration - 60)
end)

spawn(function()
	while wait() do
		local elapsed = math.floor(tick() - startTime)
		TimeLabel.Text = "Time: " .. elapsed .. "/ " .. duration .. "s"

		if Hopping and elapsed >= duration then
			serverHop()
			wait(3)
		end
	end
end)