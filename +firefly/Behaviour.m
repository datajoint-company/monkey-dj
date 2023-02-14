%{
# Behavioural data (stimulus parameters, continuous behavioural variables and discrete events)
-> firefly.Session
-> firefly.SessionList
-> firefly.DataAcquisitionParam
---
# add additional attributes
floor_den=null                 : longblob     # density of the ground plane [a.u]
v_max=null                     : longblob     # maximum forward speed [cm/s]
w_max=null                     : longblob     # maximum angular speed [deg/s]
v_gain=null                    : longblob     # forward speed joystick gain
w_gain=null                    : longblob     # angular speed joystick gain
ptb_linvel=null                : longblob     # amplitude of forward perturbation [cm/s]
ptb_angvel=null                : longblob     # amplitude of angular perturbation [deg/s]
ptb_delay=null                 : longblob     # timing of ptb from max(targ onset, move onset) [s]
firefly_on=null                : longblob     # firefly on throughout the trial? [1/0]
landmark_lin=null              : longblob     # linear landmark (concentric circ on ground)? [1/0]
landmark_ang=null              : longblob     # angular landmark (mountainous bg)? [1/0]
landmark_ground=null           : longblob     # ground plane elements not refreshed? [1/0]
replay=null                    : longblob     # stimulus was replayed? [1/0]
stop2feedback_intv=null        : longblob     # interval between stopping and feedback [s]
intertrial_intv=null           : longblob     # interval between trials [s]
reward_duration=null           : longblob     # quantity of reward [ms]

leye_horpos=null               : longblob     # left eye hor. position [deg]
leye_verpos=null               : longblob     # left eye ver. position [deg]
leye_torpos=null               : longblob     # left eye tors. position [deg]
reye_horpos=null               : longblob     # right eye hor. position [deg]
reye_verpos=null               : longblob     # right eye ver. position [deg]
reye_torpos=null               : longblob     # right eye tors. position [deg]
pupildia=null                  : longblob     # pupil diameter [a.u]
head_horpos=null               : longblob     # head hor. position [deg]
head_verpos=null               : longblob     # head ver. position [deg]
head_torpos=null               : longblob     # head tors. position [deg]
joy_linvel=null                : longblob     # forward velocity [cm/s]
joy_angvel=null                : longblob     # angular velocity [deg/s]
firefly_x=null                 : longblob     # firefly x position [cm]
firefly_y=null                 : longblob     # firefly y position [cm]
monkey_x=null                  : longblob     # monkey x position [cm]
monkey_y=null                  : longblob     # monkey y position [cm]
hand_x=null                    : longblob     # monkey hand x position [pixels]
hand_y=null                    : longblob     # monkey hand y position [pixels]
behv_time=null                 : longblob     # time index [s]

behv_tblockstart=null          : longblob     # offset for event markers [s]
behv_tsac=null                 : longblob     # saccade times [s]
%}

classdef Behaviour < dj.Imported    
    methods(Access=protected)
        function makeTuples(self,key)
            % use primary keys of session to lookup folder name from SessionLog Table
            [folder,eyechannels] = fetchn(firefly.SessionList & ... % from table
                ['session_id = ' num2str(key.session_id)] & ['monk_name = ' '"' key.monk_name '"'],... % restrict
                'folder','eyechannels'); % return attribute
            folder = folder{:}; eyechannels = eyechannels{:}; % unpack cell
            
            % create file path
            filepath = [folder '\behavioural data'];
            
            prs = fetch(firefly.DataAcquisitionParam,'*');
            analysisprs = fetch(firefly.AnalysisParam,'*'); analysisprs.eyechannels = eyechannels;
            ntrialevents = CountSMREvents(filepath);
            % prepare log data 
            [paramnames,paramvals] = PrepareLogData(filepath,ntrialevents);
            % prepare SMR data 
            [chdata,chnames,eventdata,eventnames] = PrepareSMRData(filepath,prs,analysisprs,paramnames,paramvals);
            selfAttributes = {self.header.attributes.name}; % think self.header.attributes.name is internal to dj
            for i=1:length(selfAttributes)
                if any(strcmp(chnames,selfAttributes{i}))
                    key.(selfAttributes{i}) = chdata(strcmp(chnames,selfAttributes{i}),:);
                elseif any(strcmp(eventnames,selfAttributes{i}))
                    key.(selfAttributes{i}) = eventdata{strcmp(eventnames,selfAttributes{i})};
                elseif any(strcmp(paramnames,selfAttributes{i}))
                    key.(selfAttributes{i}) = paramvals(strcmp(paramnames,selfAttributes{i}),:);
                end
            end
            self.insert(key);
            fprintf('Populated behavioural data for experiment done on %s with monkey %s \n',...
                key.session_date,key.monk_name);
        end
    end
end