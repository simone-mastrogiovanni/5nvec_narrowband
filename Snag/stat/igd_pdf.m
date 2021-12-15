function pdf=igd_pdf
%IGD_pdf  interactive probability density functions
%
%   interactive call of gd_pdf

% Version 2.0 - June 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

listpdf={'Gaussian' 'Exponential' 'Chi-square' ...
   'Uniform'};
listpdf1={'gauss' 'exp' 'chisq' 'unif'};
  
[selpdf,sdgok]=listdlg('PromptString','Which pdf ?',...
   'Name','Probability density functions',...
   'ListSize',[150 150],...
   'SelectionMode','single',...
   'ListString',listpdf);

switch selpdf
    case 1 
        promptcg1={'Mean' 'Standard deviation' 'Min x' 'Max x' 'dx'};
        defacg1={'0','1','-5' '5' '0.01'};
        answ=inputdlg(promptcg1,'Parameters',1,defacg1);
        par(1)=eval(answ{1});
        par(2)=eval(answ{2});
        range(1)=eval(answ{3});
        range(2)=eval(answ{4});
        range(3)=eval(answ{5});
    case 2 
        promptcg1={'Mean' 'Min x' 'Max x' 'dx'};
        defacg1={'1','-5' '5' '0.01'};
        answ=inputdlg(promptcg1,'Parameters',1,defacg1);
        par=eval(answ{1});
        range(1)=eval(answ{2});
        range(2)=eval(answ{3});
        range(3)=eval(answ{4});
    case 3
        promptcg1={'Degrees of freedom' 'Min x' 'Max x' 'dx'};
        defacg1={'6','-5' '5' '0.01'};
        answ=inputdlg(promptcg1,'Parameters',1,defacg1);
        par=eval(answ{1});
        range(1)=eval(answ{2});
        range(2)=eval(answ{3});
        range(3)=eval(answ{4});
    case 4
        promptcg1={'Inferior limit' 'Superior limit' 'Min x' 'Max x' 'dx'};
        defacg1={'0','1','-5' '5' '0.01'};
        answ=inputdlg(promptcg1,'Parameters',1,defacg1);
        par(1)=eval(answ{1});
        par(2)=eval(answ{2});
        range(1)=eval(answ{3});
        range(2)=eval(answ{4});
        range(3)=eval(answ{5});
end

pdf=gd_pdf(listpdf1{selpdf},par,range);
