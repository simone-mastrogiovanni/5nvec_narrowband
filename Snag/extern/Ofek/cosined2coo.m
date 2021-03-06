function [Long,Lat]=cosined2coo(CD1,CD2,CD3);
%------------------------------------------------------------------------------
% cosined2coo function                                                   ephem
% Description: Convert cosine directions to coordinates in the same
%              reference frame. See also: cosined.m, coo2cosined.m
% Input  : - Matrix of first cosine directions.
%          - Matrix of second cosine directions.
%          - Matrix of third cosine directions.
% Output : - Matrix of longitudes [radians].
%          - Matrix of latitudes [radians].
% Tested : Matlab 7.10
%     By :  Eran O. Ofek                  October 2010
%    URL : http://wise-obs.tau.ac.il/~eran/matlab.html
% Reliable: 1
%------------------------------------------------------------------------------

Long = atan2(CD2,CD1);
SLL  = sqrt(CD1.^2+CD2.^2);
I0   = find(SLL==0);
In0  = find(SLL~=0);
Lat  = zeros(size(Long));
Lat(In0) = atan(CD3(In0)./SLL(In0));
Lat(I0)  = sign(CD3(I0)).*pi./2;
% convert Long to 0..2pi range
InL      = find(Long<0);
Long(InL)= 2.*pi + Long(InL);
 
