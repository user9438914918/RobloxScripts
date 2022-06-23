-- works as of 25/06/2022
-- https://roblox.com/games/2210085102/
-- loop kill unfinished

local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()
local players = game:GetService("Players")

local UI = Material.Load({
	Title = "Naval Warfare GUI",
	Style = 3,
	SizeX = 300,
	SizeY = 200,
	Theme = "Light"
})

local KillMenu = UI.New({Title = "Kill Menu"})
local TeleportMenu = UI.New({Title = "Teleport Menu"})
local Misc = UI.New({Title = "Misc"})


--------------------------------------------------------------


local LoopKillWithGunToggle, LoopKillWithRPGToggle, KillAuraToggle
local LoopKillWithGun, LoopKillWithRPG, KillAura

local KillAllWithGunBtn = KillMenu.Button({
	Text = "Kill all with Rifle",
	Callback = function()
		LoopKillWithRPGToggle:SetState(false)
		LoopKillWithGunToggle:SetState(false)
		KillAuraToggle:SetState(false)
		local localPlr = players.LocalPlayer
		for i,v in pairs(players:GetPlayers()) do
			if v.Name ~= localPlr.Name and v.TeamColor ~= localPlr.TeamColor then
				local enemyChar = v.Character
				local localChar = localPlr.Character
				if (not enemyChar or not localChar) then continue end
				if (enemyChar.HumanoidRootPart.Position - workspace.Lobby.Flags.Position).Magnitude <= 50 then continue end
				if (enemyChar.HumanoidRootPart.Position.Y <= 0) then continue end
				
				localChar.Humanoid:UnequipTools()
				for z,Tool in pairs(localPlr.Backpack:GetChildren()) do
					if Tool.Name == "M1 Garand" then
						localChar.Humanoid:EquipTool(Tool)
						break
					end
				end
				
				localChar:MoveTo(enemyChar.HumanoidRootPart.Position + Vector3.new(0,3,0))
				local Event = game:GetService("ReplicatedStorage").Event
				task.spawn(function()
					for i = 1, 20 do
						Event:FireServer("shootRifle", "", {enemyChar.Head})
						Event:FireServer("shootRifle", "hit", {enemyChar.Humanoid})
						task.wait()
					end
				end)
				task.wait(1.5)
			end
		end
	end
})

LoopKillWithGunToggle = KillMenu.Toggle({
	Text = "Loop kill with Rifle",
	Callback = function(value)
		if value then
			LoopKillWithGun = true
			LoopKillWithRPGToggle:SetState(false)
			KillAuraToggle:SetState(false)
		else
			LoopKillWithGun = false
		end
	end
})

local KillAllWithRPGBtn = KillMenu.Button({
	Text = "Kill all with RPG (Ineffective)",
	Callback = function()
		LoopKillWithRPGToggle:SetState(false)
		LoopKillWithGunToggle:SetState(false)
		KillAuraToggle:SetState(false)
		local localPlr = players.LocalPlayer
		for i,v in pairs(players:GetPlayers()) do
			if v.Name ~= localPlr.Name and v.TeamColor ~= localPlr.TeamColor then
				local enemyChar = v.Character
				local localChar = localPlr.Character
				if (not enemyChar or not localChar) then continue end
				if (enemyChar.HumanoidRootPart.Position - workspace.Lobby.Flags.Position).Magnitude <= 50 then continue end
				if (enemyChar.HumanoidRootPart.Position.Y <= 0) then continue end
				
				localChar.Humanoid:UnequipTools()
				local children = localPlr.Backpack:GetChildren()
				for z,Tool in pairs(children) do
					local equipped = false
					if Tool.Name == "RPG" then
						localChar.Humanoid:EquipTool(Tool)
						equipped = true
					end
					if z == #children and not equipped then
						return
					end
				end
				
				localChar:MoveTo(enemyChar.HumanoidRootPart.Position + Vector3.new(0,3,0))
				local Event = game:GetService("ReplicatedStorage").Event
				task.spawn(function()
					Event:FireServer("fireRPG", {localChar.HumanoidRootPart.Position})
					task.wait()
				end)
				task.wait(2.5)
			end
		end
	end
})

LoopKillWithRPGToggle = KillMenu.Toggle({
	Text = "Loop kill with RPG (Ineffective)",
	Callback = function(value)
		if value then
			LoopKillWithRPG = true
			LoopKillWithGunToggle:SetState(false)
			KillAuraToggle:SetState(false)
		else
			LoopKillWithRPG = false
		end
	end
})

KillAuraToggle = KillMenu.Toggle({
	Text = "Kill Aura (Equip Rifle)",
	Callback = function(value)
		if value then
			KillAura = true
			LoopKillWithGunToggle:SetState(false)
			LoopKillWithRPGToggle:SetState(false)
			
			while KillAura do
				task.wait(0.3)
				print("yes")
				local localPlr = players.LocalPlayer
				for i,v in pairs(workspace:GetChildren()) do
					if v.Name ~= localPlr.Name then
						if v:FindFirstChild("Humanoid") then
			            	local enemyPlr = players:GetPlayerFromCharacter(v)
			            	if enemyPlr.TeamColor ~= localPlr.TeamColor then
			            		enemyChar = v
			            		local localChar = localPlr.Character
			            		if (enemyChar.HumanoidRootPart.Position - localChar.HumanoidRootPart.Position).Magnitude <= 300 then
			            			task.spawn(function()
										for i = 1, 10 do
											local Event = game:GetService("ReplicatedStorage").Event
											Event:FireServer("shootRifle", "", {enemyChar.Head})
											Event:FireServer("shootRifle", "hit", {enemyChar.Humanoid})
											task.wait()
										end
									end)
			            		end
			            	end
						end
					end
				end
			end
		else
			KillAura = false
		end
	end
})


--------------------------------------------------------------


local TeleportToABtn = TeleportMenu.Button({
	Text = "Teleport To A",
	Callback = function()
		local localPlr = players.LocalPlayer
		local character = localPlr.Character
		if (not character) then return end
		character.HumanoidRootPart.CFrame = workspace.IslandA.Flag.Post.CFrame + Vector3.new(1,0,0)
		localPlr.PlayerGui.ScreenGui.RemoveUniform.Visible = false
	end
})

local TeleportToBBtn = TeleportMenu.Button({
	Text = "Teleport To B",
	Callback = function()
		local localPlr = players.LocalPlayer
		local character = localPlr.Character
		if (not character) then return end
		character.HumanoidRootPart.CFrame = workspace.IslandB.Flag.Post.CFrame + Vector3.new(1,0,0)
		localPlr.PlayerGui.ScreenGui.RemoveUniform.Visible = false
	end
})

local TeleportToCBtn = TeleportMenu.Button({
	Text = "Teleport To C",
	Callback = function()
		local localPlr = players.LocalPlayer
		local character = localPlr.Character
		if (not character) then return end
		character.HumanoidRootPart.CFrame = workspace.IslandC.Flag.Post.CFrame + Vector3.new(1,0,0)
		localPlr.PlayerGui.ScreenGui.RemoveUniform.Visible = false
	end
})

local function UpdateIslandNames()
	task.spawn(function()
		for i, v in pairs(workspace:GetChildren()) do
			if v.Name == "Island" then
				v.Name = ("Island" .. v.IslandCode.Value)
			end
			task.wait()
		end
	end)
end

UpdateIslandNames()

workspace.ChildAdded:Connect(function()
	UpdateIslandNames()
end)


--------------------------------------------------------------


local WalkSpeedSlider = Misc.Slider({
	Text = "Walk Speed",
	Callback = function(value)
		local localPlr = players.LocalPlayer
		local character = localPlr.Character
		if (not character) then return end
		local humanoid = character:FindFirstChild("Humanoid")
		if (not humanoid) then return end
		
		humanoid.WalkSpeed = value
	end,
	Min = 16,
	Max = 200,
	Def = 16
})

local JumpPowerSlider = Misc.Slider({
	Text = "Jump Power",
	Callback = function(value)
		local localPlr = players.LocalPlayer
		local character = localPlr.Character
		if (not character) then return end
		local humanoid = character:FindFirstChild("Humanoid")
		if (not humanoid) then return end
		
		humanoid.JumpPower = value
	end,
	Min = 50,
	Max = 500,
	Def = 50
})

local walkSpeedBeforeDeath, jumpPowerBeforeDeath

local function lol()
	local localPlr = players.LocalPlayer
	local function e()
		localPlr.Character:WaitForChild("Humanoid").Died:Connect(function()
			walkSpeedBeforeDeath = localPlr.Character.Humanoid.WalkSpeed
			jumpPowerBeforeDeath = localPlr.Character.Humanoid.JumpPower
		end)
	end
	e()
	
	localPlr.CharacterAdded:Connect(function()
		localPlr.Character:WaitForChild("Humanoid").WalkSpeed = walkSpeedBeforeDeath
		localPlr.Character:WaitForChild("Humanoid").JumpPower = jumpPowerBeforeDeath
		e()
	end)
end

lol()

--------------------------------------------------------------


local banner = UI.Banner({Text = "Exploit made by github.com/ahmadinator  |  UI Library provided by github.com/Kinlei"})
