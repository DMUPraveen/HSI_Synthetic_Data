function [combined_data] = combine_abundances(abundances,endmembers)
%This function combines the abundance map for each endmember into a single
%(row,column,channels) matrix where channels is the number of channels in
%the endmemebers
% The third axis of the abunadnces and the first axis of the endmemebers
% must be the same
%{
abundances - (rows,columns,no_end_members)
endmemebers - (no_endmemebers,no of channels channels/wavelengths)
returns - (rows,columns,no_of_channels/wavelengths)

%}

    size_endmembers = size(endmembers);
    no_of_endmemebers = size_endmembers(1);
    no_of_channels = size_endmembers(2);
    size_of_abundances = size(abundances);
    rows = size_of_abundances(1);
    columns = size_of_abundances(2);

    combined_data = zeros(rows,columns,no_of_channels);

    for i=1:no_of_endmemebers
%         reshaped_endmembers_i = reshape(endmembers(i,:),1,1,[]);
%         abundances_i = abundances(:,:,i);
%         multiplied = abundances_i.*reshaped_endmembers_i;
        combined_data = combined_data + abundances(:,:,i).*reshape(endmembers(i,:),1,1,[]);   
    end
end

