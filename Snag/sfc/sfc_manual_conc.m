function sfc_manual_conc(file,filspre,filspost,filppre,filppost)
% SFC_MANUAL_CONC  manual correction of individual file concatenation
%
%        sfc_manual_conc(file,filspre,filspost,filppre,filppost)
%
%   filspre,filspost,filppre,filppost    concatenation files (if 0, no)

% Version 2.0 - September 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

fid=fopen(file,'r+');

if ischar(filspre)
    point1=48+128+128*2;
    fseek(fid,point1,'bof')
    fprintf(fid,'%128s',filspre)
end

if ischar(filspost)
    point1=48+128+128*3;
    fseek(fid,point1,'bof')
    fprintf(fid,'%128s',filspost)
end

if ischar(filppre)
    point1=48+128+128*4;
    fseek(fid,point1,'bof')
    fprintf(fid,'%128s',filppre)
end

if ischar(filppost)
    point1=48+128+128*5;
    fseek(fid,point1,'bof')
    fprintf(fid,'%128s',filppost)
end

fclose(fid);