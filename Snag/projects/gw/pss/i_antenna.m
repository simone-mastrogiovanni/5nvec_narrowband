function ant=i_antenna
%I_ANTENNA  interactive parameter choice

ant.azim=0;
ant.incl=0;

sel=listdlg('PromptString','Type of antenna ?',...
    'Name','Antenna type',...
    'SelectionMode','single',...
    'ListString',{'Bar antenna' 'Interferometer' ...
        'M11' 'M12' 'M13' 'M22' 'M23' 'M33'});
ant.type=sel;

sel=listdlg('PromptString','Antenna position ?',...
    'Name','Antenna position',...
    'SelectionMode','single',...
    'ListString',{'North Pole' 'Virgo' 'Explorer' 'Nautilus'});

switch sel
    case 1
        ant.lat=90;
        ant.long=0;
    case 2
        ant.lat=43.6314;
        ant.long=10.5045;
        ant.azim=199.4326;
    case 3
        ant.lat=46.25;
        ant.long=6.25;
        ant.azim=39.3;
        ant.incl=0;
    case 4
        ant.lat=41.82;
        ant.long=12.67;
        ant.azim=44;
        ant.incl=0;
end

prompt={'Detector lat. (deg)' 'Detector long. (deg)' ...
        'Detector azimuth (deg)' 'Detector inclination (deg)'};
default={num2str(ant.lat),num2str(ant.long),num2str(ant.azim),num2str(ant.incl)};

answ=inputdlg(prompt,'Antenna parameters',1,default);

ant.lat=eval(answ{1});
ant.long=eval(answ{2});
ant.azim=eval(answ{3});
ant.incl=eval(answ{4});
