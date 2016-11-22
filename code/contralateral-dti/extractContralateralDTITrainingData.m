function trainingData = extractContralateralDTITrainingData()
  maskDir = '../../masks';
  dataRoot = '../../mat_data';
  rand('seed', 0);

  masks = dir(fullfile(maskDir, '*.mat'));
  infarctedSlices = selectInfarctedSlices();
  trainingData = cell(numel(masks), 1);

  for study=1:numel(masks)
    if isempty(infarctedSlices{study})
      continue
    end

    maskFilename = fullfile(maskDir, masks(study).name);
    [pathstr,name,ext] = fileparts(maskFilename);
    load(maskFilename, 'mask', 'uslices');
    trainingData{study} = cell(numel(uslices), 1);
    studyPath = fullfile(dataRoot, name, 'ADC')

    trainingData{study} = cell(1, numel(uslices));

    for sliceNum=1:numel(uslices)
      % load ADC image
      load(infarctedSlices{study}{sliceNum}, 'slice');
      infarctADC = slice.image;
      targetHeight = slice.SliceLocation;
      maskADC = mask{sliceNum};

      % calculate slice tranformation of that image
      [angle, translation] = computeSliceTransformation(infarctADC);

      % Choose and interpolate appropriate DTI slice
      pathDTI = fullfile(dataRoot, name, 'DTI');
      img = selectCorrespondingDTI(pathDTI, targetHeight, slice.Height, slice.Width);

      if img == -1 % Check if no corresponding DTI exists
        disp(study);
        disp(sliceNum)
        continue;
      end

      transformedSlice = imtranslate(imrotate(img, -1*angle),  [0, -1*translation]);
      transformedMask = imtranslate(imrotate(maskADC, -1*angle),  [0, -1*translation]);

      % extract contralateral training data
      [Xs, Ys] = extractSlicePatches(transformedSlice, transformedMask);
      trainingData{study}{sliceNum} = struct('X', Xs, 'Y', Ys)

      clear slice
    end

    clear mask ulices
  end
end
