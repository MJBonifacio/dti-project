function img = selectCorrespondingFA(path, sliceLocation, height, width)
% Selects corresponding FA at path with given parameters(2-4) of ADC image
  slicesFA = dir(fullfile(path,'*.dcm'));

% find slices closest to target height
idxHigherSlice = 1;
  for i=1:numel(slicesFA)
    info = dicominfo(fullfile(path, slicesFA(i).name));
    if info.SliceLocation > sliceLocation
      break
    end
    idxHigherSlice = idxHigherSlice + 1;
    clear slice
  end

  % if no corresponding FA
  if idxHigherSlice > numel(slicesFA) | numel(slicesFA) < 1 | idxHigherSlice==1
    img = -1;
    return;
  end

  fname1 = fullfile(path, slicesFA(idxHigherSlice-1).name);
  s1 = dicomread(fname1);
  info1 = dicominfo(fname1);
  h1 = info1.SliceLocation;

  fname2 = fullfile(path, slicesFA(idxHigherSlice).name);
  s2 = dicomread(fname2);
  info2 = dicominfo(fname2);
  h2 = info2.SliceLocation;

  % Interpolate target slice
  img = interpolateSlice(s1, s2, h1, h2, sliceLocation);

  % Scale to height, width
  img = imresize(img, [height, width]);
end
