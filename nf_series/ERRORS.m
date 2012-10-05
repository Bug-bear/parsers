%function [ meanError ] = MSE(fore,obse,testID,totalTest)
function [ mape, mse, rmse ] = ERRORS(fore,obse)
% mape: absolute percentage forecast error
% mse:  mean-square-error
% rmse: root-mean-square-error

% fore: forecast value
% obse: oberserved value
% testID: which (of the totalTest) test this is
% totalTest: how many test in total (in this case 10 for alpha from 0.1 to 1 )

[m,n] = size(fore);
sum_mape = zeros(1,n);
sum_mse = zeros(1,n);
sum_rmse = zeros(1,n);
mape = zeros(1,n);
mse = zeros(1,n);
rmse = zeros(1,n);

for j = 1:n
    for i = 1:m
       sum_mape(1,j) = sum_mape(1,j) + abs((fore(i,j)-obse(i,j))/obse(i,j));
       sum_mse(1,j) = sum_mse(1,j) + (abs(fore(i,j)-obse(i,j))).^2;
       sum_rmse(1,j) = sum_rmse(1,j) + sqrt((abs(fore(i,j)-obse(i,j))).^2);
    end
    
    mape(1,j) = sum_mape(1,j) / m;
    mse(1,j) = sum_mse(1,j) / m;
    rmse(1,j) = sum_rmse(1,j) / m;

end

end