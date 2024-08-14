function [ value, isterminal, direction ] = DetectEndstance(t,stateVar,paramFixed,paramController)
%This function detects when midstance occcurs for the model and stops the
%integration at that moment

% m1 = paramFixed.mbody; 
% L1 = paramFixed.leglength; 
% g = paramFixed.gravg;


% unwrapping the state variables
angleTheta = stateVar(1); 
% dangleTheta = stateVar(2);
% xFoot = stateVar(3);
% INTx = stateVar(4); % integral of body position

value = angleTheta-paramController.theta_end_thisStep;
isterminal = 1;
direction = +1;

end % checked and essential