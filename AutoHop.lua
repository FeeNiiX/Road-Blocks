local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local PlaceId = game.PlaceId
local JobId = game.JobId
local plr = Players.LocalPlayer

local startTime = tick()
local duration = 30 * 60

local ScreenGui = Instance.new("ScreenGui")
local TimeLabel = Instance.new("TextLabel")
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

IncreaseButton.Parent = ScreenGui
IncreaseButton.Size = UDim2.new(0, 25, 0, 22)
IncreaseButton.Position = UDim2.new(0, 215, 0, 10)
IncreaseButton.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
IncreaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
IncreaseButton.Font = Enum.Font.SourceSans
IncreaseButton.TextSize = 28
IncreaseButton.Text = "+"

DecreaseButton.Parent = ScreenGui
DecreaseButton.Size = UDim2.new(0, 25, 0, 22)
DecreaseButton.Position = UDim2.new(0, 215, 0, 38)
DecreaseButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
DecreaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DecreaseButton.Font = Enum.Font.SourceSans
DecreaseButton.TextSize = 28
DecreaseButton.Text = "-"

IncreaseButton.MouseButton1Click:Connect(function()
	duration = duration + 60
end)

DecreaseButton.MouseButton1Click:Connect(function()
	duration = math.max(0, duration - 60)
end)

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

spawn(function()
	while wait() do
		local elapsed = math.floor(tick() - startTime)
		TimeLabel.Text = "Time: " .. elapsed .. "s / " .. duration .. "s"

		if elapsed >= duration then
			serverHop()
			wait(3)
		end
	end
end)