% to test out completely random alg paris
% this scripe is for the phase one of the final project of COEN352

function Phase_1()
clear; close all; clc;
%% parameters
% the time to run before the this scripte stops by itself
%          [day hour minute seconds]
run_time = [0   11    0      0];
time_check = 200;
alg_size = 1000;
eFactor = 1250;

saving_file_name = 'phase_1_data_100_1';

%% predetermined value
data_types = 4;
time_check_count = 0;

%% main code
try
    load('data_raw');
catch ME
    % if the data has not yet been extracted
    if (strcmp(ME.identifier,'MATLAB:load:couldNotReadFile'))
        % all the names of the data files
        data(1).name = 'Project_2_datasets/Nearly_inversely_sorted/Nearly-inversely-sorted';
        data(2).name = 'Project_2_datasets/Nearly_sorted/Nearly-sorted';
        data(3).name = 'Project_2_datasets/Random_large_range/random';
        data(4).name = 'Project_2_datasets/Random_small_range/random';
        
        for i = (1:data_types)
            % post-fix of the input raw data file & the sorted data
            data(i).data = xlsread([data(i).name '-inputs.csv']);
            data(i).solu = xlsread([data(i).name '-solutions.csv']);
        end
        
        save ('data_raw','data');
    else
%         disp('jhg')
        rethrow(ME)
    end
    
end

% size_data: how many sets of data
% size_set: how many elements in one set
[size_data, size_set] = size(data(1).data);
p1.num_tested = 0; % full history
num_tested = 0; % in the current run
p1.min_value = 999999 * ones(4,1);

% p1.best_alg = zeros(4,1000);
try
    load(['..\ProjectData\' saving_file_name])
catch ME
    % if there were no previous result from phase 1
    if(strcmp(ME.identifier,'MATLAB:load:couldNotReadFile'))
        if (7~=exist('..\ProjectData','dir'))
            mkdir('..\ProjectData');
        end
        save(['..\ProjectData\' saving_file_name], 'p1');
    else
        rethrow(ME)
    end
end
ori_min_value = p1.min_value;
% starting time of the programe
start_time = clock;
start_time = start_time(3:6);

while true
%% time check every time_check amount of tests
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
            cleanup = onCleanup(@() myCleanupFun(p1,saving_file_name));
            break;
        end
        
        
    end
    
%% sorting and the checking the proformance
    p1.num_tested = p1.num_tested + 1;
    num_tested = num_tested + 1;
    [sorting_sequence Effi(num_tested)] = P1_randGen_sequence(alg_size);
    % sorting_sequence: the sequence of comparson
    % Effi
    
    for i = (1:data_types)
        for j = (1:size_data)
            sorted = sorting(data(i).data(j,:),sorting_sequence,Effi(num_tested),size_set);
            Effe(j) = EffectivenessCheck(sorted,data(i).solu(j,:),size_set);
        end
        Effe_nom_ave(i,num_tested) = mean(Effe)*eFactor;
        alg_value(i,num_tested) = Effe_nom_ave(i,num_tested) + Effi(num_tested);
        if (alg_value(i,num_tested) < p1.min_value(i))
            p1.best_alg(i).sequence = sorting_sequence;
            p1.best_alg(i).Effe = Effe_nom_ave(i,num_tested);
            p1.best_alg(i).Effi = Effi(num_tested);
            p1.min_value(i) = alg_value(i,num_tested);
        end
    end
    
    
    
    
    time_check_count = time_check_count + 1;
end

for i = (1:data_types)
    alg_value(i,:) = Effe_nom_ave(i,:) + Effi;
    figure('name',['type: ' int2str(i)])
    subplot(3,1,1)
    plot(Effe_nom_ave(i,:));
    title('Effe')
    subplot(3,1,2)
    plot(Effi);
    title('Effi')
    subplot(3,1,3)
    plot(alg_value(i,:));
    title('alg index')
end


fprintf('\nTotal: %i; New test: %i \n\n', p1.num_tested,num_tested)
for i = (1:4)
    fprintf('ori: %f; new: %f; Effi: %f;  Effe: %f \n', ori_min_value(i),p1.min_value(i),p1.best_alg(i).Effi,p1.best_alg(i).Effe)
end

end

function myCleanupFun(p1,saving_file_name)

disp('Backed up')
save(['..\ProjectData\' saving_file_name], 'p1');
end

% 7==exist('..\ProjectData','dir')
