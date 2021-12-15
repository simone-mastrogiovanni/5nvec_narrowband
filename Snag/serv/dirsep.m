function ds=dirsep()
% directory separator
%
%     ds=dirsep()
%
%  pc   -> '\'
%  unix -> '/'
%  mac  -> '/' (old ':')

if ispc
    ds='\';
elseif isunix
    ds='/';
elseif ismac
    ds='/';
end