function out=bsd_fu(in,direct,fupars)
% bsd base follow-up
%
%    out=bsd_fu(in,direct,lenini)
%
%   in        input bsd (not corrected, possibly small band)
%   direct    candidate or direct parameters
%        .a   right ascenson (deg)
%        .d   declination
%        .f   frequency and derivative
%   fupars    follow-up parameters
%        .da  RA step
%        .dd  dec step
%        .df  frequency and derivatives steps
%        .na  RA number of steps
%        .nd  dec number of steps
%        .nf  frequency and derivatives number of steps

% Snag Version 2.0 - January 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

a0=direct.a;
d0=direct.d;
f0=direct.f(1);
sd0=direct.f(2);
if length(direct.f) > 2
    sd20=direct.f(3);
end

da=direct.da;
dd=direct.dd;
df=direct.df(1);
dsd=direct.df(2);
if length(direct.f) > 2
    dsd2=direct.df(3);
end

na=direct.na;
nd=direct.nd;
nf=direct.nf(1);
nsd=direct.nf(2);
if length(direct.f) > 2
    nsd2=direct.nf(3);
end

a=a0-da*(na-1)/2+(0:na-1)*da;
d=d0-dd*(nd-1)/2+(0:nd-1)*dd;
sd=sd0-dsd*(nsd-1)/2+(0:nsd-1)*dsd;
if length(direct.f) > 2
    sd2=sd20-dsd2*(nsd2-1)/2+(0:nsd2-1)*dsd2;
end

out.grid.a=a;
out.grid.d=d;
out.grid.sd=sd;
if length(direct.f) > 2
    out.grid.sd2=sd2;
end