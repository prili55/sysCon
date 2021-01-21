%The system determines rewards based on all agents' actions 
%PD_1-car, PD_2-bus, PD_3-walk

function [r] = getReward(agent,action,ActionCount,PD_1, PD_2, PD_3)
global NUM_AGENTS;
global FLAGS;

%sensitivities per action (1-car, 2-bus, 3-walk)
global sens_groupA;
global sens_groupB;
global sens_groupC;

%costs per action (1-car, 2-bus, 3-walk)
global costs_groupA;
global costs_groupB;
global costs_groupC;

group = FLAGS(agent);
%sens = 1;
switch group
    case 1
        sens = sens_groupA(action);
        cost = costs_groupA(action);
    case 2
        sens = sens_groupB(action);
        cost = costs_groupB(action);
    case 3
        sens = sens_groupC(action);
        cost = costs_groupC(action);
end

pd = getPd(action, PD_1, PD_2, PD_3);
countNormalize = ActionCount(action)/NUM_AGENTS;
r = pdf(pd,countNormalize);

%(A) Bus: flat line till the peak
if action == 2 
  xInt = [0:0.0001:1];
  y = pdf(PD_2,xInt); %create probability distribution object
  [maxValy,idx] = max(y);
  maxValx = xInt(idx);
  if countNormalize <= maxValx
      r = maxValy;     
  end
end

% %(B) Bus and Walk have the same maximum utility
% if action == 2 
%   xInt = [0:0.0001:1];
%   y_bus = pdf(PD_2,xInt); 
%   y_walk = pdf(PD_3,xInt);
%   val_walk = y_walk(1); %assuming walk is uniform and fixed
%   Intersections = find(abs(y_walk-y_bus)<=(0.0001));
%   if (length(Intersections) <2)
%       fprintf('BUG !!!!');
%   end
%   maxValx = xInt(Intersections(2));
%   if countNormalize <= maxValx
%       r = val_walk;     
%   end
% end

r = r*sens-cost;
% group = FLAGS(agent);
% if action == 3
%     switch group
%         case 1 %Normal
%             %r = r*2;
%         case 2 %Green
%             %r = r*2;
%         case 3 %Rich
%             %r = r*2;
%     end
% end

end