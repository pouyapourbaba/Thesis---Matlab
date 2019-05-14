%%%%%%%%%%%%%%%
% Generating the distances between the "r" and 
% the ground users.
%%%%%%%%%%%%%%%

function distance = distance_relay(x, y, z, l, L)

    d=zeros(l,1);

    for i=1:l
        d(i) = sqrt((x-L(i,1))^2 + (y-L(i,2))^2 + (z-L(i,3))^2);
    end
    
    distance = d;
end