function dStateVar = singlePendulumODE(t,stateVar,paramFixed,paramController)
% SINGLEPENDULUMODEFILE This is the ODE file for a single pendulum with
% massless links, and point-masses at the end of each link (see text book 
% for the equations)

% fixed parameters
% m1 = paramFixed.mbody; 
% L1 = paramFixed.leglength; 
% % could be changed so that the left and right legs are of different
% lengths 
% g = paramFixed.gravg;

% unwrapping the state variables
angleTheta = stateVar(1); % angle wrt ground
dangleTheta = stateVar(2);
% yFoot = stateVar(3);
% INTy = stateVar(4); % integral of body position

%% inertial force for acceleration 

% interpolate to get the right acceleration
paramController.PushoffAccelerationNow = interp1(paramController.tList_BeltSpeed, ...
    paramController.PushoffAccelerationNowList,t,'previous','extrap'); % 'previous' because we want constant acceleration during each piecewise linear domain

% forward 'inertial force' due to backward belt acceleration
forceDueToAcceleration = -paramController.PushoffAccelerationNow*paramFixed.mbody;
torqueDueToAcceleration = ...
    forceDueToAcceleration*cos(angleTheta)/(paramFixed.mbody*paramFixed.leglength);

if ~paramFixed.includeAccelerationTorque
    torqueDueToAcceleration = 0;
end

% exo torque
if strcmp(paramFixed.speedProtocol,'exo tied single speed state dependent')
    if t>paramFixed.exo.startTime
        assistanceTorque = +propulsivePhaseBasedTorque(angleTheta,paramFixed);
    else
        assistanceTorque = 0;
    end
else
    assistanceTorque = 0;
end

% angular acceleration of the stance leg
ddAngleTheta = ...
    paramFixed.gravg/paramFixed.leglength*sin(angleTheta) + ...
    torqueDueToAcceleration + assistanceTorque;

% interpolate to get the right speed
paramController.PushoffFootSpeedNow = interp1(paramController.tList_BeltSpeed, ...
    paramController.PushoffFootSpeedNowList,t,'linear','extrap');

% integrating yFoot position so that it is easily accessible
dyFoot = paramController.PushoffFootSpeedNow; % treadmill speed

dStateVar = [dangleTheta; ddAngleTheta; dyFoot];

end % code checked and essential