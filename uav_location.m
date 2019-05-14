%%%%%%%%%%%%%%%
% Generating the locations of the UAV
% "l" is the number of the locations. 
%%%%%%%%%%%%%%%

function locations = uav_location(h)
    l = init.l;
    h = h;

    k=1;
    % 8   points -> 1:64:226 m 113
    % 64  points -> 1:32:226 m 113 
    % 225 points -> 1:32:450 m 225
    % 400 points -> 1:6:115  m 58
    % 625 points -> 1:32:800 m 400
    % 2500 points -> 1:16:800 m 400
    for i = 1:32:226
        for j = 1:32:226
           L(k,:) = [i,j];
           k = k+1;
        end
    end

    sub = ones(l,2);

    L = L - 113*sub;

    h = h*ones(l,1);

    L = horzcat(L,h);
    
    locations = L;
end