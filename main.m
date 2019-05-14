% clc;
clear all;

solved_counter = 0;
wrong_counter = 0;

% Greedy 
epsilon = 0.1;
greedy_estimated_values = zeros(1, init.l);
greedy_selected_arms_numbers = zeros(1, init.l);

% Biases for generating random numbers
biases = 1 ./ (5:init.l+4);

% Mean values for generating random numbers
% means = randi([20 80],1,init.l);
means = randperm(80,init.l);
std = 10*rand(1,init.l);

% random distances between 10-500 for generating the rates 
d = randi([10, 1000],1,64);

total_random_numbers = 0;

coef = 2:1:50;

counter_h = 1;
for h=1:100
    h=50;
    
    % Epsilon Greedy Initialization
    eps_value = zeros(1, init.l);
    eps_numbers_of_actions_selected = zeros(1, init.l);
    eps = 1.0;
    
    % Random Bandit initialization
    random_numbers_of_selected = zeros(1, init.l);
    random_total_reward = 0;
    
    simulation_iterator_limit = 25000;
    
    % UCB V3 Inits
    numbers_of_selections = zeros(1, init.l); % create a vector of size l with zeros
    sums_of_rewards = zeros(1, init.l); % vector for rewards for each ad
    total_reward = 0;
    ar_matrix = zeros(simulation_iterator_limit, init.l);
    delta_matrix = zeros(simulation_iterator_limit, init.l);
    ad_chosen = zeros(1, simulation_iterator_limit);
    ucb_total_reward = 0;
    
    for j=1:simulation_iterator_limit
        
    
    range = 1; % This effects the rng in the "random_vehicle_locations", generating the random locations

    % Generate Uav location and random vehicle locations
    L = uav_location(h);   % CHECKED
    x_s = -198;
    y_s = -200;
    x_d = 1500;
    y_d = 1500;
%     [x_s, y_s, x_v1, y_v1, x_v2, y_v2] = random_vehicle_locations(range);  % CHECKED
    
    % Caculate the rates with manual distances
    [d_sr, stheta_sr, plos_sr, pnlos_sr, pathloss_sr, gain_sr, s_sr] = received_power_vector(x_s, y_s, 0,init.p_s, L, h, d);
    [d_rd, theta_rd, plos_rd, pnlos_rd, pathloss_rd, gain_rd, s_rd] = received_power_vector(x_d, y_d, 0,init.p_s, L, h, d);

    % Calculate the rates with real distances
%     [d_sr, theta_sr, plos_sr, pnlos_sr, pathloss_sr, gain_sr, s_sr] = received_power_vector(x_s, y_s, 0,init.p_s, L, h);
%     [d_rd, theta_rd, plos_rd, pnlos_rd, pathloss_rd, gain_rd, s_rd] = received_power_vector(x_d, y_d, 0,init.p_s, L, h);

    [sinr_sr, sinr_rd] = sinr(s_sr, s_rd);
    rate = log2(sinr_sr + 1) + log2(sinr_rd + 1);  %rate(ALLSINRs);
    rate = transpose(rate);
    if (j==1) 
        cum_rate = rate;
    else 
        cum_rate = cum_rate + rate;
    end
    rate = rate./max(rate); 
    rate_matrix(j,:) = rate;
       
    % Random Rates
    for k = 1:init.l
%        rate(k) = normrnd(means(k), 5);
%         rate(k) = std(k)*randn; %+ means(k);
    end
%     rate = abs(std.*randn + means);
%     rate = randn(1,64) + means; % not a specific distribution
%     rate = randn(1, init.l); % normal distribution
%     rate = (rand(1,init.l) + biases);  % not a specific distribution
%     rate = rate./max(rate);
%     if j == 1
%         total_random_numbers = rate;
% %     else
%         total_random_numbers = horzcat(total_random_numbers, rate);
%     end
%   

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%% Greedy %%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [greedy_arm_selected, greedy_reward] = epsilonGreedyAlgorithm(rate, init.l, epsilon, greedy_estimated_values);
    greedy_rewards(j) = greedy_reward;
    greedy_selected_arms_numbers(greedy_arm_selected) = greedy_selected_arms_numbers(greedy_arm_selected) + 1;
    greedy_estimated_values(greedy_arm_selected) = greedy_estimated_values(greedy_arm_selected) + ((1/greedy_selected_arms_numbers(greedy_arm_selected)) * (greedy_reward - greedy_estimated_values(greedy_arm_selected)));
    if j == 1
        greedy_regret(j) = 0;
    else
        greedy_regret(j) = greedy_regret(j-1) + max(rate) - rate(greedy_arm_selected);
    end  
    
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
        ucb_average_rate(j,:) = rate;
    else 
        t = init.l;
        [~, ucb_location] = max(ucb);
        ucb_numbers_of_selected(ucb_location) = ucb_numbers_of_selected(ucb_location) + 1;
        ucb_current_reward(j) = rate(ucb_location);
        ucb_sums_of_rates(ucb_location) = ucb_sums_of_rates(ucb_location) + rate(ucb_location);
        % divide the whole ucb_sums_of_rates 
        ucb_average_rate(j,:) = (ucb_sums_of_rates) ./ ucb_numbers_of_selected;
        % divide only the chosen location
%         ucb_average_rate(ucb_location) = (ucb_sums_of_rates(ucb_location)) / ucb_numbers_of_selected(ucb_location);
        ucb = ucb_average_rate(j,:) + sqrt( (coef(counter_h)*log(j)) ./ (ucb_numbers_of_selected) );
        ucb_regret(j) = ucb_regret(j-1) + max(rate) - rate(ucb_location);
        ucb_total_reward = ucb_total_reward + rate(ucb_location);
        t = t + 1;
    end

    if rem(j, 500) == 0  
        j
    end
    end
    
    ucb_upper_bound = sqrt( (coef(counter_h)*log(j)) ./ (ucb_numbers_of_selected) );
    averages(rate_matrix, ucb_upper_bound);
    % Calculate the regret of the naive (random) algorithm
    random_regret = random_best_rate - random_rate;
%     ucb_regret = ucb_best_cumulative_reward - ucb_cumulative_reward;  
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Plot the regret for the UCB and the naive algorithm %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     figure(2);
%     plot(ucb_regret, "LineWidth", 2);
%     grid on;
%     hold on;
%     plot(random_regret, "LineWidth", 2);
%     legend('Naive', 'UCB');
%     title("Regret");
%     xlabel("Time Step");
%     ylabel("Regret");
    
    xVec = 1:1:simulation_iterator_limit;
    figure;
    a1 = axes();
    p1 = plot(a1,random_regret, "-o",'MarkerFaceColor','red', 'MarkerIndices', 1:1000:simulation_iterator_limit); % 
    p1.LineWidth = 2;
    grid on;
    hold on;
    p2 = plot(a1,ucb_regret, "-d",'MarkerFaceColor','blue', 'MarkerIndices', 1:1000:simulation_iterator_limit);
    p2.LineWidth = 2;
    p3 = plot(a1,greedy_regret, "-s",'MarkerFaceColor','blue', 'MarkerIndices', 1:1000:simulation_iterator_limit);
    p3.LineWidth = 2;
    a2 = axes();
    a2.Position = [0.2200 0.6600 0.2 0.2]; % xlocation, ylocation, xsize, ysize
    p4 = plot(a2,random_regret(1:3000), "-o",'MarkerFaceColor','red', 'MarkerIndices', 1:1000:simulation_iterator_limit); axis tight
    p4.LineWidth = 2;
    hold on;
    grid on;
    p5 = plot(a2,ucb_regret(1:3000), "-d",'MarkerFaceColor','blue', 'MarkerIndices', 1:1000:simulation_iterator_limit); axis tight
    p5.LineWidth = 2;
    p6 = plot(a2,greedy_regret(1:3000),"-s",'MarkerFaceColor','blue', 'MarkerIndices', 1:1000:simulation_iterator_limit); axis tight
    p6.LineWidth = 2;
    annotation('ellipse',[.1 .1 .1 .1])
    annotation('arrow',[.16 .28],[.18 .6])
    legend(a1,'Naive', 'UCB', 'Epsilon Greedy');
    xlabel(a1,"Time Step");
    ylabel(a1,"Regret");

     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Plot the rewards for UCB and naive at each time step %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     figure(3);
%     scatter(1:simulation_iterator_limit ,random_current_reward, 2);
%     xlabel("Time Step");
%     ylabel("Reward");
%     
%     figure(4);
%     scatter(1:simulation_iterator_limit ,ucb_current_reward, 2);
%     xlabel("Time Step");
%     ylabel("Reward");
    



    
    
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
%     plot(ucb_regret, 'LineWidth', 2)
%     hold on
%     grid on
%     plot(random_regret, 'LineWidth', 2)
%     plot(greedy_regret, 'LineWidth', 2)
% %     plot(ucb_regret_samad, 'LineWidth', 2, 'Color', 'blue')
%     legend( 'UCB','Random','Greedy')
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
%      figure(200)
%      hist(rate_matrix(:,64), 100);
%      fitdist(rate_matrix(:,63), 'Normal')
%      figure(201)
%      hist(rate_matrix(:,63), 100);
%     histfit(total_random_numbers,200,'rician');
    random_total_rewards(counter_h) = random_total_reward;
    ucb_total_rewards(counter_h) = ucb_total_reward;
	histogram(ucb_numbers_of_selected, rate_matrix);
% 	averages(rate_matrix, ucb_upper_bound);
	averages(ucb_average_rate, ucb_upper_bound);
    
    % plot the cumulative rewards
    figure;
    b = bar(cum_rate);
    xlabel('Locations');
    ylabel('Cumulative Reward (Rate)');
    [max_value, max_index_cum_rate] = max(cum_rate);
    b.FaceColor = 'flat';
    b.CData(max_index_cum_rate,:) = [.9 0.5 .13];


% figure(12)
% subplot(1,2,1)
% bar(ucb_numbers_of_selected)
% subplot(1,2,2)
% bar(random_numbers_of_selected)

% Plots of ESIOLON GREEDY
% figure(13)
% plot(eps_rewards)


counter_h = counter_h + 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the plot for the exploration-exploitation coefficient in UCB algorithm %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(11)
plot(2:50, random_total_rewards, 'LineWidth', 3); %, 'color', 'r'
hold on;
grid on;
plot(2:50, ucb_total_rewards, 'LineWidth', 3); % , 'color', 'b'
legend('random', 'UCB1');
xlabel('Exploration/Exploitatin coefficient');
ylabel('total reward');