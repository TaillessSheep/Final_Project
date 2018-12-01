function out = accept(old, new, T)
% probability =  rand;
% temp = rand;
T1 = T;

T2 = sqrt(1-T1^2);
T3 = 1-T2;
out = (new<old) + T3*rand;

if(out > 0.8)
    fprintf('%f  %f  %f  %f  %f\n',T,T1,T2,T3,out);
    out = true;
    
else
    out = false;
    
end

end