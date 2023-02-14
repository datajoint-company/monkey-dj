%{
# Analysis parameters
analysisparam_id=1              : int               # unique id for this paramater set
---
# list of parameters
dt=0.006                        : float             # time resolution of downsampled data
# behavioural analysis
saccadeduration=0.05            : float             # sec
mintrialsforstats=50            : int
npermutations=50                : int
saccade_thresh=50               : float             # deg/s
saccade_duration=0.15           : float             # sec
v_thresh=5                      : float             # cm/s
w_thresh=3                      : float             # deg/s
v_time2thresh=0.05              : float             # approx time to go from 0 to thresh or vice-versa cm/s
pretrial=0.5                    : float             # sec
posttrial=0.5                   : float             # sec
presaccade=0.5                  : float             # sec
postsaccade=0.5                 : float             # sec
min_intersaccade=0.1            : float             # sec
maxtrialduration=4              : float             # more than this is abnormal (s)
minpeakprom_monkpos=10          : float             # expected magnitude of change in monkey position during teleportation (cm)
minpeakprom_flypos=1            : float             # expected magnitude of change in fly position in consecutive trials (cm)
fixateduration=0.75             : float             # length of fixation epochs (s)
fixate_thresh=4                 : float             # max eye velocity during fixation (deg/s)
movingwin_trials=10             : float             # window for estimating moving average/median bias (number of trials)
blink_thresh=50                 : float             # threshold to remove eye blinks (deg)
nanpadding=5                    : int               # samples
nbootstraps = 100               : int               # number of bootstraps for estimating standard errors
maxrewardwin=400                : int               # maximum window sizefor ROC analysis (cm)
# lfp analysis
lfp_eventtriggerwindow=null     : blob              # [pre-event post-event] to compute event-triggered average(s)
lfp_filtorder=4                 : int
lfp_filt=null                   : blob              # [min max] frequency (Hz)
spectrum_tapers=null            : blob              # [time-bandwidth-product number-of-tapers]
spectrum_trialave=1             : int               # 1 = trial-average
spectrum_movingwin=null         : blob              # [window-size step-size] to compute frequency spectrum (s)
tfspectrum_twinsize=null        : float             # time window size for time-frequency analysis (s)
min_stationary=0.5              : float             # mimimum duration of stationary period for LFP analysis (s)
min_mobile=0.5                  : float             # mimimum duration of mobile period for LFP analysis (s)
lfp_theta=null                  : blob               
lfp_theta_peak=8.5              : float
lfp_beta=null                   : blob 
lfp_beta_peak=18.5              : float
duration_nanpad=1               : int               # nans to pad to end of trial before concatenating (s)
phase_slidingwindow=null        : blob              # time-lags for computing time-varying spike phase (s)
num_phasebins=25                : int               # divide phase into these many bins
# event-aligned PSTH analysis
temporal_binwidth=0.02          : float             # time binwidth for neural data analysis (s)
ts_move=null                    : blob         
ts_target=null                  : blob
ts_stop=null                    : blob
ts_reward=null                  : blob
peaktimewindow=null             : blob              # time-window around the events within which to look for peak response
minpeakprom_neural=2            : float             # min height of peak response relative to closest valley (spk/s)
# correlogram analysis
duration_zeropad=0.05           : float             # zeros to pad to end of trial before concatenating (s)
corr_lag=1                      : float             # timescale of correlograms +/-(s)
# define no. of bins for tuning curves by binning method
tuning_nbins1d_binning=20               : int   # bin edges for tuning curves by 'binning' method
tuning_nbins2d_binning=null             : blob  # define bin edges for 2-D tuning curves by 'binning' method
tuning_nbins1d_knn=null                 : blob
tuning_nbins2d_knn=null                 : blob
tuning_kernel_nw='Gaussian'             : varchar(128) # choose from 'Uniform', 'Epanechnikov', 'Biweight', 'Gaussian'
tuning_bandwidth_nw=null                : blob
tuning_bandwidth2d_nw=null              : blob
tuning_nbins_nw=null                    : blob
tuning_nbins2d_nw=null                  : blob
tuning_kernel_locallinear='Gaussian'    : varchar(128) # choose from 'Uniform', 'Epanechnikov', 'Biweight', 'Gaussian'
tuning_bandwidth_locallinear=null       : blob
tuning_use_binrange=1                   : int
# range of stimulus values [min max]
binrange_v=null                 : blob #cm/s
binrang_w=null                  : blob #deg/s
binrange_r_targ=null            : blob #cm
binrange_theta_targ=null        : blob #cm
binrange_d=null                 : blob #cm
binrange_phi=null               : blob #deg
binrange_h1=null                : blob #s
binrange_h2=null                : blob #s
binrange_eye_ver=null           : blob #deg
binrange_eye_hor=null           : blob #deg
binrange_veye_vel=null          : blob #deg
binrange_heye_vel=null          : blob #deg
binrange_phase=null             : blob #rad
binrange_target_on=null         : blob #s
binrange_target_off=null        : blob #s
binrange_move=null              : blob #s
binrange_stop=null              : blob #s
binrange_reward=null            : blob #s
binrange_spikehist=null         : blob #s
# neuronal analysis
neuron_eventtriggerwindow=null  : blob #s
sta_window=null                 : blob              # time-window of STA
sfc_window=null                 : blob #s
neuralfiltwidth=10              : int # samples
nfolds=5                        : int # number of folds for cross-validation
# decoding analysis
decodertype='lineardecoder'     : varchar(128)  # name of model to fit: linear regression == 'LR'
lineardecoder_fitkernelwidth=0  : int
lineardecoder_subsample=0       : int
n_neurons=null                  : blob          # number of neurons to sample
n_neuralsamples=20              : int           # number of times to resample neurons
%}

classdef AnalysisParam < dj.Lookup
    properties
        contents = {
            1,...
            ...
            0.006,...
            ...
            0.05,50,50,50,0.15,5,3,0.05,0.5,0.5,0.5,0.5,0.1,4,10,1,0.75,4,10,50,5,100,400,...
            ...
            [-1 1],4,[0.5 80],[5 9],1,[1.5 1.5],0.5,0.5,0.5,[6 12],8.5,[12 20],18.5,1,0.05:0.05:2,25,...
            ...
            0.02,-0.5:0.02:3.5,-0.5:0.02:3.5,-3.5:0.02:0.5,-3.5:0.02:0.5,[-0.5 0.5],2,...
            ...
            0.05,1,...
            ...
            20,[20;20],100,[100;100],'Gaussian',[],[],[],[],'Gaussian',[],1,...
            ...
            [0 ; 200],[-90 ; 90],[0 ; 400],[-60 ; 60],[0 ; 400],[-90 ; 90],[-0.36 ; 0.36],[-0.36 ; 0.36],...
            [-25 ; 0],[-40 ; 40],[-15 ; 5],[-30 ; 30],[-pi ; pi],[-0.24 ; 0.48],[-0.36 ; 0.36],...
            [-0.36 ; 0.36],[-0.36 ; 0.36],[-0.36 ; 0.36],[0.006 ; 0.246],...
            ...
            [-1 1],[-1 1],[-0.5 0.5],10,5,...
            ...
            'lineardecoder',0,0,2.^(0:9),20
            }
    end
end