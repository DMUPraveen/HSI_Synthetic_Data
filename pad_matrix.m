function padded = pad_matrix(matrix,value)
padded = matrix;
s =size(padded);
c = s(2);
zr = ones(1,c)*value;
padded = [zr;padded;zr];
s =size(padded);
r = s(1);
zc = ones(r,1)*value;

padded = [zc,padded,zc];
end

