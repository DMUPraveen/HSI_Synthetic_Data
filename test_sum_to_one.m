function [sumToOneFails] = test_sum_to_one(abundances,silent)
%The function tests sum to one criterian of a given hsi abundance matrix
%for all channels

%{
    takes in a matrix of (no_rows,no_columns,end_members)
    returns no of instances where sum to one failed
    
    if silent is true it will print an error or okay message otherwise it
    will not do so
%}
    threshold = 0.0001;
    check_function = @(x) abs(x-1)>threshold;
    sum_array = sum(abundances,3);%summing all the endmember abundances
    fails_array = arrayfun(check_function,sum_array);
    sumToOneFails = sum(fails_array(:)); 
    if silent
        return;
    end
    if sumToOneFails == 0
        fprintf("Okay all channels sum to one\n");
    else
        sz = size(abundances);
        rows = sz(1);
        columns = sz(2);
        fprintf("Fail %i failures out of %i\n",sumToOneFails, rows*columns);
    end
end

