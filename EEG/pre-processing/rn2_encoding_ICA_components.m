%% Clean workspace

clc; clear; close all

%% Define parameters

subjects = 1:25;

for this_subject = subjects
    
    [param, eegfiles, logfiles] = rn2_gen_param(this_subject);
    
    %% Load data
    load(param.path_eegfile); 

    data = d;

    %% run fast ICA and check eog component detectability (+ topography check)

    cfg = [];
    cfg.keeptrials = 'yes';
    cfg.channel = {'EEG'};
    
    d_eeg = ft_timelockanalysis(cfg, data);

    %% ica
    cfg = [];
    cfg.method = 'fastica';
    ica = ft_componentanalysis(cfg, d_eeg);

    %% look at components
    cfg           = [];
    cfg.component = 1:61;      
    cfg.layout    = 'easycapM1.lay';
    cfg.comment   = 'no';
    figure; ft_topoplotIC(cfg, ica)
    colormap('jet')

    %% correlate ica timecourses with measured eog

    cfg = [];
    cfg.keeptrials = 'yes';
    d_ica = ft_timelockanalysis(cfg, ica);
    
    cfg.channel = {'eog'};
    d_eog = ft_timelockanalysis(cfg, data);

    %% Plot (visual inspection of components)

    x = [];
    y = [];

    x = d_eog.trial(:,1,:); % eog
    for c = 1:size(d_ica.trial,2)
        y = d_ica.trial(:,c,:); % components
        correlations(c) = corr(y(:), x(:));
    end

    figure; 
    bar(1:c, abs(correlations),'r'); title('correlations with component timecourses');   
    xlabel('comp #');

    %% Find the max abs cor

    max_abs_cor = find(abs(correlations) == max(abs(correlations)));
    max_abs_cor % print which one it is
    ica2rem = input('bad components are: ');

    %% Save
        
    save([param.path, '/ICA components/' 'ICA_encoding_components', '_' param.sID], 'ica2rem','ica');
    
end
