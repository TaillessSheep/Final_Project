clear; close all; clc;
tic
%% parameters
% find at least alg_amo amount of alg before stopping
alg_max = 100;

alg_size = 1000;
eFactor = 4000;

saving_file_name = 'result';

%% main code
%loading data
% all the names of the data files
data(1).name = 'Project_2_datasets/Nearly_inversely_sorted/Nearly-inversely-sorted';
data(2).name = 'Project_2_datasets/Nearly_sorted/Nearly-sorted';
data(3).name = 'Project_2_datasets/Random_large_range/random';
data(4).name = 'Project_2_datasets/Random_small_range/random';
data_types = length(data);
for i = (1:data_types)
    % post-fix of the input raw data file & the sorted data
    data(i).data = xlsread([data(i).name '-inputs.csv']);
    data(i).solu = xlsread([data(i).name '-solutions.csv']);
end


data_types = length(data);
% size_data: how many sets of data
% size_set: how many elements in one set
[size_data, size_set] = size(data(1).data);

% initial algorithm
init_Effi = randi(alg_size);
init_algorithm = randGen_sequence(init_Effi,alg_size);

for i=(1:data_types)    
    result.algorithm(i).final_algorithm = init_algorithm;
    result.algorithm(i).final_Effi = init_Effi;
end


%% sorting and the checking the proformance
for i = (1:data_types) % for all 4 data types
    disp(i)
    alg_count = 0;
    while (alg_count < alg_max)
        % mutate to a new neighbor
        [new_algorithm,new_Effi] = mutate(result.algorithm(i).final_algorithm, result.algorithm(i).final_Effi);
        for j = (1:size_data) % for all sets of data of type 'i'
            % sorted date(j) of data type(i) with new_algorithm
            sorted = sorting(data(i).data(j,:),new_algorithm,new_Effi);
            % Effe: Effe of all sets in type(i)
            Effe(j) = EffectivenessCheck(sorted,data(i).solu(j,:));
        end
        Effe_nom_ave = mean(Effe)*eFactor;  % average effectiveness
        alg_value = Effe_nom_ave + new_Effi;  % combining effectiveness and efficiency linearly
        if (alg_count==0 ||...  % if it is the first tested algorithm
                accept(result.algorithm(i).value(alg_count), alg_value, 1-alg_count/alg_max))% or this algoritm is acceptable
            % update the result
            alg_count = alg_count + 1;
            result.algorithm(i).final_algorithm = new_algorithm;
            result.algorithm(i).final_Effe = Effe_nom_ave;
            result.algorithm(i).final_Effi = new_Effi;
            result.algorithm(i).Effe(alg_count) = Effe_nom_ave;
            result.algorithm(i).Effi(alg_count) = new_Effi;
            result.algorithm(i).value(alg_count) = alg_value;
        end
    end
    
end

%% back up (saving into file)
disp('Backed up')
save(saving_file_name, 'result');


%% display the result
for i = (1:data_types)
    sum_sorted = zeros(1,size_set);
    figure('name',['type: ' int2str(i)])
    subplot(3,1,1)
    hold on;
    plot(result.algorithm(i).Effe);
    plot(result.algorithm(i).Effi);
    title('Effectiveness & Efficiency')
    subplot(3,1,2)
    plot(result.algorithm(i).value);
    title('alg index')
    for j = (1:size_data)
        % sorted date(j) of data type(i) with new_algorithm
        sorted = sorting(data(i).data(j,:),result.algorithm(i).final_algorithm, result.algorithm(i).final_Effi);
        sum_sorted = sum_sorted + sorted;
    end
    subplot(3,1,3)
    stem(sum_sorted);
end

toc

