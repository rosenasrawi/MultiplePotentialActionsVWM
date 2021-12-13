%% Clean workspace

clc; clear; close all

%% Some settings

subjects = 1:25;
laplacian = true;
beh_data_cleaning = "fast-and-slow"; %'slow' %'none'

%% Loop over all participants

s = 0;

for this_subject = subjects
    
    s = s+1;
    [param, eegfiles, logfiles] = rn2_gen_param(this_subject);
    load ([param.path, '/tfr contrasts/' 'performance_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning) '_' param.sID], 'performance');
    
    if s == 1 % Copy structure once for only label, time, freq, dimord
        performance_all = selectfields(performance,{'label', 'time', 'freq', 'dimord'});

        % Select the right time window
        time_index = performance_all.time >= param.T_window(1) & performance_all.time <= param.T_window(2);
        performance_all.time = performance_all.time(time_index);
    
    end
    
    % Performance baseline corrected

    % RT's (fast - slow)
    performance_all.blc_load1_fast(s,:,:,:)            = performance.blc_load1_fast(:,:,time_index);
    performance_all.blc_load1_slow(s,:,:,:)            = performance.blc_load1_slow(:,:,time_index);
    performance_all.blc_load2_fast(s,:,:,:)            = performance.blc_load2_fast(:,:,time_index); 
    performance_all.blc_load2_slow(s,:,:,:)            = performance.blc_load2_slow(:,:,time_index);
    performance_all.blc_load4_fast(s,:,:,:)            = performance.blc_load4_fast(:,:,time_index);
    performance_all.blc_load4_slow(s,:,:,:)            = performance.blc_load4_slow(:,:,time_index);
    
    % Errors (precise - unprecise)
    performance_all.blc_load1_precise(s,:,:,:)         = performance.blc_load1_precise(:,:,time_index);
    performance_all.blc_load1_unprecise(s,:,:,:)       = performance.blc_load1_unprecise(:,:,time_index);
    performance_all.blc_load2_precise(s,:,:,:)         = performance.blc_load2_precise(:,:,time_index);
    performance_all.blc_load2_unprecise(s,:,:,:)       = performance.blc_load2_unprecise(:,:,time_index);
    performance_all.blc_load4_precise(s,:,:,:)         = performance.blc_load4_precise(:,:,time_index);
    performance_all.blc_load4_unprecise(s,:,:,:)       = performance.blc_load4_unprecise(:,:,time_index);    
    
    % Performance comparisons
    
    % RT's (fast - slow)
    performance_all.load1fast_load1slow(s,:,:,:)       = performance.load1fast_load1slow(:,:,time_index);
    performance_all.load2fast_load2slow(s,:,:,:)       = performance.load2fast_load2slow(:,:,time_index);
    performance_all.load4fast_load4slow(s,:,:,:)       = performance.load4fast_load4slow(:,:,time_index);
    
    % Errors (precise - unprecise)
    performance_all.load1precise_load1unprecise(s,:,:,:)      = performance.load1precise_load1unprecise(:,:,time_index);
    performance_all.load2precise_load2unprecise(s,:,:,:)      = performance.load2precise_load2unprecise(:,:,time_index);
    performance_all.load4precise_load4unprecise(s,:,:,:)      = performance.load4precise_load4unprecise(:,:,time_index);     

end

%% Average

mean_performance_all = performance_all;

% Performance baseline corrected

% RT's (fast - slow)
mean_performance_all.blc_load1_fast         = squeeze(mean(performance_all.blc_load1_fast));
mean_performance_all.blc_load1_slow         = squeeze(mean(performance_all.blc_load1_slow));
mean_performance_all.blc_load2_fast         = squeeze(mean(performance_all.blc_load2_fast));
mean_performance_all.blc_load2_slow         = squeeze(mean(performance_all.blc_load2_slow));
mean_performance_all.blc_load4_fast         = squeeze(mean(performance_all.blc_load4_fast));
mean_performance_all.blc_load4_slow         = squeeze(mean(performance_all.blc_load4_slow));

% Errors (precise - unprecise)
mean_performance_all.blc_load1_precise      = squeeze(mean(performance_all.blc_load1_precise));
mean_performance_all.blc_load1_unprecise    = squeeze(mean(performance_all.blc_load1_unprecise));
mean_performance_all.blc_load2_precise      = squeeze(mean(performance_all.blc_load2_precise));
mean_performance_all.blc_load2_unprecise    = squeeze(mean(performance_all.blc_load2_unprecise));
mean_performance_all.blc_load4_precise      = squeeze(mean(performance_all.blc_load4_precise));
mean_performance_all.blc_load4_unprecise    = squeeze(mean(performance_all.blc_load4_unprecise));

% Performance comparisons

% RT's (fast - slow)
mean_performance_all.load1fast_load1slow    = squeeze(mean(performance_all.load1fast_load1slow));
mean_performance_all.load2fast_load2slow    = squeeze(mean(performance_all.load2fast_load2slow));
mean_performance_all.load4fast_load4slow    = squeeze(mean(performance_all.load4fast_load4slow));

% Errors (precise - unprecise)
mean_performance_all.load1precise_load1unprecise    = squeeze(mean(performance_all.load1precise_load1unprecise));
mean_performance_all.load2precise_load2unprecise    = squeeze(mean(performance_all.load2precise_load2unprecise));
mean_performance_all.load4precise_load4unprecise    = squeeze(mean(performance_all.load4precise_load4unprecise));


%% Add beta C3 response

beta_index = performance_all.freq >= param.betaband(1) & performance_all.freq <= param.betaband(2);
C3_index = ismember(performance_all.label, param.C3);

% Performance baseline corrected

% RT's (fast - slow)
performance_all.blc_load1_fast_beta_C3           = squeeze(mean(performance_all.blc_load1_fast(:,C3_index,beta_index,:), 3));
performance_all.blc_load1_slow_beta_C3           = squeeze(mean(performance_all.blc_load1_slow(:,C3_index,beta_index,:), 3));
performance_all.blc_load2_fast_beta_C3           = squeeze(mean(performance_all.blc_load2_fast(:,C3_index,beta_index,:), 3));
performance_all.blc_load2_slow_beta_C3           = squeeze(mean(performance_all.blc_load2_slow(:,C3_index,beta_index,:), 3));
performance_all.blc_load4_fast_beta_C3           = squeeze(mean(performance_all.blc_load4_fast(:,C3_index,beta_index,:), 3));
performance_all.blc_load4_slow_beta_C3           = squeeze(mean(performance_all.blc_load4_slow(:,C3_index,beta_index,:), 3));

% Errors (precise - unprecise)
performance_all.blc_load1_precise_beta_C3        = squeeze(mean(performance_all.blc_load1_precise(:,C3_index,beta_index,:), 3));
performance_all.blc_load1_unprecise_beta_C3      = squeeze(mean(performance_all.blc_load1_unprecise(:,C3_index,beta_index,:), 3));
performance_all.blc_load2_precise_beta_C3        = squeeze(mean(performance_all.blc_load2_precise(:,C3_index,beta_index,:), 3));
performance_all.blc_load2_unprecise_beta_C3      = squeeze(mean(performance_all.blc_load2_unprecise(:,C3_index,beta_index,:), 3));
performance_all.blc_load4_precise_beta_C3        = squeeze(mean(performance_all.blc_load4_precise(:,C3_index,beta_index,:), 3));
performance_all.blc_load4_unprecise_beta_C3      = squeeze(mean(performance_all.blc_load4_unprecise(:,C3_index,beta_index,:), 3));

% Performance comparisons

% RT's (fast - slow)
performance_all.load1fast_load1slow_beta_C3      = squeeze(mean(performance_all.load1fast_load1slow(:,C3_index,beta_index,:), 3));
performance_all.load2fast_load2slow_beta_C3      = squeeze(mean(performance_all.load2fast_load2slow(:,C3_index,beta_index,:), 3));
performance_all.load4fast_load4slow_beta_C3      = squeeze(mean(performance_all.load4fast_load4slow(:,C3_index,beta_index,:), 3));

% Errors (precise - unprecise)
performance_all.load1precise_load1unprecise_beta_C3     = squeeze(mean(performance_all.load1precise_load1unprecise(:,C3_index,beta_index,:), 3));
performance_all.load2precise_load2unprecise_beta_C3     = squeeze(mean(performance_all.load2precise_load2unprecise(:,C3_index,beta_index,:), 3));
performance_all.load4precise_load4unprecise_beta_C3     = squeeze(mean(performance_all.load4precise_load4unprecise(:,C3_index,beta_index,:), 3));

%% Save grand average structures

save ([param.path, '/tfr GA contrasts/' 'performance_all_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'performance_all');

save ([param.path, '/tfr GA contrasts/' 'mean_performance_all_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'mean_performance_all');
