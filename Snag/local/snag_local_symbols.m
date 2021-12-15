% snag_local_symbols  see particular instructions
%
%   snag_local_symbols
%
% Strings for local implementation of snag
% 
%    Operation:
%
% - snag/local/ folder should not be in the path of MatLab.
%   The files in this folder will not be run, but used as model.
% - create a folder (e.g. snaglocal/) in which to copy and upgrade
%   the local files. Put this folder in the path of MatLab.
%   These personalized files will be run.


%  Snag directory

snagdir='D:\_SF\SF_Prog\MatLab\snag\';
snagout='D:\GW_Data\snag_out\';

%  Data directories

%virgodata='D:\Data\Virgo\';
virgodata='O:\pss\';

ligodata='E:\GW_Data\40m\';
ligodataml='E:\GW_Data\40m\Andrea\';
r87data='E:\GW_Data\rog\';
scratchdata='E:\GW_Data\Prova\';
rogdata='E:\GW_Data\Rog\';
specdir=[snagdir 'data\spectra\'];
filtdir=[snagdir 'data\filters\'];

pssdata='E:\GW_Data\pss\';
pssreport='E:\GW_Data\pss_report\';

%  Other symbols

snagos='windows';
%snagos='unix';

dirsep='\';
