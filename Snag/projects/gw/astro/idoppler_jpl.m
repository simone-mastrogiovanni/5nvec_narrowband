function [g,newf,pos,vel]=idoppler_jpl
%IDOPPLER_JPL  Doppler shift due to detector/source relative motion
%
%   interactive call of doppler_jpl

% Version 1.0 - June 1999
% Copyright (C) 1999-2000  Ettore Majorana - ettore.majorana@roma1.infn.it
% Istituto Nazionale di Fisica Nucleare Sez. di Roma 
% c/o Universita` "La Sapienza"
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


promptcg1={'Coordinate type (1: equatorial, 2: ecliptical, 3: horizontal, 4: galactic)' ...
      'Longitude' 'Latitude' 'Frequency (Hz)'};
defacg1={'1','0.4','71.993','100'};
answ1=inputdlg(promptcg1,'Source',1,defacg1);


if answ1{1} == '1'
   coord='equatorial';
else
   switch answ1{1}
   case '2'
      coord='ecliptical';
   case '3' 
      coord='horizontal';
   case '4'
      coord='galactic';
   end
end



promptcg2={'Longitude (deg)' 'Latitude (deg)' 'Height (m)'};
defacg2={'43.76','71.0','0.0'};
answ2=inputdlg(promptcg2,'Detector',1,defacg2);


promptcg3={'Sampling time (s)'...
      'No. of samples (=1 -> specific answer, >1 -> output on gd)' };
defacg3={'14400','2170'};
answ3=inputdlg(promptcg3,'Data chunk',1,defacg3);


promptcg4={'Day No. (from 31 Dec 1899)' 'in-day time (s)' };
defacg4={'36516','60.0'};
answ4=inputdlg(promptcg4,'Time',1,defacg4);


ai   =eval(answ1{2});
di   =eval(answ1{3});
lat  =eval(answ2{2});
lon  =eval(answ2{1});
hei  =eval(answ2{3});
fre  =eval(answ1{4});
gio  =eval(answ4{1});
ind  =eval(answ4{2});

dt   =eval(answ3{1});
ns   =eval(answ3{2});


for i=1:ns
   day= gio + ind + i*dt/86400; %ind is tranformed in days within fuction doppler_jpl 
   [newf,pos,vel]=doppler_jpl(coord,ai,di,lat,lon,hei,fre,day,ind);

   uy(i)=newf;
   ux(i)=i*dt/86400;

end

if ns==1
   nd=num2str(newf);
   x =num2str(pos(1),'%13.2f');
   y =num2str(pos(2),'%13.2f');
   z =num2str(pos(3),'%13.2f');
   vx=num2str(vel(1));
   vy=num2str(vel(2));
   vz=num2str(vel(3));
   box=char(['shifted frequency = ' nd ' Hz'],...
             ' ',...
            ['position vector [x] = ' x ' km'],...
            ['position vector [y] = ' y ' km'],...
            ['position vector [z] = ' z ' km'],...
             ' ',...
            ['velocity vector [x] = ' vx '  *c'],...
            ['velocity vector [y] = ' vy '  *c'],...
            ['velocity vector [z] = ' vz '  *c']);
   msgbox(box,'output');
else
   g=gd(uy);
   g=edit_gd(g,'x',ux,'dx',dt/86400,'type',2,'capt','Doppler effect');
end     
