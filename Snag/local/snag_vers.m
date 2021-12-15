function snag_vers

snag_local_symbols

fid=fopen([snagdir 'snag_vers.dat'],'w');
fprintf(fid,'Snag version: %s',datestr(now));
fclose(fid)