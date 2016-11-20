function extractContralateralADCtrainingData()    

	winSize = 11;
	nbPatchPerSliceMax = 100;

    rootData = './data';
    maskDir = './data/masks';
    dirTransformationsADC = './data/transformationsADC';
    destDirPatches = './patchesContralateralADC'; 

    listMasksName = dir(fullfile(maskDir,'*.mat'));
    listTransName = dir(fullfile(dirTransformationsADC,'*.mat'));
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

   			sliceMask = data{i}.mask{slice};
   			originalSlice = data{i}.images{slice};
   			trans = data{i}.sliceTrans{slice};

   			rotMask = imrotate(sliceMask,trans(1,1));
   			[infarctedPty, infarctedPtx] = find(rotMask > 0);
            
            %reflected over vertical midline, height is identical
            normalPty = infarctedPty;
            
            %contralateral region is equidistant to vertical midline
            imageWidth = listInfoADC(slice).Width;
            centerX = round(imageWidth/2);
            distances = centerX - infarctedPtx;
            normalPtx = centerX + distances;

   			nbPatchPerSlice = min(nnz(infarctedPty),nbPatchPerSliceMax);

   			rand('seed',0); 
   			indexInfarcted = randperm(numel(infarctedPty),nbPatchPerSlice);
            
            rand('seed',0);
            indexNormal = randperm(length(normalPty, nbPatchPerSlice));
            
            pty2 = [infarctedPty(indexInfarcted(1:nbPatchPerSlice))' normalPty(indexNormal(1:nbPatchPerSlice))']';
            ptx2 = [infarctedPtx(indexInfarcted(1:nbPatchPerSlice))' normalPtx(indexNormal(1:nbPatchPerSlice))']';
            
            %TODO: figure out cuboid extraction (updated code will be at
            %https://github.com/mjbonifacio/dti-project)
   		end
   end
end