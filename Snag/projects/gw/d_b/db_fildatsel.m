function [ntype,file,pnam]=db_fildatsel
%DB_FILDATSEL  select a file for analysis
%
%        [ntype,file,pnam]=db_fildatsel
%
%        ntype  format type (1 - snf, 2 - frame by fmnl, 3 - sds, 
%                 4 - R87, 5 - matlab format by A.Vicere`, 6 - simulation)
%        file   file with path
%        pnam   path

% Version 1.0 - March 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

ntype=0;

str={'Snag Format (sds files)' 'Frames data (by MatLab fmnl)' ...
      'Data in snf files' 'R87 data' ...
      'MatLab data (Ligo 40m)' 'Simulation'};

[ntype iok]=listdlg('PromptString','Select a type of data:',...
   'Name','Data types',...
   'ListSize',[200 200],...
   'SelectionMode','single',...
   'ListString',str);

if ntype == 6
   ntype=100;
end

snag_local_symbols;

switch ntype
case 1
   dir=virgodata;
case 2
   dir=virgodata;
case 3
   dir=snfdata;
case 4
   dir=rogdata;
case 5
   dir=ligodataml;
case 100
   dir='nodir';
end

file=' ';
pnam=' ';
if ntype ~= 100
   [file,pnam]=selfile(dir);
end
