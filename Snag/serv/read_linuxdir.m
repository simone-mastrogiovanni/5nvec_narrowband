function [files,sizes,dates]=read_linuxdir(file)
% READ_LINUXDIR  reads a directory content file
%
% To have the input file, ls -l > dir.txt and edit to cut out trash

% Version 2.0 - June 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('file','var')
    file=selfile('');
end

fid=fopen(file);

C=textscan(fid,'%*s %*s %*s %*s %d %12c %s','MultipleDelimsAsOne',1);
% C=textscan(fid,'%*s %*s %*s %*s %d %s %s %s %s','MultipleDelimsAsOne',1);

fclose(fid)

files=C{3};
sizes=C{1};
n=length(sizes);
a=C{2};
for i=1:n
    dates{i}=a(i,:);
end
dates=dates';
