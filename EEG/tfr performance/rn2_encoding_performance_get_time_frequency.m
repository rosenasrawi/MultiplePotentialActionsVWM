%% Clean workspace

clc; clear; close all

%% Trigger codes

trig_load1      = 1:4;
trig_load2      = 5:12;
trig_load4      = 13:16;

trig_fast       = 1; 
trig_slow       = 2;
trig_precise    = 3;
trig_unprecise  = 4;

%% Load combined logfile

this_subject = 1; % just need the general info

[param, ~, ~] = rn2_gen_param(this_subject); %just need param

load ([param.path 'logfiles/logfiles_combined_header_rn2.mat'], 'combined_logfile');

%% Analysis settings

laplacian = true;
beh_data_cleaning = "fast-and-slow"; %'slow' %'none'

%% Start loop

subjects = 1:25;

for this_subject = subjects
    
    [param, eegfiles, logfiles] = rn2_gen_param(this_subject);
    
    %% Load data

    load (param.path_eegfile); 
    
    data = d; clear d;    
    
    %% Add item similarity to trialinfo
    
    this_subject_index = combined_logfile.SubjectID == this_subject;
    slow_vs_fast = combined_logfile.SlowVsFast(this_subject_index);
    precise_vs_unprecise = combined_logfile.PreciseVsUnprecise(this_subject_index);
    
    data.trialinfo = [data.trialinfo, zeros(size(data.trialinfo,1), 2)]; % Two extra empty columns in trialinfo
    
    data.trialinfo(ismember(slow_vs_fast , 'fast'), 12)                 = 1;       % Fast
    data.trialinfo(ismember(slow_vs_fast , 'slow'), 12)                 = 2;       % Slow
    
    data.trialinfo(ismember(precise_vs_unprecise , 'precise'), 13)      = 3;       % Precise
    data.trialinfo(ismember(precise_vs_unprecise , 'unprecise'), 13)    = 4;       % Unprecise   
    
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

    % compare with & without

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

    % Loads & performance
    
    % RT
    trials_load1_fast       = ismember(tfr.trialinfo(:,1), trig_load1) & ismember(tfr.trialinfo(:,12), trig_fast);
    trials_load1_slow       = ismember(tfr.trialinfo(:,1), trig_load1) & ismember(tfr.trialinfo(:,12), trig_slow);
    trials_load2_fast       = ismember(tfr.trialinfo(:,1), trig_load2) & ismember(tfr.trialinfo(:,12), trig_fast);
    trials_load2_slow       = ismember(tfr.trialinfo(:,1), trig_load2) & ismember(tfr.trialinfo(:,12), trig_slow);
    trials_load4_fast       = ismember(tfr.trialinfo(:,1), trig_load4) & ismember(tfr.trialinfo(:,12), trig_fast);
    trials_load4_slow       = ismember(tfr.trialinfo(:,1), trig_load4) & ismember(tfr.trialinfo(:,12), trig_slow);
    
    % Error
    trials_load1_precise    = ismember(tfr.trialinfo(:,1), trig_load1) & ismember(tfr.trialinfo(:,13), trig_precise);
    trials_load1_unprecise  = ismember(tfr.trialinfo(:,1), trig_load1) & ismember(tfr.trialinfo(:,13), trig_unprecise);
    trials_load2_precise    = ismember(tfr.trialinfo(:,1), trig_load2) & ismember(tfr.trialinfo(:,13), trig_precise);
    trials_load2_unprecise  = ismember(tfr.trialinfo(:,1), trig_load2) & ismember(tfr.trialinfo(:,13), trig_unprecise);
    trials_load4_precise    = ismember(tfr.trialinfo(:,1), trig_load4) & ismember(tfr.trialinfo(:,13), trig_precise);
    trials_load4_unprecise  = ismember(tfr.trialinfo(:,1), trig_load4) & ismember(tfr.trialinfo(:,13), trig_unprecise);    
    
    %% Contrasts
    
    %% Performance differences

    % RT's (fast - slow)
    
    % load1
    a = mean(tfr.powspctrm(trials_load1_fast,:,:,:));
    b = mean(tfr.powspctrm(trials_load1_slow,:,:,:));

    load1fast_load1slow = squeeze(((a-b) ./ (a+b))) * 100;    
    
    % load2
    a = mean(tfr.powspctrm(trials_load2_fast,:,:,:));
    b = mean(tfr.powspctrm(trials_load2_slow,:,:,:));

    load2fast_load2slow = squeeze(((a-b) ./ (a+b))) * 100;    
    
    % load4
    a = mean(tfr.powspctrm(trials_load4_fast,:,:,:));
    b = mean(tfr.powspctrm(trials_load4_slow,:,:,:));

    load4fast_load4slow = squeeze(((a-b) ./ (a+b))) * 100;        
    
    % Errors (precise - unprecise)
    
    % load1
    a = mean(tfr.powspctrm(trials_load1_precise,:,:,:));
    b = mean(tfr.powspctrm(trials_load1_unprecise,:,:,:));

    load1precise_load1unprecise = squeeze(((a-b) ./ (a+b))) * 100;    
    
    % load2
    a = mean(tfr.powspctrm(trials_load2_precise,:,:,:));
    b = mean(tfr.powspctrm(trials_load2_unprecise,:,:,:));

    load2precise_load2unprecise = squeeze(((a-b) ./ (a+b))) * 100;    
    
    % load4
    a = mean(tfr.powspctrm(trials_load4_precise,:,:,:));
    b = mean(tfr.powspctrm(trials_load4_unprecise,:,:,:));

    load4precise_load4unprecise = squeeze(((a-b) ./ (a+b))) * 100;           
    
    
    %% Performance versus baseline
    
    % RT's (fast - slow)
    blc_load1_fast = squeeze(mean(tfr.blcorrected(trials_load1_fast,:,:,:)));
    blc_load1_slow = squeeze(mean(tfr.blcorrected(trials_load1_slow,:,:,:)));

    blc_load2_fast = squeeze(mean(tfr.blcorrected(trials_load2_fast,:,:,:)));
    blc_load2_slow = squeeze(mean(tfr.blcorrected(trials_load2_slow,:,:,:)));
    
    blc_load4_fast = squeeze(mean(tfr.blcorrected(trials_load4_fast,:,:,:)));
    blc_load4_slow = squeeze(mean(tfr.blcorrected(trials_load4_slow,:,:,:)));
    
    % Errors (precise - unprecise)
    blc_load1_precise   = squeeze(mean(tfr.blcorrected(trials_load1_precise,:,:,:)));
    blc_load1_unprecise = squeeze(mean(tfr.blcorrected(trials_load1_unprecise,:,:,:)));
    
    blc_load2_precise   = squeeze(mean(tfr.blcorrected(trials_load2_precise,:,:,:)));
    blc_load2_unprecise = squeeze(mean(tfr.blcorrected(trials_load2_unprecise,:,:,:)));    
    
    blc_load4_precise   = squeeze(mean(tfr.blcorrected(trials_load4_precise,:,:,:)));
    blc_load4_unprecise = squeeze(mean(tfr.blcorrected(trials_load4_unprecise,:,:,:)));
    
    %% Contrast parameters in structure

    performance = [];
    
    performance.label = tfr.label;
    performance.time = tfr.time;
    performance.freq = tfr.freq;
    performance.dimord = 'chan_freq_time';
    
    % Performance baseline corrected
    
    % RT's (fast - slow)
    performance.blc_load1_fast           = blc_load1_fast;
    performance.blc_load1_slow           = blc_load1_slow;
    performance.blc_load2_fast           = blc_load2_fast; 
    performance.blc_load2_slow           = blc_load2_slow;
    performance.blc_load4_fast           = blc_load4_fast;
    performance.blc_load4_slow           = blc_load4_slow;
    
    % Errors (precise - unprecise)
    performance.blc_load1_precise        = blc_load1_precise;
    performance.blc_load1_unprecise      = blc_load1_unprecise;
    performance.blc_load2_precise        = blc_load2_precise;
    performance.blc_load2_unprecise      = blc_load2_unprecise;
    performance.blc_load4_precise        = blc_load4_precise;
    performance.blc_load4_unprecise      = blc_load4_unprecise;    
    
    % Performance comparisons
    
    % RT's (fast - slow)
    performance.load1fast_load1slow      = load1fast_load1slow;
    performance.load2fast_load2slow      = load2fast_load2slow;
    performance.load4fast_load4slow      = load4fast_load4slow;
    
    % Errors (precise - unprecise)
    performance.load1precise_load1unprecise     = load1precise_load1unprecise;
    performance.load2precise_load2unprecise     = load2precise_load2unprecise;
    performance.load4precise_load4unprecise     = load4precise_load4unprecise; 

    %% Save     
    save ([param.path, '/tfr contrasts/' 'performance_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning) '_' param.sID], 'performance');
    
end