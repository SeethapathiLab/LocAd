clear; close all; clc;

figDir = '/Users/manojsrinivasan2021/Dropbox/NidhiMLabResearch_M/SplitBeltAdaptation_Consolidated/programsJuly2024/FinalFigures/MATLABfiguresAndOriginalEPS/';

fileList = {'Dat_figure4BasicSavingsProtocolTATADefaultMemoryV2Trial6', ...
    'Dat_figure4BasicSavingsProtocolTATADefaultMemoryV2Trial19', ...
    'Dat_figure4BasicSavingsProtocolTATADefaultMemoryV2Trial23', ...
    'Dat_figure4BasicSavingsProtocolTATADefaultMemoryV2Trial33', ...
    'Dat_figure4BasicSavingsProtocolTATADefaultMemoryV2Trial56', ...
    'Dat_figure4BasicSavingsProtocolTATADefaultMemoryV2Trial72', ...
    'Dat_figure4BasicSavingsProtocolTATADefaultMemoryV2Trial73', ...
    'Dat_figure4BasicSavingsProtocolTATADefaultMemoryV2Trial80', ...
    'Dat_figure4BasicSavingsProtocolTATADefaultMemoryV2Trial82', ...
    'Dat_figure4BasicSavingsProtocolTATADefaultMemoryV2Trial89'};

L = 0.95; g = 9.81;
timeScaling = sqrt(L/g);
speedScaling = sqrt(L*g);

tBegin_adapt1 = 10.6*60/timeScaling;
tEnd_adapt1 = 40*60/timeScaling;

tBegin_adapt2 = 60.6*60/timeScaling;
tEnd_adapt2 = 90*60/timeScaling;

%% adapt 1
timeConstantList1 = []; maxAsymmetryList1 = [];
for iFile = 1:length(fileList)
    load([figDir fileList{iFile}]);
    tData = tList_NotSmoothed';
    yData = stepLengthAsymmetryList;
    figure(1); plot(yData); pause(1);
    yData = yData((tData>tBegin_adapt1)&(tData<tEnd_adapt1));
    tData = tData((tData>tBegin_adapt1)&(tData<tEnd_adapt1));
    pResult = fitASingleExponential(tData,yData);
    timeConstantList1 = [timeConstantList1; -1/pResult(3)];
    maxAsymmetryList1 = [maxAsymmetryList1; -min(yData)];
%     pause
end

%% adapt 2
timeConstantList2 = []; maxAsymmetryList2 = [];
for iFile = 1:length(fileList)
    load([figDir fileList{iFile}]);
    tData = tList_NotSmoothed';
    yData = stepLengthAsymmetryList;
    yData = yData((tData>tBegin_adapt2)&(tData<tEnd_adapt2));
    tData = tData((tData>tBegin_adapt2)&(tData<tEnd_adapt2));
    pResult = fitASingleExponential(tData,yData);
    timeConstantList2 = [timeConstantList2; -1/pResult(3)];
    maxAsymmetryList2 = [maxAsymmetryList2; -min(yData)];
%     pause
end

%% statistics
[h1,p1] = ttest(maxAsymmetryList1,maxAsymmetryList2)
[h2,p2] = ttest(timeConstantList1,timeConstantList2)

%% plot 
figure;
boxplot([timeConstantList1,timeConstantList2]);
ylim([0 1500]);
xlabel('first and second adaptation');
ylabel('time constants (non-dim)');