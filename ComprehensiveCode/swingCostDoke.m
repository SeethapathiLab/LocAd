function C = swingCostDoke(tDurationOfChange,vInitial,vFinal,vBody,paramFixed)
% this approximates the leg swing cost in Doke and Kuo 2005, which posits a
% cost related to force rate

vInitialRelative = vInitial-vBody;
vFinalRelative = vFinal-vBody;

deltaV = vFinalRelative-vInitialRelative;
Force = paramFixed.mFoot*deltaV/tDurationOfChange;
ForceRate = Force/tDurationOfChange;

epsilon = 0.01;

C = paramFixed.swingCost.Coeff*sqrt(ForceRate^2+epsilon^2)^paramFixed.swingCost.alpha;

end % code checked and essential