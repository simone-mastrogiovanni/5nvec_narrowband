% I_LM_multivar

answ=inputdlg({'Numero coppie di misure' '    '...
    'mu x' 'mu y' 'sigma x' 'sigma y' 'ro (coeff. di corr.'...
    '    ' 'min x' 'max x' 'min x' 'max x' 'N x' 'N y'...
    },...
    'Parametri distribuzione bivariata',...
    1,{'100' '         Distribuzione' '0' '0' '1' '1' '0.3' '         Istogramma' '-5' '5' '-5' '5' '50' '50'});

mult.ndef=eval(answ{1});
mux=eval(answ{3});
muy=eval(answ{4});
sigx=eval(answ{5});
sigy=eval(answ{6});
ro=eval(answ{7});
mult.minx=eval(answ{9});
mult.maxx=eval(answ{10});
mult.miny=eval(answ{11});
mult.maxy=eval(answ{12});
nx=eval(answ{13});
ny=eval(answ{14});

mult.par=[mux muy sigx sigy ro];
mult.N=[nx ny];
mult.M=1;
mult.ntot=0;
mult.tipo='gaus';

mult.h(1:mult.N)=0;

mult=LM_multivar(mult);