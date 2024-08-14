function f = propulsivePeriodicTorque(angleTheta,paramFixed)

a = paramFixed.exo.assistanceMagnitude;
s = paramFixed.exo.assistanceHalfSupport;
p = paramFixed.exo.assistanceStartAngle;

% angleTheta = angleTheta-p;

f = 0;
if angleTheta>p && angleTheta< p+2*s
    f = a;
end

angleTheta = angleTheta-p;
if angleTheta>0 && angleTheta<s
    f = angleTheta/s*a;
elseif angleTheta>s && angleTheta<2*s
    m = -a/s;
    f = a+m*(angleTheta-s);
end

end