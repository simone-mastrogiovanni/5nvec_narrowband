function sour=i_source
%I_SOURCE  interactive parameter choice

sour.a=120;
sour.d=30;
sour.eps=1;
sour.eta=0;
sour.psi=0; % psi < 0 clockwise rotation (also if eps = 0)
sour.t00=v2mjd([2000,1,1,0,0,0]);
sour.f0=100;
sour.df0=0;
sour.ddf0=0;
sour.h=10^-23;
sour.snr=1;
%sour.fi=2*sour.psi; % difference of phase between circular and linear polarization: eliminated 
sour.coord=0;
sour.chphase=0;
      
sel=listdlg('PromptString','Source position ?',...
    'Name','Source position',...
    'SelectionMode','single',...
    'ListString',{'North Pole' 'Galactic Center'});

switch sel
    case 1
        sour.d=90;
        sour.a=0;
    case 2
        sour.d=-28.93;
        sour.a=266.4;
end

prompt={'Source right ascension (deg)' 'Source declination (deg)' ...
        'Source eta' 'Source psi (deg)' 'Source h'};
default={num2str(sour.a),num2str(sour.d),num2str(sour.eps),num2str(sour.psi),...
    num2str(sour.h)};

answ=inputdlg(prompt,'Source parameters',1,default);

sour.a=eval(answ{1});
sour.d=eval(answ{2});
sour.eta=eval(answ{3});
sour.psi=eval(answ{4});
sour.h=eval(answ{5});
