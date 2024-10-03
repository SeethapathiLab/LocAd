function f = computeControllerFromContext(contextNow,paramFixed,controlSlopeVsContext)

f = paramFixed.storedmemory.nominalControl + ...
        controlSlopeVsContext*(contextNow-paramFixed.storedmemory.nominalContext);
% nominal control is fixed and only the slope is changed for memory

end