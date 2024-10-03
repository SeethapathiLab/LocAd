function beltSpeedsImposed = makeTreadmillSpeedCommon(paramFixed)

if ~isempty(strfind(paramFixed.speedProtocol,'tied'))
    beltSpeedsImposed = makeTreadmillSpeed_Tied(paramFixed);
elseif ~isempty(strfind(paramFixed.speedProtocol,'split'))
    if isempty(strfind(paramFixed.speedProtocol,'Gelsy'))&&isempty(strfind(paramFixed.speedProtocol,'roemmich2015'))&&isempty(strfind(paramFixed.speedProtocol,'leech2018'))
        beltSpeedsImposed = makeTreadmillSpeed_Split(paramFixed);
    elseif ~isempty(strfind(paramFixed.speedProtocol,'Gelsy'))
        beltSpeedsImposed = makeTreadmillSpeed_SplitGelsyGradual(paramFixed);
    elseif ~isempty(strfind(paramFixed.speedProtocol,'roemmich2015'))
        beltSpeedsImposed = makeTreadmillSpeed_Roemmich2015(paramFixed);
    elseif ~isempty(strfind(paramFixed.speedProtocol,'leech2018'))
        beltSpeedsImposed = makeTreadmillSpeed_Leech2018_threeDeltaVLevels(paramFixed)
    end
else
        error('Error: belt speed should be either tied or split or gradual or roemmich');
end

end