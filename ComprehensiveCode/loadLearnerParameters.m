function paramFixed = loadLearnerParameters(paramFixed)

%% Parameters of the learner
% paramFixed.Learner.LearningRate = 0; % no learning
paramFixed.Learner.LearningRate = 0.00012; % default learning rate for
% split belt walking
% paramFixed.Learner.LearningRate = 0.004; % high learning rate for tied walking

% paramFixed.Learner.noiseSTDExploratory = 0.0002; % default
paramFixed.Learner.noiseSTDExploratory = 0.002; % higher for tied walking

paramFixed.Learner.includeInternalModel = 1; % takes values zero or one

paramFixed.Learner.numStepsToUseForEstimator = 30;

%% moving toward memory
% paramFixed.Learner.LearningRateTowardMemory = 0; % no progress toward stored memory
% paramFixed.Learner.LearningRateTowardMemory = 0.02; % default: some progress toward stored memory 
% paramFixed.Learner.LearningRateTowardMemory = 0.005; % default: some progress toward stored memory 
paramFixed.Learner.LearningRateTowardMemory = 0.01; % default: some progress toward stored memory 
% paramFixed.Learner.LearningRateTowardMemory = 1; % reach stored memory in a single stride

%% truncated cosine tuning
paramFixed.Learner.powerToTheMoveToMemory = 10;
paramFixed.Learner.powerToTheMemoryFormation = 10;

%% making new memories
paramFixed.Learner.LearningRateForMemoryFormationUpdates = 0.0; % no new memories
paramFixed.Learner.LearningRateForMemoryFormationUpdates = 0.03;

%% how frequently do we update the controller parameter
paramFixed.Learner.numStepsPerIteration = 2;

%% trust region
paramFixed.Learner.trustRegionSize = 0.25*paramFixed.Learner.noiseSTDExploratory;
paramFixed.Learner.shouldWeUseTrustRegion = 1;

%% prediction error threshold
paramFixed.Learner.predictionErrorThreshold = 2*paramFixed.noiseEnergySensory_Additive; % note: this should be some overall estimate per output value
paramFixed.Learner.shouldWeThresholdPredictionError = 0; % set 0 if not interested in this thresholding
% if 1, the prediction error threshold is used to see whether the gradient
% is reliable and if the gradient is not reliable, the 
% do not use this

%% not used: exponential forgetting for gradient estimator. default = finite memory without exponential forgetting
paramFixed.Learner.alphaForgettingForEstimator = 0; % how the past is weighted compared to the present
% can comment out as it is not used

end % checked and essential