%% Clean workspace

clc; clear; close all

%% Analysis settings

laplacian = true; % laplacian = false;
beh_data_cleaning = "fast-and-slow"; %'slow' %'none'

laplacian_text = 'yes'; % laplacian_text = 'no';

%% Open statistics structures

this_subject = 1; % just need the general info
[param, ~, ~] = rn2_gen_param(this_subject); %just need param

% Load 1 vs 2 vs 4
% 2D
load ([param.path, '/tfr stats/' 'stat_load1_load4_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1_load4_C3');
load ([param.path, '/tfr stats/' 'stat_load1_load2_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1_load2_C3');
load ([param.path, '/tfr stats/' 'stat_load2_load4_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2_load4_C3');
% 1D
load ([param.path, '/tfr stats/' 'stat_load1_load4_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1_load4_beta_C3');
load ([param.path, '/tfr stats/' 'stat_load1_load2_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1_load2_beta_C3');
load ([param.path, '/tfr stats/' 'stat_load2_load4_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2_load4_beta_C3');

% Similarity
% 2D
load ([param.path, '/tfr stats similarity/' 'stat_sim_load2sim_load2dif_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2sim_load2dif_C3');
load ([param.path, '/tfr stats similarity/' 'stat_sim_load2sim_load4_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2sim_load4_C3');
load ([param.path, '/tfr stats similarity/' 'stat_sim_load2dif_load4_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2dif_load4_C3');
% 1D
load ([param.path, '/tfr stats similarity/' 'stat_sim_load2sim_load2dif_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2sim_load2dif_beta_C3');
load ([param.path, '/tfr stats similarity/' 'stat_sim_load2sim_load4_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2sim_load4_beta_C3');
load ([param.path, '/tfr stats similarity/' 'stat_sim_load2dif_load4_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2dif_load4_beta_C3');

% Performance RT
% 2D
load ([param.path, '/tfr stats performance/' 'stat_load1fast_load1slow_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1fast_load1slow_C3');
load ([param.path, '/tfr stats performance/' 'stat_load2fast_load2slow_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2fast_load2slow_C3');
load ([param.path, '/tfr stats performance/' 'stat_load4fast_load4slow_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load4fast_load4slow_C3');
% 1D
load ([param.path, '/tfr stats performance/' 'stat_load1fast_load1slow_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1fast_load1slow_beta_C3');
load ([param.path, '/tfr stats performance/' 'stat_load2fast_load2slow_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2fast_load2slow_beta_C3');
load ([param.path, '/tfr stats performance/' 'stat_load4fast_load4slow_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load4fast_load4slow_beta_C3');

%% Get p-values: Load 1 vs 2 vs 4

%% Load 1 versus 4
sign = unique(squeeze(stat_load1_load4_C3.prob(1,:,:))) < 0.05; % all significant cluster p-values
p_load1v2v4.load1_load4_C3 = unique(squeeze(stat_load1_load4_C3.prob(1,:,:)));
p_load1v2v4.load1_load4_C3 = p_load1v2v4.load1_load4_C3(sign); % significant p-values

% where?
squeeze(stat_load1_load4_C3.prob(1,:,:)) == p_load1v2v4.load1_load4_C3(1) % location first cluster
p_load1v2v4.load1_load4_C3

% 1D
sign = unique(stat_load1_load4_beta_C3.prob) < 0.05; % all significant cluster p-values
p_load1v2v4.load1_load4_beta_C3 = unique(stat_load1_load4_beta_C3.prob);
p_load1v2v4.load1_load4_beta_C3 = p_load1v2v4.load1_load4_beta_C3(sign);

%% Load 1 versus 2
sign = unique(squeeze(stat_load1_load2_C3.prob(1,:,:))) < 0.05; % all significant cluster p-values
p_load1v2v4.load1_load2_C3 = unique(squeeze(stat_load1_load2_C3.prob(1,:,:)));
p_load1v2v4.load1_load2_C3 = p_load1v2v4.load1_load2_C3(sign); % significant p-values

% where?
squeeze(stat_load1_load2_C3.prob(1,:,:)) == p_load1v2v4.load1_load2_C3(1) % location first cluster
p_load1v2v4.load1_load2_C3

% 1D
sign = unique(stat_load1_load2_beta_C3.prob) < 0.05; % all significant cluster p-values
p_load1v2v4.load1_load2_beta_C3 = unique(stat_load1_load2_beta_C3.prob);
p_load1v2v4.load1_load2_beta_C3 = p_load1v2v4.load1_load2_beta_C3(sign);

%% Load 2 versus 4
sign = unique(squeeze(stat_load2_load4_C3.prob(1,:,:))) < 0.05; % all significant cluster p-values
p_load1v2v4.load2_load4_C3 = unique(squeeze(stat_load2_load4_C3.prob(1,:,:)));
p_load1v2v4.load2_load4_C3 = p_load1v2v4.load2_load4_C3(sign); % significant p-values

% where?
squeeze(stat_load2_load4_C3.prob(1,:,:)) == p_load1v2v4.load2_load4_C3(1) % location first cluster
squeeze(stat_load2_load4_C3.prob(1,:,:)) == p_load1v2v4.load2_load4_C3(2) % location second cluster

p_load1v2v4.load2_load4_C3

% 1D
sign = unique(stat_load2_load4_beta_C3.prob) < 0.05; % all significant cluster p-values
p_load1v2v4.load2_load4_beta_C3 = unique(stat_load2_load4_beta_C3.prob);
p_load1v2v4.load2_load4_beta_C3 = p_load1v2v4.load2_load4_beta_C3(sign);

%% Get p-values: Similarity

%% Load 2-sim versus 4
sign = unique(squeeze(stat_load2sim_load4_C3.prob(1,:,:))) < 0.05; % all significant cluster p-values
p_similarity.load2sim_load4_C3 = unique(squeeze(stat_load2sim_load4_C3.prob(1,:,:)));
p_similarity.load2sim_load4_C3 = p_similarity.load2sim_load4_C3(sign); % significant p-values

% where?
squeeze(stat_load2sim_load4_C3.prob(1,:,:)) == p_similarity.load2sim_load4_C3(1) % location first cluster

p_similarity.load2sim_load4_C3

% 1D
sign = unique(stat_load2sim_load4_beta_C3.prob) < 0.05; % all significant cluster p-values
p_similarity.load2sim_load4_beta_C3 = unique(stat_load2sim_load4_beta_C3.prob);
p_similarity.load2sim_load4_beta_C3 = p_similarity.load2sim_load4_beta_C3(sign);

%% Load 2-dif versus 4
sign = unique(squeeze(stat_load2dif_load4_C3.prob(1,:,:))) < 0.05; % all significant cluster p-values
p_similarity.load2dif_load4_C3 = unique(squeeze(stat_load2dif_load4_C3.prob(1,:,:)));
p_similarity.load2dif_load4_C3 = p_similarity.load2dif_load4_C3(sign); % significant p-values

% where?
squeeze(stat_load2dif_load4_C3.prob(1,:,:)) == p_similarity.load2dif_load4_C3(1) % location first cluster
squeeze(stat_load2dif_load4_C3.prob(1,:,:)) == p_similarity.load2dif_load4_C3(2) % location second cluster

p_similarity.load2dif_load4_C3

% 1D
sign = unique(stat_load2dif_load4_beta_C3.prob) < 0.05; % all significant cluster p-values
p_similarity.load2dif_load4_beta_C3 = unique(stat_load2dif_load4_beta_C3.prob);
p_similarity.load2dif_load4_beta_C3 = p_similarity.load2dif_load4_beta_C3(sign);

%% Load 2-sim versus 2-dif
sign = unique(squeeze(stat_load2sim_load2dif_C3.prob(1,:,:))) < 0.05; % all significant cluster p-values
p_similarity.load2sim_load2dif_C3 = unique(squeeze(stat_load2sim_load2dif_C3.prob(1,:,:)));
p_similarity.load2sim_load2dif_C3 = p_similarity.load2sim_load2dif_C3(sign); % significant p-values

% where? nowhere!
squeeze(stat_load2sim_load2dif_C3.prob(1,:,:))
p_similarity.load2sim_load2dif_C3

%% Get p-values: Performance RT

%% Load 1: fast vs slow
sign = unique(squeeze(stat_load1fast_load1slow_C3.prob(1,:,:))) < 0.05; % all significant cluster p-values
p_performance.load1fast_load1slow_C3 = unique(squeeze(stat_load1fast_load1slow_C3.prob(1,:,:)));
p_performance.load1fast_load1slow_C3 = p_performance.load1fast_load1slow_C3(sign); % significant p-values

% where?
squeeze(stat_load1fast_load1slow_C3.prob(1,:,:)) == p_performance.load1fast_load1slow_C3(1) % location first cluster
p_performance.load1fast_load1slow_C3

% 1D
sign = unique(stat_load1fast_load1slow_beta_C3.prob) < 0.05; % all significant cluster p-values
p_performance.load1fast_load1slow_beta_C3 = unique(stat_load1fast_load1slow_beta_C3.prob);
p_performance.load1fast_load1slow_beta_C3 = p_performance.load1fast_load1slow_beta_C3(sign);

%% Load 2: fast vs slow
sign = unique(squeeze(stat_load2fast_load2slow_C3.prob(1,:,:))) < 0.05; % all significant cluster p-values
p_performance.load2fast_load2slow_C3 = unique(squeeze(stat_load2fast_load2slow_C3.prob(1,:,:)));
p_performance.load2fast_load2slow_C3 = p_performance.load2fast_load2slow_C3(sign); % significant p-values

% where?
squeeze(stat_load2fast_load2slow_C3.prob(1,:,:)) == p_performance.load2fast_load2slow_C3(1) % location first cluster
p_performance.load2fast_load2slow_C3

% 1D
sign = unique(stat_load2fast_load2slow_beta_C3.prob) < 0.05; % all significant cluster p-values
p_performance.load2fast_load2slow_beta_C3 = unique(stat_load2fast_load2slow_beta_C3.prob);
p_performance.load2fast_load2slow_beta_C3 = p_performance.load2fast_load2slow_beta_C3(sign);

%% Load 4: fast vs slow
sign = unique(squeeze(stat_load4fast_load4slow_C3.prob(1,:,:))) < 0.05; % all significant cluster p-values
p_performance.load4fast_load4slow_C3 = unique(squeeze(stat_load4fast_load4slow_C3.prob(1,:,:)));
p_performance.load4fast_load4slow_C3 = p_performance.load4fast_load4slow_C3(sign); % significant p-values

% where? nowhere!
squeeze(stat_load4fast_load4slow_C3.prob(1,:,:))

% 1D
sign = unique(stat_load4fast_load4slow_beta_C3.prob) < 0.05; % all significant cluster p-values
p_performance.load4fast_load4slow_beta_C3 = unique(stat_load4fast_load4slow_beta_C3.prob);
p_performance.load4fast_load4slow_beta_C3 = p_performance.load4fast_load4slow_beta_C3(sign);
