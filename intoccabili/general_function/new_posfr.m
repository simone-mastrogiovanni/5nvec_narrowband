function sourupd=new_posfr(sour,t)
% NEW_POSFR  recomputes position and frequency
%
%       sourupd=new_posfr(sour,t)
%
%   sour    source structure
%   t       time (mjd)

% Version 2.0 - February 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universit? "Sapienza" - Rome
%
% C. Palomba: Further frequency derivatives added (Apr. 2011)

sourupd=sour;
sourupd.pepoch=t;
sourupd.fepoch=t;

if isfield(sour,'ddf0') == 0
    sour.ddf0=0;
end

if isfield(sour,'d3f0') == 0
    sour.d3f0=0;
end
if isfield(sour,'d4f0') == 0
    sour.d4f0=0;
end
if isfield(sour,'d5f0') == 0
    sour.d5f0=0;
end
if isfield(sour,'d6f0') == 0
    sour.d6f0=0;
end
if isfield(sour,'d7f0') == 0
    sour.d7f0=0;
end
if isfield(sour,'d8f0') == 0
    sour.d8f0=0;
end
if isfield(sour,'d9f0') == 0
    sour.d9f0=0;
end
if isfield(sour,'d10f0') == 0
    sour.d10f0=0;
end
if isfield(sour,'d11f0') == 0
    sour.d11f0=0;
end
if isfield(sour,'d12f0') == 0
    sour.d12f0=0;
end



if isfield(sour,'v_a') == 0
    sour.v_a=0;
end

if isfield(sour,'v_d') == 0
    sour.v_d=0;
end

% DT=t-sour.fepoch;
DT=diff_mjd(sour.fepoch,t);
DT=DT*86400;
sourupd.f0=sour.d12f0*(DT)^12/factorial(12)+sour.d11f0*(DT)^11/factorial(11)+sour.d10f0*(DT)^10/factorial(10)+sour.d9f0*(DT)^9/factorial(9)+sour.d8f0*(DT)^8/factorial(8)+sour.d7f0*(DT)^7/factorial(7)+sour.d6f0*(DT)^6/factorial(6)+sour.d5f0*(DT)^5/factorial(5)+sour.d4f0*(DT)^4/factorial(4)+...
    sour.d3f0*(DT)^3/factorial(3)+sour.ddf0*(DT)^2/factorial(2)+sour.df0*DT+sour.f0;
sourupd.df0=sour.d12f0*(DT)^11/factorial(11)+sour.d11f0*(DT)^10/factorial(10)+sour.d10f0*(DT)^9/factorial(9)+sour.d9f0*(DT)^8/factorial(8)+sour.d8f0*(DT)^7/factorial(7)+sour.d7f0*(DT)^6/factorial(6)+sour.d6f0*(DT)^5/factorial(5)+sour.d5f0*(DT)^4/factorial(4)+sour.d4f0*(DT)^3/factorial(3)+...
    sour.d3f0*(DT)^2/factorial(2)+sour.ddf0*DT+sour.df0;
sourupd.ddf0=sour.d12f0*(DT)^10/factorial(10)+sour.d11f0*(DT)^9/factorial(9)+sour.d10f0*(DT)^8/factorial(8)+sour.d9f0*(DT)^7/factorial(7)+sour.d8f0*(DT)^6/factorial(6)+sour.d7f0*(DT)^5/factorial(5)+sour.d6f0*(DT)^4/factorial(4)+sour.d5f0*(DT)^3/factorial(3)+sour.d4f0*(DT)^2/factorial(2)+...
    sour.d3f0*DT+sour.ddf0;
sourupd.d3f0=sour.d12f0*(DT)^9/factorial(9)+sour.d11f0*(DT)^8/factorial(8)+sour.d10f0*(DT)^7/factorial(7)+sour.d9f0*(DT)^6/factorial(6)+sour.d8f0*(DT)^5/factorial(5)+sour.d7f0*(DT)^4/factorial(4)+sour.d6f0*(DT)^3/factorial(3)+sour.d5f0*(DT)^2/factorial(2)+sour.d4f0*DT+sour.d3f0;
sourupd.d4f0=sour.d12f0*(DT)^8/factorial(8)+sour.d11f0*(DT)^7/factorial(7)+sour.d10f0*(DT)^6/factorial(6)+sour.d9f0*(DT)^5/factorial(5)+sour.d8f0*(DT)^4/factorial(4)+sour.d7f0*(DT)^3/factorial(3)+sour.d6f0*(DT)^2/factorial(2)+sour.d5f0*DT+sour.d4f0;
sourupd.d5f0=sour.d12f0*(DT)^7/factorial(7)+sour.d11f0*(DT)^6/factorial(6)+sour.d10f0*(DT)^5/factorial(5)+sour.d9f0*(DT)^4/factorial(4)+sour.d8f0*(DT)^3/factorial(3)+sour.d7f0*(DT)^2/factorial(2)+sour.d6f0*DT+sour.d5f0;
sourupd.d6f0=sour.d12f0*(DT)^6/factorial(6)+sour.d11f0*(DT)^5/factorial(5)+sour.d10f0*(DT)^4/factorial(4)+sour.d9f0*(DT)^3/factorial(3)+sour.d8f0*(DT)^2/factorial(2)+sour.d7f0*DT+sour.d6f0;
sourupd.d7f0=sour.d12f0*(DT)^5/factorial(5)+sour.d11f0*(DT)^4/factorial(4)+sour.d10f0*(DT)^3/factorial(3)+sour.d9f0*(DT)^2/factorial(2)+sour.d8f0*(DT)^1/factorial(1)+sour.d7f0;
sourupd.d8f0=sour.d12f0*(DT)^4/factorial(4)+sour.d11f0*(DT)^3/factorial(3)+sour.d10f0*(DT)^2/factorial(2)+sour.d9f0*(DT)^1/factorial(1)+sour.d8f0;
sourupd.d9f0=sour.d12f0*(DT)^3/factorial(3)+sour.d11f0*(DT)^2/factorial(2)+sour.d10f0*(DT)^1/factorial(1)+sour.d9f0;
sourupd.d10f0=sour.d12f0*(DT)^2/factorial(2)+sour.d11f0*(DT)^1/factorial(1)+sour.d10f0;
sourupd.d11f0=sour.d12f0*(DT)^1/factorial(1)+sour.d11f0;


% DT=t-sour.pepoch;
DT=diff_mjd(sour.pepoch,t);
sourupd.a=sour.a+sour.v_a*DT/(365.25*1000*3600);
sourupd.d=sour.d+sour.v_d*DT/(365.25*1000*3600);
