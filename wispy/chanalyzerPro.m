%{
parse csv file from chanalyzer pro

num_cols=257;
wanted_cols=[1 2 3 4];
format=[];
for I=1:num_cols
if any(I==wanted_cols)
format=[format '%n'];
else
format=[format '%*n'];
end
end

fid=fopen('playwith.csv','rt');

data=textscan(fid,format,'delimiter',',')

fclose(fid);
%}
% 2405 - 2480
clearvars num;
num = xlsread('tempCSV.csv');
[ROW,COL]=size(num);

ctr=zeros(1,COL); 
sum=zeros(1,COL); 
for i=1:COL
    clearvars j;
    for j=1:ROW
        if(num(j,i)>-88)
            ctr(1,i) = ctr(1,i)+1;
            sum(1,i) = sum(1,i)+num(j,i)-88;
        end
        %sum(1,i) = sum(1,i)+num(j,i);
    end
    sum(1,i) = (sum(1,i)* -1) / (ROW) ;
end
