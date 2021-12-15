function [A type N didas dat1 dat2]=read_snaglab(file)
% READ_SNAGLAB  reads data in SnagLab formats

% Project LabMec - part of the toolbox Snag - June 2008
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

dat1=0;dat2=0;
if ~exist('file','var')
    file=selfile(' ','File SnagLab da aprire ?');
end

fid=fopen(file);

tline=fgetl(fid);

if tline(1) ~= '#'
    disp('Not a SnagLab file !')
    return
end

type=tline(2:3);

switch type
    case 'UD'
        didas=fgetl(fid);
        N=fscanf(fid,'%d',1);
        A=zeros(N,5);
        for i = 1:N
            A(i,1:5)=fscanf(fid,'%f ',5);
        end
    case 'MD' 
        tline=fgetl(fid);
        out=sscanf(tline,'%d',2);
        nord=out(1);
        N=out(2);
        tline=fgetl(fid);
        out=sscanf(tline,'%f',2);
        ux=out(1);dat1=ux;
        uy=out(2);dat2=uy;
        for i = 1:nord
            didas{i}=fgetl(fid);
        end
        A=zeros(N,1+nord);
        for i = 1:N
            A(i,1:nord+1)=fscanf(fid,'%f ',nord+1);
        end
    case 'SD'
        didas=fgetl(fid);
        tline=fgetl(fid);
        out=sscanf(tline,'%f',3);
        N=out(1);
        ini=out(2);dat1=ini;
        dt=out(3);dat2=dt;
        A=fscanf(fid,'%f ');
end