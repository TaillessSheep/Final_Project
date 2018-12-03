
clear; close all; clc;
tic
%% parameters
% find at least alg_amo amount of alg before stopping
alg_amo = 1000;

alg_size = 1000;
eFactor = 4000;

saving_file_name = 'phase_3_data';

%% main code
LoadRawData

data_types = length(data);
% size_data: how many sets of data
% size_set: how many elements in one set
[size_data, size_set] = size(data(1).data);

% initial algorithm
init_Effi = randi(alg_size);
init_algorithm = P1_randGen_sequence(init_Effi);

 % full history
for i=(1:data_types)
p3.num_tested(i) = 0;
p3.algorithm(i).count = 0;
p3.algorithm(i).value = 99999;
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
        [new_algorithm,new_Effi] = mutate(p3.algorithm(i).final_algorithm, p3.algorithm(i).final_Effi,200);
        for j = (1:size_data)
            % sorted date(j) of data type(i) with new_algorithm
            sorted = sorting(data(i).data(j,:),new_algorithm,new_Effi,size_set);
            % Effe: Effe of all sets in type(i)
            Effe(j) = EffectivenessCheck1(sorted,data(i).solu(j,:),size_set);
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
%     alg_value(i,:) = Effe_nom_ave(i,:) + new_Effi;
    figure('name',['type: ' int2str(i)])
    subplot(3,1,1)
    plot(p3.algorithm(i).Effe);
    title('Effe')
    subplot(3,1,2)
    plot(p3.algorithm(i).Effi);
    title('Effi')
    subplot(3,1,3)
    plot(p3.algorithm(i).value);
    title('alg index')
end

fprintf('\nTotal: %i;\n\n', p3.num_tested)
for i = (1:4)
%     fprintf('%f; Effi: %f;  Effe: %f \n',p3.min_value(i),p3.algorithm(i).Effi,p3.algorithm(i).Effe)
end
toc




