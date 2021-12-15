function [file,adc,chan]=frexsnag()
%FREXSNAG   frame access
%
%        [file,adc,chan]=frexsnag() or
%        [file,adc,chan]=frexsnag(direc)
%
%        file    selected file
%        adc     selected adc
%        direc   base directory

% Version 1.0 - June 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Roberto Ruffato, Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

snag_local_symbols;

[iadc iok]=listdlg('PromptString','Select a data type:',...
   'SelectionMode','single',...
   'ListString',{'Virgo Data' 'Ligo Data'});

%to be commented
switch iadc
case 1
   direc =virgodata;
case 2
   direc =ligodata;
end

file=selfile(direc);

%---------------------------------------------------

%str=mxFSlGate(file);
%clear mex;

%[iadc iok]=listdlg('PromptString','Select an ADC:',...
%   'SelectionMode','single',...
%   'ListString',str);

%adc=str{iadc};

%--------------------------------------------------
%section above to be commented when  
str=mxFSlGate(file,'adcData');

str=mxFSlGate(file,adc);
clear mex;

[iadc iok]=listdlg('PromptString','Select a channel:',...
   'SelectionMode','single',...
   'ListString',str);

chan=str{iadc};
