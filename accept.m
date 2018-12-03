function out = accept(old, new, T,i)
% probability =  rand;
% temp = rand;

T1 = T;
T2 = sqrt(1-T1^2);
% T3 = 1-T2;
T3 = T2;

% T3 = (1-T)*2;
out = (new<old) + T3*rand;

if(out > 0.5)
    fprintf('%i: %f  %f\n',i,T3,out);
    out = true;
    
else
    out = false;
    
end

end