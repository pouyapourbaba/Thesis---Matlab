%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file contains all the variables needed for the main files %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef init
   properties (Constant)
        l=64;               % The number of the locations for UAV
%         h=500;               % The heigth of the UAV

        x_d = 1000;			% The x coordinate of the destination node
        y_d = 1000; 		% The y coordinate of the destination node
        z_d = 30;

        % make the tx power of V2V link smaller than the S-R-D link
        p_s = .500 / (3.9*10^(-14));          % Transmit power of the source
        p_r = .500 / (3.9*10^(-14));          % Transmit power of the relay 
        p_v1 = .1 / (3.9*10^(-14));         % Transmit power of the v1 
        p_v2 = .1 / (3.9*10^(-14));         % Transmit power of the v2 
        
        % the variables needed for calculating the v2v pathloss
        % Dual-slope Path Loss Model in Urban Scenarios
        PL_0 = 63.9;  % reference path loss at the reference distance
        d_b = 161;  % the breakpoint distance 
        n1 = 1.81;  % path loss exponents
        n2 = 2.85;  % path loss exponents
        d_0 = 10;   % reference distance

        %%% The vehicles are in the range of a(meters) to b(meters)
        %%% The distance of the two vehicles is set to be max. delta(meters)
        a = -500;           %initial -100
        b = 500;            %initial -100
        delta = 40;         % The distance of the two vehicles in the v2v link

        f = 2e9;         % The carrier frequency
        c = 3e8;       % The speed of the light

        alpha_suburban = 5.0188;
        beta_suburban = 0.3511;
        eta_los_suburban = 0.1;
        eta_nlos_suburban = 21;
        
        alpha_urban = 9.6101;
        beta_urban = 0.1592; 
        eta_los_urban = 1;
        eta_nlos_urban = 20;
        
        alpha_dense_urban = 11.9480;
        beta_dense_urban = 0.1359;
        eta_los_dense_urban = 1.6;
        eta_nlos_dense_urban = 23;
        
        alpha_high_urban = 27.1562;
        beta_high_urban = 0.1225;
        eta_los_high_urban = 2.3;
        eta_nlos_high_urban = 34;
        
        alpha = init.alpha_suburban;          % The environment constants for the probability of line of sight
        beta = init.beta_suburban;           % The environment constants for the probability of line of sight
        eta_los = db2lin(init.eta_los_suburban);        % Additinal pathloss to free space for LOS
        eta_nlos = db2lin(init.eta_nlos_suburban);      % Additinal pathloss to free space for NLOS
   
        noise_coef = 3.9*10^(-14);
        N_0 = 1;         % Noise power -104 dBm
        SI_coef = 10^(-10);         % Self interference cancelation coefficient

        gamma1 = db2lin(1);  %5dB    % The SINR threshold for the first constraint
        gamma2 = db2lin(1);      % The SINR threshold for the second and third constraint
        gamma3 = db2lin(1);      % The SINR threshold for the fourth constraint
   end
end