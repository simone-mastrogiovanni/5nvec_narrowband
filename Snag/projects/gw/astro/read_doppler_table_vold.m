function doptab=read_doppler_table(file,subsamp,fileout)
%READ_DOPPLER_TABLE  reads a doppler table created by crea_table
%
%   file      file created by crea_table
%   subsamp   subsampling (one every...)
%   fileout   output file (can be not present)
%
%   doptab(5,n) or doptab(4,n) (fifth column is normally neglected)
%
%   doptab(1,n)   tai days
%   doptab(2,n)   v_x/c
%   doptab(3,n)   v_y/c
%   doptab(4,n)   v_z/c
%
%  example :  doptab=read_doppler_table('tableVirgo_2000-2010.dat',1);


[fid,message]=fopen(file,'r');

if fid == -1
   disp(message);
end

line=fgetl(fid);
disp(line);
line=fgetl(fid);
disp(line);
line=fgetl(fid);
disp(line);
line=fgetl(fid);
disp(line);

[a,count]=fscanf(fid,'%g');
ro=ceil(count/5);ro
A=reshape(a,5,ro);
doptab=A(:,1:subsamp:ro);


if exist('fileout')
    save fileout doptab;
end