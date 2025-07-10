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