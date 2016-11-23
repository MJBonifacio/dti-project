function infarcts = selectInfarctedSlices()

maskDir = '../../masks';
dataRoot = '../../mat_data';

masks = dir(fullfile(maskDir, '*.mat'));
infarcts = cell(numel(masks), 1);

for i=1:numel(masks)
  maskFilename = fullfile(maskDir, masks(i).name);
  [pathstr,name,ext] = fileparts(maskFilename);
  studyNumber = name;
  studyPath = fullfile(dataRoot, studyNumber, 'ADC');

  if ~exist(studyPath, 'dir')
    continue
  end

% Load ADC ROI masks
  load(maskFilename, 'mask', 'uslices');
  slices = dir(fullfile(studyPath, '*.mat'));
  infarctedSlices = cell(1, numel(uslices));

  for j=1:numel(uslices)
    infarctedSlice = slices(uslices(j));
    infarctedSlices{j} = fullfile(studyPath, infarctedSlice.name);
  end

  infarcts{i} = infarctedSlices;

  clear mask uslices infarctedSlices
end
