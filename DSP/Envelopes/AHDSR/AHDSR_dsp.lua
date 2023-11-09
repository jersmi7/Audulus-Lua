
-- AHDSR envelope with velocity, log/exp curves, depth, and shrink/stretch
-- Jerry Smith :: 2023

-- Inputs: gate A H D S R curve 
-- Outputs: envelope a h d s r Curve position time vel A_maxTime H_maxTime D_maxTime R_maxTime Aexp Dexp Rexp 

-- Set envelope times here
local attack_maxTime = 1
local hold_maxTime = 1
local decay_maxTime = 1
local release_maxTime = 1

-- Set log/exponential curves here
local A_exponent = 0.33
local D_exponent = 3
local R_exponent = 3



-- State variables
env = env or 0
envOut = envOut or 0
elapsedTime = elapsedTime or 0
attackStage = attackStage or true
holdStage = holdStage or false
decayStage = decayStage or false
sustainStage = sustainStage or false
releaseStage = releaseStage or false
prevGate = prevGate or 0
velocity = velocity or 0
currentEnv = currentEnv or 0
newStart = newStart or 0
holdTime = holdTime or 0



function process(frames)
	-- Set knob/slider tapers here
	-- for example, A[1] * A[1] * attack_maxTime
    ATTACK = A[1] * attack_maxTime
  	HOLD = H[1] * hold_maxTime
  	DECAY = D[1] * decay_maxTime
  	RELEASE = R[1] * release_maxTime
    
    local blockTime = frames / sampleRate
    
    -- Elapsed time, pause at sustain
    if not sustainStage then
        elapsedTime = elapsedTime + blockTime
    end
    
    -- Re-trigger
    if gate[1] > 0 and prevGate <= 0 then
        newStart = envOut
        env = newStart
        attackStage = true
        holdStage = false
        decayStage = false
        releaseStage = false
        velocity = gate[1]
        holdTime = H[1] * hold_maxTime
        elapsedTime = 0
    end  
  	
  	
  	
    if gate[1] > 0 then

        if attackStage then
        	local attackRange = 1 - newStart * 0.99
            local attackIncrement = blockTime / ATTACK * attackRange
            env = math.min(env + attackIncrement, 1)
            
            if curve[1] > 0 then
             	-- logarithmic attack
             	-- the case for retriggering the env before it finishes
                local normAttack = (env - newStart) / attackRange
    			local attackCurve = normAttack ^ (1 - normAttack ^ 0.33)
    			envOut = newStart + attackCurve * attackRange
            else
            	envOut = env
            end
            
            if env >= 1 then
                env = 1
                attackStage = false
                holdStage = true             
            end
                  
        elseif holdStage then
            holdTime = holdTime - blockTime
            envOut = 1  -- Output is held at the peak during hold stage
            
            if holdTime <= 0 then
                holdStage = false
                decayStage = true
            end
                  
        elseif decayStage then
        	sustain = S[1] * 0.98 + 0.01
    		local decayRange = 1 - sustain
    		local decayDecrement = blockTime / DECAY * decayRange
    		env = math.max(env - decayDecrement, sustain)

    		if curve[1] > 0 then
       			-- exponential decay
        		local normDecay = (env - sustain) / decayRange
        			if normDecay > 0 then
            			local decayCurve = normDecay ^ 3
            			envOut = sustain + decayCurve * decayRange
        			else
            			envOut = sustain
        			end
    		else
        		envOut = env -- linear decay
    		end
                    
    		if env <= sustain then
        		env = sustain
        		decayStage = false
        		sustainStage = true
        		releaseStage = true
    		end  
		end
    else 
        -- release from current
        if gate[1] <= 0 and prevGate > 0 then
        	env = 1
        	currentEnv = envOut
        	sustainStage = false
            releaseStage = true
        end
        
        if releaseStage then	
        	local releaseDecrement = blockTime / RELEASE
        	env = math.max(env - releaseDecrement, 0)
        	
        	if curve[1] > 0 then
        		-- exponential release
            	envOut = env^3 * currentEnv 
            else
            	envOut = env * currentEnv
            end

        	if env <= 0 then
        		releaseStage = false    
        		attackStage = true
        	end
        end
    end
    
    fill(envelope, envOut * velocity)
    fill(position, envOut)
	fill(time, elapsedTime)
	fill(vel, velocity)
	fill(A_maxTime, attack_maxTime)
	fill(H_maxTime, hold_maxTime)
	fill(D_maxTime, decay_maxTime)
	fill(R_maxTime, release_maxTime)
	fill(Aexp, A_exponent)
	fill(Dexp, D_exponent)
	fill(Rexp, R_exponent)
	fill(a, ATTACK)
	fill(h, HOLD)
	fill(d, DECAY)
	fill(s, S[1])
	fill(r, RELEASE)
	fill(Curve, curve[1])
	
    prevGate = gate[1]
end
