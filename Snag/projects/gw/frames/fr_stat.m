function [file,adc]=fr_stat(direc)
%FR_STAT   running statistics for frames
%
%        [file,adc]=fr_stat(direc)
%
%        file    selected file
%        adc     selected adc
%        direc   base directory

% Version 1.0 - November 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

[iform iok]=listdlg('PromptString','Data format:',...
   'SelectionMode','single',...
   'ListString',{'Raw frames' 'MatLab Frames'});

snag_local_symbols;

if iform == 1
   cddir=['cd ' ligodata];
	eval(cddir);
else
   cddir=['cd ' ligodataml];
	eval(cddir);
end

file=selfile(direc);

str={'IFO_DMRO' 'IFO_Mike' 'SUS_EE_Coil_V' 'IFO_MCR'...
   'IFO_SAT' 'IFO_EAT' 'IFO_Lock' 'IFO_Seis_1' 'PSL_MC_V' 'IFO_DCDM'};

[iadc iok]=listdlg('PromptString','Select an ADC:',...
   'SelectionMode','single',...
   'ListString',str);

adc=str{iadc};

answ=inputdlg({'Length of the chunks' 'Number of cycles ?'},...
   'Base parameters',1,...
   {'5000' '1000'});
l=eval(answ{1});
cycles=eval(answ{2});

switch iform
case 1
   [a,t,f,t0,t0s,c,u,more] = frextrsnag1(file,adc,1,1);
   lr=length(a)*2;
   clear a t f t0 t0s c u more;
   %pack;

   [d,r]=inifr2ds(l,1,lr);

   m=0;s=0;histout=zeros(1,200);histx=1:200;

   for i =1:cycles
      [d,r]=fr2ds_fl(d,r,file,adc);
      [histout,histx,m,s]=stat_ds(d,histout,histx,m,s,'total','onlylast','span',1.8);
      pause(2);
   end
case 2
   com=['load ' file];eval(com);
   rate=strcat('rate_',adc);
   dt=1/eval(rate);
   d=ds(l);d=edit_ds(d,'dt',dt);
   creagd=strcat('g=gd(',adc,');');
   eval(creagd);g=edit_gd(g,'dx',dt);n_gd(g)

   m=0;s=0;histout=zeros(1,200);histx=1:200;
   
   for i =1:cycles
      d=gd2ds(d,g);
      [histout,histx,m,s]=stat_ds(d,histout,histx,m,s,'total','onlylast','span',1.8);
      pause(2);
   end
end