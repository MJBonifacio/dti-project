function interp = interpolateSlice(slice1, slice2, h1, h2, targetHeight)
% TODO: improve this with interp3 later  
  sliceGap = abs(h1-h2);
  w1 = abs(targetHeight-h1)/sliceGap;
  w2 = abs(targetHeight-h2)/sliceGap;

  [height, width] = size(slice1);
  interp = zeros(height, width);

  for i=1:height
    for j=1:width
      interp(i,j) = w1*slice1(i,j) + w2*slice2(i,j);
    end
  end
end
