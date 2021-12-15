function [vec,logx_str]=logx2vec(logx,logx_str)
%LOGX2VEC  decodes a logx vector

% Version 2.0 - February 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

logx=double(logx);

switch logx_str.linlog
    case 3
        error('Not implemented');
        return
    case 2
        vec(1:logx_str.len)=logx;
    case 1
        m=logx_str.m;
        b=logx_str.b;
        vec=logx;
        vec(logx~=0)=(vec(logx~=0)-1)*b+m;
    case 0
        m=logx_str.m;
        b=logx_str.b;
        
        switch logx_str.sign
            case 1
                vec=logx;
                vec(logx~=0)=m*b.^(vec(logx~=0)-1);
            case -1
                vec=logx;
                vec(logx~=0)=-m*b.^(vec(logx~=0)-1);
            case 0
                vec=logx.*sign(logx);
                vec(logx~=0)=(sign(logx(logx~=0)).*m).*(b.^(vec(logx~=0)-1));
        end
    otherwise
        error('Error in linlog code');
        return
end

