%SNAGPATH  snag path settings
%
% change the snagpath directory definition in the snag_local_symbols.m file
% then, at the beginning of a snag session, run this m-file.
%
% This is not needed if the Snag paths are in the default permanent path
% (as is by modifying the pathdef.m).

snag_local_symbols;

addpath(snagdir);
addpath([snagdir 'analysis']);
addpath([snagdir 'demo']);
addpath([snagdir 'development']);
addpath([snagdir 'frames']);
addpath([snagdir 'gw']);
addpath([snagdir 'snf']);
