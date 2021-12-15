function k=psc_kfile(lam,bet)
%PSC_KFILE  which of the 242 file to take
%
%  lam,bet   ecliptic coordinates (degrees)

ilam=floor(lam/15)+1;
if ilam > 24
    ilam=24;
end
ibet=floor((bet+75)/15);

if ibet < 0
    k=241;
elseif ibet > 9
    k=242;
else
    k=ilam+ibet*24;
end