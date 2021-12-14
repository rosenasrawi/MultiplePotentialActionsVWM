%% Description 

% Script to plot TFR, topographies and time-course for each performance 
% comparison and memory load condition and save the plots as .eps files

%% Clean workspace

clc; clear; close all

%% Load structures for plotting

laplacian = true; % laplacian = false;

laplacian_text = 'yes'; % laplacian_text = 'no';
beh_data_cleaning = "fast-and-slow"; %'slow' %'none'

this_subject = 1; % just need the general info

[param, ~, ~] = rn2_gen_param(this_subject); %just need param

load ([param.path, '/tfr GA contrasts/' 'performance_all_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'performance_all');
load ([param.path, '/tfr GA contrasts/' 'mean_performance_all_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'mean_performance_all');

%% Load stats

% 1D
load ([param.path, '/tfr stats performance/' 'stat_load1fast_load1slow_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1fast_load1slow_beta_C3');
load ([param.path, '/tfr stats performance/' 'stat_load2fast_load2slow_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2fast_load2slow_beta_C3');
load ([param.path, '/tfr stats performance/' 'stat_load4fast_load4slow_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load4fast_load4slow_beta_C3');

% 2D
load ([param.path, '/tfr stats performance/' 'stat_load1fast_load1slow_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1fast_load1slow_C3');
load ([param.path, '/tfr stats performance/' 'stat_load2fast_load2slow_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2fast_load2slow_C3');
load ([param.path, '/tfr stats performance/' 'stat_load4fast_load4slow_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load4fast_load4slow_C3');

%% Color for time-course

color_10 = [145, 145, 145] / 255;    % Grey

%% Performance RT's - Fast vs slow

%% RT variables

contrasts_rt_comp           = {'load1fast_load1slow','load2fast_load2slow','load4fast_load4slow'};
masks_rt_com                = {'mask_load1fast_load1slow_C3','mask_load2fast_load2slow_C3', 'mask_load2fast_load4slow_C3'};
titles_rt_comp              = {'Load 1: fast vs slow','Load 2: fast vs slow','Load 4: fast vs slow'};

contrasts_rt_blc            = {'blc_load1_fast_beta_C3', 'blc_load1_slow_beta_C3', 'blc_load2_fast_beta_C3', 'blc_load2_slow_beta_C3', 'blc_load4_fast_beta_C3', 'blc_load4_slow_beta_C3'};
titles_rt_blc               = {'Load 1 (fast)', 'Load 1 (slow)', 'Load 2 (fast)', 'Load 2 (slow)', 'Load 4 (fast)', 'Load 4 (slow)'};

%% Change mask for 2D

for channel = 1:length(mean_performance_all.label)
    mean_performance_all.mask_load1fast_load1slow_C3(channel,:,:)           = squeeze(stat_load1fast_load1slow_C3.mask);
    mean_performance_all.mask_load2fast_load2slow_C3(channel,:,:)           = squeeze(stat_load2fast_load2slow_C3.mask);
    mean_performance_all.mask_load2fast_load4slow_C3(channel,:,:)           = squeeze(stat_load4fast_load4slow_C3.mask);
end

%% Plot TFR C3 (RT)

select_channels = {'C3'}; 
zlims = {[-12 12], [-12 12], [-12 12]};

for channel = 1:length(select_channels)
    
    cfg = [];

    cfg.channel   = select_channels{channel};
    cfg.layout    = 'easycapM1.mat';
    cfg.figure    = "gcf";
    cfg.xlim      = [-.35 2.5];
    cfg.colorbar  = 'no';

    for contrast = 1:length(contrasts_rt_comp)
        cfg.zlim            = zlims{contrast};
        cfg.parameter       = contrasts_rt_comp{contrast};
        cfg.maskparameter   = masks_rt_com{contrast};
        cfg.maskstyle       = 'outline';
        
        subplot(1,3,contrast);
        ft_singleplotTFR(cfg, mean_performance_all);
        colormap(flipud(brewermap(100,'RdBu')));

        title(titles_rt_comp{contrast}, 'FontSize', 14);
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

saveas(gcf, [param.figpath 'TFR-C3-performance-RT-' 'lapl-' laplacian_text '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'epsc');

%% Topoplot contrasts 

title_timeselect = {'0.5-1s', '1-1.5s', '1.5-2s'};
zlims = {[-6 6], [-6 6], [-6 6]};

for contrast = 1:length(contrasts_rt_comp)    
    cfg = [];

    cfg.layout    = 'easycapM1.mat';
    cfg.zlim      = zlims{contrast};
    cfg.ylim      = param.betaband;
    cfg.comment   = 'no';
    cfg.parameter = contrasts_rt_comp{contrast};
    cfg.style     = 'straight';
    cfg.colorbar  = 'no';    

    figure;
    sgtitle(['Topoplots: ' titles_rt_comp{contrast}], 'FontSize', 16, 'FontWeight', 'bold'); 

    for time = 1:length(title_timeselect)
        cfg.xlim      = param.timeselect{time};

        subplot(1,3,time);

        ft_topoplotTFR(cfg, mean_performance_all);
        colormap(flipud(brewermap(100,'RdBu')));
        title(title_timeselect{time}, 'FontSize', 14,  'FontWeight', 'normal', 'Position', [0, -1, 0]);
    end
    
    %% Save

    set(gcf, "renderer", "Painters");
    set(gcf, "Position", [100 100 600 600]);
    saveas(gcf, [param.figpath 'topo-' titles_rt_comp{contrast} 'lapl-' laplacian_text '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'epsc');
    
end

%% Plot time-course C3 (RT)

mask_load1fast_load1slow_beta_C3 = double(stat_load1fast_load1slow_beta_C3.mask); 
mask_load1fast_load1slow_beta_C3(mask_load1fast_load1slow_beta_C3==0) = nan; % nan data that is not part of mark

mask_load2fast_load2slow_beta_C3 = double(stat_load2fast_load2slow_beta_C3.mask); 
mask_load2fast_load2slow_beta_C3(mask_load2fast_load2slow_beta_C3==0) = nan; % nan data that is not part of mark

mask_load4fast_load4slow_beta_C3 = double(stat_load4fast_load4slow_beta_C3.mask); 
mask_load4fast_load4slow_beta_C3(mask_load4fast_load4slow_beta_C3==0) = nan; % nan data that is not part of mark

verticaloffset = -1;

figure;

%% Load one: fast vs slow

subplot(1,3,1);

[m_plot1] = rn2_errorbarplot(performance_all.time, performance_all.load1fast_load1slow_beta_C3, color_10, 'se');

axis([-.25 2.5 -15 10]);
plot([0,0], ylim, 'k'); 
plot([2,2], ylim, 'k');
plot(xlim, [0,0], '--k');
plot(performance_all.time, mask_load1fast_load1slow_beta_C3*verticaloffset, 'k', 'LineWidth', 2);

legend(m_plot1, titles_rt_comp{1}, 'AutoUpdate', 'off', 'Location', 'north','FontSize', 12);
xlabel('Time (s)','FontSize', 13);
ylabel('Betaband suppression (15-25 Hz)','FontSize', 13);

%% Load one: fast vs slow

subplot(1,3,2);

[m_plot2] = rn2_errorbarplot(performance_all.time, performance_all.load2fast_load2slow_beta_C3, color_10, 'se');

axis([-.25 2.5 -15 10]);
plot([0,0], ylim, 'k'); 
plot([2,2], ylim, 'k');
plot(xlim, [0,0], '--k');
plot(performance_all.time, mask_load2fast_load2slow_beta_C3*verticaloffset, 'k', 'LineWidth', 2);

legend(m_plot2, titles_rt_comp{2}, 'AutoUpdate', 'off', 'Location', 'north','FontSize', 12);
xlabel('Time (s)','FontSize', 13);

%% Load one: fast vs slow

subplot(1,3,3);

[m_plot3] = rn2_errorbarplot(performance_all.time, performance_all.load4fast_load4slow_beta_C3, color_10, 'se');

axis([-.25 2.5 -15 10]);
plot([0,0], ylim, 'k'); 
plot([2,2], ylim, 'k');
plot(xlim, [0,0], '--k');
plot(performance_all.time, mask_load4fast_load4slow_beta_C3*verticaloffset, 'k', 'LineWidth', 2);

legend(m_plot3, titles_rt_comp{3}, 'AutoUpdate', 'off', 'Location', 'north','FontSize', 12);
xlabel('Time (s)','FontSize', 13);

sgtitle('Fast versus slow in C3','FontSize', 14);

set(gcf, "renderer", "Painters");
set(gcf, "Position", [100 100 1200 300]);

%% Save

saveas(gcf, [param.figpath 'beta-C3-subplot-performance-RT-comparisons-' 'lapl-' laplacian_text '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'epsc');
