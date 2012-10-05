% use function minimisation to calculate Q that delivers least square error
% based on collected samples

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% yield best const Q from sample A %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16]=textread('sniffedPrintfAvg.txt', '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
CH = [C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16];

for i=1:16
    [Q(i),fval] = fminbnd(@(q) KFerror_Q_shifted(q, CH(:,i)), 0, 1000);
end

%{
%q = fminbnd(@KFerror_Q, 0.01, 100)
%q = fminsearch(@(q) KFerror_Q(q,C1), 0.01, 100)

for i=1:16
   %q(i) = fminsearch(@(q) KFerror_Q(q,CH(:,i)), 0, 1000);
   [Q(i),fval] = fminbnd(@(q) KFerror_Q(q, CH(:,i) ,CH(:,i)) , 0, 1000);
end
%figure;hold all;grid on;
%plot(Q);
%plot(var(CH));
%scatter(var(CH),Q)
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% test const vs adaptive Q out-of-sample (B) %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% cleaning up memory %%%
clearvars CH C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15 C16;
clearvars err_shifted constErr constErrPhase adaptiveErr V;

[C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16]=textread('LKL16-20july.txt', '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
CH = [C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16];

[ROW,COL]=size(CH);
HOURS=96; % duration of sampling
R=9; %based on cc2420 data sheet (would be 6.25 for GINA)
BASE=1;


for c=1:1
TEST_CHAN = c;

%%% periodically adjust Q by factor of 10 based on past RMSE %%%
SCALAR = 2; % daily if 24
q = Q(:,TEST_CHAN);
a=1; % initial adapt direction
%BASE = 2; % ajustment base
for i=1:floor(HOURS/SCALAR)
    %S = CH(:,TEST_CHAN); 
    S = CH(:,TEST_CHAN); 
    SAMPLE = S( 1+floor((i-1)*(SCALAR*ROW/HOURS)) : min(ROW,floor(i*(SCALAR*ROW/HOURS))) );
    %SAMPLE = S( 1+floor((i-1)*(SCALAR*ROW/HOURS)) : floor(i*(SCALAR*ROW/HOURS)) );
    
    constErrPhase(i) = KFerror_Q_shifted(Q(:,TEST_CHAN), SAMPLE);
    err_shifted(i) = KFerror_Q_shifted(q, SAMPLE);
    
    % variance-based Q adjustment
    V(i)=var(SAMPLE); %record variance
    if i>1 
        %q = q* (V(i)/V(i-1));
        q = q* (V(i-1)/V(i));
    end
end
% vriance also shows daily pattern %
%plot(V);
%set(gca,'xtick',0:SCALAR:floor(HOURS/SCALAR),'xticklabel',(0:HOURS));grid on;

adaptiveErr(TEST_CHAN) = mean(err_shifted);

%%% compare performance with constant Q %%%
constErr(TEST_CHAN) = KFerror_Q_shifted(Q(:,TEST_CHAN),  CH(:,TEST_CHAN));

end


figure;hold all;grid on;
%plot(adaptiveErr);
%plot(constErr);
plot(err_shifted);
plot(constErrPhase);
%plot(log(var(CH)));
legend('adaptive','const');
title(SCALAR) 
title(['Adjust Q every ' int2str(SCALAR) ' hours']);
hold off
