function Phase_2()
clear; close all; clc;
%% parameters
% the time to run before the this scripte stops by itself
%          [day hour minute seconds]
run_time = [0   0    0      1];
time_check = 200;
alg_size = 1000;
eFactor = 1250;

saving_file_name = 'phase_2_data';

%% predetermined value
time_check_count = 0;

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

% starting time of the programe
start_time = clock;
start_time = start_time(3:6);

% initial algorithm
old_Effi = randi(alg_size);
% new_Effi = old_Effi;
old_algorithm = P1_randGen_sequence(old_Effi);
% new_algorithm = old_algorithm;
while true
%% time check every time_check amount of tests (stopping condition)
    if (time_check_count == time_check)
        
        time_check_count = 0;
        % amount of time passed
        cur_time = clock;
        diff_time = cur_time(3:6) - start_time; 
        % difference between passed time and required run time
        timeup = run_time - diff_time;
        % removing the incorrect time value
        for i = [4,3] % for minute and second
            if (timeup(i)<0)
                timeup(i-1) = timeup(i-1) - 1;
                timeup(i) = timeup(i) + 60;
            elseif (timeup(i)>60)
                timeup(i-1) = timeup(i-1) + 1;
                timeup(i) = timeup(i) - 60;
            end
        end
        if (timeup(2)<0) % for hour
            timeup(1) = timeup(1) - 1;
            timeup(2) = timeup(2) + 24;
        elseif(timeup(2)>24)
            timeup(1) = timeup(1) + 1;
            timeup(2) = timeup(2) - 24;
        end

        % print out the remaining time
        disp([int2str(timeup(1)) 'D  ' int2str(timeup(2)) 'h  ' ...
            int2str(timeup(3)) 'm  ' int2str(timeup(4)) 's'])
        
        % if the remaining time is negative
        if (timeup(1)<0)
            stop = true;
        else
            stop = false;
        end
        % break out of the loop
        if (stop)
            cleanup = onCleanup(@() myCleanupFun(p2,saving_file_name));
            break;
        end
        
        
    end
%% sorting and the checking the proformance
    p2.num_tested = p2.num_tested + 1;
    
    [new_algorithm,new_Effi] = mutate(old_algorithm, old_Effi);
    for i = (1:data_types)
        for j = (1:size_data)
            % sorted date(j) of data type(i) with new_algorithm
            sorted = sorting(data(i).data(j,:),new_algorithm,new_Effi,size_set);
            % Effe: Effe of all sets in type(i)
            Effe(j) = EffectivenessCheck(sorted,data(i).solu(j,:),size_set);
        end
        Effe_nom_ave = mean(Effe)*eFactor;
        alg_value = Effe_nom_ave + new_Effi;
        if (p2.algorithm(i).count==0 ||...
                alg_value < p2.algorithm(i).value(p2.algorithm(i).count))
            p2.algorithm(i).count = p2.algorithm(i).count + 1;
            p2.algorithm(i).final_algorithm= new_algorithm;
            p2.algorithm(i).Effe(p2.algorithm(i).count) = Effe_nom_ave;
            p2.algorithm(i).Effi(p2.algorithm(i).count) = new_Effi;
            p2.algorithm(i).value(p2.algorithm(i).count) = alg_value;
        end
    end
    
    time_check_count = time_check_count + 1;
end

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


function myCleanupFun(p2,saving_file_name)

disp('Backed up')
save(saving_file_name, 'p2');
end


