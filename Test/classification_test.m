clear;close all;clc;

addpath('..')

load('..\data_raw');


for i = (1:4)
    for j = (1:100)
        %             sorted = data(i).data(j,:);
        Effe(i,j) = EffectivenessCheck(data(i).data(j,:),data(i).solu(j,:),100);
    end
%     Effe_nom_ave(i) = mean(Effe)*25;
    
end

Effe = Effe ;
Effe_nom_ave = mean(Effe,2);



rmpath('..')

