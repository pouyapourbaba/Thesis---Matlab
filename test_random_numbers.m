clc;
clear all;

i = 1000000;

normal_random = randn(1,i);
hist(normal_random, 10000);