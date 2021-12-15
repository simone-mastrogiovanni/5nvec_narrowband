function conv_p08_conc(folder,filelist)
%CONV_P08_CONC  converts from p08 to vbl and concatenates
%
%   folder      folder containing the decades
%   filelist    file list file (in folder)
%
%
% to obtain the list, do "dir /s/b > list.txt" and edit to arrive at
% 
% \deca_20070607\pm_VSR1_20070607-1.p08
% \deca_20070607\pm_VSR1_20070607-2.p08
% \deca_20070607\pm_VSR1_20070607-3.p08
% \deca_20070607\pm_VSR1_20070607-4.p08
% \deca_20070607\pm_VSR1_20070607-5.p08
% \deca_20070617\pm_VSR1_20070617-1.p08
% \deca_20070617\pm_VSR1_20070617-2.p08
% \deca_20070617\pm_VSR1_20070617-3.p08
%
% (without blank lines)
% the list is automatically sorted by the function.

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

fid=fopen(filelist,'r');
nfiles=0;

while (feof(fid) ~= 1)
    nfiles=nfiles+1;
    patfil=fscanf(fid,'%s',1);
    [path{nfiles} rem]=strtok(patfil,'\');
    rem=strtok(rem,'\');
    file{nfiles}=strtok(rem,'.');
    str=sprintf(' %s  %s ',path{nfiles},file{nfiles});
    disp(str);
end

[path,ix]=sort(path);
[file,ix]=sort(file);

for i = 1:nfiles
    filtotp08=[path{i} '\' file{i} '.p08'];
    filtotvbl=[path{i} '\' file{i} '.vbl'];
    
    disp([filtotvbl ' ini at ' datestr(now)]);
    
    p082vbl(filtotp08,filtotvbl)
    
%     vbl_=vbl_open(filtotvbl);
%     fclose(vbl_.fid);
    
    fid=fopen(filtotvbl,'r+');
    
    if i < nfiles
        point1=48+128+128*3;
        fseek(fid,point1,'bof');
        fprintf(fid,'%128s',[file{i+1} '.vbl']);
        point1=48+128+128*5;
        fseek(fid,point1,'bof');
        fprintf(fid,'%128s',path{i+1});
    end
    
    if i > 1
        point1=48+128+128*2;
        fseek(fid,point1,'bof');
        fprintf(fid,'%128s',[file{i-1} '.vbl']);
        point1=48+128+128*4;
        fseek(fid,point1,'bof');
        fprintf(fid,'%128s',path{i-1});
    end
    
    fclose(fid)
end