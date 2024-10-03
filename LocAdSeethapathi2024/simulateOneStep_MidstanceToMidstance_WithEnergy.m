function [pInput0_out,tlistTillEndstance, statevarlistTillEndstance, ...
   tlistTillMidstance, statevarlistMidstance, ...
   Emet_total,Emet_perTime,tTotal,Ework_pushoff,Ework_heelstrike] = ...
    simulateOneStep_MidstanceToMidstance_WithEnergy(pInput0,iStep,tStart, ...
    paramController,paramFixed)

if rem(iStep,2)==0
    paramController.tList_BeltSpeed = paramFixed.imposedFootSpeeds.tList;
    paramController.PushoffFootSpeedNowList = paramFixed.imposedFootSpeeds.footSpeed2List;
    paramController.HeelstrikeFootSpeedNowList = paramFixed.imposedFootSpeeds.footSpeed1List;
    paramController.PushoffAccelerationNowList = paramFixed.imposedFootSpeeds.footAcc2List;
else
    paramController.tList_BeltSpeed = paramFixed.imposedFootSpeeds.tList;
    paramController.PushoffFootSpeedNowList = paramFixed.imposedFootSpeeds.footSpeed1List;
    paramController.HeelstrikeFootSpeedNowList = paramFixed.imposedFootSpeeds.footSpeed2List;
    paramController.PushoffAccelerationNowList = paramFixed.imposedFootSpeeds.footAcc1List;
end

%% some fake variables 
numPointsPerInterval = 300;
tStance = 30; tEnd = tStart+tStance;
tspan = linspace(tStart,tEnd,numPointsPerInterval)';

%% mid-stance state
angleTheta0 = pInput0(1);
angleThetaDot0 = pInput0(2);
yFoot0 = pInput0(3);
SUMy0 = pInput0(4);

%% additional stuff for new swing cost
vSwing_Initial_LabFrame = pInput0(5); % new addition
paramController.PushoffFootSpeedNow = interp1(paramController.tList_BeltSpeed, ...
    paramController.PushoffFootSpeedNowList,tStart,'linear','extrap');
vBody_Initial_LabFrame = angleThetaDot0+paramController.PushoffFootSpeedNow;

%%
y_atMidstance_WRTfoot = paramFixed.leglength*sin(angleTheta0+paramFixed.angleSlope); % should be zero, ideally
y_atMidstance_Slopeframe = y_atMidstance_WRTfoot+yFoot0;

ydot_atMidstance = angleThetaDot0*paramFixed.leglength; % speed in belt frame (WRT foot)

%%
yFootBegin_Step1 = yFoot0;

%% getting the state error at mid-stance
delta_ydot_atMidstance_beltframe = ...
    ydot_atMidstance - paramController.ydot_atMidstance_nominal_beltframe;
    
delta_y_atMidstance = y_atMidstance_Slopeframe - ...
    paramController.y_atMidstance_nominal_slopeframe;
delta_SUMy = SUMy0-paramController.SUMy_atMidstance_nominal_slopeframe;

%% doing the delta ydot in lab frame
ydot_atMidstance_LabFrame = ydot_atMidstance+paramController.PushoffFootSpeedNow;
vFootNominal = -0.35; % ideally get this from some file rather than hard code here
paramController.ydot_atMidstance_nominal_labframe = ...
    paramController.ydot_atMidstance_nominal_beltframe+vFootNominal;
delta_ydot_atMidstance_labframe = ydot_atMidstance_LabFrame-paramController.ydot_atMidstance_nominal_labframe;

%% add sensory noise
delta_ydot_atMidstance_beltframe = delta_ydot_atMidstance_beltframe + ...
    paramFixed.velocitySensoryNoise*randn;

%% setting up the feedback controller with vision and speed memory
delta_vFoot_labFrame = ...
    (delta_ydot_atMidstance_labframe-delta_ydot_atMidstance_beltframe);
paramController.theta_end_thisStep = paramController.theta_end_nominal+ ...
    paramController.legAngle_gain_ydot*(delta_ydot_atMidstance_beltframe)+ ...
    paramController.legAngle_gain_y*(delta_y_atMidstance) + ...
    paramController.legAngle_gain_SUMy*(delta_SUMy) + ...
    paramController.legAngle_gain_BeltSpeed*delta_vFoot_labFrame;


%% 
if paramController.theta_end_thisStep>0.95*pi/4
    paramController.theta_end_thisStep = 0.95*pi/4;
end

%% first half step: midstance to endstance
stateVar0 = pInput0(1:3);
[tlistTillEndstance, statevarlistTillEndstance] = ...
    simulateIPUntilEndstance(stateVar0,tspan,paramFixed,paramController);

%% push off 
% pushoff happens in pushoff foot frame

% pre-push-off velocity
angleThetaEnd = statevarlistTillEndstance(end,1);
dAngleThetaEnd = statevarlistTillEndstance(end,2);

unit_vector_AlongCircle = ...
    [cos(paramController.theta_end_thisStep+paramFixed.angleSlope) -sin(paramController.theta_end_thisStep+paramFixed.angleSlope)];

vEndstance_body_pushoffFootFrame = ...
    unit_vector_AlongCircle*dAngleThetaEnd*paramFixed.leglength;

unit_vector_trailingleg = ...
    [sin(paramController.theta_end_thisStep+paramFixed.angleSlope) cos(paramController.theta_end_thisStep+paramFixed.angleSlope)];

%% push off computed in a feedback way
PushoffImpulseMagnitude_thisStep = paramController.PushoffImpulseMagnitude_nominal + ...
    paramController.pushoff_gain_ydot*delta_ydot_atMidstance_beltframe + ... % velocity maintenance
    paramController.pushoff_gain_y*delta_y_atMidstance + ...
    paramController.pushoff_gain_SUMy*delta_SUMy + ...
    paramController.pushoff_gain_BeltSpeed*delta_vFoot_labFrame; % station keeping

%%
% in foot frame of reference
v_afterPushoff_pushoffFootFrame = ... % applying the push-off
    vEndstance_body_pushoffFootFrame + ...
    PushoffImpulseMagnitude_thisStep*unit_vector_trailingleg;

deltaE_pushoff = ...
    0.5*paramFixed.mbody*norm(v_afterPushoff_pushoffFootFrame)^2 ...
    -0.5*paramFixed.mbody*norm(vEndstance_body_pushoffFootFrame)^2;

% interpolate to get the correct belt speed
paramController.PushoffFootSpeedNow = interp1(paramController.tList_BeltSpeed, ...
    paramController.PushoffFootSpeedNowList,tlistTillEndstance(end),'linear','extrap');

% converting to lab frame
v_PushoffFoot_Slopeframe = ...
    [paramController.PushoffFootSpeedNow 0]; % current stance (pushoff) belt speed
v_afterPushoff_labframe = ...
    v_afterPushoff_pushoffFootFrame + v_PushoffFoot_Slopeframe; % adding the belt speed

%% heel strike
% heelstrike happens in heelstrike foot frame

paramController.HeelstrikeFootSpeedNow = ...
    interp1(paramController.tList_BeltSpeed, ...
    paramController.HeelstrikeFootSpeedNowList,tlistTillEndstance(end),'linear','extrap');

v_HeelstrikeFoot_labframe = ...
    [paramController.HeelstrikeFootSpeedNow 0];
v_afterPushoff_heelstrikeFootFrame = ...
    v_afterPushoff_labframe - v_HeelstrikeFoot_labframe;

stepLength_nextStep = ...
    2*paramFixed.leglength*sin(paramController.theta_end_thisStep+paramFixed.angleSlope);
vector_leadingleg = ...
    [-sin(paramController.theta_end_thisStep+paramFixed.angleSlope) cos(paramController.theta_end_thisStep+paramFixed.angleSlope)];
unit_vector_leadingleg = vector_leadingleg/norm(vector_leadingleg);
v_afterHeelStrike_heelstrikeFootFrame = v_afterPushoff_heelstrikeFootFrame - (dot(unit_vector_leadingleg,v_afterPushoff_heelstrikeFootFrame)*unit_vector_leadingleg);

deltaE_heelstrike = ...
    0.5*paramFixed.mbody*norm(v_afterHeelStrike_heelstrikeFootFrame)^2 ...
    -0.5*paramFixed.mbody*norm(v_afterPushoff_heelstrikeFootFrame)^2;



%% initialize the second step simulation
tStart = tlistTillEndstance(end);
tStance = 30; tEnd = tStart+tStance;
tspan = linspace(tStart,tEnd,numPointsPerInterval)';

%% get the new theta and thetaDot for the next step
% newTheta+angleSlope = -(oldTheta+angleSlope)
% newTheta = -oldTheta-2*angleSlope
angleTheta0 = -paramController.theta_end_thisStep-2*paramFixed.angleSlope;
dAngleTheta0 = norm(v_afterHeelStrike_heelstrikeFootFrame)/paramFixed.leglength;
% move the foot to the next position
yFoot0 = statevarlistTillEndstance(end,3) + stepLength_nextStep;

%%
yFootEnd_Step1 = statevarlistTillEndstance(end,3);
yFootBegin_Step2 = yFoot0;

%%

stateVar0 = [angleTheta0; dAngleTheta0; yFoot0]; 

%% second half step: end-stance to mid-stance
[tlistTillMidstance, statevarlistMidstance] = ...
    simulateIPUntilMidstance(stateVar0,tspan,paramFixed,paramController);

%%
stateVar0 = statevarlistMidstance(end,:)';

%%
yFoot0 = stateVar0(3);
SUMy0 = SUMy0 + (yFoot0-paramController.y_atMidstance_nominal_slopeframe);
  
%% 
yFootEnd_Step2 = yFoot0;

%%
pInput0_out = [stateVar0; SUMy0];

%% step to step cost
Ework_pushoff = abs(deltaE_pushoff);
Ework_heelstrike = abs(deltaE_heelstrike);
Emet_step2step = paramFixed.bPos*Ework_pushoff + paramFixed.bNeg*Ework_heelstrike;

%% swing cost: NEW
Thalfstance1 = range(tlistTillEndstance);
Thalfstance2 = range(tlistTillMidstance);

vSwing_AtoC = (yFootBegin_Step2-yFootBegin_Step1)/Thalfstance1;
vSwing_BtoD = (yFootEnd_Step2-yFootEnd_Step1)/Thalfstance2;

%% remove work cost
C1 = 0; C3 = 0; C2 = 0;

%% Doke addition
C1 = C1 + ...
    swingCostDoke(Thalfstance1,vSwing_Initial_LabFrame, ...
    vSwing_AtoC,vBody_Initial_LabFrame,paramFixed);
C3 = C3 + ...
    swingCostDoke(Thalfstance2,paramController.PushoffFootSpeedNow, ...
    vSwing_BtoD,v_afterPushoff_labframe(1),paramFixed);

%%

EmetSwing_total = C1+C2+C3;

%%
Emet_total = Emet_step2step + EmetSwing_total;
tStance1 = range(tlistTillEndstance); tStance2 = range(tlistTillMidstance);
Emet_perTime = Emet_total/(tStance1+tStance2);
tTotal = (tStance1+tStance2);

%%
pInput0_out = [pInput0_out; vSwing_BtoD];

end % essential