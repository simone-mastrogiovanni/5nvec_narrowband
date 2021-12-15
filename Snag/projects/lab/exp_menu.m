function [out chs]=exp_menu()
% menu for some physical experiments
%
%   out=exp_menu()
%
%   k    experiment number (menu if absent)

% Version 2.0 - June 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

out={};
check=3;
ii=0;

while 1
    ch=menu('Quale esperimento ?','Molla','Carrello','Pendolo fisico','Risonanza','Volano','Generico','Exit');
    ii=ii+1;
    chs(ii)=ch;
    param={};
    switch ch
        case 1
        case 2
        case 3
        case 4
            rispar={'Massa carrello ?','k della molla ?','mu_v ?','beta ?','frequenza ? (0 risp. imp.)','Ampiezza ?',...
                'Tempo di osservazione','Tempo di campionamento'};
            defval={'1','2','0.005','0','0.22','10','200','0.01'}
            answ=inputdlg(rispar,'Parametri risonanza',1,defval);
            param.m=eval(answ{1});
            param.k=eval(answ{2});
            param.muv=eval(answ{3});
            param.beta=eval(answ{4});
            in.fr=eval(answ{5});
            in.A=eval(answ{6});
            param.To=eval(answ{7});
            param.dt=eval(answ{8});
            out{ii}=dyna_sim(param,in,check);
        case 5
        case 6
            rispar={'Massa ?','k (lin, quad, cub, sin) ?','dissip (lin, quad, cub, muv) ?','frequenza ? (0 risp. imp.)','Ampiezza ?',...
                'Tempo di osservazione','Tempo di campionamento'};
            defval={'1',sprintf('2 \n0\n0\n0'),sprintf('0.1 \n0\n0\n0'),'0.22','10','200','0.01'}
            answ=inputdlg(rispar,'Parametri ',[1 4 4 1 1 1 1],defval);
            param.m=eval(answ{1});
            kk=str2num(answ{2});
            param.k=kk(1);
            param.k2=kk(2);
            param.k3=kk(3);
            param.sin=kk(4);
            diss=str2num(answ{3});
            param.beta=diss(1);
            param.beta2=diss(2);
            param.beta3=diss(3);
            param.muv=diss(4);
            in.fr=eval(answ{4});
            in.A=eval(answ{5});
            param.To=eval(answ{6});
            param.dt=eval(answ{7});
            out{ii}=dyna_sim(param,in,check);
        otherwise
            return
    end
end
