% Snag commands
%
%   snag         - snag command/monitor window; see Snag_ML.doc
%   moresnag     - snag secondary command window
%
%   snag_local_symbols  - locally defined symbols 
%   snag_path           - to set locally the snag paths (may be not necessary)
%   snag_preferences    - snag particular settings (not mandatory)
%
%  General analysis:
%
%   da_plot      - plots double arrays
%   da_stat      - statistics for double array
%   mp_plot      - multiple plot (for mp structures)
%   mp_stat      - multiple statistics (for mp structures)
%   mp_proc      - processing for mp structures
%   histoint     - integral histogram of an array
%   gd_histoint  - integral histogram of a gd
%   gd_plot      - plots gds
%   gd_cplot     - plots for complex gds
%   gd_stat      - statistics of gds
%   ginproc      - graphical input processing (used by ginmenu)
%
%  Analysis (in /analysis):
%
%   analysis/gd_acorfft   - fft autocorrelation or autocovariance
%   analysis/gd_crcorfft  - fft cross-correlation or cross-covariance
%   analysis/atan3        - atan3 (double)
%   analysis/gd_atan3     - atan3 (gd)
%   analysis/gd_pows      - power spectrum
%   analysis/gd_worm      - worm analysis
%   analysis/gd_hilb      - analytical signal
%
%   analysis/ffilt_open_ds - opens dss to contain filter outputs
%   analysis/ffilt_ds      - filtering a ds
%   analysis/set_ff_struct - sets an ff_struct 
%
%   analysis/event_finder - two states event finder machine
%   analysis/event_finder_fast - compiled two states event finder machine (for PC)
%
%  Processing:
%
%   gd_smooth    - smooths a gd
%   gd_play      - "plays" a gd
%   spvignette   - vignetting for frequency domain data
%   tdwin        - transformed domain windowing
%   vignette     - data vignetting
%   dyn_compr    - dynamics compression
%   dyn_compr_2d - dynamics compression for gd2s
%   pre_log      - adjusts data before a logarithm
%   pre_sqrt     - adjusts data before a square root
%   uniresamp    - uniform resampling
%
%  Settings:
%
%   gd_sin        - draws a sinusoids
%   igd_sin       - interactive access to gd_sin
%   gd_exp        - draws a (complex) exponential
%   igd_exp       - interactive access to gd_exp
%   gd_delt       - draws deltas
%   igd_delt      - interactive access to gd_delt
%   gd_ramp       - draws ramps
%   igd_ramp      - interactive access to gd_ramp
%   gd_pol        - draws polinomials
%   igd_pol       - interactive access to gd_pol
%   gd_noise      - random signals
%   igd_noise     - interactive access to gd_noise
%   gd_poisson    - Poisson processes
%   o1proc_gd     - first order process
%   o2proc_gd     - second order process 
%   gd_drawspect  - draws a spectrum
%   pswindow      - creates a (double array) window for power spectrum estimation
%   cmrw          - complex Markov random walk
%   mrw           - Markov random walk
%
%  Service:
%
%   axesdlg    - ui dialog for axes limits
%   histdlg    - ui dialog for histogram parameters
%   ginmenu    - adds a graphical input processing menu to a figure
%   gintext    - adds interactively a text to a figure
%   ginpowsds  - dialog box for pows_ds
%   ginhistds  - dialog box for hist_ds
%
%   bselect    - binary selection
%   half2fullspec - creates a full (hermitian) spec from half spec
%   indsel     - index for uniform abscissa for a given value
%   rota       - rotates a vector
%   rotcol     - associates colors to integer numbers
%   selfile    - file selection with gui
%   showol     - shows an object list structure
%   tostairs   - creates a stair [X,Y] from [x,y]
%   testcomplex - tests if a double array is complex or real
%   thresh     - threshold function
%   us2minus   - changes underscores to minus signs in strings
%
%   readascii  - reads an ASCII file to a vector
%   ireadascii - interactive access to readascii
%   run_m_file - runs an m file
%   irun_m_file - interactive access to run_m_file
%
%   printps    - prints the last graphic on a postscript file
%   printeps2  -
%   printps2   -
%   printbmp   -
%
%  Special m-files:
%
%   creagd     - creates a gd
%   deletegd   - deletes a gd
%   listdoublearray - sets the structure containing the double array list
%   listds     - sets the structure containing the ds list
%   listgd     - sets the structure containing the gd list
%   listgd2    - sets the structure containing the gd2 list
%   showgdolset - creates the show-list showgdol of the gds
%   showgdol2set - creates the show-list showgdol2 of the gd2s
%   showgdoltot - creates the show-list showgdol of the gds and gd2s
%   newgdgui   - a gui to create new gds
%   uiapplication - choice of snag applications
%   uidemo     - choice of snag demos
%   uiinputfile - gui for input file
%   uiproc1gd  - processing of a single gd
%   uiproc2gd  - processing based on two gd
%   uisetgd    - creates and sets a gd
%   uisetgdnoise - gui to set gds
%
%----------------------------------------------------------------------------
%
%  Demos
%
%   demo/somegd       - creates some gds
%   demo/biggd        - creates a big gd from a ds
%   demo/rsdo         - double oscillator using rs
%
%   demo/dsnoistat    - running statistics for the Virgo antenna
%   demo/dsnoistat1   - running statistics for the Virgo antenna (onlylast)
%   demo/dsnoistat2   - running statistics for the Virgo antenna with comb
%
%   demo/dsnoisound   - sound of the Virgo antenna
%   demo/dsnoisound1  - sound of the Virgo antenna with comb
%
%   demo/dsnoispows   - running power spectrum for the Virgo antenna
%   demo/dsnoispows1  - running power spectrum for the Virgo antenna with comb
%   demo/dsnoispows2  - running power spectrum for the Virgo antenna with comb
%                        no windowing
%   demo/dssigstat    - running statistics for white noise (total)
%   demo/dssigstat2   - running statistics for white noise (ar)
%
%   demo/dssigsound   - white noise sound
%
%   demo/dssigpows1   - running power spectrum of white noise
%
%   demo/dsrunning    - running plot for Virgo noise
%   demo/dsrunning1   - running plot for Virgo noise with comb
%
%   demo/dsnoispowsexp    - running power spectrum for explorer data
%   demo/dsnoispowsexp3d  - 3-D power spectrum for explorer data
%   demo/dsnoispowsligo   - running power spectrum for explorer data
%   demo/dsnoispowslig3d  - 3-D power spectrum for explorer data
%
%   demo/dsrunningline    - use of running_ds with noise_ds
%   demo/dsrunninglinea   - use of running_ds with noisea_ds
%
%----------------------------------------------------------------------------
%
%  Gravitational Waves (in \gw)
%
%   gw/gd_chirp  - chirp
%   gw/igd_chirp - interactive access to gd_chirp
%   gw/gd_drpp   - b.h.  Davis,Ruffini,Press & Price
%   gw/gw_pulse  - some different gravitational wave pulses
%   gw/igw_pulse - interactive access to gw_pulse
%
%   gw/doppler     - computation of Doppler shift on a frequency
%   gw/earth_v0    - rough estimation of Earth velocity
%   gw/snag_tsid   - sidereal time
%   gw/astro_coord - astronomical coordinate conversion,
%   gw/doppler_jpl - computation of Doppler effect with the jpl data
%   gw/idoppler_jpl - interactive access to doppler_jpl
%
%   gw/mjd2s     - conversion mjd to string time
%   gw/mjd2v     - conversion mjd to vectorial time
%   gw/s2mjd     - conversion string time to mjd
%   gw/v2mjd     - conversion vectorial time to mjd
%   gw/day2doy   - converts a day to a doy (day of the year)
%   gw/doy2day   - converts a doy to a day
%   gw/vdoy2day  - converts vectorial doy time to vectorial time
%   gw/fastvdoy2day  - "fast" conversion of vectorial doy time to vectorial time
%   gw/gps2mjd   - converts gps time to mjd
%
%   gw/gw_ana    - gui for gravitational antenna data analysis
%   gw/gw_sim    - gui for gravitational antenna data simulation
%
%----------------------------------------------------------------------------
%
%  Frames and R87 analysis
%
%   frames/fr2gd      - creates a gd from a frame file
%   frames/r872gd     - creates a gd from an R87 file
%   frames/gen2gd     - creates a gd from a general format
%
%   frames/frextract   - interactive frame access (c mex file, by B. Mours)
%   frames/frexsnag    - interactive frame access (by R. Ruffato)
%   frames/frexsnag_ac - infos about adc and channels
%   frames/t0sdecode   - decodes time string
%
%   frames/fr_fildatsel  - selects interactively a frame, R87 or matlab data file 
%   frames/fr_selch      - selects a channel
%   frames/fr_open       - opening a frame, R87 or matlab file
%   frames/fr_gods       - asks a ds servicing
%   frames/gen_pows      - general running power spectra analysis
%   frames/gen_pows3d    - general 3D power spectra analysis
%   development/dif_pows3d    - differential 3D power spectra analysis
%
%   frames/inifr2ds   - creates a ds and an rg for use of fr2ds or r872ds
%   frames/fr_even    - interactive event search for frames
%   frames/fr_pows    - interactive running power spectrum for frames
%   frames/fr_run     - interactive running data display for frames
%   frames/fr_stat    - interactive statistics for frames
%
%   frames/open_r87         - open an r87 file
%   frames/read_header_r87  - reads an R87 header
%   frames/read_r87         - reads an R87 record
%   frames/read_r87_ch      - reads a channel in an R87 record
%   frames/read_r87_noout   - reads an r87 file without output data
%   frames/r87_summary      - summary for an R87 file
%   frames/r87_summary_fast - summary for an R87 file, without the time errors
%
%   frames/fmnl_dict              - creates a dictionary for frames structures
%   frames/fmnl_explore           - explores a frame file
%   frames/fmnl_iexplore          - interactive access to fmnl_explore
%   frames/fmnl_getch             - gets the data for a channel
%   frames/fmnl_getchinfo         - gets the info for a channel
%   frames/fmnl_getchmp           - gets data for multiple channels
%   frames/fmnl_imp               - interactive multiple channel plot for fmnl
%   frames/fmnl_open              - open a file or a sequence of files 
%   frames/fmnl_read_file_header  - reads a file header for frame files
%   frames/fmnl_read_string       - reads a string in frame format
%   frames/fmnl_read_struct       - reads a structure in frame format
%   frames/fmnl_reopen            - close an ended file and opens a new one
%   frames/fmnl_selch             - channel selection for frames
%
%   frames/do_files0 - creates a file containing the file list, to be edit
%   frames/do_files1 - creates a files db of tipe fmnl_files1.dat
%
%----------------------------------------------------------------------------
%
%  snf - Snag Format
%
%   snf/browse_snf       - browse snf files and show the parameters
%   snf/r_s_show         - shows an r_struct
%
%   snf/read_snf_header  - reads the header of an snf file
%   snf/test_snf_format  - tests the format of the snf file
%   snf/read_snf_gd      - read an snf file containing a gd or gd2
%   snf/iread_snf_gd     - interactive access to read_snf_gd
%   snf/open_snf_read    - opens an snf file to read (for ds or mds)
%   snf/read_snf_ds      - reads an snf file containing a ds or mds
%   snf/test_dsread      - read test
%
%   snf/write_snf_header - writes the header of an snf file
%   snf/write_snf_gd     - writes an snf file with a gd or gd2
%   snf/iwrite_snf_gd    - interactive use of write_snf_gd
%   snf/open_snf_write   - opens an snf file to write (for ds or mds)
%   snf/write_snf_ds     - writes an snf file with a ds or mds
%   snf/test_dswrite     - write test
%
%   snf/set_cont         - settings for continuos file access (not only for snf)
%
%----------------------------------------------------------------------------
%-------------------- Applications ------------------------------------------
%
%      Data_Browser: access to the gw data and simulation
%
%   data_browser   - gui access to Data_Browser functions (alias db)
%
%   d_b_selaccess  - access selection (by file or by time)
%   d_b_timeaccess - choices for time access
%   d_b_procmenu   - access to the processing menu
%   d_b_show       - shows the status of the Data_Browser
%   go_db          - starts Data_Browser processing
%
%   d_b_dtfpows    - time-frequency innovation spectrum
%   d_b_rhist      - running histogram
%   d_b_rplot      - running plot
%   d_b_rpows      - running power spectrum
%   d_b_tfpows     - time-frequency spectrum
%   d_b_dtfpows    - innovation time-frequency spectrum
%   d_b_evfind     - event finder
%
%   ffilt_open_ds  - opens ds for frequency domain adaptive filtering output
%   set_ff_struct  - initializes a ff_struct
%
%   filters/white1  - whitening filter
%   filters/wiener1 - wiener filter
%
%----------------------------------------------------------------------------
%
%     GW_Sim: fine simulation of gravitational antenna data
%
%   gw/gw_sim      - gui access
%
%----------------------------------------------------------------------------
%----------------------- Classes --------------------------------------------
%
%       Class gd (group of data)
%
% gd class methods
%
%   gd/gd         - gd class constructor
%
%  Extractors:
%
%   gd/x_gd        - extract gd.x
%   gd/y_gd        - extract gd.y
%   gd/n_gd        - extract gd.n
%   gd/ini_gd      - extract gd.ini
%   gd/dx_gd       - extract gd.dx
%   gd/type_gd     - extract gd.type
%   gd/capt_gd     - extract gd.capt
%   gd/cont_gd     - extract gd.cont
%
%  Modifiers:
%  
%   gd/edit_gd      - edits gds
%   gd/set_gd       - sets gds
%   gd/w_gd         - writes in a gd.y section
%   gd/multy2gd_gd  - from many doubles to a gd
%
%  Processing
%
%   gd/abs_gd       - absolute value
%   gd/abscout_gd   - creates a gd with the abscissa of the input gd
%   gd/deri_gd      - derivative
%   gd/exp_gd       - exponential
%   gd/ffilt_gd     - frequency domain filter
%   gd/gd_gdabsc    - creates a gd with gd1 ordinate as abscissa
%                     and the gd2 as ordinate
%   gd/getabsc      - creates a gd with the abscissa of gd1 and the
%                     ordinate of gd
%   gd/imag_gd      - imaginary part
%   gd/inte_gd      - integral
%   gd/log_gd       - log
%   gd/ltabsc_gd    - linear transformation of the abscissa
%   gd/maximum_gd   - maximum between two gds
%   gd/minimum_gd   - minimum between two gds
%   gd/phase_gd     - phase
%   gd/poli_gd      - polinomial of a gd
%   gd/poliabsc_gd  - polinomial transformation on the abscissa
%   gd/power_gd     - power
%   gd/psd_gd       - lock-in
%   gd/real_gd      - real part
%   gd/rota_gd      - gd rotation
%   gd/sel_gd       - selection on amplitude, index, abscissa
%   gd/sin_gd       - sine
%   gd/tfilt_gd     - time domain filter
%   gd/dyn_compr_gd - dynamical compression
%
%  Overloaded operators and functions:
%
%   gd/plus        -  +
%   gd/minus       -  -
%   gd/times       -  *
%   gd/rdivide     -  /
%   gd/mtimes      -  *
%   gd/mrdivide    -  /
%   gd/double      -  extracts gd.y
%
%  Other:
% 
%   gd/display     -  show gd
%
%----------------------------------------------------------------------------
%
%       Class gd2 (group of data - two dimension)
%
%       child of gd
%
% gd2 class methods
%
%   gd2/gd2         - class constructor
%
%   gd2/y_gd2       - extracts the matrix from a gd2
%   gd2/n_gd2       - extracts the n
%   gd2/m_gd2       - extracts the m
%   gd2/ini_gd2     - extracts the ini
%   gd2/ini2_gd2    - extracts the ini2
%   gd2/dx_gd2      - extracts the dx
%   gd2/dx2_gd2     - extracts the dx2
%   gd2/dx2_type    - extracts the type
%   gd2/x_gd2       - extracts the x
%
%   gd2/find_gd2    - find on a sparse matrix gd2
%   gd2/findtr_gd2  - find on a transposed sparse matrix gd2
%   gd2/get_gd2_vdetect - gets the auxiliary variables for 
%                         detector velocity (SFDB)
%   gd2/set_gd2_vdetect - sets the auxiliary variables for 
%                         detector velocity (SFDB)
%
%   gd2/edit_gd2      - class members modifier
%   gd2/log_gd2       - creates a gd2 logarithm of a gd2
%   gd2/dyn_compr_gd2 - dynamics compression for a gd2
%
%   gd2/peak_gd2        - finds peaks in a gd2
%   gd2/peak_gd2_sparse - finds peaks in a gd2, creating a sparse gd2
%
%   gd2/imap_gd2   - simplified map of a gd2
%   gd2/cmap_gd2   - contourf map of a gd2
%   gd2/map_gd2    - general maps a gd2
%
%----------------------------------------------------------------------------
%
%       Class ds (data stream)
%
% ds class methods
%
%   ds/ds         - class constructor
%
%  Extractors:
%
%   ds/capt_ds     - extracts capt
%   ds/dsc2gd_ds   - gets a gd from a ds chunk
%   ds/dt_ds       - extracts dt
%   ds/len_ds      - extracts len
%   ds/type_ds     - extracts type
%   ds/y1_ds       - extracts y1
%   ds/y2_ds       - extracts y2
%   ds/y_ds        - gets a double from a ds
%   ds/tini1_ds    - extracts tini1
%   ds/tini2_ds    - extracts tini2
%
%  Modifiers:
%
%   ds/edit_ds        - edits a ds
%   ds/reset_ds       - resets a ds
%
%  Sources:
%
%   ds/signal_ds     - source of signals
%   ds/noise_ds      - source of noises using cosine tapered method
%   ds/noisea_ds     - source of noises using interlaced input noise method
%   ds/gd2ds         - a ds from a (long) gd
%   ds/fr2ds         - a ds from a frame file (using fmnl)
%   ds/fr2ds-fl      - a ds from a frame file (using framelib)
%   ds/r872ds        - a ds from an R87 file
%   ds/snf2ds        - a ds from an snf file
%
%  Processing:
%
%   ds/to_interlace_ds  - creates an interlaced ds from a non-interlaced one
%   ds/de_interlace_ds  - creates a non-interlaced ds from an interlaced one
%   ds/frfilt_ds        - frequency domain filtering
%   ds/ffilt_go_ds      - frequency filtering of a type 1 ds
%
%  Analysis
%
%   ds/pows_ds       - running power spectrum
%   ds/ipows_ds      - interactive power spectrum
%   ds/ipows_ds_ng   - interactive power spectrum without graphic output
%   ds/running_ds    - running plot
%   ds/stat_ds       - running statistical analysis
%
%  Other:
%
%   ds/display_ds     - displays a ds
%
%----------------------------------------------------------------------------
%
%       Class rs (resonance set)
%
% rs class methods
%
%   rs/rs          - class constructor
%
%   rs/set_rs      - sets rs variables
%   rs/harmonic_rs - sets an rs for harmonic frequencies
%
%   rs/get_rs      - gets rs parameters
%   rs/display_rs  - displays an rs
%
%   rs/run_rs      - runs an rs
%
%----------------------------------------------------------------------------
%
%       Class rg (ring structure)
%
% rg class methods
%
%   rg/rg         - class constructor
%
%   rg/write_rg   - writes data in a rg
%   rg/read_rg    - reads data from a rg
%
%   rg/totin_rg   - extracts totin
%   rg/totout_rg  - extracts totout
%   rg/setdx_rg   - sets the dx 
%
%----------------------------------------------------------------------------
%
%       Class am (ARMA filter)
%
% am class methods
%
%   am/am         - class constructor (partially interactive)
%
%   am/na_am      - na extractor
%   am/nb_am      - nb extractor
%   am/a_am       - a extractor
%   am/b_am       - b extractor
%   am/b0_am      - b0 extractor
%   am/bilat_am   - bilat flag extractor
%   am/capt_am    - capt extractor
%   am/cont_am    - cont extractor
%
%   am/display    - class display

% Version 1.0 - November 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1998,1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome


