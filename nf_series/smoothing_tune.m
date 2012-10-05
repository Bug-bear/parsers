% compare performance of 9 different alpha values
% compare forecast(i) with observation(i+1) because smoothing forecasts future,
% as opposed by Kalman filter which estimates current.

[C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16]=textread('lkl_6wks', '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
%HOURS=24*(7*4+4)+10; BEGIN=0; % duration of lkl_sample_1 (Wednesday 23:45)
HOURS=24*7*6; BEGIN=0; % duration of lkl_sample_1 (Wednesday 23:45)

%[C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16]=textread('flat_5wks', '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
%HOURS=24*7*5+6; BEGIN=9; % duration of flat_sample_5wks+ (Friday 09:00)

%[C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16]=textread('mal_6wks', '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
%HOURS=24*7*3+1; BEGIN=16; % duration of mal_sample_3wks (Friday 16:30)
%HOURS=24*7*6; BEGIN=16; % duration of mal_sample_6wks (Friday 16:30)

CH = [C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16];
[m,n]=size(CH);
HSAMPLE=round(m/HOURS);

clearvars perHour;
perHour=zeros(HOURS,16);
for j = 1:16
    clearvars DATA
    DATA = repmat(NaN,HSAMPLE,HOURS);
    S = CH(:,j);
    for i = 1:HOURS
        DATA(:,i) = S(1+(i-1)*HSAMPLE: min(m,i*HSAMPLE));
    end
    perHour(:,j)=mean(DATA); % get the hourly mean
end

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



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% test simple exponential %%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars avgMape avgMse avgRmse
% initialise report holder (Num of alphas, Num of channels)
mape=zeros(11,n); 
mse=zeros(11,n); 
rmse=zeros(11,n); 
%{
tempCH=CH(3:end,1:end); % time-shift
%tempCH=perHour(3:end,1:end);
for i=0:10
    forecast=ses(CH,0.1*i); % simple exponential
    %forecast=ses(perHour,0.1*i); % simple exponential
    %newFt = smoothts(CH,'e',0.1*i);
    tempFT=forecast(2:end-1,1:end); % chop off last one (redundant)
    %[mape(i,:) mse(i,:) rmse(i,:)] = ERRORS(tempFT,tempCH);
    [mape(i+1,:) mse(i+1,:) rmse(i+1,:)] = ERRORS(tempFT,tempCH);
end

avgMape = mean(mape');
avgMse = mean(mse');
avgRmse = mean(rmse');
%}


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% test seasonal exponential %%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% (only work with out-of-sample)%%%%%
clearvars forecast avgMape avgMse avgRmse
%%% holders for 9 alpha and 9 gamma %%%
%avgMape=zeros(9,9); 
%avgMse=zeros(9,9); 
%avgRmse=zeros(9,9); 
avgMape=zeros(11,11); 
avgMse=zeros(11,11); 
avgRmse=zeros(11,11); 

p = floor(24*m/(HOURS)); % 1st day of probe period for S
%p = 24; % for perHour data set
tempCH=CH(p+2:end,1:end); % time-shift
%tempCH=perHour(p+2:end,1:end); % for perHour data set
%for j=1:9
for j=0:10
    %for i=1:9
    for i=0:10
        forecast=winter(CH,HSAMPLE*24, 0.1*i,0.1*j); % seasonal exponential
        %forecast=winter(perHour,4, 0.1*i,0.1*j); % for perHour data set
        tempFT=forecast(p+1:end-1,1:end); % chop off last one (redundant)
        %[mape(i,:) mse(i,:) rmse(i,:)] = ERRORS(tempFT,tempCH);
        [mape(i+1,:) mse(i+1,:) rmse(i+1,:)] = ERRORS(tempFT,tempCH);
    end
    avgMape(j+1,:)=mean(mape');
    %avgRmse(j,:)=mean(rmse');
    avgRmse(j+1,:)=mean(rmse');
end


[R,C] = find(avgRmse==min(min(avgRmse)))


%{
plot(tempCH(:,6))
hold all
tempFT=forecast(p+1:end-1,1:end); % chop off last one (redundant)
plot(tempFT(:,6))
%}