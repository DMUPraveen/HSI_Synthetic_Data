function [] = plot_4_channel(four_channel_matrix,number)
    %this code is used to plot a matrix of the shape (x,y,4) as 4 heatmap
    figure(number);
    for i = 1:4
        subplot(2,2,i);
        imagesc(four_channel_matrix(:,:,i));
    end
end
