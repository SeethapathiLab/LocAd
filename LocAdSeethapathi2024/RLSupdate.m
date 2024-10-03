function [Anew, errorOldLinear_MostRecentStep, errorNewLinear_MostRecentStep] = RLSupdate(Aold,beta,InputNowStore,...
    OutputNextStore,muMeasurement,numStepsToUse)
% this program does 'rolling least squares', that is least squares with
% finitely many past steps to build a linear model between the inputs and
% outputs.

numInputDimensions = size(InputNowStore,1);
numOutputDimensions = size(OutputNextStore,1);

% picking only a certain number of steps: each column is a step
InputNowStore = InputNowStore(:,end-numStepsToUse+1:end);
OutputNextStore = OutputNextStore(:,end-numStepsToUse+1:end);

% transpose, so that each row is a step
InputNowStore = InputNowStore';
OutputNextStore = OutputNextStore';

% adding a column of ones for the constant term
InputNowStore = [InputNowStore ones(size(InputNowStore,1),1)]; % each row is a new step

% just doing full least squares here for simplicity. easy to implement this
% rolling regression without remembering all the recent strides, that is,
% using a recursive update. this would be a finite memory recursive least
% squares (not to be confused with the common 'infinite
% memory recursive least squares'). we don't do this recursive version, as
% it is not scientifically necessary, as it is mathematically identical for
% behavioral predictions.
Anew = InputNowStore\OutputNextStore; 

%% least squares with exponential forgetting % we do not use this version. 
% lower weights for older data
% alphaForgetting = paramFixed.Learner.alphaForgettingForEstimator;
% for iCol = 1:numInputDimensions
%     InputNowStore(:,numInputDimensions+1-iCol) = ...
%         InputNowStore(:,numInputDimensions+1-iCol)*alphaForgetting^iCol;
% end
% Anew = InputNowStore\OutputNextStore;

%% find the error on all steps and then the most recent step using the pre-change 
Aold = Aold';
errorOldLinear_AllSteps = OutputNextStore-InputNowStore*Aold;
errorOldLinear_MostRecentStep = errorOldLinear_AllSteps(end,:)'; % rows are steps because of the old transpose

errorNewLinear_AllSteps = OutputNextStore-InputNowStore*Anew;
errorNewLinear_MostRecentStep = errorNewLinear_AllSteps(end,:)'; % rows are steps because of the old transpose
% doing another transpose, so the most recent error is a column vector

%% transpose it anyway, so steps are columns instead of rows
Anew = Anew';

end % checked and essential