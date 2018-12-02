function Phase_3()
clear; close all; clc;
%% parameters
% find at least alg_amo amount of alg before stopping
alg_amo = 10;

alg_size = 1000;
eFactor = 1000;

saving_file_name = 'phase_3_data';

%% main code
LoadRawData

data_types = length(data);
% size_data: how many sets of data
% size_set: how many elements in one set
[size_data, size_set] = size(data(1).data);
p3.num_tested = 0; % full history
for i=(1:data_types)
p3.algorithm(i).count = 0;
p3.algorithm(i).value = 99999;
end
alg_count = zeros(1,data_types);

% initial algorithm
old_Effi = randi(alg_size);
old_algorithm = P1_randGen_sequence(old_Effi);


while (sum(alg_count >= alg_amo) < data_types)
%% sorting and the checking the proformance
    p3.num_tested = p3.num_tested + 1;
    
    [new_algorithm,new_Effi] = mutate(old_algorithm, old_Effi,200);
    for i = (1:data_types)
        if(alg_count(i) == alg_amo)
            continue
        end
        for j = (1:size_data)
            % sorted date(j) of data type(i) with new_algorithm
            sorted = sorting(data(i).data(j,:),new_algorithm,new_Effi,size_set);
            % Effe: Effe of all sets in type(i)
            Effe(j) = EffectivenessCheck1(sorted,data(i).solu(j,:),size_set);
        end
        Effe_nom_ave = mean(Effe)*eFactor;
        alg_value = Effe_nom_ave + new_Effi;
        if (p3.algorithm(i).count==0 ||...  %% if it is the first tested algorithm
            accept(p3.algorithm(i).value(p3.algorithm(i).count), alg_value, max(min(alg_count(i)/alg_amo,1),0)))
%                 alg_value < p3.algorithm(i).value(p3.algorithm(i).count))
            p3.algorithm(i).count = p3.algorithm(i).count + 1;
            alg_count(i) = alg_count(i) + 1;
            p3.algorithm(i).final_algorithm= new_algorithm;
            p3.algorithm(i).Effe(p3.algorithm(i).count) = Effe_nom_ave;
            p3.algorithm(i).Effi(p3.algorithm(i).count) = new_Effi;
            p3.algorithm(i).value(p3.algorithm(i).count) = alg_value;
        end
    end
    
%% terminating condition: check whether alg count has reach requirment

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

end



