%% sorting
function data = sorting(data,sequence,Effi)
for i = (1:Effi)
    if (sequence(i,1)<sequence(i,2))
        a = sequence(i,1);
        b = sequence(i,2);
    else
        a = sequence(i,2);
        b = sequence(i,1);
    end
    if (data(a)>data(b))
        data = swap(data,a,b);
    end
    
end
end