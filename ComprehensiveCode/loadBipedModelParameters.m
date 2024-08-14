function paramFixed = loadBipedModelParameters(paramFixed)
% parameters related to the biped dynamics, like biped segment masses and
% lengths, gravity, and performance cost parameters (energy or symmetry)

%% treadmill acceleration include
paramFixed.includeAccelerationTorque = 1; 
% makes sure to simulate the dynamics of treadmill acceleration

%% Body parameters, FIXED
paramFixed.mbody = 1; paramFixed.leglength = 1; paramFixed.gravg = 1;

% efficiency of positive and negative work
paramFixed.efficiency_neg = 1.2; paramFixed.efficiency_pos = 0.25;
paramFixed.bPos = 1/paramFixed.efficiency_pos; 
paramFixed.bNeg = 1/paramFixed.efficiency_neg;

%% swing leg energy cost parameters
paramFixed.mFoot = 0.05;
paramFixed.swingCost.Coeff = 0.9; % for best 
paramFixed.swingCost.alpha = 1.0;

%% energy vs periodicity variance reduction
paramFixed.lambdaEnergyVsPeriodicity = 1; % 1 = energy, 0 = periodicity

%% energy vs symmetry
% paramFixed.lambdaEnergyVsSymmetry = 1; % 1 = energy, 0 = symmetry
paramFixed.lambdaEnergyVsSymmetry = 0.75; % 1 = energy, 0 = symmetry 
% paramFixed.lambdaEnergyVsSymmetry = 0.5; % 1 = energy, 0 = symmetry 
% paramFixed.lambdaEnergyVsSymmetry = 0; % 1 = energy, 0 = symmetry
% paramFixed.lambdaEnergyVsSymmetry = 0.25; % 1 = energy, 0 = symmetry
paramFixed.symmetryMultiplier = 10; % just multiplies the symmetry objective, 
% so that its gradients are comparable to the energy cost gradients

end % checked and essential