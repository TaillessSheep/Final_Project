clear; close all; clc;
tic
%% parameters
% find at least alg_amo amount of alg before stopping
alg_amo = 100;

alg_size = 1000;
eFactor = 4000;

saving_file_name = 'result';

%% main code
%loading data
try
    load('data_raw');
catch ME
    % if the data has not yet been extracted
    if (strcmp(ME.identifier,'MATLAB:load:couldNotReadFile'))
        % all the names of the data files
        disp('ha')
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
        
        save ('data_raw','data');
    else
        rethrow(ME)
    end
    
end

data_types = length(data);
% size_data: how many sets of data
% size_set: how many elements in one set
[size_data, size_set] = size(data(1).data);

% initial algorithm
init_Effi = randi(alg_size);
init_algorithm = randGen_sequence(init_Effi,alg_size);

% full history
for i=(1:data_types)
p3.num_tested(i) = 0;
p3.algorithm(i).count = 0;
% p3.algorithm(i).value = 99999;

p3.algorithm(i).final_algorithm = init_algorithm;
p3.algorithm(i).final_Effi = init_Effi;
end
alg_count = zeros(1,data_types);

while (sum(alg_count >= alg_amo) < data_types)
%% sorting and the checking the proformance
    
    for i = (1:data_types)
        if(alg_count(i) == alg_amo)
            continue
        end
        p3.num_tested(i) = p3.num_tested(i) + 1;
        [new_algorithm,new_Effi] = mutate(p3.algorithm(i).final_algorithm, p3.algorithm(i).final_Effi);
        for j = (1:size_data)
            % sorted date(j) of data type(i) with new_algorithm
            sorted = sorting(data(i).data(j,:),new_algorithm,new_Effi);
            % Effe: Effe of all sets in type(i)
            Effe(j) = EffectivenessCheck(sorted,data(i).solu(j,:));
        end
        Effe_nom_ave = mean(Effe)*eFactor;
        alg_value = Effe_nom_ave + new_Effi;
        if (p3.algorithm(i).count==0 ||...  %% if it is the first tested algorithm
            accept(p3.algorithm(i).value(p3.algorithm(i).count), alg_value, alg_count(i)/alg_amo,i))
%                 alg_value < p3.algorithm(i).value(p3.algorithm(i).count))
            p3.algorithm(i).count = p3.algorithm(i).count + 1;
            alg_count(i) = alg_count(i) + 1;
            p3.algorithm(i).final_algorithm = new_algorithm;
            p3.algorithm(i).final_Effe = Effe_nom_ave;
            p3.algorithm(i).final_Effi = new_Effi;
            p3.algorithm(i).Effe(p3.algorithm(i).count) = Effe_nom_ave;
            p3.algorithm(i).Effi(p3.algorithm(i).count) = new_Effi;
            p3.algorithm(i).value(p3.algorithm(i).count) = alg_value;
        end
    end

end

%% back up
disp('Backed up')
save(['..\ProjectData\' saving_file_name], 'p3');


%% display the result
for i = (1:data_types)
    sum_sorted = zeros(1,size_set);
    figure('name',['type: ' int2str(i)])
    subplot(4,1,1)
    plot(p3.algorithm(i).Effe);
    title('Effectiveness')
    subplot(4,1,2)
    plot(p3.algorithm(i).Effi);
    title('Efficiency')
    subplot(4,1,3)
    plot(p3.algorithm(i).value);
    title('alg index')
    for j = (1:size_data)
        % sorted date(j) of data type(i) with new_algorithm
        sorted = sorting(data(i).data(j,:),p3.algorithm(i).final_algorithm, p3.algorithm(i).final_Effi);
        sum_sorted = sum_sorted + sorted;
    end
    subplot(4,1,4)
    stem(sum_sorted);
end

fprintf('\nTested: %i;\n\n', p3.num_tested)
sum_sorted = 0;
for i = (1:data_types)
    sum_sorted = sum_sorted + p3.num_tested(i);
end
fprintf('\nTotal: %i;\n\n', sum_sorted)

toc

%% functions-----------------------------------------------------------------------
%% randGen_sequence
% the funciton is the generate a 2*1000 array randomly
% with the numbers in the range of 1~100

function [seq] = randGen_sequence(Effi,max)
seq = zeros(max,2);
seq(1:Effi,:) = randi(100,[Effi,2]);

% chack for useless pairs e.g.(34,34)
for i = (1:Effi)
    while seq(i,1)==seq(i,2)
        seq(i,:) = randi(100,[1 2]);
    end
end
end


%% sorting
function data = sorting(data,sequence,Effi)
for i = (1:Effi)
    if (sequence(i,1)<sequence(i,2))
        a = sequence(i,1);
        b = sequence(i,2);
    else
        a = sequence(i,2);
        b = sequence(i,1);
    end
    if (data(a)>data(b))
        data = swap(data,a,b);
    end
    
end
end

%% swap
function [data] = swap(data, i1, i2)

temp = data(i1);
data(i1) = data(i2);
data(i2) = temp;

end

%% mutate
function  [algorithm,Effi] = mutate(algorithm ,Effi)
mutation = randi(3);

switch(mutation)
    case 1  % modify
        N = rand_nor(Effi);
        for i = (1:N)
            pos = randi(Effi);
            temp = ones(1,2);
            while(temp(1)==temp(2))
                temp = randi(100,[1,2]);
            end
            algorithm(pos,:) = temp;
        end
    case 2  % adding
        N = rand_nor((size(algorithm,1)-Effi));
        for i = (1:N)
            pos = randi(Effi);
            % shift everything to right by one
            algorithm(pos+1:Effi+1,:) = algorithm(pos:Effi,:);
            % modify the one at pos
            temp = ones(1,2);
            while(temp(1)==temp(2))
                temp = randi(100,[1,2]);
            end
            algorithm(pos,:) = temp;
            % increase Effi
            Effi = Effi + 1;
        end
    case 3  % deleting
        N = rand_nor(Effi/3);
        for i = (1:N)
            pos = randi(Effi);
            % shift everything left by one
            algorithm(pos:Effi-1,:) = algorithm(pos+1:Effi,:);
            % remove the last one
            algorithm(Effi,:) = zeros(1,2);
            % decrease Effi
            Effi = Effi -1;
        end
end

end

function out = rand_nor(lim)
l = 1;
temp = 10;
while(temp > l)
    temp = abs(randn());
end
out = floor(temp * (lim+1) / l);
end

%% EffectivenessCheck
function Effe = EffectivenessCheck(sorted, solu)

inv_solu = fliplr(solu);
diff_inv = sum(abs(inv_solu-solu));
diff_sor = sum(abs(sorted-solu));
Effe = diff_sor/ diff_inv;

end

%% accept
function out = accept(old, new, T,i)

T1 = 1-T;
T2 = sqrt(1-T1^2);
T3 = 1-T2;

out = (new<old) + T3*rand*(1/3);

if(out > rand)
    out = true;
else
    out = false;
end

end

