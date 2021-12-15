function sds_concatenate(folder,filelist)
%SDS_CONCATENATE  concatenates a set of sds files
%
%   folder      folder containing the files
%   filelist    file list file
%
% The files to be concatenated should have the same structure (e.g. the same
% channels).
%
% ex.:
% sds_concatenate('D:\Data\Virgo\Simu\','D:\Data\Virgo\Simu\list.txt').
%
% to obtain the list, do "dir/B > list.txt"

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

fid=fopen(filelist,'r');
nfiles=0;

while (feof(fid) ~= 1)
    nfiles=nfiles+1;
    file{nfiles}=fscanf(fid,'%s',1);
    str=sprintf('  %s ',file{nfiles});
    disp(str);
end

nfiles=nfiles-1

for i = 1:nfiles-1
    sds1=sds_open([folder file{i}]);
    sds2=sds_open([folder file{i+1}]);
    fclose(sds1.fid);
    fclose(sds2.fid);
    
    str=sprintf('  %s  and  %s ',file{i},file{i+1});
    disp(str);
    
    fid=fopen([folder file{i}],'r+');
    point1=48+128+128*3;
    fseek(fid,point1,'bof');
    fprintf(fid,'%128s',file{i+1});
    fclose(fid);
    
    fid=fopen([folder file{i+1}],'r+');
    point2=48+128+128*2;
    fseek(fid,point2,'bof');
    fprintf(fid,'%128s',file{i});
    fclose(fid);
end