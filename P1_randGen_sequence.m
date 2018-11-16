% the funciton is the generate a 2*1000 array randomly
% with the numbers in the range of 1~100

function [seq, Effi] = P1_randGen_sequence()
seq = zeros(1000,2);
Effi = randi(1000);

seq(1:Effi,:) = randi(100,[Effi,2]);

% chack for useless pairs e.g.(34,34)
for i = (1:Effi)
    while seq(i,1)==seq(i,2)
        seq(i,:) = randi(100,[1 2]);
    end
end

end