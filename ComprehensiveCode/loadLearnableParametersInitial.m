function pInputControllerAsymmetricNominal = ...
    loadLearnableParametersInitial(paramFixed)

%% what are the learnable parameters
% step - odd
% theta_end_nominal = ?
% ydot_atMidstance_nominal_beltframe = ?
% PushoffImpulseMagnitude_nominal = ?
% y_atMidstance_nominal_slopeframe = 0;
% SUMy_atMidstance_nominal_slopeframe = 0;

% step - even
% theta_end_nominal = ?
% ydot_atMidstance_nominal_beltframe = ?
% PushoffImpulseMagnitude_nominal = ?
% y_atMidstance_nominal_slopeframe = ?
% SUMy_atMidstance_nominal_slopeframe = ?

% asymmetric nominal means that the nominal for the two steps are not the
% same

%% evaluate the objective function, asymmetric nominal
switch paramFixed.swingCost.Coeff
    case 0.9
        pInputControllerAsymmetricNominal = [0.328221262798818
            0.310751796902254
            0.153556843539029
            0
            0
            0.328221491356562
            0.310751694570805
            0.153557221281688
            -0.000000038953735
            -0.000000038953735];
end

end % checked and essential