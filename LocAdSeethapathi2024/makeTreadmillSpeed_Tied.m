function beltSpeedsImposed = makeTreadmillSpeed_Tied(paramFixed)

L = 0.95; g = 9.81;
timeScaling = sqrt(L/g);
timePerPhaseInMin = 2;

paramFixed.transitionTime = 3;

% vNormal = -0.35;
% vFast = -0.425;
% vSlow = -0.275;
% vVeryFast = -0.5;
% vVerySlow = -0.20;

vNormal = -0.35;
vSlow = -0.35*0.75;
vVerySlow = -0.35*0.5;
vVeryFast = -0.35*1.5;
vFast = -0.35*1.25;


%%
switch paramFixed.speedProtocol
    case 'single speed'

        %% transitioning from one speed to next takes 10 seconds, say
        tDurationTransition = paramFixed.transitionTime/timeScaling;

        %% phase 1: warmup
        tDuration1 = 9*60/timeScaling;
        footSpeed1_phase1 = vNormal;
        footSpeed2_phase1 = vNormal;

        %% phase 2: baseline
        tDuration2 = 1*60/timeScaling;
        footSpeed1_phase2 = vNormal;
        footSpeed2_phase2 = vNormal;

        %% phase 3: adaptation
        tDuration3 = 1*60/timeScaling; % default is 20
        footSpeed1_phase3 = vNormal;
        footSpeed2_phase3 = vNormal;

        %% phase 4: post-adaptation
        tDuration4 = 1*60/timeScaling;
        footSpeed1_phase4 = vNormal;
        footSpeed2_phase4 = vNormal;

        %% initialization
        tStore = [0; tDuration1; tDuration2; tDuration3; tDuration4];
        tStore = cumsum(tStore);

        footSpeed1Store = [footSpeed1_phase1; footSpeed1_phase1; ...
            footSpeed1_phase2; footSpeed1_phase3; footSpeed1_phase4];
        footSpeed2Store = [footSpeed2_phase1; footSpeed2_phase1; ...
            footSpeed2_phase2; footSpeed2_phase3; footSpeed2_phase4];

    case 'exo tied single speed state dependent'

        %% transitioning from one speed to next takes 10 seconds, say
        tDurationTransition = paramFixed.transitionTime/timeScaling;

        %% phase 1: warmup
        tDuration1 = 0.25*60/timeScaling;
        footSpeed1_phase1 = vNormal;
        footSpeed2_phase1 = vNormal;

        %% phase 2: baseline
        tDuration2 = 0.25*60/timeScaling;
        footSpeed1_phase2 = vNormal;
        footSpeed2_phase2 = vNormal;

        %% phase 3: adaptation
        tDuration3 = 0.5*60/timeScaling; % default is 20
        footSpeed1_phase3 = vNormal;
        footSpeed2_phase3 = vNormal;

        %% phase 4: post-adaptation
        tDuration4 = 2*60/timeScaling;
        footSpeed1_phase4 = vNormal;
        footSpeed2_phase4 = vNormal;

        %% initialization
        tStore = [0; tDuration1; tDuration2; tDuration3; tDuration4];
        tStore = cumsum(tStore);

        footSpeed1Store = [footSpeed1_phase1; footSpeed1_phase1; ...
            footSpeed1_phase2; footSpeed1_phase3; footSpeed1_phase4];
        footSpeed2Store = [footSpeed2_phase1; footSpeed2_phase1; ...
            footSpeed2_phase2; footSpeed2_phase3; footSpeed2_phase4];

    case 'single speed change pulse'

        %% transitioning from one speed to next takes 10 seconds, say
        tDurationTransition = paramFixed.transitionTime/timeScaling;

        %% phase 1: warmup
        tDuration1 = 4*60/timeScaling;
        footSpeed1_phase1 = vNormal;
        footSpeed2_phase1 = vNormal;

        %% phase 2: baseline
        tDuration2 = 1*60/timeScaling;
        footSpeed1_phase2 = vNormal;
        footSpeed2_phase2 = vNormal;

        %% phase 3: adaptation
        tDuration3 = timePerPhaseInMin*60/timeScaling; % default is 20
        footSpeed1_phase3 = vFast;
        footSpeed2_phase3 = vFast;

        %% phase 4: post-adaptation
        tDuration4 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase4 = vNormal;
        footSpeed2_phase4 = vNormal;

        %% initialization
        tStore = [0; tDuration1; tDuration2; tDuration3; tDuration4];
        tStore = cumsum(tStore);

        footSpeed1Store = [footSpeed1_phase1; footSpeed1_phase1; ...
            footSpeed1_phase2; footSpeed1_phase3; footSpeed1_phase4];
        footSpeed2Store = [footSpeed2_phase1; footSpeed2_phase1; ...
            footSpeed2_phase2; footSpeed2_phase3; footSpeed2_phase4];

    case 'single speed change'

        %% transitioning from one speed to next takes 10 seconds, say
        tDurationTransition = paramFixed.transitionTime/timeScaling;

        %% phase 1: warmup
        tDuration1 = 4*60/timeScaling;
        footSpeed1_phase1 = vNormal;
        footSpeed2_phase1 = vNormal;

        %% phase 2: baseline
        tDuration2 = 1*60/timeScaling;
        footSpeed1_phase2 = vNormal;
        footSpeed2_phase2 = vNormal;

        %% phase 3: adaptation
        tDuration3 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase3 = vFast;
        footSpeed2_phase3 = vFast;

        %% initialization
        tStore = [0; tDuration1; tDuration2; tDuration3];
        tStore = cumsum(tStore);

        footSpeed1Store = [footSpeed1_phase1; footSpeed1_phase1; ...
            footSpeed1_phase2; footSpeed1_phase3];
        footSpeed2Store = [footSpeed2_phase1; footSpeed2_phase1; ...
            footSpeed2_phase2; footSpeed2_phase3];


    case 'two speed changes'

        %% transitioning from one speed to next takes 10 seconds, say
        tDurationTransition = paramFixed.transitionTime/timeScaling;

        %% phase 1: warmup
        tDuration1 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase1 = vNormal;
        footSpeed2_phase1 = vNormal;

        %% phase 2: baseline
        tDuration2 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase2 = vFast;
        footSpeed2_phase2 = vFast;

        %% phase 3: adaptation
        tDuration3 = timePerPhaseInMin*60/timeScaling; % default is 20
        footSpeed1_phase3 = vNormal; % faster
        footSpeed2_phase3 = vNormal; % slower

        %% phase 4: post-adaptation
        tDuration4 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase4 = vSlow;
        footSpeed2_phase4 = vSlow;

        %% phase 5: normal again
        tDuration5 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase5 = vNormal;
        footSpeed2_phase5 = vNormal;

        %% initialization
        tStore = [0; tDuration1; tDuration2; tDuration3; tDuration4; tDuration5];
        tStore = cumsum(tStore);

        footSpeed1Store = [footSpeed1_phase1; footSpeed1_phase1; ...
            footSpeed1_phase2; footSpeed1_phase3; footSpeed1_phase4; footSpeed1_phase5];
        footSpeed2Store = [footSpeed2_phase1; footSpeed2_phase1; ...
            footSpeed2_phase2; footSpeed2_phase3; footSpeed2_phase4; footSpeed2_phase5];

    case 'tied four speed changes pagliara'

        %% transitioning from one speed to next takes 10 seconds, say
        tDurationTransition = paramFixed.transitionTime/timeScaling;

        %% phase 1: warmup
        tDuration1 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase1 = vNormal;
        footSpeed2_phase1 = vNormal;

        %% phase 2: baseline
        tDuration2 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase2 = vSlow;
        footSpeed2_phase2 = vSlow;

        %% phase 3: adaptation
        tDuration3 = timePerPhaseInMin*60/timeScaling; % default is 20
        footSpeed1_phase3 = vNormal; % faster
        footSpeed2_phase3 = vNormal; % slower

        %% phase 4: post-adaptation
        tDuration4 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase4 = vFast;
        footSpeed2_phase4 = vFast;

        %% phase 5: normal again
        tDuration5 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase5 = vNormal;
        footSpeed2_phase5 = vNormal;

        %% phase 6: normal again
        tDuration6 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase6 = vVeryFast;
        footSpeed2_phase6 = vVeryFast;

        %% phase 7: normal again
        tDuration7 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase7 = vNormal;
        footSpeed2_phase7 = vNormal;

        %% phase 8: normal again
        tDuration8 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase8 = vVerySlow;
        footSpeed2_phase8 = vVerySlow;

        %% phase 9: normal again
        tDuration9 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase9 = vNormal;
        footSpeed2_phase9 = vNormal;

        %% initialization
        tStore = [0; tDuration1; tDuration2; tDuration3; tDuration4; tDuration5; ...
            tDuration6; tDuration7; tDuration8; tDuration9];
        tStore = cumsum(tStore);

        footSpeed1Store = [footSpeed1_phase1; footSpeed1_phase1; ...
            footSpeed1_phase2; footSpeed1_phase3; footSpeed1_phase4; footSpeed1_phase5; ...
            footSpeed1_phase6; footSpeed1_phase7; footSpeed1_phase8; footSpeed1_phase9];
        footSpeed2Store = [footSpeed2_phase1; footSpeed2_phase1; ...
            footSpeed2_phase2; footSpeed2_phase3; footSpeed2_phase4; footSpeed2_phase5;
            footSpeed2_phase6; footSpeed2_phase7; footSpeed2_phase8; footSpeed2_phase9];

    case 'four speed changes 1' % official pagliara sequence?

        %% transitioning from one speed to next takes 10 seconds, say
        tDurationTransition = paramFixed.transitionTime/timeScaling;

        %% phase 1: warmup
        tDuration1 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase1 = vNormal;
        footSpeed2_phase1 = vNormal;

        %% phase 2: baseline
        tDuration2 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase2 = vFast;
        footSpeed2_phase2 = vFast;

        %% phase 3: adaptation
        tDuration3 = timePerPhaseInMin*60/timeScaling; % default is 20
        footSpeed1_phase3 = vNormal; % faster
        footSpeed2_phase3 = vNormal; % slower

        %% phase 4: post-adaptation
        tDuration4 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase4 = vSlow;
        footSpeed2_phase4 = vSlow;

        %% phase 5: normal again
        tDuration5 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase5 = vNormal;
        footSpeed2_phase5 = vNormal;

        %% phase 6: normal again
        tDuration6 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase6 = vVerySlow;
        footSpeed2_phase6 = vVerySlow;

        %% phase 7: normal again
        tDuration7 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase7 = vNormal;
        footSpeed2_phase7 = vNormal;

        %% phase 8: normal again
        tDuration8 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase8 = vVeryFast;
        footSpeed2_phase8 = vVeryFast;

        %% phase 9: normal again
        tDuration9 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase9 = vNormal;
        footSpeed2_phase9 = vNormal;

        %% initialization
        tStore = [0; tDuration1; tDuration2; tDuration3; tDuration4; tDuration5; ...
            tDuration6; tDuration7; tDuration8; tDuration9];
        tStore = cumsum(tStore);

        footSpeed1Store = [footSpeed1_phase1; footSpeed1_phase1; ...
            footSpeed1_phase2; footSpeed1_phase3; footSpeed1_phase4; footSpeed1_phase5; ...
            footSpeed1_phase6; footSpeed1_phase7; footSpeed1_phase8; footSpeed1_phase9];
        footSpeed2Store = [footSpeed2_phase1; footSpeed2_phase1; ...
            footSpeed2_phase2; footSpeed2_phase3; footSpeed2_phase4; footSpeed2_phase5;
            footSpeed2_phase6; footSpeed2_phase7; footSpeed2_phase8; footSpeed2_phase9];

    case 'four speed changes 2'

        %% transitioning from one speed to next takes 10 seconds, say
        tDurationTransition = paramFixed.transitionTime/timeScaling;

        %% phase 1: warmup
        tDuration1 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase1 = vNormal;
        footSpeed2_phase1 = vNormal;

        %% phase 2: baseline
        tDuration2 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase2 = vVerySlow;
        footSpeed2_phase2 = vVerySlow;

        %% phase 3: adaptation
        tDuration3 = timePerPhaseInMin*60/timeScaling; % default is 20
        footSpeed1_phase3 = vNormal; % faster
        footSpeed2_phase3 = vNormal; % slower

        %% phase 4: post-adaptation
        tDuration4 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase4 = vFast;
        footSpeed2_phase4 = vFast;

        %% phase 5: normal again
        tDuration5 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase5 = vNormal;
        footSpeed2_phase5 = vNormal;

        %% phase 6: normal again
        tDuration6 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase6 = vSlow;
        footSpeed2_phase6 = vSlow;

        %% phase 7: normal again
        tDuration7 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase7 = vNormal;
        footSpeed2_phase7 = vNormal;

        %% phase 8: normal again
        tDuration8 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase8 = vVeryFast;
        footSpeed2_phase8 = vVeryFast;

        %% phase 9: normal again
        tDuration9 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase9 = vNormal;
        footSpeed2_phase9 = vNormal;

        %% initialization
        tStore = [0; tDuration1; tDuration2; tDuration3; tDuration4; tDuration5; ...
            tDuration6; tDuration7; tDuration8; tDuration9];
        tStore = cumsum(tStore);

        footSpeed1Store = [footSpeed1_phase1; footSpeed1_phase1; ...
            footSpeed1_phase2; footSpeed1_phase3; footSpeed1_phase4; footSpeed1_phase5; ...
            footSpeed1_phase6; footSpeed1_phase7; footSpeed1_phase8; footSpeed1_phase9];
        footSpeed2Store = [footSpeed2_phase1; footSpeed2_phase1; ...
            footSpeed2_phase2; footSpeed2_phase3; footSpeed2_phase4; footSpeed2_phase5;
            footSpeed2_phase6; footSpeed2_phase7; footSpeed2_phase8; footSpeed2_phase9];

    case 'four speed changes 3'

        %% transitioning from one speed to next takes 10 seconds, say
        tDurationTransition = paramFixed.transitionTime/timeScaling;

        %% phase 1: warmup
        tDuration1 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase1 = vNormal;
        footSpeed2_phase1 = vNormal;

        %% phase 2: baseline
        tDuration2 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase2 = vVeryFast;
        footSpeed2_phase2 = vVeryFast;

        %% phase 3: adaptation
        tDuration3 = timePerPhaseInMin*60/timeScaling; % default is 20
        footSpeed1_phase3 = vNormal; % faster
        footSpeed2_phase3 = vNormal; % slower

        %% phase 4: post-adaptation
        tDuration4 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase4 = vFast;
        footSpeed2_phase4 = vFast;

        %% phase 5: normal again
        tDuration5 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase5 = vNormal;
        footSpeed2_phase5 = vNormal;

        %% phase 6: normal again
        tDuration6 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase6 = vVerySlow;
        footSpeed2_phase6 = vVerySlow;

        %% phase 7: normal again
        tDuration7 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase7 = vNormal;
        footSpeed2_phase7 = vNormal;

        %% phase 8: normal again
        tDuration8 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase8 = vSlow;
        footSpeed2_phase8 = vSlow;

        %% phase 9: normal again
        tDuration9 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase9 = vNormal;
        footSpeed2_phase9 = vNormal;

        %% initialization
        tStore = [0; tDuration1; tDuration2; tDuration3; tDuration4; tDuration5; ...
            tDuration6; tDuration7; tDuration8; tDuration9];
        tStore = cumsum(tStore);

        footSpeed1Store = [footSpeed1_phase1; footSpeed1_phase1; ...
            footSpeed1_phase2; footSpeed1_phase3; footSpeed1_phase4; footSpeed1_phase5; ...
            footSpeed1_phase6; footSpeed1_phase7; footSpeed1_phase8; footSpeed1_phase9];
        footSpeed2Store = [footSpeed2_phase1; footSpeed2_phase1; ...
            footSpeed2_phase2; footSpeed2_phase3; footSpeed2_phase4; footSpeed2_phase5;
            footSpeed2_phase6; footSpeed2_phase7; footSpeed2_phase8; footSpeed2_phase9];


    case 'four speed changes 4'

        %% transitioning from one speed to next takes 10 seconds, say
        tDurationTransition = paramFixed.transitionTime/timeScaling;

        %% phase 1: warmup
        tDuration1 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase1 = vNormal;
        footSpeed2_phase1 = vNormal;

        %% phase 2: baseline
        tDuration2 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase2 = vFast;
        footSpeed2_phase2 = vFast;

        %% phase 3: adaptation
        tDuration3 = timePerPhaseInMin*60/timeScaling; % default is 20
        footSpeed1_phase3 = vNormal; % faster
        footSpeed2_phase3 = vNormal; % slower

        %% phase 4: post-adaptation
        tDuration4 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase4 = vVerySlow;
        footSpeed2_phase4 = vVerySlow;

        %% phase 5: normal again
        tDuration5 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase5 = vNormal;
        footSpeed2_phase5 = vNormal;

        %% phase 6: normal again
        tDuration6 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase6 = vVeryFast;
        footSpeed2_phase6 = vVeryFast;

        %% phase 7: normal again
        tDuration7 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase7 = vNormal;
        footSpeed2_phase7 = vNormal;

        %% phase 8: normal again
        tDuration8 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase8 = vSlow;
        footSpeed2_phase8 = vSlow;

        %% phase 9: normal again
        tDuration9 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase9 = vNormal;
        footSpeed2_phase9 = vNormal;

        %% initialization
        tStore = [0; tDuration1; tDuration2; tDuration3; tDuration4; tDuration5; ...
            tDuration6; tDuration7; tDuration8; tDuration9];
        tStore = cumsum(tStore);

        footSpeed1Store = [footSpeed1_phase1; footSpeed1_phase1; ...
            footSpeed1_phase2; footSpeed1_phase3; footSpeed1_phase4; footSpeed1_phase5; ...
            footSpeed1_phase6; footSpeed1_phase7; footSpeed1_phase8; footSpeed1_phase9];
        footSpeed2Store = [footSpeed2_phase1; footSpeed2_phase1; ...
            footSpeed2_phase2; footSpeed2_phase3; footSpeed2_phase4; footSpeed2_phase5;
            footSpeed2_phase6; footSpeed2_phase7; footSpeed2_phase8; footSpeed2_phase9];

    case 'four speed changes 5'

        %% transitioning from one speed to next takes 10 seconds, say
        tDurationTransition = paramFixed.transitionTime/timeScaling;

        %% phase 1: warmup
        tDuration1 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase1 = vNormal;
        footSpeed2_phase1 = vNormal;

        %% phase 2: baseline
        tDuration2 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase2 = vVerySlow;
        footSpeed2_phase2 = vVerySlow;

        %% phase 3: adaptation
        tDuration3 = timePerPhaseInMin*60/timeScaling; % default is 20
        footSpeed1_phase3 = vNormal; % faster
        footSpeed2_phase3 = vNormal; % slower

        %% phase 4: post-adaptation
        tDuration4 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase4 = vVeryFast;
        footSpeed2_phase4 = vVeryFast;

        %% phase 5: normal again
        tDuration5 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase5 = vNormal;
        footSpeed2_phase5 = vNormal;

        %% phase 6: normal again
        tDuration6 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase6 = vFast;
        footSpeed2_phase6 = vFast;

        %% phase 7: normal again
        tDuration7 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase7 = vNormal;
        footSpeed2_phase7 = vNormal;

        %% phase 8: normal again
        tDuration8 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase8 = vSlow;
        footSpeed2_phase8 = vSlow;

        %% phase 9: normal again
        tDuration9 = timePerPhaseInMin*60/timeScaling;
        footSpeed1_phase9 = vNormal;
        footSpeed2_phase9 = vNormal;

        %% initialization
        tStore = [0; tDuration1; tDuration2; tDuration3; tDuration4; tDuration5; ...
            tDuration6; tDuration7; tDuration8; tDuration9];
        tStore = cumsum(tStore);

        footSpeed1Store = [footSpeed1_phase1; footSpeed1_phase1; ...
            footSpeed1_phase2; footSpeed1_phase3; footSpeed1_phase4; footSpeed1_phase5; ...
            footSpeed1_phase6; footSpeed1_phase7; footSpeed1_phase8; footSpeed1_phase9];
        footSpeed2Store = [footSpeed2_phase1; footSpeed2_phase1; ...
            footSpeed2_phase2; footSpeed2_phase3; footSpeed2_phase4; footSpeed2_phase5;
            footSpeed2_phase6; footSpeed2_phase7; footSpeed2_phase8; footSpeed2_phase9];


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
% figure(2555);
% plot(tStore_new,abs(footSpeed1Store_new),'linewidth',2); hold on;
% plot(tStore_new,abs(footSpeed2Store_new),'linewidth',2);
% xlabel('t'); ylabel('treadmill speeds(m/s)');
% legend('(abs) fast belt','(abs) slow belt');
% ylim([0 0.6]);
% title('Tied belt speed change protocol');

%% store in a structure
beltSpeedsImposed.tList = tStore_new;
beltSpeedsImposed.footSpeed1List = footSpeed1Store_new;
beltSpeedsImposed.footSpeed2List = footSpeed2Store_new;

%%
a1List = ...
    diff(beltSpeedsImposed.footSpeed1List)./diff(beltSpeedsImposed.tList);
a2List = ...
    diff(beltSpeedsImposed.footSpeed2List)./diff(beltSpeedsImposed.tList);

a1List = [a1List; 0]; a2List = [a2List; 0];

%%
beltSpeedsImposed.footAcc1List = a1List;
beltSpeedsImposed.footAcc2List = a2List;

end