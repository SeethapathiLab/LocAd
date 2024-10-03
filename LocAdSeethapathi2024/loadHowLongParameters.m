function paramFixed = loadHowLongParameters(paramFixed)
% use this function mainly if you want to run the program for longer or
% shorter than is automatically coded into the default when the protocol is 
%  defined. the numbers in this function will take effect only when the
%  call to this function is uncommented in the main program.

%% How many steps to simulate
paramFixed.numStepsToLearn = 2000;

%% optimization iterations
paramFixed.numIterations = floor(paramFixed.numStepsToLearn/paramFixed.Learner.numStepsPerIteration);

if mod(paramFixed.Learner.numStepsPerIteration,2)~=0 
    paramFixed.Learner.numStepsPerIteration = paramFixed.numStepsPerIteration + 1;
end

% even number ensures that the left and the right belt steps are weighted
% equally and constantly each time  Otherwise there will be too much
% jumpiness between each run

end % checked and not essential (see comment )