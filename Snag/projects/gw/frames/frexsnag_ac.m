function [adc,chan]=frexsnag_ac(file)
%FREXSNAG_AC   frame access for infos about adc and channels
%
%        [adc,chan]=frexsnag_ac(file)
%
%        file    file containing the data
%        adc     selected adc
%        chan    acquisition channel

% Version 1.0 - June 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Roberto Ruffato, Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

snag_local_symbols;
%------------------------------------------------------
%str=mxFSlGate(file);
%clear mex;
%[iadc iok]=listdlg('PromptString','Select an ADC:',...
%   'SelectionMode','single',...
%   'ListString',str);
%adc=str{iadc};
%str=mxFSlGate(file,adc);
%-------------------------------------------------------
%section above to be commented when adc is fixed to 'adcData' 

adc='adcData';
str=mxFSlGate(file,adc);
clear mex;

%--------------------------------------------------------
[iadc iok]=listdlg('PromptString','Select a channel:',...
   'SelectionMode','single',...
   'ListString',str);

chan=str{iadc};
