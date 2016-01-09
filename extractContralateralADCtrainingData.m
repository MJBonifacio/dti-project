function extractContralateralADCtrainingData()    

	winsize = 11
	nbPatchPerSliceMax = 100

    rootData = './data';
    maskDir = './data/masks';
    dirTransformationsADC = './data/transformationsADC';
    destDirPatches = './data/patchesContralateralADC'; 

    listMasksName = dir(fullfile(maskDir,'*.mat'));
    listTransName = dir(fullfile(dirTransformationsADC,'*.mat'))
    for i = 1:length(listMasksName)
    	fnameMask = fullfile(maskDir,listMasksName(i).name);
    	fnameTrans = fullfile(dirTransformationsADC,listTransName(i).name);

    	load(fnameMask, 'mask');
    	data{i}.mask = mask;

    	load(fnameTrans,'listInfoADC','listSliceTransformationsADC');
    	for j = 1:numel(listInfoADC)
    		fname = listInfoADC(j).name;
    		data{i}.sliceTrans{j} = listSliceTransformationsADC(j,:,:);
    		data{i}.images{j} = dicomread(fname);
    	end
    end

    %extract patches
   for i = 1:length(data)
   		for slice = 1:numel(data{i}.images)

   			sliceMask = data{i}.mask(slice);
   			originalSlice = data{i}.images{slice};
   			trans = data{i}.sliceTrans{slice};

   			rotMask = imrotate(sliceMask,trans(1,1));
   			[infarctedPty,infarctedPtx] = find(rotMask > 0);

   			nbPatchPerSlice = min(nnz(infarctedPty),nbPatchPerSliceMax);

   			rand('seed',0)
   			indicesToSample = randperm(numel(infarctedPty),nbPatchPerSlice);

   			patchesInfarcted = []
   			patchesNormal = 

   		end
   end
end