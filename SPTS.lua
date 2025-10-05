local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = cloneref(game:GetService("VirtualUser"))

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

local AutoInvis = false
local AutoRespawn = false
local TeamsESP = false
local AutoFS = false
local AutoBT = false
local AutoMS = false
local AutoJF = false
local AutoPP = false
local AutoMSJF = false
local Weight = 1

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
		TeleportService:TeleportToPlaceInstance(PlaceId, Servers[math.random(1, #Servers)], Players.LocalPlayer)
	else
		warn("No available servers found.")
	end
end

local function Rejoin()
	TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
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

local Toggle = FarmsTab:CreateToggle({
	Name = "Auto Respawn",
	CurrentValue = false,
	Flag = "AutoBT",
	Callback = function(Value)
	AutoRespawn = Value
	print(AutoRespawn)
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
	Name = "Auto Body Thoughness",
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

local Dropdown = FarmsTab:CreateDropdown({
	Name = "Weight",
	Options = {1, 2, 3, 4},
	CurrentOption = "3",
	MultipleOptions = false,
	Flag = "Weight",
	Callback = function(Options)
		Weight = Options[1]
	end,
})

local MiscTab = Window:CreateTab("Misc", 4483362458)
local MiscSection = MiscTab:CreateSection("Misc")

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
	Name = "Teams ESP",
	CurrentValue = false,
	Flag = "TeamsESP",
	Callback = function(Value)
		TeamsESP = Value
	end,
})

local TeleportsTab = Window:CreateTab("Teleports", 4483362458)
local TeleportsSection = TeleportsTab:CreateSection("Teleports Section")

local Button = TeleportsTab:CreateButton({
	Name = "Rejoin",
	Callback = function()
	Rejoin()
	end,
})

local Button = TeleportsTab:CreateButton({
	Name = "Server Hop",
	Callback = function()
	ServerHop()
	end,
})

local Dropdown = TeleportsTab:CreateDropdown({
	Name = "Teleports",
	Options = TrainingAreasStrings,
	CurrentOption = "",
	MultipleOptions = false,
	Flag = "Teleports",
	Callback = function(Options)
		TeleportTo = Options
		for _, part in ipairs(TrainingAreas) do
			if part.Name == TeleportTo[1] then
				Players.LocalPlayer.Character:SetPrimaryPartCFrame(part.CFrame + Vector3.new(0, 10, 0))
				print("Teleported to:", part.Name)
				break
			end
		end
	end,
})

local tickrate = 1 / 30
spawn(function()
	while wait(tickrate) do
		if TeamsESP then
			for _, v in pairs(Players:GetPlayers()) do
				local status = v:FindFirstChild("leaderstats") and v.leaderstats:FindFirstChild("Status").Value
				if v.Character and v.Character:FindFirstChild("Head") then
					local statusText = v.Character.Head:FindFirstChild("StatusBillboard")
					if not statusText then
						statusText = Instance.new("BillboardGui")
						statusText.Name = "StatusBillboard"
						statusText.Adornee = v.Character.Head
						statusText.Size = UDim2.new(0, 100, 0, 25)
						statusText.AlwaysOnTop = true
						statusText.MaxDistance = math.huge
						statusText.Parent = v.Character.Head

						local textLabel = Instance.new("TextLabel")
						textLabel.Name = "StatusLabel"
						textLabel.Size = UDim2.new(1, 0, 1, 0)
						textLabel.BackgroundTransparency = 1
						textLabel.TextScaled = true
						textLabel.Font = Enum.Font.SourceSansBold
						textLabel.Parent = statusText
					end

					local textLabel = statusText:FindFirstChild("StatusLabel")
					if textLabel then
						textLabel.Text = tostring(status or "")
						if status == "Innocent" then
							textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
						elseif status == "Protector" then
							textLabel.TextColor3 = Color3.fromRGB(255, 255, 150)
						elseif status == "Guardian" then
							textLabel.TextColor3 = Color3.fromRGB(144, 240, 144)
						elseif status == "Superhero" then
							textLabel.TextColor3 = Color3.fromRGB(0, 0, 255)
						elseif status == "Lawbreaker" then
							textLabel.TextColor3 = Color3.fromRGB(255, 140, 0)
						elseif status == "Criminal" then
							textLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
						elseif status == "Supervillain" then
							textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
						else
							textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
						end
					end
				end
			end
		end

		local character = Players.LocalPlayer and Players.LocalPlayer.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if humanoid and humanoid.Health <= 0 then
			if character and character.PrimaryPart then
				lastDeath = character.PrimaryPart.CFrame + Vector3.new(0, 10, 0)
			end
		end

		if AutoInvis then
			if character and character:FindFirstChild("Head") then
				if character.Head.Transparency == 0 then
					VirtualInputManager:SendKeyEvent(true, "T", false, game)
				end
			end
		end

		if AutoHideAura then
			if character and character:FindFirstChild("LeftHand") then
				if character.LeftHand:FindFirstChild("SPTS_FS_AURA") then
					VirtualInputManager:SendKeyEvent(true, "X", false, game)
				end
			end
		end -- yes the bills are very very high, and the rent is due

		if AutoPP then
			if Players.LocalPlayer and Players.LocalPlayer.Backpack then
				local tool = Players.LocalPlayer.Backpack:FindFirstChild("Meditate")
			end
			if tool and character then
				tool.Parent = Players.LocalPlayer.Character
			end
			wait(1)
		end

		if AutoRespawn then
			if Players.LocalPlayer.PlayerGui.IntroGui.Enabled then
				ReplicatedStorage.RemoteEvent:FireServer({ "Respawn" })
				Players.LocalPlayer.PlayerGui.IntroGui.Enabled = false
				Players.LocalPlayer.PlayerGui.ScreenGui.Enabled = true
				game.Lighting.Blur.Enabled = false
				while not Players.LocalPlayer.Character do
					wait()
				end
				if lastDeath then
					Players.LocalPlayer.Character:SetPrimaryPartCFrame(lastDeath)
				else
					print('no lastDeath found')
				end
			end
		end
		
		if AutoFS then
			ReplicatedStorage.RemoteEvent:FireServer({"Add_FS_Request"})
		end
		if AutoBT then
			ReplicatedStorage.RemoteEvent:FireServer({"+BT1"})
		end
		if AutoMS then
			ReplicatedStorage.RemoteEvent:FireServer({[1] = "EquipWeight_Request", [2] = Weight})
			ReplicatedStorage.RemoteEvent:FireServer({"Add_MS_Request"})
		end
		if AutoJF then
			ReplicatedStorage.RemoteEvent:FireServer({[1] = "EquipWeight_Request", [2] = Weight})
			ReplicatedStorage.RemoteEvent:FireServer({"Add_JF_Request"})
		end
		if AutoMSJF then
			ReplicatedStorage.RemoteEvent:FireServer({[1] = "EquipWeight_Request", [2] = Weight})
			ReplicatedStorage.RemoteEvent:FireServer({"Add_MS_Request"})
			ReplicatedStorage.RemoteEvent:FireServer({"Add_JF_Request"})
		end
	end
end)