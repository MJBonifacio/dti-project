function masterCaller()

dirnameRoc = '../roc';
dirnameSR = '../SR';
fnameTrainingSet = '../reducedTrainingSet.mat';

addpath(dirnameRoc,dirnameSR);
load(fnameTrainingSet, 'offsets', 'counts', 'x', 'y');

%Randomize patients
numPatients = length(offsets);
randIndex = randperm(numPatients);
totalYhat = [];
Ytruth = [];

%leave-one-out cross-validation
for j = 1 : numPatients
    j
    [Xtest, localYtruth, Xtrain, Ytrain] = leaveOneOut(randIndex(j), offsets, counts, x, y);

    Yhat = callKSR(Xtest, Xtrain, Ytrain);
    totalYhat = [totalYhat; Yhat];
    Ytruth = [Ytruth; localYtruth];
end

save('results.mat', 'Ytruth', 'totalYhat');
[Xeval, Yeval] = perfcurve(Ytruth, totalYhat,1);
plot(Xeval,Yeval);
xlabel('False positive rate'); ylabel('True positive rate');
title('ROC for classification by spectral regression');
