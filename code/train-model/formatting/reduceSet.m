function reducedSet()
  load('normalizedTrainingSet.mat', 'setY', 'setX', 'patchOffsets', 'patchCounts');

% Options
  reducedFname = 'reducedTrainingSet.mat';
  maxPatchesPerPatient = 100;

% Paramters from loaded data
  numPatients = length(patchOffsets);

  y = [];
  x = [];
  offsets = [];
  counts = [];
  precedingPatches = 0;

  rand('seed', 0);

  for i=1:numPatients
    beginPatch = patchOffsets(i) + 1;
    endPatch = patchOffsets(i) + patchCounts(i);
    localSetY = setY(beginPatch:endPatch);
    localSetX = setX(beginPatch:endPatch,:);

    numPatchesToSave = min(maxPatchesPerPatient, patchCounts(i));
    offsets = [offsets; precedingPatches];
    counts = [counts; numPatchesToSave];
    precedingPatches = precedingPatches + numPatchesToSave;

    normCases = randperm(numPatchesToSave/2);
    normIdx = find(localSetY < 1);
    normIdx = normIdx(normCases);

    infaCases = randperm(numPatchesToSave/2);
    infaIdx = find(localSetY > 0);
    infaIdx = infaIdx(infaCases);

    y = [y; setY(normIdx); setY(infaIdx)];
    x = [x; setX(normIdx,:); setX(infaIdx,:)];
  end

  save(reducedFname, 'x', 'y', 'offsets', 'counts');
end
