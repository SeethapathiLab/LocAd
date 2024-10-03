function postProcessHelper_JustThePlots(stateVar0,tStore,stateStore, ...
    EmetStore,EmetPerTimeStore,tStepStore,paramFixed,doAnimate, ...
    EdotStore_IterationAverage, ...
    tTotalIterationStore,EdotPureEnergyStore)
% this program makes the plots/figures

%% do post-processing and plotting of things
% tend = 0;
paramFixed.numSteps = length(EmetStore);
for iStep = 1:paramFixed.numSteps
    thetaList = stateStore{iStep}(:,1);

    yBodyList_inFootFrame = paramFixed.leglength*sin(thetaList+paramFixed.angleSlope);
    zBodyList_inSlopeFrame = paramFixed.leglength*cos(thetaList+paramFixed.angleSlope);

    if rem(iStep,2)==0
        s1 = 'r';
    else
        s1 = 'b';
    end
end

%% getting things in the lab frame
for iStep = 1:paramFixed.numSteps
    yFootStanceList{iStep} = stateStore{iStep}(:,3);
end

%% getting a interpolated swing foot trajectory, from stance foot to stance foot
% just for visualization purposes

for iStep = 1:paramFixed.numSteps

    if (iStep<=1)||(iStep>=paramFixed.numSteps)

        % no swing foot info for the first step and thee last step
        % or we can just choose to animate steps from 2 to end-1
        yFootSwingList{iStep} = NaN*ones(size(tStore{iStep}));
        zFootSwingList{iStep} = NaN*ones(size(tStore{iStep}));

    else

        % end of last stance is beginning of current swing
        % begin of next stance is end of current swing
        swingFootBegin = yFootStanceList{iStep-1}(end);
        swingFootEnd = yFootStanceList{iStep+1}(1);

        % interpolating swing foot, constant velocity over the whole distance
        yFootSwingList{iStep} = interp1([tStore{iStep}(1) tStore{iStep}(end)],[swingFootBegin swingFootEnd],tStore{iStep});

        % interpolating swing foot, beginning and ending at rest
        %         % achieved using a shifted cosine
        %         Atemp = (swingFootBegin-swingFootEnd)/2; % amplitude of the necessary cosine
        %         Amean = (swingFootEnd+swingFootBegin)/2; % mean of necessary cosine
        %         Tswing = (tStore{iStep}(end)-tStore{iStep}(1));
        %         yFootSwingList{iStep} = Amean+Atemp*cos(2*pi*(tStore{iStep}-tStore{iStep}(1))/(2*Tswing));
        % okay the above interpolation is NOT good, because we want the foot to
        % have belt speed at beginning and end, not zero speed!! perhaps a
        % polynomial fit is best

        % vertical foot excursion
        footHeight = 0.03;
        Amean = (0+footHeight)/2;
        Atemp = (0-footHeight)/2;
        Tswing = (tStore{iStep}(end)-tStore{iStep}(1));
        zFootSwingList{iStep} = Amean+Atemp*cos(2*pi*(tStore{iStep}-tStore{iStep}(1))/(Tswing));

    end

    thetaList = stateStore{iStep}(:,1);
    yBodyList_inFootFrame = paramFixed.leglength*sin(thetaList+paramFixed.angleSlope);
    zBodyList_inSlopeFrame = paramFixed.leglength*cos(thetaList); % z body

    yBodyList_inSlopeFrame = yBodyList_inFootFrame+yFootStanceList{iStep}; % y body in foot frame

    % fake knee position
    [ySwingKneeList{iStep},zSwingKneeList{iStep}] = ...
        kneeGivenBodyFoot(yBodyList_inSlopeFrame,zBodyList_inSlopeFrame,yFootSwingList{iStep},zFootSwingList{iStep});

end

%% step lengths, step length asymmetry, step time, step time asymmetry
tStanceList = zeros(paramFixed.numSteps,1);
stepLengthList = zeros(paramFixed.numSteps,1);
for iStep = 1:paramFixed.numSteps
    tStanceList(iStep) = range(tStore{iStep});
    %     theta_initial = stateStore{iStep}(1,1);
    theta_end = stateStore{iStep}(end,1); % last row, first column
    stepLengthList(iStep) = abs(2*paramFixed.leglength*sin(theta_end)); % now based on END theta of a step
end

% Note: the following assumes that the first belt is faster
tStance_fast = tStanceList(1:2:end); % stepping on to slow belt at the end: BEING on fast belt throughout
tStance_slow = tStanceList(2:2:end); % stepping on to fast belt at the end: BEING on slow belt throughout

stepTimeAsymmetryList = (tStance_slow-tStance_fast)./(tStance_slow+tStance_fast);
stepLength_slow = stepLengthList(1:2:end); % stepping on to slow belt at the end of odd steps: odd stances are on slow
stepLength_fast = stepLengthList(2:2:end); % stepping on to fast belt at the end of even steps: even stances are on slow
stepLengthAsymmetryList = (stepLength_fast-stepLength_slow)./(stepLength_fast+stepLength_slow);

%% put in a metabolic VO2 transient with a 40 sec time constant
params.tList = cumsum(tTotalIterationStore);
params.EmetRateList = EdotStore_IterationAverage;
[tSpan_Smoothed,EmetSList_Smoothed] = convertMetToVO2(params);
EmetSList_NotSmoothed = params.EmetRateList;
tList_NotSmoothed = params.tList;

skipPlot = 10;

if strcmp(paramFixed.SplitOrTied,'split')

    stepTimeAsymmetryList(1) = NaN;
    strideCountList = (1:length(stepTimeAsymmetryList))';

    figure(200);
    subplot(132); plot(strideCountList(2:skipPlot:end),stepLengthAsymmetryList(2:skipPlot:end),'-','linewidth',2); hold on;
    xlabel('stride index'); ylabel('step length symmetry');
    ylim([-0.3 0.3]); axis square;
    xlim([0 max(strideCountList)]);

    figure(200); hold on;
    subplot(133); strideList = (1:round(length(params.EmetRateList)))*paramFixed.Learner.numStepsPerIteration/2;
    plot(strideList(1:skipPlot:end),params.EmetRateList(1:skipPlot:end),'-'); hold on;
    plot(strideList(1:skipPlot:end),EmetSList_Smoothed(1:skipPlot:end),'linewidth',2);
    xlabel('stride index'); ylabel('Edot, met rate')
    legend([num2str(paramFixed.Learner.numStepsPerIteration) ' step average'],'Edot smoothed by VO2');
    ylim([0 max(params.EmetRateList)]); axis square;

    figure(200); hold on;
    subplot(131); [foot1SpeedList,foot2SpeedList] = getTreadmillSpeed(params.tList,paramFixed.imposedFootSpeeds);
    plot(params.tList(1:skipPlot:end),abs(foot1SpeedList(1:skipPlot:end)),'linewidth',2); hold on;
    plot(params.tList(1:skipPlot:end),abs(foot2SpeedList(1:skipPlot:end)),'linewidth',2); ylim([0.3 0.5]); axis square;
    xlim([0 (max(params.tList))]);
    % set(gcf,'WindowState','fullscreen');
    set(gca, 'xticklabel', []);
    xlabel('time');
    ylabel('treadmill belt speeds');
    legend('fast belt','slow belt');
    ylim([0 0.6]);

    % save the figure in the correct folder
    figDir = '/Users/manojsrinivasan2021/Dropbox/NidhiMLabResearch_M/SplitBeltAdaptation_Consolidated/programsJuly2024/FinalFigures/MATLABfiguresAndOriginalEPS/';
    savefig([figDir paramFixed.runType '.fig']);
    saveas(gcf,[figDir paramFixed.runType '.eps'],'eps');
    variablesToStore = {'stepLengthAsymmetryList','strideList','EmetSList_NotSmoothed','EmetSList_Smoothed', ...
        'tList_NotSmoothed','foot1SpeedList','foot2SpeedList'};
    for iVar = 1:length(variablesToStore)
        save([figDir 'Dat_' paramFixed.runType '_' variablesToStore{iVar} '.txt'],variablesToStore{iVar},'-ascii');
    end
    save([figDir 'Dat_' paramFixed.runType '.mat']);
end

if strcmp(paramFixed.SplitOrTied,'tied')
    figure(201); subplot(131); hold on;
    [foot1SpeedList,foot2SpeedList] = getTreadmillSpeed(params.tList,paramFixed.imposedFootSpeeds);
    plot(params.tList(1:skipPlot:end),abs(foot1SpeedList(1:skipPlot:end)),'linewidth',2); hold on;
    plot(params.tList(1:skipPlot:end),abs(foot2SpeedList(1:skipPlot:end)),'linewidth',2); ylim([0.3 0.5]); axis square;
    xlim([0 (max(params.tList))]);
    % set(gcf,'WindowState','fullscreen');
    set(gca, 'xticklabel', []);
    xlabel('time');
    ylabel('treadmill belt speeds');
    legend('fast belt','slow belt');
    ylim([0 0.6]);
    axis square;

    figure(201); subplot(132); hold on;
    tStancePerStride = (tStance_fast+tStance_slow);
    tList_stepBegin = cumsum(tStanceList);
    strideFrequencyList = 1./tStancePerStride(2:end)
    plot(tList_stepBegin(3:2:end),strideFrequencyList);
    xlabel('time (non dim)'); ylabel('step freq, averaged over 2 steps');
    ylim([0 0.8]); axis square;

    sgtitle('Tied Treadmill: Stride frequency changes');

      subplot(133); strideList = (1:round(length(params.EmetRateList)))*paramFixed.Learner.numStepsPerIteration/2;
    plot(strideList(1:skipPlot:end),params.EmetRateList(1:skipPlot:end),'-'); hold on;
    plot(strideList(1:skipPlot:end),EmetSList_Smoothed(1:skipPlot:end),'linewidth',2);
    xlabel('stride index'); ylabel('Edot, met rate')
    legend([num2str(paramFixed.Learner.numStepsPerIteration) ' step average'],'Edot smoothed by VO2');
    ylim([0 max(params.EmetRateList)]); axis square;


    % save the figure in the correct folder
    figDir = '/Users/manojsrinivasan2021/Dropbox/NidhiMLabResearch_M/SplitBeltAdaptation_Consolidated/programsJuly2024/FinalFigures/MATLABfiguresAndOriginalEPS/';
    savefig([figDir paramFixed.runType '.fig']);
    saveas(gcf,[figDir paramFixed.runType '.eps'],'eps');
    variablesToStore = {'strideFrequencyList','tList_stepBegin','EmetSList_NotSmoothed','EmetSList_Smoothed', ...
        'tList_NotSmoothed','foot1SpeedList','foot2SpeedList'};
    for iVar = 1:length(variablesToStore)
        save([figDir 'Dat_' paramFixed.runType '_' variablesToStore{iVar} '.txt'],variablesToStore{iVar},'-ascii');
    end

end



%% do animation of the whole task, relative to the lab frame
if doAnimate

    figure(10);
    yGround = -2:0.5:20;
    yGround = [yGround; yGround-0.35];
    zGround = zeros(size(yGround));

    for iStep = 1:paramFixed.numSteps

        thetaList = stateStore{iStep}(:,1);
        yBodyList_inFootFrame = paramFixed.leglength*sin(thetaList+paramFixed.angleSlope);
        zBodyList_inSlopeFrame = paramFixed.leglength*cos(thetaList+paramFixed.angleSlope); % z body
        yBodyList_inSlopeFrame = yBodyList_inFootFrame + yFootStanceList{iStep};

        calpha = cos(paramFixed.angleSlope);
        salpha = sin(paramFixed.angleSlope);
        yBodyList_inGroundFrame = ...
            calpha*yBodyList_inSlopeFrame-salpha*zBodyList_inSlopeFrame;
        zBodyList_inGroundFrame = ...
            +salpha*yBodyList_inSlopeFrame+calpha*zBodyList_inSlopeFrame;

        yFootStanceList_inGroundFrame = calpha*yFootStanceList{iStep};
        zFootStanceList_inGroundFrame = salpha*yFootStanceList{iStep};

        yFootSwingList_inGroundFrame = ...
            calpha*yFootSwingList{iStep}-salpha*zFootSwingList{iStep};
        zFootSwingList_inGroundFrame = ...
            salpha*yFootSwingList{iStep}+calpha*zFootSwingList{iStep};

        ySwingKneeList_inGroundFrame = ...
            calpha*ySwingKneeList{iStep}-salpha*zSwingKneeList{iStep};
        zSwingKneeList_inGroundFrame = ...
            salpha*ySwingKneeList{iStep}+calpha*zSwingKneeList{iStep};


        % each leg's color remains the same throughout animation, whether or not
        % there is swing and stance
        if rem(iStep,2)==0
            s1 = [0.7 0.4 0.4];
            s2 = [0.4 0.4 0.7];
        else
            s1 = [0.4 0.4 0.7];
            s2 = [0.7 0.4 0.4];
        end

        % gives light swing legs. that is, the legs become lighter when they
        % are in swing phase. if you want this, uncomment the following
        %     if rem(iStep,2)==0
        %         s1 = [0.7 0.4 0.4];
        %         s2 = [0.8 0.8 1];
        %     else
        %         s1 = [0.4 0.4 0.7];
        %         s2 = [1 0.8 0.8];
        %     end

        for jFrame = 1:length(yBodyList_inFootFrame)-1
            % plot body
            plot(yBodyList_inGroundFrame(jFrame),zBodyList_inGroundFrame(jFrame),'o','markersize',15,'markerfacecolor',[0 0 0]); hold on;
            %         xlabel('t'); ylabel('\theta');

            % plot stance foot
            plot(yFootStanceList_inGroundFrame(jFrame),zFootStanceList_inGroundFrame(jFrame),'o','markersize',8,'markerfacecolor',s1,'markeredgecolor',s1);

            % plot stance leg
            plot([yFootStanceList_inGroundFrame(jFrame) yBodyList_inGroundFrame(jFrame)],[zFootStanceList_inGroundFrame(jFrame) zBodyList_inSlopeFrame(jFrame)],'color',s1,'linewidth',2);

            % plot stance knee
            plot(mean([yFootStanceList_inGroundFrame(jFrame) yBodyList_inGroundFrame(jFrame)]),mean([zFootStanceList_inGroundFrame(jFrame) zBodyList_inSlopeFrame(jFrame)]),'marker','o','markersize',8,'markerfacecolor',s1,'markeredgecolor',s1);

            % plot swing leg, this produces a straight line swing leg
            %         plot([yFootSwingList{iStep}(jFrame) yBodyList_inLabFrame(jFrame)],[zFootSwingList{iStep}(jFrame) zBodyList(jFrame)],'color',s2,'linewidth',2);

            % plot swing foot
            plot(yFootSwingList_inGroundFrame(jFrame),zFootSwingList_inGroundFrame(jFrame),'marker','o','markersize',8,'markerfacecolor',s2,'markeredgecolor',s2);

            % plot swing knee
            plot(ySwingKneeList_inGroundFrame(jFrame),zSwingKneeList_inGroundFrame(jFrame),'marker','o','markersize',8,'markerfacecolor',s2,'markeredgecolor',s2);

            % plot swing leg with knee
            plot([yFootSwingList_inGroundFrame(jFrame) ySwingKneeList_inGroundFrame(jFrame)],[zFootSwingList{iStep}(jFrame) zSwingKneeList{iStep}(jFrame)],'color',s2,'linewidth',2);
            plot([ySwingKneeList_inGroundFrame(jFrame) yBodyList_inGroundFrame(jFrame)],[zSwingKneeList{iStep}(jFrame) zBodyList_inSlopeFrame(jFrame)],'color',s2,'linewidth',2);

            paramFixed.foot1speed = 0;
            paramFixed.foot2speed = 0;

            % plot the treadmill belt
            yGround_Slope = yGround+tStore{iStep}(jFrame)*paramFixed.foot1speed;
            zGround_Slope = zGround;
            yGround_Ground = calpha*yGround_Slope-salpha*zGround_Slope;
            zGround_Ground = salpha*yGround_Slope+calpha*zGround_Slope;
            plot(yGround_Ground,zGround_Ground,'-','color',[0.8 0.8 1],'linewidth',2);
            plot([-2 2],[0 0]-0.5,'k-');

            % plot the treadmill belt
            yGround_Slope = yGround+tStore{iStep}(jFrame)*paramFixed.foot2speed;
            zGround_Slope = zGround-0.03;
            yGround_Ground = calpha*yGround_Slope-salpha*zGround_Slope;
            zGround_Ground = salpha*yGround_Slope+calpha*zGround_Slope;
            plot(yGround_Ground,zGround_Ground,'-','color',[1 0.8 0.8],'linewidth',2);

            axis equal;
            xlim([-2 2]); ylim([-1 2]);

            pause(0.001);
            hold off;
            drawnow;
            %         pause;

        end
        %     pause
    end

end


end % essential % we've made the doAnimate thing not generate the animation and
% removed the diagnostic plots. see older version for additional details.
