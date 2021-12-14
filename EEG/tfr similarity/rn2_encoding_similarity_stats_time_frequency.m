%% Clean workspace

clc; clear; close all

%% Analysis settings

laplacian = true; % laplacian = false;
beh_data_cleaning = "fast-and-slow"; %'slow' %'none'

%% Load structures

this_subject = 1; % just need the general info
[param, ~, ~] = rn2_gen_param(this_subject); %just need param

load ([param.path, '/tfr GA contrasts/' 'itemsim_all_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'itemsim_all');
load ([param.path, '/tfr GA contrasts/' 'mean_itemsim_all_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'mean_itemsim_all');

%% Define structure for statistics (1D)

statcfg = [];

statcfg.xax = itemsim_all.time;
statcfg.npermutations = 10000;
statcfg.clusterStatEvalaluationAlpha = 0.025;
statcfg.nsub = size(itemsim_all.blc_load1, 1);
statcfg.statMethod = 'montecarlo';  % statcfg.statMethod = 'analytic';

%% Define data structures (1D)

data_load1_load4_beta_C3        = itemsim_all.load1_load4_beta_C3;
data_load1_load2sim_beta_C3     = itemsim_all.load1_load2sim_beta_C3;
data_load1_load2dif_beta_C3     = itemsim_all.load1_load2dif_beta_C3;
data_load2sim_load2dif_beta_C3  = itemsim_all.load2sim_load2dif_beta_C3;
data_load2sim_load4_beta_C3     = itemsim_all.load2sim_load4_beta_C3;
data_load2dif_load4_beta_C3     = itemsim_all.load2dif_load4_beta_C3;

data_zero = zeros(size(data_load1_load4_beta_C3));

%% Run stats (1D)

stat_load1_load4_beta_C3        = rn2_ftclusterstat1D(statcfg, data_load1_load4_beta_C3, data_zero);
stat_load1_load2sim_beta_C3     = rn2_ftclusterstat1D(statcfg, data_load1_load2sim_beta_C3, data_zero);
stat_load1_load2dif_beta_C3     = rn2_ftclusterstat1D(statcfg, data_load1_load2dif_beta_C3, data_zero);
stat_load2sim_load2dif_beta_C3  = rn2_ftclusterstat1D(statcfg, data_load2sim_load2dif_beta_C3, data_zero);
stat_load2sim_load4_beta_C3     = rn2_ftclusterstat1D(statcfg, data_load2sim_load4_beta_C3, data_zero);
stat_load2dif_load4_beta_C3     = rn2_ftclusterstat1D(statcfg, data_load2dif_load4_beta_C3, data_zero);

%% Save (1D)

save ([param.path, '/tfr stats similarity/' 'stat_sim_load1_load4_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning) ], 'stat_load1_load4_beta_C3');
save ([param.path, '/tfr stats similarity/' 'stat_sim_load1_load2sim_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1_load2sim_beta_C3');
save ([param.path, '/tfr stats similarity/' 'stat_sim_load1_load2dif_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1_load2dif_beta_C3');
save ([param.path, '/tfr stats similarity/' 'stat_sim_load2sim_load2dif_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2sim_load2dif_beta_C3');
save ([param.path, '/tfr stats similarity/' 'stat_sim_load2sim_load4_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2sim_load4_beta_C3');
save ([param.path, '/tfr stats similarity/' 'stat_sim_load2dif_load4_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2dif_load4_beta_C3');

%% Define structure for statistics (2D)

statcfg = [];

statcfg.xax = itemsim_all.time;
statcfg.yax = itemsim_all.freq;
statcfg.npermutations = 10000; % usually use 10.000 (but less for testing)
statcfg.clusterStatEvalaluationAlpha = 0.025;
statcfg.statMethod = 'montecarlo';  % statcfg.statMethod = 'analytic';

%% Define data structures (2D)

C3_index = ismember(itemsim_all.label, param.C3);

data_load1_load4_C3        = squeeze(itemsim_all.load1_load4(:,C3_index,:,:));
data_load1_load2sim_C3     = squeeze(itemsim_all.load1_load2sim(:,C3_index,:,:));
data_load1_load2dif_C3     = squeeze(itemsim_all.load1_load2dif(:,C3_index,:,:));
data_load2sim_load2dif_C3  = squeeze(itemsim_all.load2sim_load2dif(:,C3_index,:,:));
data_load2sim_load4_C3     = squeeze(itemsim_all.load2sim_load4(:,C3_index,:,:));
data_load2dif_load4_C3     = squeeze(itemsim_all.load2dif_load4(:,C3_index,:,:));

data_zero = zeros(size(data_load1_load4_C3));

%% Run stats (2D)

stat_load1_load4_C3 = rn2_ftclusterstat2D(statcfg, data_load1_load4_C3, data_zero);
stat_load1_load2sim_C3 = rn2_ftclusterstat2D(statcfg, data_load1_load2sim_C3, data_zero);
stat_load1_load2dif_C3 = rn2_ftclusterstat2D(statcfg, data_load1_load2dif_C3, data_zero);
stat_load2sim_load2dif_C3 = rn2_ftclusterstat2D(statcfg, data_load2sim_load2dif_C3, data_zero);
stat_load2sim_load4_C3 = rn2_ftclusterstat2D(statcfg, data_load2sim_load4_C3, data_zero);
stat_load2dif_load4_C3 = rn2_ftclusterstat2D(statcfg, data_load2dif_load4_C3, data_zero);

%% Save stats (2D)

save ([param.path, '/tfr stats similarity/' 'stat_sim_load1_load4_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1_load4_C3');
save ([param.path, '/tfr stats similarity/' 'stat_sim_load1_load2sim_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1_load2sim_C3');
save ([param.path, '/tfr stats similarity/' 'stat_sim_load1_load2dif_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1_load2dif_C3');
save ([param.path, '/tfr stats similarity/' 'stat_sim_load2sim_load2dif_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2sim_load2dif_C3');
save ([param.path, '/tfr stats similarity/' 'stat_sim_load2sim_load4_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2sim_load4_C3');
save ([param.path, '/tfr stats similarity/' 'stat_sim_load2dif_load4_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2dif_load4_C3');
