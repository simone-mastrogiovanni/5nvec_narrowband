function [fil,dir]=save_ev(ev,direv,fil,mode,fid,capt)
%SAVE_EV  save an event structure in an ascii file that can be edited
%
%    ev        event structure array
%    dir,fil   default folder, file
%    mode      0 standard, 1 for the full evch
%    fid       file identifier (or 0)
%    capt      caption

% Version 2.0 - April 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

ewyes=0;
if isfield(ev,'nev')
    ewyes=1;
else
    ev=ev2ew(ev);
end
n=length(ev);

cddir=['cd ' direv];
eval(cddir);

if fid <= 0
    mode=0;
    fprintf(' *** mode = 0 \n');
end

if mode == 0
	filfilt={'*.ev','Event files (*.ev)';'*.*','All files'};
	[fil,dir]=uiputfile(filfilt,'Save as');
	
	fil=strcat(dir,fil);
	
	fid=fopen(fil,'w');
end

fprintf(fid,'  List of %d events  \r\n',n);
fprintf(fid,' event     ch            time              t max          amp         cr        amp2       len (s)    flag    cl.id. \r\n');

for i = 1:n
    fprintf(fid,'%6d    %3d    %16.8f   %16.8f   %8.3f    %8.3f   %8.3f   %8.3f  %7d    %4d \r\n',...
        i,ev.ch(i),ev.t(i),ev.tm(i),ev.a(i),ev.cr(i),ev.a2(i),ev.l(i),ev.fl(i),ev.ci(i));
end

fclose(fid);