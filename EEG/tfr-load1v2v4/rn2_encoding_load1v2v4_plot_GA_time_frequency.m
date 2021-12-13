%% Clean workspace

clc; clear; close all

%% Analysis settings

laplacian = true; % laplacian = false;
beh_data_cleaning = "fast-and-slow"; %'slow' %'none'

laplacian_text = 'yes'; % laplacian_text = 'no';

%% Load structures for plotting

this_subject = 1; % just need the general info 

[param, ~, ~] = rn2_gen_param(this_subject); %just need param

load ([param.path, '/tfr GA contrasts/' 'load1vs2vs4_all_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'load1v2v4_all');
load ([param.path, '/tfr GA contrasts/' 'mean_load1vs2vs4_all_encoding_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'mean_load1v2v4_all');

%% Load stats

% 1D
load ([param.path, '/tfr stats/' 'stat_load1_load4_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1_load4_beta_C3');
load ([param.path, '/tfr stats/' 'stat_load1_load2_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1_load2_beta_C3');
load ([param.path, '/tfr stats/' 'stat_load2_load4_beta_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2_load4_beta_C3');

% 2D
load ([param.path, '/tfr stats/' 'stat_load1_load4_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1_load4_C3');
load ([param.path, '/tfr stats/' 'stat_load1_load2_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load1_load2_C3');
load ([param.path, '/tfr stats/' 'stat_load2_load4_C3_lapl' num2str(laplacian) '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'stat_load2_load4_C3');

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

%% LOAD COMPARISONS - variables

% Loads comparisons
contrasts_loadcomp          = {'load1_load4','load1_load2','load2_load4'};
masks_loadcomp              = {'mask_load1_load4_C3','mask_load1_load2_C3','mask_load2_load4_C3'};
titles_loadcomp             = {'Load 1 versus 4', 'Load 1 versus 2', 'Load 2 versus 4'};

% Baseline corrected
contrasts_blc_loads         = {'blc_load1', 'blc_load2', 'blc_load4'};
titles_blc_loads            = {'Load 1 (baseline)', 'Load 2 (baseline)', 'Load 4 (baseline)'};

%% Plot contrasts - selected channels (C3, POz, Fz)

for channel = 1:length(mean_load1v2v4_all.label)
    mean_load1v2v4_all.mask_load1_load4_C3(channel,:,:) = squeeze(stat_load1_load4_C3.mask);
    mean_load1v2v4_all.mask_load1_load2_C3(channel,:,:) = squeeze(stat_load1_load2_C3.mask);
    mean_load1v2v4_all.mask_load2_load4_C3(channel,:,:) = squeeze(stat_load2_load4_C3.mask);
end

%% Multiplot

% cfg = [];
% 
% for contrast = 1:length(contrasts_loadcomp)
%     cfg.zlim            = 'maxabs';
%     cfg.parameter       = contrasts_loadcomp{contrast};
%     cfg.layout          = 'easycapM1.lay';
%     cfg.showlabels      = 'yes';
% 
%     ft_multiplotTFR_2(cfg, mean_load1v2v4_all);
%     title(titles_loadcomp{contrast});
%     colormap(flipud(brewermap(100,'RdBu')));
% 
% end

%%
%select_channels = {'C3','POz','Fz'};
select_channels = {'C3'}; 

zlims = {[-20 20], [-15 15], [-10 10]};

for channel = 1:length(select_channels)
    
    cfg = [];

    cfg.channel   = select_channels{channel};
    cfg.layout    = 'easycapM1.mat';
    cfg.figure    = "gcf";
    %cfg.xlim      = [-.35 2.5];
    cfg.colorbar  = 'no';

    for contrast = 1:length(contrasts_loadcomp)
        cfg.zlim            = zlims{contrast};
        cfg.parameter       = contrasts_loadcomp{contrast};
        cfg.maskparameter   = masks_loadcomp{contrast};
        cfg.maskstyle       = 'outline';
        
        subplot(1,3,contrast);
        ft_singleplotTFR(cfg,mean_load1v2v4_all);
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
saveas(gcf, [param.figpath 'TFR-C3-load-comparisons-' 'lapl-' laplacian_text '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'epsc');

%saveas(gcf, [param.figpath 'TFR-C3-load-comparisons-' 'lapl-' laplacian_text '.png'])

%% Topoplot contrasts 

title_timeselect = {'0.5-1s', '1-1.5s', '1.5-2s'};
zlims = {[-12 12], [-7 7], [-6 6]};

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

        ft_topoplotTFR(cfg,mean_load1v2v4_all);
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
% 
% figure;
% subplot(1,3,1);
% 
% [m_plot1] = frevede_errorbarplot(load1v2v4_all.time, load1v2v4_all.blc_load1_beta_C3, color_7, 'se');
% [m_plot3] = frevede_errorbarplot(load1v2v4_all.time, load1v2v4_all.blc_load4_beta_C3, color_9, 'se');
% 
% axis([-.35 2.5 -50 30]);
% plot([0,0], ylim, 'k'); 
% plot([2,2], ylim, 'k');
% 
% legend([m_plot1, m_plot3], titles_blc_loads{[1 3]}, 'AutoUpdate', 'off', 'Location', 'northeast','FontSize', 12); 
% xlabel('Time (s)','FontSize', 13);
% ylabel('Betaband (15-25 Hz) power','FontSize', 13);
% 
% subplot(1,3,2);
% 
% [m_plot1] = frevede_errorbarplot(load1v2v4_all.time, load1v2v4_all.blc_load1_beta_C3, color_7, 'se');
% [m_plot2] = frevede_errorbarplot(load1v2v4_all.time, load1v2v4_all.blc_load2_beta_C3, color_8, 'se');
% 
% axis([-.35 2.5 -50 30]);
% plot([0,0], ylim, 'k'); 
% plot([2,2], ylim, 'k');
% 
% legend([m_plot1, m_plot2], titles_blc_loads{1:2}, 'AutoUpdate', 'off', 'Location', 'northeast','FontSize', 12);
% xlabel('Time (s)','FontSize', 13);
% 
% subplot(1,3,3);
% 
% [m_plot2] = frevede_errorbarplot(load1v2v4_all.time, load1v2v4_all.blc_load2_beta_C3, color_8, 'se');
% [m_plot3] = frevede_errorbarplot(load1v2v4_all.time, load1v2v4_all.blc_load4_beta_C3, color_9, 'se');
% 
% axis([-.35 2.5 -50 30]);
% plot([0,0], ylim, 'k'); 
% plot([2,2], ylim, 'k');
% 
% legend([m_plot2, m_plot3], titles_blc_loads{2:3}, 'AutoUpdate', 'off', 'Location', 'northeast','FontSize', 12); 
% xlabel('Time (s)','FontSize', 13);
% 
% 
% sgtitle('Baseline corrected loads in C3','FontSize', 14);

%% Save

% saveas(gcf, [param.figpath 'beta-C3-subplot-load-baseline-corrected-' 'lapl-' laplacian_text '.png'])

%% Plot timecourses load comparisons betaband (side by side)

% To plot mask as vertal line

mask_load1_load4_beta_C3 = double(stat_load1_load4_beta_C3.mask); 
mask_load1_load4_beta_C3(mask_load1_load4_beta_C3==0) = nan; % nan data that is not part of mark

mask_load1_load2_beta_C3 = double(stat_load1_load2_beta_C3.mask); 
mask_load1_load2_beta_C3(mask_load1_load2_beta_C3==0) = nan; % nan data that is not part of mark

mask_load2_load4_beta_C3 = double(stat_load2_load4_beta_C3.mask); 
mask_load2_load4_beta_C3(mask_load2_load4_beta_C3==0) = nan; % nan data that is not part of mark

verticaloffset = -1;

figure;
subplot(1,3,1);

[m_plot1] = frevede_errorbarplot(load1v2v4_all.time, load1v2v4_all.load1_load4_beta_C3, color_10, 'se');

axis([-.25 2.5 -20 10]);
plot([0,0], ylim, 'k'); 
plot([2,2], ylim, 'k');
plot(xlim, [0,0], '--k');
plot(load1v2v4_all.time, mask_load1_load4_beta_C3*verticaloffset, 'k', 'LineWidth', 2);

legend(m_plot1, titles_loadcomp{1}, 'AutoUpdate', 'off', 'Location', 'north','FontSize', 12);
xlabel('Time (s)','FontSize', 13);
ylabel('Betaband suppression (15-25 Hz)','FontSize', 13);

subplot(1,3,2);

[m_plot2] = frevede_errorbarplot(load1v2v4_all.time, load1v2v4_all.load1_load2_beta_C3, color_10, 'se');

axis([-.25 2.5 -20 10]);
plot([0,0], ylim, 'k'); 
plot([2,2], ylim, 'k');
plot(xlim, [0,0], '--k');
plot(load1v2v4_all.time, mask_load1_load2_beta_C3*verticaloffset, 'k', 'LineWidth', 2);

legend(m_plot2, titles_loadcomp{2}, 'AutoUpdate', 'off', 'Location', 'north','FontSize', 12);
xlabel('Time (s)','FontSize', 13);

subplot(1,3,3);

[m_plot3] = frevede_errorbarplot(load1v2v4_all.time, load1v2v4_all.load2_load4_beta_C3, color_10, 'se');

axis([-.25 2.5 -20 10]);
plot([0,0], ylim, 'k'); 
plot([2,2], ylim, 'k');
plot(xlim, [0,0], '--k');
plot(load1v2v4_all.time, mask_load2_load4_beta_C3*verticaloffset, 'k', 'LineWidth', 2);

legend(m_plot3, titles_loadcomp{3}, 'AutoUpdate', 'off', 'Location', 'north','FontSize', 12);
xlabel('Time (s)','FontSize', 13);

sgtitle('Load comparison in C3','FontSize', 14);

set(gcf, "renderer", "Painters");
set(gcf, "Position", [100 100 1200 300]);

%% Save

saveas(gcf, [param.figpath 'beta-C3-subplot-load-comparisons-' 'lapl-' laplacian_text '_removedRT_' convertStringsToChars(beh_data_cleaning)], 'epsc');

% %% Plot timecourses load comparisons betaband
% 
% % beta_index = load1v2v4_all.freq >= param.betaband(1) & load1v2v4_all.freq <= param.betaband(2);
% % C3_index = ismember(load1v2v4_all.label, 'C3');
% % 
% % 
% % load1v2v4_all.load1_load2_beta_C3 = squeeze(mean(load1v2v4_all.load1_load2(:,C3_index,beta_index,:), 3));
% % load1v2v4_all.load2_load4_beta_C3 = squeeze(mean(load1v2v4_all.load2_load4(:,C3_index,beta_index,:), 3));
% % load1v2v4_all.load1_load4_beta_C3 = squeeze(mean(load1v2v4_all.load1_load4(:,C3_index,beta_index,:), 3));
% 
% figure;
% [m_plot1] = frevede_errorbarplot(load1v2v4_all.time, load1v2v4_all.load1_load2_beta_C3, color_1, 'se');
% axis([-.35 2.5 -20 10]);
% [m_plot2] = frevede_errorbarplot(load1v2v4_all.time, load1v2v4_all.load2_load4_beta_C3, color_2, 'se');
% axis([-.35 2.5 -20 10]);
% [m_plot3] = frevede_errorbarplot(load1v2v4_all.time, load1v2v4_all.load1_load4_beta_C3, color_3, 'se');
% axis([-.35 2.5 -20 10]);
% 
% title('Load comparison in C3','FontSize', 14);
% xlabel('Time (s)','FontSize', 13);
% ylabel('Betaband (15-30 Hz) power','FontSize', 13);
% legend([m_plot1, m_plot2, m_plot3] , titles_loadcomp, 'AutoUpdate', 'off', 'Location', 'best','FontSize', 12); 
% 
% 
% plot([0,0], ylim, 'k');
% plot([2,2], ylim, 'k');
% plot(xlim, [0,0], '--k');
% 
% 
% %% Save
% 
% saveas(gcf, [param.figpath 'beta-C3-load-comparisons-' 'lapl-' laplacian_text '.png'])
% 
% 
% %% Baseline-corrected loads - variables
% 
% %% Plot timecourses loads (baseline corrected) betaband
% % 
% % 
% % beta_index = load1v2v4_all.freq >= param.betaband(1) & load1v2v4_all.freq <= param.betaband(2);
% % C3_index = ismember(load1v2v4_all.label, 'C3');
% % 
% % 
% % load1v2v4_all.blc_load1_beta_C3 = squeeze(mean(load1v2v4_all.blc_load1(:,C3_index,beta_index,:), 3));
% % load1v2v4_all.blc_load2_beta_C3 = squeeze(mean(load1v2v4_all.blc_load2(:,C3_index,beta_index,:), 3));
% % load1v2v4_all.blc_load4_beta_C3 = squeeze(mean(load1v2v4_all.blc_load4(:,C3_index,beta_index,:), 3));
% 
% 
% figure;
% [m_plot1] = frevede_errorbarplot(load1v2v4_all.time, load1v2v4_all.blc_load1_beta_C3, color_7, 'se');
% axis([-.35 2.5 -50 30]);
% [m_plot2] = frevede_errorbarplot(load1v2v4_all.time, load1v2v4_all.blc_load2_beta_C3, color_8, 'se');
% axis([-.35 2.5 -50 30]);
% [m_plot3] = frevede_errorbarplot(load1v2v4_all.time, load1v2v4_all.blc_load4_beta_C3, color_9, 'se');
% axis([-.35 2.5 -50 30]);
% 
% title('Baseline corrected loads in C3','FontSize', 14);
% xlabel('Time (s)','FontSize', 13);
% ylabel('Betaband (15-30 Hz) power','FontSize', 13);
% legend([m_plot1, m_plot2, m_plot3] , titles_blc_loads, 'AutoUpdate', 'off', 'Location', 'best','FontSize', 12); 
% 
% 
% plot([0,0], ylim, 'k'); 
% plot([2,2], ylim, 'k');
% 
% 
% %% Save
% 
% saveas(gcf, [param.figpath 'beta-C3-load-baseline-corrected-' 'lapl-' laplacian_text '.png'])
% 
% 
% %% Plot contrasts load comparisons
% 
% cfg = [];
% 
% cfg.layout      = 'easycapM1.mat';
% cfg.zlim        = [-15 15];
% cfg.comment   = 'no';
% cfg.showscale   = 'no';
% cfg.showlabels  = 'yes';
% 
% for contrast = 1:length(contrasts_loadcomp)
%        
%     cfg.parameter = contrasts_loadcomp{contrast};
%         
%     ft_multiplotTFR_2(cfg,mean_load1v2v4_all); 
%     colormap(flipud(brewermap(100,'RdBu')));
% 
%     title(titles_loadcomp{contrast}, 'FontSize', 14);
%     
% end
% 
% 
% %% Topoplot contrasts 
% 
% select_time = {[0.5 1],[1.5 2],[2 2.5]};
% titles_timeselect = {'0.5 - 1s', '1.5 - 2s', '2 - 2.5s'};
% zlims = {[-12 12], [-8 8], [-5 5]};
% 
% for contrast = 1:length(contrasts_loadcomp)    
%     cfg = [];
% 
%     cfg.layout    = 'easycapM1.mat';
%     cfg.zlim      = zlims{contrast};
%     cfg.ylim      = param.betaband;
%     cfg.comment   = 'no';
%     cfg.parameter = contrasts_loadcomp{contrast};
%     cfg.style = 'straight';
% 
% 
%     figure;
%  
%     for time = 1:length(select_time)
%         cfg.xlim  = select_time{time};
%         
%         subplot(1,3,time);
%         ft_topoplotTFR(cfg,mean_load1v2v4_all);
%         colormap(flipud(brewermap(100,'RdBu')));
% 
%         title(titles_timeselect{time}, 'FontSize', 14,  'FontWeight', 'normal', 'Position', [0, -1, 0]);
% 
%     end
% 
%     sgtitle(titles_loadcomp{contrast}, 'FontSize', 16, 'FontWeight', 'bold') 
%     
%     % Save
%     saveas(gcf, [param.figpath 'topo-' titles_loadcomp{contrast} '-comparisons-' 'lapl-' laplacian_text '.png'])
%     
% end
% 
% %% Masked by significance
% 
% % Load 2 versus 1
% [h,~,~,t]                               = ttest(load1v2v4_all.load1_load2);
% mean_load1v2v4_all.load1_load2_T        = squeeze(t.tstat); % the t-stat against 0.
% mean_load1v2v4_all.load1_load2_Masked   = mean_load1v2v4_all.load1_load2 .* squeeze(h); % values with significant t-test preserved, rest 0.
% 
% % Load 4 versus 2
% [h,~,~,t]                               = ttest(load1v2v4_all.load2_load4);
% mean_load1v2v4_all.load2_load4_T        = squeeze(t.tstat); 
% mean_load1v2v4_all.load2_load4_Masked   = mean_load1v2v4_all.load2_load4 .* squeeze(h);
% 
% % Load 4 versus 1
% [h,~,~,t]                               = ttest(load1v2v4_all.load1_load4);
% mean_load1v2v4_all.load1_load4_T        = squeeze(t.tstat);
% mean_load1v2v4_all.load1_load4_Masked   = mean_load1v2v4_all.load1_load4 .* squeeze(h);
% 
% %[h,p,ci,t] is I also want to use p and ci
% 
% 
% 
% %% Plot contrasts - selected channels (C3, POz, Fz), masked
% 
% 
% 
% %select_channels = {'C3','POz','Fz'};
% select_channels = {'C3'}; 
% 
% zlims = {[-20 20], [-15 15], [-10 10]};
% 
% for channel = 1:length(select_channels)
%     
%     cfg = [];
% 
%     cfg.channel   = select_channels{channel};
%     cfg.layout    = 'easycapM1.mat';
%     cfg.figure    = "gcf";
%     cfg.xlim      = [-.35 2.5];
%     cfg.colorbar  = 'no';
% 
%     for contrast = 1:length(contrasts_loadcomp)
%         cfg.zlim      = zlims{contrast};
%         cfg.parameter = strcat(contrasts_loadcomp{contrast}, '_Masked');
%         
%         subplot(1,3,contrast);
%         ft_singleplotTFR(cfg,mean_load1v2v4_all);
%         colormap(flipud(brewermap(100,'RdBu')));
% 
%         title(titles_loadcomp{contrast}, 'FontSize', 14);
%         xlabel('Time (s)', 'FontSize', 13);
%         ylabel('Frequency (Hz)', 'FontSize', 13);
% 
%         hold on;
% 
%         plot([0,0], ylim, 'k');
%         plot([2,2], ylim, 'k');
% 
%     end
% 
% end
% 
% 
% %% Save 
% 
% saveas(gcf, [param.figpath 'TFR-C3-load-comparisons-masked-' 'lapl-' laplacian_text '.png'])
% 
% 
% 
% 
% %% Plot masked
% 
% cfg = [];
% 
% cfg.layout      = 'easycapM1.mat';
% cfg.zlim        = [-15 15];
% cfg.comment   = 'no';
% cfg.showscale   = 'no';
% cfg.showlabels  = 'yes';
% 
% for contrast = 1:length(contrasts_loadcomp)
%        
%     cfg.parameter = strcat(contrasts_loadcomp{contrast}, '_Masked');
% 
%     ft_multiplotTFR_2(cfg, mean_load1v2v4_all);
%     colormap(flipud(brewermap(100,'RdBu')));
% 
%     title(strcat(titles_loadcomp{contrast}, ' - masked by significance'), 'FontSize', 14);
%     
% end
% 

%% Code to save

% Using contourf
% data2plot = mean_load1v2v4_all.load2_load1; % select data
% contourf(mean_load1v2v4_all.time, mean_load1v2v4_all.freq, data2plot, 500, 'linecolor', 'none'); % this instead of ft_singleplotTFR

% If I want to use more than one channel
% chan_index = ismember(load1v2v4_all.label, {'C3', 'C4'});
% squeeze(mean(load1v2v4_all.blc_load1(:,chan_index,beta_index,:), [2 3]))



