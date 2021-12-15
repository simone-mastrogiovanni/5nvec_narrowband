function gout=re_apply_null(gin,file)
% RE_APPLY_NULL applies the same nullified periods found in a gd_null_absc file

gout=gin;
y=y_gd(gin);

fid=fopen(file);

str=fgetl(fid)
str=fgetl(fid)
str=fgetl(fid)
str=fgetl(fid)
str=fgetl(fid)
A=0;

while 1
    A=fscanf(fid,'%f %f %d %d',4);
    if isempty(A)
        break
    end
    i1=A(3);
    i2=A(4);
    y(i1:i2)=0;
end

gout=edit_gd(gout,'y',y);
