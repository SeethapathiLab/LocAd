function beltSpeedsImposed = makeTreadmillSpeed_Roemmich2015(paramFixed)


L = 0.95; g = 9.81;
timeScaling = sqrt(L/g);
tDurationTransitionInMin = paramFixed.transitionTime/timeScaling/60;

vNormal = -0.25; vFast = -0.50;

paramFixed.baseDuration = 10;
paramFixed.shortDuration = 2.5;
paramFixed.tiedDuration = paramFixed.baseDuration/2;

initialDuration = 2;
baseDuration = paramFixed.baseDuration;
shortDuration = paramFixed.shortDuration;
tiedDuration = paramFixed.tiedDuration;

%%
switch paramFixed.speedProtocol
    case 'split roemmich2015 abrupt'
        
        tStore = [0; initialDuration; initialDuration+tDurationTransitionInMin; initialDuration+baseDuration; initialDuration+baseDuration+tDurationTransitionInMin; ...
            initialDuration+baseDuration+tiedDuration; initialDuration+baseDuration+tiedDuration+tDurationTransitionInMin; initialDuration+baseDuration+tiedDuration+baseDuration]*60/timeScaling;
        
        footSpeed1Store = [vNormal; vNormal; vFast; vFast; vNormal; vNormal; vFast; vFast];
        footSpeed2Store = vNormal*ones(size(tStore));
        
    case 'split roemmich2015 gradual'
        
        tStore = [0; initialDuration; initialDuration+baseDuration; initialDuration+baseDuration+tDurationTransitionInMin; ...
            initialDuration+baseDuration+tiedDuration; initialDuration+baseDuration+tiedDuration+tDurationTransitionInMin; initialDuration+baseDuration+tiedDuration+baseDuration]*60/timeScaling;
        
        footSpeed1Store = [vNormal; vNormal; vFast; vNormal; vNormal; vFast; vFast];
        footSpeed2Store = vNormal*ones(size(tStore));
        
    case 'split roemmich2015 gradual washout'
        
        tStore = [0; initialDuration; initialDuration+tDurationTransitionInMin; initialDuration+baseDuration; initialDuration+baseDuration+tiedDuration; ...
            initialDuration+baseDuration+tiedDuration+tDurationTransitionInMin; initialDuration+baseDuration+tiedDuration+baseDuration]*60/timeScaling;
        
        footSpeed1Store = [vNormal; vNormal; vFast; vFast; vNormal; vFast; vFast];
        footSpeed2Store = vNormal*ones(size(tStore));
        
    case 'split roemmich2015 extended gradual'
        
        tStore = [0; initialDuration; initialDuration+baseDuration; initialDuration+baseDuration+baseDuration; initialDuration+baseDuration+baseDuration+tDurationTransitionInMin; ...
            initialDuration+baseDuration+baseDuration+tiedDuration; initialDuration+baseDuration+baseDuration+tiedDuration+tDurationTransitionInMin; ...
            initialDuration+baseDuration+baseDuration+tiedDuration+baseDuration]*60/timeScaling;
        
        footSpeed1Store = [vNormal; vNormal; vFast; vFast; vNormal; vNormal; vFast; vFast];
        footSpeed2Store = vNormal*ones(size(tStore));
        
    case 'split roemmich2015 short abrupt'
        
        tStore = [0; initialDuration; initialDuration+tDurationTransitionInMin; initialDuration+shortDuration; initialDuration+shortDuration+tDurationTransitionInMin; initialDuration+shortDuration+tiedDuration; ...
            initialDuration+shortDuration+tiedDuration+tDurationTransitionInMin; initialDuration+shortDuration+tiedDuration+baseDuration]*60/timeScaling;
        
        footSpeed1Store = [vNormal; vNormal; vFast; vFast; vNormal; vNormal; vFast; vFast];
        footSpeed2Store = vNormal*ones(size(tStore));
        
end

% %% adding transition phases
% tStore_new = 0;
% footSpeed1Store_new = footSpeed1Store(1);
% footSpeed2Store_new = footSpeed2Store(1);
% 
% for iTran = 2:length(tStore)
%     if iTran<length(tStore)
%         tStore_new = [tStore_new; tStore(iTran); ...
%             tStore(iTran)+tTran];
%         footSpeed1Store_new = [footSpeed1Store_new; footSpeed1Store(iTran); footSpeed1Store(iTran+1)];
%         footSpeed2Store_new = [footSpeed2Store_new; footSpeed2Store(iTran); footSpeed2Store(iTran+1)];
%     else
%         tStore_new = [tStore_new; tStore(iTran)];
%         footSpeed1Store_new = [footSpeed1Store_new; footSpeed1Store(iTran)];
%         footSpeed2Store_new = [footSpeed2Store_new; footSpeed2Store(iTran)];
%     end
% end

%% plot the things
figure(2555);
plot(tStore,abs(footSpeed1Store),'linewidth',2); hold on;
plot(tStore,abs(footSpeed2Store),'linewidth',2);
xlabel('t'); ylabel('treadmill speeds(m/s)');
legend('(abs) fast belt','(abs) slow belt');
ylim([0 0.75]);

%% store in a structure
beltSpeedsImposed.tList = tStore;
beltSpeedsImposed.footSpeed1List = footSpeed1Store;
beltSpeedsImposed.footSpeed2List = footSpeed2Store;

a1List = ...
    diff(beltSpeedsImposed.footSpeed1List)./diff(beltSpeedsImposed.tList);
a2List = ...
    diff(beltSpeedsImposed.footSpeed2List)./diff(beltSpeedsImposed.tList);

a1List = [a1List; 0]; a2List = [a2List; 0];

%%  
beltSpeedsImposed.footAcc1List = a1List;
beltSpeedsImposed.footAcc2List = a2List;


end