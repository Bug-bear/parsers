% compare performance of 9 different alpha values

%[C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16]=textread('out_lkl', '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
%ALPHA=0.1; GAMMA=0.2;

%[C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16]=textread('out_flat', '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
%ALPHA=0.2; GAMMA=0.2;

[C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16]=textread('out_mal', '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
ALPHA=0.3; GAMMA=0.1;

CH = [C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16];
[m,n]=size(CH);
HSAMPLE=41; %based on existing knowledge

%{
%%%%% test plot %%%%%
forecast=SES(CH,0.5);
%plot(CH(:,6));hold all
%plot(forecast(:,6));
newFt = smoothts(CH,'e',0.5);

tempCH=CH(3:end,1:end); % time-shift
%tempCH2=CH(2:end,1:end);
tempFT1=forecast(2:end-1,1:end);
tempFT2=newFt(2:end-1,1:end);
plot(tempCH(:,6));hold all
%plot(tempCH2(:,6));hold all
plot(tempFT1(:,6));hold all
%plot(tempFT2(:,6));
%}


%%%%% plot %%%%%
%{
for i=1:10
    forecast = ses(CH,0.1*i);
    %subplot(5,2,i);
    plot(forecast(:,6))
end
%}

% initialise report holder (Num of alphas, Num of channels)
mape=zeros(1,n); 
mse=zeros(1,n); 
rmse=zeros(1,n); 

%{
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% test simple exponential %%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars avgMape avgMse avgRmse

tempCH=CH(3:end,1:end); % time-shift
    forecast=ses(CH,ALPHA); % simple exponential
    tempFT=forecast(2:end-1,1:end); % chop off last one (redundant)
    [mape(1,:) mse(1,:) rmse(1,:)] = ERRORS(tempFT,tempCH);
%}

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% test seasonal exponential %%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% (only work with out-of-sample)%%%%%
clearvars tempCH forecast avgMape avgMse avgRmse

p = 24*HSAMPLE; % 1st day of probe period for S
tempCH=CH(p+2:end,1:end); % time-shift
        forecast=winter(CH,p, ALPHA, GAMMA); % seasonal exponential
        tempFT=forecast(p+1:end-1,1:end); % chop off last one (redundant)
        [mape(1,:) mse(1,:) rmse(1,:)] = ERRORS(tempFT,tempCH);


        
        
avgMape = mean(mape');
avgMse = mean(mse');
avgRmse = mean(rmse');
%[R,C] = find(avgRmse==min(min(avgRmse)))


%{
plot(tempCH(:,6))
hold all
tempFT=forecast(p+1:end-1,1:end); % chop off last one (redundant)
plot(tempFT(:,6))
%}