function iradpat_interf
%IRADPAT_INTERF     interactive call for functions which calculate the
%response of an interferometric detector to a source.
%
%Implemented functions:     
%radpat_interf      basic function, computes the detector response at 
%                   fixed time and for a fixed source
%radpat_time        computes the detector response to a fixed source as a
%                   function of time
%radpat_sky         computes the detector response at a fixed time as a
%                   function of source position
%
%by C. Palomba, July 2003

prompt={'Source r.a. (deg)' 'Source dec. (deg)' ...
        'Wave polarization angle (deg)' 'Linear polarization (%)' ...
            'Detector lat. (deg)' 'Detector long. (deg)' ...
            'Detector azimuth (deg)' 'Starting sidereal time (hour)' ...
            'Number of time steps' 'Calculation'};
default={'83.5','23.01','60','0','43.67','-10.5','198.61','0.0','100','?'};

answ=inputdlg(prompt,'Antenna response: parameters',1,default);

source.a=eval(answ{1});
source.d=eval(answ{2});
source.psi=eval(answ{3});
source.eps=eval(answ{4});
antenna.lat=eval(answ{5});
antenna.long=eval(answ{6});
antenna.azim=eval(answ{7});
tsid=eval(answ{8});
nstep=eval(answ{9});
op=eval('answ{10}');

if strcmp(op,'?')
   str={'Antenna response for fixed source position' ...
      'Antenna time response for fixed source position' ...
      'Antenna response as a function of source position (fixed time)' };
      
[ptype iok]=listdlg('PromptString','Select a computation:',...
      'Name','Antenna response',...
   	'ListSize',[400 300],...
   	'SelectionMode','single',...
   	'ListString',str);

	switch ptype
 	case 1
       eval('g=radpat_interf(source,antenna,tsid)');
    case 2
       eval('radpat_time(source,antenna,nstep);');
    case 3
       eval('radpat_sky(source,antenna,tsid)');  
    end
  
end