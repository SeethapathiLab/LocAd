function beltSpeedsImposed = makeTreadmillSpeed_Leech2018_threeDeltaVLevels(paramFixed)

L = 0.9; g = 9.81;
timeScaling = sqrt(L/g);

% vNormal = -0.3;
% vFastSmall = -0.4;
% vFastMedium = -0.5;
% vFastLarge = -0.6;

vNormal = -0.35;
vFastSmall = -0.416666;
vFastMedium = -0.483333;
vFastLarge = -0.55;

t_warmup = 6;
t_adapt1 = 10;
t_deadapt = 25;
t_adapt2 = 10;

tDurationTransition = paramFixed.transitionTime/timeScaling;

switch paramFixed.speedProtocol
    case 'split leech2018 adapt small'

        %% transitioning from one speed to next takes 10 seconds, say

        %% phase 1: warmup
        tDuration1 = t_warmup*60/timeScaling;
        footSpeed1_phase1 = vNormal;
        footSpeed2_phase1 = vNormal;

        %% phase 2: adaptation 1
        tDuration2 = t_adapt1*60/timeScaling;
        footSpeed1_phase2 = vFastSmall;
        footSpeed2_phase2 = vNormal;

        %% phase 3: de adaptation
        tDuration3 = t_deadapt*60/timeScaling; % expt is 25
        footSpeed1_phase3 = vNormal;
        footSpeed2_phase3 = vNormal;

        %% phase 4: re-adaptation
        tDuration4 = 10*60/timeScaling;
        footSpeed1_phase4 = vFastSmall;
        footSpeed2_phase4 = vNormal;

        %% initialization
        tStore = [0; tDuration1; tDuration2; tDuration3; tDuration4];
        tStore = cumsum(tStore);

        footSpeed1Store = [footSpeed1_phase1; footSpeed1_phase1; ...
            footSpeed1_phase2; footSpeed1_phase3; footSpeed1_phase4];
        footSpeed2Store = [footSpeed2_phase1; footSpeed2_phase1; ...
            footSpeed2_phase2; footSpeed2_phase3; footSpeed2_phase4];

    case 'split leech2018 adapt medium'


        %% phase 1: warmup
        tDuration1 = t_warmup*60/timeScaling;
        footSpeed1_phase1 = vNormal;
        footSpeed2_phase1 = vNormal;

        %% phase 2: adaptation 1
        tDuration2 = 10*60/timeScaling;
        footSpeed1_phase2 = vFastMedium;
        footSpeed2_phase2 = vNormal;

        %% phase 3: de adaptation
        tDuration3 = 25*60/timeScaling; % default is 20
        footSpeed1_phase3 = vNormal;
        footSpeed2_phase3 = vNormal;

        %% phase 4: re-adaptation
        tDuration4 = 10*60/timeScaling;

        footSpeed1_phase4 = vFastMedium;
        footSpeed2_phase4 = vNormal;

        %% initialization
        tStore = [0; tDuration1; tDuration2; tDuration3; tDuration4];
        tStore = cumsum(tStore);

        footSpeed1Store = [footSpeed1_phase1; footSpeed1_phase1; ...
            footSpeed1_phase2; footSpeed1_phase3; footSpeed1_phase4];
        footSpeed2Store = [footSpeed2_phase1; footSpeed2_phase1; ...
            footSpeed2_phase2; footSpeed2_phase3; footSpeed2_phase4];

    case 'split leech2018 adapt large'


        %% phase 1: warmup
        tDuration1 = t_warmup*60/timeScaling;
        footSpeed1_phase1 = vNormal;
        footSpeed2_phase1 = vNormal;

        %% phase 2: adaptation 1
        tDuration2 = 10*60/timeScaling;
        footSpeed1_phase2 = vFastLarge;
        footSpeed2_phase2 = vNormal;

        %% phase 3: de adaptation
        tDuration3 = 25*60/timeScaling; % default is 25
        footSpeed1_phase3 = vNormal;
        footSpeed2_phase3 = vNormal;

        %% phase 4: post-adaptation
        tDuration4 = 10*60/timeScaling;

        footSpeed1_phase4 = vFastLarge;
        footSpeed2_phase4 = vNormal;

        %% initialization
        tStore = [0; tDuration1; tDuration2; tDuration3; tDuration4];
        tStore = cumsum(tStore);

        footSpeed1Store = [footSpeed1_phase1; footSpeed1_phase1; ...
            footSpeed1_phase2; footSpeed1_phase3; footSpeed1_phase4];
        footSpeed2Store = [footSpeed2_phase1; footSpeed2_phase1; ...
            footSpeed2_phase2; footSpeed2_phase3; footSpeed2_phase4];

end

%% adding transition phases
tStore_new = 0;
footSpeed1Store_new = footSpeed1Store(1);
footSpeed2Store_new = footSpeed2Store(1);

for iTran = 2:length(tStore)
    if iTran<length(tStore)
        tStore_new = [tStore_new; tStore(iTran); ...
            tStore(iTran)+tDurationTransition];
        footSpeed1Store_new = [footSpeed1Store_new; footSpeed1Store(iTran); footSpeed1Store(iTran+1)];
        footSpeed2Store_new = [footSpeed2Store_new; footSpeed2Store(iTran); footSpeed2Store(iTran+1)];
    else
        tStore_new = [tStore_new; tStore(iTran)];
        footSpeed1Store_new = [footSpeed1Store_new; footSpeed1Store(iTran)];
        footSpeed2Store_new = [footSpeed2Store_new; footSpeed2Store(iTran)];
    end
end

%% plot the things
figure(2555);
plot(tStore_new,abs(footSpeed1Store_new),'linewidth',2); hold on;
plot(tStore_new,abs(footSpeed2Store_new),'linewidth',2);
xlabel('t'); ylabel('treadmill speeds(m/s)');
legend('(abs) fast belt','(abs) slow belt');
ylim([0 0.75]);

%% store in a structure
beltSpeedsImposed.tList = tStore_new;
beltSpeedsImposed.footSpeed1List = footSpeed1Store_new;
beltSpeedsImposed.footSpeed2List = footSpeed2Store_new;

a1List = ...
    diff(beltSpeedsImposed.footSpeed1List)./diff(beltSpeedsImposed.tList);
a2List = ...
    diff(beltSpeedsImposed.footSpeed2List)./diff(beltSpeedsImposed.tList);

a1List = [a1List; 0]; a2List = [a2List; 0];

%%
beltSpeedsImposed.footAcc1List = a1List;
beltSpeedsImposed.footAcc2List = a2List;

end