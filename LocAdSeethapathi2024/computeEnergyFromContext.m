function f = computeEnergyFromContext(contextNow,paramFixed,energyParamsVsContext)

f = paramFixed.storedmemory.nominalEnergy + ...
        energyParamsVsContext*(contextNow-paramFixed.storedmemory.nominalContext);
% nominal energy is fixed and only the slope is changed for memory

end