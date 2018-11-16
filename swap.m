function [data] = swap(data, i1, i2)

temp = data(i1);
data(i1) = data(i2);
data(i2) = temp;

end