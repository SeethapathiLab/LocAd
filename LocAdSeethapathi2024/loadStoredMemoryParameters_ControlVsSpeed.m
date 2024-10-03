function paramFixed = loadStoredMemoryParameters_ControlVsSpeed(paramFixed)

%% memory stored based on nominal
switch paramFixed.swingCost.Coeff
    case 0.9
        paramFixed.storedmemory.nominalControl = [0.328221262798818
            0.310751796902254
            0.153556843539029
            0.328221491356562
            0.310751694570805
            0.153557221281688
            -0.000000038953735
            -0.000000038953735];
end

paramFixed.storedmemory.nominalContext = [-0.35; -0.35];
numContextVars = length(paramFixed.storedmemory.nominalContext);

%% how memory changes with context: slope
% learningParameterListLength = length(paramFixed.storedmemory.nominalControl);

paramFixed.storedmemory.controlSlopeVsContext = ...
    zeros(8,2); % start with a blank slate for memory accumulation
% zero here because it is accounted for in the controller

paramFixed.storedmemory.nominalEnergy = 0.051;
paramFixed.storedmemory.energyParamsVsContext = zeros(1,numContextVars);
warning('to fix nominal energy vs speed: check that the nominal Energy, really the cost is okay -- it may need to change with symmetry cost!!')
pause(5);

end