function pss_batch_diary(mscript,user,scriptin,outdir,repname)
%PSS_BATCH_DIARY  updates the pss batch diary
%
%     pss_batch_diary(mscript,user,scriptin,outdir,repname)
%
%   mscript     m-file script to be submitted (without .m)
%   user        user name
%   scriptin    = 1 -> print script (PARE CHE NON VA)
%               = 2 -> line by line timing (default)
%   outdir     output directory (default pssreport)
%   repname    report name (without extension, default pss_batch_diary)
%
% Saves the previous report in .old and updates the .rep file.
% Check and possibly edit the rep file !

% Version 2.0 - August 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('scriptin','var')
    scriptin=2;
end

if ~exist('outdir','var')
    snag_local_symbols
    outdir=pssreport;
end

if ~exist('repname','var')
    repname='pss_batch_diary';
end

filerep=[outdir repname '.rep'];
filerep1=[outdir repname '.old'];

stat=copyfile(filerep,filerep1);

fid=fopen(filerep,'a+');

t0=now;
startim=datestr(t0);filerep,fid

fprintf(fid,'\r\n\r\nSTART %s  at %s by %s\r\n',mscript,startim,user);
if scriptin > 0
    T=evalc(['type ' mscript]);
    fprintf(fid,'%s',T);
    fprintf(fid,'\r\n');
end
echo on
if scriptin == 2
    fid1=fopen([mscript '.m'],'r');
    while 1
        tline = fgetl(fid1);
        if ~ischar(tline)
            break
        end
        
        if length(tline) > 0 && tline(1) ~= '%'
            disp([tline ' ->>> submitted at ' datestr(now)])
        end
        eval(tline);
        t1=now;
        if (t1-t0)*86400 > 1
            subtim=datestr(t0);
            t0=t1;
            fprintf(fid,' ->>> %s  ->> submitted at  %s \r\n',tline,subtim);
        end
    end
    fclose(fid1);
else
    eval(mscript);
end
stoptim=datestr(now);
fprintf(fid,'\r\nSTOP  at  %s \r\n',stoptim);
fprintf(fid,'\r\n-------------------------------------------\r\n');

fclose(fid);