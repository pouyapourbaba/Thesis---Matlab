% A function to calculate the gain of the uav to the users on the ground
% and return the vector of the possible received powers by calculating the
% distances, angles and etc for the links between the relay and the ground
% nodes.

% [l, h, p_s, p_r, p_v1, p_v2, a, b, delta, f, c, alpha, beta, eta_los, eta_nlos, N_0, I_r, I_v1, I_v2, gamma1, gamma2, gamma3, PL_0, d_b, n1, d_0, n2] = init();

function [d, THETA, PLOS, PNLOS, PATHLOSS, GAIN, power] = received_power_vector(x, y , z, p, L, h, d)

%     d = distance_relay(x, y, z, init.l, L);
    THETA = theta(d, h, init.l);
    PLOS = plos(THETA, init.l, init.alpha, init.beta);
    PNLOS = ones(init.l,1)-PLOS;
    PATHLOSS = pathloss(d, PLOS, PNLOS, init.l, init.c, init.f, init.eta_los, init.eta_nlos);
    GAIN = gain(PATHLOSS, init.l);
    
    power = p*GAIN;
end