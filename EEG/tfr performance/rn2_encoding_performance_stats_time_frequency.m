%% Clean workspace

clc; clear; close all

%% Analysis settings

laplacian = true; % laplacian = false;
beh_data_cleaning = "fast-and-slow"; %'slow' %'none'

%% Load structures

this_subject = 1; % just need the general info

[param, ~, ~] = rn2_gen_param(this_subject); %just need param

load ([param.path, '/tfr GA contrasts/' 'performance_all_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'performance_all');
load ([param.path, '/tfr GA contrasts/' 'mean_performance_all_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'mean_performance_all');

%% Define structure for statistics (1D)

statcfg = [];

statcfg.xax = performance_all.time;
statcfg.npermutations = 10000;
statcfg.clusterStatEvalaluationAlpha = 0.025;
statcfg.nsub = size(performance_all.blc_load1_fast, 1);
statcfg.statMethod = 'montecarlo';  % statcfg.statMethod = 'analytic';

%% Define data structures (1D)

data_load1fast_load1slow_beta_C3    = performance_all.load1fast_load1slow_beta_C3;
data_load2fast_load2slow_beta_C3    = performance_all.load2fast_load2slow_beta_C3;
data_load4fast_load4slow_beta_C3    = performance_all.load4fast_load4slow_beta_C3;

data_zero = zeros(size(data_load1fast_load1slow_beta_C3));

%% Run stats (1D)

stat_load1fast_load1slow_beta_C3     = rn2_ftclusterstat1D(statcfg, data_load1fast_load1slow_beta_C3, data_zero);
stat_load2fast_load2slow_beta_C3     = rn2_ftclusterstat1D(statcfg, data_load2fast_load2slow_beta_C3, data_zero);
stat_load4fast_load4slow_beta_C3     = rn2_ftclusterstat1D(statcfg, data_load4fast_load4slow_beta_C3, data_zero);

%% Save (1D)

save ([param.path, '/tfr stats performance/' 'stat_load1fast_load1slow_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1fast_load1slow_beta_C3');
save ([param.path, '/tfr stats performance/' 'stat_load2fast_load2slow_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2fast_load2slow_beta_C3');
save ([param.path, '/tfr stats performance/' 'stat_load4fast_load4slow_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load4fast_load4slow_beta_C3');

%% Define structure for statistics (2D)

statcfg = [];

statcfg.xax = performance_all.time;
statcfg.yax = performance_all.freq;
statcfg.npermutations = 10000; % usually use 10.000 (but less for testing)
statcfg.clusterStatEvalaluationAlpha = 0.025;
statcfg.statMethod = 'montecarlo';  % statcfg.statMethod = 'analytic';

%% Define data structures (2D)

C3_index = ismember(performance_all.label, param.C3);

data_load1fast_load1slow_C3    = squeeze(performance_all.load1fast_load1slow(:,C3_index,:,:));
data_load2fast_load2slow_C3    = squeeze(performance_all.load2fast_load2slow(:,C3_index,:,:));
data_load4fast_load4slow_C3    = squeeze(performance_all.load4fast_load4slow(:,C3_index,:,:));

data_zero = zeros(size(data_load1fast_load1slow_C3));

%% Run stats (2D)

stat_load1fast_load1slow_C3     = rn2_ftclusterstat2D(statcfg, data_load1fast_load1slow_C3, data_zero);
stat_load2fast_load2slow_C3     = rn2_ftclusterstat2D(statcfg, data_load2fast_load2slow_C3, data_zero);
stat_load4fast_load4slow_C3     = rn2_ftclusterstat2D(statcfg, data_load4fast_load4slow_C3, data_zero);

%% Save stats (2D)

save ([param.path, '/tfr stats performance/' 'stat_load1fast_load1slow_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1fast_load1slow_C3');
save ([param.path, '/tfr stats performance/' 'stat_load2fast_load2slow_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2fast_load2slow_C3');
save ([param.path, '/tfr stats performance/' 'stat_load4fast_load4slow_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load4fast_load4slow_C3');
