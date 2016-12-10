function [Xs, Ys, numPatches] = extactStudyPatches(mask, uslices, pathFA, studyIndex, adcInfarcts)
  maxPatches = 150;
  numPatches = 0;

  xPatches = [];
  yPatches = [];
  % patchCounts = [];

  for sliceNum=1:numel(uslices)
    % load ADC image
    load(adcInfarcts{studyIndex}{sliceNum}, 'slice');
    infarctADC = slice.image;
    targetHeight = slice.SliceLocation;
    maskADC = mask{sliceNum};

    % calculate slice tranformation of that image
    [angle, translation] = computeSliceTransformation(infarctADC);

    % Choose and interpolate appropriate FA slice
    img = selectCorrespondingFA(pathFA, targetHeight, slice.Height, slice.Width);

    if img == -1 % Check if no corresponding FA exists
      disp(studyIndex);
      disp(sliceNum);
      continue;
    end

    transformedSlice = imtranslate(imrotate(img, angle),  [0, translation]);
    transformedMask = imtranslate(imrotate(maskADC, angle),  [0, translation]);

    % extract contralateral training data
    [sliceX, sliceY, patchCounts] = extractSlicePatches(transformedSlice, transformedMask);
    xPatches = [xPatches; sliceX];
    yPatches = [yPatches; sliceY];
    % patchCounts = [patchCounts; patchCounts];
    clear slice
  end

% Reduce number of patches sampled
  % patchOffsets = computeOffsets(patchCounts);
  sampledPatches = numel(yPatches);
  numPatches = min(sampledPatches, maxPatches);
  rp = randperm(sampledPatches);
  selectedIndx = rp(1:numPatches);

  Xs = xPatches(selectedIndx,:);
  Ys = yPatches(selectedIndx);
end
