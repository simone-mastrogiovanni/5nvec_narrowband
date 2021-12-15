% an_pasco_polyfit

% Project LabMec - part of the toolbox Snag - May 2008
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

[t,s,dt,n]=leggi_pasco;

% answ=inputdlg('Incertezza sulle misure ?');
% unc=eval(answ{1});
unc=0.001

data=data_polyfit(t,s,unc,0);

for i = 1:length(data)
    disp('____________________________________')
    str=sprintf(' pezzo %d  coefficienti ',i);
    for j = 1:length(data(i).a)
        str1=sprintf(' %f,  ',data(i).a(j));
        str=[str str1];
    end
    disp(str)
    
    str=sprintf('             incertezze ',i);
    for j = 1:length(data(i).a)
        str1=sprintf(' %f,  ',data(i).aunc(j));
        str=[str str1];
    end
    disp(str)
    
    prob=1-chi2cdf(data(i).chiq,data(i).ndof);
    str=sprintf('    chi quadro %f   N.g.l. %d    probabilità = %f ',...
        data(i).chiq,data(i).ndof,prob);
    disp(str)
    
    str=sprintf('   residui : media e dev. standard = %f  %f ',...
        data(i).meanres,data(i).stdres);
    disp(str)
end