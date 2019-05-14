%%%%%%%%%%%%%%%%%%%
% The pathloss for the links between the vehiles
% "Dual-slope Path Loss" Model in Urban Scenarios

% Reference: THESIS\2018\06-Jun\Dual-slope pathloss
% Article: Analysis on V2V Connectivity under Dual-slope Path Loss Model in Urban Scenarios
%%%%%%%%%%%%%%%%%%% 

% "PL_d" is the path loss at distance "d" (in dB).
% "PL_0" is the reference path loss at the reference distance "d_0".
% "d" is the transmission distance.
% "d_b" is considered as the breakpoint distance at which the 
% Fresnel zone touches the ground.
% "n1" and "n2" being the path loss exponents which indicate the 
% rate with which the received signal power decays within d_b and 
% from "d_b" respectively. 
% The breakpoint distance db is about 165 m in urban environment for
% vehicular communications.

function [PL_d] = vehicle_pathloss(d, PL_0, d_b, n1, d_0, n2)

    if d <= d_b
        PL_d = PL_0 + 10*n1*log10(d/d_0) + normal_distribution(0, 4.15); % zero mean with standard deviation sqrt(4.15)
%         PL_d = db2lin(PL_d);    
    else
        PL_d = PL_0 + 10*n1*log10(d_b/d_0) + 10*n2*log10(d/d_b) + normal_distribution(0, 4.15);
%         PL_d = db2lin(PL_d);
    end

end