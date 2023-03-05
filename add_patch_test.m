noise = perlin_like2d(100,6);
figure(2)
imagesc(noise)
sr=20;
mir = 2;
mar = 30;
blob = noise_blob(50,noise,sr,mir,mar);
merged = merge_blocks(25,4,700);
patched_merged = zeros(size(merged));

patched_merged(:,:,1) = add_patch(noise(1:50,1:50)*10,merged(:,:,1),50,50,blob);
patched_merged(:,:,2) = add_patch(noise(1:50,51:100)*0.5,merged(:,:,2),50,50,blob);
patched_merged(:,:,3) = add_patch(noise(51:100,1:50),merged(:,:,3),50,50,blob);
patched_merged(:,:,4) = add_patch(noise(51:100,51:100)*3,merged(:,:,4),50,50,blob);
for i=1:4
    patched_merged(:,:,i) = simple_blur(patched_merged(:,:,i));
end
fixed_patched = fix_sum_to_one_with_mean(patched_merged,1);

test_sum_to_one(fixed_patched,false);
plot_4_channel(fixed_patched,1);
