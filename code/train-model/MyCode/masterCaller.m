function masterCaller()

dirnameRoc = '../roc';
dirnameSR = '../SR';
fnameTrainingSet = '../vectorizedTrainingSet.mat';
patchesToTrain = 3000;

addpath(dirnameRoc,dirnameSR);
load(fnameTrainingSet, 'patchOffsets', 'patchCounts', 'setX', 'setY');

%Randomize patients
numPatients = length(patchOffsets);
randIndex = randperm(numPatients);
totalYhat = [];
Ytruth = [];

%leave-one-out cross-validation
for j = 1 : numPatients
    j
    [Xtest, localYtruth, Xtrain, Ytrain] = leaveOneOut(randIndex(j), patchOffsets, patchCounts, setX, setY);

    beginPatch = 1;
    endPatch = patchesToTrain;
    numPatches = length(Xtrain);

    Yhat = [];

    %Produce Yhat vector for ROC evaluation
    while endPatch < numPatches
      beginPatch
      endPatch
      numPatches
      % localXtest = Xtest(beginPatch:endPatch);
      localXtrain = Xtrain(beginPatch:endPatch);
      localYtrain = Ytrain(beginPatch:endPatch);
      % Yhat = [Yhat; callKSR(localXtest, localXtrain, localYtrain)];
      Yhat = [Yhat; callKSR(Xtest, localXtrain, localYtrain)];

      beginPatch = endPatch + 1;
      endPatch = endPatch + 1 + patchesToTrain;
    end

    endPatch = numPatches;
    % localXtest = Xtest(beginPatch:endPatch);
    localXtrain = Xtrain(beginPatch:endPatch);
    localYtrain = Ytrain(beginPatch:endPatch);
    % Yhat = [Yhat; callKSR(localXtest, localXtrain, localYtrain)];
    Yhat = [Yhat; callKSR(Xtest, localXtrain, localYtrain)];

    Yhat = callKSR(Xtest, Xtrain, Ytrain);
    totalYhat = [totalYhat; Yhat];
    Ytruth = [Ytruth; localYtruth];
end

[Xeval, Yeval] = perfcurve(Ytruth, totalYhat,1);
plot(Xeval,Yeval);
xlabel('False positive rate'); ylabel('True positive rate');
title('ROC for classification by spectral regression');
