-- works as of 25/06/2022
-- https://roblox.com/games/7952502098/
-- marks the wrong path and lets you jump on it

while true and task.wait() do
	for i,v in pairs(game:GetService("Workspace")["Glass Bridge"].GlassPane:GetDescendants()) do
		if v.Name == 'TouchInterest' then
			v.Parent.BrickColor = BrickColor.new("Bright red")
			v.Parent.CanCollide = true
		end
	end
end
