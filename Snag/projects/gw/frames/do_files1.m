function do_files1
%DO_FILES1  creates a frame files database
%
%        do_files1
%
% A file fmnl_files0.dat with the files list must be present. 
% To create the file, use cr_fil_dat.m and edit.

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998,1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

direc0=cd;

snag_local_symbols;

direc=virgodata;
eval(['cd ' direc]);

[fnam,pnam]=uigetfile('*.*','Select a directory (and a file)');
eval(['cd ' pnam]);

fid=fopen('fmnl_files0.dat','r');

if fid < 0 
   disp('There isn''t fmnl_files0.dat')
   return
end

cddir=['cd ' pnam];
eval(cddir);

fid=fopen('fmnl_files0.dat','r');
fid1=fopen('fmnl_files1.dat','w');

eof=0;

while eof == 0
	fil=fgetl(fid);
	eof=feof(fid);
	file=deblank([pnam fil]);
	[chs,ndata,fsamp,t0]=fmnl_getchinfo(file);
	mjd=gps2mjd(t0);
	str=mjd2s(mjd);
	fprintf(fid1,'%-30s  %s \n',fil,str);
end

fclose(fid);
fclose(fid1);
cddir=['cd ' direc0];
eval(cddir);