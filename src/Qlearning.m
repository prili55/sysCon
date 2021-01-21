function [RewardStorage,RewardStorageNormal, RewardStorageGreen, RewardStorageRich, ActionCountStorage,ActionCountNormal,ActionCountGreen,ActionCountRich] = Qlearning(PD_1, PD_2, PD_3)

global NUM_AGENTS;
global NUM_ACTIONS;
global NUM_ROUNDS;
global GROUP_CHANGE;
global ROUND_CHANGE;
global NUM_MOVING;
global GROUP_FROM;
global GROUP_TO;
global ALPHA;
global GAMMA;

%For Debug
global FLAGS;
global NUM_GROUP_A; 
global NUM_GROUP_B; 
global NUM_GROUP_C; 

global sens_groupA;
global sens_groupB;
global sens_groupC;
global costs_groupA;
global costs_groupB;
global costs_groupC;

global BUDGET_UPDATE;
global BUDGET_GROUP;
global BUDGET_WALK;

global USE_FIXED_AGENTS;
global NUM_FIXED_AGENTS;
global ORIGINAL_NUM_FIXED_AGENTS;

%INITIALIZE QTable
QTable = zeros(NUM_AGENTS,NUM_ACTIONS);
ActionStorage = zeros(NUM_AGENTS,NUM_ROUNDS); %Storage for chosen action each round
RewardStorage = zeros(NUM_AGENTS,NUM_ROUNDS); %Storage for reward recieved each round
RewardStorageNormal = zeros(NUM_AGENTS,NUM_ROUNDS); 
RewardStorageGreen = zeros(NUM_AGENTS,NUM_ROUNDS); 
RewardStorageRich = zeros(NUM_AGENTS,NUM_ROUNDS); 

ActionCountStorage = zeros(NUM_ACTIONS,NUM_ROUNDS);
ActionCountNormal = zeros(NUM_ACTIONS,NUM_ROUNDS);
ActionCountGreen = zeros(NUM_ACTIONS,NUM_ROUNDS);
ActionCountRich = zeros(NUM_ACTIONS,NUM_ROUNDS);

FormerBudgetUpdate = BUDGET_UPDATE;
FormerBudgetWalk = BUDGET_WALK;

%for the soft-max strategy
Initialtau = 3; %Initial tau ("High in beginning")
Endingtau = 0.5;
Tau = 3;

for t = 1:NUM_ROUNDS
    
    % for moving agents between groups
    if t == ROUND_CHANGE && GROUP_CHANGE == 1
        updateFlags(NUM_MOVING,GROUP_FROM,GROUP_TO);
        GROUP_CHANGE = 0;
    end
    
%%when using fixed agents
%     if t == 2000
%         USE_FIXED_AGENTS = 1;
%     end
  
%%when using fixed budget
%     if t == 3000
% %         sens_groupA(3) = 1*2;
% %         sens_groupB(3) = 1.4*2;
%          sens_groupC(3) = 0.8*1.8;
%          BUDGET_UPDATE = 1;
%     end 
    
    ActionCount = zeros(1,NUM_ACTIONS); %Keep a running sum of the number of times each action is selected.
    for a = 1:NUM_AGENTS
        action = epsilonGreedy(a, QTable);
        %action = softMax(a,QTable,Tau);

        ActionStorage(a,t) = action;
        ActionCount(action) = ActionCount(action)+1; 
        ActionCountStorage(action,t) = ActionCountStorage(action,t)+1;
        aType = FLAGS(a);
        switch aType
            case 1
                ActionCountNormal(action,t) = ActionCountNormal(action,t)+1;
            case 2
                ActionCountGreen(action,t) = ActionCountGreen(action,t)+1;
            case 3
                ActionCountRich(action,t) = ActionCountRich(action,t)+1;
        end
        
    end
    %Now that all agents decide what are their actions, give rewards
    for a = 1:NUM_AGENTS
        action = ActionStorage(a,t);
        r_t = getReward(a,action,ActionCount,PD_1, PD_2, PD_3);  
        if BUDGET_UPDATE == 1 && action == 3
            updateBudget(a,BUDGET_GROUP);
        end   
        RewardStorage(a,t) = r_t;
        aType = FLAGS(a);
        switch aType
            case 1
                RewardStorageNormal(a,t) = r_t;
            case 2
                RewardStorageGreen(a,t) = r_t;
            case 3
                RewardStorageRich(a,t) = r_t;
        end
        %update Q-Table
        old_qValue = QTable(a,action);
        %find the action with the mazimum Q-value
        maxi = max(QTable(a,:));
        bestAction = find(maxi == QTable(a,:));
        if length(bestAction) > 1
            rn = ceil(rand*length(bestAction));
            bestAction = bestAction(rn);
        end 
        estimate = QTable(a,bestAction); %=maxi
        new_qValue = (1-ALPHA)*old_qValue + ALPHA*(r_t+GAMMA*estimate);
        QTable(a,action) = new_qValue;
    end  
    %update tau for next round
    Tau = Initialtau *(Endingtau/Initialtau)^(t/NUM_ROUNDS);
    NUM_FIXED_AGENTS = ORIGINAL_NUM_FIXED_AGENTS;
end
    %If ITERATIONS>1
%    BUDGET_UPDATE = FormerBudgetUpdate;
%    BUDGET_WALK = FormerBudgetWalk;
    %Return to initial state
%     updateFlags(0,0,0);
%     updateNumAgentsGroup(0,0,0)
%     GROUP_CHANGE = 1;
%         sens_groupA(3) = 1;
%         sens_groupB(3) = 1.4;
%         sens_groupC(3) = 0.8;
end