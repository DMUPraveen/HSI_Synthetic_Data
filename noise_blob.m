function [mask] = noise_blob(size_of_mask,noise,sampling_radius,min_radius,max_radius)
    %creates a mask for a blob like shape with a specified shape
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



