local M = {}

local Cache = {}

function M.HasProperty(instance :Instance, property :string) :boolean
	if Cache[instance.ClassName] and Cache[instance.ClassName][property] then
		return true
	else
		local Clone = Instance.fromExisting(instance)
		local PropExists = pcall(function()
			return Clone[property]
		end)
		if PropExists then
			if not Cache[instance.ClassName] then
				Cache[instance.ClassName] = {}
			end
			Cache[instance.ClassName][property] = true
			return true
		end
	end
	return false
end

return M
