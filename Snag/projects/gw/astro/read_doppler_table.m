function doptab=read_doppler_table(file,subsamp,fileout)
%READ_DOPPLER_TABLE  reads a doppler table created by crea_table
%
%   file      file created by crea_table
%   subsamp   subsampling (one every...)
%   fileout   output file (can be not present)
%
%   doptab(5,n) 
%
%   doptab(1,n)   tdt days (terrestrial dynamical time: TDT = TAI + 32.184 s)
%   doptab(2,n)   p_x/c  position
%   doptab(3,n)   p_y/c
%   doptab(4,n)   p_z/c
%   doptab(5,n)   v_x/c  velocity
%   doptab(6,n)   v_y/c
%   doptab(7,n)   v_z/c
%   doptab(8,n)   Einstein correction
%
%  example :  doptab=read_doppler_table('table20-virgo.dat',1,'virdoptab');


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

[a,count]=fscanf(fid,'%g');
ro=ceil(count/8);ro
A=reshape(a,8,ro);
doptab=A(:,1:subsamp:ro);


if exist('fileout')
    disp('saved')
    save(fileout,'doptab');
end