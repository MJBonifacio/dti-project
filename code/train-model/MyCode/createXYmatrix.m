%This function, createXYmatrix, takes in as input:
%1. a specified number (num) of AIF files in a given location 
%2. the number of desired points (desiredPoints) from the masked and unmasked regions.

%In this function, the specified AIF file and its mask are taken and used to 
%retrieve random points from within the mask and non-mask regions. The
%values of these coordinates across all 20 frames of the given AIF's X file
%are then stored into a vector and mapped to a corresponding Y value (1 if
%the point lies inside the mask and 0 if the point lies outside of the mask)

%This function returns, as output, 

function [Xvector, Yvector] = createXYmatrix(num, desiredPoints)

totalPoints = desiredPoints.*2;

%initialize mask name
maskname = ['C:\matlab\Angiograms\aif_',num2str(num),'\mask2.png'];
aifname = ['F:\AngioAIF\aif_',num2str(num),'.mat'];

%load mask and locate all points that lie within the mask (row1, col1) and
%outside of the mask (row0, col0)
mask = imread(maskname);
greymask = rgb2gray(mask);
[row1,col1] = find(greymask);          
[row0,col0] = find(~greymask);
maxsize0 = size(row0, 1);
maxsize1 = size(row1, 1);

%randomly arrange numbers to randomize point selection in both masked and
%unmasked regions
index1 = randperm(maxsize1);
index0 = randperm(maxsize0);
load(aifname);

%grab the (X, Y) coordinates of your desired amount of points from both the
%masked and unmasked regions
idxList1 = index1(1:desiredPoints);
coordX1 = col1(idxList1);
coordY1 = row1(idxList1);

idxList0 = index0(1:desiredPoints);
coordX0 = col0(idxList0);
coordY0 = row0(idxList0);

%generate the matrix used to store all X values
Xvector = zeros(totalPoints,20);

%for every AIF, iterate through the 20 frames of X and store the values at
%the specified (X,Y) coord into the matrix created above
for j = 1:desiredPoints,
    Xvector(j,1:20) = X(coordY1(j), coordX1(j), 1:20);
end


%repeat for unmasked section
for k = 1:desiredPoints,
    curPos = desiredPoints + k;
    Xvector(curPos,1:20) = X(coordY0(k), coordX0(k), 1:20);
end

%set up the (2*desiredPoints x 1) matrix for all Y values (1s or 0s)
Yvector1 = ones(desiredPoints,1);
Yvector0 = zeros(desiredPoints, 1);
Yvector = [Yvector1; Yvector0];

