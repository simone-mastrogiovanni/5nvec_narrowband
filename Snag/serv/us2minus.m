function strout=us2minus(strin)
%US2MINUS   converts '_' to '-' in strings
%
%     strout=us2minus(strin)
%
%  Useful for the graph captions

n=length(strin);
strout=strin;

for i = 1:n
   if strin(i) == '_'
      strout(i)='-';
   end
end
