function [footSpeed1,footSpeed2] = getTreadmillSpeed(t,beltSpeedsImposed)

footSpeed1 = interp1(beltSpeedsImposed.tList,...
    beltSpeedsImposed.footSpeed1List,t,'linear','extrap');
footSpeed2 = interp1(beltSpeedsImposed.tList,...
    beltSpeedsImposed.footSpeed2List,t,'linear','extrap');

end % checked and essential. Used in the main program and in a 
% post-processing plotting program could be wrapped into some other
% function. 