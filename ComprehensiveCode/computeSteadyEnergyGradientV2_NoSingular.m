function gEnergy = ...
    computeSteadyEnergyGradientV2_NoSingular(AdynamicsModel,AdynamicsEnergy, ...
    pInputNow,numLearningDimensions,numStateDimensions,includeInternalModelOrNot)
% updates the gradient of the steady state energy with respect to the
% learnable control parameters by extrapolating the 

% because we removed one state to avoid singular matrices
numStateDimensions = numStateDimensions-1;

Inow = eye(numStateDimensions);

% state dynamics: equation: x_i+1 = A x_i + B p_i + C
A = AdynamicsModel(1:numStateDimensions,1:numStateDimensions);
B = AdynamicsModel(1:numStateDimensions,numStateDimensions+1:numStateDimensions+numLearningDimensions);
% C = AdynamicsModel(1:numStateDimensions,end);

% energy dynamics: equation: E_i = G x_i + H p_i + K
G = AdynamicsEnergy(1,1:numStateDimensions);
H = AdynamicsEnergy(1,numStateDimensions+1:numStateDimensions+numLearningDimensions);
% K = AdynamicsEnergy(1,end);
% 
% stateSteady = inv(I-A)*(B*pInputNow+C);
% ESteady = (G*inv(I-A)*B+H)*pInputNow + G*inv(I-A)*C + K;
% gEnergy = (G*inv(I-A)*B+H)';

gEnergy = (G*((Inow-A)\B)*includeInternalModelOrNot+H)';

end