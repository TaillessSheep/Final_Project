clear;close all;clc;
addpath('..')
load('..\data_raw');

stop_time =  36000; % seconds

raw = data(1).solu(1,:);

max_Effe = 0;
best_index = zeros(1,100);

try
    load('max_Effe');
catch ME
    
end


pre = 0;
cur = 0;
tic;
while (toc < stop_time)
    cur = toc;
    if(cur - pre >= 1)
        pre = cur;
        disp(round(stop_time - cur))
    end
    index = randperm(100);
    new = raw(index);   
    
    Effe = EffectivenessCheck(new,raw,100);
    if (Effe>max_Effe)
        max_Effe = Effe;
        best_index = index;
    end
    
    
end

disp(max_Effe)
save('max_Effe','max_Effe','best_index')

rmpath('..')