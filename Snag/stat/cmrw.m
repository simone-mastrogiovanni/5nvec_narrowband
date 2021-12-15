function g=cmrw(p,go,n)
%CMRW  complex Markov random walk
%
%   g    output gd
%
%   p    transition probability vector (dim 2)
%   go   go vector (dim 2)
%   n    number of steps

% Version 1.0 - May 2002
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('p')
   prompt={'Probability state 1 -> state 2' 'Probability state 2 -> state 1'...
         'Step type 1' 'Step type 2' 'Number of steps'};
   def={'0.5' '0.1' '1' '1' '10000'}
   answ1=inputdlg(prompt,'Power of a gd',1,def);
   
   p(1)=eval(answ1{1});
   p(2)=eval(answ1{2});
   go(1)=eval(answ1{3});
   go(2)=eval(answ1{4});
   n=eval(answ1{5});
end

g=zeros(1,n);
g=g+g*i;
rx=rand(1,n);
ry=rand(1,n);
sx=1;
sy=1;
x=0;
y=0;

for k=1:n
   if sx == 1
      if rx(k) < p(1)
         x=x+go(2);
         sx=2;
      else
         x=x+go(1);
      end
   else
      if rx(k) < p(2)
         x=x+go(1);
         sx=1;
      else
         x=x+go(2);
      end
   end
   if sy == 1
      if ry(k) < p(1)
         y=y+go(2);
         sy=2;
      else
         y=y+go(1);
      end
   else
      if ry(k) < p(2)
         y=y+go(1);
         sy=1;
      else
         y=y+go(2);
      end
   end
   gg=x+i*y;
   g(k)=gg;
end

g=gd(g);
