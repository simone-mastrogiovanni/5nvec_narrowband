% hfdf_trasf

snag_local_symbols;

sourcedir=[snagdir 'projects\gw\pss\hfdf\'];
targetdir='\\141.108.23.212\storage\users\Sergio\Funzioni_per_pss\';

copyfile([sourcedir 'hfdf_patch.m'],targetdir)
copyfile([sourcedir 'hfdf_hough.m'],targetdir)
copyfile([sourcedir 'hfdf_peak.m'],targetdir)
copyfile([sourcedir 'hfdf_refine.m'],targetdir)
copyfile([sourcedir 'hfdf_mode.m'],targetdir)
copyfile([sourcedir 'HFDF_JOB.m'],targetdir)
copyfile([sourcedir 'HFDF_SUPER_template.m'],targetdir)

fid=fopen([targetdir 'vers.txt'],'w');
fprintf(fid,'Last transfer %s',datestr(now));
fclose(fid);