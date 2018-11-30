function out = accept(old, new, T)
% probability =  rand;
out = (new<old) + T*rand;
if(out > 0.5)
    out = true;
else
    out = false;
end

end