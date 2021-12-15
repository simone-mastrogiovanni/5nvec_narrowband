function do_fr_db(varargin)
%DO_FR_DB  creates a frame files database
%
%  keys:
%
%       dir    directory  (default virgodata)
%       file   summary file (default db_summary)
%
% A file files.dat with the files list must be present. To create the file,
% use cr_fil_dat.m and edit.

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998,1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

snag_local_symbols;

direc=virgodata;
file='db_summary';

for i = 1:length(varargin)-1;
   switch varargin{i}
   case 'dir'
      direc=varargin{i+1};
   case 'file'
      file=varargin{i+1};
   end
end

direc0=cd;

cddir=['cd ' direc];
eval(cddir);

fid=fopen('fmnl_files0.dat','r');
fid1=fopen('fmnl_files1.dat','w');

eof=0;
ntype=3;
ii=0;
time=0;

while eof == 0
fil=fgetl(fid)
eof=feof(fid);
if eof == 0
   if ii == 0
      [adc,chs]=frexsnag_ac(fil);
   end
   ii=1;
   
   while 1
      [a,t,f,t0,t0s,c,u,more] = frextrsnag1(fil,chs,ii,1);
      if isempty(t0s)
         break
      else
         ndat=length(a);
         dt=1/more(6);
         time1=time;
         time=t0s_decode(t0s)
         if ii == 1
            count=fprintf(fid1,'    File    %s\n',fil);
            count=fprintf(fid1,' Adc: %s   -   Channel: %s \n',adc,chs);
            count=fprintf(fid1,' %d data per frame; sampling time: %f s\n',...
               ndat,dt);
            count=fprintf(fid1,...
               '  N          date             dms           diff\n');
         end
            diff=(time-time1)*86400-ndat*dt;
            str=mjd2s(time);
            itime=floor(time);dmsec=(time-itime)*86400*10000;
            count=fprintf(fid1,'%3d %s %f %f \n',ii,str,dmsec,diff);
         %end
         
         ii=ii+1;
      end
   end
end
end

fclose(fid);
fclose(fid1);
cddir=['cd ' direc0];
eval(cddir);