function head=check_psc_file
%CHECK_PSC_FILE  checks the consistency of a pss candidate file

file=selfile(' ');

fid=fopen(file);
format long

head=psc_rheader(fid)

info=dir(file)
ncand=(info.bytes-188)/(8*2);
if head.prot > 2
    ncand=(info.bytes-256)/(8*2);
end
ncand

if ncand-floor(ncand) ~= 0
    disp(' *** ERROR ! not integer number of candidates')
end