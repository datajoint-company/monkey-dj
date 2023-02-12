%{
# Behaviour across all trials (bias, variance, ROC)
-> firefly.Behaviour
-> firefly.Event
-> firefly.AnalysisParam
---
# add additional attributes
firefly_x=null                : longblob          # firefly x position [cm]    
firefly_y=null                : longblob          # firefly y position [cm]
firefly_r=null                : longblob          # firefly radial distance [cm]
firefly_th=null               : longblob          # firefly angle [deg]

monkey_xf=null                : longblob          # monkey stopping x position [cm]
monkey_yf=null                : longblob          # monkey stopping y position [cm]
monkey_rf=null                : longblob          # monkey stopping radial distance [cm]     
monkey_thf=null               : longblob          # monkey stopping angle [deg]

dist2firefly=null             : longblob          # dist between stopping pos and firefly
dist2firefly_shuffled=null    : longblob          # same as above, but shuffled estimate

m1_beta_r=null                : double            # radial slope (regression without intercept) 
m1_betaci_r=null              : blob              # radial slope conf int
m1_beta_th=null               : double            # angular slope 
m1_betaci_th=null             : blob              # angular slope conf int

m2_beta_r=null                : double            # radial slope (regression with intercept)  
m2_betaci_r=null              : blob              # radial slope conf int
m2_beta_th=null               : double            # angular slope  
m2_betaci_th=null             : blob              # angular slope conf int 
m2_alpha_r=null               : double            # radial intercept [cm]
m2_alphaci_r=null             : blob              # radial intercept conf int [cm]
m2_alpha_th=null              : double            # angular intercept [deg]
m2_alphaci_th=null            : blob              # angular intercept conf int [deg]

m3_r=null                     : blob              # target distance [cm] (local linear regression)
m3_betalocal_r=null           : blob              # stopping distance [cm]
m3_th=null                    : blob              # target angle [deg]
m3_betalocal_th=null          : blob              # stopping angle [deg]

corr_r=null                   : double            # corr(target dist, monk dist)
pval_r=null                   : double            # pval of radial corr
corr_th=null                  : double            # corr(target angle, monk angle)
pval_th=null                  : double            # pval of angular corr

roc_rewardwin=null            : blob              # ROC curve reward window-size
roc_pcorrect=null             : blob              # ROC curve percent correct
roc_pcorrect_shuffled=null    : blob              # ROC curve percent correct, shuffled estimate
auc=null                      : double            # area under ROC curve
auc_rbin=null                 : blob              # target distance bin
auc_r=null                    : blob              # AUC vs target distance bin
auc_thbin=null                : blob              # target angle bin
auc_th=null                   : blob              # AUC vs target angle bin

spatial_x=null                : longblob          # x coord of target [cm]
spatial_y=null                : longblob          # y coord of target [cm]
spatial_xerr=null             : longblob          # stopping error in x [cm]
spatial_yerr=null             : longblob          # stopping error in y [cm]
spatial_xstd=null             : longblob          # stopping std dev in x [cm]
spatial_ystd=null             : longblob          # stopping std dev in x [cm]
%}

classdef StatsBehaviourAll < dj.Computed
    methods(Access=protected)
        function makeTuples(self,key)
            trials = fetch(firefly.TrialBehaviour &...
                ['session_id = ' num2str(key.session_id)] & ['monk_name = ' '"' key.monk_name '"'] &...
                'attempted=1','*');
            stimulusprs = fetch(firefly.StimulusParam,'*');
            analysisprs = fetch(firefly.AnalysisParam,'*');
            stats = AnalyseBehaviour(trials,analysisprs,stimulusprs);
            
            selfAttributes = {self.header.attributes.name}; % think self.header.attributes.name is internal to dj
            for i=1:length(selfAttributes)
                if any(strcmpi(fields(stats),selfAttributes{i}))
                    key.(selfAttributes{i}) = stats.(selfAttributes{i});
                end
            end
            self.insert(key);
            fprintf('Populated behavioural stats across all trials for experiment done on %s with monkey %s \n',...
                key.session_date,key.monk_name);
        end
    end
end