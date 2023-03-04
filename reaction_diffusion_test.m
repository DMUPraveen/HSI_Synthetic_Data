pattern = reaction_diffusion(100,0.7,0.55,10000);
figure(1);
imagesc(pattern);

mask = imresize(pattern,0.25);
mask = (mask < median(mask(:)));
figure(2);
imagesc(mask)
