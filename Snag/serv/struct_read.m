function str=struct_read(file)
%STRUCT_READ  reads a structure or an array of structures from a script file
%
%   file     script file
%
% - The elements are one for line of the script file,
%   ending with a blank character, with the format:
%      field value 
% - A line beginning with % is ignored.
% - The data are doubles (read by %f) or strings 
%   (beginning and ending with " ).
% - Lines beginning with # contain commands.
%
%             Commands
%
% #NEW      new array element
% #REPEAT   repeats the array structure (#NEW not necessary)
%
% Example of script file:
%
% % Questa e' una prova
% aaa 123.45
% bbb.a 0.765
% bbb.b 0.1
% ccc "Ciao"
% #NEW
% aaa 222.45
% bbb 0.765
% ccc "CiaoCiao"
% #REPEAT

% Version 2.0 - July 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('file')
    snag_local_symbols;
    file=selfile(virgodata);
end

fid=fopen(file,'r');

tline=1;
n=1;

while tline ~= -1
    tline=fgetl(fid);
    if tline == -1
        return
    end
    if tline(1) == '%'
        disp(tline)
        continue
    end
    if length(tline) > 3
        if tline(1:4) == '#NEW'
            n=n+1;
        end
    end
    if length(tline) > 6
        if tline(1:7) == '#REPEAT'
            n=n+1;
            str(n)=str(n-1);
        end
    end
    if length(tline) > 0
        if tline(1) == '#'
            continue
        end
    end
    [field,value]=strtok(tline);
    value=blank_trim(value);
    if value(1) == '"'
        val=['''' value(2:length(value)-1) ''''];
    else
        val=value;
    end
    comm=['str(n).' field ' = ' val ';'];
    eval(comm)
end

fclose(fid);