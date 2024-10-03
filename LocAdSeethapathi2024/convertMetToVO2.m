function [tSpan,EmetVO2List] = convertMetToVO2(params)
% this program is used to convert the instantaneous stride-wise metabolic
% rate to something that would be measured by indirect calorimetry. uses a
% linear model with a 44 second time constant. see manuscript for citations

%% time constant of the linear system
timeConstant = 44; % seconds e.g., from Selinger et al 2014
g = 9.81; LegLength = 0.95; 
timeScaling = sqrt(LegLength/g);
timeConstant = timeConstant/timeScaling;
params.k = 1/timeConstant;

%% 
% to get the IC, we average over 30 steps at least, so the IC is not noise
EmetS_0 = mean(params.EmetRateList(1:30)); 
tSpan = params.tList; % we could refine this further if necessary. 
options = odeset('reltol',1e-8,'abstol',1e-8);
[tSpan,EmetVO2List] = ode45(@odeMetToVO2MET,tSpan,EmetS_0,options,params);

end

%%
function dEmetVO2dt = odeMetToVO2MET(t,EmetS,params)

EmetNow = interp1(params.tList,params.EmetRateList,t,'linear','extrap');

dEmetVO2dt = params.k*(EmetNow-EmetS);

end % checked and essential