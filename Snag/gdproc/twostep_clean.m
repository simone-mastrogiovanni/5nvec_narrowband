function [gout stat]=twostep_clean(gin,list_OK,thr,nw,out)
% twostep_clean  clean on list and threshold
%
%      gout=twostep_clean(gin,list_OK,thr,nw,cont)
%
%   gin       input gd
%   list_OK   (2,n) array with start and stop
%   thr       threshold
%   nw        window (in samples; typically 60)
%   out       output type (1 only on list, 2 only on threshold, 3 both
%             negative: plot)

% Version 2.0 - October 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if out < 0
    icpl=1;
    out=-out;
    figure,plot(gin,'g'),hold on
else
    icpl=0;
end

n=n_gd(gin);
dt=dx_gd(gin)/86400;
x=x_gd(gin);
cont=cont_gd(gin);
if isfield(cont,'t0')
    t0=cont.t0;
else
    t0=ini_gd(gin);
end
stat.t0=t0;

y=y_gd(gin);
y=find(y);
stat.tot=n;
stat.ori0=length(y);

if out == 1 || out > 2    
    [i1 i2]=size(list_OK);
    if i1 > 1
        y=y_gd(gin);
        k1=1;
        for i = 1:i2
            k2=round((list_OK(1,i)-t0)/dt)-1;
            if k2 > n
                continue
            end
            if icpl > 0
                plot(x(k1:k2),real(y(k1:k2)),'r')
            end
            y(k1:k2)=0;
            k1=round((list_OK(2,i)-t0)/dt)+1;
            if k1 < 1
                k1=1;
            end
        end
        gout=edit_gd(gin,'y',y);
    end
    y=find(y);
    stat.list0=length(y);
%     if icpl > 0
%         plot(gout,'r')
%     end
    gin=gout;
end

if out > 1
    gout=rough_clean(gin,-thr,thr,-nw);
    y=y_gd(gout);
    y=find(y);
    stat.thr0=length(y);
    if icpl > 0
        plot(gout),ylim([-3*thr 3*thr])
    end
end