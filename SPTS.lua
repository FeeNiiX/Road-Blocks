local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = cloneref(game:GetService("VirtualUser"))

-- TODO: Track all other stats (i am the goat)

local Weight = 4
local RespawnTimer = 15

local GC = getconnections or get_signal_cons
if GC then
	for i,v in pairs(GC(Players.LocalPlayer.Idled)) do
		if v["Disable"] then
			v["Disable"](v)
		elseif v["Disconnect"] then
			v["Disconnect"](v)
		end
	end
else
	Players.LocalPlayer.Idled:Connect(function()
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end)
end

local TrainingAreas = {}
if workspace.Map and workspace.Map.Training_Collisions then
	for i, folders in pairs(workspace.Map.Training_Collisions:GetChildren()) do
		for j, parts in pairs(folders:GetChildren()) do
			table.insert(TrainingAreas, parts)
		end
	end
end

local TrainingAreasStrings = {}
for _, part in ipairs(TrainingAreas) do
	table.insert(TrainingAreasStrings, tostring(part.Name))
end

local function ServerHop()
	local PlaceId = game.PlaceId
	local Servers = {}
	local function GetServers()
		local response = game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true")
		local data = HttpService:JSONDecode(response)
		for _, server in ipairs(data.data) do
			if server.playing < server.maxPlayers and server.id ~= game.JobId then
				table.insert(Servers, server.id)
			end
		end
	end
	GetServers()
	if #Servers > 0 then
		TeleportService:TeleportToPlaceInstance(PlaceId, Servers[1], Players.LocalPlayer)
	else
		warn("No available servers found.")
	end
end

local ScreenGui = Instance.new("ScreenGui")
local FistLabel = Instance.new("TextLabel")
local BodyLabel = Instance.new("TextLabel")
local PsyLabel = Instance.new("TextLabel")
local ResetButton = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui

FistLabel.Name = "FistLabel"
FistLabel.Parent = ScreenGui
FistLabel.Position = UDim2.new(0, 0, 0.4, 0)
FistLabel.Size = UDim2.new(0.1, 0, 0.05, 0)
FistLabel.BackgroundTransparency = 0.5
FistLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FistLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FistLabel.TextStrokeTransparency = 0
FistLabel.TextStrokeColor3 = Color3.fromRGB(0 ,0 ,0)
FistLabel.Font = Enum.Font.SourceSans
FistLabel.TextScaled = true
FistLabel.Text = "Fist Strength/H: 0"

BodyLabel.Name = "BodyLabel"
BodyLabel.Parent = ScreenGui
BodyLabel.Position = UDim2.new(0, 0, 0.45, 0)
BodyLabel.Size = UDim2.new(0.1, 0, 0.05, 0)
BodyLabel.BackgroundTransparency = 0.5
BodyLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
BodyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
BodyLabel.TextStrokeTransparency = 0
BodyLabel.TextStrokeColor3 = Color3.fromRGB(0 ,0 ,0)
BodyLabel.Font = Enum.Font.SourceSans
BodyLabel.TextScaled = true
BodyLabel.Text = "Body Toughness/H: 0"

PsyLabel.Name = "PsyLabel"
PsyLabel.Parent = ScreenGui
PsyLabel.Position = UDim2.new(0, 0, 0.5, 0)
PsyLabel.Size = UDim2.new(0.1, 0, 0.05, 0)
PsyLabel.BackgroundTransparency = 0.5
PsyLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
PsyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PsyLabel.TextStrokeTransparency = 0
PsyLabel.TextStrokeColor3 = Color3.fromRGB(0 ,0 ,0)
PsyLabel.Font = Enum.Font.SourceSans
PsyLabel.TextScaled = true
PsyLabel.Text = "Psychic Power/H: 0"

ResetButton.Name = "ResetButton"
ResetButton.Parent = ScreenGui
ResetButton.Position = UDim2.new(0, 0, 0.55, 0)
ResetButton.Size = UDim2.new(0.1, 0, 0.05, 0)
ResetButton.BackgroundTransparency = 0.5
ResetButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ResetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetButton.TextStrokeTransparency = 0
ResetButton.TextStrokeColor3 = Color3.fromRGB(0 ,0 ,0)
ResetButton.Font = Enum.Font.SourceSans
ResetButton.TextScaled = true
ResetButton.Text = "Reset Values"

ResetButton.MouseButton1Click:Connect(function()
	FS_Track = nil
	BT_Track = nil
	PP_Track = nil
end)

local multipliers = {K = 1e3, M = 1e6, B = 1e9, T = 1e12, Qa = 1e15, Qi = 1e18, Sx = 1e21, Sp = 1e24, Oc = 1e27, No = 1e30, Dc = 1e33}

local function parseValue(str)
	if not str then return 0 end
	local num, suffix = str:match("([%d%.]+)(%a*)")
	num = tonumber(num)
	if num and suffix and multipliers[suffix] then
		return num * multipliers[suffix]
	elseif num then
		return num
	end
	return 0
end

local function formatNumber(n)
	local s = tostring(math.floor(n))
	local formatted = s:reverse():gsub("(%d%d%d)", "%1."):reverse()
	formatted = formatted:gsub("^%.", "")
	return formatted
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "Rayfield Example Window",
	Icon = 0,
	LoadingTitle = "Rayfield Interface Suite",
	LoadingSubtitle = "by Sirius",
	ShowText = "Rayfield",
	Theme = "Default",

	ToggleUIKeybind = "K",

	DisableRayfieldPrompts = false,
	DisableBuildWarnings = false,

	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil,
		FileName = "Big Hub"
	},

	Discord = {
		Enabled = false,
		Invite = "noinvitelink",
		RememberJoins = true
	},

	KeySystem = false,
	KeySettings = {
		Title = "Untitled",
		Subtitle = "Key System",
		Note = "No method of obtaining the key is provided",
		FileName = "Key",
		SaveKey = true,
		GrabKeyFromSite = false,
		Key = {"Hello"}
	}
})

local FarmsTab = Window:CreateTab("Farms", 4483362458)
local FarmSection = FarmsTab:CreateSection("Auto Farms")

local Dropdown = FarmsTab:CreateDropdown({
	Name = "Weight",
	Options = {"Unequipped" ,"100 LB", "1 TON", "10 TON", "100 TON"},
	CurrentOption = "100 TON",
	MultipleOptions = false,
	Flag = "Weight",
	Callback = function(Options)
		local weightMap = {
			["Unequipped"] = 0,
			["100 LB"] = 1,
			["1 TON"] = 2,
			["10 TON"] = 3,
			["100 TON"] = 4
		}
		Weight = weightMap[Options[1]] or 0
	end,
})

local Toggle = FarmsTab:CreateToggle({
	Name = "Auto Respawn",
	CurrentValue = false,
	Flag = "AutoRespawn",
	Callback = function(Value)
	AutoRespawn = Value
	end,
})

local Slider = FarmsTab:CreateSlider({
   Name = "Respawn Timer",
   Range = {1, 60},
   Increment = 1,
   Suffix = "(s)",
   CurrentValue = 15,
   Flag = "Respawn Timer",
   Callback = function(Value)
   RespawnTimer = Value
   end,
})

local Toggle = FarmsTab:CreateToggle({
	Name = "Auto Fist Strenght",
	CurrentValue = false,
	Flag = "AutoFS",
	Callback = function(Value)
	AutoFS = Value
	end,
})

local Toggle = FarmsTab:CreateToggle({
	Name = "Auto Body Toughness",
	CurrentValue = false,
	Flag = "AutoBT",
	Callback = function(Value)
	AutoBT = Value
	end,
})

local Toggle = FarmsTab:CreateToggle({
	Name = "Auto Movement Speed",
	CurrentValue = false,
	Flag = "AutoMS",
	Callback = function(Value)
	AutoMS = Value
	end,
})

local Toggle = FarmsTab:CreateToggle({
	Name = "Auto Jump Force",
	CurrentValue = false,
	Flag = "AutoJF",
	Callback = function(Value)
	AutoJF = Value
	end,
})

local Toggle = FarmsTab:CreateToggle({
	Name = "Auto MS & JF",
	CurrentValue = false,
	Flag = "AutoMSJF",
	Callback = function(Value)
	AutoMSJF = Value
	end,
})

local Toggle = FarmsTab:CreateToggle({
	Name = "Auto Psychic Power",
	CurrentValue = false,
	Flag = "AutoPP",
	Callback = function(Value)
	AutoPP = Value
	end,
})

local TeleportsTab = Window:CreateTab("Teleports", 4483362458)
local TeleportsSection = TeleportsTab:CreateSection("Teleports Section")

local Dropdown = TeleportsTab:CreateDropdown({
	Name = "Teleports",
	Options = TrainingAreasStrings,
	CurrentOption = "",
	MultipleOptions = false,
	Flag = "Teleports",
	Callback = function(Options)
		for _, part in ipairs(TrainingAreas) do
			if part.Name == Options[1] then
				Players.LocalPlayer.Character:SetPrimaryPartCFrame(part.CFrame + Vector3.new(0, 10, 0))
				break
			end
		end
	end,
})

local Button = TeleportsTab:CreateButton({
	Name = "Blue Star",
	Callback = function()
	Players.LocalPlayer.Character:SetPrimaryPartCFrame(workspace.Map.Training_Collisions.FistStrength.StarFSTraining1.CFrame + Vector3.new(0, 10, 0))
	end,
})

local Button = TeleportsTab:CreateButton({
	Name = "Green Star",
	Callback = function()
	Players.LocalPlayer.Character:SetPrimaryPartCFrame(workspace.Map.Training_Collisions.FistStrength.StarFSTraining2.CFrame + Vector3.new(0, 10, 0))
	end,
})

local Button = TeleportsTab:CreateButton({
	Name = "Red Star",
	Callback = function()
	Players.LocalPlayer.Character:SetPrimaryPartCFrame(workspace.Map.Training_Collisions.FistStrength.StarFSTraining3.CFrame + Vector3.new(0, 10, 0))
	end,
})

local Button = TeleportsTab:CreateButton({
	Name = "Psychic Island",
	Callback = function()
	Players.LocalPlayer.Character:SetPrimaryPartCFrame(workspace.Map.Training_Collisions.PsychicPower.PPTrainingPart4.CFrame + Vector3.new(0, 10, 0))
	end,
})

local Button = TeleportsTab:CreateButton({
	Name = "10T Pool",
	Callback = function()
	Players.LocalPlayer.Character:SetPrimaryPartCFrame(workspace.Map.Training_Collisions.BodyToughness.LavaPart2.CFrame)
	end,
})

local MiscTab = Window:CreateTab("Misc", 4483362458)
local MiscSection = MiscTab:CreateSection("Misc")

local Button = MiscTab:CreateButton({
	Name = "Rejoin",
	Callback = function()
	TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
	end,
})

local Button = MiscTab:CreateButton({
	Name = "Server Hop",
	Callback = function()
	ServerHop()
	end,
})

local Button = MiscTab:CreateButton({
	Name = "Infinite Yield",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
	end,
})

local Button = MiscTab:CreateButton({
	Name = "Dex Explorer",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
	end,
})

local Toggle = MiscTab:CreateToggle({
	Name = "Auto Invisible (T)",
	CurrentValue = false,
	Flag = "AutoInvis",
	Callback = function(Value)
		AutoInvis = Value
	end,
})

local Toggle = MiscTab:CreateToggle({
	Name = "Auto Hide Aura (X)",
	CurrentValue = false,
	Flag = "AutoHideAura",
	Callback = function(Value)
		AutoHideAura = Value
	end,
})

local Toggle = MiscTab:CreateToggle({
	Name = "ESP",
	CurrentValue = false,
	Flag = "ESP",
	Callback = function(Value)
		ESP = Value
	end,
})

local tickrate = 1 / 30
spawn(function()
	while wait(tickrate) do
		local char = Players.LocalPlayer and Players.LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")

		if not AtmosphereDestroyed then
			workspace.Map.TrainingArea.StarFSTraining1.Atmosphere1:Destroy()
			workspace.Map.TrainingArea.StarFSTraining1.Atmosphere2:Destroy()

			workspace.Map.TrainingArea.StarFSTraining2.Atmosphere1:Destroy()
			workspace.Map.TrainingArea.StarFSTraining2.Atmosphere2:Destroy()

			workspace.Map.TrainingArea.StarFSTraining3.Atmosphere1:Destroy()
			workspace.Map.TrainingArea.StarFSTraining3.Atmosphere2:Destroy()
			AtmosphereDestroyed = true
		end

		if not FSTxt and not BTTxt and not PPTxt then
			FSTxt = Players.LocalPlayer.PlayerGui.ScreenGui.MenuFrame.InfoFrame.FSTxt
			BTTxt = Players.LocalPlayer.PlayerGui.ScreenGui.MenuFrame.InfoFrame.BTTxt
			PPTxt = Players.LocalPlayer.PlayerGui.ScreenGui.MenuFrame.InfoFrame.PPTxt

			if FSTxt then
				FSTxt:GetPropertyChangedSignal("Text"):Connect(function()
					local FS_Text = FSTxt.Text
					local FS_ValueStr = FS_Text:match("Fist Strength%s*:%s*([%d%.]+%a*)")

					if FS_ValueStr then
						if not FS_Track then
							FS_Track = {
								startTime = tick(),
								startValue = parseValue(FS_ValueStr),
								lastValue = parseValue(FS_ValueStr),
								lastTime = tick(),
								gainPerHour = 0
							}
						else
							local currentValue = parseValue(FS_ValueStr)
							local currentTime = tick()
							local elapsed = currentTime - FS_Track.startTime
							local gain = currentValue - FS_Track.startValue
							if elapsed > 0 then
								FS_Track.gainPerHour = gain / elapsed * 3600
							end
							FS_Track.lastValue = currentValue
							FS_Track.lastTime = currentTime
						end

						FistLabel.Text = string.format("Fist Strength/H: %s", formatNumber(FS_Track.gainPerHour))
					end
				end)
			end

			if BTTxt then
				BTTxt:GetPropertyChangedSignal("Text"):Connect(function()
					local BT_Text = BTTxt.Text
					local BT_ValueStr = BT_Text:match("Body Toughness%s*:%s*([%d%.]+%a*)")

					if BT_ValueStr then
						if not BT_Track then
							BT_Track = {
								startTime = tick(),
								startValue = parseValue(BT_ValueStr),
								lastValue = parseValue(BT_ValueStr),
								lastTime = tick(),
								gainPerHour = 0
							}
						else
							local currentValue = parseValue(BT_ValueStr)
							local currentTime = tick()
							local elapsed = currentTime - BT_Track.startTime
							local gain = currentValue - BT_Track.startValue
							if elapsed > 0 then
								BT_Track.gainPerHour = gain / elapsed * 3600
							end
							BT_Track.lastValue = currentValue
							BT_Track.lastTime = currentTime
						end

						BodyLabel.Text = string.format("Body Toughness/H: %s", formatNumber(BT_Track.gainPerHour))
					end
				end)
			end

			if PPTxt then
				PPTxt:GetPropertyChangedSignal("Text"):Connect(function()
					local PP_Text = PPTxt.Text
					local PP_ValueStr = PP_Text:match("Psychic Power%s*:%s*([%d%.]+%a*)")

					if PP_ValueStr then
						if not PP_Track then
							PP_Track = {
								startTime = tick(),
								startValue = parseValue(PP_ValueStr),
								lastValue = parseValue(PP_ValueStr),
								lastTime = tick(),
								gainPerHour = 0
							}
						else
							local currentValue = parseValue(PP_ValueStr)
							local currentTime = tick()
							local elapsed = currentTime - PP_Track.startTime
							local gain = currentValue - PP_Track.startValue
							if elapsed > 0 then
								PP_Track.gainPerHour = gain / elapsed * 3600
							end
							PP_Track.lastValue = currentValue
							PP_Track.lastTime = currentTime
						end

						PsyLabel.Text = string.format("Psychic Power/H: %s", formatNumber(PP_Track.gainPerHour))
					end
				end)
			end
		end

		if ESP then
			for _, v in pairs(Players:GetPlayers()) do
				local status = v:FindFirstChild("leaderstats") and v.leaderstats:FindFirstChild("Status") and v.leaderstats.Status.Value
				if v.Character and v.Character:FindFirstChild("Head") then
					local statusText = v.Character.Head:FindFirstChild("Wallacks")
					if not statusText then
						statusText = Instance.new("BillboardGui")
						statusText.Name = "Wallacks"
						statusText.Adornee = v.Character.Head
						statusText.Size = UDim2.new(0, 100, 0, 50)
						statusText.AlwaysOnTop = true
						statusText.MaxDistance = math.huge
						statusText.Parent = v.Character.Head

						local nameLabel = Instance.new("TextLabel")
						nameLabel.Name = "NameLabel"
						nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
						nameLabel.Position = UDim2.new(0, 0, 0, 0)
						nameLabel.BackgroundTransparency = 1
						nameLabel.TextScaled = true
						nameLabel.Font = Enum.Font.SourceSansBold
						nameLabel.TextStrokeTransparency = 0
						nameLabel.TextStrokeColor3 = Color3.new(0,0,0)
						nameLabel.Parent = statusText

						local statusLabel = Instance.new("TextLabel")
						statusLabel.Name = "StatusLabel"
						statusLabel.Size = UDim2.new(1, 0, 0.5, 0)
						statusLabel.Position = UDim2.new(0, 0, 0.5, 0)
						statusLabel.BackgroundTransparency = 1
						statusLabel.TextScaled = true
						statusLabel.Font = Enum.Font.SourceSansBold
						statusLabel.TextStrokeTransparency = 0
						statusLabel.TextStrokeColor3 = Color3.new(0,0,0)
						statusLabel.Parent = statusText
					end

					local nameLabel = statusText:FindFirstChild("NameLabel")
					local statusLabel = statusText:FindFirstChild("StatusLabel")
					if nameLabel and statusLabel then
						nameLabel.Text = v.DisplayName
						statusLabel.Text = tostring(status or "nil")
						if status == "Innocent" then
							statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
							nameLabel.TextColor3 = statusLabel.TextColor3
						elseif status == "Protector" then
							statusLabel.TextColor3 = Color3.fromRGB(255, 255, 150)
							nameLabel.TextColor3 = statusLabel.TextColor3
						elseif status == "Guardian" then
							statusLabel.TextColor3 = Color3.fromRGB(144, 240, 144)
							nameLabel.TextColor3 = statusLabel.TextColor3
						elseif status == "Superhero" then
							statusLabel.TextColor3 = Color3.fromRGB(0, 0, 255)
							nameLabel.TextColor3 = statusLabel.TextColor3
						elseif status == "Lawbreaker" then
							statusLabel.TextColor3 = Color3.fromRGB(255, 140, 0)
							nameLabel.TextColor3 = statusLabel.TextColor3
						elseif status == "Criminal" then
							statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
							nameLabel.TextColor3 = statusLabel.TextColor3
						elseif status == "Supervillain" then
							statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
							nameLabel.TextColor3 = statusLabel.TextColor3
						elseif status == "Devilish" then
							statusLabel.TextColor3 = Color3.fromRGB(125, 0, 200)
							nameLabel.TextColor3 = statusLabel.TextColor3
						else
							statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
							nameLabel.TextColor3 = statusLabel.TextColor3
						end
					end
				end
			end
		else
			for _, v in pairs(Players:GetChildren()) do
				if v.Character and v.Character:FindFirstChild("Head") then
					if v.Character.Head:FindFirstChild("Wallacks") then
						v.Character.Head.Wallacks:Destroy()
					end
				end
			end
		end

		if AutoRespawn then
			if char and char.PrimaryPart and hum and hum.Health <= 0 then
				if not lastDeath then
					lastDeath = (char.PrimaryPart.CFrame + Vector3.new(0, 10, 0))
				end
			end
			if Players.LocalPlayer.PlayerGui.IntroGui.Enabled then
				ReplicatedStorage.RemoteEvent:FireServer({ "Respawn" })
				Players.LocalPlayer.PlayerGui.IntroGui.Enabled = false
				Players.LocalPlayer.PlayerGui.ScreenGui.Enabled = true
				game.Lighting.Blur.Enabled = false

				if Players.LocalPlayer.Character and lastDeath then
					wait(RespawnTimer)
					Players.LocalPlayer.Character:SetPrimaryPartCFrame(lastDeath)
					lastDeath = nil
				end
			end
		end

		if AutoInvis then
			if char and char:FindFirstChild("Head") and char:FindFirstChild("Head").Transparency == 0 then
				ReplicatedStorage.RemoteEvent:FireServer({ "Skill_Invisible" })
			end
		end
		
		if AutoHideAura then
			if char and char:FindFirstChild("LeftHand") and char:FindFirstChild("LeftHand"):FindFirstChild("SPTS_FS_AURA") then
				ReplicatedStorage.RemoteEvent:FireServer({ "ConcealRevealAura" }) -- found these at LocalPlayer script StarterPlayerScript something like this ahh
			end
		end

		if AutoPP then -- this could be better no?
			if Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("Backpack") then
				local tool = Players.LocalPlayer.Backpack:FindFirstChild("Meditate")
			end
			if tool and char and tool.Parent ~= char then
				tool.Parent = char
				print("635")
			end
		end
		
		if char then
			if not Players.LocalPlayer.Character:FindFirstChild("SPTS_Weight") and AutoMS or AutoJF or AutoMSJF then
				ReplicatedStorage.RemoteEvent:FireServer({[1] = "EquipWeight_Request", [2] = Weight})
			end
			if AutoFS then
				ReplicatedStorage.RemoteEvent:FireServer({"Add_FS_Request"})
			end
			if AutoBT then
				ReplicatedStorage.RemoteEvent:FireServer({"+BT1"})
			end
			if AutoMS then
				ReplicatedStorage.RemoteEvent:FireServer({"Add_MS_Request"})
			end
			if AutoJF then
				ReplicatedStorage.RemoteEvent:FireServer({"Add_JF_Request"})
			end
			if AutoMSJF then
				ReplicatedStorage.RemoteEvent:FireServer({"Add_MS_Request"})
				ReplicatedStorage.RemoteEvent:FireServer({"Add_JF_Request"})
			end
		end
	end
end)