function [gControllerMemory,gEnergyMemory] = ...
    gradientOfErrorFromMemoryCompute(pInputNow_ConsideredGood, ...
    ENowConsideredGood,paramFixed,contextGaitNow)
% the memory is updated by gradient descent on the prediction error between
% the memory function approximation and the current state/sensing
% this function computes the gradient

%% controller memory gradient
f0 = errorFromControllerMemoryCompute(pInputNow_ConsideredGood, ...
    paramFixed,contextGaitNow,paramFixed.storedmemory.controlSlopeVsContext);

h = 1e-4;

g = [];

slopeJControllerVsContext = paramFixed.storedmemory.controlSlopeVsContext;

for iCount = 1:size(slopeJControllerVsContext,1)
    for jCount = 1:size(slopeJControllerVsContext,2)
        
        slopeJControllerVsContextNow = slopeJControllerVsContext;
        slopeJControllerVsContextNow(iCount,jCount) = ...
            slopeJControllerVsContextNow(iCount,jCount) + h;

        f = errorFromControllerMemoryCompute(pInputNow_ConsideredGood,paramFixed,contextGaitNow,slopeJControllerVsContextNow);
        
        g(iCount,jCount) = (f-f0)/h;

    end
end

gControllerMemory = g;

%% energy memory gradient
f0 = errorFromEnergyMemoryCompute(ENowConsideredGood,paramFixed, ...
    contextGaitNow,paramFixed.storedmemory.energyParamsVsContext);

h = 1e-4;

g = [];

energyMemoryParamsVsContext = paramFixed.storedmemory.energyParamsVsContext;

for iCount = 1:size(energyMemoryParamsVsContext,1)
    for jCount = 1:size(energyMemoryParamsVsContext,2)
        
        energyMemoryParamsVsContextNow = energyMemoryParamsVsContext;
        energyMemoryParamsVsContextNow(iCount,jCount) = ...
            energyMemoryParamsVsContextNow(iCount,jCount) + h;

        f = ...
            errorFromEnergyMemoryCompute(ENowConsideredGood,paramFixed, ...
            contextGaitNow,energyMemoryParamsVsContextNow);
        
        g(iCount,jCount) = (f-f0)/h;

    end
end

gEnergyMemory = g;

end % essential to updating memory