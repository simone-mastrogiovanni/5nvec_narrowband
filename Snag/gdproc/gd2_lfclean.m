function [out out_lp]=gd2_lfclean(gd2in,winlen)
% gd2_lfclean  subtracts low frequencies
%
%     out=gd2_lfclean(gd2in,winlen)
%
%   gd2in   input gd2
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

M=y_gd2(gd2in);
% M=M(:,201:210);
M1=M*0;
M2=M1;
[n m]=size(M);n,m
t=x_gd2(gd2in);

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

for j = 1:m
    y=M(:,j);
    iy=find(y);
    mea=mean(y(iy));
    for i = 1:n
        ii=find(y(base_min(i):base_max(i)));
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
    end
    y(iy)=y(iy)-me(iy)+mea;
    M1(:,j)=y;
    M2(:,j)=me;
end

% figure,plot(t),hold on,plot(t(base_min),'g'),plot(t(base_max),'r'),grid on

out=gd2in;
out=edit_gd2(out,'y',M1,'m',m,'capt',[capt_gd2(gd2in) '-> subtracted lp']);
out_lp=edit_gd2(out,'y',M2,'m',m,'capt',[capt_gd2(gd2in) '-> lp']);
