function [matrix] = simple_blur(matrix)
    blur_matrix = ones(3)*(1/9);
    matrix = conv2(matrix,blur_matrix,'same');
end

