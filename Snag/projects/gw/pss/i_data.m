function data=i_data
%I_DATA  interactive parameter choice
%
%   data             requested data structure
%       .n           chunk length
%       .dt          sampling time
%       .t0          starting time (TAI seconds; for amplitude and frequency)
%       .t           time of the first data of the chunk (TAI seconds)
%       .type        =1 normal, =2 interlaced
%

data.n=16384;
data.dt=2.5e-4;
data.t0=53005;
data.type=1;

prompt={'Chunk length' 'Sampling time' 'Starting time' 'Type (1 norm, 2 interl.'};
default={num2str(data.n),num2str(data.dt),num2str(data.t0),num2str(data.type)};

answ=inputdlg(prompt,'Data parameters',1,default);

data.n=eval(answ{1});
data.dt=eval(answ{2});
data.t0=eval(answ{3});
data.type=eval(answ{4});

data.t=data.t0;
