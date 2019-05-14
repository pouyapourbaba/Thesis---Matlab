%%%%%%%%%%%%%%%
% Generating the angles between the "r" and 
% the ground users.
%%%%%%%%%%%%%%%

function theta = theta(d, h, l)

    theta=zeros(l,1);

    for i=1:l
        theta(i) = asind(h/d(i));
    end
    
    theta;
end
