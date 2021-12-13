%% Clean workspace

clc; clear; close all

%% Analysis settings

laplacian = true; % laplacian = false;
beh_data_cleaning = "fast-and-slow"; %'slow' %'none'

%% Load structures

this_subject = 1; % just need the general info

[param, ~, ~] = rn2_gen_param(this_subject); %just need param

load ([param.path, '/tfr GA contrasts/' 'load1vs2vs4_all_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'load1v2v4_all');
load ([param.path, '/tfr GA contrasts/' 'mean_load1vs2vs4_all_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'mean_load1v2v4_all');

%% Define structure for statistics (1D)

statcfg = [];

statcfg.xax = load1v2v4_all.time;
statcfg.npermutations = 10000;
statcfg.clusterStatEvalaluationAlpha = 0.025;
statcfg.nsub = size(load1v2v4_all.blc_load1, 1);
statcfg.statMethod = 'montecarlo';  % statcfg.statMethod = 'analytic';

%% Define data structures (1D)

data_load1_load4_beta_C3 = load1v2v4_all.load1_load4_beta_C3;
data_load1_load2_beta_C3 = load1v2v4_all.load1_load2_beta_C3;
data_load2_load4_beta_C3 = load1v2v4_all.load2_load4_beta_C3;

data_zero = zeros(size(data_load1_load4_beta_C3));

%% Run stats (1D)

stat_load1_load4_beta_C3 = frevede_ftclusterstat1D(statcfg, data_load1_load4_beta_C3, data_zero);
stat_load1_load2_beta_C3 = frevede_ftclusterstat1D(statcfg, data_load1_load2_beta_C3, data_zero);
stat_load2_load4_beta_C3 = frevede_ftclusterstat1D(statcfg, data_load2_load4_beta_C3, data_zero);

%% Save (1D)

save ([param.path, '/tfr stats/' 'stat_load1_load4_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1_load4_beta_C3');
save ([param.path, '/tfr stats/' 'stat_load1_load2_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1_load2_beta_C3');
save ([param.path, '/tfr stats/' 'stat_load2_load4_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2_load4_beta_C3');

%% Define structure for statistics (2D)

statcfg = [];

statcfg.xax = load1v2v4_all.time;
statcfg.yax = load1v2v4_all.freq;
statcfg.npermutations = 10000; % usually use 10.000 (but less for testing)
statcfg.clusterStatEvalaluationAlpha = 0.025;
statcfg.statMethod = 'montecarlo';  % statcfg.statMethod = 'analytic';

%% Define data structures (2D)

C3_index = ismember(load1v2v4_all.label, param.C3);

data_load1_load4_C3 = squeeze(load1v2v4_all.load1_load4(:,C3_index,:,:));
data_load1_load2_C3 = squeeze(load1v2v4_all.load1_load2(:,C3_index,:,:));
data_load2_load4_C3 = squeeze(load1v2v4_all.load2_load4(:,C3_index,:,:));

data_zero = zeros(size(data_load1_load4_C3));

%% Run stats (2D)

stat_load1_load4_C3 = frevede_ftclusterstat2D(statcfg, data_load1_load4_C3, data_zero);
stat_load1_load2_C3 = frevede_ftclusterstat2D(statcfg, data_load1_load2_C3, data_zero);
stat_load2_load4_C3 = frevede_ftclusterstat2D(statcfg, data_load2_load4_C3, data_zero);

%% Save (2D)

save ([param.path, '/tfr stats/' 'stat_load1_load4_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1_load4_C3');
save ([param.path, '/tfr stats/' 'stat_load1_load2_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1_load2_C3');
save ([param.path, '/tfr stats/' 'stat_load2_load4_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2_load4_C3');





