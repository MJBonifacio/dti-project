function masterCaller()

dirnameRoc = '../roc';
dirnameSR = '../SR';
fnameTrainingSet = '../vectorizedTrainingSet.mat';

addpath(dirnameRoc,dirnameSR);
load(fnameTrainingSet, 'patchOffsets', 'patchCounts', 'setX', 'setY');

%Randomize patients
numPatients = length(patchOffsets);
randIndex = randperm(numPatients);
totalYhat = [];
Ytruth = [];

%leave-one-out cross-validation
for j = 1 : numPatients
    [Xtest, localYtruth, Xtrain, Ytrain] = leaveOneOut(randIndex(j), patchOffsets, patchCounts, setX, setY);

    %Produce Yhat vector for ROC evaluation
    Yhat = callKSR(Xtest, Xtrain, Ytrain);
    totalYhat = [totalYhat; Yhat];
    Ytruth = [Ytruth; localYtruth];
end

[Yeval, Xeval] = roc(Ytruth, totalYhat);
plot(Xeval,Yeval);
xlabel('False positive rate'); ylabel('True positive rate');
title('ROC for classification by spectral regression');
