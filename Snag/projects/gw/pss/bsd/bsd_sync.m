function varargout=bsd_sync(typ,varargin)
% parallelize more bsds
%
%  ex.: [bsd1p,bsd2p]=bsd_sync(0,bsd1,bsd2)
%
%   typ     type of parallelizing (0 exclusive, 1 inclusive)
%   input   bsds to be parallelized

% Snag Version 2.0 - May 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

nin=length(varargin);
Ts=zeros(1,nin);
ns=Ts;
dts=Ts;
Es=Ts;

for i = 1:nin
    b=varargin{i};
    cont=ccont_gd(b);
    Ts(i)=cont.t0;
    ns(i)=n_gd(b);
    dts(i)=dx_gd(b);
    Es(i)=adds2mjd(Ts(i),ns(i)*dts(i));
end

if typ == 0
    Tin=max(Ts);
    Tfin=min(Es);

    for i = 1:nin
        [b,i1,i2]=cut_bsd(varargin{i},[Tin Tfin]);
        varargout{i}=b;
    end
else
    Tin=min(Ts);
    Tfin=max(Es);

    for i = 1:nin
        s_bias=diff_mjd(Tin,Ts(i));
        k_bias=round(s_bias/dts(i));
    end
end