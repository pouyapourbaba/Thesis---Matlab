clear all
clc

epsilons = [0, 0.01, 0.1, 1];
for eps_iter=1:length(epsilons)
    
    arms = 10;
    expected_values = normrnd(0, 1, [1,arms]);
    [max_of_expected_value, index_of_expected_max] = max(expected_values);
    estimated_values = zeros(1, arms);
    num_of_pulls = 3000;
    cumulative_rewards = zeros(1, num_of_pulls);
    avg_outcome = zeros(1, num_of_pulls);
    avg_perc_action = zeros(1, num_of_pulls);

    play_round = 2000;
    
    for i=1:1:play_round

        estimated_values = zeros(1, arms);
        for j=1:arms
                input(j) = normrnd(expected_values(j), 1); 
        end
        selected_arms_numbers = zeros(1, arms);

        for k=1:num_of_pulls
            [arm_selected, reward] = epsilonGreedyAlgorithm(input, arms, epsilons(eps_iter), estimated_values);
            rewards(k) = reward;
            selected_arms_numbers(arm_selected) = selected_arms_numbers(arm_selected) + 1;
            estimated_values(arm_selected) = estimated_values(arm_selected) + ((1/selected_arms_numbers(arm_selected)) * (reward - estimated_values(arm_selected)));
            if arm_selected == index_of_expected_max
                perc_action(k) = 1;
            else
                perc_action(k) = 0;
            end
        end

        avg_outcome = avg_outcome + rewards;
        avg_perc_action = avg_perc_action + perc_action;
        if rem(i, 100)==0
            i
        end
    end
    % Add some zeros to the beginning of the average outcome vectors
    % to have some padding at the beginning so the plot looks better
    padding = zeros(1,20);
    avg_outcomes(eps_iter,:) = [padding, avg_outcome]; 
    avg_perc_actions(eps_iter,:) = [padding, avg_perc_action];
end



avg_action_eps0_0 = avg_perc_actions(1,:) / play_round;
avg_action_eps0_01 = avg_perc_actions(2,:) / play_round;
avg_action_eps0_1 = avg_perc_actions(3,:) / play_round;
avg_action_eps1_0 = avg_perc_actions(4,:) / play_round;

figure(1)
plot(avg_action_eps0_0, 'LineWidth', 2);
hold on;
grid on;
plot(avg_action_eps0_01, 'LineWidth', 2);
plot(avg_action_eps0_1, 'LineWidth', 2);
plot(avg_action_eps1_0, 'LineWidth', 2);
legend('epsilon = 0.0', 'epsilon = 0.01', 'epsilon = 0.1', 'epsilon = 1.0');

% actions
avg_outcome_eps0_0 = avg_outcomes(1,:) / play_round;
avg_outcome_eps0_01 = avg_outcomes(2,:) / play_round;
avg_outcome_eps0_1 = avg_outcomes(3,:) / play_round;
avg_outcome_eps1_0 = avg_outcomes(4,:) / play_round;

figure(2)
plot(avg_outcome_eps0_0, 'LineWidth', 1);
hold on;
grid on;
plot(avg_outcome_eps0_01, 'LineWidth', 1);
plot(avg_outcome_eps0_1, 'LineWidth', 1);
plot(avg_outcome_eps1_0, 'LineWidth', 1);
legend('epsilon = 0.0', 'epsilon = 0.01', 'epsilon = 0.1', 'epsilon = 1.0');