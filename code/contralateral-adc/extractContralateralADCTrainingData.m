function trainingData = extractContralateralADCTrainingData()
  maskDir = '../../masks';
  dataRoot = '../../mat_data';

  masks = dir(fullfile(maskDir, '*.mat'));
  infarctedSlices = selectInfarctedSlices();
  trainingData = cell(numel(masks), 1);

  for study=1:numel(masks)
    if isempty(infarctedSlices{study})
      continue
    end

    maskFilename = fullfile(maskDir, masks(i).name);
    [pathstr,name,ext] = fileparts(maskFilename);
    load(maskFilename);
    trainingData{study} = cell(numel(uslices), 1);
    studyPath = fullfile(dataRoot, name, 'ADC')

    for slice=1:numel(uslices)
      % load ADC image
      load(infarctedSlices{study}{slice});
      img = slice.image
      % calculate slicetranformation of that image
      [angle, translation] = computeSliceTransformation(img);

      % Choose and interpolate appropriate DTI slice
      trasformedSlice = imrotate(imtranslate(img, [0, -1*translation]), -1*angle)
      % extract contralateral training data
    end
  end
end
