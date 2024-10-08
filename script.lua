-- DOCS: https://github.com/dawid-scripts/Fluent/

--// Variables \\--
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local replicatedstorage = game:GetService("ReplicatedStorage")
local Math_upvr = require(replicatedstorage.Functions.Math)
local stripItems = true
local catchSkins = true
local sniping = false
local snipeArea = ""

local sortPokemonToSpecificBox = true -- Sorts each pokemon type to it's own box based on lore
local sortPokemonToSpecificBoxOffset = 4 -- How many boxes you want to keep free
local unknownBox = 2 -- Box to add to if pokemon is not listed or one time only
local boxNormalSkins = 3 -- Box to add caught skins to (remember to move them!)
local boxSkinnedLegendaries = 4 -- Box to add caught skins from legendaries to (remember to move them!)
local pokemon
local pokemonName
local boxToAdd
local ball
local lvl

--// Security \\--
replicatedstorage.REvents.Pokemon.jfd:InvokeServer(workspace.Trainers.Blaine)
replicatedstorage.REvents.Internal.Compare:InvokeServer("Ultra Ball", 1, "Pokeball")

--// Long lists \\--
local snipeAreas = {}
snipeAreas["Mausoleum Of Origins"] = {CFrame.new(-669.0263671875, 75.08966827392578, -4704.48193359375), {"Lugia", "Zekrom", "Reshiram"}}
snipeAreas["Victory Road"] = {CFrame.new(-6390.599609375, 54.61821746826172, -1274.2086181640625), {"Dialga", "Registeel", "Ho-Oh"}}
snipeAreas["Mt Moon"] = {CFrame.new(1971.6612548828125, -75.65400695800781, -1757.248779296875), {"Regirock"}}
snipeAreas["Mt Cinnabar"] = {CFrame.new(-4348.82958984375, 44.533424377441406, 1954.56591796875), {"Moltres", "Volcanion", "Regice"}}
snipeAreas["Seafoam Cave"] = {CFrame.new(-4213.1396484375, 9.833534240722656, -341.2264099121094), {"Kyurem", "Articuno"}}
snipeAreas["Water Powerplant"] = {CFrame.new(-4386.94384765625, -6.265628337860107, 1532.1419677734375), {"Rotom", "Meltan"}}
snipeAreas["Pokemon Tower"] = {CFrame.new(-2473.245361328125, 99.56173706054688, 1799.0164794921875), {"Giratina", "Marshadow"}}
snipeAreas["Route Zarude"] = {CFrame.new(-3.606940269470215, -73.29591369628906, -2784.8251953125), {"Zarude"}}
snipeAreas["Aether Paradise"] = {CFrame.new(-3444.374267578125, 23.305910110473633, -6172.48046875), {"Tapu Bulu", "Tapu Lele", "Tapu Fini", "Tapu Koko"}}
snipeAreas["Isle Of Armor"] = {CFrame.new(2242.07861328125, 71.2955322265625, 2.5405452251434326), {"Victini", "Manaphy", "Jirachi", "Shaymin", "Phione"}}
snipeAreas["Deoxys Patch"] = {CFrame.new(926.9016723632812, -21.03388214111328, -4186.97998046875), {"Deoxys-Normal"}}
snipeAreas["Route 10"] = {CFrame.new(-2614.93798828125, 26.549829483032227, 1596.563232421875), {"Zapdos"}}

local items = {"Great Ball", "Ultra Ball", "Master Ball", "Mythical Leaf", "Odd Keystone", "Full Restore", "Fire Stone", "Water Stone", "Thunder Stone", "Leaf Stone", "Moon Stone", "Leftovers", "Sweet Apple", "Tart Apple", "Sun and Moon Stone", "Water Scroll", "Dark Scroll", "Lucky Egg"}
local stones = {"Venusaurite","Charizardite X","Charizardite Y","Blastoisinite","Mewtwonite X","Mewtwonite Y"}
local tbl = {"Rock Tomb", "Swords Dance", "Calm Mind", "Bulk Up", "Protect", "Reflect", "Light Screen", "Roost", "Double Team", "Charge Beam", "Thunderbolt", "Thunder", "Thunder Wave", "Will-O-Wisp", "Flamethrower", "Fire Blast", "Aerial Ace", "Brick Break", "Stone Edge", "Rest", "Toxic", "Ice Beam", "Blizzard", "Psychic", "Earthquake", "Dark Pulse", "Sludge Bomb", "Overheat", "Scald", "Dragon Claw", "Hidden Power", "Shadow Ball", "Zen Headbutt", "Superpower", "X-Scissor", "Explosion", "Signal Beam", "Ice Punch", "Fire Punch", "Thunder Punch", "Drain Punch", "Dragon Pulse", "Energy Ball", "Grass Knot", "Swagger", "Dazzling Gleam", "Power-Up Punch", "Flash Cannon", "Focus Blast", "Rock Polish", "Rock Slide", "Dream Eater", "Giga Drain", "Water Pulse", "Surf", "Waterfall", "Mega Punch", "Psyshock", "Cosmic Power", "Psychic Fangs", "Double Iron Bash", "Yawn"}
local sortPokemonToBox = {Articuno = 1,Zapdos = 1,Moltres = 1,Mewtwo = 2,Mew = 2,Dialga = 3,Palkia = 3,Giratina = 3,Kyurem = 4,Zekrom = 4,Reshiram = 4,Rayquaza = 5,Kyogre = 5,Groudon = 5,Regigigas = 6,Regice = 6,Registeel = 6,Regirock = 6,Regidrago = 6,Regieleki = 6,Manaphy = 7,Phione = 7,Xerneas = 8,Yveltal = 8,Zygarde = 8,Darkrai = 9,Cresselia = 9,Raikou = 10,Entei = 10,Suicune = 10,Lugia = 11,["Ho-Oh"] = 11,Keldeo = 12,Cobalion = 12,Virizion = 12,Terrakion = 12,Latias = 13,Latios = 13,Thundurus = 14,Tornadus = 14,Landorus = 14,["Tapu Lele"] = 15,["Tapu Bulu"] = 15,["Tapu Fini"] = 15,["Tapu Koko"] = 15,["Uxie"] = 16,["Azelf"] = 16,["Mesprit"] = 16,Cosmog = 17,Cosmoem = 17,Solgaleo = 17,Lunala = 17,Necrozma = 17,Zacian = 18,Zamazenta = 18,Celebi = 19,Jirachi = 19,Deoxys = 19,Heatran = 19,Shaymin = 19,["Type: Null"] = 19,Silvally = 19,Victini = 19,Meloetta = 19,Volcanion = 19,Marshadow = 19,Zeraora = 19,Zarude = 19,Meltan = 20,Melmetal = 20}
local alwaysCatch = {"Raikou", "Entei", "Suicune","Celebi","Darkrai","Mewtwo", "Mew","Latios", "Latias","Cobalion", "Virizion", "Terrakion","Groudon", "Kyogre"}
--// Functions \\--
function pokeball()
	--game:GetService("ReplicatedStorage").REvents.Pokemon.catchPokemon:InvokeServer(pokemon, ball)
end
function catch(boxnumber)
	--game:GetService("ReplicatedStorage").REvents.PC.ParentChange:InvokeServer(pokemon, game:GetService("Players").LocalPlayer.PC:FindFirstChild("Box " .. tostring(boxnumber)))
	local args = {
		[1] = "WildGrass"
	}
	local args = {
		[1] = pokemon,
		[2] = "Ultra Ball"
	}
	game:GetService("ReplicatedStorage").REvents.Pokemon.catchPokemon:InvokeServer(unpack(args))
	game:GetService("ReplicatedStorage").REvents.PC.Release:FireServer(game:GetService("Players").LocalPlayer.OppPokemon:GetChildren()[1])
	-- Change parent
	local args = {
		[1] = pokemon,
		[2] = game:GetService("Players").LocalPlayer.PC:FindFirstChild("Box " .. tostring(boxnumber))
	}
	game:GetService("ReplicatedStorage").REvents.PC.ParentChange:InvokeServer(unpack(args))
	-- Pokedex
	local args = {
		[1] = pokemonName
	}
	game:GetService("ReplicatedStorage").REvents.Pokemon.caughtPokedex:FireServer(unpack(args))
end
function pokedex()
	--game:GetService("ReplicatedStorage").REvents.Pokemon.caughtPokedex:FireServer(pokemonName)
end
function itemstrip()
	if stripItems then
		if pokemon.HeldItem.Value ~= "" and pokemon.HeldItem.Value ~= "Dark Skinifier" then
			game:GetService("ReplicatedStorage").REvents.Pokemon.HeldItem:InvokeServer(pokemon,"")
		end
	end
end
function pokeballs()
	--game:GetService("ReplicatedStorage").REvents.Pokemon.Caughter:InvokeServer(pokemon,ball)
end
function pokeballcheck()
	--game:GetService("ReplicatedStorage"):WaitForChild("REvents"):WaitForChild("Internal"):WaitForChild("mathCheck"):FireServer(ball)
end

--// Maximize|minimize button \\--
local fluentFrame = nil
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local button = Instance.new("ImageButton", gui)
button.SizeConstraint = Enum.SizeConstraint.RelativeYY
button.Size = UDim2.new(.15, 0, .15, 0)
button.Image = "rbxassetid://74337056724489"
button.Position = UDim2.new(.9, 0, .1, 0)
button.BorderSizePixel = 0
button.BackgroundTransparency = 1
button.Activated:Connect(function()
	if fluentFrame then
		fluentFrame.Enabled = not fluentFrame.Enabled
	end
end)

local uicorner = Instance.new("UICorner", button)
uicorner.CornerRadius = UDim.new(.2, 0)

--// Hub \\--
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))();
toclipboard("https://discord.gg/asRy5w8Vg8")
Fluent:Notify({
	Title = "Welcome:",
	Content = "Thanks for using INSANE HUB!",
	SubContent = "Join discord at: .gg/asRy5w8Vg8, copied to clipboard.",
	Duration = 5
})

local Window = Fluent:CreateWindow({
	Title = "Project Polaro [INSANE GUI]",
	SubTitle = "by Bjarnos - .gg/csC7YRmN",
	TabWidth = 160,
	Size = UDim2.fromOffset(580, 460),
	Acrylic = true,
	Theme = "Dark",
	MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
	Main = Window:AddTab({Title = "Main", Icon = ""}),
	Sniper = Window:AddTab({Title = "Sniper", Icon = ""}),
	SpawnItems = Window:AddTab({Title = "Spawn Items", Icon = ""}),
	Shop = Window:AddTab({Title = "Shop", Icon = ""}),
	Report = Window:AddTab({Title = "Report Bug", Icon = ""})
};
Window:SelectTab(1);

-- Main
Tabs.Main:AddButton({
	Title = "Heal party",
	Description = "Heals all pokemon in your party.",
	Callback = function()
		replicatedstorage.REvents.Pokemon.healPokemon:FireServer()
	end
});

Tabs.Main:AddButton({
	Title = "Instant kill",
	Description = "Kills all your enemies with 1 attack.",
	Callback = function()
		for _, v in pairs(Player.OppPokemon:GetChildren()) do
			v.CurrentHP.Value = 0
		end
	end
});

Tabs.Main:AddButton({
	Title = "Go to wormhole",
	Description = "Tps you to closes wormhole if there is one.",
	Callback = function()
		local hole = workspace:FindFirstChild("Wormhole")
		if hole then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = hole.WorldPivot
		else
			print("No hole found!")
		end
	end
});

--[[
Tabs.Main:AddButton({
	Title = "Catch opponent",
	Description = "Insta-catches opponent pokemon, only works for wild pokemon, run away after using and check box 1/party.",
	Callback = function()
		Player.OppPokemon:GetChildren()[1]
		pokemonName = pokemon.Name
		ball = "Ultra Ball"
		
		task.spawn(itemstrip)
		task.spawn(pokeballcheck)
		task.spawn(pokeball)
		catch(1)
		task.spawn(pokedex)
		task.spawn(pokeballs)
	end
});
]]

Tabs.Main:AddButton({
	Title = "Max out EVs",
	Description = "Maxes out the EV of every pokemon in your party.",
	Callback = function()
		for _,v in pairs(Player.PokemonParty:GetChildren()) do
			for _,i in pairs(v.EV:GetChildren()) do
				replicatedstorage:WaitForChild("REvents"):WaitForChild("Pokemon"):WaitForChild("EVChange"):InvokeServer(i,100)
			end
		end
	end
});

Tabs.Main:AddButton({
	Title = "Max lvl",
	Description = "Maxes out the lvl of every pokemon in your party.",
	Callback = function()
		for _,v in pairs(Player.PokemonParty:GetChildren()) do
			while v.Lvl.Value < 100 do
				replicatedstorage:WaitForChild("REvents"):WaitForChild("Internal"):WaitForChild("GetExp"):InvokeServer(v,450000,"Yb58ByaIXKSIbY1qiqpmtqgiGKve5bhyLY3BA8Kp")
				replicatedstorage:WaitForChild("REvents"):WaitForChild("Pokemon"):WaitForChild("NeoPill"):InvokeServer(v)
			end
		end
	end
});

Tabs.Main:AddButton({
	Title = "Hide catch gui",
	Description = "Hides the catch gui [debugging].",
	Callback = function()
		Player.PlayerGui.Main.BattleScene.Visible = false
		Player.PlayerGui.Main.BlackScreen.Visible = false
		game:GetService("ReplicatedStorage").REvents.Pokemon.changeRequests:FireServer(game.Players.LocalPlayer.InBattle, false)
	end
});

-- Sniper
local areaDropdown = Tabs.Sniper:AddDropdown("Dropdown",{
	Title = "Select area:",
	Values = {},
	Multi = false,
	Default = 1,
})

for area, _ in pairs(snipeAreas) do
	table.insert(areaDropdown.Values, area)
end
areaDropdown:SetValue("Mausoleum Of Origins")

local legendarySelectDropdown = Tabs.Sniper:AddDropdown("Dropdown", {
	Title = "Select legendaries to catch:",
	Values = {},
	Multi = true,
	Default = 1,
})

areaDropdown:OnChanged(function(value)
	legendarySelectDropdown.Values = snipeAreas[value][2]
	legendarySelectDropdown:SetValue(snipeAreas[value][2])

	snipeArea = value
end)

local alwaysCatchLegendarySelectDropdown = Tabs.Sniper:AddDropdown("Dropdown2", {
	Title = "Legendaries to catch in every area:",
	Values = {},
	Multi = true,
	Default = 1,
})
alwaysCatchLegendarySelectDropdown.Values = alwaysCatch
alwaysCatchLegendarySelectDropdown:SetValue(alwaysCatch)

--[[
local selectBallDropdown = Tabs.Sniper:AddDropdown("Dropdown3", {
	Title = "Ball to use when catching:",
	Values = {"Great Ball", "Ultra Ball", "Master Ball"}
})
selectBallDropdown:SetValue("Ultra Ball")
]]

local stripItemsToggle = Tabs.Sniper:AddToggle("Toggle1", {Title = "Strip held items from pokemon:", Default = true})
stripItemsToggle:OnChanged(function(value)
	stripItems = value
end)

local catchSkinsToggle = Tabs.Sniper:AddToggle("Toggle2", {Title = "Catch pokemon with skins:", Default = true})
catchSkinsToggle:OnChanged(function(value)
	catchSkins = value
end)

Tabs.Sniper:AddButton({
	Title = "Start/stop sniping",
	Description = "Starts or stops your configured snipe.",
	Callback = function()
		sniping = not sniping
		if sniping == true then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = snipeAreas[snipeArea][1]
			repeat
				repeat
					replicatedstorage.FindPokemon:InvokeServer("WildGrass")
					wait()
				until #Player.OppPokemon:GetChildren() > 0

				pokemon = Player.OppPokemon:GetChildren()[1]
				pokemonName = pokemon.Name
				--ball = selectBallDropdown.Values[selectBallDropdown:GetActiveValues()]
				ball = "Ultra Ball"

				local catchlegendaries = {}
				for _, num in pairs(legendarySelectDropdown:GetActiveValues()) do
					table.insert(catchlegendaries, num)
				end

				for _, num in pairs(alwaysCatchLegendarySelectDropdown:GetActiveValues()) do
					table.insert(catchlegendaries, num)
				end

				if table.find(catchlegendaries, pokemonName) then
					local boxToAdd = unknownBox
					if catchSkins and pokemon:FindFirstChild("Skin") then
						print(pokemonName .. " WITH SKIN found!")
						boxToAdd = boxSkinnedLegendaries
					else
						print(pokemonName .. " found!")
						if sortPokemonToSpecificBox then
							boxToAdd = sortPokemonToBox[pokemonName] or 1
							if boxToAdd ~= 0 then
								boxToAdd += sortPokemonToSpecificBoxOffset
							else
								boxToAdd = unknownBox
							end
						end
					end

					task.spawn(itemstrip)
					task.spawn(pokeball)
					catch(boxToAdd)
					task.spawn(pokedex)

				elseif catchSkins and pokemon:FindFirstChild("Skin") then
					print(pokemonName .. " WITH SKIN found!")

					task.spawn(itemstrip)
					task.spawn(pokeball)
					catch(boxNormalSkins)
					task.spawn(pokedex)

				elseif stripItems and pokemon:WaitForChild("HeldItem").Value ~= "" then
					if pokemon:WaitForChild("HeldItem").Value == "Dark Skinifier" then
						task.spawn(pokeball)
						catch(1)
						task.spawn(pokedex)
					else
						print(pokemonName .. " WITH ITEM found! Item: " .. pokemon.HeldItem.Value)

						task.spawn(itemstrip)
						replicatedstorage.REvents.PC.Release:FireServer(game:GetService("Players").LocalPlayer.OppPokemon:GetChildren()[1])
					end
				else
					--print("fail: " .. pokemonName)
					replicatedstorage.REvents.PC.Release:FireServer(game:GetService("Players").LocalPlayer.OppPokemon:GetChildren()[1])
				end

			until sniping ~= true
		end
	end
});

for _, gui in pairs(game.CoreGui:GetChildren()) do
	if gui.Name == "ScreenGui" and #gui:GetChildren() == 5 then
		fluentFrame = gui
	end
end

-- Spawn items
Tabs.SpawnItems:AddButton({
	Title = "Get Robux items",
	Description = "Get free Mega Stones.",
	Callback = function()
		local event = replicatedstorage.REvents.Pokemon.ioome
		for _, item in stones do
			event:InvokeServer(item)
		end
	end
});

Tabs.SpawnItems:AddButton({
	Title = "Get ALL tms",
	Description = "Literally gives you every tm.",
	Callback = function()
		for _, child in tbl do
			Math_upvr:FuncAddItem(child, Player.Bag.TMs, 1)
		end
	end
});

local itemSelection = "Great Ball"
local selectItemDropdown = Tabs.SpawnItems:AddDropdown("selectItemDropdown",{
	Title = "Select item:",
	Values = items,
	Multi = false,
	Default = 1,
})
selectItemDropdown:SetValue("Great Ball")

selectItemDropdown:OnChanged(function(value)
	itemSelection = value
end)

local amountInput = Tabs.SpawnItems:AddInput("AmountInput", {
	Title = "Enter amount:",
	Default = "",
	Placeholder = "e.g. 100",
	Numeric = true,
	Finished = false,
	Callback = function(value)

	end
})

Tabs.SpawnItems:AddButton({
	Title = "Add items",
	Description = "Spawns the item you selected in the pokeballs section of your bag",
	Callback = function()
		Math_upvr:FuncAddItem(itemSelection, Player.Bag.Pokeball, tonumber(amountInput.Value) or 1)
	end
});

Tabs.SpawnItems:AddButton({
	Title = "Give all items",
	Description = "Gives you the amount you inputted of each item",
	Callback = function()
		for _,v in items do
			Math_upvr:FuncAddItem(v, Player.Bag.Pokeball, tonumber(amountInput.Value) or 1)
		end
	end
});

-- Shop
local cashInput = Tabs.Shop:AddInput("CashInput", {
	Title = "Enter cash amount:",
	Default = "",
	Placeholder = "e.g. 1000000",
	Numeric = true,
	Finished = false,
	Callback = function(value)

	end
})

Tabs.Shop:AddButton({
	Title = "Add cash",
	Description = "Adds the current selected amount of cash",
	Callback = function()
		local cashevent = replicatedstorage.REvents.Pokemon.jfd
		local amount = math.ceil(tonumber(cashInput.Value)/70000)
		for i = 1, amount do
			cashevent:InvokeServer(workspace.Trainers.Blaine)
		end
	end,
})

-- Report bug
local reportInput = Tabs.Report:AddInput("ReportInput", {
	Title = "Bug:",
	Default = "",
	Placeholder = "Describe your bug.",
	Numeric = false,
	Finished = false,
	Callback = function(value)

	end
})

Tabs.Report:AddButton({
	Title = "Report bug",
	Description = "Reports the current selected bug.",
	Callback = function()
		syn.request({
			Url = "https://webhook.newstargeted.com/api/webhooks/1283117752466407496/48dr9-wL7ArmEpE6sqgUaL_CfnRh5OET1YZJYpA1v1Ilrn_u64vit2c_Aogz8f0DrTqI/queue",
			Method = 'POST',
			Headers = { ['Content-Type'] = 'application/json' },
			Body = game.HttpService:JSONEncode({
				content = game.Players.LocalPlayer.Name .. " (" .. tostring(game.Players.LocalPlayer.UserId) .. "): " .. reportInput.Value,
			})
		})
	end
});
