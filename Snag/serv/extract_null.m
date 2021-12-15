function gdcell=extract_null(gin,file)
% EXTRACT_NULL extracts the same nullified periods found in a gd_null_absc file

fid=fopen(file);

y=y_gd(gin);
figure,plot(gin),hold on

str=fgetl(fid);
str=fgetl(fid);
str=fgetl(fid);
str=fgetl(fid);
str=fgetl(fid);
A=0;
ii=0;

while 1
    A=fscanf(fid,'%f %f %d %d',4);
    if isempty(A)
        break
    end
    x1=A(1);
    i1=A(3);
    i2=A(4);
    ii=ii+1;
    g=edit_gd(gin,'ini',x1,'y',y(i1:i2));
    plot(g,'r')
    gdcell{ii}=g;
end

hold off