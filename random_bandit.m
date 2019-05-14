function [selected_item, reward] = random_bandit(data, length)
    
    selected_item = randi([1 length],1,1);
    reward = data(selected_item);
 
end