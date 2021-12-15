function [ok,ictab]=istable1(tab)

vv1=version;
vv=str2double(vv1(1:3));

ictab=0;
if vv < 8.2
    ok=isstruct(tab);
    fprintf(' Old Matlab version (%s) : structures instead of tables will be used \n',vv1)
else
    ok=istable(tab);
    ictab=1;
end

if ~ok
    ictab=0;
end