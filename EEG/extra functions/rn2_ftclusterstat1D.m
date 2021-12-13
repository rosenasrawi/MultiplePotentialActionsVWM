function stat = rn2_ftclusterstat1D(statcfg, data_cond1, data_cond2)

    % needs:
    % statcfg.xax = xxx.time;
    % statcfg.npermutations = 1000;
    % statcfg.clusterStatEvalaluationAlpha = 0.05;
    % statcfg.nsub = s;
    % statcfg.statMethod = 'montecarlo';  / statcfg.statMethod = 'analytic';
    % data_cond1 % paticipants x time
    % data_cond2 % paticipants x time - if one condition against 0, enter as: data_cond2 = zeros(size(data_cond1));
    % % assumes depsamples
    % put into fieldtrip format
    
    dummy = []; x = []; y = [];
    dummy.time = statcfg.xax;
    dummy.label = {'contrastofinterest'};
    dummy.dimord = 'chan_time';
    
    for s = 1:statcfg.nsub
        x{s} = dummy; x{s}.avg(1,:) = squeeze(data_cond1(s,:)); % 1  structure per participant.
        y{s} = dummy; y{s}.avg(1,:) = squeeze(data_cond2(s,:));
    end
    
    % run cluster stat
    cfg = [];
    cfg.method = statcfg.statMethod;
    cfg.numrandomization = statcfg.npermutations;
    
    if strcmp(cfg.method, 'montecarlo'); cfg.correctm = 'cluster'; else cfg.correctm = 'no'; end
        cfg.clusteralpha     = 0.05;
        cfg.alpha            = statcfg.clusterStatEvalaluationAlpha;
        cfg.tail             = 0;
        cfg.design           = [[ones(1,s), ones(1,s)*2];[1:s, 1:s]]; % specifies which dataset belongs to which participant and which condition (effect or zeros)
        cfg.ivar             = 1;
        cfg.uvar             = 2;
        cfg.statistic        = 'depsamplesT';
        cfg.neighbours       = [];
        stat = ft_timelockstatistics(cfg, x{:},y{:});
    end

% plot mask as horizontal line using e.g.
% mask_xxx = double(stat.mask); mask_xxx(mask_xxx==0) = nan; % nan data that is not part of mark
% plot(timevector, mask_xxx*verticaloffset, 'k', 'LineWidth', 2); % verticaloffset for positioning of the "significance line"


