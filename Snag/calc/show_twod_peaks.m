function show_twod_peaks(x,y,z,n,file)
%SHOW_TWOD_PEAKS shows the output of twod_peaks
%
%    show_twod_peaks(x,y,z,n,file)
%
%    x,y,z   data
%    n       number to show (0 all)
%    file    on file if it exists

N=length(x);
if n == 0
    n=N;
end

fid=0;
if exist('file','var')
    fid=fopen(file);
else
end

for i = 1:n
    if fid > 0
        fprintf(fid,'%d  %f   %f   %f \r\n',i,x(i),y(i),z(i));
    else
        disp(sprintf('%d  %f   %f   %f',i,x(i),y(i),z(i)));
    end
end