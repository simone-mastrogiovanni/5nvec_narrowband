function [lp intyes lev]=read_laserpow(perm,file)
% read_laserpow  reads file laser-power
%
% Value of L1:PSL-PWR_PWRSET during science data segments 1+ sec long
% Between  930960015- 971654415, 2009 07/07 00:00:00 - 2010 10/21 00:00:00 utc
% (Segments may be truncated by the endpoints of the requested time interval)
% ----------------------------------------------------------------------------Value---
% L1-6553  931071406- 931079197   2009 07/08 06:56:31 - 07/08 09:06:22 utc   1.000000
% L1-6554  931081042- 931081047   2009 07/08 09:37:07 - 07/08 09:37:12 utc   1.000000
% L1-6555  931081115- 931083015   2009 07/08 09:38:20 - 07/08 10:10:00 utc   1.000000
% L1-3     931138576- 931138580   2009 07/09 01:36:01 - 07/09 01:36:05 utc   7.943282
% L1-4     931138605- 931138607   2009 07/09 01:36:30 - 07/09 01:36:32 utc   7.943282
% L1-5     931159740- 931164463   2009 07/09 07:28:45 - 07/09 08:47:28 utc   15.848932
% 
%   lp=read_laserpow(file)
%
%   perm    permitted values (n,4) [min max since upto; min max since upto; ...] ; if 0 or absent no perm
%            since and upto are in days since start 0 hour; upto=0 -> infinite; 
%            the operation is serial, so all "since" could be 0
%   file    input file (interactive choice if absent)
%   
%   lp      (3,n) the 3 are beginning time, end and value
%   intyes  (2.n) permitted intervals

if ~exist('perm','var')
    perm=0;
end

if ~exist('file','var')
    file=selfile(' ');
end

if length(perm) > 1
    [n1 n2]=size(perm);
    for i = 1:n1
        if perm(i,4) == 0
            perm(i,4)=1.e10;
        end
    end
end

intyes=[];
lev=[];

fid=fopen(file);

i=0;
k=0;
 
while ~feof(fid)
    str=fgetl(fid);
    if length(str) < 1
        continue
    end
%     if str(1) == '#' || str(1) == '/' 
%         disp(str)
%         continue;
%     end
 
    i=i+1;
    
    if i > 4
        lp(1,i-4)=gps2mjd(str2num(str(10:18)));
        lp(2,i-4)=gps2mjd(str2num(str(21:29)));
        [val status]=str2num(str(74:83));
        if status == 1
            lp(3,i-4)=val;
        else
%             disp(str)
            i=i-1;
            k=k+1;
        end
    end
end

lp0=floor(lp(1,1));

itot=i-4;
ktot=k;

if length(perm) > 1
    k=0;
    kk=1;
    for i = 1:itot
        val=lp(3,i);
        if perm(kk,3) > lp(1,i)-lp0
            continue
        end
        if perm(kk,4) < lp(1,i)-lp0
            kk=kk+1;
            if kk <= n1
                if kk < n1
                    if perm(kk,3) > lp(1,i)-lp0 || perm(kk,4) < lp(1,i)-lp0
                        continue
                    end
                else
                    continue
                end
            else
                break
            end
        end
        if val >= perm(kk,1) && val <= perm(kk,2)
            k=k+1;
            intyes(1,k)=lp(1,i);
            intyes(2,k)=lp(2,i);
            lev(k)=lp(3,i);
        end
    end
end

[n1 n2]=size(intyes);

fprintf(' %d correctly found - %d varied ; %d windows chosen\n',itot,ktot,n2)
figure,hist(lp(3,:),100),grid on,title('Histogram of laser power'),xlabel('levels')

if n1 > 1
    levm=max(lev);
    figure,hold on
    for i = 1:n2
        plot([intyes(1,i)-lp0 intyes(1,i)-lp0],[0 lev(i)],'m')
        plot([intyes(2,i)-lp0 intyes(2,i)-lp0],[0 lev(i)],'g')
        plot([intyes(1,i)-lp0 intyes(2,i)-lp0],[lev(i) lev(i)],'LineWidth',3)
    end
    grid on,title('Choice on laser power'),xlabel('days'),ylim([0 1.1*levm])
else
    figure,hold on
    for i = 1:itot
        if i > 1
            plot([lp(2,i-1)-lp0 lp(1,i)-lp0],[lp(3,i-1) lp(3,i)],'m')
        end
        plot([lp(1,i)-lp0 lp(2,i)-lp0],[lp(3,i) lp(3,i)],'LineWidth',3)
    end
    grid on,title('Laser power'),xlabel('days'),ylabel('level')
end