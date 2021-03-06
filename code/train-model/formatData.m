function formatData()
  trainingFname = 'trainingSet.mat';
  formattedFname = 'formattedTrainingSet.mat';
  load(trainingFname, 'trainingData');

  patchOffsets = [];
  patchCounts = [];
  setX = [];
  setY = [];
  precedingPatches = 0;

  for studyNum=1:length(trainingData)
    patchOffsets = [patchOffsets precedingPatches];
    patchesPerPatient = 0;
    studyY = [];

    for sliceNum=1:length(trainingData{studyNum})
      numPatchesSlice = length(trainingData{studyNum}{sliceNum});
      patchesPerPatient = patchesPerPatient + numPatchesSlice;
      precedingPatches = precedingPatches + numPatchesSlice;

      for patchNum=1:numPatchesSlice
        studyY = [studyY trainingData{studyNum}{sliceNum}(patchNum).Y];
      end
    end
    patchCounts = [patchCounts patchesPerPatient];
    setY = [setY studyY];
  end

  setX = cell(1,precedingPatches);
  patchIdx = 1;

  for studyNum = 1:length(trainingData)
    numSlices = length(trainingData{studyNum});
    for sliceNum=1:numSlices
      for patchNum=1:length(trainingData{studyNum}{sliceNum})
        setX{patchIdx} = trainingData{studyNum}{sliceNum}(patchNum).X;
        patchIdx = patchIdx + 1;
      end
    end
  end

  save(formattedFname, 'patchOffsets', 'patchCounts','setX', 'setY');
end
