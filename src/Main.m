%%%%% Global parameters %%%%%
global NUM_AGENTS;
NUM_AGENTS = 300; 
global NUM_ACTIONS;
NUM_ACTIONS = 3; %need to adjust the PDs if this number changes

%%%%% Three Groups %%%%%
global NUM_GROUP_A; %NORMAL
NUM_GROUP_A = 100;  
global NUM_GROUP_A_ORIGINAL; 
NUM_GROUP_A_ORIGINAL = NUM_GROUP_A;
global NUM_GROUP_B; %GREEN
NUM_GROUP_B = 100; 
global NUM_GROUP_B_ORIGINAL; 
NUM_GROUP_B_ORIGINAL = NUM_GROUP_B;
global NUM_GROUP_C; %RICH
NUM_GROUP_C = NUM_AGENTS - NUM_GROUP_A - NUM_GROUP_B;

%%%%% Parameters for the learning %%%%%
global ALPHA;
ALPHA = 0.1; 
global GAMMA;
GAMMA = 0.75; 
global EPSILON;
EPSILON = 0.05; 

%%%%% Moving agents between groups %%%%%
global GROUP_CHANGE; %binary parameter
GROUP_CHANGE = 0; %when changing that, comment\uncomment in Qlearning.m
global ROUND_CHANGE;
ROUND_CHANGE = 600; 
global NUM_MOVING;
NUM_MOVING = 350;
global GROUP_FROM;
GROUP_FROM = 1;
global GROUP_TO;
GROUP_TO = 2;
global FLAGS;
FLAGS = zeros(1,NUM_AGENTS);

%%%%% Fixed Budget %%%%%
global BUDGET_UPDATE;
BUDGET_UPDATE = 0; %0 - budget is un-limited, 1 - budget is fixed
global BUDGET_GROUP;
BUDGET_GROUP = 3; %1 - Rewarding Normal group, 2 - Rewarding Green group, 3 - Rewarding Rich group
global BUDGET_WALK;
BUDGET_WALK = 100000;

%%%%% Fixed Agnets (i.e, always choose the same action) %%%%%
global USE_FIXED_AGENTS;
USE_FIXED_AGENTS = 1;
global GROUP_FIXED_AGENTS;
GROUP_FIXED_AGENTS = 3; %1 - Normal; 2 - Green; 3 - Rich
global ACTION_FIXED_AGENTS;
ACTION_FIXED_AGENTS = 2; %1 - car; 2 - bus; 3 - walk
global NUM_FIXED_AGENTS;
NUM_FIXED_AGENTS = 30;
global ORIGINAL_NUM_FIXED_AGENTS;
ORIGINAL_NUM_FIXED_AGENTS = NUM_FIXED_AGENTS;

%sensitivities per action (1-car, 2-bus, 3-walk)
global sens_groupA;
sens_groupA = [1.3,1,1]; %normal %%sens_groupA = [1,1,1];
global sens_groupB;
sens_groupB = [1,1.35,1.4]; %green
global sens_groupC;
sens_groupC = [1.4,0.7,0.8]; %rich

%costs per action (1-car, 2-bus, 3-walk)
global costs_groupA;
costs_groupA = [0,0,0]; %normal
global costs_groupB;
costs_groupB = [0.1,0.11,0]; %green %costs_groupB = [0,0.2,0];
global costs_groupC;
costs_groupC = [-0.2,0,0]; %rich %%costs_groupC = [0,0,0]; %rich

updateFlags(0,0,0);

%%Assumptions about how the population might look like
PD_car = makedist('Normal','mu',0,'sigma',0.4); 
PD_bus = makedist('Normal','mu',0.4,'sigma',0.35);
PD_walk = makedist('Uniform');

[Ravg,RavgNormal,RavgGreen, RavgRich, Aavg,AavgNormal,AavgGreen,AavgRich] = loop(PD_car, PD_bus, PD_walk);
for k = 1:NUM_AGENTS
    plot(Ravg(k,:))
    hold on
end
xlabel('Number of Rounds') % x-axis label
ylabel('Average Reward') % y-axis label
set(gcf, 'Position',  [200, 200, 400, 280]);

figure();
for ac = 1:NUM_ACTIONS
    p = plot(Aavg(ac,:));
    hold on
end
title('All Population');
legend({'car','bus','walk'},'Location','southwest')
xlabel('Number of Rounds') % x-axis label
ylabel('Average Number of Agents') % y-axis label
set(gcf, 'Position',  [200, 200, 360, 260]);

figure();
for ac = 1:NUM_ACTIONS
    p = plot(AavgNormal(ac,:));
    hold on
end
title('Group #1'); %Normal
legend({'car','bus','walk'},'Location','southwest')
xlabel('Number of Rounds') % x-axis label
ylabel('Average Number of Agents') % y-axis label
set(gcf, 'Position',  [200, 200, 360, 260]);

figure();
for ac = 1:NUM_ACTIONS
    p = plot(AavgGreen(ac,:));
    hold on
end
title('Group #2'); %Green
legend({'car','bus','walk'},'Location','southwest')
xlabel('Number of Rounds') % x-axis label
ylabel('Average Number of Agents') % y-axis label
set(gcf, 'Position',  [200, 200, 360, 260]);

figure();
for ac = 1:NUM_ACTIONS
    p = plot(AavgRich(ac,:));
    hold on
end
title('Group #3'); %Rich
legend({'car','bus','walk'},'Location','southwest')
xlabel('Number of Rounds') % x-axis label
ylabel('Average Number of Agents') % y-axis label
set(gcf, 'Position',  [200, 200, 360, 260]);