function action = epsilonGreedy(agent,QTable)
global NUM_ACTIONS;
global EPSILON;

global FLAGS;
global USE_FIXED_AGENTS;
global GROUP_FIXED_AGENTS;
global ACTION_FIXED_AGENTS;
global NUM_FIXED_AGENTS;

if USE_FIXED_AGENTS == 1
    aType = FLAGS(agent);
    if aType == GROUP_FIXED_AGENTS && NUM_FIXED_AGENTS>0
        action = ACTION_FIXED_AGENTS;
        NUM_FIXED_AGENTS = NUM_FIXED_AGENTS - 1;
        return;
    end
end

maxi = max(QTable(agent,:)); %make sure argVal=QTable(a,action)
    bestAction = find(maxi == QTable(agent,:));
    if length(bestAction) > 1
        rn = ceil(rand*length(bestAction));
        bestAction = bestAction(rn); %(basically no need for this row because we use the index of the action)
    end  
iter = rand;
if (iter < (EPSILON)) %EXPLORATION 
    action = ceil(rand*NUM_ACTIONS); 
else                
    action = bestAction; %EXPLOITATION             
end

end