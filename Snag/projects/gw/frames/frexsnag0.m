function [file,adc]=frexsnag0()
%FrExSnag   running plot of data and power spectrum for frames
%
%        [file,adc]=frexsnag0()
%
%        file    selected file
%        adc     selected adc
%        direc   base directory

% Version 1.0 - June 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

snag_local_symbols;
cddir=['cd ' ligodata];
eval(cddir);

[iadc iok]=listdlg('PromptString','Select a data type:',...
   'SelectionMode','single',...
   'ListString',{'Virgo Data' 'Ligo Data'});

%to be commented
switch iadc
case 1
   direc ='virgodata';
case 2
   direc ='ligodata';
end

file=selfile(direc);

%---------------------------------------------------

str=mxFSlGate(file);
clear mex;

[iadc iok]=listdlg('PromptString','Select an ADC:',...
   'SelectionMode','single',...
   'ListString',str);

adc=str{iadc};

%--------------------------------------------------
%section above to be commented when  
%str=mxFSlGate(file,'adcData');

str=mxFSlGate(file,adc);
clear mex;

[iadc iok]=listdlg('PromptString','Select a channel:',...
   'SelectionMode','single',...
   'ListString',str);

adc=str{iadc};

[a,t,f,t0,t0s,c,u,more] = frextrsnag1(file,adc,1,1);

%---------- plot time serie --------------------
%
 subplot(2,1,1)
 plot(t,a) 
 ylabel(adc)
 xlabel('time [s]')
 title(t0s)
%
%------ compute and plot FFT --------------------
% 
 b = fft(a);
 m = abs(b(1:length(b)/2));
 subplot(2,1,2)
 semilogy(f,m)
 ylabel('power')
 xlabel('frequency [Hz]')
 title(['FFT for ',adc])
 
 
