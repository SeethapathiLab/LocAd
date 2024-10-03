function [yKneeList,zKneeList] = kneeGivenBodyFoot(yBodyList,zBodyList,yFootList,zFootList)

yKneeList = zeros(size(yBodyList)); zKneeList = yKneeList;

for jFrame = 1:length(yBodyList)
    [yKneeList(jFrame),zKneeList(jFrame)] = ...
        kneeGivenBodyFootScalar(yBodyList(jFrame),zBodyList(jFrame),yFootList(jFrame),zFootList(jFrame));
end

end

function [yKnee,zKnee] = kneeGivenBodyFootScalar(yBody,zBody,yFoot,zFoot)

yMid = (yBody+yFoot)/2;
zMid = (zBody+zFoot)/2;

legLengthNow = norm([yBody-yFoot; zBody-zFoot]);
legLengthNominal = 1;

alpha = acos(legLengthNow/legLengthNominal);
alpha = abs(alpha);

R = [cos(alpha) -sin(alpha); sin(alpha) cos(alpha)];

temp = [yBody; zBody] + R*[yMid-yBody; zMid-zBody];
yKnee = temp(1); zKnee = temp(2);

end % checked and not essential. 
% this is just for visualization purposes suppressed in this version.