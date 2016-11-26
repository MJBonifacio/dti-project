function [Xmatrix, Ymatrix] = callCreateXYMatrix(numPatients, desiredPoints)

%intialize matrices
    Xmatrix = [];
    Ymatrix = [];
   
%add each patient to the matrix
%this Xmatrix and Ymatrix will then be split into test and training data

for i = 1 : numPatients,
    [X, Y] = createXYmatrix(i, desiredPoints);
    Xmatrix = [Xmatrix; X];
    Ymatrix = [Ymatrix; Y];
end