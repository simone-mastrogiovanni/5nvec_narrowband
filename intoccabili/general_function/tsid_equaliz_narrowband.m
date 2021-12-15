function [geq weq]=tsid_equaliz_narrowband(gin,wien,ant,fr0)
% TSID_EQUALIZE  equalizes for the sidereal period)
%
%   [geq weq d5eq d5 w5 A0 A45 A0_deq A45_deq]=tsid_equaliz(gin,wien,ant)
%
%   gin       input data
%   wien      wiener vector (or 1)
%   ant       ...
%   fr0       Frequency of the source

% Version 2.0 - May 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universit� "Sapienza" - Rome

if length(wien) == 1
    wien=check_nonzero(gin);
end
ST=86164.09053083288;
cont=cont_gd(gin);
t0=cont.t0;
% t0sid=(gmst(t0)+ant.long/15)*3600;
sour.a=cont.corrections_par.a;
sour.d=cont.corrections_par.d;
dt=dx_gd(gin);
fr1=fr0-floor(fr0*dt)/dt;
N=floor(ST/dt);
weq=zeros(1,N)';
yeq=weq;
y=y_gd(gin);
n=n_gd(gin);
x=x_gd(gin);
%x=x-x(1);
y=y.*exp(-1j*mod(fr0*x,1)*2*pi); %shift data by - signal frequency
yequa=zeros(N,1);
wequa=zeros(N,1);
piece=floor(n/N);
tot=piece;

% for i=1:1:piece
%    tot=tot+1;
%    yequa=yequa+y((i-1)*N+1:i*N);
%    wequa=wequa+wien((i-1)*N+1:i*N);   
% end
y=y.';
wien=wien.';
yequa=sum(reshape(y(1:piece*N),N,piece),2);
wequa=sum(reshape(wien(1:piece*N),N,piece),2);

weq=wequa;
%weq=wequa/tot; % normalize weights

geq=edit_gd(gin,'y',yequa,'capt',['ST on ' capt_gd(gin)]); % output gd with folded data
