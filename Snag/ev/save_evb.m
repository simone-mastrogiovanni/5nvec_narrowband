function [fil,dir]=save_ev(ev,direv,fil,mode,fid,capt)
%SAVE_ECH  save a channel structure in an ascii file that can be edited
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

n=length(ev);

cddir=['cd ' direv];
eval(cddir);

if fid <= 0
    mode=0;
    frpintf(' *** mode = 0 \n');
end

if mode == 0
	filfilt={'*.ech','Event files (*.ev)';'*.*','All files'};
	if mode == 1
        filfilt={'*.evch','Channel/Event structure files (*.evch)';'*.*','All files'};
	end
	[fil,dir]=uiputfile(filfilt,'Save as');
	
	fil=strcat(dir,fil);
	
	fid=fopen(fil,'w');
end

fprintf(fid,'  List of %d events  \r\n',);
fprintf(fid,' event   ch   time   t max    amp   cr   len (s)   cl.id. \r\n');
for i = 1:ch.na
    fprintf(fid,'antenna %3d   :  %3d channels \r\n',i,ch.nch(i));
end
fprintf(fid,'  %s \r\n',capt);
fprintf(fid,' ch    antenna |      type      |  centr. freq.      bandwidth \r\n'); 
for i = 1:nchtot
    fprintf(fid,'%3d     %3d    |%16s|  %9.3f        %9.3f \r\n', ...
        i,ch.an(i),ch.ty{i},ch.cf(i),ch.bw(i));
end

if isfield(ch,'lcn')
    nsim=length(ch.lcn);
    if nsim > 0
        fprintf(fid,'\r\n -------------- Simulation -------------\r\n\r\n');
        fprintf(fid,'lambda for gw (norm to tobs) : %f \r\n',ch.lmg);
        fprintf(fid,'antenna  loc.dist.lambda \r\n');
        for i = 1:ch.na
            fprintf(fid,'  %2d        %f \r\n',i,ch.lml(i));
        end
        fprintf(fid,' ch     loc.dist.lam.   loc.dist.sens.  grav.wav.sens.\r\n');
        for i = 1:nsim
            fprintf(fid,'%3d   %12.3f   %12.3f   %12.3f \r\n',i,ch.lcn(i),ch.lds(i),ch.gws(i));
        end
    end
end

if isfield(ch,'nev')
    fprintf(fid,'\r\n -------------- Statistics -------------\r\n\r\n');
    nchst=length(ch.nev);
    for i = 1:nchst
        fprintf(fid,'%3d : %5d  events \r\n',i,ch.nev(i));
    end
end

if mode == 0
    fclose(fid);
    fid=0;
end