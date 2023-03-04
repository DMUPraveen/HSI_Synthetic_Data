function [fixed_matrix] = fix_sum_to_one_with_mean(merged_abundances,region_size)
    %Fixes sum of endmemebers in all channels not being one with merged
    %abundances. 
    %{   
    If the sum is one that part is not changed.

    If the sum is not one but non-zero then it simply renormalizes across the
    channels
    
    Otherwise, take the mean of a square region centered around the pixel. and
    update the current pixel with the value then renomalize acorss the channels
    
    When taking the mean the mean is taken acorss one end_emember abundace
    for that abundance map in a region of the size
    (region_size*2+1,region_size*2+1) with the interested pizel at the
    center
    %}   

    size_of_merged_abundances = num2cell(size(merged_abundances));
    [rows,columns,~] = size_of_merged_abundances{:};
    threshold = 0.0001;
    check_function = @(x) abs(x-1)>threshold;
    for i=1:rows
        for j=1:columns
            abundances_total = sum(merged_abundances(i,j,:));
            if(abundances_total == 1)
                continue
            end
            if(abundances_total ==0)
                %do the averaging to get a a values that are not all zero
                [start_row,start_column,end_row,end_column] =contained_window(i,j,region_size,rows,columns);
%                 fprintf("%i,%i,%i,%i\n",start_row,start_column,end_row,end_column);
                mean_values = mean(merged_abundances(start_row:end_row,start_column:end_column,:),[1,2]);
%                 disp(mean_values);
                merged_abundances(i,j,:) = mean_values;
            end
            merged_abundances(i,j,:) = merged_abundances(i,j,:)/sum(merged_abundances(i,j,:)); %renormalize if sum is not one
            new_abundances_total = sum(merged_abundances(i,j,:));
            if(check_function(new_abundances_total) || isnan(new_abundances_total) || isinf(new_abundances_total))
               fprintf("didn't work at %i,%i sum is %i\n",i,j,new_abundances_total);
            end
        end 

    end
    fixed_matrix = merged_abundances;


end


function [start_row,start_column,end_row,end_column] =contained_window(row,column,step,no_rows,no_columns)
    %used to get a window for averaging if the window goes out of bounds it
    %shifts the window so that it does not do that

    start_row = row-step;
    start_column = column-step;
    end_row = row+step;
    end_column = column-step;

    if(start_row < 1)
        start_row = 1;
        end_row = row+2*step;
    end
    if(start_column < 1)
        start_column = 1;
        end_column = column+2*step;
    end
    if(end_row > no_rows)
        end_row = no_rows;
        start_row = row-2*step;
        
    end
    if(end_column > no_columns)
        end_column = no_columns;
        start_column = column-2*step;
    end

    %ensuring that it is still within bounds
    if(start_row < 1)
        start_row = 1;

    end
    if(start_column < 1)
        start_column = 1;
    end
    %next part is not really necessary but added just to make sure
    if(end_row > no_rows)
        end_row = no_rows;
    end
    if(end_column > no_columns)
        end_column = no_columns;
    end
end


