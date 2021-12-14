%% Description 

% Script to determine which trials to include for further analyses using ft_rejectvisual
% Save list of trials to keep in further analysis

%% Clean workspace

clc; clear; close all

%% Define parameters

subjects = 1:25;

for this_subject = subjects
        
    [param, eegfiles, logfiles] = rn2_gen_param(this_subject);
    
    %% Load data

    load (param.path_eegfile); 
    
    data = d; clear d;

    %% Load ICA

    load ([param.path, '/ICA components/' 'ICA_encoding_components', '_' param.sID], 'ica2rem','ica');

    %% Select EEG

    cfg = [];
    cfg.channel = {'EEG'};

    data = ft_selectdata(cfg, data);

    %% Remove bad ICA components

    cfg = [];
    cfg.component = ica2rem;

    data = ft_rejectcomponent(cfg, ica, data);

    %% Find bad trials

    data.trialinfo(:,end+1) = 1:length(data.trial);
    trials_old = data.trialinfo(:,end);

    %% All channels, all bands

    cfg = [];
    cfg.method = 'summary';
    cfg.channel = {'EEG'};

    data = ft_rejectvisual(cfg, data);

    %% Chan selections

    cfg.keepchannel = 'yes';
    cfg.channel = {'C3','C4','PO7','PO8'};
 
    data = ft_rejectvisual(cfg, data);    

    %% Band selections

    cfg.channel = {'EEG'};
    cfg.preproc.bpfilter = 'yes';
    cfg.preproc.bpfreq = [8 30];

    data = ft_rejectvisual(cfg, data);

    %% Band and chan selections

    cfg.channel = {'C3','C4','PO7','PO8'};

    data = ft_rejectvisual(cfg, data); 

    %% Trials to keep

    trials_new = data.trialinfo(:,end);

    trl2keep = ismember(trials_old, trials_new); % could save this

    propkeep(this_subject) = mean(trl2keep) % how many removed?

    %% Save

    save ([param.path, '/usable trials/' 'usable_trials_encoding_' param.sID], 'trl2keep');
    
end


