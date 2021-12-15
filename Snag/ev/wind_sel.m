function [tsel,isel]=wind_sel(t,wind)
%WIND_SEL   selection of events by window
%
%    t       event times
%  wind(:,1) selection windows (wind(:,1) ini, wind(:,2) fin)
%
%  tsel      selected events
%  isel      index of selected events

% Version 2.0 - April 2004
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

[nr,nc]=size(wind);

disp(sprintf(' %d windows',nr))
wind1=wind';
w=wind1(:);
w=min(diff(w));
if w < 0
    disp('WRONG WINDOWS !');
    disp(wind);
end

n=0;
isel=0;

for i = 1:nr
    isel0=find(wind(i,1)<=t&t<=wind(i,2));
    n0=length(isel0);
    isel(n+1:n+n0)=isel0;
    n=n+n0;
end

tsel=t(isel);
    
    
