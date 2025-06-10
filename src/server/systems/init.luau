--[[
    This module is responsible for loading all the systems in the game. It will load all the systems in the systems folder and return them as a table.

    @module Systems
    @author Magik Manz (MagikTheWizard)
    @date 2025-05-02
]]--

local Systems = { }

for _, module in ipairs(script:GetChildren()) do
    if not module:IsA("ModuleScript") or script == module then
        continue
    end

    table.insert(Systems, require(module))
end

return table.freeze(Systems)
