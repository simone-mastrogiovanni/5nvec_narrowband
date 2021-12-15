function [addr,ant,runame,tim,target,SD]=bsd_funblock_0(addr,ant,runame,tim,target)
% defines the search parameters
%

global bsd_glob_noplot bsd_glob_level bsd_glob_nozeroing
bsd_glob_set=reset_bsd_glob()

SD=86164.09053083288;

if ~exist('addr','var') || addr == 0
    addr='I:';
end
if ~exist('ant','var') || ~ischar(ant)
    ant='ligol';
end
if ~exist('runame','var') || runame == 0
    runame='O2';
end
if ~exist('tim','var') || tim == 0
    tim=1;
end

if ~exist('target','var') || ~isstruct(target)
    target=pulsar_3;
end

if ~isfield(target,'psi')
    target.psi=0;
end
if ~isfield(target,'eta')
    target.eta=0;
end

msgbox(sprintf('bsd_funblock_0 : %s %s %s %f %s',addr,ant,runame,tim,target.name))
pause(0.5)