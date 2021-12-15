% crea_fakesource_file

sourstr(1).N=100;
sourstr(1).fr=[50,1050];
sourstr(1).sd1=[0,0];
sourstr(1).sd2=[0,0];
sourstr(1).amp=[0.0001,1];
sourstr(1).eps=[0,0];
sourstr(1).psi=[0,0];
sourstr(1).alpha=[0,360];
sourstr(1).delta=[-90,90];

years=2000;
sourstr(2).N=400;
sourstr(2).fr=[50,1050];
sourstr(2).sd1=[0,1050/(years*365.2445)];
sourstr(2).sd2=[0,0];
sourstr(2).amp=[0.0001,0.5];
sourstr(2).eps=[0,0];
sourstr(2).psi=[0,0];
sourstr(2).alpha=[0,360];
sourstr(2).delta=[-90,90];

fcand=pss_creasourcefile(sourstr);