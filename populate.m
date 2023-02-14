% %% add monkeys
% insert(firefly.Monkey, {'Dylan', 01, "M"});
% 
% %% add sessions
% insert(firefly.Session, {'Dylan', '2023-01-27', 01, 'Valentina'});
% insert(firefly.Session, {'Dylan', '2023-01-30', 02, 'Valentina'});

% %% populate static tables
% firefly.SessionList;
% firefly.ElectrodeParam;
% firefly.DataAcquisitionParam;
% firefly.StimulusParam;
% firefly.AnalysisParam;

%% populate basic tables - behavior, events, neuron, lfp (imported)
populate(firefly.Behaviour);  % .log,, .smr?
populate(firefly.Event);  % .log,, .smr?
% populate(firefly.Neuron);
% populate(firefly.Lfp);

%% populate tables with segmented trials (computed)
populate(firefly.TrialBehaviour);
% populate(firefly.TrialNeuron);
% populate(firefly.TrialLfp);
% populate(firefly.TrialLfpbeta);
% populate(firefly.TrialLfptheta);

%% populate results tables (computed)
populate(firefly.StatsBehaviour);
populate(firefly.StatsBehaviourAll); % quick version - analyse all trials without splitting into conditions
populate(firefly.StatsEye);
populate(firefly.StatsEyeAll); % quick version - analyse all trials without splitting into conditions
% populate(firefly.StatsLfpAll);
% populate(firefly.StatsLfpthetaAll);
% populate(firefly.StatsLfpbetaAll);
% populate(firefly.StatsNeuronAll);