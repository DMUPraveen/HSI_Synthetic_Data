function [destination_mat] = add_patch(source_mat,destination_mat,start_row,start_column,mask)
%Takes some parts from the soruce image and puts it in the destination
%source image must be the same size as the mask
%image where the mask is 1
%{
    source_mat - matrix where data is obtained for parts where the mask is 1
    (must have the same size as mask)
    destination_mat - matrix where data the patch is added to places where
    the mask is 0 are left alone and places where the mask is 1 are
    replaced with the source matrix values
    start_row,start_column - upper left corner of the patch,
    mask - mask used for the patch


%}

mask = arrayfun(@(x) x~=0,mask); %ensuring that all the elements are 1 or 0

% sizes = size(source_mat);
% rows = sizes(1);
% columns = sizes(1);

sizes_mask = size(mask);
mask_rows = sizes_mask;
mask_columns = sizes_mask;

negative_mask = 1-mask;
first_part = destination_mat(start_row:start_row+mask_rows-1,start_column:start_column+mask_columns-1).*negative_mask;
second_part = source_mat.*mask;
total_part = first_part+second_part;
destination_mat(start_row:start_row+mask_rows-1,start_column:start_column+mask_columns-1)=total_part;
end

