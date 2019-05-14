% A function to calculate the channel gains between the vehicles

function [gain, d, pathloss] = gain_vehicle(x1,y1,x2,y2)
    PL_0 = init.PL_0;
    d_b = init.d_b;
    n1 = init.n1;
    d_0 = init.d_0;
    n2 = init.n2;
    
    d = distance_ground(x1, y1, x2, y2);
    pathloss = vehicle_pathloss(d, PL_0, d_b, n1, d_0, n2);
    pathloss = db2lin(pathloss + (10 * randn));
    gain = (1/pathloss);
%     %Random change for each user, complex channel
    gain = gain*(randn + 1i*randn)/sqrt(2);
    gain = abs(gain);
    
end