function [out out_lp]=gd_lfclean(gdin,winlen)
% gd_lfclean  subtracts low frequencies
%
%     out=gd_lfclean(gdin,winlen)
%
%   gdin   input gd
%   winlen  (triangular) window length (def=7)
%           negative rectangular

% Version 2.0 - January 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('winlen','var')
    winlen=7;
end

ictri=1;
if winlen < 0
    ictri=0;
    winlen=-winlen;
end

M=y_gd(gdin);
n=length(M);n
t=x_gd(gdin);

base_min=ones(1,n);
base_max=base_min*n;
me=base_min'*0;

for i = 1:n
    if floor(i/5000)*5000 == i
        fprintf('Limits computation fraction : %f \n',i/n)
    end
    ii=find(t-t(i) >= -winlen/2);
    base_min(i)=min(ii);
    
    ii=find(t(i:n)-t(i) <= winlen/2);
    base_max(i)=max(ii)+i-1;
end


iy=find(M);
mea=mean(M(iy));mea
for i = 1:n
    ii=find(M(base_min(i):base_max(i)));%length(ii)
    if ~isempty(ii)
        ii=ii+base_min(i)-1;
        MM=M(ii);
        if ictri == 0
            me(i)=mean(MM);
        else
            tt=abs(t(i)-t(ii));
            win=(winlen-2*tt)/winlen;
            mew=mean(win);
            me(i)=mean(MM.*win)/mew;
        end
    end
%    me(i)=M(round(mean(base_min(i):base_max(i))));
end
y(iy)=M(iy)-me(iy)+mea;
M1=y;
M2=me;

% figure,plot(t),hold on,plot(t(base_min),'g'),plot(t(base_max),'r'),grid on

out=gdin;
out=edit_gd(out,'y',M1,'capt',[capt_gd(gdin) '-> subtracted lp']);
out_lp=edit_gd(out,'y',M2,'capt',[capt_gd(gdin) '-> lp']);
