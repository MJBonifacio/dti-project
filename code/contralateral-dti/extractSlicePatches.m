function [Xs, Ys] = extractSlicePatches(img, infarctMask)
% TODO: Account for the case when contralateral voxels are infarcted
    nbSamplPerCaseMax = 100;
    winSize = 11;

    % find points[row,col] in the infarcted region
    [infarctedPty, infarctedPtx] = find(infarctMask > 0);
    nbSamplPerCase = min(nnz(infarctedPty), nbSamplPerCaseMax);
    nbPatches = 2*nbSamplPerCase;

    indxInfa = randperm(length(infarctedPty));
    indxInfa = indxInfa(1:nbSamplPerCase);

    flippedImage = flipDim(img, 2);

    Xs = cell(1, nbPatches);
    Ys = zeros(1, nbPatches);

    for i=1:nbSamplPerCase
      y = infarctedPty(indxInfa(i));
      x = infarctedPtx(indxInfa(i));

      cbInfa = extractCuboid(img, y, x, winSize);
      cbNorm = flipdim(extractCuboid(flippedImage, y, x, winSize), 2);

      Ys(i) = 1;
      Xs{i} = cbInfa;

      Ys(nbPatches + 1 - i) = 0;
      Xs{nbPatches + 1 - i} = cbNorm;
    end
end
