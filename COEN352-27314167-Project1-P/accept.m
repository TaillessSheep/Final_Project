%% accept
function out = accept(old, new, T)

% T = sqrt(1-T^2);
% T = 1-T;

out = (new<old) + T*rand*(1/3);

if(out > rand)
    out = true;
else
    out = false;
end

end
