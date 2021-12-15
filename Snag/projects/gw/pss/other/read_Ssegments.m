function seg=read_Ssegments(kbias,file)
% READ_Ssegments
%
%  The file contains t1,t2 time and length
%  Comments begins with #
%
%   kbias: see the function (0 or not present for old files, 1 for newer
%   ones)

if ~exist('kbias','var')
    k1=1;
    k2=2;
else
    if ~isnumeric(kbias)
        file=kbias;
        k1=1;
        k2=2;
    else
        if length(kbias) == 1
            k1=kbias+1;
            k2=kbias+2;
        else
            k1=kbias(1);
            k2=kbias(2);
        end
    end
end
if ~exist('file','var')
    file=selfile(' ');
end
    
fid=fopen(file);
i=0;
 
while ~feof(fid)
    str=fgetl(fid);
    if length(str) < 1
        continue
    end
    if str(1) == '#' || str(1) == '/' 
        disp(str)
        continue;
    end
    
    t=sscanf(str,'%f');
    if length(t) < k2
        continue
    end
    i=i+1;
    
    seg(1,i)=gps2mjd(t(k1));
    seg(2,i)=gps2mjd(t(k2));
end

fclose(fid);