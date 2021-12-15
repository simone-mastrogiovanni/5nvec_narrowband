function end_sel_9399

global n9399 nend9399 ini9399 end9399 x9399

if n9399 == 0
    n9399=n9399+1;
    ini9399(n9399)=x(1);
end
if n9399 == nend9399+1
    nend9399=nend9399+1;
    end9399(nend9399)=x9399(length(x9399));
    superplot9399('r')
end
 ini9399=ini9399(1:n9399);
 end9399=end9399(1:n9399);
 
fid=fopen('fil9399.txt','w');

for i = 1:n9399
    fprintf(fid,'%f %f \r\n',ini9399(i),end9399(i));
end
fclose(fid);
