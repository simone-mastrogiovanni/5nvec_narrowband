function stop_sel_9399

global n9399 nend9399 ini9399 end9399 x9399

if n9399 == 0
    n9399=n9399+1;
    ini9399(n9399)=x9399(1);
end
if n9399 == nend9399+1
    nend9399=nend9399+1;
else
    superplot9399('k')
end

xx=ginput(1);
end9399(nend9399)=xx(1);
superplot9399('r')
