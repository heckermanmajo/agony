
--- Formation Function
---
--- Generates positions for units to form around a given central position based on a specified formation type.
---
--- @param units table A list of unit objects. Each unit must have a `collision_radius` field. The collision radius can differ for each unit.
--- @param center table The central position of the formation, provided as a table with `x` and `y` fields.
--- @param spacing number The desired spacing between units in the formation. This is the minimum distance between the edges of the units.
--- @param formationType string The type of formation. Accepted values: "line", "grid", "unorganized".
--- @return table A list of positions (tables with `x` and `y` fields) mapped to the units.
---
--- Usage Example:
--- local formationPositions = createFormation(units, {x = 100, y = 100}, 10, "line")
local function createFormation(units, center, spacing, formationType)
    local positions = {}

    if formationType == "line" then
        -- Line formation: Units are placed in a straight line.
        local currentX = center.x - (#units - 1) * (spacing / 2)
        for i, unit in ipairs(units) do
            table.insert(positions, {x = currentX, y = center.y})
            currentX = currentX + spacing + unit.collision_radius * 2
        end
    elseif formationType == "grid" then
        -- Grid formation: Units are placed in a grid pattern.
        local rowWidth = math.ceil(math.sqrt(#units))
        local startX = center.x - (rowWidth - 1) * (spacing / 2)
        local currentX, currentY = startX, center.y

        for i, unit in ipairs(units) do
            -- Place unit at the current position
            table.insert(positions, {x = currentX, y = currentY})

            -- Move to the next grid column
            currentX = currentX + spacing + unit.collision_radius * 2

            -- If end of row is reached, reset X and move to the next row
            if (i % rowWidth) == 0 then
                currentX = startX
                currentY = currentY + spacing + unit.collision_radius * 2
            end
        end
    elseif formationType == "unorganized" then
        -- Unorganized formation: Units are placed randomly around the center.
        local math_random = math.random
        for _, unit in ipairs(units) do
            local angle = math_random() * 2 * math.pi
            local distance = math_random() * spacing * #units
            table.insert(positions, {
                x = center.x + math.cos(angle) * (distance + unit.collision_radius),
                y = center.y + math.sin(angle) * (distance + unit.collision_radius)
            })
        end
    else
        error("Invalid formation type: " .. tostring(formationType))
    end

    return positions
end
