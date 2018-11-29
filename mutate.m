function  [algorithm,Effi] = mutate(algorithm ,Effi)

mutation = randi(3);
pos = randi(Effi);
switch(mutation)
    case 1  % modify
        temp = ones(1,2);
        while(temp(1)==temp(2))
            temp = randi(100,[1,2]);
        end
        algorithm(pos,:) = temp;
        
    case 2  % adding
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
        
    case 3  % deleting 
        % shift everything left by one
        algorithm(pos:Effi-1,:) = algorithm(pos+1:Effi,:);
        % remove the last one
        algorithm(Effi,:) = zeros(1,2);
        % decrease Effi
        Effi = Effi -1;
end

% new_algorithm = old_algorithm;


end