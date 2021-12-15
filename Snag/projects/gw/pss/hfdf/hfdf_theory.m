function out=hfdf_theory(peaks,win,to,df)
%
%
%
%   peaks    (2,N) time, frequency for each peak
%   window   [min, max fr; min, max sd] or 0
%
%   f=f_i+s*t_i  then  -f_i=-f+s*t_i

[n1,N]=size(peaks);
tin=peaks(1,:);
fin=peaks(2,:);
C=combnk(1:N,2);
[n1,n2]=size(C);
A=zeros(2);

for i = 1:n1
    A(:,1)=[1 -tin(C(i,1))];
    A(:,2)=[1 -tin(C(i,2))];
    B(1)=fin(C(i,1));
    B(2)=fin(C(i,2));
    X(:,i)=linsolve(A,B');
end

if length(win) == 1
    xmin=min(X(1,:));
    xmax=max(X(1,:));
    ymin=min(X(2,:));
    ymax=max(X(2,:));
    win=[xmin xmax;ymin ymax];
end

m=999;
df=(win(2,1)-win(1,1))/m;
f=win(1,1)+(0:m)*df;
figure,hold on
for i = 1:N
    s=(-fin(i)+f)./tin(i);
    plot(f,s);
end
grid on

out.X=X;
out.win=win;