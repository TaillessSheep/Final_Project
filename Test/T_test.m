clear;close all;clc;

x = (1:-1/1000:0);

y = sqrt(1-x.^2);
y = 1-y;
plot(x,y);
