
function [x_s, y_s, x_v1, y_v1, x_v2, y_v2] = random_vehicle_locations(range)
    
    a = init.a;
    b = init.b;
    delta = init.delta;
    %%% Introducing the probablility of 50% for the v2v vehicles to be
    %%% on the x axis and 50% of the time to be on the y axis
    rng(range)
    prob = rand();

    if prob <= 0.5
        x_v1 = round((b-a).*rand(1,1) + a);
    else
        x_v1 = 0;
    end

    if x_v1==0
       y_v1 = round((b-a).*rand + a);
       x_v2 = 0;
       y_v2 = y_v1 + round((delta).*rand + 5);  % max 45m   min 5m
    else
        y_v1 = 0;
        y_v2 = 0;
        x_v2 = x_v1 + round((delta).*rand + 5);
    end
    
    if prob <= 0.5
        x_s = round((b-a).*rand + a);
    else    
        x_s = 0;
    end
    
    if x_s == 0
       y_s = round((b-a).*rand + a);
    else
        y_s = 0;
    end

end