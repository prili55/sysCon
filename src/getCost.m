%group 1-normal, group 2-green, group 3-rich 
function cost = getCost(agent, action)
global FLAGS;

costs_groupA = [0,0,0]; %normal
costs_groupB = [0,1.1,0]; %green
costs_groupC = [0,0,0]; %rich

group = FLAGS(agent);
switch group
    case 1
        cost = costs_groupA(action);
    case 2
        cost = costs_groupB(action);
    case 3
        cost = costs_groupC(action);
end
end