block_size = 25;
no_of_blocks_in_a_side = 4;
noofit = 700;

merged = merge_blocks(block_size,no_of_blocks_in_a_side,noofit);
plot_4_channel(merged);
test_sum_to_one(merged,false);
filled_with_ones = fill_with_ones(merged,4,1,1,100,100);
test_sum_to_one(filled_with_ones,false);