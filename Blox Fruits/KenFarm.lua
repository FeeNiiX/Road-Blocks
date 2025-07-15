local VirtualInputManager = game:GetService('VirtualInputManager')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local TeleportService = game:GetService('TeleportService')
local TweenService = game:GetService('TweenService')
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

local function GetRoot()
	local rootPart = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
	return rootPart
end

local function Rejoin()
	TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
end

local function Convert(target)
	if typeof(target) == "Instance" and target:IsA("BasePart") then
		return target.Position
	elseif typeof(target) == "CFrame" then
		return target.Position
	elseif typeof(target) == "Vector3" then
		return target
	else
		print("Invalid target type")
	end
end

local function Tween(target)
	root = GetRoot()

	if root and root.Parent and root.Parent:FindFirstChild("Humanoid") then
		local humanoid = root.Parent:FindFirstChild("Humanoid")
		if humanoid.Sit then
			VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
			wait()
			VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
		end
	end

	local targetPos = Convert(target)
	local distance = (root.Position - targetPos).Magnitude
	local duration = distance / 350

	local info = TweenInfo.new(duration, Enum.EasingStyle.Linear)
	local tween = TweenService:Create(root, info, {CFrame = CFrame.new(targetPos)})

	tween:Play()
end

spawn(function()
	while wait() do
		local KenActive = plr:GetAttribute('KenActive')
		if not KenActive then
			VirtualInputManager:SendKeyEvent(true, "E", false, game)
			wait()
			VirtualInputManager:SendKeyEvent(false, "E", false, game)
		else
			Shanda = workspace.Enemies:FindFirstChild('Shanda')
			rShanda = ReplicatedStorage:FindFirstChild('Shanda')
			if Shanda then
				Tween(Shanda.HumanoidRootPart)
			elseif rShanda then
				Tween(rShanda.HumanoidRootPart)
			else
				Tween(CFrame.new(-7850, 5563, -408))
			end

			Dodges = plr.PlayerGui.Main.BottomHUDList.UniversalContextButtons.BoundActionKen.DodgesLeftLabel.TextLabel.Text
			if (string.find(Dodges, "0/3")) then
				Rejoin()
			end
		end
	end
end)