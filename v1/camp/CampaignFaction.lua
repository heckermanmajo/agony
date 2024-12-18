local CampaignFaction = {}





function CampaignFaction.is(x) return getmetatable(x) == CampaignFaction end
function CampaignFaction.assert(x) assert(CampaignFaction.is(x), "Expected CampaignFaction. Got " .. type(x)) end

return CampaignFaction