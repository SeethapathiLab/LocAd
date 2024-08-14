function [pInputControllerStore_OnesTried,tStore,stateStore, ...
    EmetTotalStore,EmetPerTimeStore,tStepStore, ...
    EdotStore_IterationAverage, ...
    tTotalIterationStore] = simulateLearningStepByStep(paramFixed, ...
    pInputControllerAsymmetricNominal,stateVar0_Model,contextNow, ...
    paramControllerGains)

disp(['Simulating Learning While Walking ... (' num2str(paramFixed.numIterations) ' strides)']);

%%
tStore = [];
stateStore = [];
EmetTotalStore = [];
EmetPerTimeStore = [];
tStepStore = [];
% EworkPushoffStore = [];
% EworkHeelstrikeStore = [];

%% key paramaters
noiseSTD = paramFixed.Learner.noiseSTDExploratory;
numIterations = paramFixed.numIterations;
includeInternalModelOrNot = paramFixed.Learner.includeInternalModel;

%%
pInputControllerAsymmetricNominal = pInputControllerAsymmetricNominal([1:3 6:10]);
% because the last two variablees of the odd step are zero without loss of
% generality (origin setting)
numLearningDimensions = length(pInputControllerAsymmetricNominal);
numStateDimensions = length(stateVar0_Model);

%% learning rates
alphaEnergyLearningRate = paramFixed.Learner.LearningRate;

%% do the gradient descent

% learning parameter input
pInputNow = pInputControllerAsymmetricNominal;

% state initial condition
% stateVar0_Model = stateVar0_Model;

% initial time
tStart = 0; % re-setting this doesn't matter here

%% initial internal model
AdynamicsModelNow = ...
    zeros(numStateDimensions-1,numLearningDimensions+numStateDimensions); % no +1 for the constant term and -1 to avoid singularity?
AdynamicsEnergyNow = ...
    zeros(1,numLearningDimensions+numStateDimensions); % just on output

%% initializing gradient
gEnergyGradientNow = zeros(size(pInputControllerAsymmetricNominal)); % initial zero

%% initializing various empty arrays
pInputControllerStore_OnesTried = [];
stateVarNowStore = [];
stateVarNextStore = [];
EdotStore = [];
pInputControllerStore_OnesConsideredGood = [];
gradientEnergyEstimateStore = cell(1,1);
AdynamicsModelStore = cell(1,1);
AdynamicsEnergyStore = cell(1,1);

errorOldDynamicsModelStore = [];
errorNewDynamicsModelStore = [];
errorOldEnergyModelStore = [];
errorNewEnergyModelStore = [];
learningOnOrNotStore = [];
memoryToGradientDirectionCosineStore = [];

gGradientForMemoryUpdateStore = cell(1,1);
errorFromMemoryStore = [];
pInputMemoryNowStore = [];

%% copying some variables
numStridesToUse = paramFixed.Learner.numStepsToUseForEstimator; 
stateVar0_ModelNow = stateVar0_Model;
pInputNow_ConsideredGood = pInputNow;

%% looping over all strides
for iStride = 1:numIterations % 1 stride = 1 iteration
    
    if mod(iStride,50)==0
        disp(['iStride = ' num2str(iStride)]); % display stride 
    end
    
    %% exploratory noise
    delta_pInputNow1_Noise = noiseSTD*randn(numLearningDimensions,1);
    
%     for iDim = 1:numLearningDimensions % making sure that the noise is not too small or too large
%         a = 0.2*noiseSTD; b = 2*noiseSTD;
%         if abs(delta_pInputNow1_Noise(iDim))>a||abs(delta_pInputNow1_Noise(iDim))<b
%             delta_pInputNow1_Noise(iDim) = sign(delta_pInputNow1_Noise(iDim))*(a+(b-a)*rand); % some uniform between a and b
%         end
%     end
    
    %% compute the gradient step
    delta_pInputNow2_Gradient = alphaEnergyLearningRate*(-gEnergyGradientNow);

    %% restriction gradient step size if using trust region
    if paramFixed.Learner.shouldWeUseTrustRegion 
        if norm(delta_pInputNow2_Gradient)>paramFixed.Learner.trustRegionSize*sqrt(numLearningDimensions)
            delta_pInputNow2_Gradient = delta_pInputNow2_Gradient/norm(delta_pInputNow2_Gradient);
            delta_pInputNow2_Gradient = delta_pInputNow2_Gradient*paramFixed.Learner.trustRegionSize*sqrt(numLearningDimensions);
        end
    end

    %% use the linear memory model to get a memory to move toward
    % could be nonlinear, with a piecewise relu kind of network
    pInputMemoryNow = paramFixed.storedmemory.nominalControl + ...
        paramFixed.storedmemory.controlSlopeVsContext*(contextNow-paramFixed.storedmemory.nominalContext); 
    pInputMemoryNowStore = [pInputMemoryNowStore pInputMemoryNow];
    
    %% take a step toward memory
    dirTowardMemory = (pInputMemoryNow-pInputNow_ConsideredGood);
    
    % modified cosine tuning: compute direction cosine between memory and gradient
    temp = ...
        dot(dirTowardMemory,-gEnergyGradientNow)/norm(dirTowardMemory,2)/norm(gEnergyGradientNow,2);
    memoryToGradientDirectionCosineStore(iStride) = temp; 
    
    powerMovetoMemory = paramFixed.Learner.powerToTheMoveToMemory;
    
    if isnan(temp) % this happens when we have divide by zero for the gradient say
        temp = 1*paramFixed.Learner.LearningRateTowardMemory; % when gradient is bad, use memory <>
    else
        temp = (1+temp)/2; % needs to be 1 when angle is zero and zero when 180 or -180 degrees
        temp = temp^powerMovetoMemory; % square it to penalize opposing the gradient much more
        temp = temp*paramFixed.Learner.LearningRateTowardMemory; % adding a cosine law for the learning rate toward memory
    end

    % compute step toward memory
    delta_pInputNow3_TowardMemory = temp*dirTowardMemory;
    
    % add step toward memory
    pInputNow_ConsideredGood = pInputNow_ConsideredGood + delta_pInputNow3_TowardMemory; % step towards the stored memory
    
    %% add gradient and noise steps
    pInputNow_ConsideredGood = pInputNow_ConsideredGood + delta_pInputNow2_Gradient;
    pInputNow_ToTry = pInputNow_ConsideredGood + delta_pInputNow1_Noise;
    
    %% simulate walking
    [EdotNow,stateVar0_ModelNext,tEnd, ...
        f_energy,f_constraint,tStore_Now,stateStore_Now,EmetTotalStore_Now,EmetPerTimeStore_Now,tStepStore_Now] = ...
        fObjective_AsymmetricNominal_8DTo10D(pInputNow_ToTry,stateVar0_ModelNow, ...
        paramControllerGains,paramFixed,tStart);
    
    %% multiplicative measurement noise in energy estimates / measurements
    EdotNow = EdotNow*(1+randn*paramFixed.noiseEnergySensory_Multiplicative); % multiplicative noise
    EdotNow = EdotNow+paramFixed.noiseEnergySensory_Additive*randn; % additive noise

    %% store all the data so far
    stateVarNowStore =  [stateVarNowStore  stateVar0_ModelNow];
    stateVarNextStore = [stateVarNextStore stateVar0_ModelNext];
    pInputControllerStore_OnesTried = [pInputControllerStore_OnesTried pInputNow_ToTry];
    EdotStore = [EdotStore EdotNow];
    pInputControllerStore_OnesConsideredGood = ...
        [pInputControllerStore_OnesConsideredGood pInputNow_ConsideredGood];
    
    %% update internal model dynamics (linear)
    if iStride>numStridesToUse
        [AdynamicsModelNow,errorOldDynamicsModel,errorNewDynamicsModel] = ... % find the gradient
            computeModelDynamicsModelRLS_NoSingular(AdynamicsModelNow,stateVarNowStore,...
            stateVarNextStore,pInputControllerStore_OnesTried,numStridesToUse);
    end
    
    %% update energy model dynamics
    if iStride>numStridesToUse
        [AdynamicsEnergyNow,errorOldEnergyModel,errorNewEnergyModel] = computeEnergyDynamicsModelRLS_NoSingular(AdynamicsEnergyNow, ...
            stateVarNowStore,EdotStore,pInputControllerStore_OnesTried,numStridesToUse);
    end
    
    %% compute the error in the linear models
    if iStride>numStridesToUse
        % error in the Dynamics model
        errorOldDynamicsModelStore = [errorOldDynamicsModelStore errorOldDynamicsModel];
        errorNewDynamicsModelStore = [errorNewDynamicsModelStore errorNewDynamicsModel];
        
        % error in the Energy model
        errorOldEnergyModelStore = [errorOldEnergyModelStore errorOldEnergyModel];
        errorNewEnergyModelStore = [errorNewEnergyModelStore errorNewEnergyModel];
    end
    
    %% get the gradient of the steady state energy    
    gEnergyGradientNow = computeSteadyEnergyGradientV2_NoSingular(AdynamicsModelNow, ...
        AdynamicsEnergyNow,pInputNow_ToTry, ...
        numLearningDimensions,numStateDimensions,includeInternalModelOrNot);
    
    gradientEnergyEstimateStore{iStride} = gEnergyGradientNow;
    AdynamicsModelStore{iStride} = AdynamicsModelNow;
    AdynamicsEnergyStore{iStride} = AdynamicsEnergyNow;
    
    %% implements prediction error thresholding. 
    if paramFixed.Learner.shouldWeThresholdPredictionError
        if iStride>numStridesToUse
            %         predictionErrorListNow = ...
            %             [errorOldDynamicsModel; errorNewDynamicsModel; ...
            %             errorOldEnergyModel; errorNewEnergyModel]; % error control on both old and new
            predictionErrorListNow = ... % just with the new model
                [errorOldEnergyModel; errorNewEnergyModel];
            if any(abs(predictionErrorListNow)>paramFixed.Learner.predictionErrorThreshold)
                gEnergyGradientNow = 0*gEnergyGradientNow;
                learningOnOrNotStore = [learningOnOrNotStore; 0];
                % if the gradient has high error, do not take the gradient
                % step 
            else
                learningOnOrNotStore = [learningOnOrNotStore; 1];
            end
        end
    end
    
    %% reset for the next step
    tStart = tEnd;
    stateVar0_ModelNow = stateVar0_ModelNext;
    
    %%
    drawnow;
    
    %% update the memory
    % the gradient that moves the memory toward the current experience
    gGradientForMemoryUpdate = ...
        gradientOfErrorFromMemoryCompute(paramFixed.storedmemory.controlSlopeVsContext, ...
        pInputNow_ConsideredGood,paramFixed,contextNow);
    
    % direction from current memory prediction to current controller
    % experienced
    n_memorytocurrentcontroller = -dirTowardMemory; % dirTowardMemory is the direction from current controller to memory prediction
    n_memorytocurrentcontroller = n_memorytocurrentcontroller/norm(n_memorytocurrentcontroller,2);
    
    % current direction that the controller is moving toward
    n_vController = delta_pInputNow2_Gradient + delta_pInputNow3_TowardMemory;
    n_vController = n_vController/norm(n_vController);
    
    % cosine of angle between memory->current and v_currentController
    dot_MemoryToCurrent_vCurrent = dot(n_memorytocurrentcontroller,n_vController); % this is the directionj cosine already
    
    % modified cosine tuning: scaling how memory should move
    temp = dot_MemoryToCurrent_vCurrent;
    powerForMemoryFormation = paramFixed.Learner.powerToTheMemoryFormation;
    if isnan(temp) % this happens when we have divide by zero for the gradient say
        temp = 0;
    else
        temp = (1+temp)/2; % needs to be 1 when angle is zero and zero when 180 or -180 degrees
        temp = temp^powerForMemoryFormation; % square it to penalize opposing the gradient much more
        temp = temp*paramFixed.Learner.LearningRateForMemoryFormationUpdates; % adding a cosine law for the learning rate toward memory
    end
    
    % update the memory
    paramFixed.storedmemory.controlSlopeVsContext = ...
        paramFixed.storedmemory.controlSlopeVsContext + ...
        temp*(-gGradientForMemoryUpdate);
    
    gGradientForMemoryUpdateStore{iStride} = gGradientForMemoryUpdate;
    errorFromMemoryStore = [errorFromMemoryStore errorFromMemoryCompute(paramFixed.storedmemory.controlSlopeVsContext,pInputNow_ConsideredGood,paramFixed,contextNow)];
    
    % update the memory context 
    [vA,vB] = getTreadmillSpeed(tStart,paramFixed.imposedFootSpeeds);
    contextNow = [vA; vB];
    
    %% add some noise in the context
    contextNow = contextNow.*(1+paramFixed.noiseEnergySensory_Multiplicative*randn(size(contextNow)));

     %% assemble all the Store variables
    if iStride ==1
        tStore = [tStore; tStore_Now];
        stateStore = [stateStore; stateStore_Now];
        EmetTotalStore = [EmetTotalStore; EmetTotalStore_Now];
        EmetPerTimeStore = [EmetPerTimeStore; EmetPerTimeStore_Now];
        tStepStore = [tStepStore; tStepStore_Now]; % this is step time midstance to midstance, not useful
        
%         EworkPushoffStore = [EworkPushoffStore; EworkPushoffStore_Now];
%         EworkHeelstrikeStore = [EworkHeelstrikeStore; EworkHeelstrikeStore_Now];

    else
        
        % to merge the half steps at the end and the beginning to compile
        % things for steps defined as heel strike to heel strike
        tStore{end} = [tStore{end}; tStore_Now{1}];
        stateStore{end} = [stateStore{end}; stateStore_Now{1}];
        % the other steps
        tStore = [tStore; tStore_Now(2:end)];
        stateStore = [stateStore; stateStore_Now(2:end)];
        
        % the rest are just arrays from midstance to midstance
        EmetTotalStore = [EmetTotalStore; EmetTotalStore_Now];
        EmetPerTimeStore = [EmetPerTimeStore; EmetPerTimeStore_Now];
        tStepStore = [tStepStore; tStepStore_Now];
        
%         EworkPushoffStore = [EworkPushoffStore; EworkPushoffStore_Now];
%         EworkHeelstrikeStore = [EworkHeelstrikeStore; EworkHeelstrikeStore_Now];
        
    end

    %% time and energy/objective averages
    EdotStore_IterationAverage(iStride) = sum(EmetTotalStore_Now)/sum(tStepStore_Now);
    tTotalIterationStore(iStride) = sum(tStepStore_Now);

end


end % essential and checked.
% unnecessary plots removed