%{
# Eye movement across all trials (tracking index, saccades)
-> firefly.Behaviour
-> firefly.Event
-> firefly.AnalysisParam
---
# add additional attributes
saccade_trueval=null                : longblob          # amplitude of saccade [deg]     
saccade_truedir=null                : longblob          # direction of saccade [deg]
saccade_predval=null                : longblob          # predicted amplitude [deg]
saccade_preddir=null                : longblob          # predicted direction [deg]
saccade_time=null                   : longblob          # time of saccade [s]

eyebehvcorr_r=0                     : double            # corr(target-tracking error, stopping error)
eyebehvcorr_pval=0                  : double            # pval of corr
eyepos_err=null                     : longblob          # target-tracking error
stoppos_err=null                    : longblob          # stopping error

ver_pred=null                       : longblob          # predicted vertical eye position [deg]
hor_pred=null                       : longblob          # predicted horiz eye position [deg]
verdiff_pred=null                   : longblob          # predicted vertical vergence [deg]
hordiff_pred=null                   : longblob          # predicted horiz vergence [deg]
ver_true=null                       : longblob          # vertical eye position [deg]
hor_true=null                       : longblob          # horiz eye position [deg]
verdiff_true=null                   : longblob          # vertical vergence [deg]
hordiff_true=null                   : longblob          # horiz vergence [deg]

ver_xcorr=null                      : longblob          # cross-corr between actual and pred vertical
ver_xcorrlag=null                   : longblob          # cross-corr timelag
ver_xcorrshuf=null                  : longblob          # shuffled cross-corr
hor_xcorr=null                      : longblob          # cross-corr between actual and pred horiz
hor_xcorrlag=null                   : longblob          # cross-corr timelag
hor_xcorrshuf=null                  : longblob          # shuffled cross-corr

ver_rfix=null                       : longblob          # corr between actual and pred vertical fixation-aligned
ver_pvalfix=null                    : longblob          # pval of corr
hor_rfix=null                       : longblob          # corr between actual and pred horiz
hor_pvalfix=null                    : longblob          # pval of corr
verdiff_rfix=null                   : longblob          # corr between actual and pred vert vergence
verdiff_pvalfix=null                : longblob          # pval of corr
hordiff_rfix=null                   : longblob          # corr between actual and pred horiz vergence
hordiff_pvalfix=null                : longblob          # pval of corr

cossim_meanfix=null                 : longblob          # mean cosine similarity (CS) fixation-aligned
cossim_semfix=null                  : longblob          # sem
cossim_meanshuffix=null             : longblob          # shuffled CS
cossim_semshuffix=null              : longblob          # sem of shuffled CS
cossimgrouped_fix=null              : longblob          # CS grouped by reward

varexp_meanfix=null                 : longblob          # mean variance explained (VE) fixation-aligned
varexp_semfix=null                  : longblob          # sem
varexp_meanshuffix=null             : longblob          # shuffled VE
varexp_semshuffix=null              : longblob          # sem of shuffled VE
varexpgrouped_fix=null              : longblob          # VE grouped by reward
varexpbound_fix=null                : longblob          # upper bound of VE
sqerr_fix=null                      : longblob          # squared error
var_pred_fix=null                   : longblob          # variance of predicted eye pos
var_true_fix=null                   : longblob          # variance of actual eye pos

ver_rstop=null                      : longblob          # corr between actual and pred vertical stop-aligned
ver_pvalstop=null                   : longblob          # pval of corr
hor_rstop=null                      : longblob          # corr between actual and pred horiz
hor_pvalstop=null                   : longblob          # pval of corr
verdiff_rstop=null                  : longblob          # corr between actual and pred vert vergence
verdiff_pvalstop=null               : longblob          # pval of corr
hordiff_rstop=null                  : longblob          # corr between actual and pred horiz stop-aligned
hordiff_pvalstop=null               : longblob          # pval of corr

cossim_meanstop=null                : longblob          # mean CS stop-aligned
cossim_semstop=null                 : longblob          # sem
cossim_meanshufstop=null            : longblob          # shuffled CS
cossim_semshufstop=null             : longblob          # sem of shuffled estimate
cossimgrouped_stop=null             : longblob          # CS grouped by reward

varexp_meanstop=null                : longblob          # mean VE stop-aligned
varexp_semstop=null                 : longblob          # sem
varexp_meanshufstop=null            : longblob          # shuffled VE
varexp_semshufstop=null             : longblob          # sem of shuffled estimate
varexpgrouped_stop=null             : longblob          # VE grouped by reward
varexpbound_stop=null               : longblob          # upper bound of VE
sqerr_stop=null                     : longblob          # squared error
var_pred_stop=null                  : longblob          # variance of predicted eye pos
var_true_stop=null                  : longblob          # variance of actual eye pos
%}

classdef StatsEyeAll < dj.Computed
    methods(Access=protected)
        function makeTuples(self,key)
            trials = fetch(firefly.TrialBehaviour &...
                ['session_id = ' num2str(key.session_id)] & ['monk_name = ' '"' key.monk_name '"'] &...
                'attempted=1','*');
            stats = fetch(firefly.StatsBehaviourAll &...
                ['session_id = ' num2str(key.session_id)] & ['monk_name = ' '"' key.monk_name '"'],'*');
            stimulusprs = fetch(firefly.StimulusParam,'*');
            analysisprs = fetch(firefly.AnalysisParam,'*');
            stats = AnalyseEyemovement(trials,stats,analysisprs,stimulusprs);
            
            selfAttributes = {self.header.attributes.name}; % think self.header.attributes.name is internal to dj
            for i=1:length(selfAttributes)
                if any(strcmpi(fields(stats),selfAttributes{i}))
                    key.(selfAttributes{i}) = stats.(selfAttributes{i});
                end
            end
            self.insert(key);
            fprintf('Populated eyemovement stats across all trials for experiment done on %s with monkey %s \n',...
                key.session_date,key.monk_name);
        end
    end
end