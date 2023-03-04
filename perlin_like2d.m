
function s = perlin_like2d(m,octaves)
  s = zeros([m,m]);
  max_octaves = ceil(log2(m));
  if(octaves > max_octaves)
      octaves = max_octaves;
  end
  for i = 0:octaves
    points_to_interpolate = max(2,round(m/power(2,i)))*2;
    d = interp2(randn([points_to_interpolate,points_to_interpolate]), i, 'spline');
    s = s + (i+1) * d(1:m, 1:m);
  end
  s = (s - min(min(s(:,:)))) ./ (max(max(s(:,:))) - min(min(s(:,:))));
end
