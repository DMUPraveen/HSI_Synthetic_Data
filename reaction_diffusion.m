%The reosurces used to implement the algorithms
%http://karlsims.com/rd.html
%https://youtu.be/BV9ny785UNc

function [pattern] = reaction_diffusion(size,k,f,iterations)
%used for generating road like irregular shapes
%{
size - size of the pattern needed (large recommended like 100 then use
        imresize to make it smaller
k - kill rate part of the algorithm values 0.6-0.8 are recommended
f - feed rate part of the algorithms values 0.2-0.9 are recommened
iterations - must be large such as 10000
%}
k  = max(min(k,1),0);
f = max(min(f,1),0);
k = k*(0.070-0.045)+0.045;
f = f*(0.1-0.01)+0.01;
convolving_matrix = [0.05,0.2,0.05;0.2,-1,0.2;0.05,0.2,0.05];
A = ones(size);
B = zeros(size);
dA = 1.0;
dB = 0.5;
B(round(size/2):round(size/2)+round(size/10)-1,round(size/2):round(size/2)+round(size/10)-1) = ones(round(size/10));
for i=1:iterations
    Av = A(2:size-1,2:size-1);
    Bv = B(2:size-1,2:size-1);
    cA = conv2(A,convolving_matrix,'valid');
    cB = conv2(B,convolving_matrix,'valid');
    DA =dA*cA - (Av.*Bv).*Bv+f*(1-Av);
    DB =dB*cB + (Av.*Bv).*Bv-(k+f)*Bv;
    Av = Av+DA;
    Bv = Bv+DB;
    A(2:size-1,2:size-1) = Av;
    B(2:size-1,2:size-1) = Bv;
    A(A > 1) = 1;
    A(A<0) = 0;
    B(B > 1) = 1;
    B(B < 0) = 0;

end

pattern = (A-B+1)/2;
pattern = pattern(2:size-1,2:size-1);
pattern = pad_matrix(pattern,0);
end




