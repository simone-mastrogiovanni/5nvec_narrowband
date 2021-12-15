function folder=selfolder(dialog_title,startfolder)
%SELFOLDER  selects a folder (directory) 
%
%        folder=selfile(dialog_title,startfolder)
%
%   dialog_title, startfolder   

% Version 1.0 - May 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('dialog_title')
    dialog_title='Folder selection';
end
if ~exist('startfolder')
    startfolder=' ';
end
cddir=['cd ' startfolder];
eval(cddir);

folder=uigetdir(startfolder,dialog_title);
