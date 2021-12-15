%DO_FILES0  creates files0.dat with the list of files, to be edit
%
% - Create the file
% - Edit it excluding the items not needed and ensuring the time
%   ascending sequence
% - Rename it as fmnl_files0.dat
%
% One must set the directory with the files.

[fnam,pnam]=uigetfile('*.*','Select a directory (and a file)');
eval(['cd ' pnam]);

ddd=dir;
nfil=length(ddd);

fid=fopen('files0.dat','w');

for i = 1:nfil
   fprintf(fid,'%s \n',ddd(i).name);
end

fclose(fid);