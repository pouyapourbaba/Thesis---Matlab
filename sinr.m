function [sinr_sr, sinr_rd] = sinr(s_sr, s_rd)
    sinr_sr = (s_sr) / (init.N_0 + init.SI_coef*init.p_r);
    sinr_rd = (s_rd) / (init.N_0);
end
