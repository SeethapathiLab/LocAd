function stateVar0_Model = loadInitialBodyState(pInputControllerAsymmetricNominal)
%% Initial conditions for the simulation
% NOTE: these are MID-STANCE initial conditions

vSwingInitial = 0.35; % initial swing speed - shouldn't matter much, ideally equal to the nominal velocity?

stateVar0_Model = [0                        % angleTheta0 = stance leg angle
    pInputControllerAsymmetricNominal(2)    % dAngleTheta0 = stance leg angular rate
    0                                       % yFoot0 = 0; % in lab frame
    0                                       % sum of yFoot in lab frame (integral feedback for station keeping)
    vSwingInitial];                         % vSwing 

end  % checked and essential