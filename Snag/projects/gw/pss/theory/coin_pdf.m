function cpdf=coin_pdf(inpdf)
%COIN_PDF computes the coincidence false alarm pdf from f.a. pdf
%
%           cpdf=coin_pdf(inpdf)
%
% It is supposed to have "events" from two antennas with a known pdf inpdf;
% we compute the f.a. pdf of coincidence of events above a given threshold in
% two antennas.
%
%    inpdf   single antenna (noise) pdf gd
%    cpdf    coincidence pdf gd

% Version 2.0 - June 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

cpdf=inpdf;
F=y_gd(inte_gd(inpdf));
f=y_gd(inpdf);

c=2*f.*(1-F);

cpdf=edit_gd(cpdf,'y',c,'capt','coin');