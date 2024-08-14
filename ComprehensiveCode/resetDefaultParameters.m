

%% regular split-belt, figure 2a
% paramFixed.SplitOrTied = 'split';
% paramFixed.speedProtocol = 'classic split belt';
% paramFixed.transitionTime = 10; % in seconds. 
% paramFixed.imposedFootSpeeds = makeTreadmillSpeed_Split(paramFixed);

%% regular tied belt speed changes
% more familiar task of walking on a regular treadmill with speed changes
paramFixed.transitionTime = 10; % in seconds. 
paramFixed.SplitOrTied = 'tied';
% paramFixed.speedProtocol = 'single speed';
paramFixed.speedProtocol = 'four speed changes';
paramFixed.imposedFootSpeeds = makeTreadmillSpeed_Tied(paramFixed);

%% to do: merge the makeTreadmillSpeed Tied and Split into a single program. easy.

%% default split, except, turn off memory and learning is easy.

%% default split, except, different learning rates. easy.

%% series of learning rates toward memory. easy.

%% series of increased sensory noise for fixed exploratory noise. easy.

%% basic savings protocol. merge into makeTreadmillSpeed. easy.

%% interference protocol.
    %  Malone-Bastian protocol. TATATB vs TATBTA.
    %  TA vs TBA plus new experiments … needs sensory/exploratory noise that is similar magnitude to experiment

%% gradual protocol

%% noise protocol.

%% state-dependent exoskeleton response

%% various roemmich protocols: absrupt, gradual, abrupts with gradual washout, extended gradual, short abrupt

%% generalization and perturbation size effect

%% degraded learning??



