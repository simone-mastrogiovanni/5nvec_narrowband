function [fr cr t v bg]=extr_peakmap(frband,tobs,bandcr,bandbg,file)
% EXTR_PEAKMAP extracts peaks from a peakmap vbl type 2 file
%  
%     [fr cr t v me]=extr_peakmap(frband,tobs,bandcr,bandbg,file)
%
%    frband  frequency band [frmin frmax]; 0 -> all
%    tobs    observation period [tmin tmax]; 0 -> all
%    bandcr  band of cr [bcrmin bcrmax]; 0 -> all
%    bandbg  band of me [bbgmin bbgmax]; 0 -> all
%    file    peakmap file (if absent, interactive request)
%
%    fr      peak frequencies
%    cr      peak cr
%    t       peak time
%    v       peak detector velocity vector
%    bg      peak background

% Version 2.0 - August 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('file')
    file=selfile('  ');
end

if frband == 0
    frband=[0 1000000];
end
if bandcr == 0
    bandcr=[0 1e100];
end
if bandbg == 0
    bandbg=[0 1e100];
end
if time == 0
    time=[0 1000000];
end

vbl_=vbl_open(file);

if vbl_.nch ~= 5
    disp(' *** It is not a Type 2 peakmap file')
    return
end

lenx=vbl_.ch(3).lenx;
dx=vbl_.ch(3).dx;
DT=1/(dx*2);
biasfrin=floor(frband(1)/dx);
biasfrfi=ceil(frband(2)/dx);
lenx1=vbl_.ch(4).lenx;
dx1=vbl_.ch(4).dx;

t=zeros(50000,1);
v=zeros(50000,3);

ii=0;
tim0=0;

while 1
    vbl_=vbl_nextbl(vbl_);
    if vbl_.eof > 0
        fclose(vbl_.fid);
        file=[vbl_.filppost '\' vbl_.filspost]
        vbl_=vbl_open(file);
        if vbl_.eof == 2
            break
        end
        vbl_=vbl_nextbl(vbl_);
    end
    
    ii=ii+1;
    t=vbl_.bltime;
    if t(ii) < tobs(1) || t > tobs(2)
        continue
    end
    
    vbl_.ch0.next=-1;
    vbl_=vbl_nextch(vbl_);
    vv=fread(vbl_.fid,3,'double');
    v(ii,:)=vv;
    vbl_=vbl_nextch(vbl_);
    sp=fread(vbl_.fid,vbl_.ch0.lenx,'float'); % figure,semilogy(sp)
    sp(length(sp)+1:vbl_.ch0.lenx)=0;
    splen=vbl_.ch0.lenx;
    vbl_=vbl_nextch(vbl_);
    ind=fread(vbl_.fid,vbl_.ch0.lenx,'int32');
    vbl_=vbl_nextch(vbl_);
    ind(splen+1)=vbl_.ch0.lenx;
    dind=diff(ind); % figure,plot(dind)
    if tim0 > 0
        if abs((t(ii)-tim0)*86400-DT)>1
            hole=(t(ii)-tim0)*86400-DT; %hole=(t(ii)-tim0)*86400,dx
        end
    end
    tim0=t(ii);
end
