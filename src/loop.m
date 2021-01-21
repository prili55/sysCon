%Script file to run the N-armed1bandit using the epsilon-greedy strategy
function [Ravg,RavgNormal,RavgGreen, RavgRich, Aavg,AavgNormal,AavgGreen,AavgRich] = loop(PD_1, PD_2, PD_3)

global NUM_ROUNDS;
NUM_ROUNDS = 5000; 
global NUM_AGENTS;
global NUM_ACTIONS;
ITERATIONS = 1; %instead of 10 
Ravg = zeros(NUM_AGENTS,NUM_ROUNDS);  %coloumn vector
RavgNormal = zeros(NUM_AGENTS,NUM_ROUNDS);  %coloumn vector
RavgGreen = zeros(NUM_AGENTS,NUM_ROUNDS);  %coloumn vector
RavgRich = zeros(NUM_AGENTS,NUM_ROUNDS);  %coloumn vector

Aavg = zeros(NUM_ACTIONS,NUM_ROUNDS);  %coloumn vector
AavgNormal = zeros(NUM_ACTIONS,NUM_ROUNDS);  %coloumn vector
AavgGreen = zeros(NUM_ACTIONS,NUM_ROUNDS);  %coloumn vector
AavgRich = zeros(NUM_ACTIONS,NUM_ROUNDS);  %coloumn vector

%call the program ITERATIONS times, each call will consist of NUM_ROUNDS plays.
for j = 1:ITERATIONS
    [RewardStorage,RewardStorageNormal, RewardStorageGreen, RewardStorageRich, ActionCountStorage,ActionCountNormal,ActionCountGreen,ActionCountRich] = Qlearning(PD_1, PD_2, PD_3); %NUM_AGENTSxNUM_ROUNDS matrix
    %[RewardStorage,ActionCountStorage] = Sarsa(PD_1, PD_2, PD_3); %NUM_AGENTSxNUM_ROUNDS matrix
    for a = 1:NUM_AGENTS
        Ravg(a,:) = Ravg(a,:) + RewardStorage(a,:); %avgRewards
        RavgNormal(a,:) = RavgNormal(a,:) + RewardStorageNormal(a,:); %avgNormalRewards
        RavgGreen(a,:) = RavgGreen(a,:) + RewardStorageGreen(a,:); %avgGreenRewards
        RavgRich(a,:) = RavgRich(a,:) + RewardStorageRich(a,:); %avgRichRewards
    end
    
    for ac = 1:NUM_ACTIONS
        Aavg(ac,:) = Aavg(ac,:) + ActionCountStorage(ac,:); %avgActions
        AavgNormal(ac,:) = AavgNormal(ac,:) + ActionCountNormal(ac,:); %avgNormalActions
        AavgGreen(ac,:) = AavgGreen(ac,:) + ActionCountGreen(ac,:); %avgGreenActions
        AavgRich(ac,:) = AavgRich(ac,:) + ActionCountRich(ac,:); %avgRichActions
    end
    
    %if mod(j,10) == 0  %instead of 500
        fprintf('Loop: On iterate %d\n',j);
    %end
end

Ravg = Ravg./(ITERATIONS);
RavgNormal = RavgNormal./(ITERATIONS);
RavgGreen = RavgGreen./(ITERATIONS);
RavgRich = RavgRich./(ITERATIONS);

Aavg = Aavg./(ITERATIONS);
AavgNormal = AavgNormal./(ITERATIONS);
AavgGreen = AavgGreen./(ITERATIONS);
AavgRich = AavgRich./(ITERATIONS);
end