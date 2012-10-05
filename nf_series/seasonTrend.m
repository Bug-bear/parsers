%% Analysis of noise seasonality and trend %%
% must set parameter "HOURS" for each sample

[C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16]=textread('lkl_6wks', '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
%HOURS=24*(7*4+4)+10; BEGIN=0; % duration of lkl_sample_1 (Wednesday 23:45)
HOURS=24*7*6; BEGIN=0; % duration of lkl_6wks (Wednesday 23:45)

%[C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16]=textread('flat_5wks', '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
%HOURS=24*7*5+6; BEGIN=9; % duration of flat_sample_5wks+ (Friday 09:00)

%[C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16]=textread('mal_6wks', '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
%HOURS=24*7*3+1; BEGIN=16; % duration of mal_sample_3wks (Friday 16:30)
%HOURS=24*7*6; BEGIN=16; % duration of mal_sample_6wks (Friday 16:30)

CH = [C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16];
[m,n]=size(CH);
HSAMPLE=round(m/HOURS);


clearvars DATA perHour;
DATA = repmat(NaN,HSAMPLE,HOURS);
S = CH(:,2);
for i = 1:HOURS
    DATA(:,i) = S(1+(i-1)*HSAMPLE: min(m,i*HSAMPLE));
end
perHour=mean(DATA); % get the hourly mean

waca = perHour(7*24+1:end);

    fit1(perHour); set(gca,'YLim', [-100 -65]);
    set(gca,'xtick',0:7*24:HOURS,'xticklabel',(0:HOURS)); xlabel('Time (Weeks)'); % week ticks
    xlabel('Time (Weeks)');
    ylabel('Noise Strength (dBm)');


%%%%%%%%%%%%%%%%%%
%%%%% Season %%%%%
%%%%%%%%%%%%%%%%%%

%%%%%
%%%%% plot noise series of 16 channels %%%%%
%%%%%
%{
%{
% lkl week 4
FROM = ((3*7+1)*24-BEGIN)*m/(HOURS);
TO = ((4*7+1)*24-BEGIN)*m/(HOURS);
DD = {'Thur','Fri','Sat','Sun','Mon','Tues','Wed'};
%}

%{
% flat week 4
FROM = ((3*7+1)*24-BEGIN)*m/(HOURS);
TO = ((4*7+1)*24-BEGIN)*m/(HOURS);
DD = {'Fri','Sat','Sun','Mon','Tues','Wed','Thur'};
%}

% mal week 2
FROM = ((1*7+1)*24-BEGIN)*m/(HOURS);
TO = ((2*7+1)*24-BEGIN)*m/(HOURS);
DD = {'Wed','Thur','Fri','Sat','Sun','Mon','Tues'};


%single channel version
figure; plot(CH(:,2)); grid on; set(gca,'XLim', [1 m]); %plot and stretch
%fit1(CH(:,2)); grid on; set(gca,'XLim', [1 m]);

%set(gca,'xtick',0: 24*m/(HOURS):m,'xticklabel',(0:HOURS)); % day ticks
%set(gca,'XLim', [25*24*m/(HOURS) 26*24*m/(HOURS)]); % select specific day

set(gca,'xtick',0: 7*24*m/(HOURS):m,'xticklabel',(0:HOURS)); xlabel('Time (Week)'); % week ticks
%set(gca,'XLim', [FROM TO]); xlabel('Days'); % select specific week
%set(gca,'xtick',FROM: 24*m/(HOURS) :TO,'xticklabel',DD); % weekday ticks

%%set(gca,'xtick',0: m/(HOURS):m,'xticklabel',(0:HOURS)); xlabel('Time (Hour)'); % bi-hour ticks
%set(gca,'XLim', [((3*7+1+1)*24-BEGIN)*m/(HOURS) ((4*7+1+3)*24-BEGIN)*m/(HOURS)]); % select specific 2-days
%set(gca,'xtick',((3*7+1+1)*24-BEGIN)*m/(HOURS): 2*m/(HOURS) :((4*7+1+3)*24-BEGIN)*m/(HOURS),'xticklabel',(0:2:23)); % bi-hour ticks
%xlabel('Time (Hour)')

ylabel('Noise Strength (dBm)')
set(gca,'YLim', [-100 -65]);
%}


for i = 1:16
    subplot(4,4,i); 
    plot(CH(:,i)); % plain
    %trend1(CH(:,i)); % with linear fit
    %set(gca,'xtick',0: 24*m/(HOURS):m,'xticklabel',(0:HOURS)); % day ticks
    %set(gca,'XLim', [16*24*m/(HOURS) 22*24*m/(HOURS)]); % select specific day
    set(gca,'xtick',0: 7*24*m/(HOURS):m,'xticklabel',(0:HOURS)); % week ticks
    %set(gca,'XLim', [3*7*24*m/(HOURS) 4*7*24*m/(HOURS)]); % select specific week
    grid on;
    title(['Channel ' int2str(i+10)]);
end
%figureSize=get(gcf,'Position');
%uicontrol('Style','text','String','My title','Position',[(figureSize(3)-100)/2 figureSize(4)-25 100 25],'BackgroundColor',get(gcf,'Color'));



%%%%%
%%%%% time-domain: ACF of 16 channels %%%%%
%%%%%
%{
nLags=24*4;
%parcorr(perHour,nLags);
%autocorr(perHour,nLags);set(gca,'xtick',0:12:nLags,'xticklabel',(0:12:nLags));
autocorr(perHour(24*7+1:end),nLags);set(gca,'XTickLabel',{'0 ','12','24','28','36','48','56','60','72','84','96'},'XTick',[0 12 24 28 36 48 56 60 72 84 96]); % for malet
%figure;autocorr(waca,nLags);set(gca,'xtick',0:12:nLags,'xticklabel',(0:12:nLags));
set(gca,'XLim', [0 nLags]);
ylabel('Correlation Coefficient');
xlabel('Lag (Hours)');
%}

%{
nLags= round(m-1)/2;
figure
xaxisScaler=4;
for i = 1:16
    subplot(4,4,i); parcorr(CH(:,i),nLags);set(gca,'xtick',0:m/48*xaxisScaler:m,'xticklabel',(0:xaxisScaler:48));grid on;
    ylabel('');
    xlabel('Lag (hours)');
    title(['Channel ' int2str(i+10)]);
end
%}


%{
%%%%%
%%%%% time-domain: boxplot %%%%%
%%%%%
%extract daily pattern
S = CH(:,1); 
dat = repmat(NaN,HSAMPLE,HOURS);
%dat = repmat(NaN,HSAMPLE*24,floor(HOURS/24));
for i = 1:HOURS
%for i = 1:floor(HOURS/24)
    %{
    wawa=repmat({int2str(i)}, HSAMPLE, 1);
    if i==1 group=wawa;
    else group=[group;wawa]; end
    %}
    dat(:,i) = S(1+(i-1)*HSAMPLE: min(m,i*HSAMPLE));
    %dat(:,i) = S(1+(i-1)*HSAMPLE*24: min(m,i*HSAMPLE*24));
end
boxplot(dat);
set(gca,'XLim', [16*floor(HOURS/24) 22*floor(HOURS/24)]); % select specific day
%}


%%%%%
%%%%% frequency-domain: spectral density of 16 channels %%%%%
%%%%%

%{
%single
nyquist = 1/2;
%freq = (1:HOURS/2)/(HOURS/2)*nyquist; 
freq = (1:(HOURS-24*7)/2)/((HOURS-24*7)/2)*nyquist; % for malet
X=freq;
for i = 1:length(freq)
    X(i)=1/freq(i);
end
xaxisScaler=4;

%Y = fft(perHour);Y(1)=[];
Y = fft(perHour(24*7+1:end));Y(1)=[]; % for malet
%power = abs(Y(1:floor(HOURS/2))).^2;
power = abs(Y(1:floor((HOURS-24*7)/2))).^2; % for malet
plot(X,power); 
set(gca,'XLim', [0 36]);
%set(gca,'xtick',0:xaxisScaler:m,'xticklabel',(0:xaxisScaler:HOURS));grid on;
set(gca,'xtick',0:xaxisScaler:m,'xticklabel',(0:xaxisScaler:(HOURS-24*7)));grid on; % for malet
xlabel('Period (Hours)');
ylabel('Spectral Power');
%set(gca,'YLim', [0 450000]);
hold all;
%}

%16
%{
nyquist = 1/2;
freq = (1:m/2)/(m/2)*nyquist;
X=freq;
for i = 1:length(freq)
    X(i)=1/freq(i);
end
xaxisScaler=4;
for i = 1:16
    Y = fft(CH(:,i));Y(1)=[];
    power = abs(Y(1:floor(m/2))).^2;
    subplot(4,4,i);
    plot(X,power);
    set(gca,'XLim', [0 m/48*36]);
    set(gca,'xtick',0:m/48*xaxisScaler:m,'xticklabel',(0:xaxisScaler:48));grid off;
    title(['Channel ' int2str(i+10)]);
    %xlabel('Period (Hours)');
end
%figure;bar(freq,power);
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%
%%%%% Trend %%%%%
%%%%%%%%%%%%%%%%%

%%%%%
%%%%% linear fitting %%%%%
%%%%%

%fit16(CH);
%{
fit1(CH(:,2)); set(gca,'XLim', [1 m]);
set(gca,'xtick',0: 7*24*m/(HOURS):m,'xticklabel',(0:HOURS)); xlabel('Time (Weeks)'); % week ticks
ylabel('Noise Strength (dBm)');
%}

%%%%%
%%%%% classical decomposition %%%%%
%%%%%

% 2 * 24 -MA (moving average)
    %{
    % Method 1: equivalent to 25-MA with weights [1/48; ...1/24...; 1/48]
    wts = [1/48;repmat(1/24,23,1);1/48];
    ret = conv(perHour,wts,'valid');
    fit1(ret); set(gca,'YLim', [-100 -65]);
    set(gca,'xtick',0:7*24:HOURS,'xticklabel',(0:HOURS)); xlabel('Time (Weeks)'); % week ticks
    xlabel('Time (Weeks)');
    ylabel('Noise Strength (dBm)');
    %}

    %{
    % Method 2: 2-MA then 24-MA
    % 2-MA
    clearvars wts; wts=[1/2;1/2];
    ma1=conv(perHour,wts,'valid');
    %output = tsmovavg(S','s', 24*HSAMPLE);
    %ma = output(~isnan(output));%plot(ma);
    % 24-MA
    clearvars wts; wts=repmat(1/24,24,1);
    ma2=conv(ma1,wts,'valid');
    figure; plot(ma2); set(gca,'YLim', [-100 -65]);
    %}

    %{  
    % Method 3: IRIS toolbox x12
    clearvars DATA i j x y;
    DATA = repmat(NaN,2*HSAMPLE,floor(HOURS/2));
    S = CH(:,2); 
    j=1;
    for i = 2:2:HOURS
        DATA(:,j) = S(1+(i-2)*HSAMPLE: min(m,i*HSAMPLE));
        j=j+1;
    end
    perHour=mean(DATA); % get the hourly mean
    ca=mm(1000,1):mm(1032,5);
    x = tseries(ca,perHour); %plot(x); grid on;
    y = x12(x); figure;plot(y); grid on;
    z = trend(x); figure;plot(z); grid on;
    set(gca,'YLim', [-100 -60]); ylabel('Noise (dBm)');
    %set(gca,'xtick',0: 7*24*m/(HOURS):floor(HOURS/2),'xticklabel',(0:floor(HOURS/2))); xlabel('Time (Weeks)'); % week ticks
    %set(gca,'xtick',0:floor(HOURS/2),'xticklabel',(0:floor(HOURS/2))); % week ticks
    %}

%{
for i = 1:16
    subplot(4,4,i);
    output = tsmovavg(CH(:,i)','s', floor(m/2));
    output=output(~isnan(output));
    %plot(CH(:,6)); hold on;
    plot(output); grid on;
    set(gca,'YLim', [-100 -60]); ylabel('Noise (dBm)');
    set(gca,'XTick',[]);
end
%}

%%%%% frequency-domain: spectral density of 16 channels %%%%%
%{
nyquist = 1/2;
freq = (1:m/2)/(m/2)*nyquist;
xaxisScaler=4;
%}

%{
for i = 1:16
    Y = fft(CH(:,i));Y(1)=[];
    power = abs(Y(1:floor(m/2))).^2;
    subplot(4,4,i);
    bar(freq,power);
    %set(gca,'XLim', [0 m/48*36]);
    %set(gca,'xtick',0:m/48*xaxisScaler:m,'xticklabel',(0:xaxisScaler:48));grid off;
    %title(['Channel ' int2str(i+10)]);
    %xlabel('Period (Hours)');
end
%}
%{
Y = fft(CH(:,6));Y(1)=[];
power = abs(Y(1:floor(m/2))).^2;
%bar(freq,power);
set(gca,'XLim', [-0.02 0.02]);
%}
%{
xx=[1:1:100];yy=xx;
for i = 1:100
    yy(i) = i;
end
%plot(xx,yy)
freq = (1:50)/(50)*nyquist;
YY=fft(yy);YY(1)=[];
power = abs(YY(1:50)).^2;
bar(freq,power);
set(gca,'XLim', [-0.02 0.02]);
%}





%{
figure
TESTEE1=detrend(TESTEE);
autocorr(TESTEE,nLags)
figure
parcorr(TESTEE,nLags)
%}

%%%%% Correlation of lag 1 %%%%%
%{
lag=1;
lagC=lagmatrix(C1,lag);

X = C1(lag+1:m);
Y = lagC(lag+1:m);
corrcoef(X,Y)
corr(X,Y,'type','Spearman')
figure
scatter(X,Y);
%}

%createfigureKF(X,Y,m,'b');

%set(gca,'XLim', [-98 -74]);
%set(gca,'XTick',1:1:12);
%graphFitted(C1,m,'b');
%graphFitted(N,R,m,'b');

%figure
%mdl=LinearModel.fit(mtxQ)


%{
figure
scatter(N,Q)
%plot(N,Q,'ro')
%}
%figure
%scatter(C1)
%plot(N,R,'ro')


