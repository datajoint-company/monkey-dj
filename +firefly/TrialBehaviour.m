%{
# Single-trial behavioural data (stimulus parameters and continuous behavioural variables)
-> firefly.Behaviour
-> firefly.Event
-> firefly.AnalysisParam
trial_number=1              : int           # trial number
---
# add additional attributes
floor_den=0                 : double        # density of the ground plane [a.u]     
v_max=0                     : double        # maximum forward speed [cm/s]     
w_max=0                     : double        # maximum angular speed [deg/s]
v_gain=0                    : double        # forward speed joystick gain
w_gain=0                    : double        # angular speed joystick gain
ptb_linvel=0                : double        # amplitude of forward perturbation [cm/s]     
ptb_angvel=0                : double        # amplitude of angular perturbation [deg/s] 
ptb_delay=0                 : double        # timing of ptb from max(targ onset, move onset) [s]    
firefly_on=0                : double        # firefly on throughout the trial? [1/0]      
landmark_lin=0              : double        # linear landmark (concentric circ on ground)? [1/0]    
landmark_ang=0              : double        # angular landmark (mountainous bg)? [1/0]      
landmark_fixedground=0      : double        # ground plane elements not refreshed? [1/0]     
replay=0                    : double        # stimulus was replayed? [1/0]   
stop2feedback_intv=0        : double        # interval between stopping and feedback [s]
intertrial_intv=0           : double        # interval between trials [s]
reward_duration=0           : double        # quantity of reward [ms]
attempted=0                 : double        # attempted trial? [1/0]
rewarded=0                  : double        # rewarded trial? [1/0]
perturbed=0                 : double        # perturbation in trial? [1/0]
spurious_targ=0             : double        # target was misplaced? [1/0]

leye_horpos=null            : longblob      # left eye hor. position [deg]
leye_verpos=null            : longblob      # left eye ver. position [deg]
leye_torpos=null            : longblob      # left eye tors. position [deg]
reye_horpos=null            : longblob      # right eye hor. position [deg]
reye_verpos=null            : longblob     	# right eye ver. position [deg]
reye_torpos=null            : longblob      # right eye tors. position [deg]
pupildia=null               : longblob      # pupil diameter [a.u]
head_horpos=null            : longblob      # head hor. position [deg]
head_verpos=null            : longblob      # head ver. position [deg]
head_torpos=null            : longblob      # head tors. position [deg]
joy_linvel=null             : longblob      # forward velocity [cm/s]
joy_angvel=null             : longblob      # angular velocity [deg/s]
firefly_x=null              : longblob      # firefly x position [cm]
firefly_y=null              : longblob      # firefly y position [cm]
monkey_x=null               : longblob      # monkey x position [cm]
monkey_y=null               : longblob      # monkey y position [cm]
monkey_xtraj=null           : longblob      # monkey smooth x position [cm]
monkey_ytraj=null           : longblob      # monkey smooth y position [cm]
monkey_phitraj=null         : longblob      # monkey smooth orientation [deg]
dist2firefly_x=null         : longblob      # x distance to firefly [cm]
dist2firefly_y=null         : longblob      # y distance to firefly [cm]
dist2firefly_r=null         : longblob      # distance to firefly [cm]
dist2firefly_th=null        : longblob      # angle to firefly [deg]
hand_x=null                 : longblob      # monkey hand x position [pixels]
hand_y=null                 : longblob      # monkey hand y position [pixels]
behv_time=null              : longblob      # time index [s]

behv_tbeg=null              : tinyblob      # time when target appeared
behv_tmove=null             : tinyblob      # time when movement started
behv_tstop=null             : tinyblob      # time when movement ended
behv_trew=null              : tinyblob      # time when reward delivered
behv_tend=null              : tinyblob      # time when trial ended
behv_tptb=null              : tinyblob      # time when perturbation started
behv_tsac=null              : longblob      # time when saccade was made
%}

classdef TrialBehaviour < dj.Computed
    methods(Access=protected)
        function makeTuples(self,key)
            behv_data = fetch(firefly.Behaviour &...
                ['session_id = ' num2str(key.session_id)] & ['monk_name = ' '"' key.monk_name '"'],'*');
            event_data = fetch(firefly.Event &...
                ['session_id = ' num2str(key.session_id)] & ['monk_name = ' '"' key.monk_name '"'],'*');
            stimulusprs = fetch(firefly.StimulusParam,'*');
            analysisprs = fetch(firefly.AnalysisParam,'*');
            
            trials = SegmentBehaviouralData(behv_data,event_data,analysisprs,stimulusprs);
            selfAttributes = {self.header.attributes.name}; % think self.header.attributes.name is internal to dj
            ntrials = numel(trials);
            for j=1:ntrials
                key.trial_number = j;
                for i=1:length(selfAttributes)
                    if any(strcmp(fields(trials(j)),selfAttributes{i}))
                        key.(selfAttributes{i}) = trials(j).(selfAttributes{i});
                    end
                end
                self.insert(key);
            end            
            fprintf('Populated trial-by-trial behavioural data for experiment done on %s with monkey %s \n',...
                key.session_date,key.monk_name);
        end
    end
end