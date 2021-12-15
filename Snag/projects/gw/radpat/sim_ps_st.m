function [lf A]=sim_ps_st(sour,ant,N)
%SIM_PS_ST  periodic source low frequency modulation
%             (see also sim_ps_nodop)
%
%     [lf A]=sim_ps_st(sour,ant,N)
%
%  sour       source structure or 5-vect
%  ant        antenna structure 
%  N          number of samples

% Version 2.0 - January 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

st=(0:N-1)*2*pi/N;

if isnumeric(sour)
    A=sour;
    stsid=0;
else
    [L0 L45 CL CR A Hp Hc]=sour_ant_2_5vec(sour,ant);
end

lf=0;
for i = 1:5
    lf=lf+A(i)*exp(1j*(i-3)*st);
end
