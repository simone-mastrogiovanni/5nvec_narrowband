% noisy_vfs

% [gout,fr,lfr,fr0,ph0]=vfs_create(10000,-0.1,1,[0.1,0.01,20]);
[gout,fr,lfr,fr0,ph0]=vfs_create(10000,-0.1,[1 -0.0001],[0.1,0.01,20]);

% efr1=vfs_freq(gout+0.1*randn(10000,1),2);
efr1=vfs_freq(gout+0*randn(10000,1),2);

a=ar_lowpass(efr1,2,2);
gfr=edit_gd(a,'y',fr);
figure,plot(a),hold on,plot(gfr,'r')