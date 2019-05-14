% clc;
clear all;

solved_counter = 0;
wrong_counter = 0;

% random distances between 10-500 for generating the rates 
d = randi([10, 500],1,64);

coef = 1:2:50;

counter_h = 1;
for h=1:49
    h=50;
    
    % Random Bandit initialization
    random_numbers_of_selected = zeros(1, init.l);
    random_total_reward = 0;
    
    % UCB V3 Inits
    numbers_of_selections = zeros(1, init.l); % create a vector of size l with zeros
    sums_of_rewards = zeros(1, init.l); % vector for rewards for each ad
    total_reward = 0;
    ar_matrix = zeros(simulation_iterator_limit, init.l);
    delta_matrix = zeros(simulation_iterator_limit, init.l);
    ad_chosen = zeros(1, simulation_iterator_limit);
    ucb_total_reward = 0;
    
    simulation_iterator_limit = 5000;
    for j=1:simulation_iterator_limit
        
    
    range = 1; % This effects the rng in the "random_vehicle_locations", generating the random locations

    % Generate Uav location and random vehicle locations
    L = uav_location(h);   % CHECKED
    x_s = -198;
    y_s = 0;
%     [x_s, y_s, x_v1, y_v1, x_v2, y_v2] = random_vehicle_locations(range);  % CHECKED
    
    % Caculate the rates with manual distances
%     [d_sr, theta_sr, plos_sr, pnlos_sr, pathloss_sr, gain_sr, s_sr] = received_power_vector(x_s, y_s, 0,init.p_s, L, h, d);
    
    % Calculate the rates with real distances
    [d_sr, theta_sr, plos_sr, pnlos_sr, pathloss_sr, gain_sr, s_sr] = received_power_vector(x_s, y_s, 0,init.p_s, L, h);

    ALLSINRs = sinr(s_sr);
    rate = log2(ALLSINRs + 1);
    rate = transpose(rate);
    rate = rate./max(rate);
    
    % Random Bandit v1
    random_location = randi([1 init.l],1,1);
    random_numbers_of_selected(random_location) = random_numbers_of_selected(random_location) + 1;
    random_total_reward = random_total_reward + rate(random_location);
    random_reward_at_each_iteration(j) = rate(random_location);
    if j==1
        random_best_rate(j) = max(rate);
        random_rate(j) = rate(random_location);
        random_current_reward(j) = random_rate(j);
    else
        random_best_rate(j) = random_best_rate(j-1) + max(rate);
        random_rate(j) = random_rate(j-1) + rate(random_location);
        random_current_reward(j) = rate(random_location);
    end
    
    % UCB V3
%     ad = 0;
%     max_upper_bound = 0;
%     for i = 1:init.l
%         if (numbers_of_selections(i) > 0)
%             average_reward = sums_of_rewards(i) / numbers_of_selections(i);
%             delta_i = sqrt(((coef(counter_h))*log(j)) / (numbers_of_selections(i)));
%             upper_bound = average_reward + delta_i;
%             ar_matrix(j,i) = average_reward;
%             delta_matrix(j,i) = delta_i;
%         else
%             upper_bound = 1e400;
%         end
%         
%         if upper_bound > max_upper_bound
%             max_upper_bound = upper_bound;
%             ad = i;
%             ad_chosen(j) = ad;
%         end
%     end
%     
%     ads_selected(j) = ad;
%     numbers_of_selections(ad) = numbers_of_selections(ad) + 1;
%     reward = rate(ad);
%     sums_of_rewards(ad) = sums_of_rewards(ad) + reward;
%     ucb_total_reward = ucb_total_reward + reward;
%     if j < init.l
%         ucb_regret(j) =  0;
%         ucb_current_reward(j) = 0;
%     else
%         ucb_regret(j) = ucb_regret(j-1) + max(rate) - reward;
%         ucb_current_reward(j) = reward;
%     end
    
              
    
    % UCB V2 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Update the the "sum_of_rewards" vector with the reward from the "rate" 
    %%% vector at the "ucb_location" index
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if j == 1
        ucb_numbers_of_selected = ones(1, init.l);
        ucb = rate; 
        ucb_sums_of_rates = rate;
        ucb_regret(j) = 0;
        ucb_current_reward(j) = 0;
        ucb_sums_of_rates(j,:) = rate;
        ucb_average_rate = rate;
    else 
        t = init.l;
        [~, ucb_location] = max(ucb);
        ucb_numbers_of_selected(ucb_location) = ucb_numbers_of_selected(ucb_location) + 1;
        ucb_current_reward(j) = rate(ucb_location);
        ucb_sums_of_rates(ucb_location) = ucb_sums_of_rates(ucb_location) + rate(ucb_location);
        % divide the whole ucb_sums_of_rates 
        ucb_average_rate = (ucb_sums_of_rates) ./ ucb_numbers_of_selected;
        % divide only the chosen location
%         ucb_average_rate(ucb_location) = (ucb_sums_of_rates(ucb_location)) / ucb_numbers_of_selected(ucb_location);
        ucb = ucb_average_rate + sqrt( (coef(counter_h)*log(j)) ./ (ucb_numbers_of_selected) );
        ucb_regret(j) = ucb_regret(j-1) + max(rate) - rate(ucb_location);
        ucb_total_reward = ucb_total_reward + rate(ucb_location);
        t = t + 1;
    end
    
%     

    %UCB V1
%     if j == 1
%         ucb_sums_of_reward = rate;
%         ucb_numbers_of_selections = ones(1, init.l);
%         ucb_total_reward = sum(rate);
%         [~, index] = max(rate);
%         ucb_regret_samad(j) = 0;
%         ucb_current_reward(j) = rate(index);
%         ucb_cumulative_reward(j) = rate(index);
%         ucb_best_action_cumulative_reward(j) = rate(index); 
%         ucb_average_reward = rate;
%     else
%         
%         ucb_delta_i = sqrt( (2*log(j+init.l)) ./ (ucb_numbers_of_selections) );
%         ucb_upper_bound = ucb_average_reward + ucb_delta_i;
%         [~, index] = max(ucb_upper_bound);
%         ucb_numbers_of_selections(index) = ucb_numbers_of_selections(index) + 1;
%         ucb_current_reward(j) = rate(index);
%         ucb_cumulative_reward(j) = ucb_cumulative_reward(j-1) + rate(index);
%         ucb_best_action_cumulative_reward(j) = ucb_best_action_cumulative_reward(j-1) + max(rate);
%         ucb_sums_of_reward(index) = ucb_sums_of_reward(index) + ucb_current_reward(j);
%         ucb_regret_samad(j) = ucb_regret_samad(j-1) + max(rate) - ucb_current_reward(j);
%         ucb_total_reward = ucb_total_reward + rate(index);
%         ucb_average_reward(index) = ucb_sums_of_reward(index) ./ ucb_numbers_of_selections(index);
%     end
    
    if rem(j, 1000) == 0  
        j
    end
    end
    
    % Calculate the regret of the naive (random) algorithm
    random_regret = random_best_rate - random_rate;
%     ucb_regret = ucb_best_cumulative_reward - ucb_cumulative_reward;


%     figure(1);
%     bar(numbers_of_selections);
%     title("Numbers of selection fo each location, Naive");
%     xlabel("UAV locations");
%     ylabel("Number of selection");

    figure(2);
    plot(ucb_regret, "LineWidth", 2);
    grid on;
    hold on;
    plot(random_regret, "LineWidth", 2);
    legend('Naive', 'UCB');
    title("Regret");
    xlabel("Time Step");
    ylabel("Regret");
    
    figure(3);
    scatter(1:simulation_iterator_limit ,random_current_reward, 2);
    title('random');
    
    figure(4);
    scatter(1:simulation_iterator_limit ,ucb_current_reward, 2);
    title('ucb');
    



%     figure(3);
%     bar(ucb_numbers_of_selected);
%     title("Numbers of selection fo each location, UCB");
%     xlabel("UAV locations");
%     ylabel("Number of selection");
%     
%     figure(4);
%     plot(ucb_regret, "LineWidth", 2);
%     grid on;
%     title("Regret, UCB");
%     xlabel("Time Step");
%     ylabel("Regret");
    
    
%     ucb_regret = ucb_best_action_cumulative_reward - ucb_cumulative_reward;
    
%     figure(1)
%     plot(ucb_regret, 'LineWidth', 2, 'Color', 'red')
%     hold on
%     grid on
%     plot(random_regret)
% %     plot(ucb_regret_samad, 'LineWidth', 2, 'Color', 'blue')
%     legend('Random', 'UCB', 'UCB Samad')
%     
%     figure(2)
%     scatter(1:simulation_iterator_limit,ucb_current_reward)
%     grid on
%     title('Reward at each time step.')
%     
%     figure(3)
%     scatter(1:simulation_iterator_limit,random_rewards)
%     grid on
%     title('Reward at each time step.')

%     hist(total_random_numbers, 1000);
%     hist(rate_matrix(:,50), 1000);
%     histfit(total_random_numbers,200,'rician');
random_total_rewards(counter_h) = random_total_reward;
ucb_total_rewards(counter_h) = ucb_total_reward;

figure(11)
plot(random_total_rewards, '-*');
hold on;
grid on;
plot(ucb_total_rewards, '-o');

figure(12)
subplot(1,2,1)
bar(ucb_numbers_of_selected)
subplot(1,2,2)
bar(random_numbers_of_selected)


counter_h = counter_h + 1;
end