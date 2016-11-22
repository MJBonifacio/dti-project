function img = selectCorrespondingDTI(path, sliceLocation, height, width)
% Selects corresponding DTI at path with given parameters(2-4) of ADC image
  slicesDTI = dir(fullfile(path,'*.mat'));

% find slices closest to target height
idxHigherSlice = 1;
  for i=1:numel(slicesDTI)
    load(fullfile(path, slicesDTI(i).name));
    if slice.SliceLocation > sliceLocation
      clear slice
      break
    end
    idxHigherSlice = idxHigherSlice + 1;
    clear slice
  end

  load(fullfile(path, slicesDTI(idxHigherSlice -1)).name);
  s1 = slice.image;
  h1 = slice.SliceLocation;
  clear slice

  load(fullfile(path, slicesDTI(idxHigherSlice)).name);
  s2 = slice.image;
  h2 = slice.SliceLocation;

  % Interpolate target slice
  img = interpolateSlice(s1, s2, h1, h2, sliceLocation);

  % Scale to height, width
  img = imresize(img, [height, width]);
end
