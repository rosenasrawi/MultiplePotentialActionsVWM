%% Description 

% Script to load time-frequency response for each subjects, combine these,
% calculate the grand-average, and save both as .mat files

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

    % RT's (fast - slow)
    performance_all.load1fast_load1slow(s,:,:,:)       = performance.load1fast_load1slow(:,:,time_index);
    performance_all.load2fast_load2slow(s,:,:,:)       = performance.load2fast_load2slow(:,:,time_index);
    performance_all.load4fast_load4slow(s,:,:,:)       = performance.load4fast_load4slow(:,:,time_index);

end

%% Average

mean_performance_all = performance_all;

% RT's (fast - slow)
mean_performance_all.load1fast_load1slow    = squeeze(mean(performance_all.load1fast_load1slow));
mean_performance_all.load2fast_load2slow    = squeeze(mean(performance_all.load2fast_load2slow));
mean_performance_all.load4fast_load4slow    = squeeze(mean(performance_all.load4fast_load4slow));

%% Add beta C3 response

beta_index = performance_all.freq >= param.betaband(1) & performance_all.freq <= param.betaband(2);
C3_index = ismember(performance_all.label, param.C3);

% RT's (fast - slow)
performance_all.load1fast_load1slow_beta_C3      = squeeze(mean(performance_all.load1fast_load1slow(:,C3_index,beta_index,:), 3));
performance_all.load2fast_load2slow_beta_C3      = squeeze(mean(performance_all.load2fast_load2slow(:,C3_index,beta_index,:), 3));
performance_all.load4fast_load4slow_beta_C3      = squeeze(mean(performance_all.load4fast_load4slow(:,C3_index,beta_index,:), 3));

%% Save grand average structures

save ([param.path, '/tfr GA contrasts/' 'performance_all_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'performance_all');

save ([param.path, '/tfr GA contrasts/' 'mean_performance_all_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'mean_performance_all');
