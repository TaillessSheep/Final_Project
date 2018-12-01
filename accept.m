function out = accept(old, new, T)
% probability =  rand;
temp = rand;
out = (new<old) + T*temp;

if(out > 0.8)
    disp([num2str(T) ' ' num2str(out)])
    out = true;
    
else
    out = false;
    
end

end