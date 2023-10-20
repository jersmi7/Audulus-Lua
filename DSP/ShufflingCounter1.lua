--[[ 
Shuffling counter :: Jerry Smith, 2023

Non-repeating random number counter
Inputs: Trigger Reset Regen Low High Pattern Shuffle regenAt shuffleLow shuffleHigh 
Outputs: Sequence Mod Wrap Cycles 

• The sequence will always start up with the same random sequence.
• Trigger receives any gate or trigger signal to advance the counter.
• Regen will generate a new table of shuffled random values [0,1]. (Also, regen is configured here to wait until the next trigger to do its job.)
• cycleRegen and regenAt set the number of cycles to repeat a shuffled sequence.
• Low and high boundaries set the range of the sequence. Output subtracts 1 for 0 to n-1 range (for Audulus muxes and what not).
• Reset resets the sequence to low bound. Set useImmediateReset to reset immediately or wait until the next trigger.
• shuffleLow and shufffleHigh set the boundaries for shuffling.
• Repeat shuffle cycle maps the shuffled cycle across the sequence.
• Up, down, up-down exc, up-down inc, down-up exc, down-up inc.
• Impatience jumps ahead randomly from 0 to set value.
--]]


init = 1
prevTrig = 0
triggerNext = 0
prevRegen = 0
regenNext = 0
prevReset = 0
resetNext = 0
sequence = {}
count = 0
prevCount = 0
cycles = 0

useImmediateReset = 1

-- Fisher-Yates "shuffle in place" algorithm
local function shuffle(t, n)
    for j = 1, n do t[j] = j end
    for j = #t, 2, -1 do
        local k = math.random(j)
        t[j], t[k] = t[k], t[j]
    end
end

function resetMode(mode, trigger, reset)
	if mode == 1 then
        if reset > 0 and prevReset == 0 or count >= length then 
            count = 0
            triggerNext = 0
        end
    else
        if reset > 0 and prevReset == 0 then
            triggerNext = triggerNext + 1
        end

        if triggerNext > 0 and trigger > 0 and prevTrig == 0 or count >= length then 
            count = 0
            triggerNext = 0
        end
    end
end

function process(frames)

    -- Wait until the next count
    if Regen[1] > 0 and prevRegen == 0 then
        regenNext = regenNext + 1
    end
	
	
    length = High[1] - Low[1] + 1

    if init > 0 or (regenNext > 0 and Trigger[1] > 0 and prevTrig == 0) then 
        init = 0
        regenNext = 0
        shuffle(sequence, length)
    end

    if Trigger[1] > 0 and prevTrig == 0 then
        count = count + 1    
    end
	
	resetMode(useImmediateReset, Trigger[1], Reset[1])
	
	-- Check if it's time to reshuffle the sequence
	if count == 0 and Trigger[1] > 0 and prevTrig == 0 then
    	cycles = cycles + 1
    	if cycles >= regenAt[1] then
        	cycles = 0
        		if cycleRegen[1] > 0 then
        			shuffle(sequence, length)
        		end
    	end
    end
    
    low, high = Low[1] - 1, High[1] - 1
    shuffled = sequence[count + 1] + low
	
	
    if Shuffle[1] > 0 then
        fill(Sequence, shuffled)
    else
        fill(Sequence, count + low)
    end
    
    fill(Mod, Sequence[1] / high)
    
    if count == 0 then -- and Trigger[1] > 0 and prevTrigger == 0 then
    	fill(Wrap, 1)
    else 
    	fill(Wrap, 0)
    end
    
    fill(Cycles, cycles)

    prevRegen = Regen[1]
    prevTrig = Trigger[1]
    prevReset = Reset[1]
    prevCount = 0
end
