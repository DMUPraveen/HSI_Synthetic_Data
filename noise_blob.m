%The reosurces used to implement the algorithms
%https://youtu.be/ZI1dmHv3MeM
%https://necessarydisorder.wordpress.com/2017/11/15/drawing-from-noise-and-then-making-animated-loopy-gifs-from-there/
function [mask] = noise_blob(size_of_mask,noise,sampling_radius,min_radius,max_radius)
    %creates a mask for a blob like shape with a specified shape
    %{
    size_of_mask - the size of the mask that needs to be created
    noise - 2d noise function provided as 2d square matrix (you can use
    perlin_like2d for this different octave values will give different
    results)
    sampling_radius = radius of the circle used to sample nois values
    (larger values will have larger numbers (less jumps) of radius values for the blob )
    min_radius = minimum radius of the blob
    max_radius = maximum radius of the blob
    
    returns a mask contatining 0 and 1 values that can be used in add_patch
    %}
    s = size_of_mask;
    r = s;
    c = s;
    cr = r/2;
    cc = c/2;
    mask = zeros(s,s);
    size_of_noise = size(noise);
    if(sampling_radius > min(size_of_noise)/2-1)
        sampling_radius = min(size_of_noise)/2-1;
    end
    for i=1:r
        for j=1:c
            pos = [i-cr,j-cc];
%             disp(pos)
            current_radius = sqrt(pos(1)*pos(1)+pos(2)*pos(2));
            if(current_radius == 0)
                pos = [0,0];
            else

                pos = pos/current_radius*sampling_radius;
            end
%             disp(round(pos+[size_of_noise(1)/2,size_of_noise(1)/2]));
            spos = round(pos+[size_of_noise(1)/2,size_of_noise(1)/2])+1;
%             disp(spos);
            blob_radius = noise(spos(1),spos(2))*(max_radius-min_radius)+min_radius;
            
            mask(i,j) = current_radius < blob_radius;
        end
    end
end



