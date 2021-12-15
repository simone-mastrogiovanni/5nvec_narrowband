function conv_p10_conc_4(folder,filelist)
%CONV_P10_CONC_4  converts from p10 to vbl and concatenates (mod Sab)
%
%   folder      folder containing the decades
%   filelist    file list file (in folder)
%
%
% to obtain the list, do "dir /s/b > list.txt" and edit to arrive at
% 
% deca_20070607\pm_VSR1_20070607-1.p09
% deca_20070607\pm_VSR1_20070607-2.p09
% deca_20070607\pm_VSR1_20070607-3.p09
% deca_20070607\pm_VSR1_20070607-4.p09
% deca_20070607\pm_VSR1_20070607-5.p09
% deca_20070617\pm_VSR1_20070617-1.p09
% deca_20070617\pm_VSR1_20070617-2.p09
% deca_20070617\pm_VSR1_20070617-3.p09
%
% (without blank lines)
% the list is automatically sorted by the function.

% Version 2.0 - March 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universit� "Sapienza" - Rome
snag_local_symbols;
% snagos='unix'
% dirsep='/'
fid=fopen(filelist,'r');
nfiles=0;

while (feof(fid) ~= 1)
    nfiles=nfiles+1;
    pathfil{nfiles}=fscanf(fid,'%s',1)
end

pathfil=sort(pathfil);

for i = 1:nfiles
    [path1,file1]=fileparts(pathfil{i});
    file{i}=file1;
    path{i}=path1;
end

for i = 1:nfiles
    disp(pathfil{i})
    %sabfiltotp10=[path{i} dirsep file{i} '.p10']
    filtotp10=[folder path{i} dirsep file{i} '.p10']
    % sabfiltotvbl=[path{i} dirsep file{i} '.vbl'];
    filtotvbl=[file{i} '.vbl']
    disp([filtotvbl ' ini at ' datestr(now)]);
    
    p102vbl_3(filtotp10,filtotvbl)
    
%     vbl_=vbl_open(filtotvbl);
%     fclose(vbl_.fid);
    
    fid=fopen(filtotvbl,'r+');
    
    if i < nfiles
        point1=48+128+128*3;
        fseek(fid,point1,'bof');
        file{i+1} %sab
        fprintf(fid,'%128s',[file{i+1} '.vbl']);
        point1=48+128+128*5;
        fseek(fid,point1,'bof');
        path{i+1}
      
        fprintf(fid,'%128s',[path{i+1} dirsep]);
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