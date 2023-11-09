-- Lorenz Attractor LFO. 
-- Classic ever-evolving chaotic system

-- Inputs: Rate Scale Reset
-- Outputs: X Y Z time



function createLorenzLFO()
    -- Initial conditions
    local x, y, z = 0.01, 0.01, 0.01
    local prev_reset = 0
    local elapsedTime = 0
    local resetTime = 10
    local safetyThreshold = 2

    return function(rate, scale, reset)
        
        -- Lorenz system parameters
        local sigma = 9.0
        local rho = 28.0
        local beta = 8.0 / 3.0

        -- Time step for integration
        local dt = rate * rate * 0.02 + 0.0001
		
		-- looping counter
        if elapsedTime >= resetTime then
            elapsedTime = 0
        end 

        local scale_x = scale * 0.06
        local scale_y = scale * 0.05
        local scale_z = scale * 0.06

        if reset > 0 and prev_reset <= 0 then
            x, y, z = 0.01, 0.01, 0.01
            elapsedTime = 0
        else
            -- Lorenz attractor equations
            local dx = sigma * (y - x) * dt
            local dy = (x * (rho - z) - y) * dt
            local dz = (x * y - beta * z) * dt

            -- Update positions
            x = x + dx
            y = y + dy
            z = z + dz

            elapsedTime = elapsedTime + dt
        end

        local outputX = x * scale_x
        local outputY = y * scale_y
        local outputZ = (z * scale_z) - 1
        
        if math.abs(outputX) > safetyThreshold or 
        	math.abs(outputY) > safetyThreshold or 
        	math.abs(outputZ) > safetyThreshold then
            x, y, z = 0.01, 0.01, 0.01
			elapsedTime = 0
        end

        fill(X, outputX)
        fill(Y, outputY)
        fill(Z, outputZ)
        fill(time, elapsedTime)
        
        prev_reset = reset
    end
end

local lorenzLFO = createLorenzLFO()

function process(frames)
    lorenzLFO(Rate[1], Scale[1], Reset[1])
end
