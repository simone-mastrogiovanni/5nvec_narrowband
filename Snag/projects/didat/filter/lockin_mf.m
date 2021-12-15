% lockin_mf  confronto lock-in e m-f per segnali periodici 

t=20;
N=1000*t;
fi=0.3;
x=sin((1:N)*2*pi/t+fi);
x=gd(x);
rum=randn(1,N);
rum=gd(rum);