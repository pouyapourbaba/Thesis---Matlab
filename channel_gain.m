function[gain_to_bs] = channel_gain(dist_to_bs)

% COST231-Hata model path loss model for channels between BS and Users
    %With LTE assumpitons for 2Ghz   -9 for shaddow fading   128.1
    %Path loss of each user
    gain_to_bs = -(128.1 + 37.6 * log10(dist_to_bs/1000)) + 10 * randn;
    linear_gain = db2lin(gain_to_bs);
    %Random change for each user, complex channel
    gain_to_bs = linear_gain*(randn + 1i*randn)/sqrt(2);
    gain_to_bs = abs(gain_to_bs);
end