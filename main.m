block_size = 25;
no_of_blocks_in_a_side = 4;
noofit = 700;

merged = merge_blocks(block_size,no_of_blocks_in_a_side,noofit);
fprintf("Before fixing the sum to ones:\n");
test_sum_to_one(merged,false);
plot_4_channel(fixed_merged,1);
filled_with_ones = fill_with_ones(merged,4,1,1,100,100);
fprintf("After fixing the sum to ones\n");
fixed_merged = fix_sum_to_one_with_mean(merged,1);
test_sum_to_one(fixed_merged,false);
plot_4_channel(fixed_merged,2);


