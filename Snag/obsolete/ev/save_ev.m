function [fil,dir]=save_ev(ev,direv,fil,mode,fid,capt)
%SAVE_ECH  save a channel structure in an ascii file that can be edited
%
%    ev        event structure array
%    dir,fil   default folder, file
%    mode      0 standard, 1 for the full evch
%    fid       file identifier (or 0)
%    capt      caption

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
        i,ev(i).ch,ev(i).t,ev(i).tm,ev(i).a,ev(i).cr,ev(i).a2,ev(i).l,ev(i).fl,ev(i).ci);
end

fclose(fid);