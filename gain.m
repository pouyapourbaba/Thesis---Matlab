%%%%%%%%%%%%%%%%%%%
% The average channel gain for the links between the r
% and the ground users.
%%%%%%%%%%%%%%%%%%% 

function gain = gain(pathloss, l)
    
    gain=zeros(l,1);
    biases = 1 ./ (5:l+4);
    for i=1:l
        %pathloss in db + 10 randn
        %db2lin
        %inverse ()
        %0,1
        pathloss(i) = db2lin(10*log10(pathloss(i)) + sqrt(10)*randn); %(randi([1 10],1,1)));
    end
    for i=1:l
        gain(i) = (1/pathloss(i)); % pathloss in dB
    end
    
%     linear_gain = db2lin(gain);
%     Random change for each user, complex channel
    gain = gain.*(randn + 1i*randn)/sqrt(2);
    gain = abs(gain);
end