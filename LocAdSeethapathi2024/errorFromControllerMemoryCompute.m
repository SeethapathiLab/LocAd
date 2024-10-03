function f = errorFromControllerMemoryCompute(pInputNow_ConsideredGood,paramFixed,contextNow,controlSlopeVsContext)
% the memory is updated by gradient descent on the prediction error between
% the memory function approximation and the current state/sensing
% this function computes the prediction error

pInputMemoryNow = computeControllerFromContext(contextNow,paramFixed,controlSlopeVsContext); 

f = (pInputNow_ConsideredGood-pInputMemoryNow)'*(pInputNow_ConsideredGood-pInputMemoryNow);

f = sqrt(f);

end