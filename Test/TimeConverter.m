% toSecond = true: std->sec
function out_time = TimeConverter(in_time)

if(length(in_time)==3) % from std to seconds
    %          h*3600          + m*60          + s
    out_time = in_time(1)*3600 + in_time(2)*60 + in_time(3);

    
elseif(length(in_time)==1) % from seconds to std
    %           h m s
    out_time = [0 0 0];
    out_time(1) = floor(in_time / 3600);
    in_time = in_time - out_time(1)*3600;
    out_time(2) = floor(in_time / 60);
    in_time = in_time - out_time(2)*60;
    out_time(3) = floor(in_time);
    
else
    error('Input length (%i) is neither 1 or 3.',length(in_time));
end

end