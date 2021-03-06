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
    
    load ([param.path, '/tfr contrasts/' 'load_1vs2vs4_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning) '_' param.sID], 'load1v2v4');
    
    if s == 1 % Copy structure once for only label, time, freq, dimord
        load1v2v4_all = selectfields(load1v2v4,{'label', 'time', 'freq', 'dimord'});
        
        % Select the right time window
        time_index = load1v2v4_all.time >= param.T_window(1) & load1v2v4_all.time <= param.T_window(2);
        load1v2v4_all.time = load1v2v4_all.time(time_index);
    end
    
    % Load comparisons
    load1v2v4_all.load1_load2(s,:,:,:) = load1v2v4.load1_load2(:,:,time_index);
    load1v2v4_all.load2_load4(s,:,:,:) = load1v2v4.load2_load4(:,:,time_index);
    load1v2v4_all.load1_load4(s,:,:,:) = load1v2v4.load1_load4(:,:,time_index);

end

%% Average

mean_load1v2v4_all = load1v2v4_all;

% Load comparisons
mean_load1v2v4_all.load1_load2 = squeeze(mean(load1v2v4_all.load1_load2));
mean_load1v2v4_all.load2_load4 = squeeze(mean(load1v2v4_all.load2_load4));
mean_load1v2v4_all.load1_load4 = squeeze(mean(load1v2v4_all.load1_load4));

%% Add beta C3 response

beta_index = load1v2v4_all.freq >= param.betaband(1) & load1v2v4_all.freq <= param.betaband(2);
C3_index = ismember(load1v2v4_all.label, param.C3);

load1v2v4_all.load1_load2_beta_C3 = squeeze(mean(load1v2v4_all.load1_load2(:,C3_index,beta_index,:), 3));
load1v2v4_all.load2_load4_beta_C3 = squeeze(mean(load1v2v4_all.load2_load4(:,C3_index,beta_index,:), 3));
load1v2v4_all.load1_load4_beta_C3 = squeeze(mean(load1v2v4_all.load1_load4(:,C3_index,beta_index,:), 3));

%% Save grand average structures

save ([param.path, '/tfr GA contrasts/' 'load1vs2vs4_all_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'load1v2v4_all');

save ([param.path, '/tfr GA contrasts/' 'mean_load1vs2vs4_all_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'mean_load1v2v4_all');
