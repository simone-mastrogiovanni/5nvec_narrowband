% check_fpeakmap

[x1,y1,z1,tim1]=show_peaks([227 238],0,0);

source1.a=252.68;
source1.d=-42.77;
source1.f0=227.2758;
source1.df0=5.3883e-004/80;

source2.a=269.26;
source2.d=47.38;
source2.f0=230.7128;
source2.df0=0;

source3.a=218.86;
source3.d=-40.64;
source3.f0=237.7302;
source3.df0=3.4145e-004/80;

ant.azim=0;
ant.incl=0;
ant.lat=43.67;
ant.long=10.5;

% simplified computation

fr1=pss_frshift(tim1,source1,ant);
fr2=pss_frshift(tim1,source2,ant);
fr3=pss_frshift(tim1,source3,ant);

figure,plot_triplets(x1+floor(tim1(1)),y1,log10(z1)),grid on
hold on,plot(fr1,'x')
plot(fr2,'x')
plot(fr3,'x')

% complete computation : comment if not needed

doptab=doptab_from_sds; % use tableVirgo_2000-2010.sds in metadata

fr1a=pss_frshift(tim1,source1,doptab);
fr2a=pss_frshift(tim1,source2,doptab);
fr3a=pss_frshift(tim1,source3,doptab);

figure,plot_triplets(x1+floor(tim1(1)),y1,log10(z1)),grid on
hold on,plot(fr1a,'x')
plot(fr2a,'x')
plot(fr3a,'x')