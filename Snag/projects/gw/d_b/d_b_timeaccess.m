function [D_B,r_struct]=d_b_timeaccess(D_B,r_struct)
%DB_TIMEACCESS  sets up the structures for access by time
%
%       [D_B,r_struct]=db_timeaccess(D_B,r_struct)
% 
%  Can be called also without the input r_struct

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

direc0=cd;

snag_local_symbols;

direc=virgodata;
eval(['cd ' direc]);

[fnam,pnam]=uigetfile('*.*','Select a directory (and a file)');
eval(['cd ' pnam]);

r_struct.cont.dir=pnam;

fid=fopen('fmnl_files1.dat');

if fid < 0
   disp(' *** Error opening fmnl_files1.dat');
   return
end

eof=0;
ii=0;

while eof == 0
	str=fgetl(fid);
	eof=feof(fid);
	ii=ii+1;
   file=str(1:30);
   file=deblank(file);
   r_struct.cont.files{ii}=file;
   str1=str(32:length(str));
   str1=deblank(str1);
   times(ii)=s2mjd(str1);
end

r_struct.cont.kmax=ii;

str=mjd2s(times(1)-0.00001);
str1=mjd2s(times(ii)-0.00001);

answ=inputdlg({['Desired time ? min ' str ' max ' str1]},...
   'Access by time',1,{str});

time1=s2mjd(answ{1});
r_struct.cont.time1=time1;

for i = 1:ii
   if time1 <= times(i)
      break
   end
end

k=i-1;
if k < 1
   k=1;
end

r_struct.cont.k=k;
r_struct.cont.file=deblank([r_struct.cont.dir r_struct.cont.files{k}]);;
D_B.data.file=deblank([r_struct.cont.dir r_struct.cont.file]);