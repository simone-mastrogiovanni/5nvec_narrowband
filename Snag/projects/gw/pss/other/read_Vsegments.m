function seg=read_Vsegments(mode,file)
% READ_Vsegments
%
%   mode   -1 = only segs, otherwise on flag mode = [fl1 fl2 ...]
%
%  The file contains t1,t2 time as 2nd and 3rd value, flag possibly as 5th
%  Comments begins with #

if ~exist('file','var')
    file=selfile(' ');
end

icmode=1;
if length(mode) == 1
    if mode == -1
        icmode=0;
    end
end
    
fid=fopen(file);
i=0;
 
while ~feof(fid)
    str=fgetl(fid);
    if str(1) == '#'
        disp(str)
        continue;
    end
    t=sscanf(str,'%f');
    if icmode == 0
    i=i+1;
        seg(1,i)=gps2mjd(t(2));
        seg(2,i)=gps2mjd(t(3));
    else
        ii=find(mode==t(5));
        if sum(ii) > 0
            i=i+1;
            seg(1,i)=gps2mjd(t(2));
            seg(2,i)=gps2mjd(t(3));
        end
    end
end

fclose(fid);