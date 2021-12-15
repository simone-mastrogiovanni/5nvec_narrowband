function labmenu(h0)
%LABMENU  activates the lab input menu

% Project LabMec - part of the toolbox Snag - April 2008
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

contmenuh=uimenu(h0,'label','Lab');

uimenu(contmenuh,'label','valore','callback','ginproc(''value'');');
uimenu(contmenuh,'label','distanza','callback','ginproc(''distance'');');
uimenu(contmenuh,'label','pendenza','callback','ginproc(''slope'');');
uimenu(contmenuh,'label','"pendenza esponente"','callback','ginproc(''logslope'');');
uimenu(contmenuh,'label','"tau pendenza"','callback','ginproc(''ylogslope'');');
uimenu(contmenuh,'label',' ');
uimenu(contmenuh,'label','pend. espon. a 3 punti','callback','ginproc(''3pexpsl'');');
uimenu(contmenuh,'label','cerchio a 3 punti','callback','ginproc(''3pcircle'');');
uimenu(contmenuh,'label','fit polinomiale fit polinomiale','callback','ginproc(''polyfit'');');
uimenu(contmenuh,'label','y-log','callback','ginproc(''pfylog'');');
uimenu(contmenuh,'label','fit polinomiale log-log','callback','ginproc(''pfloglog'');');
uimenu(contmenuh,'label',' ');
uimenu(contmenuh,'label','nuovi dati','callback','[t,s,dt,n]=leggi_pasco;eval(gdcom)');