-- Basic counter
-- Jerry Smith :: 2024

-- Input: trigger
-- Output: count

-- This script demonstrates a basic counter in Audulus, which increments on each trigger input and loops.

-- This approach is the equivalent of the node-based Audulus counter using sample and hold with an expression (using feedback).

-- We are using fill() here, so we get CPU savings (around 2x) because we are processing at every block (audio buffer) instead of every frame (audio sample). (This is like using the "legacy" A3 feedback delay node whereas, as of this writing, A4 nodes always processes every sample in a feedback loop.)

-- Using storage is the same as selecting "save data" on the sample and hold node. Storage Samples uses memory when saving your patch, set it as small as possible (16 in this case)

-- Counter loop value
local n = 4

-- Declare state variables
local Count = 0
local prevTrig = 0
local loadState = true
local saveState = false



-- The process function is called at block rate.
-- "frames" refers to number of samples in the current audio block.
function process(frames)
	
	-- Initial state loading
    if loadState then
        -- On the first process call, load the saved count from storage.
        -- "storage[1]" refers to the first index in a predefined storage array for persisting data across sessions.
        -- "Storage Samples" sets the number of indexes you can access.
        Count = storage[1] or 0  -- Load saved count, defaulting to 0 if storage[1] is nil.
        loadState = false  -- Prevent further loading after the initial load.
    end	
	
	
	-- Trigger detection
    -- A trigger is processed by comparing the current and previous trigger values.
    -- A rising edge (transition from 0 to a positive value) increments the counter.
    if trigger[1] > 0 and prevTrig == 0 then
    	-- Increment count, with modulo for wrap-around.
        Count = (Count + 1) % n  -- Loop counter from 0 to (n-1)
        -- Count = Count % n + 1  -- Loop counter from 1 to n
        saveState = true  -- Set flag to save the new count value to storage.
    end
    prevTrig = trigger[1]  -- Update previous trigger value for the next block.
    
    
	-- Output the current count value once per block ("fill" the buffer at "control rate").
    fill(count, Count)
	
	-- State saving
    if saveState then
        storage[1] = Count  -- Save the current count to the first index in the storage array.
        saveState = false  -- Reset the save flag until the next trigger.
    end
end
