function d=ds(a)
%DS ds (data stream) class constructor
%
%      d=ds(a)  -> a is the length
%
%  Data members
%
%    tini1   time of the first sample of y1
%    tini2   time of the first sample of y2
%    dt      sampling time
%    len     length of chunks
%    y1      odd chunk (last chunk if not interlaced) OCCUPIES len*5/4
%    y2      even chunk (last but one chunk if not interlaced)
%    ind1    index of y1
%    ind2    index of y2
%    type    type (=0 -> not interlaced no last but one,
%                  =1 -> not interlaced, =2 -> interlaced)
%    nc1     number of y1 chunk
%    nc2     number of y2 chunk
%    lcw     last chunk written ("produced")
%    lcr     last chunk read ("served" - for client-server use)
%    totdat  total data
%    treq    time requested (to start)
%    capt    caption
%    cont    control variable
%    verb    verbosity (1 default, 0 no verb)
%
%  Operation
%
% The basic idea is the client-server metaphor: the client asks for
% chunks of data, defining at the beginning the modalities and then
% calling iteratively the server. 
% There are three fundamental operations:
%
%  - initial setting, in which a ds is created and the modalities of the
%    data service are defined. This is done mainly by the methods 
%    ds (the constructor) and edit_ds (a modifier).
%    At this stage the fundamental constants of the ds are set:
%       - len    the length of the chunks
%       - type   the type (1 (the default): last data in y1, last data but
%                one in y2, 2 : interlaced by the half, alternate y1, y2,
%                0 : only last data in y1)
%       - dt     the sampling time
%       - capt   the caption
%       - treq   the requested beginning time
%    these parameters 
%    Then some variables are initialized:
%       - nc1 = 0    serial number of y1 chunks
%       - nc2 = 0    serial number of y2 chunks
%       - lcw = 0    last chunk written ("produced")
%       - lcr = 0    last chunk read ("served" - for client-server use)
%       - ind1 = 1   index of y1 (for particular uses)
%       - ind2 = 1   index of y2 (for particular uses)
%       - cont = 0   control variable (for particular uses)
%       - tini1 = -d.len*d.dt   sometimes necessary
%    A particular method is reset_ds, that resets the variables to the
%    initial values.
%
%  - ds servicing, that is done by particular methods that carry out the ds
%    server operation. Examples are
%       - data simulation servers, as 
%              - signal_ds   creates continuous signals (sinusoid, ramp,...)
%              - noise_ds    simulates a noise of given power spectrum
%       - data access servers, as
%              - r872ds      access data in r87 format
%              - fr2ds       access data in frames format
%              - snf2ds      access data in snf (ds, mds) format
%       - other, as
%              - gd2ds       creates a ds from a "long" gd
%    A ds server has the duty to set ds variables (except lcr and cont).
%
%  - client processing, that is done by functions that operates on the
%    chunks served by a ds server. Examples are
%       - pows_ds,ipows_ds,    compute running power spectrum, with
%         ipows_ds_ng          different characteristics
%       - running_ds           running plot
%       - stat_ds              running statistics
%    Typically a client ds processor works independently of the type of
%    ds server.
%
% Besides the three basic operations, there is another important type of
% operation, that is the
%
%  - ds transformation, performed by a ds transformer that has both the 
%    characteristics of a ds server and of a client processor. Examples are
%       - to_interlace_ds      trasforms a type 1 ds to a type 2 ds
%       - de_interlace_ds      trasforms a type 2 ds to a type 1 ds
%       - ffilt_go_ds          creates from a ds a frequency domain filtered
%                              ds
%    A ds transformer has the same "duties" of a ds server, for the generated
%    ds.

% Version 1.0 - July 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if isa(a,'double')
   d.tini1=-a;
   d.tini2=-a;
   d.dt=1;
   d.len=a;
   d.y1=zeros(1,ceil((d.len*5)/4));
   d.y2=zeros(1,d.len);
   d.ind1=1;
   d.ind2=1;
   d.type=1;
   d.nc1=0;
   d.nc2=0;
   d.lcw=0;
   d.lcr=0;
   d.treq=0;
   d.totdat=0;
   d.capt='default interlaced';
   d.cont=0;
   d.verb=1;
   d=class(d,'ds');
elseif isa(a,'ds')
   d=a;
   d.ind1=1;
   d.ind2=1;
   d.type=1;
   d.nc1=0;
   d.nc2=0;
   d.lcw=0;
   d.lcr=0;
   d.treq=0;
   d.totdat=0;
   d.cont=0;
else
   error('ds class constructor error');
end
