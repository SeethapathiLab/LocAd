function [stateVar0,tStore,stateStore,EmetTotalStore, ...
    EmetPerTimeStore,tStepStore,EworkPushoffStore,EworkHeelstrikeStore] = ...
    simulateManySteps_AsymmetricControl(stateVar0,paramController,paramFixed,tStart)

% reduced state at mid-stance is 
% angleTheta0, dAngleTheta0, ...
% yFoot (lab frame), INTy (lab frame)

% tStart = 0;

tStore = cell(paramFixed.numSteps+1,1);
stateStore = cell(paramFixed.numSteps+1,1);
EmetTotalStore = zeros(paramFixed.numSteps,1);
EmetPerTimeStore = zeros(paramFixed.numSteps,1);
tStepStore = zeros(paramFixed.numSteps,1);

EworkPushoffStore = zeros(paramFixed.numSteps,1);
EworkHeelstrikeStore = zeros(paramFixed.numSteps,1);

%%
for iStep = 1:paramFixed.numSteps
    
    %% odd or even control
    if mod(iStep,2)==0
        paramController.theta_end_nominal = ...
            paramController.Even.theta_end_nominal;
        paramController.ydot_atMidstance_nominal_beltframe = ...
            paramController.Even.ydot_atMidstance_nominal_beltframe;
        paramController.PushoffImpulseMagnitude_nominal = ...
            paramController.Even.PushoffImpulseMagnitude_nominal;
        paramController.y_atMidstance_nominal_slopeframe = ...
            paramController.Even.y_atMidstance_nominal_slopeframe;
        paramController.SUMy_atMidstance_nominal_slopeframe = ...
            paramController.Even.SUMy_atMidstance_nominal_slopeframe;
    else
        paramController.theta_end_nominal = ...
            paramController.Odd.theta_end_nominal;
        paramController.ydot_atMidstance_nominal_beltframe = ...
            paramController.Odd.ydot_atMidstance_nominal_beltframe;
        paramController.PushoffImpulseMagnitude_nominal = ...
            paramController.Odd.PushoffImpulseMagnitude_nominal;
        paramController.y_atMidstance_nominal_slopeframe = ...
            0; % fixed to zero by fiat
        paramController.SUMy_atMidstance_nominal_slopeframe = ...
            0; % fixed to zero by fiat
    end
    
    %% simulate the first step, belt 1
    [stateVar0, tlistTillEndstance, statevarlistTillEndstance, ...
       tlistTillMidstance, statevarlistMidstance, ...
       Emet_totalNow,Emet_perTime,tTotal,EworkPushoff,EworkHeelstrike] = ...
        simulateOneStep_MidstanceToMidstance_WithEnergy(stateVar0,iStep,tStart, ...
        paramController,paramFixed);

    %% storing everything
    % the following weirdness is because a midstance to midstance
    % simulation straddles two steps
    
    tStore{iStep} = [tStore{iStep}; tlistTillEndstance];
    stateStore{iStep} = [stateStore{iStep}; statevarlistTillEndstance];
    
    if iStep<paramFixed.numSteps
        tStore{iStep+1} = [tStore{iStep+1}; tlistTillMidstance(1:end-1)];
        stateStore{iStep+1} = [stateStore{iStep+1}; statevarlistMidstance(1:end-1,:)];
    else
        tStore{iStep+1} = [tStore{iStep+1}; tlistTillMidstance(1:end)];
        stateStore{iStep+1} = [stateStore{iStep+1}; statevarlistMidstance(1:end,:)];
    end
    
    %% reset time, very important do not comment!
    tStart = tlistTillMidstance(end);
    
    %% metabolic cost estimate
    EmetTotalStore(iStep) = Emet_totalNow;
    EmetPerTimeStore(iStep) = Emet_perTime;
    tStepStore(iStep) = tTotal;
    
    EworkPushoffStore(iStep) = EworkPushoff;
    EworkHeelstrikeStore(iStep) = EworkHeelstrike;

end

end % essential