function randSpeedFluctuations = clipRandSpeedFluctuations(randSpeedFluctuations,deltaT,aMax)

for iTime = 2:length(randSpeedFluctuations)
    aNow = (randSpeedFluctuations(iTime)-randSpeedFluctuations(iTime-1))/deltaT;
    if aNow>aMax
        randSpeedFluctuations(iTime) = randSpeedFluctuations(iTime-1) + aMax*deltaT;
    elseif aNow<-aMax
        randSpeedFluctuations(iTime) = randSpeedFluctuations(iTime-1) - aMax*deltaT;
    end
end

end