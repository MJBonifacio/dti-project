function [Xs, Ys] = extractSlicePatches(img, infarctMask, )
% extract patches
% for each mask
for i=1:length(study_data)
    for slice=1:numel(study_data{i}.slices)

        % load mask and find points in the infarcted region
        current_mask = study_data{i}.mask{slice};
        [pty, ptx] = find(current_mask > 0);
        % points in the format of [row, col]

        Ys = zeros(1,numel(pty));
        for j=1:numel(pty)
            Ys(j) = current_mask(pty(j), ptx(j)) - 1;
  % QUESTION: wouldn't these all just end up as 0 since the mask is binary?
        end

        Ys = logical(Ys);
        infarctedPty = pty(Ys);
        infarctedPtx = ptx(Ys);

        normalPty = pty(~Ys);
        normalPtx = ptx(~Ys);

        nbSamplPerCase = min(nnz(Ys), nbSamplPerCaseMax);

        rand('seed', 0);
        indxInfa = randperm(length(infarctedPty), nbSamplPerCase);

        rand('seed', 0);
        indxNorm = randperm(length(normalPty), nbSamplPerCase);

        Y2 = [ones(1,nbSamplPerCase,1) zeros(1,nbSamplPerCase,1)];

        pty2 = [infarctedPty(indxInfa(1:nbSamplPerCase))' normalPty(indxNorm(1:(nbSamplPerCase)))' ]';
        ptx2 = [infarctedPtx(indxInfa(1:nbSamplPerCase))' normalPtx(indxNorm(1:(nbSamplPerCase)))' ]';

        im1 = squeeze(study_data{i}.corresponding_images{slice});
        im1(im1<0) = 0;
        im1 = im1 ./ max(im1(:));

        cb1 = extractCuboidNoReshape(im1,  pty2, ptx2, winSize);

        X1{i} = cat(3, X1{i}, cb1);
        Y{patient} = Y2;

        clear cb1 cb2 cb Y2 tmp1 tmp2 im1 pty2 ptx2 Ys;
        break;
    end
end

end
