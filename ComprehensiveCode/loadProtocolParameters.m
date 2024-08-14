function paramFixed = loadProtocolParameters(paramFixed)
% adaptation protocol parameters: how the treadmill speed is changed, and
% whether the adaptation protocol is on a split-belt treadmill or a tied
% belt treadmill.

if ~isempty(strfind(paramFixed.speedProtocol,'split'))
    paramFixed.SplitOrTied = 'split';
elseif ~isempty(strfind(paramFixed.speedProtocol,'tied'))
    paramFixed.SplitOrTied = 'tied';
end

%% speed protocol details based on speed protocol name
if ~isfield(paramFixed,'transitionTime')
    paramFixed.transitionTime = 10; % in seconds. 
end
paramFixed.imposedFootSpeeds = makeTreadmillSpeedCommon(paramFixed);

%%
paramFixed.angleSlope = 0;  
% do not change: the code has not been tested for non-zero values

%% We get the simulation duration from the protocol, but you can override 
% this by changing the values in loadHowLongParameters.m function and
% uncommenting that function in the root program

%% How many steps to simulate
nominalStepTime = 1.7; 
paramFixed.numStepsToLearn = paramFixed.imposedFootSpeeds.tList(end)/nominalStepTime;
paramFixed.numStepsToLearn = round(paramFixed.numStepsToLearn/100)*100; % round to the nearest hundred

%% optimization iterations
paramFixed.numIterations = floor(paramFixed.numStepsToLearn/paramFixed.Learner.numStepsPerIteration);

if mod(paramFixed.Learner.numStepsPerIteration,2)~=0 
    paramFixed.Learner.numStepsPerIteration = paramFixed.numStepsPerIteration + 1;
end


end  % checked and essential