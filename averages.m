function averages(input, bounds)
    figure
    hold on
    grid on
    for i=1:init.l
       dist = fitdist(input(:,i), 'Normal') ;
       avgs(i) = dist.mu;
       % std from the distribution
%        stds(i) = dist.sigma;
%        plt(i) = plot([i,i], [dist.mu-dist.sigma, dist.mu+dist.sigma], 'b', 'LineWidth', 1)
%       std ffrom the ucb
       plt(i) = plot([i,i], [dist.mu-bounds(i), dist.mu+bounds(i)], 'b');
       xlim([1 64])
    end
    stds = bounds;
    [a,b] = min(stds);
    [max_mean, max_mean_index] = max(avgs);
    
    stds_up = avgs + stds;
    stds_down = avgs - stds;
    
    sct_mean = scatter(1:init.l, avgs, 13, 'filled', 'MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor',[0 .7 .7],...
              'LineWidth',1.5);
	sct_mean_max = scatter(max_mean_index, max_mean, 20, 'filled', 'MarkerEdgeColor',[.9 .5 .13],...
        'MarkerFaceColor',[.9 .5 .13],...
        'LineWidth',1.5);
    scatter(1:init.l, stds_up, '.', 'r')
    scatter(1:init.l, stds_down, '.', 'r')
    legend([plt(1),sct_mean,sct_mean_max],'confidence bound', 'expected reward', 'highest expected reward')
    xlabel('Locations')
    ylabel('Expected reward (rate)')
end

