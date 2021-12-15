function [chs,dt,dlen,vers,minvers,frame4par]=fmnl_selch(file)
%FMNL_SELCH   single channel selection
%
%       [chs,dt,dlen,vers,minvers,frame4par]=fmnl_selch(file)

% Version 1.0 - October 2001
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
%    Luca Pontisso - luca.pontisso@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

[vers,minvers]=fmnl_chkver(file);

if vers >= 4
   
   [chs,dt,dlen,frame4par]=fmnl_seektoc(file);
      
else
	[chss,ndata,fsamp]=fmnl_getchinfo(file);
	
	[iadc iok]=listdlg('PromptString','Select a channel',...
       'Name','Channel selection',...
       'SelectionMode','single',...
       'ListString',chss);
	chs=chss{iadc};
	dt=1/fsamp(iadc);
	dlen=ndata(iadc);
	frame4par=0;
end