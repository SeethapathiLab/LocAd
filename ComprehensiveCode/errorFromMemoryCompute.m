function f = errorFromMemoryCompute(slopeJControllerVsContext,pInputNow_ConsideredGood,paramFixed,contextGaitNow)
% the memory is updated by gradient descent on the prediction error between
% the memory function approximation and the current state/sensing
% this function computes the prediction error

pInputMemoryNow = paramFixed.storedmemory.nominalControl + ...
        slopeJControllerVsContext*(contextGaitNow-paramFixed.storedmemory.nominalContext); 

f = (pInputNow_ConsideredGood-pInputMemoryNow)'*(pInputNow_ConsideredGood-pInputMemoryNow);

end