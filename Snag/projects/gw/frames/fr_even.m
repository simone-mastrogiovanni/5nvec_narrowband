function [file,adc]=fr_even(direc)
%FR_EVEN   event finder for frames
%
%        [file,adc]=fr_even(direc)
%
%        file    selected file
%        adc     selected adc
%        direc   base directory

% Version 1.0 - November 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

snag_local_symbols;
cddir=['cd ' ligodata];
eval(cddir);

file=selfile(direc);

str={'IFO_DMRO' 'IFO_Mike' 'SUS_EE_Coil_V' 'IFO_MCR'...
   'IFO_SAT' 'IFO_EAT' 'IFO_Lock' 'IFO_Seis_1' 'PSL_MC_V' 'IFO_DCDM'};

[iadc iok]=listdlg('PromptString','Select an ADC:',...
   'SelectionMode','single',...
   'ListString',str);

adc=str{iadc};

%answ=inputdlg({'Length of an fft ?' 'Number of cycles ?'},...
%   'Base spectral parameters',1,...
%   {'8192' '1000'});
%l=eval(answ{1});
%cycles=eval(answ{2});
cycles=20;

[a,t,f,t0,t0s,c,u,more] = frextrsnag1(file,adc,1,1);
lr=length(a)*2;

[d,r]=inifr2ds(lr,1,lr);
stat=zeros(1,30);
mode=zeros(1,10);
mode(1)=1;
mode(2)=1;
mode(3)=t0;
mode(4)=more(6);  %(t(101)-t(1))/100;
mode(5)=100;
mode(6)=2.5;
mode(7)=0.1;
mode(8)=10;
mode(9)=t0;

clear a t f t0 t0s c u more;
%pack;

for i =1:cycles
   [d,r]=fr2ds_fl(d,r,file,adc);
   y=y_ds(d);
   stat=event_finder(y,mode,stat,' ','evenfr.dat','statfr.dat');
end
