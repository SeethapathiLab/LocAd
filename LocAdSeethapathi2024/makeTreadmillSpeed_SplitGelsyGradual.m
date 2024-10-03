function beltSpeedsImposed = makeTreadmillSpeed_SplitGelsyGradual(paramFixed)

L = 0.95; g = 9.81;
timeScaling = sqrt(L/g);


% v1
vNormal = -0.40;
vFast = -0.50;
vSlow = -0.30;

% v2
% vNormal = -0.40;
% vFast = -0.57;
% vSlow = -0.22;

% v3
% vNormal = -0.35;
% vFast = -0.525;
% vSlow = -0.175;


%% transitioning from one speed to next takes 10 seconds, say
tDurationTransition = paramFixed.transitionTime/timeScaling;

%% phase 1: warmup (tied)
tDuration1 = 2*60/timeScaling;
footSpeed1_phase1 = vNormal;
footSpeed2_phase1 = vNormal;

%% phase 2: baseline (tied)
tDuration2 = 2*60/timeScaling;
footSpeed1_phase2 = vNormal;
footSpeed2_phase2 = vNormal;

%% phase 3: split adaptation
tDuration3 = 10*60/timeScaling; % default is 20
footSpeed1_phase3 = vFast;
footSpeed2_phase3 = vSlow;

%% phase 4: second adaptation (back to tied)
tDuration4 = 3*60/timeScaling; % default is 20
footSpeed1_phase4 = vSlow;
footSpeed2_phase4 = vSlow;

%% phase 5: second adaptation (back to tied)
tDuration5 = 1*60/timeScaling; % default is 20
footSpeed1_phase5 = vSlow;
footSpeed2_phase5 = vSlow;

%% initialization
tStore = [0; tDuration1; tDuration2; tDuration3;  tDurationTransition; tDuration4; tDuration5];
tStore = cumsum(tStore);

footSpeed1Store = [footSpeed1_phase1; footSpeed1_phase1; ...
    footSpeed1_phase2; footSpeed1_phase3; footSpeed1_phase4; footSpeed1_phase5; footSpeed1_phase5];
footSpeed2Store = [footSpeed2_phase1; footSpeed2_phase1; ...
    footSpeed2_phase2; footSpeed2_phase3; footSpeed2_phase4; footSpeed1_phase5; footSpeed1_phase5];


%%
switch paramFixed.speedProtocol

    case 'splitgradualNoNoiseGelsy'

        tStore_new = tStore;
        footSpeed1Store_new = footSpeed1Store;
        footSpeed2Store_new = footSpeed2Store;

        %% plot the things
        figure(2555);
        plot(tStore_new,abs(footSpeed1Store_new),'linewidth',2); hold on;
        plot(tStore_new,abs(footSpeed2Store_new),'linewidth',2);
        xlabel('t'); ylabel('treadmill speeds (non-dimensional)');
        legend('(abs) fast belt','(abs) slow belt');
        ylim([0 abs(vFast)*1.25]);
        title('Split belt speed change protocol');

%         pause

    case 'splitgradualNoisyGelsy' % gradualnoisy_correlated

        tDelta = paramFixed.beltNoise_tDelta/timeScaling;
        tStore_replace = (tStore(3):tDelta:tStore(5))';
        if tStore_replace(end)~=tStore(5)
            tStore_replace(end) = tStore(5);
        end

        tStore_new = [tStore(1:2); tStore_replace; tStore(6:end)];
        footSpeed1Store_new = interp1(tStore,footSpeed1Store,tStore_new);
        footSpeed2Store_new = interp1(tStore,footSpeed2Store,tStore_new);
        std_beltnoise = paramFixed.beltNoise/sqrt(g*L);
        randSpeedFluctuations = std_beltnoise*randn(size(tStore_replace));
        randSpeedFluctuations(1:2) = 0;
        randSpeedFluctuations(end-1:end) = 0;
        NrandSpeedFluctuations = length(randSpeedFluctuations);

        footSpeed1Store_newer = footSpeed1Store_new;
        footSpeed1Store_newer(3:3+NrandSpeedFluctuations-1) = ...
            footSpeed1Store_new(3:3+NrandSpeedFluctuations-1) + ...
            randSpeedFluctuations;
        ratioNow = ...
            footSpeed2Store_new./footSpeed1Store_new;
        footSpeed2Store_newer = ...
            ratioNow.*footSpeed1Store_newer;

        footSpeed1Store_new = footSpeed1Store_newer;
        footSpeed2Store_new = footSpeed2Store_newer;

        %% plot the things
        figure(2555);
        plot(tStore_new,abs(footSpeed1Store_new),'linewidth',2); hold on;
        plot(tStore_new,abs(footSpeed2Store_new),'linewidth',2);
        xlabel('t'); ylabel('treadmill speeds (non-dimensional)');
        legend('(abs) fast belt','(abs) slow belt');
        ylim([0 abs(vFast)*1.25]);
        title('Split belt speed change protocol');

    case 'splitAbruptGelsy'

        %% transitioning from one speed to next takes 10 seconds, say
        tDurationTransition = paramFixed.transitionTime/timeScaling;

        %% phase 1: warmup (tied)
        tDuration1 = 2*60/timeScaling;
        footSpeed1_phase1 = vNormal;
        footSpeed2_phase1 = vNormal;

        %% phase 2: baseline (tied)
        tDuration2 = 2*60/timeScaling;
        footSpeed1_phase2 = vNormal;
        footSpeed2_phase2 = vNormal;

        %% phase 3: split adaptation
        tDuration3 = 10*60/timeScaling; % default is 20
        footSpeed1_phase3 = vFast;
        footSpeed2_phase3 = vSlow;

        %% phase 4: second adaptation (back to tied)
        tDuration4 = 4*60/timeScaling; % default is 20
        footSpeed1_phase4 = vSlow;
        footSpeed2_phase4 = vSlow;

        %% initialization
        tStore = [0; tDuration1; tDuration2; tDuration3; tDuration4];
        tStore = cumsum(tStore);

        footSpeed1Store = [footSpeed1_phase1; footSpeed1_phase1; ...
            footSpeed1_phase2; footSpeed1_phase3; footSpeed1_phase4];
        footSpeed2Store = [footSpeed2_phase1; footSpeed2_phase1; ...
            footSpeed2_phase2; footSpeed2_phase3; footSpeed2_phase4];

        
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
        xlabel('t'); ylabel('treadmill speeds (non-dimensional)');
        legend('(abs) fast belt','(abs) slow belt');
        ylim([0 abs(vFast)*1.25]);
        title('Split belt speed change protocol');

%         pause

end

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