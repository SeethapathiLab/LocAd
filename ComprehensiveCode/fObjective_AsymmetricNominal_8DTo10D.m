function [f_objective,stateVar0,tEnd,f_energy,f_constraint,tStore,stateStore,EmetTotalStore, EmetPerTimeStore, tStepStore] = ...
    fObjective_AsymmetricNominal_8DTo10D(pInputControllerNominal,stateVar0_Model, ...
    paramController,paramFixed,tStart)

temp = zeros(10,1);
temp(1:3) = pInputControllerNominal(1:3);
temp(6:10) = pInputControllerNominal(4:8);
pInputControllerNominal = temp;

[f_objective,stateVar0,tEnd,f_energy,f_constraint,tStore,stateStore,EmetTotalStore,EmetPerTimeStore,tStepStore] = ...
    fObjective_AsymmetricNominal(pInputControllerNominal,stateVar0_Model, ...
    paramController,paramFixed,tStart);

end % checked and essential