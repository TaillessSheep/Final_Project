function  [algorithm,Effi] = mutate(algorithm ,Effi,max)
mutation = randi(3);

switch(mutation)
    case 1  % modify
        N = rand_nor(Effi);
        for i = (1:N)
            pos = randi(Effi);
            temp = ones(1,2);
            while(temp(1)==temp(2))
                temp = randi(100,[1,2]);
            end
            algorithm(pos,:) = temp;
        end
    case 2  % adding
        N = rand_nor((size(algorithm,1)-Effi));
        for i = (1:N)
            pos = randi(Effi);
            % shift everything to right by one
            algorithm(pos+1:Effi+1,:) = algorithm(pos:Effi,:);
            % modify the one at pos
            temp = ones(1,2);
            while(temp(1)==temp(2))
                temp = randi(100,[1,2]);
            end
            algorithm(pos,:) = temp;
            % increase Effi
            Effi = Effi + 1;
        end
    case 3  % deleting
        N = rand_nor(Effi/3);
        for i = (1:N)
            pos = randi(Effi);
            % shift everything left by one
            algorithm(pos:Effi-1,:) = algorithm(pos+1:Effi,:);
            % remove the last one
            algorithm(Effi,:) = zeros(1,2);
            % decrease Effi
            Effi = Effi -1;
        end
end

end

function out = rand_nor(lim)
l = 1;
temp = 10;
while(temp > l)
    temp = abs(randn());
end
out = floor(temp * (lim+1) / l);
end