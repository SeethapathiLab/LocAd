function paramController = loadControllerGainParameters(paramFixed)
% These are the feedback gains in the feedback controller that keeps the
% biped stable. They are obtained from how 

%% Controller parameters, gains, Fixed during the optimization
switch paramFixed.swingCost.Coeff 
    case 0.9
        paramController.pushoff_gain_ydot  = -0.521088310893437;
        paramController.legAngle_gain_ydot =  0.279308152405233;
        paramController.pushoff_gain_y =  -0.085939152240409;
        paramController.legAngle_gain_y =  -0.028999999999996;
        paramController.pushoff_gain_SUMy =  -0.007302228127922;
        paramController.legAngle_gain_SUMy =  0.002019507100848;
        paramController.legAngle_gain_BeltSpeed = -0.075044622818653;
        paramController.pushoff_gain_BeltSpeed = -1.055930819923483;
end

%% the following doesn't matter wrt results
paramController.ControllerBeltFrameVsLabFrame = 1;
% paramController.ControllerBeltFrameVsLabFrame = 0.75;

%%
% temp = load('DatStoredMemoryLinearAndQuadratic.mat');
% storedFFController = temp.storedFFController;
% 
% controlSlopeVsContext = ... % linear policy for tied speed walking
%     -[storedFFController.linearModel.Bslopes([1:3 6:10]) storedFFController.linearModel.Bslopes([1:3 6:10])]/2;
% 
% slopeVsFootSpeed = sum(controlSlopeVsContext,2); 
% % because we had previously broken up this into the left and right belt
% % contributions to 
% 
% paramController.legAngle_gain_BeltSpeed = slopeVsFootSpeed(1)-paramController.legAngle_gain_ydot*slopeVsFootSpeed(2);
% paramController.pushoff_gain_BeltSpeed = slopeVsFootSpeed(3)-paramController.pushoff_gain_ydot*slopeVsFootSpeed(2);
% % 

end  % code checked and essential