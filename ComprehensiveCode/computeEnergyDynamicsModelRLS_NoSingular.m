function [AdynamicsNew,errorOldModel,errorNewModel] = ...
    computeEnergyDynamicsModelRLS_NoSingular(AdynamicsNow, ...
    stateVarNowStore,EdotStore,pInputControllerNowStore,numStepsToUse)
% computes a linear model that predicts energy this stride from input state
% and control parameters

beta = 0.5; % not used and can be set to 

Aold = AdynamicsNow;

muMeasurement = 0; % dummy variable and not used

InputNowStore = [stateVarNowStore; pInputControllerNowStore];
OutputNextStore = EdotStore;

% remove 1st row of zeros to avoid singularity
InputNowStore = InputNowStore(2:end,:);

[AdynamicsNew,errorOldModel,errorNewModel] = ...
    RLSupdate(Aold,beta,InputNowStore,...
    OutputNextStore,muMeasurement,numStepsToUse);

end