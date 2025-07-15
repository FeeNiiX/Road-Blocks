local VirtualInputManager = game:GetService('VirtualInputManager')
local CollectionService = game:GetService("CollectionService")
local TeleportService = game:GetService('TeleportService')
local TweenService = game:GetService('TweenService')
local HttpService = game:GetService('HttpService')
local Players = game:GetService('Players')

local plr = Players.LocalPlayer

if plr.PlayerGui:FindFirstChild("Main (minimal)") and plr.PlayerGui['Main (minimal)']:FindFirstChild("ChooseTeam") then
	repeat wait()
		if plr.PlayerGui["Main (minimal)"].ChooseTeam.Visible == true then
			for i, v in pairs(getconnections(plr.PlayerGui['Main (minimal)'].ChooseTeam.Container.Marines.Frame.TextButton.Activated)) do
				v.Function()
			end
		end
	until plr.Team ~= nil and game:IsLoaded()
end

wait(2)

plr.DevCameraOcclusionMode = 'Invisicam'

local function getRoot()
	local rootPart = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
	return rootPart
end

local function convert(target)
	if typeof(target) == "Instance" and target:IsA("BasePart") then
		return target.Position
	elseif typeof(target) == "CFrame" then
		return target.Position
	elseif typeof(target) == "Vector3" then
		return target
	else
		print("203: Invalid target type")
	end
end

local function Tween(target)
	local root = getRoot()

	if root and root.Parent and root.Parent:FindFirstChild("Humanoid") then
		local humanoid = root.Parent:FindFirstChild("Humanoid")
		if humanoid.Sit then
			VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
			wait()
			VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
		end
	end

	local targetPos = convert(target)
	local distance = (root.Position - targetPos).Magnitude
	local duration = distance / 350

	local info = TweenInfo.new(duration, Enum.EasingStyle.Linear)
	local tween = TweenService:Create(root, info, {CFrame = CFrame.new(targetPos)})

	tween:Play()
	tween.Completed:Wait()
end

local function serverHop()
	local servers = {}
	local req
	local DidItWork, Output = pcall(function()
		req = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true")
	end)
	print(DidItWork, Output)
	if DidItWork then
		local body = HttpService:JSONDecode(req)

		if body and body.data then
			for i, v in next, body.data do
				if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
					table.insert(servers, 1, v.id)
				end
			end
		end

		if #servers > 0 then
			TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], plr)
		end
	else
		wait(15) -- if it says too many requests then wait 15 seconds no this is not chatgpt writing 😡😡😡
	end
end

while wait(1/30) do
	local BerryBushes = CollectionService:GetTagged("BerryBush")
	local Distance, NearestBush, NearestBerryName = math.huge, nil, nil
	local Character = plr.Character or plr.CharacterAdded:Wait()

	for i, Bush in pairs(BerryBushes) do
		for AttributeName, _ in pairs(Bush:GetAttributes()) do
			local Magnitude = (Bush.Parent:GetPivot().Position - Character.HumanoidRootPart.Position).Magnitude
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

		if (Character.HumanoidRootPart.Position - BushCenter).Magnitude > 100 then
			Tween(BushCenter)
		else
			local BerryPart = BushModel.Berries:FindFirstChildOfClass('Model')
			if BerryPart then
				if BerryPart.PrimaryPart then
					Tween(BerryPart.PrimaryPart.Position)
					if (Character.HumanoidRootPart.Position - BerryPart.PrimaryPart.Position).Magnitude <= 15 then
						fireproximityprompt(BerryPart.ProximityPrompt)
					end
				end
			end
		end
	else
		serverHop()
		wait(5)
	end
end

local function UpdateBerriesESP() -- this doesnt work at all 😭
	local BerryBushes = CollectionService:GetTagged("BerryBush")
	for _, Bush in pairs(BerryBushes) do
		pcall(function()
			for AttributeName, Berry in pairs(Bush:GetAttributes()) do
				if Berry then
					if not Bush.Parent:FindFirstChild("BerryESP") then
						local bill = Instance.new("BillboardGui", Bush.Parent)
						bill.Name = "BerryESP"
						bill.ExtentsOffset = Vector3.new(0, 2, 0)
						bill.Size = UDim2.new(1, 200, 1, 30)
						bill.Adornee = Bush.Parent
						bill.AlwaysOnTop = true
						local name = Instance.new("TextLabel", bill)
						name.Font = Enum.Font.GothamSemibold
						name.TextSize = 14
						name.TextWrapped = true
						name.Size = UDim2.new(1, 0, 1, 0)
						name.TextYAlignment = Enum.TextYAlignment.Top
						name.BackgroundTransparency = 1
						name.TextStrokeTransparency = 0.5
						name.TextColor3 = Color3.fromRGB(255, 255, 0)
						name.Text = Berry
					end
					if Bush.Parent:FindFirstChild("BerryESP") then
						local Player = game.Players.LocalPlayer
						if Player and Player.Character and Player.Character:FindFirstChild("Head") then
							local Position = Player.Character.Head.Position
							local Magnitude = (Bush.Parent:GetPivot().Position - Position).Magnitude
							Bush.Parent.BerryESP.TextLabel.Text = Berry .. "\n" .. math.floor(Magnitude) .. "m"
						end
					end
				else
					if Bush.Parent:FindFirstChild("NameEsp") then
						Bush.Parent:FindFirstChild("NameEsp"):Destroy()
					end
				end
			end
		end)
	end
end

while wait(2) do
	UpdateBerriesESP()
end