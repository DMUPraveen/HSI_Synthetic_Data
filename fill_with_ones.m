function merged_new = fill_with_ones(merged,end_member,start_row,start_col,height,width)
    %{
    
    Takes in a matrix of shape (row_size,column_size,no_of_end_members) and
    fills a chosen rectangular area with ones in the chosen endmember number zeroing
    the other end members (thus respecting sum to one)
    The area need not be aligned with a block created from merge_blocks

    start_row,start_column specifies the location of the left corner of the
    rectangle to be filled with ones

    (height,width) - the size of the the rectangle area to be filled with
    ones (height is row wise width is column wise)
    
    merged - input matrix (must have a 3d shape with more that end_member
    number of dimensions in the 3rd axis)

    end_member - end_member_to_be_filled
    %}

    merged_new = merged;
    end_members = size(merged_new,3); 
    merged_new(start_row:start_row+height-1, start_col:start_col+width-1, end_member) = ones(height,width);
    
    for  i = 1:end_members
        if end_member ~= i
            merged_new(start_row:start_row+height-1, start_col:start_col+width-1, i) = zeros(height,width);
    
        end
    end

end

% figure(1);
% for i = 1:4
%     subplot(2,2,i);
%     imagesc(merged(:,:,i));
% end
