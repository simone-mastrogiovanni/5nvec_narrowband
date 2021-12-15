function [logx,logx_str]=vec2logx(vec,logx_str)
%VEC2LOGX   code a vector to LogX
%
%  vec              vector to be coded
%
%  logx             coded vector
%
%  logx_str         LogX structure
%        .stat      state variable
%        .dimen     X : [1 2 4 not implemented] 8 16 32
%        .sign      -1 all negative, 1 all positive, 0 mixed 
%        .linlog    3 look-up [not implemented], 2 constant, 1 linear, 0 logarithmic 
%        .m 
%        .b
%        .epsval    for two-signs log automatic format
%        .satur     positive and negative saturation
%        .errmax    
%        .errcode   error code (0 noerror,...)
%        .len       original length of the sparse vector
%        .nchar     total number of bytes in coded data

% Version 2.0 - February 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

len=length(vec);

if logx_str.dimen == 32
    logx=single(vec);
    return
end

N=2.^logx_str.dimen-1;
if N < 255
    error('Not implemented');
    return
end
    
switch logx_str.linlog
    case 3
        error('Not implemented');
        return
    case 2
        logx=vec(1);
    case 1
        [s,mi,ma]=simima(vec);
        logx_str.sign=s;
        
        m=mi;
        b=(ma-mi)/(N-1);
        logx_str.m=m;
        logx_str.b=b;
        logx=round((vec-m)/b)+1;
        
        logx(vec==0)=0;
    case 0
        [s,mi,ma]=simima(vec);
        logx_str.sign=s;
        
        switch s
            case 1
                m=mi;
                b=(ma/mi)^(1/(N-1));
                logx_str.m=m;
                logx_str.b=b;
                logx=round(log(vec/m)./log(b))+1;
                
                logx(vec==0)=0;
            case -1
                m=-ma;
                b=(mi/ma)^(1/(N-1));
                logx_str.m=m;
                logx_str.b=b;
                logx=round(log(-vec/m)./log(b))+1;
                
                logx(vec==0)=0;
            case 0
                [mi,ma]=simima2(vec);
                N=(N+1)/2-1;
                
                m=mi;
                b=(ma/mi)^(1/(N-1));
                logx_str.m=m;
                logx_str.b=b;
                logx=abs(vec);
                logx=round(log(logx/m)./log(b))+1;
                logx=logx.*sign(vec);
                
                logx(vec==0)=0;
        end
    otherwise
        error('Error in linlog code');
        return
end

if s == 0 & logx_str.linlog == 0
	switch logx_str.dimen
	case 8
        logx=int8(logx);
	case 16
        logx=int16(logx);
	end
else
	switch logx_str.dimen
	case 8
        logx=uint8(logx);
	case 16
        logx=uint16(logx);
	end
end

logx_str.stat=crea_logxstat(logx_str);

 

function [s,mi,ma]=simima(vec)

vec=vec(vec~=0);
mi=min(vec);
ma=max(vec);
if mi*ma > 0
    s=sign(mi);
else
    s=0;
end
    
 

function [mi,ma]=simima2(vec)

mi1=min(-vec(vec<0));
ma1=max(-vec(vec<0));
mi2=min(vec(vec>0));
ma2=max(vec(vec>0));

mi=min(mi1,mi2);
ma=max(ma1,ma2);