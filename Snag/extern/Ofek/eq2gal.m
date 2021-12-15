function [X,Y]=eq2gal(Long,Lat,Dir);
%--------------------------------------------------------
% eq2gal function    converting Long & Lat to
%                    RA & Dec and visa versa.
% Input  : - Longitude column vector (radians).
%          - Latitude coulmn vector (radians).
%          - Direction of transformation
%            'g' - equatorial to galactic (default).
%            'e' - galactic to equatorial.
% Output : - vector of RA or longitude, radians.
%          - vector of b or latitude, radians.
%    By : Eran O. Ofek             August 1999     
%--------------------------------------------------------

RotM = [-0.0548755604, +0.4941094279, -0.8676661490; -0.8734370902, -0.4448296300, -0.1980763734; -0.4838350155, +0.7469822445, +0.4559837762];

if (nargin==2),
   Dir = 'g';
elseif (nargin==3),
   % no defaults
else
   error('Illigal number of argument');
end

% convert to direction cosines
Pos = [cos(Long).*cos(Lat), sin(Long).*cos(Lat), sin(Lat)]';

if (Dir=='g'),
   RPos = RotM*Pos;
elseif (Dir=='e'),
   RPos = [RotM']*Pos;
else
   error('unknown type of conversion');
end

% convert to long & lat
RPos = RPos';
X = atan2(RPos(:,2),RPos(:,1));
Y = atan(RPos(:,3)./sqrt(RPos(:,1).^2+RPos(:,2).^2));
