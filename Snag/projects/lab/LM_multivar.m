function mult=LM_multivar(mult)
% LM_MULTIVAR  simulazione e analisi variabili multi-variate
%
%     mult=LM_multivar(mult)
%    
%        .par    [mux muy sigx sigy ro]
%        .f      distribuzione (solo in output)
%        .minx   minimo per l'istogramma
%        .maxx   massimo per l'istogramma
%        .miny   minimo per l'istogramma
%        .maxy   massimo per l'istogramma
%        .N      numero bin dell'istogramma [x y]
%        .h      istogramma
%        .ndef   numero lanci da simulare (in aggiunta)
%        .ntot   numero lanci simulati
%        .hfig   handle alla figura
%        .chiq   chi quadro
%        .gdl    gradi di libertà
%        .prob   probabilità chi quadro
%        .M      numero di ripetizioni (>1 no plot singolo)
%

% Project LabMec - part of the toolbox Snag - July 2008
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('mult','var')
    icbin=0;
else
    icbin=1;
end

if icbin == 0
    mult.tipo='gaus';
    mult.par=[0 0 1 1 0.6];
    mult.minx=-5;
    mult.maxx=5;
    mult.miny=-5;
    mult.maxy=5;
    mult.N=[50 50];
    mult.h(1:mult.N)=0;
    mult.ndef=100;
    mult.ntot=0;
    mult.M=1;
end

MU=[mult.par(1) mult.par(2)];
rr=mult.par(5)*mult.par(3)*mult.par(4);
SIGMA=[mult.par(3).^2 rr; rr mult.par(4).^2];

if mult.M == 1
    lanci=mvnrnd(MU,SIGMA,mult.ndef);
    figure,plot(lanci(:,1),lanci(:,2),'+'),grid on

    mult.media=mean(lanci);
    mult.std=std(lanci);
    cc=corr(lanci);
    mult.corr=cc(1,2);

    figure,hist3(lanci,mult.N)
    [mult.H mult.X]=hist3(lanci,mult.N);
    figure,image(100*mult.H/max(max(mult.H)))
else
    mult.media=zeros(mult.M,2);
    mult.std=mult.media;
    mult.corr=zeros(mult.M,1);
    for i = 1:mult.M
        lanci=mvnrnd(MU,SIGMA,mult.ndef);
        mult.media(i,:)=mean(lanci);
        mult.std(i,:)=std(lanci);
        cc=corr(lanci);
        mult.corr(i)=cc(1,2);
    end
    figure,hist(mult.corr,50)
    figure,hist(mult.media,500)
    figure,hist(mult.std,500)
end

