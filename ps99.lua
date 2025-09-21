local Eggs = game.Players.LocalPlayer.PlayerScripts.Scripts.Game['Egg Opening Frontend']
getsenv(Eggs).PlayEggAnimation = function() return end

local RS = game:GetService('ReplicatedStorage')
local Players = game:GetService('Players')
local HatchEventEggs = RS.Network.CustomEggs_Hatch
local HatchNormalEggs = RS.Network.Eggs_RequestPurchase
local ClosestDistance = 10

--[[
local function getMaxHatchableEggs()
	local remainingText = game:GetService('Players').LocalPlayer.PlayerGui._MACHINES.EggSlotsMachine.Frame.Slots.Items.Title.Remaining.Text
	local maxHatchableEggs = tonumber(remainingText:match('^(%d+)/'))
	print('Max Hatchable Eggs:', maxHatchableEggs)
	return maxHatchableEggs
end

getMaxHatchableEggs()
doesnt work because it doesnt load until u open it egg slots machine so its just 9/99 because placeholder 
so its TODO frfr
]]--

local function FindNearestNormalEgg()
	for _, v in pairs(workspace.__THINGS.Eggs.World3:GetChildren()) do
		if v:IsA('Model') then
			local Distance = (v.PrimaryPart.Position - Players.LocalPlayer.Character.PrimaryPart.Position).Magnitude
			if Distance < ClosestDistance then
				ClosestNormalEgg = tostring(v.Name)
				ClosestDistance = Distance
			end
		end
	end
	return ClosestNormalEgg
end

local function GetNormalEggId(EggName)
	local EggNumber = ClosestNormalEgg:match('^(%d+)')

	if EggNumber then
		for _, WorldFolders in pairs(RS.__DIRECTORY.Eggs['Zone Eggs']:GetChildren()) do
			for _, UpdateFolders in pairs(WorldFolders:GetChildren()) do
				for _, Eggs in pairs(UpdateFolders:GetChildren()) do
					if Eggs.Name:match(EggNumber) then
						EggName = Eggs.Name:match('%d+%s|%s(.+)$')
					end
				end
			end
		end
		return EggName
	end
end

while wait(0.1) do
	if OpenNearestEgg then
		local NormalEgg = FindNearestNormalEgg(ClosestNormalEgg)
		if NormalEgg then
			local baka = GetNormalEggId(EggName)
			HatchNormalEggs:InvokeServer(baka, EggAmount)
			print('Opened Normal Egg:', baka)
		end
	end
end

local UserInputService = game:GetService('UserInputService')

UserInputService.InputBegan:Connect(function(Input)
	if Input.KeyCode == Enum.KeyCode.I then
		OpenNearestEgg = not OpenNearestEgg
		print('Auto Open Egg: ', OpenNearestEgg)
	end

	--[[ if Input.KeyCode == Enum.KeyCode.O then
		TPToBestEgg = not TPToBestEgg
		print('TPToBestEgg:', TPToBestEgg)
	end ]]
end)
