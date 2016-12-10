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
    caseOffset = patchOffsets(i);
    beginPatch = caseOffset + 1;
    endPatch = caseOffset + patchCounts(i);
    localSetY = setY(beginPatch:endPatch);
    localSetX = setX(beginPatch:endPatch,:);

    patchesInStudy = patchCounts(i);
    numPatchesToSave = min(maxPatchesPerPatient, patchesInStudy);
    offsets = [offsets; precedingPatches];
    counts = [counts; numPatchesToSave];
    precedingPatches = precedingPatches + numPatchesToSave;

    normPatchesIdx = find(localSetY < 1);
    normCases = randperm(length(normPatchesIdx));
    normIdx = normPatchesIdx(normCases(1:numPatchesToSave/2));
    normIdx = normIdx + caseOffset;

    infaPatchesIdx = find(localSetY > 0);
    infaCases = randperm(length(infaPatchesIdx));
    infaIdx = infaPatchesIdx(infaCases(1:numPatchesToSave/2));
    infaIdx = infaIdx + caseOffset;

    y = [y; setY(normIdx); setY(infaIdx)];
    x = [x; setX(normIdx,:); setX(infaIdx,:)];
  end

  save(reducedFname, 'x', 'y', 'offsets', 'counts');
end
