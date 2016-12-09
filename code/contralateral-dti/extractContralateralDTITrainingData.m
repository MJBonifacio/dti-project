function [X, Y, counts, offsets] = extractContralateralDTITrainingData()
  maskDir = '../../masks';
  dataRoot = '../../mat_data';
  FARoot = '../../FA_data';
  rand('seed', 0);

  trainingDataFname = 'trainingData.mat';

  masks = dir(fullfile(maskDir, '*.mat'));
  infarctedSlices = selectInfarctedSlices();
  X = [];
  Y = [];
  counts = [];

  for study=1:numel(masks)
    if isempty(infarctedSlices{study})
      continue
    end

    maskFilename = fullfile(maskDir, masks(study).name);
    [pathstr,name,ext] = fileparts(maskFilename);
    load(maskFilename, 'mask', 'uslices');
    studyPath = fullfile(dataRoot, name, 'ADC')

    pathFA = fullfile(FARoot, name);
    if ~exist(pathFA, 'dir')
      continue
    end
    [studyX, studyY, numPatches] = extractStudyPatches(mask, uslices, pathFA, study, infarctedSlices);

    X = [X; studyX];
    Y = [Y; studyY];
    counts = [counts; numPatches];
    clear mask ulices
  end

  offsets = computeOffsets(counts);
  save(trainingDataFname, 'X', 'Y', 'counts', 'offsets');
end
