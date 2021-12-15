function [sid sol asid]=sidsolasid(t)
% sidsolasid  rough computation of GMST, UT and GMAST in hour
%
%   t  in mjd

sol=24*t;
sol=mod(sol,24);

t=t-v2mjd([2000 1 1 12 0 0]);

sid=18.697374558 + 24.06570982441908*t;
sid=mod(sid,24);

asid=-282.6974395092493+23.934290175580919*t;
asid=mod(asid,24);
