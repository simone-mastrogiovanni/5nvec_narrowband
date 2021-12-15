function s=bsd_pows(bsd,res,pieces,windn)
% bsd power spectrum
%
%   bsd     input bsd
%   res     resolution
%   pieces  number of pieces (def 1)
%   windn   window number (0 -> no, 1 -> bartlett, 2 -> hanning, 3 -> flatcos, 4 -> tukey)
%            def hanning

% Snag Version 2.0 - December 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('windn','var')
    windn=2;
end
if ~exist('pieces','var')
    pieces=1;
end

cont=ccont_gd(bsd);
inifr=cont.inifr;

s=gd_pows(bsd,'resolution',res,'pieces',pieces,'window',windn);

n=n_gd(bsd);
nz=find(y_gd(bsd));
rap=length(nz)/n;
s=s/rap;

s=edit_gd(s,'ini',inifr);