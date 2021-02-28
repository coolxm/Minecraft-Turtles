local SlotCount = 16    --16 is for chest
local width, depth, height = 2, 2, 2
local d = "north"

-- Check arguments for size
if (#arg == 3) then
    --If 3 arguments are present, continue
    width = tonumber(arg[1])
    depth = tonumber(arg[2])
    height = tonumber(arg[3])
else
    print("Bad size given, defaulting to 2, 2, 2")
end

function ReFuel()
    --Default position to 1
    turtle.select(1)

    if(turtle.getFuelLevel() < 50) then
        -- Does the turtle have enough fuel
        print("refuel in progress")
        
        local slot = 1
        -- Check all slots for fuel
        while(slot ~= SlotCount) do
            turtle.select(slot)
            if (turtle.refuel(1)) then
                return true
            end
            slot = slot + 1
        end

        return false
    else
        return true
    end
end

function LookForChest()
    turtle.select(1)
    for slot = 1, SlotCount, 1 do
        local item = turtle.getItemDetail(slot)

        if (item ~= nil) then
            if (item["name"] == "enderstorage:ender_storage") then
                return slot
            end
        end
    end
    return false
end

function store()
    chest = LookForChest()
    if (chest ~= nil) then
        turtle.select(chest)
        turtle.digUp()
        turtle.placeUp()
    else
        print("No chest")
    end
    -- chest deployed

    local coal = 0
    for slot = 1, SlotCount, 1 do
        local item = turtle.getItemDetail(slot)
        if (item ~= nil and item["name"] ~= "minecraft:coal_block" and item["name"] ~= "minecraft:coal") then
             turtle.select(slot)
             turtle.dropUp()
        else
            coal = coal + 1                         
        end
    end

    -- Check if all slots aren't filled with coal
    if coal == 16 then
        for slot = 3, SlotCount, 1 do
            if (slot ~= chest) then
                turtle.dropUp()
            end
        end
    end 

    print("stored")

    turtle.select(1)
    turtle.digUp()
end

function dig()
    while (turtle.detect() or turtle.detectUp() or turtle.detectDown()) do
        turtle.dig()
        turtle.digUp()
        turtle.digDown()
    end
end

function GetFuel()
    -- TODO
end

function Forward()
    dig()
    turtle.forward()
end

function TurnAround(tier)
    if(tier % 2 == 1) then
        if(d == "north" or d == "east") then
            TurnRight()
        elseif(d == "south" or d == "west") then
            TurnLeft()
        end

    else
        if(d == "north" or d == "east") then
            TurnLeft()
        elseif(d == "south" or d == "west") then
            TurnRight()
        end

    end

    flipNamed()
end

function TurnRight()
    turtle.turnRight()
    dig()
    turtle.forward()
    turtle.turnRight()
    dig()
end

function TurnLeft()
    turtle.turnLeft()
    dig()
    turtle.forward()
    turtle.turnLeft()
    dig()
end

function flipNamed()

    if(d == "north") then
        d = "south"

    elseif(d == "south") then
        d = "north"

    elseif(d == "west") then
        d = "east"

    elseif(d == "east") then
        d = "west"

    end
end

function Up()
    turtle.turnRight()
    turtle.turnRight()
    flipNamed()
    turtle.digUp()
    turtle.up()
    turtle.digUp()
    turtle.up()
    turtle.digUp()
    turtle.up()
end

function Down()
    turtle.digDown()
    turtle.down()
    turtle.digDown()
    turtle.down()
    turtle.digDown()
    turtle.down()
end

function OnStart()

   for tier = 1, height, 1 do
        -- while needed height is not reached
        for col = 1, width, 1 do
            -- while needed width is not reached
            for row = 1, depth, 1 do
                -- while needed depth is not reached
                if (not ReFuel()) then
                    -- if Refuel does not return True, stop
                    print("out of fuel, powering down...")
                    return
                end
                
                Forward()
                print(string.format("row: %d col: %d", row, col))
                -- Go forward
            end
            
            if (col ~= width) then
                TurnAround(tier)
            end
            store()
            -- Turn
        end

        if tier == height then
            for i = 1, height, 1 do
                Down()
            end
            return
        end
        Up()
        -- Tier up
    end
end

OnStart()
print("done")
-- Start the program when all is given