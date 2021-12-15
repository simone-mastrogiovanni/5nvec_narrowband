function out=dyna_sim(param,in,check)
% dynamic equation symulation
%
%    out=dyna_sim(data,in,check)
%
%   param.dt      sampling time
%        .To      observation time
%        .m       mass
%        .beta    linear dissipation
%        .beta2   quadratic dissipation
%        .beta3   cubic dissipation
%        .muv     rolling resistance or dry friction 
%                 (coefficiente di attrito volvente o radente)
%        .k       linear elasicity coefficient
%        .k2      quadratic elasicity coefficient
%        .k3      cubic elasicity coefficient
%        .sin     sinusoidal elasticity coefficient (pendulum; angle in rad)
% %        .jerk    jerk (strappo) NO JERK !
%        .y0      initial position
%        .v0      initial velocity
%        .a0      initial acceleration
%        .tsmooth start-smoothing time for harmonic input
%
%      in.fr     frequency (0 delta)
%        .A      amplitude
%        .x      generic input (to be time rescaled)
%
%      check     1 plot, 2 enhanced dt, 3 plot & enh dt

% Version 2.0 - June 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome


if ~isfield(param,'dt')
     param.dt=0.01;
end
if ~isfield(param,'To')
     param.To=100;
end
if ~isfield(param,'m')
     param.m=1;
end
if ~isfield(param,'beta')
     param.beta=0;
end
if ~isfield(param,'beta2')
     param.beta2=0;
end
if ~isfield(param,'beta3')
     param.beta3=0;
end
if ~isfield(param,'muv')
     param.muv=0;
end
if ~isfield(param,'k')
     param.k=1;
end
if ~isfield(param,'k2')
     param.k2=0;
end
if ~isfield(param,'k3')
     param.k3=0;
end
if ~isfield(param,'sin')
     param.sin=0;
end
if ~isfield(param,'jerk')
     param.jerk=0;
end
if ~isfield(param,'y0')
     param.y0=0;
end
if ~isfield(param,'v0')
     param.v0=0;
end
if ~isfield(param,'a0')
     param.a0=0;
end
if ~isfield(param,'tsmooth')
     param.tsmooth=50;
end

if ~exist('in','var')
    in.fr=0;
end

N=round(param.To/param.dt); 

if ~isfield(in,'A') 
     in.A=1;
end

cimp=0;
if ~isfield(in,'x') || in.x == 0
     if ~isfield(in,'fr')
         in.fr=0;
     end
     if in.fr == 0
        in.x=zeros(N,1);
        in.x(1)=1;
        cimp=1
     else
        in.x=sin(in.fr*2*pi*(0:N-1)*param.dt);
        nsm=round(param.tsmooth/param.dt);
        in.x(1:nsm)=in.x(1:nsm).*(1-cos(pi*(1:nsm)/nsm))/2;
     end
end

f=in.x*in.A;
[y,v,a]=dodyna(param,f);

f=gd(f);
f=edit_gd(f,'dx',param.dt);
y=gd(y);
y=edit_gd(y,'dx',param.dt);
v=gd(v);
v=edit_gd(v,'dx',param.dt);
a=gd(a);
a=edit_gd(a,'dx',param.dt);
out.f=f;
out.y=y;
out.v=v;
out.a=a;

if check > 1
    param1=param;
    param1.dt=param.dt/10;
    if cimp == 0
        f1=spline(0:N-1,in.x*in.A,0:0.1:N-1);
    else
        f1=zeros(N*10,1);
        f1(1:10)=in.A;
    end
    y1=dodyna(param1,f1);
    y1=gd(y1);
    y1=edit_gd(y1,'dx',param.dt/10);
    out.y1=y1;
end

if check == 1
    figure,plot(out.y);
elseif check == 3
    figure,plot(out.y1);
    hold on,plot(out.y,'r.');
end


function [y,v,a]=dodyna(p,f)
% raw engine
%
%  p  param
%  f  input force

N=length(f);
y=zeros(N,1);
v=y;
a=y;

y(1)=p.y0;
v(1)=p.v0;
a(1)=p.a0;
dt=p.dt;

for i = 2:N
    a(i)=f(i-1)/p.m ...
        -(p.k*y(i-1)+p.k2*y(i-1).^2+p.k3*y(i-1).^3+p.sin*sin(y(i-1))) ...
        -(p.beta*v(i-1)+p.beta2*v(i-1).^2+p.beta3*v(i-1).^3+p.muv*sign(v(i-1)));
    v(i)=v(i-1)+a(i)*dt;
    y(i)=y(i-1)+v(i)*dt;
end