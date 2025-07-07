local Eggs = game.Players.LocalPlayer.PlayerScripts.Scripts.Game['Egg Opening Frontend']
getsenv(Eggs).PlayEggAnimation = function() return end
-- deletes the PlayEggAnimation function
-- named the script after this because i found it at v3rmillion and it got me started

local RS = game:GetService('ReplicatedStorage')
local Players = game:GetService('Players')
local HatchEventEggs = RS.Network.CustomEggs_Hatch
local HatchNormalEggs = RS.Network.Eggs_RequestPurchase

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

-------------------------------------------------- Event Eggs --------------------------------------------------

--[[ local function FindNearestEventEgg(ClosestEventEgg)
    local ClosestDistance = 10
    for _,v in pairs(workspace.__THINGS.CustomEggs:GetChildren()) do
        if v:IsA('Model') then
            local Distance = (v.PrimaryPart.Position - Players.LocalPlayer.Character.PrimaryPart.Position).Magnitude
            if Distance < ClosestDistance then
                ClosestEventEgg = tostring(v.Name)
                ClosestDistance = Distance
            end
        end
    end
    return ClosestEventEgg
end

local function FindHighestEventEgg(HighestEventEgg)
    local HighestY = -math.huge
    for _,v in pairs(workspace.__THINGS.CustomEggs:GetChildren()) do
        if v:IsA('Model') then
            local yPos = v.PrimaryPart.Position.Y
            if yPos > HighestY then
                HighestY = yPos
                HighestEventEgg = v
            end
        end
    end
    return HighestEventEgg
end

local function TPToHighestEventEgg()
    local huh = FindHighestEventEgg(HighestEventEgg)
    if huh then
        local Distance = (HighestEventEgg.PrimaryPart.Position - Players.LocalPlayer.Character.PrimaryPart.Position).Magnitude
        if Distance > 10 then
            Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(HighestEventEgg.PrimaryPart.Position + Vector3.new(0, 0, 0)))
            print('Teleported to Highest Event Egg:', HighestEventEgg.Name)
        end
    end
end 

rest in piss valentine tower event i wish i had a valentine, a goth girl, or a asian baddie
what is bro saying?
take a load of this guy
]]--

-------------------------------------------------- Normal Eggs --------------------------------------------------

local function FindNearestNormalEgg(ClosestNormalEgg)
    local ClosestDistance = 10
    for _,v in pairs(workspace.__THINGS.Eggs.World3:GetChildren()) do
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
        for _, WorldFolders in pairs(RS.__DIRECTORY.Eggs['Zone Eggs']:GetChildren()) do -- search all egg names
            for _, UpdateFolders in pairs(WorldFolders:GetChildren()) do -- in all folders
                for _, Eggs in pairs(UpdateFolders:GetChildren()) do -- future proof asf
                    if Eggs.Name:match(EggNumber) then
                        EggName = Eggs.Name:match('%d+%s|%s(.+)$')
                    end
                end
            end
        end
        return EggName
    end
end

-------------------------------------------------- Open Eggs --------------------------------------------------

local function OpenEgg()
    local idk = FindNearestEventEgg(ClosestEventEgg)
    local argh = FindNearestNormalEgg(ClosestNormalEgg)
    if idk then
        HatchEventEggs:InvokeServer(idk, EggAmount)
        print('Opened Event Egg:', idk)
    elseif argh then
        local baka = GetNormalEggId(EggName)
        HatchNormalEggs:InvokeServer(baka, EggAmount)
        print('Opened Normal Egg:', baka)
    end
end

---------------------------------------------------------------------------------------------------------------

-- this is not the best way to update the things is it chat?

while true do
    task.wait(1)
    if OpenNearestEgg then
        OpenEgg()
    end

    --[[ if TPToBestEgg then
        TPToHighestEventEgg()
    end ]]
end

local UserInputService = game:GetService('UserInputService')

UserInputService.InputBegan:Connect(function(Input)
    if Input.KeyCode == Enum.KeyCode.I then
        OpenNearestEgg = not OpenNearestEgg
        print('OpenNearestEgg: ', OpenNearestEgg)
    end

    --[[ if Input.KeyCode == Enum.KeyCode.O then
        TPToBestEgg = not TPToBestEgg
        print('TPToBestEgg:', TPToBestEgg)
    end ]]
end)
