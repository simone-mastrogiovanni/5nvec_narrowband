function ev=crea_ev(n,nch)
%CREA_EV

ev(n).t=0;
ev(n).ch=0;
ev(n).a=0;
ev(n).l=0;

for i = 1:n
    ev(i).t=rand(1)*100;
    ev(i).ch=ceil(i/(n/nch));
    ev(i).a=rand(1)*10;
    ev(i).l=ceil(rand(1)*20);
end