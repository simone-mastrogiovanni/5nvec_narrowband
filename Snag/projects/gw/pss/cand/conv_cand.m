function  conv_cand(list,outfold)
% 
%    conv_cand(list,cand)
%
% converts text candidate files to .mat
%
%  list      the file with the input file list; to create list, dir /s/b > list.txt
%  outfold   output folder (it should exist)

% Version 2.0 - July 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome


fidlist=fopen(list,'r');
nfiles=0;

while (feof(fidlist) ~= 1)
    nfiles=nfiles+1;
    fil=fscanf(fidlist,'%s',1);
    str=sprintf('  %s ',fil);
    disp(str);
    
    [pathstr, name, ext] = fileparts(fil);
    filout=[outfold, name, '.mat'];
    
    A=load(fil);
    save(filout,'A');
end
fclose(fidlist);

