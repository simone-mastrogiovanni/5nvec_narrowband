function g=mrw(p,go,n)
%MRW  Markov random walk
%
%   g    output gd
%
%   p    transition probability vector (dim 2)
%   go   go vector (dim 2)
%   n    number of steps

if ~exist('p')
   prompt={'Probability state 1 -> state 2' 'Probability state 2 -> state 1'...
         'Step type 1' 'Step type 2' 'Number of steps'};
   def={'0.5' '0.1' '1' '1' '10000'}
   answ1=inputdlg(prompt,'Power of a gd',1,def);
   
   p(1)=eval(answ1{1});
   p(2)=eval(answ1{1});
   go(1)=eval(answ1{1});
   go(2)=eval(answ1{1});
   n=eval(answ1{1});
end
   
g=zeros(1,n);
r=rand(1,n);
s=1;
x=0;

for i=1:n
   if s == 1
      if r(i) < p(1)
         x=x+go(2);
         s=2;
      else
         x=x+go(1);
      end
   else
      if r(i) < p(2)
         x=x+go(1);
         s=1;
      else
         x=x+go(2);
      end
   end
   g(i)=x;
end

g=gd(g);
