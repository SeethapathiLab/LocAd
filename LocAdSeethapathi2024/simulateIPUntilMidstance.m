function [tlistTillMidstance, statevarlistTillMidstance] = ...
    simulateIPUntilMidstance(statevar0,tspan,paramFixed,paramController)

% simulating inverted pendulum till midstance
options = odeset('Events',@DetectMidstance,'reltol',1e-10,'abstol',1e-10);
[tlistTillMidstance,statevarlistTillMidstance] = ...
    ode45(@singlePendulumODE,tspan,statevar0,options,paramFixed,paramController);

end % checked and essential