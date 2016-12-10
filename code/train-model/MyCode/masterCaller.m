function masterCaller()

dirnameRoc = '../roc';
dirnameSR = '../SR';
fnameTrainingSet = 'infaNormTrainingData.mat';

addpath(dirnameRoc,dirnameSR);
load(fnameTrainingSet, 'offsets', 'counts', 'X', 'Y');

%Randomize patients
numPatients = length(offsets);
randIndex = randperm(numPatients);
totalYhat = [];
Ytruth = [];

X = standardizeX(X);

%leave-one-out cross-validation
for j = 1 : numPatients
    j
    [Xtest, localYtruth, Xtrain, Ytrain] = leaveOneOut(randIndex(j), offsets, counts, X, Y);

    Yhat = callKSR(Xtest, Xtrain, Ytrain);
    totalYhat = [totalYhat; Yhat];
    Ytruth = [Ytruth; localYtruth];
end

save('infaNormResults.mat', 'Ytruth', 'totalYhat');
[Yeval, Xeval] = roc(Ytruth, totalYhat);
plot(Xeval,Yeval);
xlabel('False positive rate'); ylabel('True positive rate');
title('ROC for classification by spectral regression');
