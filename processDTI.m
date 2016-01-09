function processDTI()
%two steps
	%1) For each case, for each infarcted slice, find the closest processDTI
	%2) For each selected DTI, find its brain transformation

%path constants
    rootData = './data';
    maskDir = './data/masks';
    ADCtransDir = './data/transformationsADC';
    destDir = './data/transformationsDTI';

%load data
    listDirs = dir(rootData);
    numCases = size(listDirs,1);

for i = 1:numCases %numloops == numstudies
    
    if ~listDirs(i).isdir || strcmp(listDirs(i).name,'.') || strcmp(listDirs(i).name,'..') || strcmp(listDirs(i).name,'masks') || strcmp(listDirs(i).name,'transformationsADC') || strcmp(listDirs(i).name,'transformationsDTI')
        continue
    end

    studyNumber = listDirs(i).name;

    pathDTI = fullfile(rootData,studyNumber,'DTI');
    listDTI = dir(fullfile(pathDTI,'*.dcm'));

    %sample image for preallocation
    tmpDTIfname = fullfile(pathDTI,listDTI(1).name);
    tmpDTIinfo = dicominfo(tmpDTIfname);
	sizeDTI = size(uint8(dicomread(tmpDTIfname)));

	%preallocation
	listInfoDTI = repmat(tmpDTIinfo,numel(listDTI),1);

	%store DTI info
	for j = 1:numel(listDTI)
		fnameSlice = fullfile(pathDTI,listDTI(j).name);
		listInfoDTI(j) = dicominfo(fnameSlice);
	end

	%load data from ADC calculations 
	fnameADCparams = fullfile(ADCtransDir,strcat(studyNumber,'.mat'));
	load(fnameADCparams); %listInfoADC, listSliceTransformationsADC, sizeADC

	numSlices = numel(listInfoADC);
	listImagesDTI = cell(numSlices,1);

	%match closest DTI slices based on ADC.SliceLocation
	matchedSlicesDTI = zeros(numSlices,1);
	DTISliceNumber = 1;
	heightADC = listInfoADC(1).Height;
	heightDTI = listInfoDTI(1).Height;
	scaleFactor = heightADC/heightDTI;

	selectedInfoDTI = repmat(tmpDTIinfo,numSlices,1);

	for j = 1:numSlices
		sliceLocToMatch = listInfoADC(j).SliceLocation;

		if DTISliceNumber < numel(listDTI)
			%slice heights increase as filenames increase, going up the head
			%match by going to first DTI slice higher than ADC height, then choosing the slice with
			%the shortest distance to the ADC slice between that DTI and the one right below it

			while sliceLocToMatch > listInfoDTI(DTISliceNumber).SliceLocation
				DTISliceNumber = DTISliceNumber + 1;
			end

			if eq(DTISliceNumber,1)
				listImagesDTI{j} = uint8(dicomread(listInfoDTI(DTISliceNumber).Filename));
			else
				sliceLoc2 = listInfoDTI(DTISliceNumber).SliceLocation;
				sliceLoc1 = listInfoDTI(DTISliceNumber - 1).SliceLocation;

				twoIsCloser = true;

				two = (sliceLoc2 - sliceLocToMatch) < (sliceLocToMatch - sliceLoc1);

				if two
					listImagesDTI{j} = uint8(dicomread(listInfoDTI(DTISliceNumber).Filename));
				else
					listImagesDTI{j} = uint8(dicomread(listInfoDTI(DTISliceNumber - 1).Filename));
				end
			end
		else %assumed to only be true for the last slice
			listImagesDTI{j} = uint8(dicomread(listInfoDTI(DTISliceNumber).Filename));
		end

		matchedSlicesDTI(j,1) = DTISliceNumber;
		selectedInfoDTI(j) = dicominfo(listInfoDTI(DTISliceNumber).Filename);
	end


	fnameTransformation = fullfile(destDir,strcat(studyNumber,'.mat'));
    save(fnameTransformation,'matchedSlicesDTI','selectedInfoDTI');	
	
	clear matchedSlicesDTI listInfoDTI
end