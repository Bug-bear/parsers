% use function minimisation to calculate Q that delivers least square error
% based on collected samples 

% and compare adaptive and constant Q using simluted signals

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% yield best const Q from sample A %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%[C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16]=textread('LKL16-20july.txt', '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
%HOURS=96; % duration of sampling

[C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16]=textread('lkl_6wks', '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
HOURS=24*7*6; BEGIN=0; % duration of lkl_6wks (Wednesday 23:45)

%[C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16]=textread('flat_5wks', '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
%HOURS=24*7*5+6; BEGIN=9; % duration of flat_sample_5wks+ (Friday 09:00)

%[C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16]=textread('mal_6wks', '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
%HOURS=24*7*6; BEGIN=16; % duration of mal_sample_6wks (Friday 16:30)

CH = [C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16];
[ROW,COL]=size(CH);
HSAMPLE=round(ROW/HOURS);
R=9; %based on cc2420 data sheet (would be 6.25 for GINA)
BASE=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% get best static Q %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:16
    [Q(i),fval] = fminbnd(@(q) KFerror_Q_shifted(q, CH(:,i)), 0, 1000);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% test const vs adaptive Q out-of-sample (B) %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% systhesise out-sample %
clearvars T NF O

for i=1:16
    % True state
    T(:,i) = min(CH(:,i)) + (range(CH(:,i))).*rand(ROW,1);

    % Noise floor
    NF = normrnd(0,std2(CH(:,i)),ROW,1);

    % Observation
    O(:,i) = T(:,i) + NF;
end

%%% cleaning up memory %%%
clearvars CH C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15 C16;
clearvars adaptiveErr adaptiveErr_Phase constErr constErrPhase V;


for c=1:16
TEST_CHAN = c;

%%% periodically adjust Q by factor of 10 based on past RMSE %%%
SCALAR = 1; % daily if 24
q = Q(:,TEST_CHAN);
a=1; % initial adapt direction
%BASE = 2; % ajustment base
for i=1:floor(HOURS/SCALAR)
    clearvars S SAMPLE;
    S = O(:,TEST_CHAN);
    SAMPLE = S( 1+floor((i-1)*(SCALAR*HSAMPLE)) : min(ROW,floor(i*(SCALAR*HSAMPLE))) );
    tt = T(:,TEST_CHAN);
    ttt = tt( 1+floor((i-1)*(SCALAR*HSAMPLE)) : min(ROW,floor(i*(SCALAR*HSAMPLE))) );
    
    adaptiveErr_Phase(i) = KFerror_Q(q, SAMPLE, ttt);
    %adaptiveErr_Phase(i) = KFerror_Q_shifted(q, SAMPLE);
    constErrPhase(i) = KFerror_Q(Q(:,TEST_CHAN), SAMPLE, ttt);
    %constErrPhase(i) = KFerror_Q_shifted(Q(:,TEST_CHAN), SAMPLE);
    
    % variance-based Q adjustment
    V(i)=var(SAMPLE); %record variance
    %V(i)=var(S(1: min(ROW,floor(i*(SCALAR*ROW/HOURS))))); % entire variance up to date
    
    if i>1 
        q = q* ((V(i)/V(i-1)));
        %q = q* (V(i-1)/V(i));
    end
end
% vriance also shows daily pattern %
%plot(V);
%set(gca,'xtick',0:SCALAR:floor(HOURS/SCALAR),'xticklabel',(0:HOURS));grid on;

adaptiveErr(TEST_CHAN) = mean(adaptiveErr_Phase);

%%% compare performance with constant Q %%%
%constErr(TEST_CHAN) = KFerror_Q(Q(:,TEST_CHAN),  O(:,TEST_CHAN), T(:,TEST_CHAN));
constErr(TEST_CHAN) = mean(constErrPhase);

end

Result_a = mean(adaptiveErr)
Result_s = mean(constErr)

%diff = constErr - adaptiveErr; bar(diff);
%plot(adaptiveErr); hold on; plot(constErr);

%{
figure;hold all;grid on;

plot(adaptiveErr_Phase);
plot(constErrPhase);
%plot(log(var(CH)));
legend('adaptive','const');
title(SCALAR) 
title(['Adjust Q every ' int2str(SCALAR) ' hours']);
hold off
%}