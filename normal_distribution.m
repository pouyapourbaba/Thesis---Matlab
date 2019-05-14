%%%
% normally distributed RV with m-mean and d-deviation
%%%
function [normal] = normal_distribution(m, d)
%     m = 0;
%     d = 1.7;
    rng('shuffle');
    for i=1:500
        nor(i) = d.*randn + m;
    end
    normal = sum(nor)/500;
end