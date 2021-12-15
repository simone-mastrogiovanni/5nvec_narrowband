% prova

figure, hold on

aa=pulsar_5;
aa.psi=0;
k=1;

for eta = 0:0.15:1
    aa.eta=eta;
    [G M]=pss_sky_resp(virgo,aa,1);
    [tcol colstr colchar]=rotcol(k);
    plot(1./G,colstr);
    k=k+1;
end

grid on,title('Loss factor - eta variation'),xlabel('declination')

figure,hold on,k=1;
for eta = 0:0.15:1
    [tcol colstr colchar]=rotcol(k);
    plot([0 1],[k k],colstr);
    k=k+1;
end

k=1;
aa.eta=0;
figure, hold on

for psi = 0:7.5:45
    aa.psi=psi;
    [G M]=pss_sky_resp(virgo,aa,1);
    [tcol colstr colchar]=rotcol(k);
    plot(1./G,colstr);
    k=k+1;
end

grid on,title('Loss factor - psi variation'),xlabel('declination')