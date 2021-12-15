function [coh phase]=vec_cohe(v1,v2)
% VEC_COHE  2 vector coherence
%
%     coh=vec_cohe(v1,v2)
%
%    coh    coherence
%    phase  mean phase angle (deg)

% Version 2.0 - May 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

v1=v1(:);
v2=v2(:);

coh=abs(dot(v1,v2)/(norm(v1)*norm(v2)))^2;

n=length(v1);
phase=sum(angle(v1./v2))*180/(pi*n);