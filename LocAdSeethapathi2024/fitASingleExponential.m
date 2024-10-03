function pResult = fitASingleExponential(tData,yData)

numAttempts = 4;

%%
for iAttempt = 1:numAttempts

    pInput0 = randn(3,1); pInput0(1) = yData(1); pInput0(3) = -4;
    options = optimset('display','none','MaxFunEvals',2000);
    [pResult,fVal] = fminunc(@fMSE,pInput0,options,tData,yData);
    
    pResultStore{iAttempt} = pResult;
    fValStore(iAttempt) = fVal;

    %%
    figure(3001);
    tDataScaled = tData/max(tData);
    plot(tDataScaled,yData,'o');
    hold on;

    a0 = pResult(1);
    a1 = pResult(2);
    a2 = pResult(3);

    yPredicted = a0 + a1*exp(a2*tDataScaled);

    hold on;
    plot(tDataScaled,yPredicted);

%     maxTList(iAttempt) = max(tData);
    
%     pause; hold on; % close(300);

end

[~,iMax] = min(fValStore);
pResult = pResultStore{iMax};

%% undo the time-scaling
pResult(3) = pResult(3)/max(tData);

% pause

end

%%

function f = fMSE(pInput,tData,yData)

a0 = pInput(1);
a1 = pInput(2);
a2 = pInput(3);

tDataScaled = tData/max(tData);

yPredicted = a0 + a1*exp(a2*tDataScaled);

f = mean((yData-yPredicted).^2);

end