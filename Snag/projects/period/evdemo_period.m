% evdemo_period periodicita' eventi

pi2=2*pi;
res=20;
frmax=1000;
nev=500;

% t=[100 100.101 100.203 100.499];
t=rand(1,nev);

dfr=1/(max(t)-min(t));

n=floor(frmax*res/dfr);
fr=(0:n-1)*dfr/res;
s=(1:n)*0;

for i = 1:n
    om=fr(i)*pi2;
    s(i)=sum(exp(j*om*t));
end

s=(abs(s).^2)/nev;

figure, plot(fr(50:n),s(50:n));