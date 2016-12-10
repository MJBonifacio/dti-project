function cleanData()
  fname = 'trainingSet.mat';
  load(fname, 'trainingData');

  for studyNum = 1:length(trainingData)
    for sliceNum = 1:length(trainingData{studyNum})
      studyNum
      sliceNum
      numPatches = length(trainingData{studyNum}{sliceNum});

      Y = [ones(1, numPatches/2) zeros(1, numPatches/2)];

      for patchNum = 1:numPatches
        trainingData{studyNum}{sliceNum}(patchNum).Y = Y(patchNum);
      end

      clear Y
    end
  end

  save(fname, 'trainingData');
end
