function g=gd_ps(varargin)
%GD_PS  periodic source
%
% keys :
%
% 'dt'        sampling time (in s)
% 'fenh'      frequency Doppler enhancement (to have the same effect with higher frequency)
% 'adopp'     amplitude Doppler
% 'frinit'    initial frequency
% 'dec_t'     decay time
% 'len'       length
% 'amp'       amplitude; if amp=0 -> computes the amplitude at 100 Mpc
% 'ph_rot'    phase of Earth rotation (radiants)
% 'ph_orb'    phase of Earth orbit (radiants)
%
% 'outf'    outputs the frequency
% 'outs'    outputs the signal
%
%   roughly :
%
%  f_out = frinit*(adopp*(A_orb*sin(t*fenh/t_orb+ph_orb)+A_rot*sin(t*fenh/t_rot+ph_rot))*exp(-t/dec_t)
%
%  s_out = amp*sin(f_out*t)

% Version 1.0 - May 2002
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998-2002  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

dt=0.001;
fenh=1000;
frinit=100;
adop=1;
ecl_lat=0;
eq_decl=0;
dec_t=1000*365.2442*86400;
len=32768;
amp=1;
ph_rot=0;
ph_orb=0;
ic=2;

for i = 1:length(varargin)
   strin=varargin{i};
   switch strin
      case 'dt'
         dt=varargin{i+1};
      case 'fenh'
         fenh=varargin{i+1};
      case 'adop'
         adop=varargin{i+1};
      case 'frinit'
         frinit=varargin{i+1};
      case 'eq_decl'
         eq_decl=varargin{i+1};
      case 'ecl_lat'
         ecl_lat=varargin{i+1};
      case 'dec_t'
         dec_t=varargin{i+1};
      case 'len'
         len=varargin{i+1};
      case 'amp'
         amp=varargin{i+1};
      case 'ph_rot'
         ph_rot=varargin{i+1};
      case 'ph_orb'
         ph_orb=varargin{i+1};
      case 'outf'
         ic=1;
      case 'outs'
         ic=2;
   end
end

if fenh ~= 1
    msgbox(sprintf('Attention ! fenh = %f',fenh))
end

A_orb=0.0001*cos(ecl_lat*pi/180);
A_rot=0.000001*cos(eq_decl*pi/180);
t_rot=86400*0.9972695667;
t_orb=365.25*86400;

f=zeros(1,len);
t=(0:len-1)*dt;
pi2=pi*2;
f = frinit*(1+adop*(A_orb*sin(t.*pi2*fenh/t_orb+ph_orb)+A_rot*sin(t.*pi2*fenh/t_rot+ph_rot)).*exp(-t./dec_t));

if ic == 1
   g=gd(f);
   g=edit_gd(g,'dx',dt*fenh/86400,'capt','pulsar frequency');
else
   pi2=2*pi;
   do=pi2*dt;
   f=cumsum(f)*do;
   f=mod(f,pi2);
   a=amp*cos(f);	

   g=gd(a);

   g=edit_gd(g,'dx',dt,'capt','pulsar signal');
end
