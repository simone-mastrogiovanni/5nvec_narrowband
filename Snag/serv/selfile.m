function [f,pnam,fnam]=selfile(direc,filter,question)
%SELFILE  selects a file in a directory
%
%        [f,pnam,fnam]=selfile(direc,filter,question)
%
%   f        file with path
%   pnam     path
%   fnam     file name
%   direc    the directory

% Version 1.0 - November 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('question','var')
    question='File Selection';
end

if ~exist('filter','var')
    filter='*.*';
end
    
cddir=['cd ' direc];
eval(cddir);

[fnam,pnam]=uigetfile(filter,question);

f=strcat(pnam,fnam);