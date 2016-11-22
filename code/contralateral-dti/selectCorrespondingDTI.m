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

  % if no corresponding DTI
  if idxHigherSlice > numel(slicesDTI) or numel(slicesDTI) < 1 or idxHigherSlice==1
    img = -1;
    return;
  end

  fname1 = slicesDTI(idxHigherSlice-1).name;
  load(fullfile(path, fname1));
  s1 = slice.image;
  h1 = slice.SliceLocation;
  clear slice

  fname2 = slicesDTI(idxHigherSlice).name;
  load(fullfile(path, fname2));
  s2 = slice.image;
  h2 = slice.SliceLocation;

  % Interpolate target slice
  img = interpolateSlice(s1, s2, h1, h2, sliceLocation);

  % Scale to height, width
  img = imresize(img, [height, width]);
end
