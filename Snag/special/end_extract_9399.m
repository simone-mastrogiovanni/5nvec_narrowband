function gdcell=end_extract_9399

global n9399 nend9399 ini9399 end9399 x9399 g9399 fid9399

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

for i = 1:n9399
    
end

x=x_gd(g9399);
y=y_gd(g9399);
typ=type_gd(g9399);

for i = 1:n9399
    iini=indexofarr(x,ini9399(i));
    ifin=indexofarr(x,end9399(i));
    x1=x(iini:ifin);
    y1=y(iini:ifin);
    if typ == 1
        g=edit_gd(g9399,'ini',x1(1),'y',y1,'capt',['extracted from ' capt_gd(g9399)]);
    else
        g=edit_gd(g9399,'x',x1,'y',y1,'capt',['extracted from ' capt_gd(g9399)]);
    end
    gdcell{i}=g;
    fprintf(fid9399,'%f %f  %d %d \r\n',ini9399(i),end9399(i),iini,ifin);
end

fclose(fid9399);
