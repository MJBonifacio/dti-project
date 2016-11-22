function infarcts = selectInfarctedSlices()

maskDir = '../../masks';
dataRoot = '../../mat_data';

masks = dir(fullfile(maskDir, '*.mat'));
infarcts = cell(numel(masks), 1);

for i=1:numel(masks)
  maskFilename = fullfile(maskDir, masks(i).name);
  [pathstr,name,ext] = fileparts(maskFilename);
  studyNumber = name;
  studyPath = fullfile(dataRoot, name, 'ADC');

  if ~exist(studyPath, 'dir')
    continue
  end

% Load ADC ROI masks. They will include "mask" and "uslices" variables
  load(maskFilename);
  slices = dir(fullfile(studyPath, '*.mat'));
  infarctedSlices = cell(numel(uslices), 1);

  for j=1:numel(uslices)
    infarctedSlice = slices(uslices(j));
    infarctedSlices{j} = fullfile(studyPath, infarctedSlice.name);
  end

  infarcts{i} = infarctedSlices;

  clear mask uslices infarctedSlices
end
