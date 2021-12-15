function [fil,dir,fid]=save_ech(ch,direv,fil,mode,capt)
%SAVE_ECH  save a channel structure in an ascii file that can be edited
%
%    ch        channel structure
%    dir,fil   default folder, file
%    mode      0 standard, 1 for the full evch
%    capt      caption

% Version 2.0 - April 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

nchtot=length(ch.an);

cddir=['cd ' direv];
eval(cddir);

filfilt={'*.ech','Channel structure files (*.ech)';'*.*','All files'};
if mode == 1
    filfilt={'*.evch','Channel/Event structure files (*.evch)';'*.*','All files'};
end
[fil,dir]=uiputfile(filfilt,'Save as');

fil=strcat(dir,fil);

fid=fopen(fil,'w');
fprintf(fid,'  Channel structure: %d antennas  \r\n',ch.na);
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