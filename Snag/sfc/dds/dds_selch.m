function [chn,dt,ndatatot]=dds_selch(file)
%dds_SELCH   single channel selection
%
%       [chn,dt,ndatatot]=dds_selch(file)

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

[chss,ndatatot,fsamp]=dds_getchinfo(file);

[iadc iok]=listdlg('PromptString','Select a channel',...
   'Name','Channel selection',...
   'SelectionMode','single',...
   'ListString',chss);
chn=iadc;
dt=1/fsamp;
