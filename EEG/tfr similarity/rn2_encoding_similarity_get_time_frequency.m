%% Clean workspace

clc; clear; close all

%% Trigger codes

trig_load1 = 1;
trig_load2_sim = 21;
trig_load2_dif = 22;
trig_load4 = 4;

%% Load combined logfile

this_subject = 1; % just need the general info

[param, ~, ~] = rn2_gen_param(this_subject); %just need param

load ([param.path 'logfiles/logfiles_combined_header_rn2.mat'], 'combined_logfile');

%% Analysis settings

laplacian = true;
beh_data_cleaning = "fast-and-slow"; %'slow' %'none'

%% Start loop

subjects = 25;

for this_subject = subjects
    
    [param, eegfiles, logfiles] = rn2_gen_param(this_subject);
    
    %% Load data

    load (param.path_eegfile); 
    
    data = d; clear d;    
    
    %% Add item similarity to trialinfo
    
    this_subject_index = combined_logfile.SubjectID == this_subject;
    item_sim = combined_logfile.ItemSimilarity(this_subject_index);
    
    data.trialinfo = [data.trialinfo, zeros(size(data.trialinfo,1),1)]; 
    
    data.trialinfo(ismember(item_sim , 'load1'), 12)         = 1;       % Load 1
    data.trialinfo(ismember(item_sim , 'load2 less'), 12)    = 21;      % Load 2 sim
    data.trialinfo(ismember(item_sim , 'load2 more'), 12)    = 22;      % Load 2 dif
    data.trialinfo(ismember(item_sim , 'load4'), 12)         = 4;       % Load 4
    
    %% Load ICA

    load ([param.path, '/ICA components/' 'ICA_encoding_components', '_' param.sID], 'ica2rem','ica');

    %% Load trials to keep

    load ([param.path, '/usable trials/' 'usable_trials_encoding_' param.sID], 'trl2keep');

    %% Keep channels of interest

    cfg = [];
    cfg.channel = {'EEG'};

    data = ft_preprocessing(cfg, data);

    %% Remove bad behavior trials from trl2keep
    
    if beh_data_cleaning ~= "none"
        
        this_subject_index = combined_logfile.SubjectID == this_subject;
        remove_RT1 = combined_logfile.removeRT1(this_subject_index);

        if beh_data_cleaning == "slow"
            good_behavior = remove_RT1 ~= "slow";
        end

        if beh_data_cleaning == "fast-and-slow"
            good_behavior = remove_RT1 ~= "slow" & remove_RT1 ~= "fast";
        end

        trl2keep = trl2keep & good_behavior;
        
    end
    
    %% Remove bad trials

    cfg = [];
    cfg.trials = trl2keep;

    data = ft_selectdata(cfg, data);
    
    clear trl2keep;

    %% Remove bad ICA components

    cfg = [];
    cfg.component = ica2rem;

    data = ft_rejectcomponent(cfg, ica, data);
    
    clear ica;

    %% Surface laplacian if specified

    if laplacian
        cfg = [];
        cfg.elec = ft_read_sens('standard_1020.elc');

        data = ft_scalpcurrentdensity(cfg, data);
    end
    
    %% Get time-frequency response
    
    taperstyle = 'hanning'; 
    windowsize = 0.3;

    cfg = [];

    cfg.method = 'mtmconvol';
    cfg.keeptrials = 'yes';
    cfg.taper = taperstyle;
    cfg.foi = 3:1:40; % frequency's of interest
    cfg.pad = 10; % 
    cfg.toi = data.time{1}(1) + (windowsize / 2) : .05 : data.time{1}(end) - (windowsize / 2); % steps of 50 ms always. 
    cfg.t_ftimwin = ones(1,length(cfg.foi)) * windowsize;

    tfr = ft_freqanalysis(cfg, data);

    clear data;    
    
    %% Baseline correct data pre-encoding
    
    timesel_baseline = tfr.time >= -.5+(windowsize / 2) & tfr.time <= 0-(windowsize / 2);
    data_baseline = squeeze(mean(mean(tfr.powspctrm(:,:,:,timesel_baseline),4))); % mean over time in baseline period & trials
    
    tfr.blcorrected = nan(size(tfr.powspctrm));
    
    for trial = 1:length(tfr.trialinfo(:,1))
                
        for time = 1:length(tfr.time)
           tfr.blcorrected(trial,:,:,time) = ((squeeze(tfr.powspctrm(trial,:,:,time)) - data_baseline) ./ data_baseline) * 100;
        end
        
    end    
    
    %% Separate trial types

    % Loads & similarity
    trials_load1 = ismember(tfr.trialinfo(:,12), trig_load1);
    trials_load2_sim = ismember(tfr.trialinfo(:,12), trig_load2_sim); 
    trials_load2_dif = ismember(tfr.trialinfo(:,12), trig_load2_dif);
    trials_load4 = ismember(tfr.trialinfo(:,12), trig_load4);
    
    %% Contrasts
    
    %% Load differences

    % load1 vs load4
    a = mean(tfr.powspctrm(trials_load1,:,:,:));
    b = mean(tfr.powspctrm(trials_load4,:,:,:));

    load1_load4 = squeeze(((a-b) ./ (a+b))) * 100;    
    
    % load1 vs load2_sim
    a = mean(tfr.powspctrm(trials_load1,:,:,:));
    b = mean(tfr.powspctrm(trials_load2_sim,:,:,:));

    load1_load2sim = squeeze(((a-b) ./ (a+b))) * 100;  
    
    % load1 vs load2_dif
    a = mean(tfr.powspctrm(trials_load1,:,:,:));
    b = mean(tfr.powspctrm(trials_load2_dif,:,:,:));

    load1_load2dif = squeeze(((a-b) ./ (a+b))) * 100;  
        
    % load2_sim vs load2_dif
    a = mean(tfr.powspctrm(trials_load2_sim,:,:,:));
    b = mean(tfr.powspctrm(trials_load2_dif,:,:,:));

    load2sim_load2dif = squeeze(((a-b) ./ (a+b))) * 100;  
        
    % load2_sim vs load4
    a = mean(tfr.powspctrm(trials_load2_sim,:,:,:));
    b = mean(tfr.powspctrm(trials_load4,:,:,:));

    load2sim_load4 = squeeze(((a-b) ./ (a+b))) * 100;  
            
    % load2_dif vs load4
    a = mean(tfr.powspctrm(trials_load2_dif,:,:,:));
    b = mean(tfr.powspctrm(trials_load4,:,:,:));

    load2dif_load4 = squeeze(((a-b) ./ (a+b))) * 100;  
            
    %% Loads versus baseline
    
    blc_load1 = squeeze(mean(tfr.blcorrected(trials_load1,:,:,:)));
    
    blc_load2_sim = squeeze(mean(tfr.blcorrected(trials_load2_sim,:,:,:)));
    
    blc_load2_dif = squeeze(mean(tfr.blcorrected(trials_load2_dif,:,:,:)));
    
    blc_load4 = squeeze(mean(tfr.blcorrected(trials_load4,:,:,:)));
    
    %% Contrast parameters in structure

    itemsim = [];
    
    itemsim.label = tfr.label;
    itemsim.time = tfr.time;
    itemsim.freq = tfr.freq;
    itemsim.dimord = 'chan_freq_time';
    
    % Loads baseline corrected
    itemsim.blc_load1           = blc_load1;
    itemsim.blc_load2_sim       = blc_load2_sim;
    itemsim.blc_load2_dif       = blc_load2_dif;
    itemsim.blc_load4           = blc_load4;
    
    % Load comparisons
    itemsim.load1_load4         = load1_load4;
    itemsim.load1_load2sim      = load1_load2sim;
    itemsim.load1_load2dif      = load1_load2dif;
    itemsim.load2sim_load2dif   = load2sim_load2dif;
    itemsim.load2sim_load4      = load2sim_load4;
    itemsim.load2dif_load4      = load2dif_load4;
    
    %% Save    
    
    save ([param.path, '/tfr contrasts/' 'itemsim_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning) '_' param.sID], 'itemsim');
    
end