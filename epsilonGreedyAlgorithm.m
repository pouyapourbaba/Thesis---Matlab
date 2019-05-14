function [arm_selected, reward] = epsilonGreedyAlgorithm(input, arms, epsilon, estimated_values) 
    greedyness = rand;
    if greedyness < epsilon
        arm_selected = randi([1 arms]);
        % random reward
%         reward = input(arm_selected) + rand;
        % reward for the real simulation
        reward = input(arm_selected);
    else
        [~, arm] = max(estimated_values);
        arm_selected = arm;
        reward = input(arm_selected) + rand;
    end
    