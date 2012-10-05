% holt-winter exponential smoothing (without trend)

function [Ft] = winter(Ob,SSAMPLE, alpha,gamma)

% Ft: total forecast
% L : single exponential factor
% S : seasonal factor
% p : season length
% HOURS: duration of sampling

[m,n] = size(Ob);
L = zeros(m,n);
p = SSAMPLE; % 1st day of probe period for S
%p = 24; % for perHour data set
S = zeros(m,n);
%S = zeros(m+p,n); % The first p entries are "negative indexed" initial value

%%%%% set initial L %%%%%
L0 = zeros(1,n);
for j = 1:n
    for i = 1:p
        L0(1,j) = L0(1,j) + Ob(i,j);
    end
    L0(1,j) = L0(1,j)/p;
end


%%%%% set S with negative index (p steps before the 1st avaiable data) %%%%%
for j = 1:n
    for i = 1:p
        S(i,j) = Ob(i,j) - L0(1,j);
    end
end


%%%%% multiplicative %%%%%
%{
for j = 1:n
    for i = 1+p:m
        if i==1+p
            Lt=L0(1,j);
        else
            Lt = L(i-1,j);
        end
        
        L(i,j) = alpha*(Ob(i,j)/S(i-p,j)) + (1-alpha)*Lt;
        S(i,j) = gamma*(Ob(i,j)/Lt) + (1-gamma)*S(i-p,j);
        Ft(i,j) = L(i,j)+S(i-p+1,j);
    end
end
%}

%%%%% additive %%%%%
for j = 1:n
    for i = p+1:m
        if i==p+1
            Lt=L0(1,j);
        else
            Lt = L(i-1,j);
        end
        
        L(i,j) = alpha*(Ob(i,j)-S(i-p,j)) + (1-alpha)*Lt;
        %S(i,j) = gamma*(Ob(i,j)-Lt) + (1-gamma)*S(i-p,j);
        S(i,j) = gamma*(Ob(i,j)-L(i,j)) + (1-gamma)*S(i-p,j);
        Ft(i,j) = L(i,j)+S(i-p+1,j);
    end
end

end