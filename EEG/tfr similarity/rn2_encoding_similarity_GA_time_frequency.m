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
    load ([param.path, '/tfr contrasts/' 'itemsim_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning) '_' param.sID], 'itemsim');
    
    if s == 1 % Copy structure once for only label, time, freq, dimord
        itemsim_all = selectfields(itemsim, {'label', 'time', 'freq', 'dimord'});

        % Select the right time window
        time_index = itemsim_all.time >= param.T_window(1) & itemsim_all.time <= param.T_window(2);
        itemsim_all.time = itemsim_all.time(time_index);
    end
    
    % Baseline corrected loads
    itemsim_all.blc_load1(s,:,:,:)      = itemsim.blc_load1(:,:,time_index);
	itemsim_all.blc_load2_sim(s,:,:,:)  = itemsim.blc_load2_sim(:,:,time_index);
	itemsim_all.blc_load2_dif(s,:,:,:)  = itemsim.blc_load2_dif(:,:,time_index);    
    itemsim_all.blc_load4(s,:,:,:)      = itemsim.blc_load4(:,:,time_index);
    
    % Load comparisons
    
    itemsim_all.load1_load4(s,:,:,:)         = itemsim.load1_load4(:,:,time_index);
    itemsim_all.load1_load2sim(s,:,:,:)      = itemsim.load1_load2sim(:,:,time_index);
    itemsim_all.load1_load2dif(s,:,:,:)      = itemsim.load1_load2dif(:,:,time_index);
    itemsim_all.load2sim_load2dif(s,:,:,:)   = itemsim.load2sim_load2dif(:,:,time_index);
    itemsim_all.load2sim_load4(s,:,:,:)      = itemsim.load2sim_load4(:,:,time_index);
    itemsim_all.load2dif_load4(s,:,:,:)      = itemsim.load2dif_load4(:,:,time_index);

end

%% Average

mean_itemsim_all = itemsim_all;

% Baseline corrected loads
mean_itemsim_all.blc_load1          = squeeze(mean(itemsim_all.blc_load1));
mean_itemsim_all.blc_load2_sim      = squeeze(mean(itemsim_all.blc_load2_sim));
mean_itemsim_all.blc_load2_dif      = squeeze(mean(itemsim_all.blc_load2_dif));
mean_itemsim_all.blc_load4          = squeeze(mean(itemsim_all.blc_load4));

% Load comparisons

mean_itemsim_all.load1_load4        = squeeze(mean(itemsim_all.load1_load4));
mean_itemsim_all.load1_load2sim     = squeeze(mean(itemsim_all.load1_load2sim));
mean_itemsim_all.load1_load2dif     = squeeze(mean(itemsim_all.load1_load2dif));
mean_itemsim_all.load2sim_load2dif  = squeeze(mean(itemsim_all.load2sim_load2dif));
mean_itemsim_all.load2sim_load4     = squeeze(mean(itemsim_all.load2sim_load4));
mean_itemsim_all.load2dif_load4     = squeeze(mean(itemsim_all.load2dif_load4));

%% Add beta C3 response

beta_index = itemsim_all.freq >= param.betaband(1) & itemsim_all.freq <= param.betaband(2);
C3_index = ismember(itemsim_all.label, param.C3);

itemsim_all.blc_load1_beta_C3           = squeeze(mean(itemsim_all.blc_load1(:,C3_index,beta_index,:), 3));
itemsim_all.blc_load2_sim_beta_C3       = squeeze(mean(itemsim_all.blc_load2_sim(:,C3_index,beta_index,:), 3));
itemsim_all.blc_load2_dif_beta_C3       = squeeze(mean(itemsim_all.blc_load2_dif(:,C3_index,beta_index,:), 3));
itemsim_all.blc_load4_beta_C3           = squeeze(mean(itemsim_all.blc_load4(:,C3_index,beta_index,:), 3));

itemsim_all.load1_load4_beta_C3         = squeeze(mean(itemsim_all.load1_load4(:,C3_index,beta_index,:), 3));
itemsim_all.load1_load2sim_beta_C3      = squeeze(mean(itemsim_all.load1_load2sim(:,C3_index,beta_index,:), 3));
itemsim_all.load1_load2dif_beta_C3      = squeeze(mean(itemsim_all.load1_load2dif(:,C3_index,beta_index,:), 3));
itemsim_all.load2sim_load2dif_beta_C3   = squeeze(mean(itemsim_all.load2sim_load2dif(:,C3_index,beta_index,:), 3));
itemsim_all.load2sim_load4_beta_C3      = squeeze(mean(itemsim_all.load2sim_load4(:,C3_index,beta_index,:), 3));
itemsim_all.load2dif_load4_beta_C3      = squeeze(mean(itemsim_all.load2dif_load4(:,C3_index,beta_index,:), 3));

%% Save grand average structures

save ([param.path, '/tfr GA contrasts/' 'itemsim_all_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'itemsim_all');

save ([param.path, '/tfr GA contrasts/' 'mean_itemsim_all_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'mean_itemsim_all');
