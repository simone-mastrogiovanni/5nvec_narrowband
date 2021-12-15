function pulsar=read_cwinj_table(injtab,kpuls)
% Creates a cw source structure from Ligo list
%
%   injtab   cw injection table (load from cwinj_Ox.mat)
%   kpuls    number of the pulsar

% Snag Version 2.0 - April 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome


PT=injtab;

nams=PT.Properties.VariableNames;

PTk=nams{1};
PTgpsref=nams{2};
PTf0=nams{3};
PTdf0=nams{4};
PTligoh0=nams{9};
PTiota=nams{12};
PTpsi0=nams{13};
PTra=nams{17};
PTdec=nams{16};

eval(['k=PT.' PTk ';'])
eval(['gpsref=PT.' PTgpsref ';'])
eval(['f0=PT.' PTf0 ';'])
eval(['df0=PT.' PTdf0 ';'])
eval(['ligoh0=PT.' PTligoh0 ';'])
eval(['iota=PT.' PTiota ';'])
eval(['psi0=PT.' PTpsi0 ';'])
eval(['ra=PT.' PTra ';'])
eval(['dec=PT.' PTdec ';'])

ii=find(k == kpuls);

if length(ii) == 0
    disp('pulsar not found')
    pulsar=[];
    return
end

if length(ii) > 1
    disp('more than one pulsar found')
    pulsar=[];
    return
end

pulsar.name=['pulsar_' num2str(kpuls)];
pulsar.a=ra(ii)*180/pi;
pulsar.d=dec(ii)*180/pi;
pulsar.v_a=0;
pulsar.v_d=0;
pulsar.fepoch=gps2mjd(gpsref(ii));
pulsar.f0=f0(ii);
pulsar.df0=df0(ii);
pulsar.ddf0=0;
pulsar.pepoch=pulsar.fepoch;

[ao,do]=astro_coord('equ','ecl',pulsar.a,pulsar.d);
pulsar.ecl=[ao,do];

pulsar.t00=51544;
pulsar.eps=1;

cosi=cos(iota(ii));
pulsar.eta=-2*cosi/(1+cosi^2);
pulsar.psi=psi0(ii)*180/pi;

pulsar.h=ligoh0(ii)*sqrt(1+6*cosi^2+cosi^4)/2;

pulsar.snr=1;
pulsar.coord=0;
pulsar.chphase=0;
pulsar.dfrsim=-0.2000;