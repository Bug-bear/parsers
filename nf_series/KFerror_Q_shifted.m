% invoke Kalman filter for sample of the specified channel and return
% square error

function [ error ] = KFerror_Q_shifted( Q,OBSERVED )
R=9; %based on cc2420 data sheet (would be 6.25 for GINA)
%{
[m,n]=size(OBSERVED);
Mu = mean(OBSERVED);
for i=1:m
    CON(i,:)=Mu;
end
%}

%SAMPLE = CH(:,1);
%q = 0.01 * Q; %scale the q
q=Q;
est = Kalman(OBSERVED, q, R);

tempCH = OBSERVED(3:end,1:end);         % 3rd to the end
%tempCH = T(3:end,1:end);         % 3rd to the end
tempFT = est(2:end-1,1:end); % 2nd(predicting 3rd sample) to end-1
%[mape mse rmse] = ERRORS(tempFT,tempCH); % prediction accuracy
%[mape mse rmse] = ERRORS(tempFT,CON); % assuming constant underlying model
%[mape mse rmse] = ERRORS(est,T); % non-shifted
[mape mse rmse] = ERRORS(tempFT,tempCH); % non-shifted
error = rmse;
%error = mape;
