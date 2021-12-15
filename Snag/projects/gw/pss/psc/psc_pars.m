function psc_pars(pars,hfr,file)
%PSC_PARS  shows psc candidate db parameters
%
%      psc_pars(pars,file)
%
%   pars[n,7,3]  candidate parameters min,max,dx
%   file         output file (if present, otherwise on display); if file is
%                a number, it is interpreted as a fid

[n1,n2,n3]=size(pars);
fid=0;

if exist('file','var')
    if isnumeric(file)
        fid=file;
    else
        fid=fopen(file,'w');
    end
end

if ~exist('hfr','var')
    hfr=zeros(n1,1);
end

ncandtot=0;

for i = 1:n1
    if pars(i,1,3) > 0
        band=i*10;
        ncand=sum(hfr((i-1)*100+1:i*100));
        ncandtot=ncandtot+ncand;
        str=sprintf('%4d -> %8d %8.3f <-> %8.3f  %8d  %4d  %10.2f',band,ncand,pars(i,1,1),pars(i,1,2),...
            round((360*180)/(pars(i,2,3)*pars(i,3,3))),round((pars(i,4,2)-pars(i,4,1))/pars(i,4,3)),...
            band/(pars(i,4,2)*365.24));
        if fid == 0
            disp(str)
        else
            fprintf(fid,'%s \n',str);
        end
    end
end

disp(ncandtot)