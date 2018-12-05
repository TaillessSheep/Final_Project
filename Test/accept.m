function out = accept(old, new, T,i)

T1 = 1-T;
T2 = sqrt(1-T1^2);
T3 = 1-T2;

out = (new<old) + T3*rand*(1/3);

if(out > rand)
    out = true;
else
    out = false;
end

end