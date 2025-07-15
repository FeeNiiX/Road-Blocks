print('Loading Blox Fruits Fatality...')
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(readfile('Library.lua'))() -- Dont leave this here gng
--local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local VirtualInputManager = game:GetService('VirtualInputManager')
local CollectionService = game:GetService('CollectionService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local TeleportService = game:GetService('TeleportService')
local TweenService = game:GetService('TweenService')
local HttpService = game:GetService('HttpService')
local VirtualUser = game:GetService('VirtualUser')
local RunService = game:GetService('RunService')
local StarterGui = game:GetService('StarterGui')
local Lighting = game:GetService('Lighting')
local Players = game:GetService('Players')
local Stats = game:GetService('Stats')

local Timer = tick()
local plr = Players.LocalPlayer
local CommF_ = ReplicatedStorage.Remotes.CommF_
local Meters = 100 / 28

-- TODO
--[[
Give Up ✌️✊
Bring back all OnChanged things
Fix Island Tween
Fix BerryESP
Fix AutoBerry
Find out what makes the player starts sliding of steep angles and camera gets a little quirk (localplayer tab 100%)

Long Term:
Add Fast attack
Add Hitbox Expander (maybe its just humanoidrootpart butt lift)
Smart Teleport (I already know how to 😈) ]]

if plr.PlayerGui:WaitForChild('Main (minimal)') and plr.PlayerGui['Main (minimal)']:WaitForChild('ChooseTeam') then
	repeat wait()
		if plr.PlayerGui['Main (minimal)'].ChooseTeam.Visible == true then
			for i, v in pairs(getconnections(plr.PlayerGui['Main (minimal)'].ChooseTeam.Container.Marines.Frame.TextButton.Activated)) do
				v.Function()
			end
		end
	until plr.Team ~= nil and game:IsLoaded()
end

wait(1)

-- Functions
local function getRoot()
	local rootPart = plr.Character and plr.Character:FindFirstChild('HumanoidRootPart')
	return rootPart
end

local function serverHop()
	-- infinite yield server hop ofc
	local servers = {}
	local req = game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true')
	local body = HttpService:JSONDecode(req)

	if body and body.data then
		for i, v in next, body.data do
			if type(v) == 'table' and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
				table.insert(servers, 1, v.id)
			end
		end
	end

	if #servers > 0 then
		TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], plr)
	else
		StarterGui:SetCore('SendNotification', {
			Title = 'Server Hop',
			Text = 'Could not find a server to join.',
			Duration = 5,
		})
	end
end

plr.Idled:Connect(function()
	print('Anti AFK worked (i think)')
	VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
	wait()
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
	Shop = Window:AddTab('Shop'),
	Visuals = Window:AddTab('Visuals'),
	Misc = Window:AddTab('Misc'),
	Config = Window:AddTab('Config'),
}

StarterGui:SetCore('SendNotification', {
	Title = 'Fatality Loaded Successfully',
	Duration = '3',
})

local MenuGroup = Tabs.Config:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function()
	Library:Unload()
end)

MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'LeftControl', NoUI = true, Text = 'Menu keybind' })
Library.ToggleKeybind = Options.MenuKeybind

if game.PlaceId == 2753915549 then
	FirstSea = true
elseif game.PlaceId == 4442272183 then
	SecondSea = true
elseif game.PlaceId == 7449423635 then
	ThirdSea = true
end

if FirstSea then
	IslandCheck = {
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
	}
	elseif SecondSea then
	IslandCheck = {
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
	}
	elseif ThirdSea then
	IslandCheck = {
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
end

local IslandNames = {}
for name, _ in pairs(IslandCheck) do
	table.insert(IslandNames, name)
end
table.sort(IslandNames)

--[[ 
TODO: Island Tweeing is uncomplete, the tween itself wont get the vector3 values so yas
 ]]

-- Left Group Box Tweening
local Tweening = Tabs.Main:AddLeftGroupbox('Tweening')

local function convert(target)
	if typeof(target) == 'Instance' or typeof(target) == 'Part' or typeof(target) == 'Model' then
		return target.PrimaryPart
	elseif typeof(target) == 'CFrame' then
		return target.Position
	elseif typeof(target) == 'Vector3' then
		return target
	else
		print('404: ', typeof(target))
		print('404: Invalid target type')
	end
end

local function Tween(target)
	local root = getRoot()

	if root and root.Parent and root.Parent:FindFirstChild('Humanoid') then
		local humanoid = root.Parent:FindFirstChild('Humanoid')
		if humanoid.Sit then
			VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
			wait()
			VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
		end
	end

	local targetPos = convert(target)
	if targetPos then
		local distance = (root.Position - targetPos.Position).Magnitude
		local duration = distance / tSpeed

		local info = TweenInfo.new(duration, Enum.EasingStyle.Linear)
		local tween = TweenService:Create(root, info, {CFrame = CFrame.new(targetPos.Position)})

		tween:Play()
		tween.Completed:Wait()
	end
end

local function CancelTween(Target)
	if not Target then
		print('Canceling Tween NPC')
		local root = getRoot()
		-- TweenService:Create(root, TweenInfo.new(0), {CFrame = CFrame.new(root.Position)}):Play()
		if root.Anchored then
			print('Unanchoring Root')
			root.Anchored = false
		end
	end
end

Tweening:AddDropdown('PlayersDropdown', {SpecialType = 'Player', Text = 'Players', Callback = function(Value) end})
Tweening:AddToggle('TweenToPlayerToggle', {Text = 'Tween To Players', Default = false, Callback = function(Value) end})
Toggles.TweenToPlayerToggle:OnChanged(function()
	TweenPlayer = Toggles.TweenToPlayerToggle.Value
end)
spawn(function()
	while wait(0.5) do
		if TweenPlayer then
			local t = Options.PlayersDropdown.Value
			local ta = Player:FindFirstChild(t).Character.HumanoidRootPart
			Tween(ta)
			CancelTween(ta)
		end
	end
end)

Tweening:AddToggle('SpectatePlayerToggle', {Text = 'Spectate Player', Default = false, Callback = function(Value) end})
Toggles.SpectatePlayerToggle:OnChanged(function()
	if Toggles.SpectatePlayerToggle.Value then
		workspace.CurrentCamera.CameraSubject = workspace.Characters[Options.PlayersDropdown.Value]
	else
		workspace.CurrentCamera.CameraSubject = plr.Character
	end
end)

Tweening:AddDropdown('NPCsDropdown', {Values = GetNPCs(), Default = 0, Multi = false, Text = 'NPCs', Callback = function(Value) end})
Tweening:AddToggle('TweenToNPCToggle', {Text = 'Tween To NPC', Default = false, Callback = function(Value) end})
Toggles.TweenToNPCToggle:OnChanged(function()
	TweenNPC = Toggles.TweenToNPCToggle.Value
end)
spawn(function()
	while wait(0.5) do
		if TweenNPC then
			local t = Options.NPCsDropdown.Value
			local ta
			if ReplicatedStorage.NPCs:FindFirstChild(t) then
				ta = ReplicatedStorage.NPCs[t]
			elseif workspace.NPCs:FindFirstChild(t) then
				ta = workspace.NPCs[t]
			end
			if ta then
				Tween(ta)
				CancelTween(ta)
			end
		end
	end
end)

Tweening:AddDropdown('IslandsDropdown', {Values = IslandNames, Default = 0, Multi = false, Text = 'Islands', Callback = function(Value) end})
Tweening:AddToggle('TweenToIslandToggle', { Text = 'Tween To Island', Default = false, Callback = function(Value) end})
Toggles.TweenToIslandToggle:OnChanged(function()
	TweenIsland = Toggles.TweenToIslandToggle.Value
end)
spawn(function()
	while wait(0.5) do
		if TweenIsland then
			local t = Options.IslandsDropdown.Value
			local target = IslandCheck[SelectedIsland]
			Tween(target)
			CancelTween(target)
		else
		end
	end
end)

Tweening:AddSlider('tSpeed', {Text = 'Tweening Speed', Default = 350, Min = 0, Max = 350, Rounding = 0, Compact = false,Callback = function(Value) end})
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
	while wait() do
		if Toggles.AutoChests.Value then
			for i, v in pairs(workspace.Map:GetDescendants()) do
				if v.Name:find('Chest') and v:IsA('Part') and v.CanTouch then
					Chest = v.CFrame
				end
			end
			
			Tween(Chest)
		end
	end
end)

AutoCollect:AddToggle('ChestESP', {Text = 'Chest ESP', Default = true, Callback = function(Value) end})
Toggles.ChestESP:OnChanged(function()
	Toggle_ChestESP = Toggles.ChestESP.Value
end)
spawn(function()
	while wait(0.1) do
		if Toggle_ChestESP then
			for _, chest in pairs(workspace.ChestModels:GetChildren()) do
				if not chest:FindFirstChild("ChestEsp") then
					local bill = Instance.new("BillboardGui", chest)
					bill.Name = "ChestEsp"
					bill.AlwaysOnTop = true
					bill.Adornee = chest
					bill.Size = UDim2.new(1, 200, 1, 30)

					local name = Instance.new("TextLabel", bill)
					name.FontSize = 'Size14'
					name.Font = Enum.Font.SourceSans
					name.TextWrapped = true
					name.Size = UDim2.new(1, 0, 1, 0)
					name.TextYAlignment = 'Top'
					name.BackgroundTransparency = 1
					name.TextStrokeTransparency = 0.5
					name.TextColor3 = Color3.fromRGB(255, 255, 255)
				else
					local dis = math.floor((plr.Character.HumanoidRootPart.Position - chest.PrimaryPart.Position).Magnitude / Meters)
					chest["ChestEsp"].TextLabel.Text = (chest.Name .. "\n" .. dis .. "M")
				end
			end
		else
			if chest:FindFirstChild("ChestEsp") then
				chest:FindFirstChild("ChestEsp"):Destroy()
			end
		end
	end
end)

AutoCollect:AddToggle('BerryHop', {Text = 'Berry Hop', Default = false, Callback = function(Value) end})
AutoCollect:AddToggle('AutoCollectBerries', {Text = 'Auto Collect Berries', Default = false, Callback = function(Value) end})
spawn(function()
	while wait() do
		if Toggles.AutoCollectBerries.Value then
			local BerryBushes = CollectionService:GetTagged("BerryBush")
			local Distance, NearestBush, NearestBerryName

			for i, Bush in ipairs(BerryBushes) do
				for AttributeName, _ in pairs(Bush:GetAttributes()) do
					local Magnitude = (Bush.Parent:GetPivot().Position - plr.Character.HumanoidRootPart.Position).Magnitude
					if Magnitude < Distance then
						Distance = Magnitude
						NearestBush = Bush
						NearestBerryName = AttributeName
					end
				end
			end

			if NearestBush and NearestBerryName then
				local BushModel = NearestBush.Parent
				local BushCenter = BushModel:GetPivot().Position

				Tween(BushCenter)

				local BerryPart = BushModel:FindFirstChild(NearestBerryName)
				if BerryPart and BerryPart:IsA("BasePart") then
					Tween(BerryPart.Position)
					VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
					wait()
					VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
				end
			else
				if Toggles.BerryHop.Value then
					serverHop()
				end
			end
		end
	end
end)

AutoCollect:AddToggle('BerryESP', {Text = 'Berries ESP', Default = true, Callback = function(Value) end})
Toggles.BerryESP:OnChanged(function()
	Toggle_BerryESP = Toggles.BerryESP.Value
end)
spawn(function()
	while wait(0.1) do
		if Toggle_BerryESP then
			local BerryBushes = CollectionService:GetTagged("BerryBush")
			for i, Bush in pairs(BerryBushes) do
				for AttributeName, Berry in pairs(Bush:GetAttributes()) do
					if Berry then
						if not Bush.Parent:FindFirstChild("BerryESP") then
							local bill = Instance.new("BillboardGui", Bush.Parent)
							bill.Name = "BerryESP"
							bill.AlwaysOnTop = true
							bill.Adornee = Bush.Parent
							bill.Size = UDim2.new(1, 200, 1, 30)

							local name = Instance.new("TextLabel", bill)
							name.FontSize = 'Size14'
							name.Font = Enum.Font.SourceSans
							name.TextWrapped = true
							name.TextYAlignment = 'Top'
							name.Size = UDim2.new(1, 0, 1, 0)
							name.BackgroundTransparency = 1
							name.TextStrokeTransparency = 0.5
							name.TextColor3 = Color3.fromRGB(255, 255, 255)
						else
							if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
								local dis = math.floor((plr.Character.HumanoidRootPart.Position - Bush.Parent:GetPivot().Position).Magnitude / Meters)
								Bush.Parent.BerryESP.TextLabel.Text = Berry .. "\n" .. dis .. "M"
							end
						end
					else
						if Bush.Parent:FindFirstChild("BerryESP") then
							Bush.Parent:FindFirstChild("BerryESP"):Destroy()
						end
					end
				end
			end
		end
	end
end)

-- Servers GroupBox
local Servers = Tabs.Main:AddRightGroupbox('Servers')

Servers:AddButton({Text = 'Travel to First Sea', Func = function()
	CommF_:InvokeServer('TravelMain')
end})
Servers:AddButton({Text = 'Travel to Second Sea', Func = function()
	CommF_:InvokeServer('TravelDressrosa')
end})
Servers:AddButton({Text = 'Travel to Third Sea', Func = function()
	CommF_:InvokeServer('TravelZou')
end})

Servers:AddButton({Text = 'Server Hop', Func = function() serverHop() end})

Servers:AddButton({Text = 'Rejoin', Func = function()
	TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
end})

Servers:AddSlider('AutoHopTimer', {Text = 'AutoHop Timer (Minutes)', Default = 30, Min = 1, Max = 240, Rounding = 0, Compact = false, Callback = function(Value) end})
Servers:AddToggle('AutoHop', {Text = 'Auto Hop', Default = true, Callback = function(Value) end})
spawn(function()
	while wait() do
		if Toggles.AutoHop.Value then
			if Timer >= (Options.AutoHopTimer.Value * 60) then
				while wait() do
					elapsed = math.floor(tick() - Timer)
					if elapsed >= (Options.AutoHopTimer.Value * 60) then
						serverHop()
						wait(3)
					end
				end
			end
		end
	end
end)

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

-- Fruits GroupBox
local Fruits = Tabs.Main:AddRightGroupbox('Fruits')
Fruits:AddToggle('DevilFruitESP', {Text = 'Devil Fruits ESP', Default = true, Callback = function(Value) end})
spawn(function()
	while wait() do
		if Toggles.DevilFruitESP.Value then
			pcall(function()
				for i, v in pairs(workspace:GetChildren()) do
					if v:IsA("Tool") then
						if v:FindFirstChild("Handle") then
							repeat wait(0.1)
								if not v.Handle:FindFirstChild("DevilFruitESP") then
									local BillboardGui = Instance.new("BillboardGui")
									local TextLabel = Instance.new("TextLabel")

									BillboardGui.Parent = v.Handle
									BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
									BillboardGui.Active = true
									BillboardGui.Name = "DevilFruitESP"
									BillboardGui.AlwaysOnTop = true
									BillboardGui.LightInfluence = 1
									BillboardGui.Size = UDim2.new(0, 200, 0, 50)
									BillboardGui.StudsOffset = Vector3.new(0, 2, 0)

									TextLabel.Parent = BillboardGui
									TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
									TextLabel.BackgroundTransparency = 1
									TextLabel.Size = UDim2.new(0, 200, 0, 50)
									TextLabel.Font = Enum.Font.GothamBold
									TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
									TextLabel.FontSize = "Size14"
									TextLabel.TextStrokeTransparency = 0
								end
								local Dis = math.floor((plr.Character.HumanoidRootPart.Position - v.Handle.Position).Magnitude)
								v.Handle.DevilFruitESP.TextLabel.Text = v.Name.."\n"..Dis.." M."
							until not Toggles.DevilFruitESP.Value
						end
					end
				end
			end)
		else
			for i,v in pairs(workspace:GetChildren()) do
				if string.find(v.Name, "Fruit") then
					if v:FindFirstChild("Handle") then
						if v.Handle:FindFirstChild("DevilFruitESP") then
							v.Handle.DevilFruitESP:Destroy()
						end
					end
				end
			end
		end
	end
end)
Fruits:AddToggle('AutoFruit', {Text = 'Auto Collect Fruits', Default = false, Callback = function(Value) end})
spawn(function()
	while wait(1) do
		if Toggles.AutoFruit.Value then
			pcall(function()
				for i,v in pairs(workspace:GetChildren()) do
					if v.Name:find('Fruit') and v:IsA('Tool') then
						v.Handle.CFrame = plr.Character.HumanoidRootPart.CFrame
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
				Tween(Fruit)
			end
		end
	end
end)

Fruits:AddToggle('BuyRandomFruit', {Text = 'Auto Buy Random Fruit', Default = false, Callback = function(Value) end})
spawn(function()
	while wait(1) do
		if Toggles.BuyRandomFruit.Value then
			CommF_:InvokeServer("Cousin","Buy")
		end
	end
end)

Fruits:AddToggle('FruitNotify', {Text = 'Fruit Spawn Notify', Default = true, Callback = function(Value) end})
spawn(function()
	while wait(1) do
		if Toggles.FruitNotify.Value then
			for i, v in workspace:GetChildren() do
				if v.Name:find('Fruit') and v:IsA('Tool') then
					print('2017: ', v.Name)
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
			end
		end
	end
end)

Fruits:AddToggle('StoreFruit', {Text = 'Auto Store Fruit', Default = false, Callback = function(Value) end})
local function StoreFruite(name_1, name_2)
	local Character = plr.Character
	local Backpack = plr.Backpack
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
	while wait(1) do
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

-- Local Player Tab
local LocalPlayerGroupBox = Tabs.Player:AddLeftGroupbox('Local Player')

LocalPlayerGroupBox:AddDropdown('Team', {Values = {'Pirates', 'Marines'}, Default = 1, Multi = false, Text = 'Team', Callback = function(Value) end})
Options.Team:OnChanged(function()
	SelectedTeam = Options.Team.Value
end)

LocalPlayerGroupBox:AddButton({Text = 'Change Team', Func = function()
	if SelectedTeam == 'Pirates' then
		CommF_:InvokeServer('SetTeam', 'Pirates')
	elseif SelectedTeam == 'Marines' then
		CommF_:InvokeServer('SetTeam', 'Marines')
	end
end})

-- could be inside the loop but it may lag or whatever
LocalPlayerGroupBox:AddButton({Text = 'Remove Fog', Func = function()
	Lighting.FogStart = Lighting.FogStart * 100
	Lighting.FogEnd = Lighting.FogEnd * 100

	for i, v in pairs(Lighting:GetDescendants()) do
		if v:IsA('Atmosphere') then
			v:Destroy()
		end
	end
end})

LocalPlayerGroupBox:AddButton({Text = 'Stop Camera Shake', Func = function()
	local CameraShaker = require(ReplicatedStorage.Util.CameraShaker)
	CameraShaker:Stop()
end})

LocalPlayerGroupBox:AddToggle('WalkOnWater', {Text = 'Walk on Water', Default = true, Callback = function(Value) end})
Toggles.WalkOnWater:OnChanged(function()
	if Toggles.WalkOnWater.Value then
		workspace.Map['WaterBase-Plane'].Size = Vector3.new(1000,112,1000)
	else
		workspace.Map['WaterBase-Plane'].Size = Vector3.new(1000,80,1000)
	end
end)

LocalPlayerGroupBox:AddToggle('ChangeDashLength', {Text = 'Change Dash Length', Default = false, Callback = function(Value) end})

local dDash = plr.Character:GetAttribute('DashLength')
local DashDepbox = LocalPlayerGroupBox:AddDependencyBox()
DashDepbox:AddSlider('DashLength', {Text = 'Dash Length', Default = dDash, Min = 0, Max = 500, Rounding = 0, Compact = false, Callback = function(Value) end})
Options.DashLength:OnChanged(function()
	plr.Character:SetAttribute('DashLength', Options.DashLength.Value)
	plr.Character:SetAttribute('DashLengthAir', Options.DashLength.Value)
end)

DashDepbox:SetupDependencies({
	{ Toggles.ChangeDashLength, true }
})

LocalPlayerGroupBox:AddToggle('NoFlashstepCooldown', {Text = 'No Flashstep Cooldown', Default = false, Callback = function(Value) end})
LocalPlayerGroupBox:AddToggle('InfiniteGeppo', {Text = 'Unlimited Air Jumps', Default = false, Callback = function(Value) end})
LocalPlayerGroupBox:AddToggle('InfiniteEnergy', {Text = 'Unlimited Energy', Default = false, Callback = function(Value) end})
LocalPlayerGroupBox:AddToggle('DelKenBlur', {Text = 'Remove Instinct Blur', Default = false, Callback = function(Value) end})
LocalPlayerGroupBox:AddToggle('UnlimitedZoom', {Text = 'Zoom Distance', Default = false, Callback = function(Value) end})
LocalPlayerGroupBox:AddToggle('AutoInstinct', {Text = 'Auto Instinct', Default = false, Callback = function(Value) end})
LocalPlayerGroupBox:AddToggle('FarInstinct', {Text = 'Far Instinct', Default = false, Callback = function(Value) end})
LocalPlayerGroupBox:AddToggle('NoclipCam', {Text = 'Noclip Camera', Default = false, Callback = function(Value) end})
LocalPlayerGroupBox:AddToggle('AutoRaceV3', {Text = 'Auto Race V3', Default = false, Callback = function(Value) end})
LocalPlayerGroupBox:AddToggle('AutoAura', {Text = 'Auto Aura', Default = false, Callback = function(Value) end})
LocalPlayerGroupBox:AddToggle('Noclip', {Text = 'Noclip', Default = false, Callback = function(Value) end})

local dZoom = plr.CameraMaxZoomDistance
spawn(function() -- start of update
	while wait(0.1) do
		-- Flashstep Cooldown
		if Toggles.NoFlashstepCooldown.Value then
			plr.Character:SetAttribute('FlashstepCooldown', 1)
		else
			plr.Character:SetAttribute('FlashstepCooldown', 0)
		end

		-- Infinite Energy
		if Toggles.InfiniteEnergy.Value then
			local Energy = plr.Character:FindFirstChild('Energy')
			Energy.Value = Energy.MaxValue
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

		-- Unlimited Zoom
		if Toggles.UnlimitedZoom.Value then
			plr.CameraMaxZoomDistance = dZoom * 100
		else
			plr.CameraMaxZoomDistance = dZoom
		end

		-- Auto Instinct
		if Toggles.AutoInstinct.Value then
			local KenActive = plr:GetAttribute('KenActive')
			if not KenActive then
				VirtualInputManager:SendKeyEvent(true, "E", false, game)
				wait()
				VirtualInputManager:SendKeyEvent(false, "E", false, game)
			end
		end

		-- Far Instinct
		if Toggles.FarInstinct.Value then
			plr.Character:SetAttribute('KenRange', math.huge)
		end

		-- Auto Race V3
		if Toggles.AutoRaceV3.Value then
			VirtualInputManager:SendKeyEvent(true, "T", false, game)
			wait()
			VirtualInputManager:SendKeyEvent(false, "T", false, game)
		end

		-- Noclip Camera
		if Toggles.NoclipCam.Value then
			plr.DevCameraOcclusionMode = 'Invisicam'
		else
			plr.DevCameraOcclusionMode = 'Zoom'
		end

		-- Auto Aura
		if Toggles.AutoAura.Value then
			local HasBuso = plr.Character:FindFirstChild('HasBuso')
			if not HasBuso then
				CommF_:InvokeServer('Buso')
			end
		end

		-- Noclip
		if Toggles.Noclip.Value then
			for i, v in pairs(plr.Character:GetDescendants()) do
				if v:IsA("BasePart") and v.CanCollide == true then
					v.CanCollide = false
				end
			end
		else
			for i, v in pairs(plr.Character:GetDescendants()) do
				if v:IsA('BasePart') and v.CanCollide == false then
					v.CanCollide = true
				end
			end
		end
	end

	if Toggles.InfiniteGeppo.Value then
		pcall(function()
			for i, func in next, getgc(true) do
				if type(func) == 'function' and getfenv(func).script == plr.Character:FindFirstChild('Geppo') then
					for index, upvalue in next, getupvalues(func) do
						if type(upvalue) == 'number' and upvalue == 0 then
							setupvalue(func, index, 0)
						end
					end
				end
			end
		end)
	end -- end of update
end)

print('past localplayer tab 😰')

-- Auto Farm Tab
local function CheckLevel()
	local Lv = plr.Data.Level.Value
	if First_Sea then
		if Lv == 1 or Lv <= 9 or SelectedMonster == "Bandit [Lv. 5]" then
			EnemyName = "Bandit"
			NameQuest = "BanditQuest1"
			QuestLv = 1
			CFrameQuest = CFrame.new(1060, 16, 1547)
			CFrameMonster = CFrame.new(1038, 41, 1576)
		elseif Lv == 10 or Lv <= 14 or SelectedMonster == "Monkey [Lv. 14]" then
			EnemyName = "Monkey"
			NameQuest = "JungleQuest"
			QuestLv = 1
			CFrameQuest = CFrame.new(-1601, 36, 153)
			CFrameMonster = CFrame.new(-1448, 50, 63)
		elseif Lv == 15 or Lv <= 29 or SelectedMonster == "Gorilla [Lv. 20]" then
			EnemyName = "Gorilla"
			NameQuest = "JungleQuest"
			QuestLv = 2
			CFrameQuest = CFrame.new(-1601, 36, 153)
			CFrameMonster = CFrame.new(-1142, 40, -515)
		elseif Lv == 30 or Lv <= 39 or SelectedMonster == "Pirate [Lv. 35]" then
			EnemyName = "Pirate"
			NameQuest = "BuggyQuest1"
			QuestLv = 1
			CFrameQuest = CFrame.new(-1140, 4, 3827)
			CFrameMonster = CFrame.new(-1201, 40, 3857)
		elseif Lv == 40 or Lv <= 59 or SelectedMonster == "Brute [Lv. 45]" then
			EnemyName = "Brute"
			NameQuest = "BuggyQuest1"
			QuestLv = 2
			CFrameQuest = CFrame.new(-1140, 4, 3827)
			CFrameMonster = CFrame.new(-1387, 24, 4100)
		elseif Lv == 60 or Lv <= 74 or SelectedMonster == "Desert Bandit [Lv. 60]" then
			EnemyName = "Desert Bandit"
			NameQuest = "DesertQuest"
			QuestLv = 1
			CFrameQuest = CFrame.new(896, 6, 4390)
			CFrameMonster = CFrame.new(984, 16, 4417)
		elseif Lv == 75 or Lv <= 89 or SelectedMonster == "Desert Officer [Lv. 70]" then
			EnemyName = "Desert Officer"
			NameQuest = "DesertQuest"
			QuestLv = 2
			CFrameQuest = CFrame.new(896, 6, 4390)
			CFrameMonster = CFrame.new(1547, 14, 4381)
		elseif Lv == 90 or Lv <= 99 or SelectedMonster == "Snow Bandit [Lv. 90]" then
			EnemyName = "Snow Bandit"
			NameQuest = "SnowQuest"
			QuestLv = 1
			CFrameQuest = CFrame.new(1386, 87, -1298)
			CFrameMonster = CFrame.new(1356, 105, -1328)
		elseif Lv == 100 or Lv <= 119 or SelectedMonster == "Snowman [Lv. 100]" then
			EnemyName = "Snowman"
			NameQuest = "SnowQuest"
			QuestLv = 2
			CFrameQuest = CFrame.new(1386, 87, -1298)
			CFrameMonster = CFrame.new(1218, 138, -1488)
		elseif Lv == 120 or Lv <= 149 or SelectedMonster == "Chief Petty Officer [Lv. 120]" then
			EnemyName = "Chief Petty Officer"
			NameQuest = "MarineQuest2"
			QuestLv = 1
			CFrameQuest = CFrame.new(-5035, 28, 4324)
			CFrameMonster = CFrame.new(-4931, 65, 4121)
		elseif Lv == 150 or Lv <= 174 or SelectedMonster == "Sky Bandit [Lv. 150]" then
			EnemyName = "Sky Bandit"
			NameQuest = "SkyQuest"
			QuestLv = 1
			CFrameQuest = CFrame.new(-4842, 717, -2623)
			CFrameMonster = CFrame.new(-4955, 365, -2908)
		elseif Lv == 175 or Lv <= 189 or SelectedMonster == "Dark Master [Lv. 175]" then
			EnemyName = "Dark Master"
			NameQuest = "SkyQuest"
			QuestLv = 2
			CFrameQuest = CFrame.new(-4842, 717, -2623)
			CFrameMonster = CFrame.new(-5148, 439, -2332)
		elseif Lv == 190 or Lv <= 209 or SelectedMonster == "Prisoner [Lv. 190]" then
			EnemyName = "Prisoner"
			NameQuest = "PrisonerQuest"
			QuestLv = 1
			CFrameQuest = CFrame.new(5310, 0, 474)
			CFrameMonster = CFrame.new(4937, 0, 649)
		elseif Lv == 210 or Lv <= 249 or SelectedMonster == "Dangerous Prisoner [Lv. 210]" then
			EnemyName = "Dangerous Prisoner"
			NameQuest = "PrisonerQuest"
			QuestLv = 2
			CFrameQuest = CFrame.new(5310, 0, 474)
			CFrameMonster = CFrame.new(5099, 0, 1055)
		elseif Lv == 250 or Lv <= 274 or SelectedMonster == "Toga Warrior [Lv. 250]" then
			EnemyName = "Toga Warrior"
			NameQuest = "ColosseumQuest"
			QuestLv = 1
			CFrameQuest = CFrame.new(-1577, 7, -2984)
			CFrameMonster = CFrame.new(-1872, 49, -2913)
		elseif Lv == 275 or Lv <= 299 or SelectedMonster == "Gladiator [Lv. 275]" then
			EnemyName = "Gladiator"
			NameQuest = "ColosseumQuest"
			QuestLv = 2
			CFrameQuest = CFrame.new(-1577, 7, -2984)
			CFrameMonster = CFrame.new(-1521, 81, -3066)
		elseif Lv == 300 or Lv <= 324 or SelectedMonster == "Military Soldier [Lv. 300]" then
			EnemyName = "Military Soldier"
			NameQuest = "MagmaQuest"
			QuestLv = 1
			CFrameQuest = CFrame.new(-5316, 12, 8517)
			CFrameMonster = CFrame.new(-5369, 61, 8556)
		elseif Lv == 325 or Lv <= 374 or SelectedMonster == "Military Spy [Lv. 325]" then
			EnemyName = "Military Spy"
			NameQuest = "MagmaQuest"
			QuestLv = 2
			CFrameQuest = CFrame.new(-5316, 12, 8517)
			CFrameMonster = CFrame.new(-5787, 75, 8651)
		elseif Lv == 375 or Lv <= 399 or SelectedMonster == "Fishman Warrior [Lv. 375]" then
			EnemyName = "Fishman Warrior"
			NameQuest = "FishmanQuest"
			QuestLv = 1
			CFrameQuest = CFrame.new(61122, 18, 1569)
			CFrameMonster = CFrame.new(60844, 98, 1298)
			if (LevelFarmQuest or LevelFarmNoQuest or SelectMonster_Quest_Farm or SelectMonster_NoQuest_Farm or DevilMastery_Farm) and (CFrameMonster.Position - plr.Character.HumanoidRootPart.Position).Magnitude > 3000 then
				CommF_:InvokeServer("requestEntrance",Vector3.new(61163, 11, 1819))
			end
		elseif Lv == 400 or Lv <= 449 or SelectedMonster == "Fishman Commando [Lv. 400]" then
			EnemyName = "Fishman Commando"
			NameQuest = "FishmanQuest"
			QuestLv = 2
			CFrameQuest = CFrame.new(61122, 18, 1569)
			CFrameMonster = CFrame.new(61738, 64, 1433)
			if (LevelFarmQuest or LevelFarmNoQuest or SelectMonster_Quest_Farm or SelectMonster_NoQuest_Farm or DevilMastery_Farm) and (CFrameMonster.Position - plr.Character.HumanoidRootPart.Position).Magnitude > 3000 then
				CommF_:InvokeServer("requestEntrance",Vector3.new(61163, 11, 1819))
			end
		elseif Lv == 450 or Lv <= 474 or SelectedMonster == "God's Guard [Lv. 450]" then
			EnemyName = "God's Guard"
			NameQuest = "SkyExp1Quest"
			QuestLv = 1
			CFrameQuest = CFrame.new(-4721, 845, -1953)
			CFrameMonster = CFrame.new(-4628, 866, -1931)
			if (LevelFarmQuest or LevelFarmNoQuest or SelectMonster_Quest_Farm or SelectMonster_NoQuest_Farm or DevilMastery_Farm) and (CFrameMonster.Position - plr.Character.HumanoidRootPart.Position).Magnitude > 3000 then
				CommF_:InvokeServer("requestEntrance",Vector3.new(-4607, 872, -1667))
			end
		elseif Lv == 475 or Lv <= 524 or SelectedMonster == "Shanda [Lv. 475]" then
			EnemyName = "Shanda"
			NameQuest = "SkyExp1Quest"
			QuestLv = 2
			CFrameQuest = CFrame.new(-7863, 5545, -378)
			CFrameMonster = CFrame.new(-7685, 5601, -441)
			if (LevelFarmQuest or LevelFarmNoQuest or SelectMonster_Quest_Farm or SelectMonster_NoQuest_Farm or DevilMastery_Farm) and (CFrameMonster.Position - plr.Character.HumanoidRootPart.Position).Magnitude > 3000 then
				CommF_:InvokeServer("requestEntrance",Vector3.new(-7894, 5547, -380))
			end
		elseif Lv == 525 or Lv <= 549 or SelectedMonster == "Royal Squad [Lv. 525]" then
			EnemyName = "Royal Squad"
			NameQuest = "SkyExp2Quest"
			QuestLv = 1
			CFrameQuest = CFrame.new(-7903, 5635, -1410)
			CFrameMonster = CFrame.new(-7654, 5637, -1407)
		elseif Lv == 550 or Lv <= 624 or SelectedMonster == "Royal Soldier [Lv. 550]" then
			EnemyName = "Royal Soldier"
			NameQuest = "SkyExp2Quest"
			QuestLv = 2
			CFrameQuest = CFrame.new(-7903, 5635, -1410)
			CFrameMonster = CFrame.new(-7760, 5679, -1884)
		elseif Lv == 625 or Lv <= 649 or SelectedMonster == "Galley Pirate [Lv. 625]" then
			EnemyName = "Galley Pirate"
			NameQuest = "FountainQuest"
			QuestLv = 1
			CFrameQuest = CFrame.new(5258, 38, 4050)
			CFrameMonster = CFrame.new(5557, 152, 3998)
		elseif Lv >= 650 or SelectedMonster == "Galley Captain [Lv. 650]" then
			EnemyName = "Galley Captain"
			NameQuest = "FountainQuest"
			QuestLv = 2
			CFrameQuest = CFrame.new(5258, 38, 4050)
			CFrameMonster = CFrame.new(5677, 92, 4966)
		end
	end
	if SecondSea then
		if Lv == 700 or Lv <= 724 or SelectedMonster == "Raider [Lv. 700]" then
			EnemyName = "Raider"
			NameQuest = "Area1Quest"
			QuestLv = 1
			CFrameQuest = CFrame.new(-427, 72, 1835)
			CFrameMonster = CFrame.new(68, 93, 2429)
		elseif Lv == 725 or Lv <= 774 or SelectedMonster == "Mercenary [Lv. 725]" then
			EnemyName = "Mercenary"
			NameQuest = "Area1Quest"
			QuestLv = 2
			CFrameQuest = CFrame.new(-427, 72, 1835)
			CFrameMonster = CFrame.new(-864, 122, 1453)
		elseif Lv == 775 or Lv <= 799 or SelectedMonster == "Swan Pirate [Lv. 775]" then
			EnemyName = "Swan Pirate"
			NameQuest = "Area2Quest"
			QuestLv = 1
			CFrameQuest = CFrame.new(635, 73, 917)
			CFrameMonster = CFrame.new(1065, 137, 1324)
		elseif Lv == 800 or Lv <= 874 or SelectedMonster == "Factory Staff [Lv. 800]" then
			EnemyName = "Factory Staff"
			NameQuest = "Area2Quest"
			QuestLv = 2
			CFrameQuest = CFrame.new(635, 73, 917)
			CFrameMonster = CFrame.new(533, 128, 355)
		elseif Lv == 875 or Lv <= 899 or SelectedMonster == "Marine Lieutenant [Lv. 875]" then
			EnemyName = "Marine Lieutenant"
			NameQuest = "MarineQuest3"
			QuestLv = 1
			CFrameQuest = CFrame.new(-2440, 73, -3217)
			CFrameMonster = CFrame.new(-2489, 84, -3151)
		elseif Lv == 900 or Lv <= 949 or SelectedMonster == "Marine Captain [Lv. 900]" then
			EnemyName = "Marine Captain"
			NameQuest = "MarineQuest3"
			QuestLv = 2
			CFrameQuest = CFrame.new(-2440, 73, -3217)
			CFrameMonster = CFrame.new(-2335, 79, -3245)
		elseif Lv == 950 or Lv <= 974 or SelectedMonster == "Zombie [Lv. 950]" then
			EnemyName = "Zombie"
			NameQuest = "ZombieQuest"
			QuestLv = 1
			CFrameQuest = CFrame.new(-5494, 48, -794)
			CFrameMonster = CFrame.new(-5536, 101, -835)
		elseif Lv == 975 or Lv <= 999 or SelectedMonster == "Vampire [Lv. 975]" then
			EnemyName = "Vampire"
			NameQuest = "ZombieQuest"
			QuestLv = 2
			CFrameQuest = CFrame.new(-5494, 48, -794)
			CFrameMonster = CFrame.new(-5806, 16, -1164)
		elseif Lv == 1000 or Lv <= 1049 or SelectedMonster == "Snow Trooper [Lv. 1000]" then
			EnemyName = "Snow Trooper"
			NameQuest = "SnowMountainQuest"
			QuestLv = 1
			CFrameQuest = CFrame.new(607, 401, -5370)
			CFrameMonster = CFrame.new(535, 432, -5484)
		elseif Lv == 1050 or Lv <= 1099 or SelectedMonster == "Winter Warrior [Lv. 1050]" then
			EnemyName = "Winter Warrior"
			NameQuest = "SnowMountainQuest"
			QuestLv = 2
			CFrameQuest = CFrame.new(607, 401, -5370)
			CFrameMonster = CFrame.new(1234, 456, -5174)
		elseif Lv == 1100 or Lv <= 1124 or SelectedMonster == "Lab Subordinate [Lv. 1100]" then
			EnemyName = "Lab Subordinate"
			NameQuest = "IceSideQuest"
			QuestLv = 1
			CFrameQuest = CFrame.new(-6061, 15, -4902)
			CFrameMonster = CFrame.new(-5720, 63, -4784)
		elseif Lv == 1125 or Lv <= 1174 or SelectedMonster == "Horned Warrior [Lv. 1125]" then
			EnemyName = "Horned Warrior"
			NameQuest = "IceSideQuest"
			QuestLv = 2
			CFrameQuest = CFrame.new(-6061, 15, -4902)
			CFrameMonster = CFrame.new(-6292, 91, -5502)
		elseif Lv == 1175 or Lv <= 1199 or SelectedMonster == "Magma Ninja [Lv. 1175]" then
			EnemyName = "Magma Ninja"
			NameQuest = "FireSideQuest"
			QuestLv = 1
			CFrameQuest = CFrame.new(-5429, 15, -5297)
			CFrameMonster = CFrame.new(-5461, 130, -5836)
		elseif Lv == 1200 or Lv <= 1249 or SelectedMonster == "Lava Pirate [Lv. 1200]" then
			EnemyName = "Lava Pirate"
			NameQuest = "FireSideQuest"
			QuestLv = 2
			CFrameQuest = CFrame.new(-5429, 15, -5297)
			CFrameMonster = CFrame.new(-5251, 55, -4774)
		elseif Lv == 1250 or Lv <= 1274 or SelectedMonster == "Ship Deckhand [Lv. 1250]" then
			EnemyName = "Ship Deckhand"
			NameQuest = "ShipQuest1"
			QuestLv = 1
			CFrameQuest = CFrame.new(1040, 125, 32911)
			CFrameMonster = CFrame.new(921, 125, 33088)
			if (LevelFarmQuest or LevelFarmNoQuest or SelectMonster_Quest_Farm or SelectMonster_NoQuest_Farm or DevilMastery_Farm) and (CFrameMonster.Position - plr.Character.HumanoidRootPart.Position).Magnitude > 20000 then
				CommF_:InvokeServer("requestEntrance",Vector3.new(923, 126, 32852))
			end
		elseif Lv == 1275 or Lv <= 1299 or SelectedMonster == "Ship Engineer [Lv. 1275]" then
			EnemyName = "Ship Engineer"
			NameQuest = "ShipQuest1"
			QuestLv = 2
			CFrameQuest = CFrame.new(1040, 125, 32911)
			CFrameMonster = CFrame.new(886, 40, 32800)
			if (LevelFarmQuest or LevelFarmNoQuest or SelectMonster_Quest_Farm or SelectMonster_NoQuest_Farm or DevilMastery_Farm) and (CFrameMonster.Position - plr.Character.HumanoidRootPart.Position).Magnitude > 20000 then
				CommF_:InvokeServer("requestEntrance",Vector3.new(923, 126, 32852))
			end
		elseif Lv == 1300 or Lv <= 1324 or SelectedMonster == "Ship Steward [Lv. 1300]" then
			EnemyName = "Ship Steward"
			NameQuest = "ShipQuest2"
			QuestLv = 1
			CFrameQuest = CFrame.new(971, 125, 33245)
			CFrameMonster = CFrame.new(943, 129, 33444)
			if (LevelFarmQuest or LevelFarmNoQuest or SelectMonster_Quest_Farm or SelectMonster_NoQuest_Farm or DevilMastery_Farm) and (CFrameMonster.Position - plr.Character.HumanoidRootPart.Position).Magnitude > 20000 then
				CommF_:InvokeServer("requestEntrance",Vector3.new(923, 126, 32852))
			end
		elseif Lv == 1325 or Lv <= 1349 or SelectedMonster == "Ship Officer [Lv. 1325]" then
			EnemyName = "Ship Officer"
			NameQuest = "ShipQuest2"
			QuestLv = 2
			CFrameQuest = CFrame.new(971, 125, 33245)
			CFrameMonster = CFrame.new(955, 181, 33331)
			if (LevelFarmQuest or LevelFarmNoQuest or SelectMonster_Quest_Farm or SelectMonster_NoQuest_Farm or DevilMastery_Farm) and (CFrameMonster.Position - plr.Character.HumanoidRootPart.Position).Magnitude > 20000 then
				CommF_:InvokeServer("requestEntrance",Vector3.new(923, 126, 32852))
			end
		elseif Lv == 1350 or Lv <= 1374 or SelectedMonster == "Arctic Warrior [Lv. 1350]" then
			EnemyName = "Arctic Warrior"
			NameQuest = "FrostQuest"
			QuestLv = 1
			CFrameQuest = CFrame.new(5668, 28, -6484)
			CFrameMonster = CFrame.new(5935, 77, -6472)
			if (LevelFarmQuest or LevelFarmNoQuest or SelectMonster_Quest_Farm or SelectMonster_NoQuest_Farm or DevilMastery_Farm) and (CFrameMonster.Position - plr.Character.HumanoidRootPart.Position).Magnitude > 20000 then
				CommF_:InvokeServer("requestEntrance",Vector3.new(-6508, 89, -132))
			end
		elseif Lv == 1375 or Lv <= 1424 or SelectedMonster == "Snow Lurker [Lv. 1375]" then
			EnemyName = "Snow Lurker"
			NameQuest = "FrostQuest"
			QuestLv = 2
			CFrameQuest = CFrame.new(5668, 28, -6484)
			CFrameMonster = CFrame.new(5628, 57, -6618)
		elseif Lv == 1425 or Lv <= 1449 or SelectedMonster == "Sea Soldier [Lv. 1425]" then
			EnemyName = "Sea Soldier"
			NameQuest = "ForgottenQuest"
			QuestLv = 1
			CFrameQuest = CFrame.new(-3054, 236, -10147)
			CFrameMonster = CFrame.new(-3185, 58, -9663)
		elseif Lv >= 1450 or SelectedMonster == "Water Fighter [Lv. 1450]" then
			EnemyName = "Water Fighter"
			NameQuest = "ForgottenQuest"
			QuestLv = 2
			CFrameQuest = CFrame.new(-3054, 236, -10147)
			CFrameMonster = CFrame.new(-3262, 298, -10552)
		end
	end
	if ThirdSea then
		if Lv == 1500 or Lv <= 1524 or SelectedMonster == "Pirate Millionaire [Lv. 1500]" then
			EnemyName = "Pirate Millionaire"
			NameQuest = "PiratePortQuest"
			QuestLv = 1
			CFrameQuest = CFrame.new(-289, 43, 5580)
			CFrameMonster = CFrame.new(-435, 189, 5551)
		elseif Lv == 1525 or Lv <= 1574 or SelectedMonster == "Pistol Billionaire [Lv. 1525]" then
			EnemyName = "Pistol Billionaire"
			NameQuest = "PiratePortQuest"
			QuestLv = 2
			CFrameQuest = CFrame.new(-289, 43, 5580)
			CFrameMonster = CFrame.new(-236, 217, 6006)
		elseif Lv == 1575 or Lv <= 1599 or SelectedMonster == "Dragon Crew Warrior [Lv. 1575]" then
			EnemyName = "Dragon Crew Warrior"
			NameQuest = "DragonCrewQuest"
			QuestLv = 1
			CFrameQuest = CFrame.new(6735, 126, -711)
			CFrameMonster = CFrame.new(6301, 104, -1082)
		elseif Lv == 1600 or Lv <= 1624 or SelectedMonster == "Dragon Crew Archer [Lv. 1600]" then
			EnemyName = "Dragon Crew Archer"
			NameQuest = "DragonCrewQuest"
			QuestLv = 2
			CFrameQuest = CFrame.new(6735, 126, -711)
			CFrameMonster = CFrame.new(6831, 441, 446)
		elseif Lv == 1625 or Lv <= 1649 or SelectedMonster == "Hydra Enforcer [Lv. 1625]" then
			EnemyName = "Hydra Enforcer"
			NameQuest = "VenomCrewQuest"
			QuestLv = 1
			CFrameQuest = CFrame.new(5214, 1003, 759)
			CFrameMonster = CFrame.new(5195, 1089, 617)
		elseif Lv == 1650 or Lv <= 1699 or SelectedMonster == "Venomous Assailant [Lv. 1650]" then
			EnemyName = "Venomous Assailant"
			NameQuest = "VenomCrewQuest"
			QuestLv = 2
			CFrameQuest = CFrame.new(5214, 1003, 759)
			CFrameMonster = CFrame.new(5195, 1089, 617)
		elseif Lv == 1700 or Lv <= 1724 or SelectedMonster == "Marine Commodore [Lv. 1700]" then
			EnemyName = "Marine Commodore"
			NameQuest = "MarineTreeIsland"
			QuestLv = 1
			CFrameQuest = CFrame.new(2179, 28, -6740)
			CFrameMonster = CFrame.new(2198, 128, -7109)
		elseif Lv == 1725 or Lv <= 1774 or SelectedMonster == "Marine Rear Admiral [Lv. 1725]" then
			EnemyName = "Marine Rear Admiral"
			NameQuest = "MarineTreeIsland"
			QuestLv = 2
			CFrameQuest = CFrame.new(2179, 28, -6740)
			CFrameMonster = CFrame.new(3294, 385, -7048)
		elseif Lv == 1775 or Lv <= 1799 or SelectedMonster == "Fishman Raider [Lv. 1775]" then
			EnemyName = "Fishman Raider"
			NameQuest = "DeepForestIsland3"
			QuestLv = 1
			CFrameQuest = CFrame.new(-10582, 331, -8757)
			CFrameMonster = CFrame.new(-10553, 521, -8176)
		elseif Lv == 1800 or Lv <= 1824 or SelectedMonster == "Fishman Captain [Lv. 1800]" then
			EnemyName = "Fishman Captain"
			NameQuest = "DeepForestIsland3"
			QuestLv = 2
			CFrameQuest = CFrame.new(-10583, 331, -8759)
			CFrameMonster = CFrame.new(-10789, 427, -9131)
		elseif Lv == 1825 or Lv <= 1849 or SelectedMonster == "Forest Pirate [Lv. 1825]" then
			EnemyName = "Forest Pirate"
			NameQuest = "DeepForestIsland"
			QuestLv = 1
			CFrameQuest = CFrame.new(-13232, 332, -7626)
			CFrameMonster = CFrame.new(-13489, 400, -7770)
		elseif Lv == 1850 or Lv <= 1899 or SelectedMonster == "Mythological Pirate [Lv. 1850]" then
			EnemyName = "Mythological Pirate"
			NameQuest = "DeepForestIsland"
			QuestLv = 2
			CFrameQuest = CFrame.new(-13232, 332, -7626)
			CFrameMonster = CFrame.new(-13508, 582, -6985)
		elseif Lv == 1900 or Lv <= 1924 or SelectedMonster == "Jungle Pirate [Lv. 1900]" then
			EnemyName = "Jungle Pirate"
			NameQuest = "DeepForestIsland2"
			QuestLv = 1
			CFrameQuest = CFrame.new(-12682, 390, -9902)
			CFrameMonster = CFrame.new(-12267, 459, -10277)
		elseif Lv == 1925 or Lv <= 1974 or SelectedMonster == "Musketeer Pirate [Lv. 1925]" then
			EnemyName = "Musketeer Pirate"
			NameQuest = "DeepForestIsland2"
			QuestLv = 2
			CFrameQuest = CFrame.new(-12682, 390, -9902)
			CFrameMonster = CFrame.new(-13291, 520, -9904)
		elseif Lv == 1975 or Lv <= 1999 or SelectedMonster == "Reborn Skeleton [Lv. 1975]" then
			EnemyName = "Reborn Skeleton"
			NameQuest = "HauntedQuest1"
			QuestLv = 1
			CFrameQuest = CFrame.new(-9480, 142, 5566)
			CFrameMonster = CFrame.new(-8761, 183, 6168)
		elseif Lv == 2000 or Lv <= 2024 or SelectedMonster == "Living Zombie [Lv. 2000]" then
			EnemyName = "Living Zombie"
			NameQuest = "HauntedQuest1"
			QuestLv = 2
			CFrameQuest = CFrame.new(-9480, 142, 5566)
			CFrameMonster = CFrame.new(-10103, 238, 6179)
		elseif Lv == 2025 or Lv <= 2049 or SelectedMonster == "Demonic Soul [Lv. 2025]" then
			EnemyName = "Demonic Soul"
			NameQuest = "HauntedQuest2"
			QuestLv = 1
			CFrameQuest = CFrame.new(-9516, 178, 6078)
			CFrameMonster = CFrame.new(-9712, 204, 6193)
		elseif Lv == 2050 or Lv <= 2074 or SelectedMonster == "Posessed Mummy [Lv. 2050]" then
			EnemyName = "Posessed Mummy"
			NameQuest = "HauntedQuest2"
			QuestLv = 2
			CFrameQuest = CFrame.new(-9516, 178, 6078)
			CFrameMonster = CFrame.new(-9545, 69, 6339)
		elseif Lv == 2075 or Lv <= 2099 or SelectedMonster == "Peanut Scout [Lv. 2075]" then
			EnemyName = "Peanut Scout"
			NameQuest = "NutsIslandQuest"
			QuestLv = 1
			CFrameQuest = CFrame.new(-2105, 37, -10195)
			CFrameMonster = CFrame.new(-2150, 122, -10358)
		elseif Lv == 2100 or Lv <= 2124 or SelectedMonster == "Peanut President [Lv. 2100]" then
			EnemyName = "Peanut President"
			NameQuest = "NutsIslandQuest"
			QuestLv = 2
			CFrameQuest = CFrame.new(-2105, 37, -10195)
			CFrameMonster = CFrame.new(-2150, 122, -10358)
		elseif Lv == 2125 or Lv <= 2149 or SelectedMonster == "Ice Cream Chef [Lv. 2125]" then
			EnemyName = "Ice Cream Chef"
			NameQuest = "IceCreamIslandQuest"
			QuestLv = 1
			CFrameQuest = CFrame.new(-819, 64, -10967)
			CFrameMonster = CFrame.new(-789, 209, -11009)
		elseif Lv == 2150 or Lv <= 2199 or SelectedMonster == "Ice Cream Commander [Lv. 2150]" then
			EnemyName = "Ice Cream Commander"
			NameQuest = "IceCreamIslandQuest"
			QuestLv = 2
			CFrameQuest = CFrame.new(-819, 64, -10967)
			CFrameMonster = CFrame.new(-789, 209, -11009)
		elseif Lv == 2200 or Lv <= 2224 or SelectedMonster == "Cookie Crafter [Lv. 2200]" then
			EnemyName = "Cookie Crafter"
			NameQuest = "CakeQuest1"
			QuestLv = 1
			CFrameQuest = CFrame.new(-2022, 36, -12030)
			CFrameMonster = CFrame.new(-2321, 36, -12216)
		elseif Lv == 2225 or Lv <= 2249 or SelectedMonster == "Cake Guard [Lv. 2225]" then
			EnemyName = "Cake Guard"
			NameQuest = "CakeQuest1"
			QuestLv = 2
			CFrameQuest = CFrame.new(-2022, 36, -12030)
			CFrameMonster = CFrame.new(-1418, 36, -12255)
		elseif Lv == 2250 or Lv <= 2274 or SelectedMonster == "Baking Staff [Lv. 2250]" then
			EnemyName = "Baking Staff"
			NameQuest = "CakeQuest2"
			QuestLv = 1
			CFrameQuest = CFrame.new(-1928, 37, -12840)
			CFrameMonster = CFrame.new(-1980, 36, -12983)
		elseif Lv == 2275 or Lv <= 2299 or SelectedMonster == "Head Baker [Lv. 2275]" then
			EnemyName = "Head Baker"
			NameQuest = "CakeQuest2"
			QuestLv = 2
			CFrameQuest = CFrame.new(-1928, 37, -12840)
			CFrameMonster = CFrame.new(-2251, 52, -13033)
		elseif Lv == 2300 or Lv <= 2324 or SelectedMonster == "Cocoa Warrior [Lv. 2300]" then
			EnemyName = "Cocoa Warrior"
			NameQuest ="ChocQuest1"
			QuestLv = 1
			CFrameQuest = CFrame.new(231, 23, -12200)
			CFrameMonster = CFrame.new(167, 26, -12238)
		elseif Lv == 2325 or Lv <= 2349 or SelectedMonster == "Chocolate Bar Battler [Lv. 2325]" then
			EnemyName = "Chocolate Bar Battler"
			NameQuest = "ChocQuest1"
			QuestLv = 2
			CFrameQuest = CFrame.new(231, 23, -12200)
			CFrameMonster = CFrame.new(701, 25, -12708)
		elseif Lv == 2350 or Lv <= 2374 or SelectedMonster == "Sweet Thief [Lv. 2350]" then
			EnemyName = "Sweet Thief"
			NameQuest = "ChocQuest2"
			QuestLv = 1
			CFrameQuest = CFrame.new(151, 23, -12774)
			CFrameMonster = CFrame.new(-140, 25, -12652)
		elseif Lv == 2375 or Lv <= 2400 or SelectedMonster == "Candy Rebel [Lv. 2375]" then
			EnemyName = "Candy Rebel"
			NameQuest = "ChocQuest2"
			QuestLv = 2
			CFrameQuest = CFrame.new(151, 23, -12774)
			CFrameMonster = CFrame.new(47, 25, -13029)
		elseif Lv == 2400 or Lv <= 2424 or SelectedMonster == "Candy Pirate [Lv. 2400]" then
			EnemyName = "Candy Pirate"
			NameQuest = "CandyQuest1"
			QuestLv = 1
			CFrameQuest = CFrame.new(-1149, 13, -14445)
			CFrameMonster = CFrame.new(-1437, 17, -14385)
		elseif Lv == 2425 or Lv <= 2449 or SelectedMonster == "Snow Demon [Lv. 2425]" then
			EnemyName = "Snow Demon"
			NameQuest = "CandyQuest1"
			QuestLv = 2
			CFrameQuest = CFrame.new(-1149, 13, -14445)
			CFrameMonster = CFrame.new(-916, 17, -14638)

		elseif Lv == 2450 or Lv <= 2474 or SelectedMonster == "Isle Outlaw [Lv. 2450]" then
			EnemyName = "Isle Outlaw"
			NameQuest = "TikiQuest1"
			QuestLv = 1
			CFrameQuest = CFrame.new(-16548, 55, -172)
			CFrameMonster = CFrame.new(-16122, 10, -257)
		elseif Lv == 2475 or Lv <= 2499 or SelectedMonster == "Island Boy [2475]" then
			EnemyName = "Island Boy"
			NameQuest = "TikiQuest1"
			QuestLv = 2
			CFrameQuest = CFrame.new(-16548, 55, -172)
			CFrameMonster = CFrame.new(-16736, 20, -131)
		elseif Lv == 2500 or Lv <= 2524 or SelectedMonster == "Sun-kissed Warrior [Lv. 2500]" then
			EnemyName = "Sun-kissed Warrior"
			NameQuest = "TikiQuest2"
			QuestLv = 1
			CFrameQuest = CFrame.new(-16541, 54, 1051)
			CFrameMonster = CFrame.new(-16413, 54, 1054)
		elseif Lv == 2525 or Lv <= 2549 or SelectedMonster == "Isle Champion [Lv. 2525]" then
			EnemyName = "Isle Champion"
			NameQuest = "TikiQuest2"
			QuestLv = 2
			CFrameQuest = CFrame.new(-16541, 54, 1051)
			CFrameMonster = CFrame.new(-16787, 20, 992)
		elseif Lv == 2550 or Lv <= 2574 or SelectedMonster == "Serpent Hunter [Lv. 2550]" then
			EnemyName = "Serpent Hunter"
			NameQuest = "TikiQuest3"
			QuestLv = 1
			CFrameQuest = CFrame.new(-16665, 104, 1579)
			CFrameMonster = CFrame.new(-16654, 105, 1579)
		elseif Lv >= 2575 or SelectedMonster == "Skull Slayer [Lv. 2575]" then
			EnemyName = "Skull Slayer"
			NameQuest = "TikiQuest3"
			QuestLv = 2
			CFrameQuest = CFrame.new(-16665, 104, 1579)
			CFrameMonster = CFrame.new(-16654, 105, 1579)
		end
	end
end

local function CheckBossQuest()
	if FirstSea then
		if SelectBoss == "The Gorilla King" then
			BossMon = "The Gorilla King [Lv. 25] [Boss]"
			NameBoss = 'The Gorrila King'
			NameQuestBoss = "JungleQuest"
			QuestLvBoss = 3
			CFrameQBoss = CFrame.new(-1601, 36, 153)
			CFrameBoss = CFrame.new(-1088, 8, -488)
		elseif SelectBoss == "Bobby" then
			BossMon = "Bobby [Lv. 55] [Boss]"
			NameBoss = 'Bobby'
			NameQuestBoss = "BuggyQuest1"
			QuestLvBoss = 3
			CFrameQBoss = CFrame.new(-1140, 4, 3827)
			CFrameBoss = CFrame.new(-1087, 46, 4040)
		elseif SelectBoss == "The Saw" then
			BossMon = "The Saw [Lv. 100] [Boss]"
			NameBoss = 'The Saw'
			CFrameBoss = CFrame.new(-784, 72, 1603)
		elseif SelectBoss == "Yeti" then
			BossMon = "Yeti [Lv. 110] [Boss]"
			NameBoss = 'Yeti'
			NameQuestBoss = "SnowQuest"
			QuestLvBoss = 3
			CFrameQBoss = CFrame.new(1386, 87, -1298)
			CFrameBoss = CFrame.new(1218, 138, -1488)
		elseif SelectBoss == "Mob Leader" then
			BossMon = "Mob Leader [Lv. 120] [Boss]"
			NameBoss = 'Mob Leader'
			CFrameBoss = CFrame.new(-2844, 7, 5356)
		elseif SelectBoss == "Vice Admiral" then
			BossMon = "Vice Admiral [Lv. 130] [Boss]"
			NameBoss = 'Vice Admiral'
			NameQuestBoss = "MarineQuest2"
			QuestLvBoss = 2
			CFrameQBoss = CFrame.new(-5036, 28, 4324)
			CFrameBoss = CFrame.new(-5006, 88, 4353)
		elseif SelectBoss == "Saber Expert" then
			NameBoss = 'Saber Expert'
			BossMon = "Saber Expert [Lv. 200] [Boss]"
			CFrameBoss = CFrame.new(-1458, 29, -50)
		elseif SelectBoss == "Warden" then
			BossMon = "Warden [Lv. 220] [Boss]"
			NameBoss = 'Warden'
			NameQuestBoss = "ImpelQuest"
			QuestLvBoss = 1
			CFrameBoss = CFrame.new(5278, 2, 944)
			CFrameQBoss= CFrame.new(5191, 2, 686)
		elseif SelectBoss == "Chief Warden" then
			BossMon = "Chief Warden [Lv. 230] [Boss]"
			NameBoss = 'Chief Warden'
			NameQuestBoss = "ImpelQuest"
			QuestLvBoss = 2
			CFrameBoss = CFrame.new(5206, 0, 814)
			CFrameQBoss = CFrame.new(5191, 2, 686)
		elseif SelectBoss == "Swan" then
			BossMon = "Swan [Lv. 240] [Boss]"
			NameBoss = 'Swan'
			NameQuestBoss = "ImpelQuest"
			QuestLvBoss = 3
			CFrameBoss = CFrame.new(5325, 7, 719)
			CFrameQBoss = CFrame.new(5191, 2, 686)
		elseif SelectBoss == "Magma Admiral" then
			BossMon = "Magma Admiral [Lv. 350] [Boss]"
			NameBoss = 'Magma Admiral'
			NameQuestBoss = "MagmaQuest"
			QuestLvBoss = 3
			CFrameQBoss = CFrame.new(-5314, 12, 8517)
			CFrameBoss = CFrame.new(-5765, 82, 8718)
		elseif SelectBoss == "Fishman Lord" then
			BossMon = "Fishman Lord [Lv. 425] [Boss]"
			NameBoss = 'Fishman Lord'
			NameQuestBoss = "FishmanQuest"
			QuestLvBoss = 3
			CFrameQBoss = CFrame.new(61122, 18, 1569)
			CFrameBoss = CFrame.new(61260, 30, 1193)
		elseif SelectBoss == "Wysper" then
			BossMon = "Wysper [Lv. 500] [Boss]"
			NameBoss = 'Wysper'
			NameQuestBoss = "SkyExp1Quest"
			QuestLvBoss = 3
			CFrameQBoss = CFrame.new(-7861, 5545, -379)
			CFrameBoss = CFrame.new(-7866, 5576, -546)
		elseif SelectBoss == "Thunder God" then
			BossMon = "Thunder God [Lv. 575] [Boss]"
			NameBoss = 'Thunder God'
			NameQuestBoss = "SkyExp2Quest"
			QuestLvBoss = 3
			CFrameQBoss = CFrame.new(-7903, 5635, -1410)
			CFrameBoss = CFrame.new(-7994, 5761, -2088)
		elseif SelectBoss == "Cyborg" then
			BossMon = "Cyborg [Lv. 675] [Boss]"
			NameBoss = 'Cyborg'
			NameQuestBoss = "FountainQuest"
			QuestLvBoss = 3
			CFrameQBoss = CFrame.new(5258, 38, 4050)
			CFrameBoss = CFrame.new(6094, 73, 3825)
		elseif SelectBoss == "Ice Admiral" then
			BossMon = "Ice Admiral [Lv. 700] [Boss]"
			NameBoss = 'Ice Admiral'
			CFrameBoss = CFrame.new(1266, 26, -1399)
		elseif SelectBoss == "Greybeard" then
			BossMon = "Greybeard [Lv. 750] [Raid Boss]"
			NameBoss = 'Greybeard'
			CFrameBoss = CFrame.new(-5081, 85, 4257)
		end
	end
	if SecondSea then
		if SelectBoss == "Diamond" then
			BossMon = "Diamond [Lv. 750] [Boss]"
			NameBoss = 'Diamond'
			NameQuestBoss = "Area1Quest"
			QuestLvBoss = 3
			CFrameQBoss = CFrame.new(-427, 73, 1835)
			CFrameBoss = CFrame.new(-1576, 198, 13)
		elseif SelectBoss == "Jeremy" then
			BossMon = "Jeremy [Lv. 850] [Boss]"
			NameBoss = 'Jeremy'
			NameQuestBoss = "Area2Quest"
			QuestLvBoss = 3
			CFrameQBoss = CFrame.new(636, 73, 918)
			CFrameBoss = CFrame.new(2006, 448, 853)
		elseif SelectBoss == "Fajita" then
			BossMon = "Fajita [Lv. 925] [Boss]"
			NameBoss = 'Fajita'
			NameQuestBoss = "MarineQuest3"
			QuestLvBoss = 3
			CFrameQBoss = CFrame.new(-2441, 73, -3217)
			CFrameBoss = CFrame.new(-2172, 103, -4015)
		elseif SelectBoss == "Don Swan" then
			BossMon = "Don Swan [Lv. 1000] [Boss]"
			NameBoss = 'Don Swan'
			CFrameBoss = CFrame.new(2286, 15, 863)
		elseif SelectBoss == "Smoke Admiral" then
			BossMon = "Smoke Admiral [Lv. 1150] [Boss]"
			NameBoss = 'Smoke Admiral'
			NameQuestBoss = "IceSideQuest"
			QuestLvBoss = 3
			CFrameQBoss = CFrame.new(-5429, 15, -5297)
			CFrameBoss = CFrame.new(-5275, 20, -5260)
		elseif SelectBoss == "Awakened Ice Admiral" then
			BossMon = "Awakened Ice Admiral [Lv. 1400] [Boss]"
			NameBoss = 'Awakened Ice Admiral'
			NameQuestBoss = "FrostQuest"
			QuestLvBoss = 3
			CFrameQBoss = CFrame.new(5668, 28, -6483)
			CFrameBoss = CFrame.new(6403, 340, -6894)
		elseif SelectBoss == "Tide Keeper" then
			BossMon = "Tide Keeper [Lv. 1475] [Boss]"
			NameBoss = 'Tide Keeper'
			NameQuestBoss = "ForgottenQuest"
			QuestLvBoss = 3
			CFrameQBoss = CFrame.new(-3053, 237, -10145)
			CFrameBoss = CFrame.new(-3795, 105, -11421)
		elseif SelectBoss == "Darkbeard" then
			BossMon = "Darkbeard [Lv. 1000] [Raid Boss]"
			NameBoss = 'Darkbeard'
			CFrameMon = CFrame.new(3677, 62, -3144)
		elseif SelectBoss == "Cursed Captain" then
			BossMon = "Cursed Captain [Lv. 1325] [Raid Boss]"
			NameBoss = 'Cursed Captain'
			CFrameBoss = CFrame.new(916, 181, 33422)
		elseif SelectBoss == "Order" then
			BossMon = "Order [Lv. 1250] [Raid Boss]"
			NameBoss = 'Order'
			CFrameBoss = CFrame.new(-6217, 28, -5053)
		end
	end
	if ThirdSea then
		if SelectBoss == "Stone" then
			BossMon = "Stone [Lv. 1550] [Boss]"
			NameBoss = 'Stone'
			NameQuestBoss = "PiratePortQuest"
			QuestLvBoss = 3
			CFrameQBoss = CFrame.new(-289, 43, 5579)
			CFrameBoss = CFrame.new(-1027, 92, 6578)
		elseif SelectBoss == "Hydra Leader" then
			BossMon = "Hydra Leader [Lv. 1675] [Boss]"
			NameBoss = 'Hydra Leader'
			NameQuestBoss = "VenomCrewQuest"
			QuestLvBoss = 3
			CFrameQBoss = CFrame.new(5214, 1003, 759)
			CFrameBoss = CFrame.new(5887, 1018, -117)
		elseif SelectBoss == "Kilo Admiral" then
			BossMon = "Kilo Admiral [Lv. 1750] [Boss]"
			NameBoss = 'Kilo Admiral'
			NameQuestBoss = "MarineTreeIsland"
			QuestLvBoss = 3
			CFrameQBoss = CFrame.new(2179, 28, -6739)
			CFrameBoss = CFrame.new(2764, 432, -7144)
		elseif SelectBoss == "Captain Elephant" then
			BossMon = "Captain Elephant [Lv. 1875] [Boss]"
			NameBoss = 'Captain Elephant'
			NameQuestBoss = "DeepForestIsland"
			QuestLvBoss = 3
			CFrameQBoss = CFrame.new(-13232, 332, -7626)
			CFrameBoss = CFrame.new(-13376, 433, -8071)
		elseif SelectBoss == "Beautiful Pirate" then
			BossMon = "Beautiful Pirate [Lv. 1950] [Boss]"
			NameBoss = 'Beautiful Pirate'
			NameQuestBoss = "DeepForestIsland2"
			QuestLvBoss = 3
			CFrameQBoss = CFrame.new(-12682, 390, -9902)
			CFrameBoss = CFrame.new(5283, 22, -110)
		elseif SelectBoss == "Cake Queen" then
			BossMon = "Cake Queen [Lv. 2175] [Boss]"
			NameBoss = 'Cake Queen'
			NameQuestBoss = "IceCreamIslandQuest"
			QuestLvBoss = 3
			CFrameQBoss = CFrame.new(-819, 64, -10967)
			CFrameBoss = CFrame.new(-678, 381, -11114)
		elseif SelectBoss == "Longma" then
			BossMon = "Longma [Lv. 2000] [Boss]"
			NameBoss = 'Longma'
			CFrameBoss = CFrame.new(-10238, 389, -9549)
		elseif SelectBoss == "Soul Reaper" then
			BossMon = "Soul Reaper [Lv. 2100] [Raid Boss]"
			NameBoss = 'Soul Reaper'
			CFrameBoss = CFrame.new(-9524, 315, 6655)
		elseif SelectBoss == "rip_indra True Form" then
			BossMon = "rip_indra True Form [Lv. 5000] [Raid Boss]"
			NameBoss = 'rip_indra True Form'
			CFrameBoss = CFrame.new(-5415, 505, -2814)
		end
	end
end

local AutoFarmSettings = Tabs.AutoFarm:AddLeftGroupbox('Auto Farm Settings')

local WeaponList = {'Melee', 'Blox Fruit', 'Sword', 'Gun'}
AutoFarmSettings:AddDropdown('Weapon', {Values = WeaponList, Default = 1, Multi = false, Text = 'Weapons', Callback = function(Value) end})
Options.Weapon:OnChanged(function()
	SelectWeaponFarm = Options.Weapon.Value
	
	if SelectWeaponFarm == 'Melee' then
		for i, v in pairs(plr.Backpack:GetChildren()) do
			if v.ToolTip == 'Melee' then
				if plr.Backpack:FindFirstChild(tostring(v.Name)) then
					SelectedWeapon = v.Name
				end
			end
		end
	elseif SelectWeaponFarm == 'Sword' then
		for i, v in pairs(plr.Backpack:GetChildren()) do
			if v.ToolTip == 'Sword' then
				if plr.Backpack:FindFirstChild(tostring(v.Name)) then
					SelectedWeapon = v.Name
				end
			end
		end
	elseif SelectWeaponFarm == 'Blox Fruit' then
		for i, v in pairs(plr.Backpack:GetChildren()) do
			if v.ToolTip == 'Blox Fruit' then
				if plr.Backpack:FindFirstChild(tostring(v.Name)) then
					SelectedWeapon = v.Name
				end
			end
		end
	elseif SelectWeaponFarm == 'Gun' then
		for i, v in pairs(plr.Backpack:GetChildren()) do
			if v.ToolTip == 'Gun' then
				if plr.Backpack:FindFirstChild(tostring(v.Name)) then
					SelectedWeapon = v.Name
				end
			end
		end
	end
end)

-- local function fBringMob(TargetName, TargetCFrame)
-- 	for i, v in pairs(workspace.Enemies:GetChildren()) do
-- 		if v.Name == TargetName then
-- 			if v:FindFirstChild('Humanoid') and v.Humanoid.Health > 0 then
-- 				if (v.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude < tonumber(BringDis) then
-- 					v.HumanoidRootPart.CFrame = TargetCFrame
-- 					v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
-- 					v.Humanoid:ChangeState(11)
-- 					v.Humanoid:ChangeState(14)
-- 					if v.Humanoid:FindFirstChild('Animator') then
-- 						v.Humanoid.Animator:Destroy()
-- 					end
-- 				end
-- 			end
-- 		end
-- 	end
-- end

-- AutoFarmSettings:AddToggle('BringMobs', {Text = 'Bring Mobs', Default = false, Callback = function(Value) end})
-- spawn(function()
-- 	while wait(1) do
-- 		if Toggles.BringMobs.Value and (Toggles.AutoFarmToggle.Value) then
-- 			pcall(function()
-- 				fBringMob(Level_Farm_Name, Level_Farm_CFrame)
-- 			end)
-- 		elseif Toggles.BringMobs.Value and Toggles.AutoBones.Value then
-- 			pcall(function()
-- 				fBringMob(Bone_Farm_Name, Bone_Farm_CFrame)
-- 			end)
-- 		elseif Toggles.BringMobs.Value and AutoFarmNearestToggle then
-- 			pcall(function()
-- 				fBringMob(Nearest_Farm_Name, Nearest_Farm_CFrame)
-- 			end)
-- 		end
-- 	end
-- end)

-- AutoFarmSettings:AddSlider('BringRange', {Text = 'Bring Mobs Range', Default = 250, Min = 0, Max = 500, Rounding = 0, Compact = false,Callback = function(Value) end})
-- Options.BringRange:OnChanged(function()
-- 	BringDis = Options.BringRange.Value
-- end)

local function EquipTool(Tool)
	plr.Character.Humanoid:EquipTool(plr.Backpack[Tool])
end

local function AutoClick()
	print('Autoclicking (hell nah)')
	VirtualInputManager:Button1Down(Vector2.new(0, 0))
	wait()
	VirtualInputManager:Button1Up(Vector2.new(0, 0))
end

local AutoFarm = Tabs.AutoFarm:AddLeftGroupbox('Auto Farm')
AutoFarm:AddToggle('AutoFarmToggle', {Text = 'Auto Farm', Default = false, Callback = function(Value) end})
spawn(function()
	while wait(0.1) do
		if Toggles.AutoFarmToggle.Value then
			pcall(function()
				CheckLevel()
				if not string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) or plr.PlayerGui.Main.Quest.Visible == false then
					CommF_:InvokeServer("AbandonQuest")
					Tween(CFrameQuest)
					if (CFrameQuest.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 5 then
						wait(0.5)
						CommF_:InvokeServer("StartQuest", NameQuest, QuestLv)
					end
				elseif string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) or plr.PlayerGui.Main.Quest.Visible == true then
					if workspace.Enemies:FindFirstChild(EnemyName) then
						for i, v in pairs(workspace.Enemies:GetChildren()) do
							if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
								if v.Name == EnemyName then
									repeat wait()
										EquipTool(SelectWeapon)
										target = v.HumanoidRootPart + Vector3.new(offX, offY, offZ)
										Tween(target)
										AutoClick()
									until not Toggles.AutoFarmToggle.Value or not v.Parent or v.Humanoid.Health <= 0 or not workspace.Enemies:FindFirstChild(v.Name) or plr.PlayerGui.Main.Quest.Visible == false
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

AutoFarm:AddToggle('AutoFarmNoQuest', {Text = 'Auto Farm No Quest', Default = false, Callback = function(Value) end})
spawn(function()
	while wait(0.1) do
		if Toggles.AutoFarmNoQuest.Value then
			pcall(function()
				CheckLevel()
				if workspace.Enemies:FindFirstChild(EnemyName) then
					for i, v in pairs (workspace.Enemies:GetChildren()) do
						if v.Name == EnemyName then
							if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
								repeat wait()
									EquipTool(SelectWeapon)
									target = v.HumanoidRootPart + Vector3.new(offX, offY, offZ)
									Tween(target)
									AutoClick()
								until not Toggles.AutoFarmNoQuest.Value or not v.Parent or v.Humanoid.Health <= 0 or not workspace.Enemies:FindFirstChild(v.Name)
							end
						end
					end
				else
					Tween(CFrameMon)
				end
			end)
		end
	end
end)

AutoFarm:AddToggle('AutoFarmNearestToggle', {Text = 'Auto Farm Nearest', Default = false, Callback = function(Value) end})
spawn(function()
	while wait(0.1) do
		if Toggles.AutoFarmNearestToggle.Value then
			pcall(function()
				for i, v in pairs (workspace.Enemies:GetChildren()) do
					if v:FindFirstChild('Humanoid') and v:FindFirstChild('HumanoidRootPart') and v.Humanoid.Health > 0 then
						if (plr.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude <= 1000 then
							repeat wait()
								EquipTool(SelectedWeapon)
								target = v.HumanoidRootPart + Vector3.new(offX, offY, offZ)
								Tween(target)
								AutoClick()
							until not Toggles.AutoFarmNearestToggle.Value or not v.Parent or v.Humanoid.Health <= 0 or not workspace.Enemies:FindFirstChild(v.Name)
						end
					end
				end
			end)
		end
	end
end)

local BossNameStorage = {
	"The Gorrila King", "Bobby", "The Saw", "Yeti", "Mob Leader", "Vice Admiral", "Saber Expert", "Warden", "Chief Warden", "Swan", "Magma Admiral", "Fishman Lord", "Wysper", "Thunder God", "Cyborg", "Ice Admiral", "Greybeard",
	"Diamond", "Jeremy", "Fajita", "Don Swan", "Smoke Admiral", "Awakened Ice Admiral", "Tide Keeper", "Darkbeard", "Cursed Captain", "Order",
	"Stone", "Hydra Leader", "Kilo Admiral", "Captain Elephant", "Beautiful Pirate", "Cake Queen", "Longma", "Soul Reaper", "rip_indra True Form"
}
local BossList = {}
for i, v in pairs(ReplicatedStorage:GetChildren()) do
	if table.find(BossNameStorage, v.Name) then
		table.insert(BossList, v.Name)
	end
end

AutoFarm:AddDropdown('SelectBoss', {Values = BossList, Default = 1, Multi = false, Text = 'Select Boss', Callback = function(Value) end})
Options.SelectBoss:OnChanged(function()
	SelectBoss = Options.SelectBoss.Value
end)

AutoFarm:AddToggle('AutoFarmBossQuest', {Text = 'Auto Farm Boss (Quest)', Default = false, Callback = function(Value) end})
spawn(function()
	while wait(0.1) do
		if Toggles.AutoFarmBossQuest.Value then
			pcall(function()
				CheckBossQuest(SelectBoss)
				if not string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameBoss) or plr.PlayerGui.Main.Quest.Visible == false then
					CommF_:InvokeServer("AbandonQuest")
					Tween(CFrameQBoss)
					if (CFrameQBoss.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 5 then
						CommF_:InvokeServer("StartQuest", NameQuestBoss, QuestLvBoss)
					end
				elseif string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameBoss) or plr.PlayerGui.Main.Quest.Visible == true then
					if workspace.Enemies:FindFirstChild(SelectBoss) then
						for i,v in pairs(workspace.Enemies:GetChildren()) do
							if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
								if v.Name == SelectBoss then
									repeat wait()
										EquipTool(SelectWeapon)
										Tween(v.HumanoidRootPart.CFrame)
										v.Humanoid:ChangeState(11)
										v.Humanoid:ChangeState(14)
										AutoClick()
									until not Toggles.AutoFarmBossQuest.Value or not v.Parent or v.Humanoid.Health <= 0 or not workspace.Enemies:FindFirstChild(v.Name) or plr.PlayerGui.Main.Quest.Visible == false
								end
							end
						end
					else
						Tween(CFrameBoss)
					end
				end
			end)
		end
	end
end)

AutoFarm:AddToggle('AutoFarmBossNoQuest', {Text = 'Auto Farm Boss (No Quest)', Default = false, Callback = function(Value) end})
spawn(function()
	while wait() do
		if Toggles.AutoFarmBossNoQuest.Value then
			pcall(function()
				CheckBossQuest(SelectBoss)
				Tween(CFrameBoss)
				for i, v in pairs(workspace.Enemies:GetChildren()) do
					if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
						if v.Name == SelectBoss then
							repeat wait()
								EquipTool(SelectWeapon)
								target = v.HumanoidRootPart + Vector3.new(offX, offY, offZ)
								Tween(target)
								v.Humanoid:ChangeState(11)
								v.Humanoid:ChangeState(14)
								AutoClick()
							until not Toggles.AutoFarmBossNoQuest.Value or not v.Parent or v.Humanoid.Health <= 0 or not workspace.Enemies:FindFirstChild(v.Name)
						end
					end
				end
			end)
		end
	end
end)

-- Start of First Sea GroupBox
local GroupBox_FirstSea = Tabs.AutoFarm:AddRightGroupbox('First Sea')
-- End of First Sea GroupBox

-- Start of Second Sea GroupBox
local GroupBox_SecondSea = Tabs.AutoFarm:AddRightGroupbox('Second Sea')
GroupBox_SecondSea:AddToggle('AutoLegendarySword', {Text = 'Auto Legendary Sword', Default = false, Callback = function(Value) end})
spawn(function()
	while wait() do
		if Toggles.AutoLegendarySword.Value then
			CommF_:InvokeServer("LegendarySworldDealer","1")
			CommF_:InvokeServer("LegendarySworldDealer","2")
			CommF_:InvokeServer("LegendarySworldDealer","3")
		end
	end
end)

local Core = CFrame.new(448, 199, -441)
GroupBox_SecondSea:AddToggle('AutoFactory', {Text = 'Auto Factory', Default = false, Callback = function(Value) end})
spawn(function()
	while wait() do
		if Toggles.AutoFactory.Value then
			if workspace.Enemies:FindFirstChild("Core") then
				for i, v in pairs(game.Workspace.Enemies:GetChildren()) do
					if v.Name == "Core" and v.Humanoid.Health > 0 then
						repeat wait()
							Tween(Core)
							EquipTool(SelectWeapon)
							AutoClick()
						until not v.Parent or v.Humanoid.Health <= 0  or Toggles.AutoFactory.Value == false
					end
				end
			elseif ReplicatedStorage:FindFirstChild("Core") then
				repeat Tween(Core)
					wait()
				until not Toggles.AutoFactory.Value or (plr.Character.HumanoidRootPart.Position - Vector3.new(Core)).Magnitude <= 10
			end
		end
	end
end)
-- End of Second Sea GroupBox

-- Start of Third Sea GroupBox
local GroupBox_ThirdSea = Tabs.AutoFarm:AddRightGroupbox('Third Sea')
GroupBox_ThirdSea:AddToggle('AutoEletric', {Text = '(BETA) Auto Unlock Eletric Claw', Default = false, Callback = function(Value) end})
spawn(function()
	while wait() do
		if Toggles.AutoEletric.Value then
			target = ReplicatedStorage.NPCs:FindFirstChild('Previous Hero').HumanoidRootPart
			Tween(target)
			if getRoot() and (getRoot().Position - target.HumanoidRootPart.Position).Magnitude <= 10 then
				-- CommF_:InvokeServer("idk") TODO TODO TODO, can someone contribute with the invoke server for ts?
				wait(5)
				Tween(CFrame.new(-12553, 332, -7621))
			end
		end
	end
end)

GroupBox_ThirdSea:AddToggle('AutoBones', {Text = 'Auto Farm Bones', Default = false, Callback = function(Value) end})
spawn(function()
	while wait(0.1) do
		if Toggles.AutoBones.Value then
			pcall(function()
				Tween(CFrame.new(-9508, 142, 5737))
				for i, v in pairs(workspace.Enemies:GetChildren()) do
					if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
						if v.Name == "Reborn Skeleton" or v.Name == "Living Zombie" or v.Name =="Demonic Soul" or v.Name == "Posessed Mummy" then
							repeat wait()
								EquipTool(SelectWeapon)
								target = v.HumanoidRootPart + Vector3.new(offX, offY, offZ)
								Tween(target)
								AutoClick()
							until not Toggles.AutoBones.Value or not v.Parent or v.Humanoid.Health <= 0 or not game.Workspace.Enemies:FindFirstChild(v.Name)
						end
					end
				end

				for i, v in pairs(ReplicatedStorage:GetChildren()) do
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

GroupBox_ThirdSea:AddToggle('AutoPirateRaid', {Text = 'Auto Pirate Raid', Default = false, Callback = function(Value) end })
spawn(function()
	while wait() do
		if Toggles.AutoPirateRaid.Value then
			pcall(function()
				local CFrameCastleRaid = CFrame.new(-5496, 313, -2841)
				if (CFrameCastleRaid.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 500 then
					for i, v in pairs(workspace.Enemies:GetChildren()) do
						if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
							if v.Name then
								if (v.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude < 2000 then
									repeat wait()
										EquipTool(SelectWeapon)
										target = v.HumanoidRootPart + Vector3.new(offX, offY, offZ)
										Tween(target)
										v.Humanoid:ChangeState(11)
										v.Humanoid:ChangeState(14)
										AutoClick()
									until not Toggles.AutoPirateRaid.Value or not v.Parent or v.Humanoid.Health <= 0 or not workspace.Enemies:FindFirstChild(v.Name)
								end
							end
						end
					end
				else
					Tween(CFrameCastleRaid)
				end
			end)
		end
	end
end)

GroupBox_ThirdSea:AddToggle('AutoEliteHunter', {Text = 'Auto Elite Hunter', Default = false, Callback = function(Value) end})
spawn(function()
	while wait() do
		if Toggles.AutoEliteHunter.Value then
			pcall(function()
				local progelit = CommF_:InvokeServer("EliteHunter", "Progress")
				EliteProgress:Refresh("Elite Boss Killed : " .. progelit)
				if plr.PlayerGui.Main.Quest.Visible == true then
					if string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Diablo") or string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,"Deandre") or string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Urban") then
						if workspace.Enemies:FindFirstChild("Diablo") or workspace.Enemies:FindFirstChild("Deandre") or workspace.Enemies:FindFirstChild("Urban") then
							for i, v in pairs(workspace.Enemies:GetChildren()) do
								if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
									if v.Name == "Diablo" or v.Name == "Deandre" or v.Name == "Urban" then
										repeat wait()
											EquipTool(SelectWeapon)
											target = v.HumanoidRootPart + Vector3.new(offX, offY, offZ)
											Tween(target)
											v.Humanoid:ChangeState(11)
											v.Humanoid:ChangeState(14)
											AutoClick()
										until Toggles.AutoEliteHunter.Value == false or v.Humanoid.Health <= 0 or not v.Parent
									end
								end
							end
						else
							if ReplicatedStorage:FindFirstChild("Diablo") then
								Tween(ReplicatedStorage:FindFirstChild("Diablo").HumanoidRootPart)
							elseif ReplicatedStorage:FindFirstChild("Deandre") then
								Tween(ReplicatedStorage:FindFirstChild("Deandre").HumanoidRootPart)
							elseif ReplicatedStorage:FindFirstChild("Urban") then
								Tween(ReplicatedStorage:FindFirstChild("Urban").HumanoidRootPart)
							end
						end
					end
				else
					CommF_:InvokeServer("EliteHunter")
				end
			end)
		end
	end
end)
-- End of Third Sea GroupBox

-- Misc Tab
local Misc = Tabs.Misc:AddLeftGroupbox('Misc')

-- Shop Tab
local Shop = Tabs.Shop:AddLeftGroupbox('Shop')

Shop:AddToggle('RandomSurprise', {Text = 'Auto Random Surprise (50 Bones)', Default = false, Callback = function(Value) end})
spawn(function()
	while wait(0.2) do
		if Toggles.RandomSurprise.Value then
			CommF_:InvokeServer('Bones', 'Buy', 1, 1)
		end
	end
end)

local ShopAbilities = Tabs.Shop:AddRightGroupbox('Abilities Shop')
ShopAbilities:AddButton('Buy Air Jump [ $10,000 ]', function() CommF_:InvokeServer('BuyHaki', 'Geppo') end)
ShopAbilities:AddButton('Buy Aura [ $25,000 ]', function() CommF_:InvokeServer('BuyHaki', 'Buso') end)
ShopAbilities:AddButton('Buy Flashstep [ $25,000 ]', function() CommF_:InvokeServer('BuyHaki', 'Soru') end)
ShopAbilities:AddButton('Buy Instinct [ $750,000 ]', function() CommF_:InvokeServer('KenTalk', 'Buy') end)

ShopAbilities:AddToggle('AutoBuyAbilities', {Text = 'Auto Buy All Haki', Default = false, Callback = function(Value)
	while wait(2) do
		CommF_:InvokeServer('BuyHaki', 'Geppo')
		CommF_:InvokeServer('BuyHaki', 'Buso')
		CommF_:InvokeServer('BuyHaki', 'Soru')
		CommF_:InvokeServer('KenTalk', 'Buy')
	end
end})

local ShopMisc = Tabs.Shop:AddLeftGroupbox('Misc')
ShopMisc:AddButton("Reroll Race [ f3000 ]", function() CommF_:InvokeServer(BlackbeardReward, Reroll, 2) end)
ShopMisc:AddButton("Reset Stats [ f2500 ]", function() CommF_:InvokeServer(BlackbeardReward, Refund, 2) end)

local Melee = Tabs.Shop:AddLeftGroupbox('Melees Shop')
Melee:AddButton('Black Leg [ $150,000  ]', function() CommF_:InvokeServer('BuyBlackLeg') end)
Melee:AddButton('Electro [ $550,000  ]', function() CommF_:InvokeServer('BuyElectro') end)
Melee:AddButton('Fishman Karate [ $750,000  ]', function() CommF_:InvokeServer('BuyFishmanKarate') end)
Melee:AddButton('Dragon Claw [ f1,500 ]', function()
	CommF_:InvokeServer('BlackbeardReward', 'DragonClaw', '1')
	CommF_:InvokeServer('BlackbeardReward', 'DragonClaw', '2')
end)
Melee:AddButton('Superhuman [ $3,000,000 ]', function() CommF_:InvokeServer('BuySuperhuman') end)
Melee:AddButton('Death Step [ f5,000 / $5,000,000 ]', function() CommF_:InvokeServer('BuyDeathStep') end)
Melee:AddButton('Sharkman Karate [ f5,000 / $2,500,000 ]', function()
	CommF_:InvokeServer('BuySharkmanKarate', true)
	CommF_:InvokeServer('BuySharkmanKarate')
end)
Melee:AddButton('Electric Claw [ f5,000 / $3,000,000 ]', function() CommF_:InvokeServer('BuyElectricClaw') end)
Melee:AddButton('Dragon Talon [ f5,000 / $3,000,000 ]', function() CommF_:InvokeServer('BuyDragonTalon') end)
Melee:AddButton('God Human [ f5,000 / $5,000,000 ]', function() CommF_:InvokeServer('BuyGodhuman') end)

local Accessories = Tabs.Shop:AddRightGroupbox('Accessories Shop')
Accessories:AddButton('Black Cape [ $50,000 ]', function() CommF_:InvokeServer('BuyItem', 'Black Cape') end)
Accessories:AddButton('Swordsman Hat [ $150,000 ]', function() CommF_:InvokeServer('BuyItem', 'Swordsman Hat') end)
Accessories:AddButton('Tomoe Ring [ $500,000 ]', function() CommF_:InvokeServer('BuyItem', 'Tomoe Ring') end)

local Sword = Tabs.Shop:AddLeftGroupbox('Swords Shop')
Sword:AddButton('Cutlass [ $1,000 ]', function() CommF_:InvokeServer('BuyItem', 'Cutlass') end)
Sword:AddButton('Katana [ $1,000 ]', function() CommF_:InvokeServer('BuyItem', 'Katana') end)
Sword:AddButton('Dual Katana [ $12,000 ]', function() CommF_:InvokeServer('BuyItem', 'Dual Katana') end)
Sword:AddButton('Iron Mace [ $25,000 ]', function() CommF_:InvokeServer('BuyItem', 'Iron Mace') end)
Sword:AddButton('Triple Katana [ $60,000 ]', function() CommF_:InvokeServer('BuyItem', 'Triple Katana') end)
Sword:AddButton('Pipe [ $100,000 ]', function() CommF_:InvokeServer('BuyItem', 'Pipe') end)
Sword:AddButton('Dual-Headed Blade [ $400,000 ]', function() CommF_:InvokeServer('BuyItem', 'Dual-Headed Blade') end)
Sword:AddButton('Soul Cane [ $750,000 ]', function() CommF_:InvokeServer('BuyItem', 'Soul Cane') end)
Sword:AddButton('Bisento [ $1,200,000 ]', function() CommF_:InvokeServer('BuyItem', 'Bisento') end)
Sword:AddButton('Pole v2 [ f5,000 ]', function()	CommF_:InvokeServer('ThunderGodTalk') end)

local Gun = Tabs.Shop:AddRightGroupbox('Guns Shop')
Gun:AddButton('Slingshot [ $5,000 ]', function() CommF_:InvokeServer('BuyItem', 'Slingshot') end)
Gun:AddButton('Musket [ $8,000 ]', function() CommF_:InvokeServer('BuyItem', 'Musket') end)
Gun:AddButton('Flintlock [ $10,500 ]', function() CommF_:InvokeServer('BuyItem', 'Flintlock') end)
Gun:AddButton('Refined Slingshot [ $30,000 ]', function() CommF_:InvokeServer('BuyItem', 'Refined Slingshot') end)
Gun:AddButton('Refined Flintlock [ $65,000 ]', function() CommF_:InvokeServer('BuyItem', 'Refined Flintlock') end)
Gun:AddButton('Kabucha [ f1,500 ]', function() CommF_:InvokeServer('BlackbeardReward', 'Slingshot', '2') end)

-- Visuals Tab
local Sense = loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Sirius/refs/heads/request/library/sense/source.lua'))()

function Sense.getWeapon(plr)
	if plr.Character then
		local weapon = plr.Character:FindFirstChildOfClass('Tool')
	end
	if weapon then
		return tostring(weapon)
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
	for i, v in pairs(togglesToEnable) do
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
	for i, v in pairs(togglesToEnable) do
		if Toggles[v] then
			Toggles[v]:SetValue(true)
		end
	end
end)

local ESPColors = Tabs.Visuals:AddRightTabbox()

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