function [ value, isterminal, direction ] = DetectMidstance(t,stateVar,paramFixed,paramController)
%This function detects when midstance occcurs for the model and stops the
%integration at that moment

% m1 = paramFixed.mbody; 
% L1 = paramFixed.leglength; 
% g = paramFixed.gravg;

% unwrapping the state variables
angleTheta = stateVar(1); 
% dangleTheta = stateVar(2);
% yFoot = stateVar(3);
% INTy = stateVar(4); % integral of body position

yNow = (paramFixed.leglength*sin(angleTheta+paramFixed.angleSlope));

value = yNow; % same as theta+paramFixed.angleSlope becoming zero
isterminal = 1;
direction = +1;

end % checked and essential