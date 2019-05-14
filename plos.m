%%%%%%%%%%%%%%%
% Generating the probability of LOS for the 
% link between the "r" and the ground users.
%%%%%%%%%%%%%%%

function plos = plos(theta, l, alpha, beta)

    plos=zeros(l,1);

    for i=1:l
        plos(i) = 1/(1 + alpha * exp(-beta*(theta(i)-alpha)));
    end
    
    plos = plos;
end
