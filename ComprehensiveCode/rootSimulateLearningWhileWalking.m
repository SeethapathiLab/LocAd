clear; close all; clc; % clearing everything so you start with a clean slate

numRepeats = 1
for iRepeat = 1:numRepeats

% This is the main program in this folder. Run this program, and it calls
% whatever functions are necessary to simulate learning while walking.

% -------------------------------------------------------------------------
% This initial section defines the various model parameters. See Methods
% for how these parameters are obtained or fixed.
% -------------------------------------------------------------------------

% warning('Learning and memory has been turned off right now')

%% initialize empty parameter values
paramFixed = [];

%% initialize the random number generator
rng('shuffle','twister'); % ensures a different sequence of random numbers

%% biped model parameters
paramFixed = loadBipedModelParameters(paramFixed);

%% sensory noise parameters
paramFixed = loadSensoryNoiseParameters(paramFixed);

%% controller parameters
paramControllerGains = loadControllerGainParameters(paramFixed);

%% set the integral controller to zero?
% paramController.pushoff_gain_SUMy =  0;
% paramController.legAngle_gain_SUMy =  0;

%% learner parameters
paramFixed = loadLearnerParameters(paramFixed);

%% define the different adaptation protocols and figures
% comment out all but one here to make the relevant plot

paramFixed.runType = 'figure2aRegularSplitBelt'; % checked and works fine
% paramFixed.runType = 'figure2aRegularSplitBeltPureEnergy'; % checked and works fine
% paramFixed.runType = 'figure2cPagliaraTiedBelt'; % checked and works fine
% paramFixed.runType = 'figure3aTurnOffMemoryAndLearning'; % checked and works fine
% paramFixed.runType = 'figure3bDifferentLearningRates_Default12'; % checked and works fine
% paramFixed.runType = 'figure3bDifferentLearningRates_Lower04'; % checked and works fine
% paramFixed.runType = 'figure3bDifferentLearningRates_MuchLower001'; % checked and works fine
% paramFixed.runType = 'figure3bDifferentLearningRates_Higher24'; % checked and works fine
% paramFixed.runType = 'figure3cDifferentLearningRatesTowardMemory_Zero';  % checked and works fine
% paramFixed.runType = 'figure3cDifferentLearningRatesTowardMemory_Default01';  % checked and works fine
% paramFixed.runType = 'figure3cDifferentLearningRatesTowardMemory_Lower002';  % checked and works fine
% paramFixed.runType = 'figure3cDifferentLearningRatesTowardMemory_Higher1';  % checked and works fine
% paramFixed.runType = 'figure3cDifferentLearningRatesTowardMemory_Higher05';  % checked and works fine
% paramFixed.runType = 'figure3dDifferentSensoryNoiseLevelsDefault0p0001'; % checked and works fine
% paramFixed.runType = 'figure3dDifferentSensoryNoiseLevelsHigher0p001'; % checked and works fine
% paramFixed.runType = 'figure3dDifferentSensoryNoiseLevelsHigher0p01'; % checked and works fine
% paramFixed.runType = 'figure3dDifferentSensoryNoiseLevelsHigher0p05'; % checked and works fine
% paramFixed.runType = 'figure3dDifferentSensoryNoiseLevelsHigher0p1'; % checked and works fine
% paramFixed.runType = 'figure3dDifferentSensoryNoiseLevelsHigher0p2'; % checked and works fine
% paramFixed.runType = 'figure4BasicSavingsProtocolTATANoMemoryV3'; % checked and works fine
% paramFixed.runType = 'figure4BasicSavingsProtocolTATADefaultMemoryV3'; % checked and works fine
% paramFixed.runType = 'figure5SeriesOfFeedbackGainsAndFalling'; % works for degrading learning but need to add falling snapshot
% paramFixed.runType = 'figure6aInterferenceMaloneBastianTATBTA'; % checked and works fine
% paramFixed.runType = 'figure6aInterferenceMaloneBastianTATATA'; % checked and works fine
% paramFixed.runType = 'figure6bInterferenceNewExperimentsTA'; % checked
% and works fine % may need to add additional variability
% paramFixed.runType = 'figure6bInterferenceNewExperimentsTBA'; % checked and works fine  % may need to add additional variability
% paramFixed.runType = 'figure7aAbruptNoNoise'; % checked and works fine
% paramFixed.runType = 'figure7aAbruptNoisy';  % checked and works fine
% paramFixed.runType = 'figure7bGradualNoNoise'; % checked and works fine % maybe make the max velocity higher
% paramFixed.runType = 'figure7bGradualNoisy'; % checked and works fine % maybe make the max velocity higher
% paramFixed.runType = 'figure7bGradualAbrupt'; % checked and works fine
% paramFixed.runType = 'suppfigure5RoemmichAbrupt'; % checked and works fine
% paramFixed.runType = 'suppfigure5RoemmichGradual'; % checked and works fine
% paramFixed.runType = 'suppfigure5RoemmichGradualWashout'; % checked and works fine
% paramFixed.runType = 'suppfigure5RoemmichExtendedGradual'; % checked and works fine
% paramFixed.runType = 'suppfigure5RoemmichShortAbrupt'; % checked and works fine
% paramFixed.runType = 'suppfigure4ExoStateDependent_positive'; % checked and works fine
% paramFixed.runType = 'suppfigure4ExoStateDependent_negative'; % checked and works fine
% paramFixed.runType = 'Leech2018PerturbationSizeSmall'; % checked and works fine
% paramFixed.runType = 'Leech2018PerturbationSizeLarge'; % checked and works fine
% paramFixed.runType = 'GeneralizationAWB'; % checked and works fine
% paramFixed.runType = 'GeneralizationB'; % checked and works fine
% paramFixed.runType = 'GeneralizationBWB'; % checked and works fine
% paramFixed.runType = 'figure2aAndfig8PureSymmetry'; % checked and works fine

%% parameter values for each runType
switch paramFixed.runType
    case 'figure2aRegularSplitBelt'
        paramFixed.speedProtocol = 'classic split belt';
    case 'figure2aRegularSplitBeltPureEnergy'
        paramFixed.speedProtocol = 'classic split belt';
        paramFixed.lambdaEnergyVsSymmetry = 1; % 1 = energy, 0 = symmetry
    case 'figure2cPagliaraTiedBelt'
        paramFixed.speedProtocol = 'tied four speed changes pagliara';
    case 'figure3aTurnOffMemoryAndLearning'
        paramFixed.speedProtocol = 'classic split belt';
        paramFixed.Learner.LearningRateTowardMemory = 0;
        paramFixed.Learner.LearningRate = 0;
    case 'figure3bDifferentLearningRates_Default12'
        paramFixed.speedProtocol = 'classic split belt';
        %         paramFixed.Learner.LearningRate = 0;
        %         paramFixed.Learner.LearningRate = 0.00001; % much much slower.USE
        %         paramFixed.Learner.LearningRate = 0.00002; % much slower
        %         paramFixed.Learner.LearningRate = 0.00004; % slower. USE
        %         paramFixed.Learner.LearningRate = 0.00006; % slower
        paramFixed.Learner.LearningRate = 0.00012; % default. USE
        %         paramFixed.Learner.LearningRate = 0.00024; % faster. USE?
        %         paramFixed.Learner.LearningRate = 0.00048; % much faster. probably too fast
    case 'figure3bDifferentLearningRates_Lower04'
        paramFixed.speedProtocol = 'classic split belt';
        paramFixed.Learner.LearningRate = 0.00004; % slower. USE
    case 'figure3bDifferentLearningRates_MuchLower001'
        paramFixed.speedProtocol = 'classic split belt';
        paramFixed.Learner.LearningRate = 0.00001; % much much slower.USE
    case 'figure3bDifferentLearningRates_Higher24'
        paramFixed.speedProtocol = 'classic split belt';
        paramFixed.Learner.LearningRate = 0.00024; % faster. USE?
    case 'figure3cDifferentLearningRatesTowardMemory_Zero'
        paramFixed.speedProtocol = 'classic split belt';
        paramFixed.Learner.LearningRateTowardMemory = 0; % no memory.USE.
        %         paramFixed.Learner.LearningRateTowardMemory = 0.002; % even slower. Fine to USE
        %         paramFixed.Learner.LearningRateTowardMemory = 0.005; % slower. Fine to USE
        %         paramFixed.Learner.LearningRateTowardMemory = 0.01; % default.USE
        %         paramFixed.Learner.LearningRateTowardMemory = 0.02; % faster
    case 'figure3cDifferentLearningRatesTowardMemory_Default01'
        paramFixed.speedProtocol = 'classic split belt';
        paramFixed.Learner.LearningRateTowardMemory = 0.01; % default.USE
    case 'figure3cDifferentLearningRatesTowardMemory_Lower002'
        paramFixed.speedProtocol = 'classic split belt';
        paramFixed.Learner.LearningRateTowardMemory = 0.002; % default.USE
    case 'figure3cDifferentLearningRatesTowardMemory_Higher1'
        paramFixed.speedProtocol = 'classic split belt';
        paramFixed.Learner.LearningRateTowardMemory = 0.1; % default.USE
    case 'figure3cDifferentLearningRatesTowardMemory_Higher05'
        paramFixed.speedProtocol = 'classic split belt';
        paramFixed.Learner.LearningRateTowardMemory = 0.05; % default.USE
    case 'figure3dDifferentSensoryNoiseLevelsDefault0p0001'
        paramFixed.speedProtocol = 'classic split belt';

        % multiplicative noise
        paramFixed.noiseEnergySensory_Multiplicative = 0.0001; % default. USE. But too small
%         paramFixed.noiseEnergySensory_Multiplicative = 0.1; % even higher and choppy
        %          paramFixed.noiseEnergySensory_Multiplicative = 0.25; % even higher and choppy and can result in sometimes degrading learning
        %          paramFixed.noiseEnergySensory = 0.5; % even higher and choppy

        % additive noise
        paramFixed.noiseEnergySensory_Additive = 0.000; % default
%         paramFixed.noiseEnergySensory_Additive = 0.1;
        %         paramFixed.noiseEnergySensory_Additive = 0.2; % pretty choppy learning
    case 'figure3dDifferentSensoryNoiseLevelsHigher0p001'
        paramFixed.speedProtocol = 'classic split belt';
        paramFixed.noiseEnergySensory_Multiplicative = 0.001; % even higher and choppy
        paramFixed.noiseEnergySensory_Additive = 0.001;
    case 'figure3dDifferentSensoryNoiseLevelsHigher0p1'
        paramFixed.speedProtocol = 'classic split belt';
        paramFixed.noiseEnergySensory_Multiplicative = 0.1; % even higher and choppy
        paramFixed.noiseEnergySensory_Additive = 0.1;
   case 'figure3dDifferentSensoryNoiseLevelsHigher0p2'
        paramFixed.speedProtocol = 'classic split belt';
        paramFixed.noiseEnergySensory_Multiplicative = 0.2; % even higher and choppy
        paramFixed.noiseEnergySensory_Additive = 0.2;
    case 'figure3dDifferentSensoryNoiseLevelsHigher0p01'
        paramFixed.speedProtocol = 'classic split belt';
        paramFixed.noiseEnergySensory_Multiplicative = 0.01; % even higher and choppy
        paramFixed.noiseEnergySensory_Additive = 0.01;
    case 'figure3dDifferentSensoryNoiseLevelsHigher0p05'
        paramFixed.speedProtocol = 'classic split belt';
        paramFixed.noiseEnergySensory_Multiplicative = 0.05; % even higher and choppy
        paramFixed.noiseEnergySensory_Additive = 0.05;
    case 'figure4BasicSavingsProtocolTATANoMemoryV3'
        paramFixed.speedProtocol = 'split savings TATA';
        paramFixed.Learner.LearningRateTowardMemory = 0; % USE
        %         paramFixed.Learner.LearningRateTowardMemory = 0.01; % default.USE
    case 'figure4BasicSavingsProtocolTATADefaultMemoryV3'
        paramFixed.runType = [paramFixed.runType 'Trial' num2str(floor(rand*100))]; % adds a random trial number, so we have many trials
        paramFixed.speedProtocol = 'split savings TATA';
%         paramFixed.Learner.LearningRateTowardMemory = 0; % USE
                paramFixed.Learner.LearningRateTowardMemory = 0.01; % default.USE
    case 'figure5SeriesOfFeedbackGainsAndFalling'
        paramFixed.speedProtocol = 'classic split belt';
        %         paramFixed.gainScaling = 1; % default
        %         paramFixed.gainScaling = 0.5; % default
        %         paramFixed.gainScaling = 0.25;
        %         paramFixed.gainScaling = 0.10;
        paramFixed.gainScaling = 0.075;
        %         paramFixed.gainScaling = 0.05;
        %         paramFixed.gainScaling = 0.0;

        % this needs noise
        paramFixed.velocitySensoryNoise = 0.0025;
        paramFixed.noiseEnergySensory_Additive = 0.0025;

        temp = fieldnames(paramControllerGains);
        for iField = 1:length(temp)
            %             iField
            if ~isempty(strfind(temp{iField},'gain'))
                temp2 = getfield(paramControllerGains,temp{iField});
                paramControllerGains = setfield(paramControllerGains,temp{iField},temp2*paramFixed.gainScaling);
                %                 pause
            end
        end
        %         pause
    case 'figure6aInterferenceMaloneBastianTATBTA'
        paramFixed.speedProtocol = 'split interference MaloneBastian TATBTA';
        paramFixed.Learner.LearningRate = paramFixed.Learner.LearningRate*(1+0.25*randn); % learning rate variability to simulate human-level rate variability
        paramFixed.runType = [paramFixed.runType 'Trial' num2str(floor(rand*100))]; % adds a random trial number, so we have many trials
    case 'figure6aInterferenceMaloneBastianTATATA'
        paramFixed.speedProtocol = 'split interference MaloneBastian TATATA';
        paramFixed.Learner.LearningRate = paramFixed.Learner.LearningRate*(1+0.25*randn); % learning rate variability to simulate human-level rate variability
        paramFixed.runType = [paramFixed.runType 'Trial' num2str(floor(rand*100))]; % adds a random trial number, so we have many trials
    case 'figure6bInterferenceNewExperimentsTA'
        paramFixed.Learner.LearningRate = paramFixed.Learner.LearningRate*(1+0.25*randn); % learning rate variability to simulate human-level rate variability
        paramFixed.speedProtocol = 'split interference new expt TA';
        paramFixed.runType = [paramFixed.runType 'Trial' num2str(floor(rand*100))]; % adds a random trial number, so we have many trials
        paramFixed.transitionTime = 20; % longer because TBA needs it to be longer
    case 'figure6bInterferenceNewExperimentsTBA'
        paramFixed.transitionTime = 20; % make longer as the biped may fall otherwise
        paramFixed.Learner.LearningRate = paramFixed.Learner.LearningRate*(1+0.25*randn); % learning rate variability to simulate human-level rate variability
        paramFixed.speedProtocol = 'split interference new expt TBA';
        paramFixed.runType = [paramFixed.runType 'Trial' num2str(floor(rand*100))]; % adds a random trial number, so we have many trials
    case 'figure7aAbruptNoNoise'
        paramFixed.speedProtocol = 'splitabruptNoNoise';
        paramFixed.runType = [paramFixed.runType 'Trial' num2str(floor(rand*100))]; % adds a random trial number, so we have many trials
    case 'figure7aAbruptNoisy'
        paramFixed.speedProtocol = 'splitabruptNoisy';
        % belt noise
        paramFixed.beltNoise = 0.04; % 0.2 m/s as in experiment. but in the old runs, we had set it to 0.04 m/s ,perhaps 
%         paramFixed.beltNoise = 0.1; % 0.2 m/s as in experiment. but in the old runs, we had set it to 0.04 m/s ,perhaps 
        paramFixed.beltNoise_tDelta = 1.2; % in seconds. this is what we used in experiment
%         paramFixed.beltNoise_tDelta = 3; % in seconds. this is what we used in previous calculations
        paramFixed.beltNoise_aMax = 0.1; % 0.1 m/s roughly
        paramFixed.runType = [paramFixed.runType 'Trial' num2str(floor(rand*100))]; % adds a random trial number, so we have many trials
    case 'figure7bGradualNoNoise'
        paramFixed.speedProtocol = 'splitgradualNoNoiseGelsy';
    case 'figure7bGradualNoisy'
        paramFixed.speedProtocol = 'splitgradualNoisyGelsy';
        paramFixed.beltNoise = 0.17; % 0.03 (m/s)^2 variance as 
        paramFixed.beltNoise_tDelta = 3; % in seconds. this is what we used in previous calculations
        paramFixed.runType = [paramFixed.runType 'Trial' num2str(floor(rand*100))]; % adds a random trial number, so we have many trials
    case 'figure7bGradualAbrupt'
        paramFixed.speedProtocol = 'splitAbruptGelsy';                
        paramFixed.runType = [paramFixed.runType 'Trial' num2str(floor(rand*100))]; % adds a random trial number, so we have many trials
    case 'suppfigure5RoemmichAbrupt'
        paramFixed.speedProtocol = 'split roemmich2015 abrupt';
        paramFixed.runType = [paramFixed.runType 'Trial' num2str(floor(rand*100))]; % adds a random trial number, so we have many trials
        paramFixed.transitionTime = 3;
    case 'suppfigure5RoemmichGradual'
        paramFixed.speedProtocol = 'split roemmich2015 gradual';
        paramFixed.runType = [paramFixed.runType 'Trial' num2str(floor(rand*100))]; % adds a random trial number, so we have many trials
        paramFixed.transitionTime = 3;
    case 'suppfigure5RoemmichGradualWashout'
        paramFixed.speedProtocol = 'split roemmich2015 gradual washout';
        paramFixed.runType = [paramFixed.runType 'Trial' num2str(floor(rand*100))]; % adds a random trial number, so we have many trials
        paramFixed.transitionTime = 3;
    case 'suppfigure5RoemmichExtendedGradual'
        paramFixed.speedProtocol = 'split roemmich2015 extended gradual';
        paramFixed.runType = [paramFixed.runType 'Trial' num2str(floor(rand*100))]; % adds a random trial number, so we have many trials
        paramFixed.transitionTime = 3;
    case 'suppfigure5RoemmichShortAbrupt'
        paramFixed.speedProtocol = 'split roemmich2015 short abrupt';
        paramFixed.runType = [paramFixed.runType 'Trial' num2str(floor(rand*100))]; % adds a random trial number, so we have many trials
        paramFixed.transitionTime = 3;
    case 'suppfigure4ExoStateDependent_positive'
        paramFixed.speedProtocol = 'exo tied single speed state dependent';
                paramFixed.exo.assistanceMagnitude = 0.2; % decreases step frequency
%         paramFixed.exo.assistanceMagnitude = -0.2; % increases step frequency
        paramFixed.exo.assistanceHalfSupport = 0.1;
        paramFixed.exo.assistanceStartAngle = 0.1;
        L = 0.95; g = 9.81; timeScaling = sqrt(L/g);
        paramFixed.exo.startTime = 50/timeScaling;
    case 'suppfigure4ExoStateDependent_negative'
        paramFixed.speedProtocol = 'exo tied single speed state dependent';
        %         paramFixed.exo.assistanceMagnitude = 0.2; % decreases step frequency
        paramFixed.exo.assistanceMagnitude = -0.2; % increases step frequency
        paramFixed.exo.assistanceHalfSupport = 0.1;
        paramFixed.exo.assistanceStartAngle = 0.1;
        L = 0.95; g = 9.81; timeScaling = sqrt(L/g);
        paramFixed.exo.startTime = 50/timeScaling;
    case 'Leech2018PerturbationSizeSmall'
        paramFixed.speedProtocol = 'split leech2018 adapt small';
        paramFixed.transitionTime = 3;
    case 'Leech2018PerturbationSizeLarge'
        paramFixed.speedProtocol = 'split leech2018 adapt large';
        paramFixed.transitionTime = 3;
    case 'GeneralizationAWB'
        paramFixed.speedProtocol = 'split savings generalizes to small';
%         paramFixed.transitionTime = 3;
    case 'GeneralizationBWB'
        paramFixed.speedProtocol = 'split savings small to small baseline';
%         paramFixed.transitionTime = 3;
    case 'GeneralizationB'
        paramFixed.speedProtocol = 'split savings small baseline';
%         paramFixed.transitionTime = 3;
    case 'figure2aAndfig8PureSymmetry'
        paramFixed.speedProtocol = 'classic split belt';
        paramFixed.lambdaEnergyVsSymmetry = 0;
%         paramFixed.transitionTime = 3;
end

%% load speed protocol parameters
paramFixed = loadProtocolParameters(paramFixed);

%% initial stored memory, default control
paramFixed = loadStoredMemoryParameters_ControlVsSpeed(paramFixed);

%% how long to simulate parameters
% paramFixed = loadHowLongParameters(paramFixed);
% We get the simulation duration from the protocol, but you can override
% this by uncommenting loadHowLongParameters.m function above and changing
% the values in loadHowLongParameters

%% load current learnable parameters
% look inside the function to what controller parameters are tuned by the learning algorithm
pInputControllerAsymmetricNominal = loadLearnableParametersInitial(paramFixed);

%% load initial state and time
stateVar0_Model = loadInitialBodyState(pInputControllerAsymmetricNominal);
tStart = 0;

% storing initial state for later use
stateVar0_Model_BeforeLearning = stateVar0_Model;

%% performance or objective function calculation. Just a demo, not necessary to do here.
% f = fObjective_AsymmetricNominal(pInputControllerAsymmetricNominal,stateVar0_Model, ...
%     paramControllerGains,paramFixed,tStart); % function computes the
%     objective or performance function for one stride

%% re-set defaults based on actual plot to be made
% paramFixed = resetDefaultsForSpecificProtocol();

%% context for the gait
% TO DO: get this from
[vA,vB] = getTreadmillSpeed(0,paramFixed.imposedFootSpeeds);
contextNow = [vA; vB];
contextLength = length(contextNow);

%% Simulate learning step by step with some outputs
[pInputControllerStore_OnesTried,tStore,stateStore, ...
    EmetTotalStore,EmetPerTimeStore,tStepStore,...
    EdotStore_IterationAverage, ...
    tTotalIterationStore] = ...
    simulateLearningStepByStep(paramFixed,pInputControllerAsymmetricNominal, ...
    stateVar0_Model,contextNow,paramControllerGains);

%% convert the 8D back up to 10D to use the old functions
% pInputControllerStore_8D = pInputControllerStore_OnesTried;
% pInputControllerStore_10D = [pInputControllerStore_8D(1:3,:);
%     zeros(2,size(pInputControllerStore_8D,2));
%     pInputControllerStore_8D(4:8,:)];

%% post-process outputs and make some plots
% doAnimate = 0; % leave on 0. changing this to 1 will not do anything in this version.
% postProcessAfterLearning(pInputControllerStore_10D, ...
%     stateVar0_Model_BeforeLearning, ...
%     paramControllerGains,paramFixed,doAnimate);

%%
doAnimate = 0; % leave on 0. changing this to 1 will not do anything in this version.
postProcessHelper_JustThePlots(stateVar0_Model,tStore,stateStore, ...
    EmetTotalStore,EmetPerTimeStore,tStepStore,paramFixed,doAnimate,...
    EdotStore_IterationAverage, tTotalIterationStore)

end
