function performTrainingDataExtraction()

winSize = 11;
nbSamplPerCaseMax = 100;

rootCSV = '../Data/t2/';
maskDir = '../Data/t2/masks/';
destDirPatches = '../Data/t2/';

listMasksName = dir(strcat(destDir, '*.mat'));
for i=1:length(listMasksName)
    fnameMask = strcat(destDir, listMasksName(i).name);

    % read mask
    load(fnameMask, 'mask', 'uslices');
    data{i}.mask = mask;
    data{i}.slices = uslices;

    % read dicom
    listDicom = subdir(strcat(rootCSV, num2str(i), '/*.dcm'));
    for j=1:numel(uslices)
        fname = listDicom(uslices(j)).name;
        data{i}.X{j} = dicomread(fname);
    end
end

X1 = {};

% extract patches
for i=1:length(data)
    for slice=1:numel(data{i}.slices)

        tmp = data{i}.mask{slice};
        [pty, ptx] = find(tmp > 0);

        Ys = zeros(1,numel(pty));
        for j=1:numel(pty)
            Ys(j) = tmp(pty(j), ptx(j)) - 1;
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

        im1 = squeeze(data{i}.X{slice});
        im1(im1<0) = 0;
        im1 = im1 ./ max(im1(:));

        cb1 = extractCuboidNoReshape(im1,  pty2, ptx2, winSize);

        X1{i} = cat(3, X1{i}, cb1);
        Y{patient} = Y2;

        clear cb1 cb2 cb Y2 tmp1 tmp2 im1 pty2 ptx2 Ys;
        break;
    end
end

save(sprintf('%s/trainingSet%d.mat', destDirPatches, winSize), 'X', 'Y');
