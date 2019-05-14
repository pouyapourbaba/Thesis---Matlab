function [sum_rate] = rate(sinr)
    sum_rate = zeros(init.l,1);
    for i=1:init.l
        sum_rate(i) = log(sinr(i,1) +1);
    end
    
end