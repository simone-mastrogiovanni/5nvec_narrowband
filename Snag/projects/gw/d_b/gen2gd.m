function g=gen2gd(D_B)
%GEN2GD   a gd from frames, matlab or R87 files
%
%        g=gen2gd
%   or   g=gen2gd(D_B)
%
%     g is a gd

% Version 1.0 - October 2001
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
%                     Luca Pontisso - luca.pontisso@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if exist('D_B')
   ntype=D_B.data.type;
   file=D_B.data.file;
   chn=D_B.data.chnumber;
   chs=D_B.data.chname;
   dt=D_B.data.dt;
   dslen=D_B.data.dlen;
   sp=D_B.data.sp;
   frame4par=D_B.data.frame4par;
else
	[ntype,file]=fr_fildatsel;

	[chn,chs,dt,dslen,sp,vers,minvers,frame4par]=fr_selch(ntype,file);
end

strdslen=sprintf('%d',dslen);

answ=inputdlg({'Length of the gd ?' 'Start (0 from 0 or 1 from midnight)'},...
   'gd parameters',1,...
   {strdslen '0'});
gdlen=eval(answ{1});
start=eval(answ{2});

y=zeros(1,gdlen);

rglen=2*dslen;

typ=1;
%npiece=floor(gdlen/dslen);
npiece=ceil(gdlen/dslen);
%nrest=gdlen-npiece*dslen;

[d,r,fid,reclen,g,r_struct]=db_open(ntype,file,chs,dslen,typ,rglen,dt,sp,frame4par);
dslen=len_ds(d);

for i =1:npiece
   r_struct.it=i; %%
   [d,r,r_struct]=db_gods(d,r,g,ntype,file,chs,chn,fid,reclen,r_struct,sp);
   if i==1
      if start ~= 0
         start=tini1_ds(d);
         start=(start-floor(start))*86400;
      end
   end
   y((i-1)*dslen+1:i*dslen)=y_ds(d);
end

%y1=y_ds(d);
%y(npiece*dslen+1:gdlen)=y1(1:nrest);
y=y(1:gdlen);

g=gd(y);
g=edit_gd(g,'dx',dt,'ini',start)
