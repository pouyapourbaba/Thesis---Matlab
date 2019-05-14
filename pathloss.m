%%%%%%%%%%%%%%%%%%%
% The average pathloss for the links between the r
% and the ground users.
%%%%%%%%%%%%%%%%%%% 

function pathloss = pathloss(d, plos, pnlos, l, c, f, eta_los, eta_nlos)

    pathloss=zeros(l,1);

    for i=1:l
        pathloss(i) = (eta_los*plos(i)*((4*pi*f*d(i)/c))^2) + (eta_nlos*pnlos(i)*((4*pi*f*d(i)/c))^2);
    end
    
    pathloss = pathloss;
    
end