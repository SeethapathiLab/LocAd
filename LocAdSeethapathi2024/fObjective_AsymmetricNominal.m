function [f_objective,stateVar0,tEnd,f_energy,f_constraint,tStore,stateStore,EmetTotalStore, EmetPerTimeStore, tStepStore] = ...
    fObjective_AsymmetricNominal(pInputControllerNominal,stateVar0_Model, ...
    paramController,paramFixed,tStart)

%% unwrap the controller 
paramController.Odd.theta_end_nominal = ...
    pInputControllerNominal(1);
paramController.Odd.ydot_atMidstance_nominal_beltframe = ...
    pInputControllerNominal(2);
paramController.Odd.PushoffImpulseMagnitude_nominal = ...
    pInputControllerNominal(3);
paramController.Odd.y_atMidstance_nominal_slopeframe = ...
    pInputControllerNominal(4); % needs to be fixed to zero
paramController.Odd.SUMy_atMidstance_nominal_slopeframe = ...
    pInputControllerNominal(5); % needs to be fixed to zero

paramController.Even.theta_end_nominal = ...
    pInputControllerNominal(6);
paramController.Even.ydot_atMidstance_nominal_beltframe = ...
    pInputControllerNominal(7);
paramController.Even.PushoffImpulseMagnitude_nominal = ...
    pInputControllerNominal(8);
paramController.Even.y_atMidstance_nominal_slopeframe = ...
    pInputControllerNominal(9);
paramController.Even.SUMy_atMidstance_nominal_slopeframe = ...
    pInputControllerNominal(10);

%% simulate 4 steps, so that we have some reasonable average to go off of,
% just to be safe
paramFixed.numSteps = paramFixed.Learner.numStepsPerIteration; 
[stateVar0,tStore,stateStore,EmetTotalStore, EmetPerTimeStore, ...
    tStepStore] = ...
    simulateManySteps_AsymmetricControl(stateVar0_Model,paramController,paramFixed,tStart);

f_energy = sum(EmetTotalStore)/sum(tStepStore);
tEnd = tStore{end}(end);

f_constraint = (norm(stateVar0_Model(2:3)-stateVar0(2:3)))^2; % just thetaDot and yFoot is targeted to be zeroed

% trading off energy and periodicity: seems not essential
lambdaEnergyVsPeriodicity = paramFixed.lambdaEnergyVsPeriodicity;
f_objective = lambdaEnergyVsPeriodicity*f_energy+(1-lambdaEnergyVsPeriodicity)*f_constraint;

angleThetaEnd_1 = stateStore{1}(end,1); angleThetaEnd_2 = stateStore{2}(end,1);
f_symmetry = (angleThetaEnd_1-angleThetaEnd_2)^2;

% trading off energy and symmetry
f_objective = paramFixed.lambdaEnergyVsSymmetry*f_objective + ...
    (1-paramFixed.lambdaEnergyVsSymmetry)*f_symmetry*paramFixed.symmetryMultiplier;

end  % checked and essential