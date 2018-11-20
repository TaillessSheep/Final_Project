clear;close all;clc;

addpath('..')

load('phase_1_data.mat');

sorting_sequence = p1.best_alg(1).sequence;

load('..\data_raw');
Effi = 226;
size_set = 100;
num_tested = 1;

for i = (1:4)
    for j = (1:100)
        sorted(j,:,i) = sorting(data(i).data(j,:),p1.best_alg(i).sequence,p1.best_alg(i).Effi,size_set);
        %             Effe(j) = EffectivenessCheck(sorted(:,j,i),data(i).solu(j,:),size_set);
    end
    %         Effe_nom_ave(i,num_tested) = mean(Effe)*25;
    %         alg_value(i,num_tested) = Effe_nom_ave(i,num_tested) + Effi(num_tested);
    %         if (alg_value(i,num_tested) < p1.min_value(i))
    %             p1.best_alg(i).sequence = sorting_sequence;
    %             p1.min_value(i) = alg_value(i,num_tested);
    %         end
end

s1 = sorted(:,:,1);
s2 = sorted(:,:,2);
s3 = sorted(:,:,3);
s4 = sorted(:,:,4);


so1 = data(1).solu;
so2 = data(2).solu;
so3 = data(3).solu;
so4 = data(4).solu;




rmpath('..')


