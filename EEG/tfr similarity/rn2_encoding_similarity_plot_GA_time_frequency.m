%% Clean workspace

clc; clear; close all

%% Load structures for plotting

laplacian = true; % laplacian = false;

laplacian_text = 'yes'; % laplacian_text = 'no';
beh_data_cleaning = "fast-and-slow"; %'slow' %'none'

this_subject = 1; % just need the general info

[param, ~, ~] = rn2_gen_param(this_subject); %just need param

load ([param.path, '/tfr GA contrasts/' 'itemsim_all_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'itemsim_all');
load ([param.path, '/tfr GA contrasts/' 'mean_itemsim_all_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'mean_itemsim_all');

%% Load stats

% 1D

load ([param.path, '/tfr stats similarity/' 'stat_sim_load1_load4_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning) ], 'stat_load1_load4_beta_C3');
load ([param.path, '/tfr stats similarity/' 'stat_sim_load1_load2sim_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1_load2sim_beta_C3');
load ([param.path, '/tfr stats similarity/' 'stat_sim_load1_load2dif_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1_load2dif_beta_C3');
load ([param.path, '/tfr stats similarity/' 'stat_sim_load2sim_load2dif_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2sim_load2dif_beta_C3');
load ([param.path, '/tfr stats similarity/' 'stat_sim_load2sim_load4_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2sim_load4_beta_C3');
load ([param.path, '/tfr stats similarity/' 'stat_sim_load2dif_load4_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2dif_load4_beta_C3');

% 2D

load ([param.path, '/tfr stats similarity/' 'stat_sim_load1_load4_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1_load4_C3');
load ([param.path, '/tfr stats similarity/' 'stat_sim_load1_load2sim_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1_load2sim_C3');
load ([param.path, '/tfr stats similarity/' 'stat_sim_load1_load2dif_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1_load2dif_C3');
load ([param.path, '/tfr stats similarity/' 'stat_sim_load2sim_load2dif_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2sim_load2dif_C3');
load ([param.path, '/tfr stats similarity/' 'stat_sim_load2sim_load4_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2sim_load4_C3');
load ([param.path, '/tfr stats similarity/' 'stat_sim_load2dif_load4_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2dif_load4_C3');

%% Nice colors for plotting

color_1 = [224,152,7] / 255;    % Orange
color_2 = [153,72,224] / 255;   % Purple
color_3 = [21,161,121] / 255;   % Green

color_4 = [242,216,1] / 255;    % Yellow
color_5 = [205,78,51] / 255;    % Red
color_6 = [24,138,161] / 255;   % Blue


color_7 = [179, 31, 44] / 255;      % Red       % 1
color_8 = [23, 94, 162] / 255;      % Blue      % 2
color_9 = [211, 189, 32] / 255;     % Yellow    % 4

color_10 = [145, 145, 145] / 255;    % Grey

color_11 = [29,119,204] / 255;   % Blue (light) 
color_12 = [18,75,128] / 255;    % Blue (dark)

%% LOAD COMPARISONS - variables

% Loads comparisons
contrasts_loadcomp          = {'load2sim_load2dif','load2sim_load4','load2dif_load4'};
masks_loadcomp              = {'mask_load2sim_load2dif_C3','mask_load2sim_load4_C3','mask_load2dif_load4_C3'};
titles_loadcomp             = {'Load 2 (sim) vs 2 (dif)','Load 2 (sim) vs 4','Load 2 (dif) vs 4'};

% Baseline corrected
contrasts_blc_loads         = {'blc_load2_sim', 'blc_load2_dif', 'blc_load4'};
titles_blc_loads            = {'Load 2 (sim)', 'Load 2 (dif)', 'Load 4'};

%% Plot contrasts - selected channels (C3, POz, Fz)

for channel = 1:length(mean_itemsim_all.label)
    mean_itemsim_all.mask_load1_load4_C3(channel,:,:)       = squeeze(stat_load1_load4_C3.mask);
    mean_itemsim_all.mask_load1_load2sim_C3(channel,:,:)    = squeeze(stat_load1_load2sim_C3.mask);
    mean_itemsim_all.mask_load1_load2dif_C3(channel,:,:)    = squeeze(stat_load1_load2dif_C3.mask);
    mean_itemsim_all.mask_load2sim_load2dif_C3(channel,:,:) = squeeze(stat_load2sim_load2dif_C3.mask);
    mean_itemsim_all.mask_load2sim_load4_C3(channel,:,:)    = squeeze(stat_load2sim_load4_C3.mask);
    mean_itemsim_all.mask_load2dif_load4_C3(channel,:,:)    = squeeze(stat_load2dif_load4_C3.mask);
end

%% Multiplot (RT)

cfg = [];

for contrast = 1:length(contrasts_loadcomp)
    cfg.zlim            = 'maxabs';
    cfg.parameter       = contrasts_loadcomp{contrast};
    cfg.layout          = 'easycapM1.lay';

    ft_multiplotTFR_2(cfg, mean_itemsim_all);
    title(titles_loadcomp{contrast});
    colormap(flipud(brewermap(100,'RdBu')));

end

%% Plot
%select_channels = {'C3','POz','Fz'};
select_channels = {'C3'}; 

zlims = {[-12 12], [-12 12], [-12 12]};
%zlims = {'maxabs'};

for channel = 1:length(select_channels)
    
    cfg = [];

    cfg.channel   = select_channels{channel};
    cfg.layout    = 'easycapM1.mat';
    cfg.figure    = "gcf";
    cfg.xlim      = [-.35 2.5];
    cfg.colorbar  = 'no';

    for contrast = 1:length(contrasts_loadcomp)
        cfg.zlim            = zlims{contrast};
        cfg.parameter       = contrasts_loadcomp{contrast};
        cfg.maskparameter   = masks_loadcomp{contrast};
        cfg.maskstyle       = 'outline';
        
        subplot(1,3,contrast);
        ft_singleplotTFR(cfg,mean_itemsim_all);
        colormap(flipud(brewermap(100,'RdBu')));

        title(titles_loadcomp{contrast}, 'FontSize', 14);
        xlabel('Time (s)', 'FontSize', 13);
        ylabel('Frequency (Hz)', 'FontSize', 13);

        hold on;

        plot([0,0], ylim, 'k');
        plot([2,2], ylim, 'k');

    end

end

set(gcf, "renderer", "Painters");
set(gcf, "Position", [100 100 1200 300]);

%% Save 

saveas(gcf, [param.figpath 'TFR-C3-itemsim-' 'lapl-' laplacian_text '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'epsc');

%% Topoplot contrasts 

title_timeselect = {'0.5-1s', '1-1.5s', '1.5-2s'};
zlims = {[-8 8], [-7 7], [-6 6]};

for contrast = 1:length(contrasts_loadcomp)    
    cfg = [];

    cfg.layout    = 'easycapM1.mat';
    cfg.zlim      = zlims{contrast};
    cfg.ylim      = param.betaband;
    cfg.comment   = 'no';
    cfg.parameter = contrasts_loadcomp{contrast};
    cfg.style     = 'straight';
    cfg.colorbar  = 'no';    

    figure;
    sgtitle(['Topoplots: ' titles_loadcomp{contrast}], 'FontSize', 16, 'FontWeight', 'bold'); 

    for time = 1:length(title_timeselect)
        cfg.xlim      = param.timeselect{time};

        subplot(1,3,time);

        ft_topoplotTFR(cfg,mean_itemsim_all);
        colormap(flipud(brewermap(100,'RdBu')));
        title(title_timeselect{time}, 'FontSize', 14,  'FontWeight', 'normal', 'Position', [0, -1, 0]);
    end
    
    %% Save

    set(gcf, "renderer", "Painters");
    set(gcf, "Position", [100 100 600 600]);
    saveas(gcf, [param.figpath 'topo-' titles_loadcomp{contrast} 'lapl-' laplacian_text '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'epsc');
    
end

%% Plot comparisons next to one another

% %% Plot timecourses loads betaband (side by side)
% 
% figure;
% subplot(1,3,1);
% 
% [m_plot1] = frevede_errorbarplot(itemsim_all.time, itemsim_all.blc_load2_sim_beta_C3, color_11, 'se');
% [m_plot3] = frevede_errorbarplot(itemsim_all.time, itemsim_all.blc_load2_dif_beta_C3, color_12, 'se');
% 
% axis([-.35 2.5 -50 30]);
% plot([0,0], ylim, 'k'); 
% plot([2,2], ylim, 'k');
% 
% legend([m_plot1, m_plot3], titles_blc_loads{[1 2]}, 'AutoUpdate', 'off', 'Location', 'northeast','FontSize', 12); 
% xlabel('Time (s)','FontSize', 13);
% ylabel('Betaband (15-30 Hz) power','FontSize', 13);
% 
% subplot(1,3,2);
% 
% [m_plot1] = frevede_errorbarplot(itemsim_all.time, itemsim_all.blc_load2_sim_beta_C3, color_11, 'se');
% [m_plot2] = frevede_errorbarplot(itemsim_all.time, itemsim_all.blc_load4_beta_C3, color_9, 'se');
% 
% axis([-.35 2.5 -50 30]);
% plot([0,0], ylim, 'k'); 
% plot([2,2], ylim, 'k');
% 
% legend([m_plot1, m_plot2], titles_blc_loads{[1 3]}, 'AutoUpdate', 'off', 'Location', 'northeast','FontSize', 12);
% xlabel('Time (s)','FontSize', 13);
% 
% subplot(1,3,3);
% 
% [m_plot2] = frevede_errorbarplot(itemsim_all.time, itemsim_all.blc_load2_dif_beta_C3, color_12, 'se');
% [m_plot3] = frevede_errorbarplot(itemsim_all.time, itemsim_all.blc_load4_beta_C3, color_9, 'se');
% 
% axis([-.35 2.5 -50 30]);
% plot([0,0], ylim, 'k'); 
% plot([2,2], ylim, 'k');
% 
% legend([m_plot2, m_plot3], titles_blc_loads{[2 3]}, 'AutoUpdate', 'off', 'Location', 'northeast','FontSize', 12); 
% xlabel('Time (s)','FontSize', 13);
% 
% 
% sgtitle('Baseline corrected loads in C3','FontSize', 14);
% 
% 
% 
% %% Save
% 
% saveas(gcf, [param.figpath 'beta-C3-subplot-itemsim-baseline-corrected-' 'lapl-' laplacian_text '.png'])

%% Plot timecourses load comparisons betaband (side by side)

% To plot mask as vertal line

mask_load2sim_load2dif_beta_C3 = double(stat_load2sim_load2dif_beta_C3.mask); 
mask_load2sim_load2dif_beta_C3(mask_load2sim_load2dif_beta_C3==0) = nan; % nan data that is not part of mark

mask_load2sim_load4_beta_C3 = double(stat_load2sim_load4_beta_C3.mask); 
mask_load2sim_load4_beta_C3(mask_load2sim_load4_beta_C3==0) = nan; % nan data that is not part of mark

mask_load2dif_load4_beta_C3 = double(stat_load2dif_load4_beta_C3.mask); 
mask_load2dif_load4_beta_C3(mask_load2dif_load4_beta_C3==0) = nan; % nan data that is not part of mark

verticaloffset = -1;

figure;
subplot(1,3,1);

[m_plot1] = frevede_errorbarplot(itemsim_all.time, itemsim_all.load2sim_load2dif_beta_C3, color_10, 'se');

axis([-.25 2.5 -15 10]);
plot([0,0], ylim, 'k'); 
plot([2,2], ylim, 'k');
plot(xlim, [0,0], '--k');
plot(itemsim_all.time, mask_load2sim_load2dif_beta_C3*verticaloffset, 'k', 'LineWidth', 2);


legend(m_plot1, titles_loadcomp{1}, 'AutoUpdate', 'off', 'Location', 'north','FontSize', 12);
xlabel('Time (s)','FontSize', 13);
ylabel('Betaband suppression (15-25 Hz)','FontSize', 13);

subplot(1,3,2);

[m_plot2] = frevede_errorbarplot(itemsim_all.time, itemsim_all.load2sim_load4_beta_C3, color_10, 'se');

axis([-.25 2.5 -15 10]);
plot([0,0], ylim, 'k'); 
plot([2,2], ylim, 'k');
plot(xlim, [0,0], '--k');
plot(itemsim_all.time, mask_load2sim_load4_beta_C3*verticaloffset, 'k', 'LineWidth', 2);

legend(m_plot2, titles_loadcomp{2}, 'AutoUpdate', 'off', 'Location', 'north','FontSize', 12);
xlabel('Time (s)','FontSize', 13);

subplot(1,3,3);

[m_plot3] = frevede_errorbarplot(itemsim_all.time, itemsim_all.load2dif_load4_beta_C3, color_10, 'se');

axis([-.25 2.5 -15 10]);
plot([0,0], ylim, 'k'); 
plot([2,2], ylim, 'k');
plot(xlim, [0,0], '--k');
plot(itemsim_all.time, mask_load2dif_load4_beta_C3*verticaloffset, 'k', 'LineWidth', 2);

legend(m_plot3, titles_loadcomp{3}, 'AutoUpdate', 'off', 'Location', 'north','FontSize', 12);
xlabel('Time (s)','FontSize', 13);

sgtitle('Load comparison in C3','FontSize', 14);

set(gcf, "renderer", "Painters");
set(gcf, "Position", [100 100 1200 300]);

%% Save

saveas(gcf, [param.figpath 'beta-C3-subplot-itemsim-comparisons-' 'lapl-' laplacian_text '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'epsc');
