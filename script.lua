-- Variables
local currentVersion = "V1.0.0"
local realVersion = game:HttpGet("https://raw.githubusercontent.com/IdkTheSecond/idk/main/version.txt")
if tostring(string.sub(realVersion, 1, -2)) ~= currentVersion then
	toclipboard("https://discord.gg/asRy5w8Vg8")
	game.Players.LocalPlayer:Kick("Outdated version! Please run the new one from here: .gg/asRy5w8Vg8 or from clipboard.")
end

local stripItems = true
local catchSkins = true
local sniping = false

local sortPokemonToSpecificBox = true -- Sorts each pokemon type to it's own box based on lore
local sortPokemonToSpecificBoxOffset = 4 -- How many boxes you want to keep free
local unknownBox = 2 -- Box to add to if pokemon is not listed or one time only
local boxNormalSkins = 3 -- Box to add caught skins to (remember to move them!)
local boxSkinnedLegendaries = 4 -- Box to add caught skins from legendaries to (remember to move them!)

-- Long lists
local snipeAreas = {}
snipeAreas["Mausoleum Of Origins"] = {CFrame.new(-669.0263671875, 75.08966827392578, -4704.48193359375), {"Lugia", "Zekrom", "Reshiram"}}
-- Zekrom requires Kyurem + electric type in party, Reshiram requires Kyurem + fire type in party
snipeAreas["Victory Road"] = {CFrame.new(-6390.599609375, 54.61821746826172, -1274.2086181640625), {"Dialga", "Registeel", "Ho-Oh"}}
-- Dialga requires champ badge
snipeAreas["Mt Moon"] = {CFrame.new(1971.6612548828125, -75.65400695800781, -1757.248779296875), {"Regirock"}}
snipeAreas["Mt Cinnabar"] = {CFrame.new(-4348.82958984375, 44.533424377441406, 1954.56591796875), {"Moltres", "Volcanion", "Regice"}}
snipeAreas["Seafoam Cave"] = {CFrame.new(-4213.1396484375, 9.833534240722656, -341.2264099121094), {"Kyurem", "Articuno"}}
-- Kyurem requires champ badge
snipeAreas["Water Powerplant"] = {CFrame.new(-4386.94384765625, -6.265628337860107, 1532.1419677734375), {"Rotom", "Meltan"}}
-- Rotom requires 1 pure ghost and electric type in party
snipeAreas["Pokemon Tower"] = {CFrame.new(-2473.245361328125, 99.56173706054688, 1799.0164794921875), {"Giratina", "Marshadow"}}
-- Giratina requires champ badge
snipeAreas["Route Zarude"] = {CFrame.new(-3.606940269470215, -73.29591369628906, -2784.8251953125), {"Zarude"}}

-- Requirements not checked:
snipeAreas["Aether Paradise"] = {CFrame.new(-3444.374267578125, 23.305910110473633, -6172.48046875), {"Tapu Bulu", "Tapu Lele", "Tapu Fini", "Tapu Koko"}}
snipeAreas["Isle Of Armor"] = {CFrame.new(2242.07861328125, 71.2955322265625, 2.5405452251434326), {"Victini", "Manaphy", "Jirachi", "Shaymin", "Phione"}}

local alwaysCatch = {
	"Raikou", "Entei", "Suicune",
	"Celebi",
	"Darkrai",
	"Mewtwo", "Mew",
	-- Mew requires Mew gamepass
	"Latios", "Latias",
	"Cobalion", "Virizion", "Terrakion",
	-- These three require Keldeo in party
	"Groudon", "Kyogre"} -- Random spawns
-- Groudon and Kyogre require Rayquaza in party

local sortPokemonToBox = {}
sortPokemonToBox.Articuno = 1
sortPokemonToBox.Zapdos = 1
sortPokemonToBox.Moltres = 1

sortPokemonToBox.Mewtwo = 2

sortPokemonToBox.Dialga = 3
sortPokemonToBox.Palkia = 3
sortPokemonToBox.Giratina = 3

sortPokemonToBox.Kyurem = 4
sortPokemonToBox.Zekrom = 4
sortPokemonToBox.Reshiram = 4

sortPokemonToBox.Rayquaza = 5
sortPokemonToBox.Kyogre = 5
sortPokemonToBox.Groudon = 5

sortPokemonToBox.Regigigas = 6
sortPokemonToBox.Regice = 6
sortPokemonToBox.Registeel = 6
sortPokemonToBox.Regirock = 6
sortPokemonToBox.Regidrago = 6
sortPokemonToBox.Regieleki = 6

sortPokemonToBox.Manaphy = 7
sortPokemonToBox.Phione = 7

sortPokemonToBox.Xerneas = 8
sortPokemonToBox.Yveltal = 8
sortPokemonToBox.Zygarde = 8

sortPokemonToBox.Darkrai = 9
sortPokemonToBox.Cresselia = 9

sortPokemonToBox.Raikou = 10
sortPokemonToBox.Entei = 10
sortPokemonToBox.Suicune = 10

sortPokemonToBox.Lugia = 11
sortPokemonToBox["Ho-Oh"] = 11

sortPokemonToBox.Keldeo = 12
sortPokemonToBox.Cobalion = 12
sortPokemonToBox.Virizion = 12
sortPokemonToBox.Terrakion = 12

sortPokemonToBox.Latias = 13
sortPokemonToBox.Latios = 13

sortPokemonToBox.Thundurus = 14
sortPokemonToBox.Tornadus = 14
sortPokemonToBox.Landorus = 14

sortPokemonToBox["Tapu Lele"] = 15
sortPokemonToBox["Tapu Bulu"] = 15
sortPokemonToBox["Tapu Fini"] = 15
sortPokemonToBox["Tapu Koko"] = 15

sortPokemonToBox["Uxie"] = 16
sortPokemonToBox["Azelf"] = 16
sortPokemonToBox["Mesprit"] = 16

sortPokemonToBox.Cosmog = 17
sortPokemonToBox.Cosmoem = 17
sortPokemonToBox.Solgaleo = 17
sortPokemonToBox.Lunala = 17
sortPokemonToBox.Necrozma = 17

sortPokemonToBox.Zacian = 18
sortPokemonToBox.Zamazenta = 18

-- Others
sortPokemonToBox.Celebi = 19
sortPokemonToBox.Jirachi = 19
sortPokemonToBox.Deoxys = 19
sortPokemonToBox.Heatran = 19
sortPokemonToBox.Shaymin = 19
sortPokemonToBox["Type: Null"] = 19
sortPokemonToBox.Silvally = 19
sortPokemonToBox.Victini = 19
sortPokemonToBox.Meloetta = 19
sortPokemonToBox.Volcanion = 19
sortPokemonToBox.Marshadow = 19
sortPokemonToBox.Zeraora = 19
sortPokemonToBox.Zarude = 19

sortPokemonToBox.Meltan = 20
sortPokemonToBox.Melmetal = 20

--// Hub \\--
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))();

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
};
Window:SelectTab(1);

-- Main
Tabs.Main:AddButton({
	Title = "Heal party",
	Description = "Heals all pokemon in your party.",
	Callback = function()
		game.ReplicatedStorage.REvents.Pokemon.healPokemon:FireServer()
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
end)

local alwaysCatchLegendarySelectDropdown = Tabs.Sniper:AddDropdown("Dropdown2", {
	Title = "Legendaries to catch in every area:",
	Values = {},
	Multi = true,
	Default = 1,
})
alwaysCatchLegendarySelectDropdown.Values = alwaysCatch
alwaysCatchLegendarySelectDropdown:SetValue(alwaysCatch)

local stripItemsToggle = Tabs.Sniper:AddToggle("Toggle1", {Title = "Strip held items from pokemon:", Default = true})
stripItemsToggle:OnChanged(function(value)
	stripItems = value
end)

local catchSkinsToggle = Tabs.Sniper:AddToggle("Toggle2", {Title = "Catch pokemon with skins:", Default = true})
stripItemsToggle:OnChanged(function(value)
	catchSkins = value
end)

Tabs.Sniper:AddButton({
	Title = "Start/stop sniping",
	Description = "Starts or stops your configured snipe.",
	Callback = function()
		local realVersion2 = game:HttpGet("https://raw.githubusercontent.com/IdkTheSecond/idk/main/version.txt")
		if tostring(string.sub(realVersion2, 1, -2)) ~= currentVersion then
			toclipboard("https://discord.gg/asRy5w8Vg8")
			game.Players.LocalPlayer:Kick("Outdated version! Please run the new one from here: .gg/asRy5w8Vg8 or from clipboard.")
		end
		
		sniping = not sniping
		if sniping == true then
			local snipeArea = areaDropdown.Values[areaDropdown:GetActiveValues()]
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = snipeAreas[snipeArea][1]
			repeat
				repeat
					local args = {
						[1] = "WildGrass"
					}

					game:GetService("ReplicatedStorage").FindPokemon:InvokeServer(unpack(args))
				until #game:GetService("Players").LocalPlayer.OppPokemon:GetChildren() > 0

				local pokemon = game:GetService("Players").LocalPlayer.OppPokemon:GetChildren()[1]
				local pokemonName = pokemon.Name
				
				local catchlegendaries = {}
				for _, num in pairs(legendarySelectDropdown:GetActiveValues()) do
					table.insert(catchlegendaries, legendarySelectDropdown.Values[num])
				end
				
				for _, num in pairs(alwaysCatchLegendarySelectDropdown:GetActiveValues()) do
					table.insert(catchlegendaries, alwaysCatchLegendarySelectDropdown.Values[num])
				end
				
				if table.find(catchlegendaries, pokemonName) then
					local boxToAdd = unknownBox
					if catchSkins and pokemon:FindFirstChild("Skin") then
						print(pokemonName .. " WITH SKIN found!")
						boxToAdd = boxSkinnedLegendaries
					else
						print(pokemonName .. " found!")
						if sortPokemonToSpecificBox then
							boxToAdd = sortPokemonToBox[pokemonName] or 0
							if boxToAdd ~= 0 then
								boxToAdd += sortPokemonToSpecificBoxOffset
							else
								boxToAdd = unknownBox
							end
						end
					end

					local args = {
						[1] = pokemon,
						[2] = "Ultra Ball"
					}

					game:GetService("ReplicatedStorage").REvents.Pokemon.catchPokemon:InvokeServer(unpack(args))

					-- Change parent
					local args = {
						[1] = game:GetService("ReplicatedStorage").TempS[pokemonName],
						[2] = game:GetService("Players").LocalPlayer.PC:FindFirstChild("Box " .. tostring(boxToAdd))
					}

					game:GetService("ReplicatedStorage").REvents.PC.ParentChange:InvokeServer(unpack(args))

					-- Pokedex
					local args = {
						[1] = pokemonName
					}

					game:GetService("ReplicatedStorage").REvents.Pokemon.caughtPokedex:FireServer(unpack(args))

					-- Idk probably security
					local args = {
						[1] = game:GetService("Players").LocalPlayer.PC:FindFirstChild("Box " .. tostring(boxToAdd))[pokemonName],
						[2] = "Ultra Ball"
					}

					game:GetService("ReplicatedStorage").REvents.Pokemon.Caughter:InvokeServer(unpack(args))

					-- Strip item
					if stripItems then
						for _, child in pairs(game:GetService("Players").LocalPlayer.PC:FindFirstChild("Box " .. tostring(boxToAdd)):GetChildren()) do
							if child.Name == pokemonName and child.HeldItem.Value ~= "" then
								local args = {
									[1] = game:GetService("Players").LocalPlayer.PC:FindFirstChild("Box " .. tostring(boxToAdd))[pokemonName],
									[2] = ""
								}

								game:GetService("ReplicatedStorage").REvents.Pokemon.HeldItem:InvokeServer(unpack(args))
							end
						end
					end
				elseif catchSkins and pokemon:FindFirstChild("Skin") then
					print(pokemonName .. " WITH SKIN found!")

					local args = {
						[1] = pokemon,
						[2] = "Ultra Ball"
					}

					game:GetService("ReplicatedStorage").REvents.Pokemon.catchPokemon:InvokeServer(unpack(args))

					-- Change parent
					local args = {
						[1] = game:GetService("ReplicatedStorage").TempS[pokemonName],
						[2] = game:GetService("Players").LocalPlayer.PC:FindFirstChild("Box " .. tostring(boxNormalSkins))
					}

					game:GetService("ReplicatedStorage").REvents.PC.ParentChange:InvokeServer(unpack(args))

					-- Pokedex
					local args = {
						[1] = pokemonName
					}

					game:GetService("ReplicatedStorage").REvents.Pokemon.caughtPokedex:FireServer(unpack(args))

					-- Idk probably security
					local args = {
						[1] = game:GetService("Players").LocalPlayer.PC:FindFirstChild("Box " .. tostring(boxNormalSkins))[pokemonName],
						[2] = "Ultra Ball"
					}

					game:GetService("ReplicatedStorage").REvents.Pokemon.Caughter:InvokeServer(unpack(args))

					-- Strip item
					if stripItems then
						for _, child in pairs(game:GetService("Players").LocalPlayer.PC:FindFirstChild("Box " .. tostring(boxNormalSkins)):GetChildren()) do
							if child.Name == pokemonName and child.HeldItem.Value ~= "" then
								local args = {
									[1] = game:GetService("Players").LocalPlayer.PC:FindFirstChild("Box " .. tostring(boxNormalSkins))[pokemonName],
									[2] = ""
								}

								game:GetService("ReplicatedStorage").REvents.Pokemon.HeldItem:InvokeServer(unpack(args))
							end
						end
					end
				elseif stripItems and pokemon:WaitForChild("HeldItem").Value ~= "" then
					print(pokemonName .. " WITH ITEM found! Item: " .. pokemon.HeldItem.Value)
					-- Box doesn't matter cuz it gets deleted

					local args = {
						[1] = pokemon,
						[2] = "Ultra Ball"
					}

					game:GetService("ReplicatedStorage").REvents.Pokemon.catchPokemon:InvokeServer(unpack(args))

					-- Change parent
					local args = {
						[1] = game:GetService("ReplicatedStorage").TempS[pokemonName],
						[2] = game:GetService("Players").LocalPlayer.PC:FindFirstChild("Box " .. tostring(1))
					}

					game:GetService("ReplicatedStorage").REvents.PC.ParentChange:InvokeServer(unpack(args))

					-- Pokedex
					local args = {
						[1] = pokemonName
					}

					game:GetService("ReplicatedStorage").REvents.Pokemon.caughtPokedex:FireServer(unpack(args))

					-- Idk probably security
					local args = {
						[1] = game:GetService("Players").LocalPlayer.PC:FindFirstChild("Box " .. tostring(1))[pokemonName],
						[2] = "Ultra Ball"
					}

					game:GetService("ReplicatedStorage").REvents.Pokemon.Caughter:InvokeServer(unpack(args))

					-- Strip item
					local args = {
						[1] = game:GetService("Players").LocalPlayer.PC:FindFirstChild("Box " .. tostring(1))[pokemonName],
						[2] = ""
					}

					game:GetService("ReplicatedStorage").REvents.Pokemon.HeldItem:InvokeServer(unpack(args))


					-- Delete out of box
					game:GetService("ReplicatedStorage").REvents.PC.Release:FireServer(game:GetService("Players").LocalPlayer.PC:FindFirstChild("Box " .. tostring(1))[pokemonName])
				else
					--print("fail: " .. pokemonName)
				end

				game:GetService("ReplicatedStorage").REvents.PC.Release:FireServer(game:GetService("Players").LocalPlayer.OppPokemon:GetChildren()[1])
			until sniping ~= true
		end
	end
});
