% simple exponential smoothing

function [Ft] = ses(Ob,alpha)

[m,n] = size(Ob);
Ft=zeros(m,n);

%{
for n = 1:n
    for m = 2:m
        Ft(m,n)= alpha*Ft(m-1,n) + (1-alpha)*Ft(m,n);
    end
end
%}

for n = 1:n
    for m = 1:m
        if m==1
            Ft(m,n)= Ob(m,n);
        else
            Ft(m,n)= (1-alpha)*Ft(m-1,n) + alpha*Ob(m,n);
        end
    end
end

end