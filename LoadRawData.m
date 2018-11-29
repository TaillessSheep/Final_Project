% script to load the raw data

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