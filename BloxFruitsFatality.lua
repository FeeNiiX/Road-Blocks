print('Loading Blox Fruits Fatality...')
-- local Library = loadstring(readfile('Library.lua'))()
-- local ThemeManager = loadstring(readfile('ThemeManager.lua'))()
-- local SaveManager = loadstring(readfile('SaveManager.lua'))()
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/FeeNiiX/BloxFruitsFatality/refs/heads/develop/libs/Linoria/Library.lua'))()
local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/FeeNiiX/BloxFruitsFatality/refs/heads/develop/libs/Linoria/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/FeeNiiX/BloxFruitsFatality/refs/heads/develop/libs/Linoria/SaveManager.lua'))()

local VirtualInputManager = game:GetService('VirtualInputManager')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local TeleportService = game:GetService('TeleportService')
local TweenService = game:GetService('TweenService')
local VirtualUser = game:GetService('VirtualUser')
local RunService = game:GetService('RunService')
local StarterGui = game:GetService('StarterGui')
local Lighting = game:GetService('Lighting')
local Players = game:GetService('Players')
local Stats = game:GetService('Stats')
local Player = Players.LocalPlayer

-- TODO --
-- Add Fast attack
-- Add Hitbox Expander (maybe its just humanoidrootpart butt lift)
-- Literally make an auto farm because thats the whole point of a blox fruits script? 😭😭😭😭😭😭
-- Smart Teleport from hoho hub? (I already know how to 😈)

local SelectedTeam = 'Pirates' -- Change your team here nigga

repeat wait()
	if Player.PlayerGui:FindFirstChild('Main (minimal)') then
		local Main = Player.PlayerGui['Main (minimal)']
		if Main.ChooseTeam.Visible == true then
			if SelectedTeam == "Pirate" then
				for i, v in pairs(getconnections(Main.ChooseTeam.Container.Pirates.Frame.TextButton.Activated)) do
					v.Function()
				end
			elseif SelectedTeam == "Marine" then
				for i, v in pairs(getconnections(Main.ChooseTeam.Container.Marines.Frame.TextButton.Activated)) do
					v.Function()
				end
			else
				for i, v in pairs(getconnections(Main.ChooseTeam.Container.Pirates.Frame.TextButton.Activated)) do
					v.Function()
				end
			end
		end
	end
until Player.Team ~= nil and game:IsLoaded()

-- Functions

local CameraShaker = require(ReplicatedStorage.Util.CameraShaker)
CameraShaker:Stop()

Player.Idled:Connect(function()
	print('Anti AFK saved your ass')
	VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
	wait(1)
	VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

local function GetNPCs()
	local NPCs = {}
	
	for i, v in pairs(workspace.NPCs:GetChildren()) do
		if v:IsA('Model') then
			table.insert(NPCs, v.Name)
		end
	end

	for i, v in pairs(ReplicatedStorage.NPCs:GetChildren()) do
		if v:IsA('Model') then
			table.insert(NPCs, v.Name)
		end
	end

	table.sort(NPCs)
	return NPCs
end

--[[ local function Tween(tar)
	local root = Player.Character:FindFirstChild('HumanoidRootPart')
	
	if root and tar then
		if tar == SelectedPlayer then
			tar = workspace.Characters:FindFirstChild(SelectedPlayer).PrimaryPart.CFrame
			
		elseif tar == SelectedNPC then
			tOffsetX, tOffsetY, tOffsetZ = 0, 0, 0
			if workspace.NPCs:FindFirstChild(SelectedNPC) then
				tar = workspace.NPCs:FindFirstChild(SelectedNPC).PrimaryPart.CFrame
			else
				tar = ReplicatedStorage.NPCs:FindFirstChild(SelectedNPC).PrimaryPart.CFrame
			end
			
		elseif tar == SelectedIsland then
			tar = workspace.Map:FindFirstChild(SelectedIsland).WorldPivot
		end
		local dist = (tar.Position - root.Position).Magnitude
		
		TweenService:Create(root, TweenInfo.new((dist - 150)/TweenSpeed, Enum.EasingStyle.Linear), {CFrame = tar + Vector3.new(offX, offY, offZ)}):Play()
		wait(1)
	end
end ]]

-- UI Elements
wait(2)

StarterGui:SetCore('SendNotification', {
	Title = 'Fatality Loaded Successfully',
	Duration = '3',
})

local Window = Library:CreateWindow({
	Title = 'fatality.win',
	Center = true,
	AutoShow = true,
	TabPadding = 8,
	MenuFadeTime = 0
})

local Tabs = {
	Main = Window:AddTab('Main'),
	Player = Window:AddTab('Player'),
	AutoFarm = Window:AddTab('AutoFarm'),
	Fruits = Window:AddTab('Fruits'),
	Visuals = Window:AddTab('Visuals'),
	Shop = Window:AddTab('Shop'),
	Misc = Window:AddTab('Misc'),
	Config = Window:AddTab('Config'),
}

local MenuGroup = Tabs.Config:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function()
	Library:Unload()
end)

MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'LeftControl', NoUI = true, Text = 'Menu keybind' })
Library.ToggleKeybind = Options.MenuKeybind

if game.PlaceId == 2753915549 then
	First_Sea = true
elseif game.PlaceId == 4442272183 then
	Second_Sea = true
elseif game.PlaceId == 7449423635 then
	Third_Sea = true
end

local IslandCheck = {
	First_Sea_Islands = {
		['Start Island'] = Vector3.new(1071, 16, 1426),
		['Marine Start'] = Vector3.new(-2573, 6, 2046),
		['Middle Town'] = Vector3.new(-655, 7, 1436),
		['Jungle'] = Vector3.new(-1249, 11, 341),
		['Pirate Village'] = Vector3.new(-1122, 4, 3855),
		['Desert'] = Vector3.new(1094, 6, 4192),
		['Frozen Village'] = Vector3.new(1198, 27, -1211),
		['Marine Ford'] = Vector3.new(-4505, 20, 4260),
		['Colosseum 1'] = Vector3.new(-1428, 7, -3014),
		['Sky island 1'] = Vector3.new(-4970, 717, -2622),
		['Sky island 2'] = Vector3.new(-4813, 903, -1912),
		['Sky island 3'] = Vector3.new(-7952, 5545, -320),
		['Sky island 4'] = Vector3.new(-7793, 5607, -2016),
		['Prison'] = Vector3.new(4854, 5, 740),
		['Magma Village'] = Vector3.new(-5231, 8, 8467),
		['UnderWater City'] = Vector3.new(61163, 11, 1819),
		['Fountain City'] = Vector3.new(5132, 4, 4037),
		['House Cyborgs'] = Vector3.new(6262, 71, 3998),
		['Shanks Room'] = Vector3.new(-1442, 29, -28),
		['Mob Island'] = Vector3.new(-2850, 7, 5354),
		['Dock'] = Vector3.new(82, 18, 2834)
	},
	Second_Sea_Islands = {
		['Kingdom of Rose'] = Vector3.new(-394, 118, 1245),
		['Mansion 1'] = Vector3.new(-390, 331, 673),
		['Flamingo Room'] = Vector3.new(2302, 15, 663),
		['Green Zone'] = Vector3.new(-2372, 72, -3166),
		['Cafe'] = Vector3.new(-385, 73, 297),
		['Factory'] = Vector3.new(430, 210, -432),
		['Colosseum'] = Vector3.new(-1836, 44, 1360),
		['Grave Island'] = Vector3.new(-5411, 48, -721),
		['Snow Mountain'] = Vector3.new(511, 401, -5380),
		['Cold Island'] = Vector3.new(-6026, 14, -5071),
		['Hot Island'] = Vector3.new(-5478, 15, -5246),
		['Cursed Ship'] = Vector3.new(902, 124, 33071),
		['Ice Castle'] = Vector3.new(5400, 28, -6236),
		['Forgotten Island'] = Vector3.new(-3043, 238, -10191),
		['Usoapp Island'] = Vector3.new(4748, 8, 2849)
	},
	Third_Sea_Islands = {
		['Port Town'] = Vector3.new(-610, 57, 6436),
		['Floating Turtle'] = Vector3.new(-10919, 331, -8637),
		['Mansion'] = Vector3.new(-12553, 332, -7621),
		['Castle on the Sea'] = Vector3.new(-5091, 314, -2976),
		['Hydra Island'] = Vector3.new(5229, 800, 345),
		['Friendly Arena'] = Vector3.new(5220, 72, -1450),
		['Haunted Castle'] = Vector3.new(-9530, -132, 5763),
		['Great Tree'] = Vector3.new(2174, 28, -6728),
		['Beautiful Pirate Domain'] = Vector3.new(5310, 21, 129),
		['Secret Temple'] = Vector3.new(5217, 6, 1100),
		['Teler Park'] = Vector3.new(-9512, 142, 5548),
		['Peanut Island'] = Vector3.new(-2142, 48, -10031),
		['Chocolate Island'] = Vector3.new(156, 30, -12662),
		['Ice Cream Island'] = Vector3.new(-949, 59, -10907),
		['Cake Loaf'] = Vector3.new(-2099, 66, -12128),
		['Candy Cane'] = Vector3.new(-1530, 13, -14770),
		['Mini Sky'] = Vector3.new(-263, 49325, -35260),
		['Tiki Outpost'] = Vector3.new(-16548, 55, -172)
	}
}

local Islands = {}
if First_Sea then
	for i, v in pairs(IslandCheck.First_Sea_Islands) do
		table.insert(Islands, i)
	end
elseif Second_Sea then
	for i, v in pairs(IslandCheck.Second_Sea_Islands) do
		table.insert(Islands, i)
	end
elseif Third_Sea then
	for i, v in pairs(IslandCheck.Third_Sea_Islands) do
		table.insert(Islands, i)
	end
end

-- Left Group Box Tweening
local Tweening = Tabs.Main:AddLeftGroupbox('Tweening')

local function Tween(tar, wait, offset)
	local root = Player.Character:FindFirstChild('HumanoidRootPart')
	if tar.CFrame then
		local info = TweenInfo.new(((tar.CFrame.Position - root.CFrame.Position).Magnitude - 150) / tSpeed)
		if offset then
			local t = TweenService:Create(root, info, {CFrame = tar.CFrame + Vector3.new(offX, offY, offZ)})
		else
			local t = TweenService:Create(root, info, {CFrame = tar.CFrame})
		end
	else
		local info = TweenInfo.new(((tar - root.CFrame.Position).Magnitude - 150) / tSpeed)
		if offset then
			local t = TweenService:Create(root, info, {CFrame = tar + Vector3.new(offX, offY, offZ)})
		else
			local t = TweenService:Create(root, info, {CFrame = tar})
		end
	end

	if root and info and tar then
		if wait then
			t:Play()
			t.Completed:Wait()
		else
			t:Play()
		end
	end
end

local function cancelTween()
	local root = Player.Character:FindFirstChild('HumanoidRootPart')
	if root then
		root.CFrame = root.CFrame
	end
end

Tweening:AddDropdown('PlayersDropdown', {SpecialType = 'Player', Text = 'Players', Callback = function(Value) end})
Options.PlayersDropdown:OnChanged(function()
	SelectedPlayer = Options.PlayersDropdown.Value
end)


Tweening:AddToggle('SpectatePlayerToggle', {Text = 'Spectate Player', Default = false, Callback = function(Value) end})
Toggles.SpectatePlayerToggle:OnChanged(function()
	if Toggles.SpectatePlayerToggle.Value then
		workspace.CurrentCamera.CameraSubject = workspace.Characters[SelectedPlayer]
	else
		workspace.CurrentCamera.CameraSubject = Player.Character
	end
end)


Tweening:AddToggle('TweenToPlayersToggle', {Text = 'Tween To Players', Default = false, Callback = function(Value) end})

Toggles.TweenToPlayersToggle:OnChanged(function()
	while Toggles.TweenToPlayersToggle.Value do
		local tar = Players:FindFirstChild(SelectedPlayer).Character.HumanoidRootPart
		if not tar then
			tar = workspace.Characters:FindFirstChild(SelectedPlayer).HumanoidRootPart
		else
			Tween(tar, false, true)
		end
		wait(1/60)
	end
end)


Tweening:AddDropdown('NPCsDropdown', {Values = GetNPCs(), Default = 'Barista Cousin', Multi = false, Text = 'NPCs', Callback = function(Value) end})
Options.NPCsDropdown:OnChanged(function()
	SelectedNPC = Options.NPCsDropdown.Value
end)

Tweening:AddToggle('TweenToNPCToggle', {Text = 'Tween To NPC', Default = false, Callback = function(Value) end})

Toggles.TweenToNPCToggle:OnChanged(function()
	while Toggles.TweenToNPCToggle.Value do
		if workspace.NPCs:FindFirstChild(SelectedNPC) then
			tar = workspace.NPCs:FindFirstChild(SelectedNPC).PrimaryPart
			Tween(tar, true, false)
		else
			tar = ReplicatedStorage.NPCs:FindFirstChild(SelectedNPC).PrimaryPart
			Tween(tar, true, false)
		end
	end
	wait(1)
end)

Tweening:AddDropdown('IslandsDropdown', {Values = Islands, Default = 0, Multi = false, Text = 'Islands', Callback = function(Value) end})
Options.IslandsDropdown:OnChanged(function()
	SelectedIsland = Options.IslandsDropdown.Value
end)


Tweening:AddToggle('TweenToIslandToggle', { Text = 'Tween To Island', Default = false, Callback = function(Value) end})
Toggles.TweenToIslandToggle:OnChanged(function()
	while wait(1) and Toggles.TweenToIslandToggle.Value and SelectedIsland do
		Tween(SelectedIsland, true, false)
	end
end)


Tweening:AddSlider('tSpeed', {Text = 'Tweening Speed', Default = 340, Min = 0, Max = 350, Rounding = 0, Compact = false,Callback = function(Value) end})
Options.tSpeed:OnChanged(function() tSpeed = Options.tSpeed.Value end)


Tweening:AddSlider('offX', {Text = 'Offset X', Default = 0, Min = 0, Max = 200, Rounding = 0, Compact = false, Callback = function(Value) end})
Options.offX:OnChanged(function() offX = Options.offX.Value end)


Tweening:AddSlider('offY', {Text = 'Offset Y', Default = 20, Min = 0, Max = 200, Rounding = 0, Compact = false, Callback = function(Value) end})
Options.offY:OnChanged(function() offY = Options.offY.Value end)


Tweening:AddSlider('offZ', {Text = 'Offset Z', Default = 0, Min = 0, Max = 200, Rounding = 0, Compact = false,Callback = function(Value) end})
Options.offZ:OnChanged(function() offZ = Options.offZ.Value end)

-- Auto Collect GroupBox
local AutoCollect = Tabs.Main:AddLeftGroupbox('Auto Collect')

AutoCollect:AddToggle('AutoChests', {Text = 'Auto Collect Chests', Default = false, Callback = function(Value) end})

spawn(function()
	while Toggles.AutoChests.Value do
		local root = Player.Character:FindFirstChild('HumanoidRootPart')
		local info = TweenInfo(((Chest.Position - root.Position).Magnitude - 150) / tSpeed)
		
		for i, v in pairs(workspace.ChestModels:GetChildren()) do
			if v.Name:find('Chest') and v:IsA('Model') then
				Chest = v.PrimaryPart.CFrame
			end
		end
		
		for i, v in pairs(workspace.Map:GetDescendants()) do
			if v.Name:find('Chest') and v:IsA('Part') and v.CanTouch then
				Chest = v.CFrame
			end
		end
		
		local t = TweenService:Create(root, info, {CFrame = Chest})
		t:Play()
		t.Completed:Wait()
	end
end)

local Number = math.random(1, 1000000)

AutoCollect:AddToggle('ChestESP', {Text = 'Chest ESP', Default = false, Callback = function(Value) end})

spawn(function()
	while wait(1) do
		for i, v in pairs(workspace:GetChildren()) do
			pcall(function()
				if string.find(v.Name, "Chest") then
					if ChestESP then
						if string.find(v.Name, "Chest") then
							if not v:FindFirstChild("NameEsp" .. Number) then
								local ChestGui = Instance.new("BillboardGui", v)
								ChestGui.Name = "NameEsp" .. Number;
								ChestGui.ExtentsOffset = Vector3.new(0, 1, 0)
								ChestGui.Size = UDim2.new(1, 200, 1, 30)
								ChestGui.Adornee = v;
								ChestGui.AlwaysOnTop = true;
								local ChestText = Instance.new("TextLabel", ChestGui)
								--ChestText.Font = "GothamBold"
								--ChestText.FontSize = "Size14"
								ChestText.TextWrapped = true;
								ChestText.Size = UDim2.new(1, 0, 1, 0)
								ChestText.TextYAlignment = "Top"
								ChestText.BackgroundTransparency = 1;
								ChestText.TextStrokeTransparency = 0.5;
								ChestText.TextColor3 = Color3.fromRGB(0, 255, 250)
								if v.Name == "Chest1" then
									ChestText.Text = "Chest 1" .. " \n" .. fDist((Player.Character.CFrame.Position - v.Position).Magnitude) .. " Studs"
								end;
								if v.Name == "Chest2" then
									ChestText.Text = "Chest 2" .. " \n" .. fDist((Player.Character.CFrame.Position - v.Position).Magnitude) .. " Studs"
								end;
								if v.Name == "Chest3" then
									ChestText.Text = "Chest 3" .. " \n" .. fDist((Player.Character.CFrame.Position - v.Position).Magnitude) .. " Studs"
								end
							else
								v["NameEsp" .. Number].TextLabel.Text = v.Name .. "   \n" .. fDist((Player.Character.Head.Position - v.Position).Magnitude) .. " Studs"
							end
						end
					else
						if v:FindFirstChild("NameEsp" .. Number) then
							v:FindFirstChild("NameEsp" .. Number):Destroy()
						end
					end
				end
			end)
		end
	end
end)

-- Servers GroupBox
local Servers = Tabs.Main:AddRightGroupbox('Servers')

Servers:AddButton({Text = 'Travel to First Sea', Func = function()
	ReplicatedStorage.Remotes.CommF_:InvokeServer('TravelMain')
end})

Servers:AddButton({Text = 'Travel to Second Sea', Func = function()
	ReplicatedStorage.Remotes.CommF_:InvokeServer('TravelDressrosa')
end})

Servers:AddButton({Text = 'Travel to Third Sea', Func = function()
	ReplicatedStorage.Remotes.CommF_:InvokeServer('TravelZou')
end})

Servers:AddButton({Text = 'Server Hop', Func = function()
	-- infinite yield server hop ofc
	local PlaceId = game.PlaceId
	local JobId = game.JobId
	local HttpService = game:GetService('HttpService')
	local HttpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
	
	if HttpRequest then
		local servers = {}
		local req = HttpRequest({Url = string.format('https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true', PlaceId)})
		local body = HttpService:JSONDecode(req.Body)
		
		if body and body.data then
			for i, v in next, body.data do
				if type(v) == 'table' and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= JobId then
					table.insert(servers, 1, v.id)
				end
			end
		end
		
		if #servers > 0 then
			TeleportService:TeleportToPlaceInstance(PlaceId, servers[math.random(1, #servers)], Player)
		else
			StarterGui:SetCore('SendNotification', {
				Title = 'Server Hop',
				Text = 'Could not find a server to join.',
				Duration = 5,
			})
		end
	end
end})

Servers:AddButton({Text = 'Rejoin', Func = function()
	local PlaceId = game.PlaceId
	local JobId = game.JobId
	TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Player)
end})


-- Scripts Groupbox
local Scripts = Tabs.Main:AddRightGroupbox('Scripts')

Scripts:AddButton({Text = 'Infinite Yield', Func = function()
	loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end})

Scripts:AddButton({Text = 'Dex Explorer', Func = function()
	loadstring(game:HttpGet('https://raw.githubusercontent.com/infyiff/backup/main/dex.lua'))()
end})

Scripts:AddButton({Text = 'Remote Spy', Func = function()
	loadstring(game:HttpGet('https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua'))()
end})

-- Local Player Tab
local LocalPlayerGroupBox = Tabs.Player:AddLeftGroupbox('Local Player')

local Humanoid = Player.Character.Humanoid
local HumanoidRootPart = Player.Character.HumanoidRootPart

Player.CharacterAdded:Connect(function(plr)
	local Humanoid = plr:WaitForChild('Humanoid')
	local HumanoidRootPart = plr:WaitForChild('HumanoidRootPart')
	print('Line 514' .. plr .. Humanoid .. HumanoidRootPart)
end)

LocalPlayerGroupBox:AddDropdown('Team', {Values = {'Pirates', 'Marines'}, Default = SelectedTeam, Multi = false, Text = 'Team', Callback = function(Value) end})
Options.Team:OnChanged(function()
	SelectedTeam = Options.Team.Value
end)

LocalPlayerGroupBox:AddButton({Text = 'Change Team', Func = function()
	if SelectedTeam == 'Pirates' then
		ReplicatedStorage.Remotes.CommF_:InvokeServer('SetTeam', 'Pirates')
	elseif SelectedTeam == 'Marines' then
		ReplicatedStorage.Remotes.CommF_:InvokeServer('SetTeam', 'Marines')
	end
end})

LocalPlayerGroupBox:AddToggle('InfiniteEnergy', {Text = 'Unlimited Energy', Default = false, Callback = function(Value) end})
LocalPlayerGroupBox:AddToggle('InfiniteGeppo', {Text = 'Unlimited Air Jumps', Default = false, Callback = function(Value) end})
LocalPlayerGroupBox:AddToggle('ChangeDashLength', {Text = 'Change Dash Length', Default = false, Callback = function(Value) end})
LocalPlayerGroupBox:AddToggle('ChangeSpeedHack', {Text = 'Change WalkSpeed', Default = false, Callback = function(Value) end})
LocalPlayerGroupBox:AddToggle('ChangeJumpHack', {Text = 'Change JumpPower', Default = false, Callback = function(Value) end})

local DefaultDash = Player.Character:GetAttribute('DashLength')

local DashDepbox = LocalPlayerGroupBox:AddDependencyBox()
DashDepbox:AddSlider('DashLength', {Text = 'Dash Length', Default = DefaultDash, Min = 0, Max = 500, Rounding = 0, Compact = false, Callback = function(Value) end})
Options.DashLength:OnChanged(function()
	Player.Character:SetAttribute('DashLength', Options.DashLength.Value)
	Player.Character:SetAttribute('DashLengthAir', Options.DashLength.Value)
end)

local SpeedDepbox = LocalPlayerGroupBox:AddDependencyBox()
SpeedDepbox:AddSlider('SpeedHack', {Text = 'WalkSpeed', Default = Humanoid.WalkSpeed, Min = 0, Max = 400, Rounding = 0, Compact = false, Callback = function(Value) end})

local JumpDepbox = LocalPlayerGroupBox:AddDependencyBox()
JumpDepbox:AddSlider('JumpHack', {Text = 'JumpPower', Default = Humanoid.JumpPower, Min = 0, Max = 800, Rounding = 0, Compact = false, Callback = function(Value) end})

DashDepbox:SetupDependencies({
	{ Toggles.ChangeDashLength, true }
})
SpeedDepbox:SetupDependencies({
	{ Toggles.ChangeSpeedHack, true }
})
JumpDepbox:SetupDependencies({
	{ Toggles.ChangeJumpHack, true }
})

-- Initializing the default values
local dKenRange = Player:WaitForChild('VisionRadius').Value
local ZoomInit = Player.CameraMaxZoomDistance
print('Line 614' .. dKenRange, ZoomInit)

local originalLighting = {}
local dFogStart = Lighting.FogStart
local dFogEnd = Lighting.FogEnd
for i, v in pairs(Lighting:GetDescendants()) do
	if v:IsA('Atmosphere') then
		table.insert(originalLighting, v:Clone())
	end
end

LocalPlayerGroupBox:AddToggle('RemoveFlashstepCooldown', {Text = 'Remove Flashstep Cooldown', Default = true, Callback = function(Value) end})
LocalPlayerGroupBox:AddToggle('UnlimitedVision', {Text = 'Unlimited Instinct Range', Default = true, Callback = function(Value) end})
LocalPlayerGroupBox:AddToggle('DelKenBlur', {Text = 'Remove Instinct Blur', Default = true, Callback = function(Value) end})
LocalPlayerGroupBox:AddToggle('AutoRaceAbility', {Text = 'Auto Race V3', Default = true, Callback = function(Value) end})
LocalPlayerGroupBox:AddToggle('UnlimitedZoom', {Text = 'Zoom Distance', Default = true, Callback = function(Value) end})
LocalPlayerGroupBox:AddToggle('AutoInstinct', {Text = 'Auto Instinct', Default = true, Callback = function(Value) end})
LocalPlayerGroupBox:AddToggle('NoclipCam', {Text = 'Noclip Camera', Default = true, Callback = function(Value) end})
LocalPlayerGroupBox:AddToggle('DeleteFog', {Text = 'Remove Fog', Default = true, Callback =  function(Value) end})
LocalPlayerGroupBox:AddToggle('AutoAura', {Text = 'Auto Aura', Default = true, Callback = function(Value) end})
LocalPlayerGroupBox:AddToggle('Noclip', {Text = 'Noclip', Default = false, Callback = function(Value) end})

spawn(function() -- start of update
	while wait(0.1) do
		-- Auto Aura
		if Toggles.AutoAura.Value then
			local HasBuso = Player.Character:FindFirstChild('HasBuso')
			if not HasBuso then
				ReplicatedStorage.Remotes.CommF_:InvokeServer('Buso')
			end
		end

		-- Auto Instinct
		if Toggles.AutoInstinct.Value then
			local KenActive = Player:GetAttribute('KenActive')
			if not KenActive then
				VirtualInputManager:SendKeyEvent(true, "E", false, game)
				wait()
				VirtualInputManager:SendKeyEvent(false, "E", false, game)
			end
		end

		-- Auto Race V3
		if Toggles.AutoRaceAbility.Value then
			VirtualInputManager:SendKeyEvent(true, "T", false, game)
			wait()
			VirtualInputManager:SendKeyEvent(false, "T", false, game)
		end

		-- Unlimited Ken
		if Toggles.UnlimitedVision.Value then
			Player.VisionRadius.Value = math.huge
		else
			Player.VisionRadius.Value = dKenRange
		end

		-- Flashstep Cooldown
		if Toggles.RemoveFlashstepCooldown.Value then
			Player.Character:SetAttribute('FlashstepCooldown', 1)
		else
			Player.Character:SetAttribute('FlashstepCooldown', 0)
		end
		-- Noclip Camera
		if Toggles.NoclipCam.Value then
			Player.DevCameraOcclusionMode = 'Invisicam'
		else
			Player.DevCameraOcclusionMode = 'Zoom'
		end

		-- Unlimited Zoom
		if Toggles.UnlimitedZoom.Value then
			Player.CameraMaxZoomDistance = math.huge
		else
			Player.CameraMaxZoomDistance = ZoomInit
		end

		-- Remove Fog
		if Toggles.DeleteFog.Value then
			Lighting.FogStart = math.huge
			Lighting.FogEnd = math.huge
		
			for i, v in pairs(Lighting:GetDescendants()) do
				if v:IsA('Atmosphere') then
					v:Destroy()
				end
			end
		-- else -- restore fog
		--     Lighting.FogStart = dFogStart
		--     Lighting.FogEnd = dFogEnd
		--     for i, v in pairs(originalLighting) do
		--         v.Parent = Lighting
		--     end
		--     break -- exit the loop if toggle is disabled
		-- end
		-- wait()
		end

		-- Remove Instinct Blur
		if Toggles.DelKenBlur.Value then
			Lighting.Blur.Enabled = false
			for i, v in pairs(Lighting:GetChildren()) do
				if v:IsA('ColorCorrectionEffect') then
					v.Enabled = false
				end
			end
		end -- ken blur restores itself

		-- Noclip
		if Toggles.Noclip.Value then
			for _, v in pairs(Player.Character:GetDescendants()) do
				if v:IsA("BasePart") and v.CanCollide == true then
					v.CanCollide = false
				end
			end
		else
			for _, v in pairs(Player.Character:GetDescendants()) do
				if v:IsA('BasePart') and v.CanCollide == false then
					v.CanCollide = true
				end
			end
		end
	end -- end of update

	if Toggles.InfiniteGeppo.Value then
		pcall(function()
			for _, func in next, getgc(true) do
				if type(func) == 'function' and getfenv(func).script == Player.Character:FindFirstChild('Geppo') then
					for index, upvalue in next, getupvalues(func) do
						if type(upvalue) == 'number' and upvalue == 0 then
							setupvalue(func, index, 0)
						end
					end
				end
			end
		end)
	end
	
	if Toggles.InfiniteEnergy.Value then
		local Energy = Player.Character:FindFirstChild('Energy')
		if Energy then
			Energy.Value = Energy.MaxValue
		end
	end
end)

LocalPlayerGroupBox:AddToggle('WalkOnWater', {Text = 'Walk on Water', Default = true, Callback = function(Value) end})
Toggles.WalkOnWater:OnChanged(function()
	if Toggles.WalkOnWater.Value then
		workspace.Map['WaterBase-Plane'].Size = Vector3.new(1000,112,1000)
	else
		workspace.Map['WaterBase-Plane'].Size = Vector3.new(1000,80,1000)
	end
end)


print('got past local player tab 😰')

-- Auto Farm Tab
local function CheckLevel()
	local Lv = Player.Data.Level.Value
	if First_Sea then
		if Lv == 1 or Lv <= 9 or SelectedMonster == "Bandit [Lv. 5]" then
			EnemyName = "Bandit"
			NameQuest = "BanditQuest1"
			QuestLv = 1
			NameMon = "Bandit"
			CFrameQuest = CFrame.new(1060, 16, 1547)
			CFrameMonster = CFrame.new(1038, 41, 1576)
		elseif Lv == 10 or Lv <= 14 or SelectedMonster == "Monkey [Lv. 14]" then
			EnemyName = "Monkey"
			NameQuest = "JungleQuest"
			QuestLv = 1
			NameMon = "Monkey"
			CFrameQuest = CFrame.new(-1601, 36, 153)
			CFrameMonster = CFrame.new(-1448, 50, 63)
		elseif Lv == 15 or Lv <= 29 or SelectedMonster == "Gorilla [Lv. 20]" then
			EnemyName = "Gorilla"
			NameQuest = "JungleQuest"
			QuestLv = 2
			NameMon = "Gorilla"
			CFrameQuest = CFrame.new(-1601, 36, 153)
			CFrameMonster = CFrame.new(-1142, 40, -515)
		elseif Lv == 30 or Lv <= 39 or SelectedMonster == "Pirate [Lv. 35]" then
			EnemyName = "Pirate"
			NameQuest = "BuggyQuest1"
			QuestLv = 1
			NameMon = "Pirate"
			CFrameQuest = CFrame.new(-1140, 4, 3827)
			CFrameMonster = CFrame.new(-1201, 40, 3857)
		elseif Lv == 40 or Lv <= 59 or SelectedMonster == "Brute [Lv. 45]" then
			EnemyName = "Brute"
			NameQuest = "BuggyQuest1"
			QuestLv = 2
			NameMon = "Brute"
			CFrameQuest = CFrame.new(-1140, 4, 3827)
			CFrameMonster = CFrame.new(-1387, 24, 4100)
		elseif Lv == 60 or Lv <= 74 or SelectedMonster == "Desert Bandit [Lv. 60]" then
			EnemyName = "Desert Bandit"
			NameQuest = "DesertQuest"
			QuestLv = 1
			NameMon = "Desert Bandit"
			CFrameQuest = CFrame.new(896, 6, 4390)
			CFrameMonster = CFrame.new(984, 16, 4417)
		elseif Lv == 75 or Lv <= 89 or SelectedMonster == "Desert Officer [Lv. 70]" then
			EnemyName = "Desert Officer"
			NameQuest = "DesertQuest"
			QuestLv = 2
			NameMon = "Desert Officer"
			CFrameQuest = CFrame.new(896, 6, 4390)
			CFrameMonster = CFrame.new(1547, 14, 4381)
		elseif Lv == 90 or Lv <= 99 or SelectedMonster == "Snow Bandit [Lv. 90]" then
			EnemyName = "Snow Bandit"
			NameQuest = "SnowQuest"
			QuestLv = 1
			NameMon = "Snow Bandit"
			CFrameQuest = CFrame.new(1386, 87, -1298)
			CFrameMonster = CFrame.new(1356, 105, -1328)
		elseif Lv == 100 or Lv <= 119 or SelectedMonster == "Snowman [Lv. 100]" then
			EnemyName = "Snowman"
			NameQuest = "SnowQuest"
			QuestLv = 2
			NameMon = "Snowman"
			CFrameQuest = CFrame.new(1386, 87, -1298)
			CFrameMonster = CFrame.new(1218, 138, -1488)
		elseif Lv == 120 or Lv <= 149 or SelectedMonster == "Chief Petty Officer [Lv. 120]" then
			EnemyName = "Chief Petty Officer"
			NameQuest = "MarineQuest2"
			QuestLv = 1
			NameMon = "Chief Petty Officer"
			CFrameQuest = CFrame.new(-5035, 28, 4324)
			CFrameMonster = CFrame.new(-4931, 65, 4121)
		elseif Lv == 150 or Lv <= 174 or SelectedMonster == "Sky Bandit [Lv. 150]" then
			EnemyName = "Sky Bandit"
			NameQuest = "SkyQuest"
			QuestLv = 1
			NameMon = "Sky Bandit"
			CFrameQuest = CFrame.new(-4842, 717, -2623)
			CFrameMonster = CFrame.new(-4955, 365, -2908)
		elseif Lv == 175 or Lv <= 189 or SelectedMonster == "Dark Master [Lv. 175]" then
			EnemyName = "Dark Master"
			NameQuest = "SkyQuest"
			QuestLv = 2
			NameMon = "Dark Master"
			CFrameQuest = CFrame.new(-4842, 717, -2623)
			CFrameMonster = CFrame.new(-5148, 439, -2332)
		elseif Lv == 190 or Lv <= 209 or SelectedMonster == "Prisoner [Lv. 190]" then
			EnemyName = "Prisoner"
			NameQuest = "PrisonerQuest"
			QuestLv = 1
			NameMon = "Prisoner"
			CFrameQuest = CFrame.new(5310, 0, 474)
			CFrameMonster = CFrame.new(4937, 0, 649)
		elseif Lv == 210 or Lv <= 249 or SelectedMonster == "Dangerous Prisoner [Lv. 210]" then
			EnemyName = "Dangerous Prisoner"
			NameQuest = "PrisonerQuest"
			QuestLv = 2
			NameMon = "Dangerous Prisoner"
			CFrameQuest = CFrame.new(5310, 0, 474)
			CFrameMonster = CFrame.new(5099, 0, 1055)
		elseif Lv == 250 or Lv <= 274 or SelectedMonster == "Toga Warrior [Lv. 250]" then
			EnemyName = "Toga Warrior"
			NameQuest = "ColosseumQuest"
			QuestLv = 1
			NameMon = "Toga Warrior"
			CFrameQuest = CFrame.new(-1577, 7, -2984)
			CFrameMonster = CFrame.new(-1872, 49, -2913)
		elseif Lv == 275 or Lv <= 299 or SelectedMonster == "Gladiator [Lv. 275]" then
			EnemyName = "Gladiator"
			NameQuest = "ColosseumQuest"
			QuestLv = 2
			NameMon = "Gladiator"
			CFrameQuest = CFrame.new(-1577, 7, -2984)
			CFrameMonster = CFrame.new(-1521, 81, -3066)
		elseif Lv == 300 or Lv <= 324 or SelectedMonster == "Military Soldier [Lv. 300]" then
			EnemyName = "Military Soldier"
			NameQuest = "MagmaQuest"
			QuestLv = 1
			NameMon = "Military Soldier"
			CFrameQuest = CFrame.new(-5316, 12, 8517)
			CFrameMonster = CFrame.new(-5369, 61, 8556)
		elseif Lv == 325 or Lv <= 374 or SelectedMonster == "Military Spy [Lv. 325]" then
			EnemyName = "Military Spy"
			NameQuest = "MagmaQuest"
			QuestLv = 2
			NameMon = "Military Spy"
			CFrameQuest = CFrame.new(-5316, 12, 8517)
			CFrameMonster = CFrame.new(-5787, 75, 8651)
		elseif Lv == 375 or Lv <= 399 or SelectedMonster == "Fishman Warrior [Lv. 375]" then
			EnemyName = "Fishman Warrior"
			NameQuest = "FishmanQuest"
			QuestLv = 1
			NameMon = "Fishman Warrior"
			CFrameQuest = CFrame.new(61122, 18, 1569)
			CFrameMonster = CFrame.new(60844, 98, 1298)
			if (LevelFarmQuest or LevelFarmNoQuest or SelectMonster_Quest_Farm or SelectMonster_NoQuest_Farm or DevilMastery_Farm) and (CFrameMonster.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 3000 then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163, 11, 1819))
			end
		elseif Lv == 400 or Lv <= 449 or SelectedMonster == "Fishman Commando [Lv. 400]" then
			EnemyName = "Fishman Commando"
			NameQuest = "FishmanQuest"
			QuestLv = 2
			NameMon = "Fishman Commando"
			CFrameQuest = CFrame.new(61122, 18, 1569)
			CFrameMonster = CFrame.new(61738, 64, 1433)
			if (LevelFarmQuest or LevelFarmNoQuest or SelectMonster_Quest_Farm or SelectMonster_NoQuest_Farm or DevilMastery_Farm) and (CFrameMonster.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 3000 then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163, 11, 1819))
			end
		elseif Lv == 450 or Lv <= 474 or SelectedMonster == "God's Guard [Lv. 450]" then
			EnemyName = "God's Guard"
			NameQuest = "SkyExp1Quest"
			QuestLv = 1
			NameMon = "God's Guard"
			CFrameQuest = CFrame.new(-4721, 845, -1953)
			CFrameMonster = CFrame.new(-4628, 866, -1931)
			if (LevelFarmQuest or LevelFarmNoQuest or SelectMonster_Quest_Farm or SelectMonster_NoQuest_Farm or DevilMastery_Farm) and (CFrameMonster.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 3000 then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-4607, 872, -1667))
			end
		elseif Lv == 475 or Lv <= 524 or SelectedMonster == "Shanda [Lv. 475]" then
			EnemyName = "Shanda"
			NameQuest = "SkyExp1Quest"
			QuestLv = 2
			NameMon = "Shanda"
			CFrameQuest = CFrame.new(-7863, 5545, -378)
			CFrameMonster = CFrame.new(-7685, 5601, -441)
			if (LevelFarmQuest or LevelFarmNoQuest or SelectMonster_Quest_Farm or SelectMonster_NoQuest_Farm or DevilMastery_Farm) and (CFrameMonster.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 3000 then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-7894, 5547, -380))
			end
		elseif Lv == 525 or Lv <= 549 or SelectedMonster == "Royal Squad [Lv. 525]" then
			EnemyName = "Royal Squad"
			NameQuest = "SkyExp2Quest"
			QuestLv = 1
			NameMon = "Royal Squad"
			CFrameQuest = CFrame.new(-7903, 5635, -1410)
			CFrameMonster = CFrame.new(-7654, 5637, -1407)
		elseif Lv == 550 or Lv <= 624 or SelectedMonster == "Royal Soldier [Lv. 550]" then
			EnemyName = "Royal Soldier"
			NameQuest = "SkyExp2Quest"
			QuestLv = 2
			NameMon = "Royal Soldier"
			CFrameQuest = CFrame.new(-7903, 5635, -1410)
			CFrameMonster = CFrame.new(-7760, 5679, -1884)
		elseif Lv == 625 or Lv <= 649 or SelectedMonster == "Galley Pirate [Lv. 625]" then
			EnemyName = "Galley Pirate"
			NameQuest = "FountainQuest"
			QuestLv = 1
			NameMon = "Galley Pirate"
			CFrameQuest = CFrame.new(5258, 38, 4050)
			CFrameMonster = CFrame.new(5557, 152, 3998)
		elseif Lv >= 650 or SelectedMonster == "Galley Captain [Lv. 650]" then
			EnemyName = "Galley Captain"
			NameQuest = "FountainQuest"
			QuestLv = 2
			NameMon = "Galley Captain"
			CFrameQuest = CFrame.new(5258, 38, 4050)
			CFrameMonster = CFrame.new(5677, 92, 4966)
		end
	end
	if Second_Sea then
		if Lv == 700 or Lv <= 724 or SelectedMonster == "Raider [Lv. 700]" then
			EnemyName = "Raider"
			NameQuest = "Area1Quest"
			QuestLv = 1
			NameMon = "Raider"
			CFrameQuest = CFrame.new(-427, 72, 1835)
			CFrameMonster = CFrame.new(68, 93, 2429)
		elseif Lv == 725 or Lv <= 774 or SelectedMonster == "Mercenary [Lv. 725]" then
			EnemyName = "Mercenary"
			NameQuest = "Area1Quest"
			QuestLv = 2
			NameMon = "Mercenary"
			CFrameQuest = CFrame.new(-427, 72, 1835)
			CFrameMonster = CFrame.new(-864, 122, 1453)
		elseif Lv == 775 or Lv <= 799 or SelectedMonster == "Swan Pirate [Lv. 775]" then
			EnemyName = "Swan Pirate"
			NameQuest = "Area2Quest"
			QuestLv = 1
			NameMon = "Swan Pirate"
			CFrameQuest = CFrame.new(635, 73, 917)
			CFrameMonster = CFrame.new(1065, 137, 1324)
		elseif Lv == 800 or Lv <= 874 or SelectedMonster == "Factory Staff [Lv. 800]" then
			EnemyName = "Factory Staff"
			NameQuest = "Area2Quest"
			QuestLv = 2
			NameMon = "Factory Staff"
			CFrameQuest = CFrame.new(635, 73, 917)
			CFrameMonster = CFrame.new(533, 128, 355)
		elseif Lv == 875 or Lv <= 899 or SelectedMonster == "Marine Lieutenant [Lv. 875]" then
			EnemyName = "Marine Lieutenant"
			NameQuest = "MarineQuest3"
			QuestLv = 1
			NameMon = "Marine Lieutenant"
			CFrameQuest = CFrame.new(-2440, 73, -3217)
			CFrameMonster = CFrame.new(-2489, 84, -3151)
		elseif Lv == 900 or Lv <= 949 or SelectedMonster == "Marine Captain [Lv. 900]" then
			EnemyName = "Marine Captain"
			NameQuest = "MarineQuest3"
			QuestLv = 2
			NameMon = "Marine Captain"
			CFrameQuest = CFrame.new(-2440, 73, -3217)
			CFrameMonster = CFrame.new(-2335, 79, -3245)
		elseif Lv == 950 or Lv <= 974 or SelectedMonster == "Zombie [Lv. 950]" then
			EnemyName = "Zombie"
			NameQuest = "ZombieQuest"
			QuestLv = 1
			NameMon = "Zombie"
			CFrameQuest = CFrame.new(-5494, 48, -794)
			CFrameMonster = CFrame.new(-5536, 101, -835)
		elseif Lv == 975 or Lv <= 999 or SelectedMonster == "Vampire [Lv. 975]" then
			EnemyName = "Vampire"
			NameQuest = "ZombieQuest"
			QuestLv = 2
			NameMon = "Vampire"
			CFrameQuest = CFrame.new(-5494, 48, -794)
			CFrameMonster = CFrame.new(-5806, 16, -1164)
		elseif Lv == 1000 or Lv <= 1049 or SelectedMonster == "Snow Trooper [Lv. 1000]" then
			EnemyName = "Snow Trooper"
			NameQuest = "SnowMountainQuest"
			QuestLv = 1
			NameMon = "Snow Trooper"
			CFrameQuest = CFrame.new(607, 401, -5370)
			CFrameMonster = CFrame.new(535, 432, -5484)
		elseif Lv == 1050 or Lv <= 1099 or SelectedMonster == "Winter Warrior [Lv. 1050]" then
			EnemyName = "Winter Warrior"
			NameQuest = "SnowMountainQuest"
			QuestLv = 2
			NameMon = "Winter Warrior"
			CFrameQuest = CFrame.new(607, 401, -5370)
			CFrameMonster = CFrame.new(1234, 456, -5174)
		elseif Lv == 1100 or Lv <= 1124 or SelectedMonster == "Lab Subordinate [Lv. 1100]" then
			EnemyName = "Lab Subordinate"
			NameQuest = "IceSideQuest"
			QuestLv = 1
			NameMon = "Lab Subordinate"
			CFrameQuest = CFrame.new(-6061, 15, -4902)
			CFrameMonster = CFrame.new(-5720, 63, -4784)
		elseif Lv == 1125 or Lv <= 1174 or SelectedMonster == "Horned Warrior [Lv. 1125]" then
			EnemyName = "Horned Warrior"
			NameQuest = "IceSideQuest"
			QuestLv = 2
			NameMon = "Horned Warrior"
			CFrameQuest = CFrame.new(-6061, 15, -4902)
			CFrameMonster = CFrame.new(-6292, 91, -5502)
		elseif Lv == 1175 or Lv <= 1199 or SelectedMonster == "Magma Ninja [Lv. 1175]" then
			EnemyName = "Magma Ninja"
			NameQuest = "FireSideQuest"
			QuestLv = 1
			NameMon = "Magma Ninja"
			CFrameQuest = CFrame.new(-5429, 15, -5297)
			CFrameMonster = CFrame.new(-5461, 130, -5836)
		elseif Lv == 1200 or Lv <= 1249 or SelectedMonster == "Lava Pirate [Lv. 1200]" then
			EnemyName = "Lava Pirate"
			NameQuest = "FireSideQuest"
			QuestLv = 2
			NameMon = "Lava Pirate"
			CFrameQuest = CFrame.new(-5429, 15, -5297)
			CFrameMonster = CFrame.new(-5251, 55, -4774)
		elseif Lv == 1250 or Lv <= 1274 or SelectedMonster == "Ship Deckhand [Lv. 1250]" then
			EnemyName = "Ship Deckhand"
			NameQuest = "ShipQuest1"
			QuestLv = 1
			NameMon = "Ship Deckhand"
			CFrameQuest = CFrame.new(1040, 125, 32911)
			CFrameMonster = CFrame.new(921, 125, 33088)
			if (LevelFarmQuest or LevelFarmNoQuest or SelectMonster_Quest_Farm or SelectMonster_NoQuest_Farm or DevilMastery_Farm) and (CFrameMonster.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000 then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923, 126, 32852))
			end
		elseif Lv == 1275 or Lv <= 1299 or SelectedMonster == "Ship Engineer [Lv. 1275]" then
			EnemyName = "Ship Engineer"
			NameQuest = "ShipQuest1"
			QuestLv = 2
			NameMon = "Ship Engineer"
			CFrameQuest = CFrame.new(1040, 125, 32911)
			CFrameMonster = CFrame.new(886, 40, 32800)
			if (LevelFarmQuest or LevelFarmNoQuest or SelectMonster_Quest_Farm or SelectMonster_NoQuest_Farm or DevilMastery_Farm) and (CFrameMonster.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000 then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923, 126, 32852))
			end
		elseif Lv == 1300 or Lv <= 1324 or SelectedMonster == "Ship Steward [Lv. 1300]" then
			EnemyName = "Ship Steward"
			NameQuest = "ShipQuest2"
			QuestLv = 1
			NameMon = "Ship Steward"
			CFrameQuest = CFrame.new(971, 125, 33245)
			CFrameMonster = CFrame.new(943, 129, 33444)
			if (LevelFarmQuest or LevelFarmNoQuest or SelectMonster_Quest_Farm or SelectMonster_NoQuest_Farm or DevilMastery_Farm) and (CFrameMonster.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000 then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923, 126, 32852))
			end
		elseif Lv == 1325 or Lv <= 1349 or SelectedMonster == "Ship Officer [Lv. 1325]" then
			EnemyName = "Ship Officer"
			NameQuest = "ShipQuest2"
			QuestLv = 2
			NameMon = "Ship Officer"
			CFrameQuest = CFrame.new(971, 125, 33245)
			CFrameMonster = CFrame.new(955, 181, 33331)
			if (LevelFarmQuest or LevelFarmNoQuest or SelectMonster_Quest_Farm or SelectMonster_NoQuest_Farm or DevilMastery_Farm) and (CFrameMonster.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000 then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923, 126, 32852))
			end
		elseif Lv == 1350 or Lv <= 1374 or SelectedMonster == "Arctic Warrior [Lv. 1350]" then
			EnemyName = "Arctic Warrior"
			NameQuest = "FrostQuest"
			QuestLv = 1
			NameMon = "Arctic Warrior"
			CFrameQuest = CFrame.new(5668, 28, -6484)
			CFrameMonster = CFrame.new(5935, 77, -6472)
			if (LevelFarmQuest or LevelFarmNoQuest or SelectMonster_Quest_Farm or SelectMonster_NoQuest_Farm or DevilMastery_Farm) and (CFrameMonster.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 20000 then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-6508, 89, -132))
			end
		elseif Lv == 1375 or Lv <= 1424 or SelectedMonster == "Snow Lurker [Lv. 1375]" then
			EnemyName = "Snow Lurker"
			NameQuest = "FrostQuest"
			QuestLv = 2
			NameMon = "Snow Lurker"
			CFrameQuest = CFrame.new(5668, 28, -6484)
			CFrameMonster = CFrame.new(5628, 57, -6618)
		elseif Lv == 1425 or Lv <= 1449 or SelectedMonster == "Sea Soldier [Lv. 1425]" then
			EnemyName = "Sea Soldier"
			NameQuest = "ForgottenQuest"
			QuestLv = 1
			NameMon = "Sea Soldier"
			CFrameQuest = CFrame.new(-3054, 236, -10147)
			CFrameMonster = CFrame.new(-3185, 58, -9663)
		elseif Lv >= 1450 or SelectedMonster == "Water Fighter [Lv. 1450]" then
			EnemyName = "Water Fighter"
			NameQuest = "ForgottenQuest"
			QuestLv = 2
			NameMon = "Water Fighter"
			CFrameQuest = CFrame.new(-3054, 236, -10147)
			CFrameMonster = CFrame.new(-3262, 298, -10552)
		end
	end
	if Third_Sea then
		if Lv == 1500 or Lv <= 1524 or SelectedMonster == "Pirate Millionaire [Lv. 1500]" then
			EnemyName = "Pirate Millionaire"
			NameQuest = "PiratePortQuest"
			QuestLv = 1
			NameMon = "Pirate Millionaire"
			CFrameQuest = CFrame.new(-289, 43, 5580)
			CFrameMonster = CFrame.new(-435, 189, 5551)
		elseif Lv == 1525 or Lv <= 1574 or SelectedMonster == "Pistol Billionaire [Lv. 1525]" then
			EnemyName = "Pistol Billionaire"
			NameQuest = "PiratePortQuest"
			QuestLv = 2
			NameMon = "Pistol Billionaire"
			CFrameQuest = CFrame.new(-289, 43, 5580)
			CFrameMonster = CFrame.new(-236, 217, 6006)
		elseif Lv == 1575 or Lv <= 1599 or SelectedMonster == "Dragon Crew Warrior [Lv. 1575]" then
			EnemyName = "Dragon Crew Warrior"
			NameQuest = "DragonCrewQuest"
			QuestLv = 1
			NameMon = "Dragon Crew Warrior"
			CFrameQuest = CFrame.new(6735, 126, -711)
			CFrameMonster = CFrame.new(6301, 104, -1082)
		elseif Lv == 1600 or Lv <= 1624 or SelectedMonster == "Dragon Crew Archer [Lv. 1600]" then
			EnemyName = "Dragon Crew Archer"
			NameQuest = "DragonCrewQuest"
			QuestLv = 2
			NameMon = "Dragon Crew Archer"
			CFrameQuest = CFrame.new(6735, 126, -711)
			CFrameMonster = CFrame.new(6831, 441, 446)
		elseif Lv == 1625 or Lv <= 1649 or SelectedMonster == "Hydra Enforcer [Lv. 1625]" then
			EnemyName = "Hydra Enforcer"
			NameQuest = "VenomCrewQuest"
			QuestLv = 1
			NameMon = "Hydra Enforcer"
			CFrameQuest = CFrame.new(5214, 1003, 759)
			CFrameMonster = CFrame.new(5195, 1089, 617)
		elseif Lv == 1650 or Lv <= 1699 or SelectedMonster == "Venomous Assailant [Lv. 1650]" then
			EnemyName = "Venomous Assailant"
			NameQuest = "VenomCrewQuest"
			QuestLv = 2
			NameMon = "Venomous Assailant"
			CFrameQuest = CFrame.new(5214, 1003, 759)
			CFrameMonster = CFrame.new(5195, 1089, 617)
		elseif Lv == 1700 or Lv <= 1724 or SelectedMonster == "Marine Commodore [Lv. 1700]" then
			EnemyName = "Marine Commodore"
			NameQuest = "MarineTreeIsland"
			QuestLv = 1
			NameMon = "Marine Commodore"
			CFrameQuest = CFrame.new(2179, 28, -6740)
			CFrameMonster = CFrame.new(2198, 128, -7109)
		elseif Lv == 1725 or Lv <= 1774 or SelectedMonster == "Marine Rear Admiral [Lv. 1725]" then
			EnemyName = "Marine Rear Admiral"
			NameQuest = "MarineTreeIsland"
			QuestLv = 2
			NameMon = "Marine Rear Admiral"
			CFrameQuest = CFrame.new(2179, 28, -6740)
			CFrameMonster = CFrame.new(3294, 385, -7048)
		elseif Lv == 1775 or Lv <= 1799 or SelectedMonster == "Fishman Raider [Lv. 1775]" then
			EnemyName = "Fishman Raider"
			NameQuest = "DeepForestIsland3"
			QuestLv = 1
			NameMon = "Fishman Raider"
			CFrameQuest = CFrame.new(-10582, 331, -8757)
			CFrameMonster = CFrame.new(-10553, 521, -8176)
		elseif Lv == 1800 or Lv <= 1824 or SelectedMonster == "Fishman Captain [Lv. 1800]" then
			EnemyName = "Fishman Captain"
			NameQuest = "DeepForestIsland3"
			QuestLv = 2
			NameMon = "Fishman Captain"
			CFrameQuest = CFrame.new(-10583, 331, -8759)
			CFrameMonster = CFrame.new(-10789, 427, -9131)
		elseif Lv == 1825 or Lv <= 1849 or SelectedMonster == "Forest Pirate [Lv. 1825]" then
			EnemyName = "Forest Pirate"
			NameQuest = "DeepForestIsland"
			QuestLv = 1
			NameMon = "Forest Pirate"
			CFrameQuest = CFrame.new(-13232, 332, -7626)
			CFrameMonster = CFrame.new(-13489, 400, -7770)
		elseif Lv == 1850 or Lv <= 1899 or SelectedMonster == "Mythological Pirate [Lv. 1850]" then
			EnemyName = "Mythological Pirate"
			NameQuest = "DeepForestIsland"
			QuestLv = 2
			NameMon = "Mythological Pirate"
			CFrameQuest = CFrame.new(-13232, 332, -7626)
			CFrameMonster = CFrame.new(-13508, 582, -6985)
		elseif Lv == 1900 or Lv <= 1924 or SelectedMonster == "Jungle Pirate [Lv. 1900]" then
			EnemyName = "Jungle Pirate"
			NameQuest = "DeepForestIsland2"
			QuestLv = 1
			NameMon = "Jungle Pirate"
			CFrameQuest = CFrame.new(-12682, 390, -9902)
			CFrameMonster = CFrame.new(-12267, 459, -10277)
		elseif Lv == 1925 or Lv <= 1974 or SelectedMonster == "Musketeer Pirate [Lv. 1925]" then
			EnemyName = "Musketeer Pirate"
			NameQuest = "DeepForestIsland2"
			QuestLv = 2
			NameMon = "Musketeer Pirate"
			CFrameQuest = CFrame.new(-12682, 390, -9902)
			CFrameMonster = CFrame.new(-13291, 520, -9904)
		elseif Lv == 1975 or Lv <= 1999 or SelectedMonster == "Reborn Skeleton [Lv. 1975]" then
			EnemyName = "Reborn Skeleton"
			NameQuest = "HauntedQuest1"
			QuestLv = 1
			NameMon = "Reborn Skeleton"
			CFrameQuest = CFrame.new(-9480, 142, 5566)
			CFrameMonster = CFrame.new(-8761, 183, 6168)
		elseif Lv == 2000 or Lv <= 2024 or SelectedMonster == "Living Zombie [Lv. 2000]" then
			EnemyName = "Living Zombie"
			NameQuest = "HauntedQuest1"
			QuestLv = 2
			NameMon = "Living Zombie"
			CFrameQuest = CFrame.new(-9480, 142, 5566)
			CFrameMonster = CFrame.new(-10103, 238, 6179)
		elseif Lv == 2025 or Lv <= 2049 or SelectedMonster == "Demonic Soul [Lv. 2025]" then
			EnemyName = "Demonic Soul"
			NameQuest = "HauntedQuest2"
			QuestLv = 1
			NameMon = "Demonic Soul"
			CFrameQuest = CFrame.new(-9516, 178, 6078)
			CFrameMonster = CFrame.new(-9712, 204, 6193)
		elseif Lv == 2050 or Lv <= 2074 or SelectedMonster == "Posessed Mummy [Lv. 2050]" then
			EnemyName = "Posessed Mummy"
			NameQuest = "HauntedQuest2"
			QuestLv = 2
			NameMon = "Posessed Mummy"
			CFrameQuest = CFrame.new(-9516, 178, 6078)
			CFrameMonster = CFrame.new(-9545, 69, 6339)
		elseif Lv == 2075 or Lv <= 2099 or SelectedMonster == "Peanut Scout [Lv. 2075]" then
			EnemyName = "Peanut Scout"
			NameQuest = "NutsIslandQuest"
			QuestLv = 1
			NameMon = "Peanut Scout"
			CFrameQuest = CFrame.new(-2105, 37, -10195)
			CFrameMonster = CFrame.new(-2150, 122, -10358)
		elseif Lv == 2100 or Lv <= 2124 or SelectedMonster == "Peanut President [Lv. 2100]" then
			EnemyName = "Peanut President"
			NameQuest = "NutsIslandQuest"
			QuestLv = 2
			NameMon = "Peanut President"
			CFrameQuest = CFrame.new(-2105, 37, -10195)
			CFrameMonster = CFrame.new(-2150, 122, -10358)
		elseif Lv == 2125 or Lv <= 2149 or SelectedMonster == "Ice Cream Chef [Lv. 2125]" then
			EnemyName = "Ice Cream Chef"
			NameQuest = "IceCreamIslandQuest"
			QuestLv = 1
			NameMon = "Ice Cream Chef"
			CFrameQuest = CFrame.new(-819, 64, -10967)
			CFrameMonster = CFrame.new(-789, 209, -11009)
		elseif Lv == 2150 or Lv <= 2199 or SelectedMonster == "Ice Cream Commander [Lv. 2150]" then
			EnemyName = "Ice Cream Commander"
			NameQuest = "IceCreamIslandQuest"
			QuestLv = 2
			NameMon = "Ice Cream Commander"
			CFrameQuest = CFrame.new(-819, 64, -10967)
			CFrameMonster = CFrame.new(-789, 209, -11009)
		elseif Lv == 2200 or Lv <= 2224 or SelectedMonster == "Cookie Crafter [Lv. 2200]" then
			EnemyName = "Cookie Crafter"
			NameQuest = "CakeQuest1"
			QuestLv = 1
			NameMon = "Cookie Crafter"
			CFrameQuest = CFrame.new(-2022, 36, -12030)
			CFrameMonster = CFrame.new(-2321, 36, -12216)
		elseif Lv == 2225 or Lv <= 2249 or SelectedMonster == "Cake Guard [Lv. 2225]" then
			EnemyName = "Cake Guard"
			NameQuest = "CakeQuest1"
			QuestLv = 2
			NameMon = "Cake Guard"
			CFrameQuest = CFrame.new(-2022, 36, -12030)
			CFrameMonster = CFrame.new(-1418, 36, -12255)
		elseif Lv == 2250 or Lv <= 2274 or SelectedMonster == "Baking Staff [Lv. 2250]" then
			EnemyName = "Baking Staff"
			NameQuest = "CakeQuest2"
			QuestLv = 1
			NameMon = "Baking Staff"
			CFrameQuest = CFrame.new(-1928, 37, -12840)
			CFrameMonster = CFrame.new(-1980, 36, -12983)
		elseif Lv == 2275 or Lv <= 2299 or SelectedMonster == "Head Baker [Lv. 2275]" then
			EnemyName = "Head Baker"
			NameQuest = "CakeQuest2"
			QuestLv = 2
			NameMon = "Head Baker"
			CFrameQuest = CFrame.new(-1928, 37, -12840)
			CFrameMonster = CFrame.new(-2251, 52, -13033)
		elseif Lv == 2300 or Lv <= 2324 or SelectedMonster == "Cocoa Warrior [Lv. 2300]" then
			EnemyName = "Cocoa Warrior"
			NameQuest ="ChocQuest1"
			QuestLv = 1
			NameMon = "Cocoa Warrior"
			CFrameQuest = CFrame.new(231, 23, -12200)
			CFrameMonster = CFrame.new(167, 26, -12238)
		elseif Lv == 2325 or Lv <= 2349 or SelectedMonster == "Chocolate Bar Battler [Lv. 2325]" then
			EnemyName = "Chocolate Bar Battler"
			NameQuest = "ChocQuest1"
			QuestLv = 2
			NameMon = "Chocolate Bar Battler"
			CFrameQuest = CFrame.new(231, 23, -12200)
			CFrameMonster = CFrame.new(701, 25, -12708)
		elseif Lv == 2350 or Lv <= 2374 or SelectedMonster == "Sweet Thief [Lv. 2350]" then
			EnemyName = "Sweet Thief"
			NameQuest = "ChocQuest2"
			QuestLv = 1
			NameMon = "Sweet Thief"
			CFrameQuest = CFrame.new(151, 23, -12774)
			CFrameMonster = CFrame.new(-140, 25, -12652)
		elseif Lv == 2375 or Lv <= 2400 or SelectedMonster == "Candy Rebel [Lv. 2375]" then
			EnemyName = "Candy Rebel"
			NameQuest = "ChocQuest2"
			QuestLv = 2
			NameMon = "Candy Rebel"
			CFrameQuest = CFrame.new(151, 23, -12774)
			CFrameMonster = CFrame.new(47, 25, -13029)
		elseif Lv == 2400 or Lv <= 2424 or SelectedMonster == "Candy Pirate [Lv. 2400]" then
			EnemyName = "Candy Pirate"
			NameQuest = "CandyQuest1"
			QuestLv = 1
			NameMon = "Candy Pirate"
			CFrameQuest = CFrame.new(-1149, 13, -14445)
			CFrameMonster = CFrame.new(-1437, 17, -14385)
		elseif Lv == 2425 or Lv <= 2449 or SelectedMonster == "Snow Demon [Lv. 2425]" then
			EnemyName = "Snow Demon"
			NameQuest = "CandyQuest1"
			QuestLv = 2
			NameMon = "Snow Demon"
			CFrameQuest = CFrame.new(-1149, 13, -14445)
			CFrameMonster = CFrame.new(-916, 17, -14638)

		elseif Lv == 2450 or Lv <= 2474 or SelectedMonster == "Isle Outlaw [Lv. 2450]" then
			EnemyName = "Isle Outlaw"
			NameQuest = "TikiQuest1"
			QuestLv = 1
			NameMon = "Isle Outlaw"
			CFrameQuest = CFrame.new(-16548, 55, -172)
			CFrameMonster = CFrame.new(-16122, 10, -257)
		elseif Lv == 2475 or Lv <= 2499 or SelectedMonster == "Island Boy [2475]" then
			EnemyName = "Island Boy"
			NameQuest = "TikiQuest1"
			QuestLv = 2
			NameMon = "Island Boy"
			CFrameQuest = CFrame.new(-16548, 55, -172)
			CFrameMonster = CFrame.new(-16736, 20, -131)
		elseif Lv == 2500 or Lv <= 2524 or SelectedMonster == "Sun-kissed Warrior [Lv. 2500]" then
			EnemyName = "Sun-kissed Warrior"
			NameQuest = "TikiQuest2"
			QuestLv = 1
			NameMon = "Sun-"
			CFrameQuest = CFrame.new(-16541, 54, 1051)
			CFrameMonster = CFrame.new(-16413, 54, 1054)
		elseif Lv == 2525 or Lv <= 2549 or SelectedMonster == "Isle Champion [Lv. 2525]" then
			EnemyName = "Isle Champion"
			NameQuest = "TikiQuest2"
			QuestLv = 2
			NameMon = "Isle Champion"
			CFrameQuest = CFrame.new(-16541, 54, 1051)
			CFrameMonster = CFrame.new(-16787, 20, 992)
		elseif Lv == 2550 or Lv <= 2574 or SelectedMonster == "Serpent Hunter [Lv. 2550]" then
			EnemyName = "Serpent Hunter"
			NameQuest = "TikiQuest3"
			QuestLv = 1
			NameMon = "Serpent Hunter"
			CFrameQuest = CFrame.new(-16665, 104, 1579)
			CFrameMonster = CFrame.new(-16654, 105, 1579)
		elseif Lv >= 2575 or SelectedMonster == "Skull Slayer [Lv. 2575]" then
			EnemyName = "Skull Slayer"
			NameQuest = "TikiQuest3"
			QuestLv = 2
			NameMon = "Skull Slayer"
			CFrameQuest = CFrame.new(-16665, 104, 1579)
			CFrameMonster = CFrame.new(-16654, 105, 1579)
		end
	end
end

local AutoFarmSettings = Tabs.AutoFarm:AddLeftGroupbox('Auto Farm Settings')

local WeaponList = {'Melee', 'Blox Fruit', 'Sword', 'Gun'}
AutoFarmSettings:AddDropdown('Weapon', {Values = WeaponList, Default = 1, Multi = false, Text = 'Weapons', Callback = function(Value) end})
Options.Weapon:OnChanged(function()
	SelectWeaponFarm = Options.Weapon.Value
	
	if SelectWeaponFarm == 'Melee' then
		for i, v in pairs(Player.Backpack:GetChildren()) do
			if v.ToolTip == 'Melee' then
				if Player.Backpack:FindFirstChild(tostring(v.Name)) then
					SelectedWeapon = v.Name
				end
			end
		end
	elseif SelectWeaponFarm == 'Sword' then
		for i, v in pairs(Player.Backpack:GetChildren()) do
			if v.ToolTip == 'Sword' then
				if Player.Backpack:FindFirstChild(tostring(v.Name)) then
					SelectedWeapon = v.Name
				end
			end
		end
	elseif SelectWeaponFarm == 'Blox Fruit' then
		for i, v in pairs(Player.Backpack:GetChildren()) do
			if v.ToolTip == 'Blox Fruit' then
				if Player.Backpack:FindFirstChild(tostring(v.Name)) then
					SelectedWeapon = v.Name
				end
			end
		end
	elseif SelectWeaponFarm == 'Gun' then
		for i, v in pairs(Player.Backpack:GetChildren()) do
			if v.ToolTip == 'Gun' then
				if Player.Backpack:FindFirstChild(tostring(v.Name)) then
					SelectedWeapon = v.Name
				end
			end
		end
	end
end)

-- local sethiddenproperty = sethiddenproperty or (function(...) return ... end)
-- v.Humanoid:ChangeState(11)
-- v.Humanoid:ChangeState(14)
-- if v.Humanoid:FindFirstChild('Animator') then
-- v.Humanoid.Animator:Destroy()
local function fBringMob(TargetName, TargetCFrame)
	for i, v in pairs(workspace.Enemies:GetChildren()) do
		if v.Name == TargetName then
			if v:FindFirstChild('Humanoid') and v.Humanoid.Health > 0 then
				if (v.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude < tonumber(BringDis) then
					v.HumanoidRootPart.CFrame = TargetCFrame
					v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
				end
			end
		end
	end
end

AutoFarmSettings:AddToggle('BringMobs', {Text = 'Bring Mobs', Default = false, Callback = function(Value) end})
spawn(function()
	while wait(1) do
		if Toggles.BringMobs.Value and (LevelFarmQuest or LevelFarmNoQuest) then
			pcall(function()
				fBringMob(Level_Farm_Name, Level_Farm_CFrame)
			end)

		elseif Toggles.BringMobs.Value and Farm_Bone then
			pcall(function()
				fBringMob(Bone_Farm_Name, Bone_Farm_CFrame)
			end)

		elseif Toggles.BringMobs.Value and Nearest_Farm then
			pcall(function()
				fBringMob(Nearest_Farm_Name, Nearest_Farm_CFrame)
			end)
		end
	end
end)

AutoFarmSettings:AddSlider('BringRange', {Text = 'Bring Mobs Range', Default = 250, Min = 0, Max = 500, Rounding = 0, Compact = false,Callback = function(Value) end})
Options.BringRange:OnChanged(function()
	BringDis = Options.BringRange.Value
end)

local function EquipTool(Tool)
	Player.Character.Humanoid:EquipTool(Player.Backpack[Tool])
end

local function AutoClick()
	print('Autoclicking (hell nah)')
	VirtualInputManager:Button1Down(Vector2.new(0, 0))
end

local AutoFarm = Tabs.AutoFarm:AddLeftGroupbox('Auto Farm')
AutoFarm:AddToggle('AutoFarmToggle', {Text = 'Auto Farm', Default = false, Callback = function(Value) end})
spawn(function()
	while wait(1) do
		print('AutoFarm Step 1')
		if Toggles.AutoFarmToggle.Value then
			print('AutoFarm Step 2')
			pcall(function()
				print('AutoFarm Step 3')
				CheckLevel()
				if not string.find(Player.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) or Player.PlayerGui.Main.Quest.Visible == false then
					print('AutoFarm Step 4')
					ReplicatedStorage.Remotes.CommF_:InvokeServer("AbandonQuest")
					Tween(CFrameQuest)
					if (CFrameQuest.Position - Player.Character.HumanoidRootPart.Position).Magnitude <= 5 then
						wait(1)
						ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", NameQuest, QuestLv)
					end

				elseif string.find(Player.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) or Player.PlayerGui.Main.Quest.Visible == true then
					if workspace.Enemies:FindFirstChild(EnemyName) then
						for i,v in pairs(workspace.Enemies:GetChildren()) do
							if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
								if v.Name == EnemyName then
									repeat wait()
										EquipTool(SelectWeapon)
										Tween(v.HumanoidRootPart.CFrame)
										v.HumanoidRootPart.CanCollide = false
										v.HumanoidRootPart.Size = Vector3.new(60,60,60)
										-- v.HumanoidRootPart.Transparency = 1
										Level_Farm_Name = v.Name
										Level_Farm_CFrame = v.HumanoidRootPart.CFrame
										AutoClick()
									until not LevelFarmQuest or not v.Parent or v.Humanoid.Health <= 0 or not workspace.Enemies:FindFirstChild(v.Name) or Player.PlayerGui.Main.Quest.Visible == false
								end
							end
						end
					else
						Tween(CFrameMonster)
					end
				end
			end)
		end
	end
end)

AutoFarm:AddToggle('AutoFarmNearestToggle', {Text = 'Auto Farm Nearest', Default = false, Callback = function(Value) end})
spawn(function()
	while wait(1) do
		if Toggles.AutoFarmNearestToggle.Value then
			pcall(function()
				for i,v in pairs (workspace.Enemies:GetChildren()) do
					if v:FindFirstChild('Humanoid') and v:FindFirstChild('HumanoidRootPart') and v.Humanoid.Health > 0 then
						if (Player.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude <= 1000 then
							repeat wait()
								EquipTool(SelectedWeapon)
								Tween(v.HumanoidRootPart.CFrame)
								Nearest_Farm_Name = v.Name
								Nearest_Farm_CFrame = v.HumanoidRootPart.CFrame
								AutoClick()
							until not Nearest_Farm or not v.Parent or v.Humanoid.Health <= 0 or not workspace.Enemies:FindFirstChild(v.Name)
						end
					end
				end
			end)
		end
	end
end)

AutoFarm:AddToggle('BonesFarm', {Text = 'Auto Farm Bones', Default = false, Callback = function(Value) end})
spawn(function()
	while wait(1) do
		if Toggles.BonesFarm.Value then
			pcall(function()
				Tween(CFrame.new(-9508, 142, 5737))
				for i, v in pairs(game.Workspace.Enemies:GetChildren()) do
					if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
						if v.Name == "Reborn Skeleton" or v.Name == "Living Zombie" or v.Name =="Demonic Soul" or v.Name == "Posessed Mummy" then
							repeat game:GetService("RunService").Heartbeat:wait()
								EquipTool(SelectWeapon)
								Tween(v.HumanoidRootPart.CFrame)
								v.HumanoidRootPart.CanCollide = false
								v.HumanoidRootPart.Size = Vector3.new(60,60,60)
								--v.HumanoidRootPart.Transparency = 1
								Bone_Farm_Name = v.Name
								Bone_Farm_CFrame = v.HumanoidRootPart.CFrame
								AutoClick()
							until not Farm_Bone or not v.Parent or v.Humanoid.Health <= 0 or not game.Workspace.Enemies:FindFirstChild(v.Name)
						end
					end
				end

				for i, v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
					if v.Name == "Reborn Skeleton" then
						Tween(v.HumanoidRootPart.CFrame)
					elseif v.Name == "Living Zombie" then
						Tween(v.HumanoidRootPart.CFrame)
					elseif v.Name == "Demonic Soul" then
						Tween(v.HumanoidRootPart.CFrame)
					elseif v.Name == "Posessed Mummy" then
						Tween(v.HumanoidRootPart.CFrame)
					end
				end
			end)
		end
	end
end)

-- Fruits Tab
local Fruits = Tabs.Fruits:AddLeftGroupbox('Fruits')

Fruits:AddToggle('FruitESP', {Text = 'Fruit ESP', Default = true, Callback = function(Value) end})
local function fDist(arg)
	return math.floor(tonumber(arg))
end
local function BloxFruitsESP()
	for i, v in pairs(workspace:GetChildren()) do
		pcall(function()
			if Toggles.FruitESP.Value then
				if string.find(v.Name, "Fruit") then
					if not v.Handle:FindFirstChild("NameEsp" .. Number) then
						local FruitGui = Instance.new("BillboardGui", v.Handle)
						FruitGui.Name = "NameEsp" .. Number;
						FruitGui.ExtentsOffset = Vector3.new(0, 1, 0)
						FruitGui.Size = UDim2.new(1, 200, 1, 30)
						FruitGui.Adornee = v.Handle;
						FruitGui.AlwaysOnTop = true;
						local FruitText = Instance.new("TextLabel", FruitGui)
						--FruitText.Font = "GothamBold"
						--FruitText.FontSize = "Size14"
						FruitText.TextWrapped = true;
						FruitText.Size = UDim2.new(1, 0, 1, 0)
						FruitText.TextYAlignment = "Top"
						FruitText.BackgroundTransparency = 1;
						FruitText.TextStrokeTransparency = 0.5;
						FruitText.TextColor3 = Color3.fromRGB(255, 0, 0)
						FruitText.Text = v.Name .. " \n" .. fDist((game:GetService("Players").LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude / 3) .. " M"
					else
						v.Handle["NameEsp" .. Number].TextLabel.Text = v.Name .. "   \n" .. fDist((game:GetService("Players").LocalPlayer.Character.CFrame.Position - v.Handle.Position).Magnitude) .. " Studs"
					end
				end
			else
				if v.Handle:FindFirstChild("NameEsp" .. Number) then
					v.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
				end
			end
		end)
	end
end;

Fruits:AddToggle('AutoFruit', {Text = 'Auto Collect Fruits', Default = false, Callback = function(Value) end})
spawn(function()
	while wait(1) do
		if Toggles.AutoFruit.Value then
			pcall(function()
				for i,v in pairs(workspace:GetChildren()) do
					if v.Name:find('Fruit') and v:IsA('Tool') then
						v.Handle.CFrame = Player.Character.HumanoidRootPart.CFrame
					end
				end
			end)
		
			pcall(function()
				for i, v in pairs(workspace:GetChildren()) do
					if v.Name:find('Fruit') and v:IsA('Model') then
						if v:FindFirstChild('Handle') and v:FindFirstChild('Fruit') and v:FindFirstChild('Fruit'):IsA('Model') then
							local Fruit = v.Fruit.CFrame
						end
					end
				end
			end)
	
			if Fruit then
				local root = Player.Character:FindFirstChild('HumanoidRootPart')
				local info = TweenInfo.new(((Fruit.Position - root.Position).Magnitude - 150) / tSpeed)
				local t = TweenService:Create(root, info, {CFrame = Fruit})
				t:Play()
				t.Completed:Wait()
			end
		end
	end
end)

Fruits:AddToggle('BuyRandomFruit', {Text = 'Auto Buy Random Fruit', Default = false, Callback = function(Value) end})
spawn(function()
	while wait(1) do
		if Toggles.BuyRandomFruit.Value then
			ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin","Buy")
		end
	end
end)

Fruits:AddToggle('FruitNotify', {Text = 'Fruit Spawn Notify', Default = true, Callback = function(Value) end})
spawn(function()
	while wait(1) do
		if Toggles.FruitNotify.Value then
			for _, v in workspace:GetChildren() do
				print('line 1654', v)
				if v.Name:find('Fruit') and v:IsA('Tool') then
					StarterGui:SetCore('SendNotification', {
						Title = 'Dropped Fruit Found: ' .. v.Name,
						Duration = 5,
					})
				elseif v.Name:find('Fruit') and v:IsA('Model') then
					if v:FindFirstChild('Fruit') and v:IsA('Model') then
						StarterGui:SetCore('SendNotification', {
							Title = 'Fruit Found: ' .. v.Name,
							Duration = 5,
						})
					else
						StarterGui:SetCore('SendNotification', {
							Title = 'Found Unknown Fruit: ' ,
							Duration = 5,
						})
					end
				end
			end)
		end
	end
end

Fruits:AddToggle('StoreFruit', {Text = 'Auto Store Fruit', Default = false, Callback = function(Value) end})
local function StoreFruite(name_1, name_2)
	local Character = Player.Character
	local Backpack = Player.Backpack
	local CommF_ = ReplicatedStorage.Remotes.CommF_
	if Character:FindFirstChild(name_2) or Backpack:FindFirstChild(name_2) then
		local args = {
			[1] = "StoreFruit",
			[2] = name_1,
			[3] = Character:FindFirstChild(name_2) or Backpack:FindFirstChild(name_2) 
		}
		CommF_:InvokeServer(unpack(args))
	end
end
spawn(function()
	while wait(0.5) do
		if Toggles.StoreFruit.Value then
			pcall(function()
				StoreFruit("Rocket-Rocket", "Rocket Fruit")
				StoreFruit("Spin-Spin", "Spin Fruit")
				StoreFruit("Blade-Blade", "Blade Fruit")
				StoreFruit("Spring-Spring", "Spring Fruit")
				StoreFruit("Bomb-Bomb", "Bomb Fruit")
				StoreFruit("Smoke-Smoke", "Smoke Fruit")
				StoreFruit("Spike-Spike", "Spike Fruit")
				StoreFruit("Flame-Flame", "Flame Fruit")
				StoreFruit("Falcon-Falcon", "Falcon Fruit")
				StoreFruit("Ice-Ice", "Ice Fruit")
				StoreFruit("Sand-Sand", "Sand Fruit")
				StoreFruit("Dark-Dark", "Dark Fruit")
				StoreFruit("Diamond-Diamond", "Diamond Fruit")
				StoreFruit("Light-Light", "Light Fruit")
				StoreFruit("Rubber-Rubber", "Rubber Fruit")
				StoreFruit("Barrier-Barrier", "Barrier Fruit")
				StoreFruit("Ghost-Ghost", "Ghost Fruit")
				StoreFruit("Magma-Magma", "Magma Fruit")
				StoreFruit("Quake-Quake", "Quake Fruit")
				StoreFruit("Buddha-Buddha", "Buddha Fruit")
				StoreFruit("Love-Love", "Love Fruit")
				StoreFruit("Spider-Spider", "Spider Fruit")
				StoreFruit("Sound-Sound", "Sound Fruit")
				StoreFruit("Phoenix-Phoenix", "Phoenix Fruit")
				StoreFruit("Portal-Portal", "Portal Fruit")
				StoreFruit("Rumble-Rumble", "Rumble Fruit")
				StoreFruit("Pain-Pain", "Pain Fruit")
				StoreFruit("Blizzard-Blizzard", "Blizzard Fruit")
				StoreFruit("Gravity-Gravity", "Gravity Fruit")
				StoreFruit("Mammoth-Mammoth", "Mammoth Fruit")
				StoreFruit("T-Rex-T-Rex", "T-Rex Fruit")
				StoreFruit("Dough-Dough", "Dough Fruit")
				StoreFruit("Shadow-Shadow", "Shadow Fruit")
				StoreFruit("Venom-Venom", "Venom Fruit")
				StoreFruit("Control-Control", "Control Fruit")
				StoreFruit("Gas-Gas", "Gas Fruit")
				StoreFruit("Spirit-Spirit", "Spirit Fruit")
				StoreFruit("Leopard-Leopard", "Leopard Fruit")
				StoreFruit("Yeti-Yeti", "Yeti Fruit")
				StoreFruit("Kitsune-Kitsune", "Kitsune Fruit")
				StoreFruit("Dragon-Dragon", "Dragon Fruit")
			end)
		end
	end
end)

-- Misc Tab
local Misc = Tabs.Misc:AddLeftGroupbox('Misc')

-- Shop Tab
local Shop = Tabs.Shop:AddLeftGroupbox('Shop')

Shop:AddToggle('RandomSurprise', {Text = 'Auto Random Surprise (50 Bones)', Default = false, Callback = function(Value) end})
Toggles.RandomSurprise:OnChanged(function()
	while Toggles.RandomSurprise.Value do
		ReplicatedStorage.Remotes.CommF_:InvokeServer('Bones', 'Buy', 1, 1)
		wait(0.25)
	end
end)

local ShopAbilities = Tabs.Shop:AddRightGroupbox('Abilities Shop')
ShopAbilities:AddButton('Buy Air Jump [ $10,000 ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyHaki', 'Geppo') end)
ShopAbilities:AddButton('Buy Aura [ $25,000 ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyHaki', 'Buso') end)
ShopAbilities:AddButton('Buy Flashstep [ $25,000 ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyHaki', 'Soru') end)
ShopAbilities:AddButton('Buy Instinct [ $750,000 ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('KenTalk', 'Buy') end)

ShopAbilities:AddToggle('AutoBuyAbilities', {Text = 'Auto Buy All Haki', Default = false, Callback = function(Value)
	while wait(2) do
		ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyHaki', 'Geppo')
		ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyHaki', 'Buso')
		ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyHaki', 'Soru')
		ReplicatedStorage.Remotes.CommF_:InvokeServer('KenTalk', 'Buy')
	end
end})

local ShopMisc = Tabs.Shop:AddLeftGroupbox('Misc')
ShopMisc:AddButton("Reroll Race [ f3000 ]", function() ReplicatedStorage.Remotes.CommF_:InvokeServer(BlackbeardReward, Reroll, 2) end)
ShopMisc:AddButton("Reset Stats [ f2500 ]", function() ReplicatedStorage.Remotes.CommF_:InvokeServer(BlackbeardReward, Refund, 2) end)

local Melee = Tabs.Shop:AddLeftGroupbox('Melees Shop')
Melee:AddButton('Black Leg [ $150,000  ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyBlackLeg') end)
Melee:AddButton('Electro [ $550,000  ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyElectro') end)
Melee:AddButton('Fishman Karate [ $750,000  ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyFishmanKarate') end)
Melee:AddButton('Dragon Claw [ f1,500 ]', function()
	ReplicatedStorage.Remotes.CommF_:InvokeServer('BlackbeardReward', 'DragonClaw', '1')
	ReplicatedStorage.Remotes.CommF_:InvokeServer('BlackbeardReward', 'DragonClaw', '2')
end)
Melee:AddButton('Superhuman [ $3,000,000 ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BuySuperhuman') end)
Melee:AddButton('Death Step [ f5,000 / $5,000,000 ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyDeathStep') end)
Melee:AddButton('Sharkman Karate [ f5,000 / $2,500,000 ]', function()
	ReplicatedStorage.Remotes.CommF_:InvokeServer('BuySharkmanKarate', true)
	ReplicatedStorage.Remotes.CommF_:InvokeServer('BuySharkmanKarate')
end)
Melee:AddButton('Electric Claw [ f5,000 / $3,000,000 ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyElectricClaw') end)
Melee:AddButton('Dragon Talon [ f5,000 / $3,000,000 ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyDragonTalon') end)
Melee:AddButton('God Human [ f5,000 / $5,000,000 ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyGodhuman') end)

local Accessories = Tabs.Shop:AddRightGroupbox('Accessories Shop')
Accessories:AddButton('Black Cape [ $50,000 ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyItem', 'Black Cape') end)
Accessories:AddButton('Swordsman Hat [ $150,000 ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyItem', 'Swordsman Hat') end)
Accessories:AddButton('Tomoe Ring [ $500,000 ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyItem', 'Tomoe Ring') end)

local Sword = Tabs.Shop:AddLeftGroupbox('Swords Shop')
Sword:AddButton('Cutlass [ $1,000 ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyItem', 'Cutlass') end)
Sword:AddButton('Katana [ $1,000 ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyItem', 'Katana') end)
Sword:AddButton('Dual Katana [ $12,000 ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyItem', 'Dual Katana') end)
Sword:AddButton('Iron Mace [ $25,000 ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyItem', 'Iron Mace') end)
Sword:AddButton('Triple Katana [ $60,000 ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyItem', 'Triple Katana') end)
Sword:AddButton('Pipe [ $100,000 ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyItem', 'Pipe') end)
Sword:AddButton('Dual-Headed Blade [ $400,000 ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyItem', 'Dual-Headed Blade') end)
Sword:AddButton('Soul Cane [ $750,000 ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyItem', 'Soul Cane') end)
Sword:AddButton('Bisento [ $1,200,000 ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyItem', 'Bisento') end)
Sword:AddButton('Pole v2 [ f5,000 ]', function()	ReplicatedStorage.Remotes.CommF_:InvokeServer('ThunderGodTalk') end)

local Gun = Tabs.Shop:AddRightGroupbox('Guns Shop')
Gun:AddButton('Slingshot [ $5,000 ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyItem', 'Slingshot') end)
Gun:AddButton('Musket [ $8,000 ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyItem', 'Musket') end)
Gun:AddButton('Flintlock [ $10,500 ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyItem', 'Flintlock') end)
Gun:AddButton('Refined Slingshot [ $30,000 ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyItem', 'Refined Slingshot') end)
Gun:AddButton('Refined Flintlock [ $65,000 ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BuyItem', 'Refined Flintlock') end)
Gun:AddButton('Kabucha [ f1,500 ]', function() ReplicatedStorage.Remotes.CommF_:InvokeServer('BlackbeardReward', 'Slingshot', '2') end)

-- Visuals Tab
local Sense = loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Sirius/refs/heads/request/library/sense/source.lua'))()

function Sense.getWeapon(plr)
	local weapon = plr.Character:FindFirstChildOfClass('Tool').Name
	print('weapon:', weapon)
	if weapon then
		return weapon
	else
		return 'None'
	end
end

local ESPSettings = Tabs.Visuals:AddLeftTabbox()

local Tab1 = ESPSettings:AddTab('Enemy')
Tab1:AddToggle('EnemyEnabled', {Text = 'Enemy ESP Enabled', Default = false, Callback = function(Value) end})
Tab1:AddToggle('EnemyBox', {Text = 'Enemy Box', Default = false, Callback = function(Value) end})
Tab1:AddToggle('EnemyBoxOutline', {Text = 'Enemy Box Outline', Default = false, Callback = function(Value) end})
Tab1:AddToggle('EnemyBoxFilled', {Text = 'Enemy Box Filled', Default = false, Callback = function(Value) end})
Tab1:AddToggle('EnemyHealthBar', {Text = 'Enemy Health Bar', Default = false, Callback = function(Value) end})
Tab1:AddToggle('EnemyHealthBarOutline', {Text = 'Enemy Health Bar Outline', Default = false, Callback = function(Value) end})
Tab1:AddToggle('EnemyHealthText', {Text = 'Enemy Health Text', Default = false, Callback = function(Value) end})
Tab1:AddToggle('EnemyHealthTextOutline', {Text = 'Enemy Health Text Outline', Default = false, Callback = function(Value) end})
Tab1:AddToggle('Enemy3DBox', {Text = 'Enemy 3D Box', Default = false, Callback = function(Value) end})
Tab1:AddToggle('EnemyName', {Text = 'Enemy Name', Default = false, Callback = function(Value) end})
Tab1:AddToggle('EnemyNameOutline', {Text = 'Enemy Name Outline', Default = false, Callback = function(Value) end})
Tab1:AddToggle('EnemyWeapon', {Text = 'Enemy Weapon', Default = false, Callback = function(Value) end})
Tab1:AddToggle('EnemyWeaponOutline', {Text = 'Enemy Weapon Outline', Default = false, Callback = function(Value) end})
Tab1:AddToggle('EnemyDistance', {Text = 'Enemy Distance', Default = false, Callback = function(Value) end})
Tab1:AddToggle('EnemyDistanceOutline', {Text = 'Enemy Distance Outline', Default = false, Callback = function(Value) end})
Tab1:AddToggle('EnemyTracer', {Text = 'Enemy Tracer', Default = false, Callback = function(Value) end})
Tab1:AddToggle('EnemyTracerOutline', {Text = 'Enemy Tracer Outline', Default = false, Callback = function(Value) end})
Tab1:AddToggle('EnemyOffScreenArrow', {Text = 'Enemy Off Screen Arrow', Default = false, Callback = function(Value) end})
Tab1:AddToggle('EnemyOffScreenArrowOutline', {Text = 'Enemy Off Screen Arrow Outline', Default = false, Callback = function(Value) end})
Tab1:AddToggle('EnemyChams', {Text = 'Enemy Chams', Default = false, Callback = function(Value) end})
Tab1:AddToggle('EnemyChamsVisibleOnly', {Text = 'Enemy Chams Visible Only', Default = false, Callback = function(Value) end})
Tab1:AddDropdown('EnemyTracerOrigin', {Values = {'Bottom', 'Middle', 'Top'}, Default = 'Bottom', Multi = false, Text = 'Enemy  Tracer Origin', Callback = function(Value) end})
Tab1:AddSlider('EnemyOffScreenArrowSize', {Text = 'Enemy Off Screen Arrow Size', Default = 15, Min = 1, Max = 50, Rounding = 0, Callback = function(Value) end})
Tab1:AddSlider('EnemyOffScreenArrowRadius', {Text = 'Enemy Off Screen Arrow Radius', Default = 150, Min = 50, Max = 500, Rounding = 0, Callback = function(Value) end})
Tab1:AddButton('Enable All', function()
	local togglesToEnable = {
		'EnemyEnabled', 'EnemyBox', 'EnemyBoxOutline', 'EnemyBoxFilled', 
		'EnemyHealthBar', 'EnemyHealthBarOutline', 'EnemyHealthText', 
		'EnemyHealthTextOutline', 'EnemyName', 
		'EnemyNameOutline', 'EnemyWeapon', 'EnemyWeaponOutline', 
		'EnemyDistance', 'EnemyDistanceOutline', 'EnemyTracer', 
		'EnemyTracerOutline', 'EnemyOffScreenArrow', 'EnemyOffScreenArrowOutline',
		'EnemyChams','EnemyChamsVisibleOnly'
	}
	for _, v in pairs(togglesToEnable) do
		if Toggles[v] then
			Toggles[v]:SetValue(true)
		end
	end
end)

local Tab2 = ESPSettings:AddTab('Friendly')
Tab2:AddToggle('FriendlyEnabled', {Text = 'Friendly ESP Enabled', Default = false, Callback = function(Value) end})
Tab2:AddToggle('FriendlyBox', {Text = 'Friendly Box', Default = false, Callback = function(Value) end})
Tab2:AddToggle('FriendlyBoxOutline', {Text = 'Friendly Box Outline', Default = false, Callback = function(Value) end})
Tab2:AddToggle('FriendlyBoxFilled', {Text = 'Friendly Box Filled', Default = false, Callback = function(Value) end})
Tab2:AddToggle('FriendlyHealthBar', {Text = 'Friendly Health Bar', Default = false, Callback = function(Value) end})
Tab2:AddToggle('FriendlyHealthBarOutline', {Text = 'Friendly Health Bar Outline', Default = false, Callback = function(Value) end})
Tab2:AddToggle('FriendlyHealthText', {Text = 'Friendly Health Text', Default = false, Callback = function(Value) end})
Tab2:AddToggle('FriendlyHealthTextOutline', {Text = 'Friendly Health Text Outline', Default = false, Callback = function(Value) end})
Tab2:AddToggle('Friendly3DBox', {Text = 'Friendly 3D Box', Default = false, Callback = function(Value) end})
Tab2:AddToggle('FriendlyName', {Text = 'Friendly Name', Default = false, Callback = function(Value) end})
Tab2:AddToggle('FriendlyNameOutline', {Text = 'Friendly Name Outline', Default = false, Callback = function(Value) end})
Tab2:AddToggle('FriendlyWeapon', {Text = 'Friendly Weapon', Default = false, Callback = function(Value) end})
Tab2:AddToggle('FriendlyWeaponOutline', {Text = 'Friendly Weapon Outline', Default = false, Callback = function(Value) end})
Tab2:AddToggle('FriendlyDistance', {Text = 'Friendly Distance', Default = false, Callback = function(Value) end})
Tab2:AddToggle('FriendlyDistanceOutline', {Text = 'Friendly Distance Outline', Default = false, Callback = function(Value) end})
Tab2:AddToggle('FriendlyTracer', {Text = 'Friendly Tracer', Default = false, Callback = function(Value) end})
Tab2:AddToggle('FriendlyTracerOutline', {Text = 'Friendly Tracer Outline', Default = false, Callback = function(Value) end})
Tab2:AddToggle('FriendlyOffScreenArrow', {Text = 'Friendly Off Screen Arrow', Default = false, Callback = function(Value) end})
Tab2:AddToggle('FriendlyOffScreenArrowOutline', {Text = 'Friendly Off Screen Arrow Outline', Default = false, Callback = function(Value) end})
Tab2:AddToggle('FriendlyChams', {Text = 'Friendly Chams', Default = false, Callback = function(Value) end})
Tab2:AddToggle('FriendlyChamsVisibleOnly', {Text = 'Friendly Chams Visible Only', Default = false, Callback = function(Value) end})
Tab2:AddDropdown('FriendlyTracerOrigin', {Values = {'Bottom', 'Middle', 'Top'}, Default = 'Bottom', Multi = false, Text = 'Friendly Tracer Origin', Callback = function(Value) end})
Tab2:AddSlider('FriendlyOffScreenArrowSize', {Text = 'Friendly Off Screen Arrow Size', Default = 15, Min = 1, Max = 50, Rounding = 0, Callback = function(Value) end})
Tab2:AddSlider('FriendlyOffScreenArrowRadius', {Text = 'Friendly Off Screen Arrow Radius', Default = 150, Min = 50, Max = 500, Rounding = 0, Callback = function(Value) end})
Tab2:AddButton('Enable All', function()
	local togglesToEnable = {
		'FriendlyEnabled', 'FriendlyBox', 'FriendlyBoxOutline', 'FriendlyBoxFilled', 
		'FriendlyHealthBar', 'FriendlyHealthBarOutline', 'FriendlyHealthText', 
		'FriendlyHealthTextOutline', 'FriendlyName', 
		'FriendlyNameOutline', 'FriendlyWeapon', 'FriendlyWeaponOutline', 
		'FriendlyDistance', 'FriendlyDistanceOutline', 'FriendlyTracer', 
		'FriendlyTracerOutline', 'FriendlyOffScreenArrow', 'FriendlyOffScreenArrowOutline',
		'FriendlyChams', 'FriendlyChamsVisibleOnly'
	}
	for _, v in pairs(togglesToEnable) do
		if Toggles[v] then
			Toggles[v]:SetValue(true)
		end
	end
end)

--[[ local ESPColors = Tabs.Visuals:AddRightTabbox()

local Tab3 = ESPColors:AddTab('Enemy Colors')
Tab3:AddLabel('Enemy Box Color'):AddColorPicker('EnemyBoxColor', { Default = Color3.new(1, 0, 0), Callback = function(Value) end})
Tab3:AddLabel('Enemy Box Outline Color'):AddColorPicker('EnemyBoxOutlineColor', { Default = Color3.new(1, 0, 0), Callback = function(Value) end})
Tab3:AddLabel('Enemy Box Fill Color'):AddColorPicker('EnemyBoxFillColor', { Default = Color3.new(1, 0, 0), Callback = function(Value) end})
Tab3:AddLabel('Enemy Healthy Color'):AddColorPicker('EnemyHealthyColor', { Default = Color3.new(0, 1, 0), Callback = function(Value) end})
Tab3:AddLabel('Enemy Unhealthy Color'):AddColorPicker('EnemyUnhealthyColor', { Default = Color3.new(1, 0, 0), Callback = function(Value) end})
Tab3:AddLabel('Enemy Health Bar Outline Color'):AddColorPicker('EnemyHealthBarOutlineColor', { Default = Color3.new(), Callback = function(Value) end})
Tab3:AddLabel('Enemy Health Text Color'):AddColorPicker('EnemyHealthTextColor', { Default = Color3.new(1, 1, 1), Callback = function(Value) end})
Tab3:AddLabel('Enemy Health Text Outline Color'):AddColorPicker('EnemyHealthTextOutlineColor', { Default = Color3.new(), Callback = function(Value) end})
Tab3:AddLabel('Enemy 3D Box Color'):AddColorPicker('Enemy3DBoxColor', { Default = Color3.new(1, 0, 0), Callback = function(Value) end})
Tab3:AddLabel('Enemy Name Color'):AddColorPicker('EnemyNameColor', { Default = Color3.new(1, 1, 1), Callback = function(Value) end})
Tab3:AddLabel('Enemy Name Outline Color'):AddColorPicker('EnemyNameOutlineColor', { Default = Color3.new(), Callback = function(Value) end})
Tab3:AddLabel('Enemy Weapon Color'):AddColorPicker('EnemyWeaponColor', { Default = Color3.new(1, 1, 1), Callback = function(Value) end})
Tab3:AddLabel('Enemy Weapon Outline Color'):AddColorPicker('EnemyWeaponOutlineColor', { Default = Color3.new(), Callback = function(Value) end})
Tab3:AddLabel('Enemy Distance Color'):AddColorPicker('EnemyDistanceColor', { Default = Color3.new(1, 1, 1), Callback = function(Value) end })
Tab3:AddLabel('Enemy Distance Outline Color'):AddColorPicker('EnemyDistanceOutlineColor', { Default = Color3.new(), Callback = function(Value) end })
Tab3:AddLabel('Enemy Tracer Color'):AddColorPicker('EnemyTracerColor', { Default = Color3.new(1, 0, 0), Callback = function(Value) end })
Tab3:AddLabel('Enemy Tracer Outline Color'):AddColorPicker('EnemyTracerOutlineColor', { Default = Color3.new(0, 0, 0), Callback = function(Value) end })
Tab3:AddLabel('Enemy Off Screen Arrow Color'):AddColorPicker('EnemyOffScreenArrowColor', { Default = Color3.new(1, 0, 0), Callback = function(Value) end })
Tab3:AddLabel('Enemy Off Screen Arrow Outline Color'):AddColorPicker('EnemyOffScreenArrowOutlineColor', { Default = Color3.new(0, 0, 0), Callback = function(Value) end })
Tab3:AddLabel('Enemy Chams Fill Color'):AddColorPicker('EnemyChamsFillColor', { Default = Color3.new(0, 0, 0), Callback = function(Value) end })
Tab3:AddLabel('Enemy Chams Outline Color'):AddColorPicker('EnemyChamsOutlineColor', { Default = Color3.new(1, 0, 0), Callback = function(Value) end }) ]]

--[[ local Tab4 = ESPColors:AddTab('Friendly Colors')
Tab4:AddLabel('Friendly Box Color'):AddColorPicker('FriendlyBoxColor', { Default = Color3.new(0, 1, 0), Callback = function(Value) end})
Tab4:AddLabel('Friendly Box Outline Color'):AddColorPicker('FriendlyBoxOutlineColor', { Default = Color3.new(), Callback = function(Value) end})
Tab4:AddLabel('Friendly Box Fill Color'):AddColorPicker('FriendlyBoxFillColor', { Default = Color3.new(0, 1, 0), Callback = function(Value) end})
Tab4:AddLabel('Friendly Healthy Color'):AddColorPicker('FriendlyHealthyColor', { Default = Color3.new(0, 1, 0), Callback = function(Value) end})
Tab4:AddLabel('Friendly Unhealthy Color'):AddColorPicker('FriendlyUnhealthyColor', { Default = Color3.new(1, 0, 0), Callback = function(Value) end})
Tab4:AddLabel('Friendly Health Bar Outline Color'):AddColorPicker('FriendlyHealthBarOutlineColor', { Default = Color3.new(), Callback = function(Value) end})
Tab4:AddLabel('Friendly Health Text Color'):AddColorPicker('FriendlyHealthTextColor', { Default = Color3.new(1, 1, 1), Callback = function(Value) end})
Tab4:AddLabel('Friendly Health Text Outline Color'):AddColorPicker('FriendlyHealthTextOutlineColor', { Default = Color3.new(), Callback = function(Value) end})
Tab4:AddLabel('Friendly 3D Box Color'):AddColorPicker('Friendly3DBoxColor', { Default = Color3.new(0, 1, 0), Callback = function(Value) end})
Tab4:AddLabel('Friendly Name Color'):AddColorPicker('FriendlyNameColor', { Default = Color3.new(1, 1, 1), Callback = function(Value) end})
Tab4:AddLabel('Friendly Name Outline Color'):AddColorPicker('FriendlyNameOutlineColor', { Default = Color3.new(), Callback = function(Value) end})
Tab4:AddLabel('Friendly Weapon Color'):AddColorPicker('FriendlyWeaponColor', { Default = Color3.new(1, 1, 1), Callback = function(Value) end})
Tab4:AddLabel('Friendly Weapon Outline Color'):AddColorPicker('FriendlyWeaponOutlineColor', { Default = Color3.new(), Callback = function(Value) end})
Tab4:AddLabel('Friendly Distance Color'):AddColorPicker('FriendlyDistanceColor', { Default = Color3.new(1, 1, 1), Callback = function(Value) end })
Tab4:AddLabel('Friendly Distance Outline Color'):AddColorPicker('FriendlyDistanceOutlineColor', { Default = Color3.new(), Callback = function(Value) end })
Tab4:AddLabel('Friendly Trace Color'):AddColorPicker('FriendlyTraceColor', { Default = Color3.new(0, 1, 0), Callback = function(Value) end })
Tab4:AddLabel('Friendly Trace Outline Color'):AddColorPicker('FriendlyTraceOutlineColor', { Default = Color3.new(0, 0, 0), Callback = function(Value) end })
Tab4:AddLabel('Friendly Off Screen Arrow Color'):AddColorPicker('FriendlyOffScreenArrowColor', { Default = Color3.new(0, 1, 0), Callback = function(Value) end })
Tab4:AddLabel('Friendly Off Screen Arrow Outline Color'):AddColorPicker('FriendlyOffScreenArrowOutlineColor', { Default = Color3.new(0, 0, 0), Callback = function(Value) end })
Tab4:AddLabel('Friendly Chams Fill Color'):AddColorPicker('FriendlyChamsFillColor', { Default = Color3.new(0, 0, 0), Callback = function(Value) end })
Tab4:AddLabel('Friendly Chams Outline Color'):AddColorPicker('FriendlyChamsOutlineColor', { Default = Color3.new(0, 1, 0), Callback = function(Value) end }) ]]
-- Enemy Toggles
Toggles.EnemyEnabled:OnChanged(function() Sense.teamSettings.enemy.enabled = Toggles.EnemyEnabled.Value end)
Toggles.EnemyBox:OnChanged(function() Sense.teamSettings.enemy.box = Toggles.EnemyBox.Value end)
Toggles.EnemyBoxOutline:OnChanged(function() Sense.teamSettings.enemy.boxOutline = Toggles.EnemyBoxOutline.Value end)
Toggles.EnemyBoxFilled:OnChanged(function() Sense.teamSettings.enemy.boxFilled = Toggles.EnemyBoxFilled.Value end)
Toggles.Enemy3DBox:OnChanged(function() Sense.teamSettings.enemy.box3d = Toggles.Enemy3DBox.Value end)
Toggles.EnemyHealthText:OnChanged(function() Sense.teamSettings.enemy.healthText = Toggles.EnemyHealthText.Value end)
Toggles.EnemyHealthBar:OnChanged(function() Sense.teamSettings.enemy.healthBar = Toggles.EnemyHealthBar.Value end)
Toggles.EnemyHealthBarOutline:OnChanged(function() Sense.teamSettings.enemy.healthBarOutline = Toggles.EnemyHealthBarOutline.Value end)
Toggles.EnemyName:OnChanged(function() Sense.teamSettings.enemy.name = Toggles.EnemyName.Value end)
Toggles.EnemyNameOutline:OnChanged(function() Sense.teamSettings.enemy.nameOutline = Toggles.EnemyNameOutline.Value end)
Toggles.EnemyWeapon:OnChanged(function() Sense.teamSettings.enemy.weapon = Toggles.EnemyWeapon.Value end)
Toggles.EnemyWeaponOutline:OnChanged(function() Sense.teamSettings.enemy.weaponOutline = Toggles.EnemyWeaponOutline.Value end)
Toggles.EnemyDistance:OnChanged(function() Sense.teamSettings.enemy.distance = Toggles.EnemyDistance.Value end)
Toggles.EnemyDistanceOutline:OnChanged(function() Sense.teamSettings.enemy.distanceOutline = Toggles.EnemyDistanceOutline.Value end)
Toggles.EnemyTracer:OnChanged(function() Sense.teamSettings.enemy.tracer = Toggles.EnemyTracer.Value end)
Options.EnemyTracerOrigin:OnChanged(function() Sense.teamSettings.enemy.tracerOrigin = Options.EnemyTracerOrigin.Value end)
Toggles.EnemyTracerOutline:OnChanged(function() Sense.teamSettings.enemy.tracerOutline = Toggles.EnemyTracerOutline.Value end)
Toggles.EnemyOffScreenArrow:OnChanged(function() Sense.teamSettings.enemy.offScreenArrow = Toggles.EnemyOffScreenArrow.Value end)
Toggles.EnemyOffScreenArrowOutline:OnChanged(function() Sense.teamSettings.enemy.offScreenArrowOutline = Toggles.EnemyOffScreenArrowOutline.Value end)
Options.EnemyOffScreenArrowSize:OnChanged(function() Sense.teamSettings.enemy.offScreenArrowSize = Options.EnemyOffScreenArrowSize.Value end)
Options.EnemyOffScreenArrowRadius:OnChanged(function() Sense.teamSettings.enemy.offScreenArrowRadius = Options.EnemyOffScreenArrowRadius.Value end)
Toggles.EnemyChams:OnChanged(function() Sense.teamSettings.enemy.chams = Toggles.EnemyChams.Value end)
Toggles.EnemyChamsVisibleOnly:OnChanged(function() Sense.teamSettings.enemy.chamsVisibleOnly = Toggles.EnemyChamsVisibleOnly.Value end)

-- Friendly Toggles
Toggles.FriendlyEnabled:OnChanged(function() Sense.teamSettings.friendly.enabled = Toggles.FriendlyEnabled.Value end)
Toggles.FriendlyBox:OnChanged(function() Sense.teamSettings.friendly.box = Toggles.FriendlyBox.Value end)
Toggles.FriendlyBoxOutline:OnChanged(function() Sense.teamSettings.friendly.boxOutline = Toggles.FriendlyBoxOutline.Value end)
Toggles.FriendlyBoxFilled:OnChanged(function() Sense.teamSettings.friendly.boxFilled = Toggles.FriendlyBoxFilled.Value end)
Toggles.Friendly3DBox:OnChanged(function() Sense.teamSettings.friendly.box3d = Toggles.Friendly3DBox.Value end)
Toggles.FriendlyHealthText:OnChanged(function() Sense.teamSettings.friendly.healthText = Toggles.FriendlyHealthText.Value end)
Toggles.FriendlyHealthBar:OnChanged(function() Sense.teamSettings.friendly.healthBar = Toggles.FriendlyHealthBar.Value end)
Toggles.FriendlyHealthBarOutline:OnChanged(function() Sense.teamSettings.friendly.healthBarOutline = Toggles.FriendlyHealthBarOutline.Value end)
Toggles.FriendlyName:OnChanged(function() Sense.teamSettings.friendly.name = Toggles.FriendlyName.Value end)
Toggles.FriendlyNameOutline:OnChanged(function() Sense.teamSettings.friendly.nameOutline = Toggles.FriendlyNameOutline.Value end)
Toggles.FriendlyWeapon:OnChanged(function() Sense.teamSettings.friendly.weapon = Toggles.FriendlyWeapon.Value end)
Toggles.FriendlyWeaponOutline:OnChanged(function() Sense.teamSettings.friendly.weaponOutline = Toggles.FriendlyWeaponOutline.Value end)
Toggles.FriendlyDistance:OnChanged(function() Sense.teamSettings.friendly.distance = Toggles.FriendlyDistance.Value end)
Toggles.FriendlyDistanceOutline:OnChanged(function() Sense.teamSettings.friendly.distanceOutline = Toggles.FriendlyDistanceOutline.Value end)
Toggles.FriendlyTracer:OnChanged(function() Sense.teamSettings.friendly.tracer = Toggles.FriendlyTracer.Value end)
Options.FriendlyTracerOrigin:OnChanged(function() Sense.teamSettings.friendly.tracerOrigin = Options.FriendlyTracerOrigin.Value end)
Toggles.FriendlyTracerOutline:OnChanged(function() Sense.teamSettings.friendly.tracerOutline = Toggles.FriendlyTracerOutline.Value end)
Toggles.FriendlyOffScreenArrow:OnChanged(function() Sense.teamSettings.friendly.offScreenArrow = Toggles.FriendlyOffScreenArrow.Value end)
Toggles.FriendlyOffScreenArrowOutline:OnChanged(function() Sense.teamSettings.friendly.offScreenArrowOutline = Toggles.FriendlyOffScreenArrowOutline.Value end)
Options.FriendlyOffScreenArrowSize:OnChanged(function() Sense.teamSettings.friendly.offScreenArrowSize = Options.FriendlyOffScreenArrowSize.Value end)
Options.FriendlyOffScreenArrowRadius:OnChanged(function() Sense.teamSettings.friendly.offScreenArrowRadius = Options.FriendlyOffScreenArrowRadius.Value end)
Toggles.FriendlyChams:OnChanged(function() Sense.teamSettings.friendly.chams = Toggles.FriendlyChams.Value end)
Toggles.FriendlyChamsVisibleOnly:OnChanged(function() Sense.teamSettings.friendly.chamsVisibleOnly = Toggles.FriendlyChamsVisibleOnly.Value end)

-- Enemy Colors
--[[ Options.EnemyBoxColor:OnChanged(function()
	Sense.teamSettings.enemy.boxColor = Options.EnemyBoxColor.Value
end)
Options.EnemyBoxOutlineColor:OnChanged(function()
	Sense.teamSettings.enemy.boxOutlineColor = Options.EnemyBoxOutlineColor.Value
end)
Options.EnemyBoxFillColor:OnChanged(function()
	Sense.teamSettings.enemy.boxFillColor = Options.EnemyBoxFillColor.Value
end)
Options.EnemyHealthyColor:OnChanged(function()
	Sense.teamSettings.enemy.healthyColor = Options.EnemyHealthyColor.Value
end)
Options.EnemyUnhealthyColor:OnChanged(function()
	Sense.teamSettings.enemy.unhealthyColor = Options.EnemyUnhealthyColor.Value
end)
Options.EnemyHealthBarOutlineColor:OnChanged(function()
	Sense.teamSettings.enemy.healthBarOutlineColor = Options.EnemyHealthBarOutlineColor.Value
end)
Options.EnemyHealthTextColor:OnChanged(function()
	Sense.teamSettings.enemy.healthTextColor = Options.EnemyHealthTextColor.Value
end)
Options.EnemyHealthTextOutlineColor:OnChanged(function()
	Sense.teamSettings.enemy.healthTextOutlineColor = Options.EnemyHealthTextOutlineColor.Value
end)
Options.Enemy3DBoxColor:OnChanged(function()
	Sense.teamSettings.enemy.box3dColor = Options.Enemy3DBoxColor.Value
end)
Options.EnemyNameColor:OnChanged(function()
	Sense.teamSettings.enemy.nameColor = Options.EnemyNameColor.Value
end)
Options.EnemyNameOutlineColor:OnChanged(function()
	Sense.teamSettings.enemy.nameOutlineColor = Options.EnemyNameOutlineColor.Value
end)
Options.EnemyWeaponColor:OnChanged(function()
	Sense.teamSettings.enemy.weaponColor = Options.EnemyWeaponColor.Value
end)
Options.EnemyWeaponOutlineColor:OnChanged(function()
	Sense.teamSettings.enemy.weaponOutlineColor = Options.EnemyWeaponOutlineColor.Value
end)
Options.EnemyDistanceColor:OnChanged(function()
	Sense.teamSettings.enemy.distanceColor = Options.EnemyDistanceColor.Value
end)
Options.EnemyDistanceOutlineColor:OnChanged(function()
	Sense.teamSettings.enemy.distanceOutlineColor = Options.EnemyDistanceOutlineColor.Value
end)
Options.EnemyTracerColor:OnChanged(function()
	Sense.teamSettings.enemy.tracerColor = Options.EnemyTracerColor.Value
end)
Options.EnemyTracerOutlineColor:OnChanged(function()
	Sense.teamSettings.enemy.tracerOutlineColor = Options.EnemyTracerOutlineColor.Value
end)
Options.EnemyOffScreenArrowColor:OnChanged(function()
	Sense.teamSettings.enemy.offScreenArrowColor = Options.EnemyOffScreenArrowColor.Value
end)
Options.EnemyOffScreenArrowOutlineColor:OnChanged(function()
	Sense.teamSettings.enemy.offScreenArrowOutlineColor = Options.EnemyOffScreenArrowOutlineColor.Value
end)
Options.EnemyChamsFillColor:OnChanged(function()
	Sense.teamSettings.enemy.chamsFillColor = Options.EnemyChamsFillColor.Value
end)
Options.EnemyChamsOutlineColor:OnChanged(function()
	Sense.teamSettings.enemy.chamsOutlineColor = Options.EnemyChamsOutlineColor.Value
end)

-- Friendly Colors
Options.FriendlyBoxColor:OnChanged(function()
	Sense.teamSettings.friendly.boxColor = Options.FriendlyBoxColor.Value
end)

Options.FriendlyBoxOutlineColor:OnChanged(function()
	Sense.teamSettings.friendly.boxOutlineColor = Options.FriendlyBoxOutlineColor.Value
end)

Options.FriendlyBoxFillColor:OnChanged(function()
	Sense.teamSettings.friendly.boxFillColor = Options.FriendlyBoxFillColor.Value
end)

Options.FriendlyHealthyColor:OnChanged(function()
	Sense.teamSettings.friendly.healthyColor = Options.FriendlyHealthyColor.Value
end)

Options.FriendlyUnhealthyColor:OnChanged(function()
	Sense.teamSettings.friendly.unhealthyColor = Options.FriendlyUnhealthyColor.Value
end)

Options.FriendlyHealthBarOutlineColor:OnChanged(function()
	Sense.teamSettings.friendly.healthBarOutlineColor = Options.FriendlyHealthBarOutlineColor.Value
end)

Options.FriendlyHealthTextColor:OnChanged(function()
	Sense.teamSettings.friendly.healthTextColor = Options.FriendlyHealthTextColor.Value
end)

Options.FriendlyHealthTextOutlineColor:OnChanged(function()
	Sense.teamSettings.friendly.healthTextOutlineColor = Options.FriendlyHealthTextOutlineColor.Value
end)

Options.Friendly3DBoxColor:OnChanged(function()
	Sense.teamSettings.friendly.box3dColor = Options.Friendly3DBoxColor.Value
end)

Options.FriendlyNameColor:OnChanged(function()
	Sense.teamSettings.friendly.nameColor = Options.FriendlyNameColor.Value
end)

Options.FriendlyNameOutlineColor:OnChanged(function()
	Sense.teamSettings.friendly.nameOutlineColor = Options.FriendlyNameOutlineColor.Value
end)

Options.FriendlyWeaponColor:OnChanged(function()
	Sense.teamSettings.friendly.weaponColor = Options.FriendlyWeaponColor.Value
end)

Options.FriendlyWeaponOutlineColor:OnChanged(function()
	Sense.teamSettings.friendly.weaponOutlineColor = Options.FriendlyWeaponOutlineColor.Value
end)

Options.FriendlyDistanceColor:OnChanged(function()
	Sense.teamSettings.friendly.distanceColor = Options.FriendlyDistanceColor.Value
end)

Options.FriendlyDistanceOutlineColor:OnChanged(function()
	Sense.teamSettings.friendly.distanceOutlineColor = Options.FriendlyDistanceOutlineColor.Value
end)

Options.FriendlyTraceColor:OnChanged(function()
	Sense.teamSettings.friendly.tracerColor = Options.FriendlyTraceColor.Value
end)

Options.FriendlyTraceOutlineColor:OnChanged(function()
	Sense.teamSettings.friendly.tracerOutlineColor = Options.FriendlyTraceOutlineColor.Value
end)

Options.FriendlyOffScreenArrowColor:OnChanged(function()
	Sense.teamSettings.friendly.offScreenArrowColor = Options.FriendlyOffScreenArrowColor.Value
end)

Options.FriendlyOffScreenArrowOutlineColor:OnChanged(function()
	Sense.teamSettings.friendly.offScreenArrowOutlineColor = Options.FriendlyOffScreenArrowOutlineColor.Value
end)

Options.FriendlyChamsFillColor:OnChanged(function()
	Sense.teamSettings.friendly.chamsFillColor = Options.FriendlyChamsFillColor.Value
end)

Options.FriendlyChamsOutlineColor:OnChanged(function()
	Sense.teamSettings.friendly.chamsOutlineColor = Options.FriendlyChamsOutlineColor.Value
end) ]]

local ESPMisc = Tabs.Visuals:AddRightGroupbox('Misc')

ESPMisc:AddSlider('FieldOfView', {
	Text = 'Field of View',
	Default = 70,
	Min = 30,
	Max = 120,
	Rounding = 0,
	Callback = function(Value)
		workspace.CurrentCamera.FieldOfView = Value
	end
})

ESPMisc:AddSlider('TextSize', {
	Text = 'Text Size',
	Default = 13,
	Min = 1,
	Max = 32,
	Rounding = 0,
	Callback = function(Value)
		Sense.sharedSettings.textSize = Value
	end
})

ESPMisc:AddDropdown('TextFont', {
	Values = {2, 3, 4},
	Default = 1,
	Multi = false,
	Text = 'Text Font',
	Callback = function(Value)
		Sense.sharedSettings.textFont = Value
	end
})

ESPMisc:AddToggle('LimitDistance', {
	Text = 'Limit Distance',
	Default = false,
	Callback = function(Value)
		Sense.sharedSettings.limitDistance = Value
	end
})

ESPMisc:AddSlider('MaxDistance', {
	Text = 'Max Distance',
	Default = 150,
	Min = 0,
	Max = 1000,
	Rounding = 0,
	Callback = function(Value)
		Sense.sharedSettings.maxDistance = Value
	end
})

ESPMisc:AddButton('Unload ESP', function()
	Sense.Unload()
end)

print('90%')
-- Library functions
Library:SetWatermarkVisibility(true)

local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local WatermarkConnection = RunService.RenderStepped:Connect(function()
	FrameCounter += 1;

	if (tick() - FrameTimer) >= 1 then
		FPS = FrameCounter;
		FrameTimer = tick();
		FrameCounter = 0;
	end;
	
	Library:SetWatermark(('fatality.win | %s fps | %s ms | | %s RAM | %s'):format(
		math.floor(Stats.Workspace.Heartbeat:GetValue()),
		math.floor(Stats.PerformanceStats.Ping:GetValue()),
		math.floor(Stats.PerformanceStats.Memory:GetValue()),
		os.date('%X')
	));
end);

Library.KeybindFrame.Visible = false; -- default was on

Library:OnUnload(function()
	WatermarkConnection:Disconnect()

	print('Unloaded!')
	Library.Unloaded = true
end)

-- UI Settings

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('FatalityWin')
SaveManager:SetFolder('FatalityWin/BloxFruits')

SaveManager:BuildConfigSection(Tabs['Config'])

ThemeManager:ApplyToTab(Tabs['Config'])

ThemeManager:ApplyTheme('Fatality')

SaveManager:LoadAutoloadConfig()

Sense.Load()

print('100%')