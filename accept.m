function out = accept(old, new, T,i)
% probability =  rand;
% temp = rand;

T1 = T;
T2 = sqrt(1-T1^2);
% T3 = 1-T2;
T3 = T2;

% T3 = (1-T)*1;

out = (new<old) + T3*rand*(1/3);

if(out > rand)
%     fprintf('%i: %f  %f\n',i,T3,out);
    out = true;
    
else
    out = false;
    
end

end