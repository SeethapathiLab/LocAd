function f = errorFromEnergyMemoryCompute(ENow_ConsideredGood,paramFixed,contextNow,energyParamsVsContext)
% the memory is updated by gradient descent on the prediction error between
% the memory function approximation and the current state/sensing
% this function computes the prediction error

EMemoryNow = computeEnergyFromContext(contextNow,paramFixed,energyParamsVsContext);

f = (ENow_ConsideredGood-EMemoryNow)'*(ENow_ConsideredGood-EMemoryNow);
f = sqrt(f);

end