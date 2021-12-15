function mp=fmnl_imp
%FMNL_IMP   interactive multiple channel plot for fmnl
%
%       mp=fmnl_imp

% Version 1.0 - October 2001
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
%                     Luca Pontisso - luca.pontisso@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


snag_local_symbols;
file=selfile(virgodata);
vers=fmnl_chkver(file);

if vers >= 4
   
   mpstruct=fmnl_mp_seektoc(file);
   data=fmnl_mp_extrfr(mpstruct);
   %mp.nch=length(data.name);
   lnn=length(data.name);
   mp.nch=0;
   count=1;
   data   
   for i=1:lnn
      %
      mp.ch(count).name=data.name{i};
      mp.ch(count).n=data.ndata(:,i);
      mp.ch(count).x=(1:(data.ndata(i)*data.diff))*data.dx(i);
      mp.ch(count).y=data.data{i};
      mp.ch(count).unitx=data.unitx{i};
      mp.ch(count).unity=data.unity{i};
      count=count+1;
      mp.nch=mp.nch+1;
      %     
      
   end
   
else
   
[chss,ndata]=fmnl_getchinfo(file);

[iadc iok]=listdlg('PromptString','Select any number of channels',...
   'Name','Multiple channels plot',...
   'ListSize',[300 250],...
   'SelectionMode','multiple',...
   'ListString',chss)
selch=chss(iadc);
ndata=ndata(iadc);

answ=inputdlg({'Init frame (relative to the file)' 'Number of frames'},...
   'Choice of frames',2,...
  	{'1' '1'});
fr1=eval(answ{1});
nfr=eval(answ{2});

mp=fmnl_getchmp(file,selch,ndata,fr1,nfr);

end

if mp.nch == 0
   return
end

mp_plot(mp);