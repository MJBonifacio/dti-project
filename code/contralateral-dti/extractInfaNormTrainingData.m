function [X, Y, counts, offsets] = extractInfaNormTrainingData()
  maskDir = '../../masks';
  dataRoot = '../../mat_data';
  FARoot = '../../FA_data';
  rand('seed', 0);

  trainingDataFname = 'infaNormTrainingData.mat';

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
    [studyX, studyY, numPatches] = extractInfaNormStudyPatches(mask, uslices, pathFA, study, infarctedSlices);

    size(X)
    size(studyX)
    X = [X; studyX];
    Y = [Y; studyY];
    counts = [counts; numPatches];
    clear mask ulices
  end

  offsets = computeOffsets(counts);
  save(trainingDataFname, 'X', 'Y', 'counts', 'offsets');
end
