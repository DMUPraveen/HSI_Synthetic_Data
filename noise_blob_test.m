ns = 100;
oc = 0;
noise = perlin_like2d(100,oc);
sr=3;
mir = 10;
mar = 30;
blob = noise_blob(50,noise,sr,mir,mar);
imagesc(blob)