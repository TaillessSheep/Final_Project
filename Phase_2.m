function Phase_2()
clear; close all; clc;
%% parameters
% the time to run before the this scripte stops by itself
%              [hour minute seconds]
time_run.std = [0    0      30];
% time_check = 200;
alg_size = 1000;
eFactor = 25;

saving_file_name = 'phase_2_data';

%% main code
LoadRawData

data_types = length(data);
% size_data: how many sets of data
% size_set: how many elements in one set
[size_data, size_set] = size(data(1).data);
p2.num_tested = 0; % full history
for i=(1:data_types)
p2.algorithm(i).count = 0;
p2.algorithm(i).value = 99999;
end
% p2.min_value = 99999 * ones(4,1);

% initial algorithm
old_Effi = randi(alg_size);
% new_Effi = old_Effi;
old_algorithm = P1_randGen_sequence(old_Effi);
% new_algorithm = old_algorithm;

% starting time of the programe
time_run.sec = TimeConverter(time_run.std);
time_left.sec = time_run.sec;
time_left.std = time_run.std;
old_sec = time_run.sec;
tic;
while time_left.sec>0
%% sorting and the checking the proformance
    p2.num_tested = p2.num_tested + 1;
    
    [new_algorithm,new_Effi] = mutate(old_algorithm, old_Effi,100);
    for i = (1:data_types)
        for j = (1:size_data)
            % sorted date(j) of data type(i) with new_algorithm
            sorted = sorting(data(i).data(j,:),new_algorithm,new_Effi,size_set);
            % Effe: Effe of all sets in type(i)
            Effe(j) = EffectivenessCheck(sorted,data(i).solu(j,:),size_set);
        end
        Effe_nom_ave = mean(Effe)*eFactor;
        alg_value = Effe_nom_ave + new_Effi;
        if (p2.algorithm(i).count==0 ||...  %% if it is the first tested algorithm
            accept(p2.algorithm(i).value(p2.algorithm(i).count), alg_value, time_left.sec/time_run.sec))
%                 alg_value < p2.algorithm(i).value(p2.algorithm(i).count))
            p2.algorithm(i).count = p2.algorithm(i).count + 1;
            p2.algorithm(i).final_algorithm= new_algorithm;
            p2.algorithm(i).Effe(p2.algorithm(i).count) = Effe_nom_ave;
            p2.algorithm(i).Effi(p2.algorithm(i).count) = new_Effi;
            p2.algorithm(i).value(p2.algorithm(i).count) = alg_value;
        end
    end
    
%% time control(terminating condition)
    time_left.sec = time_run.sec - toc;
    time_left.std = TimeConverter(time_left.sec);
    if(old_sec - time_left.sec>=1)
        fprintf('%ih %im %is\n',time_left.std(1),time_left.std(2),time_left.std(3))
        old_sec = time_left.sec;
    end
end

%% back up
disp('Backed up')
save(saving_file_name, 'p2');


%% display the result
for i = (1:data_types)
%     alg_value(i,:) = Effe_nom_ave(i,:) + new_Effi;
    figure('name',['type: ' int2str(i)])
    subplot(3,1,1)
    plot(p2.algorithm(i).Effe);
    title('Effe')
    subplot(3,1,2)
    plot(p2.algorithm(i).Effi);
    title('Effi')
    subplot(3,1,3)
    plot(p2.algorithm(i).value);
    title('alg index')
end

fprintf('\nTotal: %i;\n\n', p2.num_tested)
for i = (1:4)
%     fprintf('%f; Effi: %f;  Effe: %f \n',p2.min_value(i),p2.algorithm(i).Effi,p2.algorithm(i).Effe)
end

end



