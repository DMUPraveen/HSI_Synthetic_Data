function merged = merge_blocks(block_size, no_of_blocks_on_a_side, noofit)

    %{
    calls and merges blocks created by syngen into one matrix

    returns a matrix of shape (block_size* no_of_blocks_on_a_side,block_size* no_of_blocks_on_a_side,4)
    The 4 is because the synge that is being used at the moment is generating a
    four maps (for 4 endmembers)

    block_size - blocks size needed by syngen (syngen will return four matrices
    of shape (block_size,block_size)

    no_of_blocks_on_a_side - this code will make a larger matrix with this many
    blocks on a side, meaning no_of_blocks_on_a_side^2 blocks in total

    noofit - number of iterations -- needed by syngen

    warning!! due to an error in syngen sum to one is not satisfied by the
    returned matrix additional processing is needed
    %}
    size = block_size;
    height = size;
    width = size;
    n_blocks = no_of_blocks_on_a_side;

    merged = zeros(size*n_blocks,size*n_blocks,4);

    for i = 1:n_blocks

        for j = 1:n_blocks

            [alpha,beta,delta,gama] = syngen(height,width,noofit);
            %the alpha(1:size,1:size) is required because syngen for some
            %unkown reason returns the wrong size at certain instances
            merged((i-1)*size+1:i*size,(j-1)*size+1:j*size,1) = alpha(1:size,1:size);
            merged((i-1)*size+1:i*size,(j-1)*size+1:j*size,2) = beta(1:size,1:size);
            merged((i-1)*size+1:i*size,(j-1)*size+1:j*size,3) = delta(1:size,1:size);
            merged((i-1)*size+1:i*size,(j-1)*size+1:j*size,4) = gama(1:size,1:size);
        end

    end


end

%[merged] = create_merged(25, 4, 700)