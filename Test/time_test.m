%          [hour minute seconds]
time_run.std = [20    0      10];
time_run.sec = TimeConverter(time_run.std);

tic;

time_left.sec = time_run.sec;
time_left.std = time_run.std;
old_sec = time_left.sec;

while(time_left.sec>0)
    
    
    
    time_left.sec = time_run.sec - toc;
    time_left.std = TimeConverter(time_left.sec);
    if(old_sec - time_left.sec>=1)
        fprintf('%ih %im %is\n',time_left.std(1),time_left.std(2),time_left.std(3))
        old_sec = time_left.sec;
    end
end
