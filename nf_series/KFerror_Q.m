% invoke Kalman filter for sample of the specified channel and return
% square error

function [ error ] = KFerror_Q( Q,OBSERVED,T )
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

[mape mse rmse] = ERRORS(est,T); % non-shifted
%[mape mse rmse] = ERRORS(tempFT,tempCH); % non-shifted
%error = rmse;
error = mape;
