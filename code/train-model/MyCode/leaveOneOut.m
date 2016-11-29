function [Xtest, Ytruth, Xtrain, Ytrain] = leaveOneOut(excludedPatient, patchOffsets, patchCounts, setX, setY)

% Calculate constants used for exclusion
  numPatches = patchCounts(excludedPatient);
  beginExcluded = patchOffsets(excludedPatient) + 1;
  lastExcluded = beginExcluded + numPatches - 1;
  numCases = length(patchOffsets);
  totalPatches = patchOffsets(numCases) + patchCounts(numCases);

% Initialize Output Variables
  Xtest = [];
  Ytruth = [];
  Xtrain = [];
  Ytrain = [];

% Partition test vector
  Xtest = setX(beginExcluded:lastExcluded,:);
  Ytruth = setY(beginExcluded:lastExcluded);

% Fill training vectors
  if excludedPatient > 1
    lastBefore = patchOffsets(excludedPatient);
    Xtrain = [Xtrain; setX(1:lastBefore,:)];
    Ytrain = [Ytrain; setY(1:lastBefore)];
  end
  if excludedPatient < numCases
    firstAfter = lastExcluded + 1;
    Xtrain = [Xtrain; setX(firstAfter:totalPatches,:)];
    Ytrain = [Ytrain; setY(firstAfter:totalPatches)];
  end
end
