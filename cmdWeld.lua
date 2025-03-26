-- paste the entire script in the command line

local CHS = game:GetService('ChangeHistoryService')
local Selection = game:GetService("Selection"):Get()

if #Selection ~= 2 then
	error('select 2 instances only, first is instance of which all descendants to weld and second what part to weld it to')
end
if not Selection[2]:IsA('BasePart') then
	error('second instance must be a basepart')
end

local weldsMade = 0
local function weld(part1, part2)
	weldsMade += 1
	local newWeld = Instance.new('WeldConstraint')
	newWeld.Parent = part1
	newWeld.Enabled = true
	newWeld.Part0 = part1
	newWeld.Part1 = part2
end

local recordData = CHS:TryBeginRecording('Weld')
if not recordData then error('changehistoryservice') end

if Selection[1]:IsA('BasePart') then
	weld(Selection[1], Selection[2])
end
for _,instance in pairs(Selection[1]:GetDescendants()) do
	if instance:IsA("BasePart") and instance ~= Selection[2] then
		if instance:FindFirstAncestorWhichIsA('ViewportFrame') then continue end
		weld(instance, Selection[2])
	end
end
CHS:FinishRecording(recordData, Enum.FinishRecordingOperation.Commit)
warn('- done successfully - welds made: ' .. tostring(weldsMade))
