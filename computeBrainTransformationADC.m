function computeBrainTransformationADC()
%takes set of brain images and computes two parameters:
%   1) rotation angle to vertical orientation
%       -using 1/2 angle of max normxcorr2 between brain and its reflection
%   2) # of pixels of translation necessary to maximize vertical correlation

%path constants
    rootData = './data';
    maskDir = './data/masks';
    destDir = './data/transformationsADC'; 


%load data
    listDirs = dir(rootData);
    numCases = size(listDirs,1);
    
for i = 1:numCases %numloops == numstudies
    
    if ~listDirs(i).isdir || strcmp(listDirs(i).name,'.') || strcmp(listDirs(i).name,'..') || strcmp(listDirs(i).name,'masks') || strcmp(listDirs(i).name,'transformationsADC') || strcmp(listDirs(i).name,'transformationsDTI')
        continue
    end
    
    studyNumber = listDirs(i).name;
    tempVars = fullfile(maskDir,strcat(studyNumber,'.mat'));
    load(tempVars); %mask and uslices

    pathADC = fullfile(rootData,studyNumber,'ADC');
    listADC = dir(fullfile(pathADC,'*.dcm'));

%load ADC images + data for those slices
    %used to determine amount of money to preallocate
    tmpADCfname = fullfile(pathADC,listADC(1).name);
    tmpADCinfo = dicominfo(tmpADCfname);
        
    sizeADC = size(uint8(dicomread(tmpADCfname)));
    listImagesADC = cell(numel(uslices),1);
    listInfoADC = repmat(tmpADCinfo,numel(uslices),1);
    listSliceTransformationsADC = zeros(numel(uslices),2,1);
        
    for j = 1:numel(uslices)
        fnameSlice = fullfile(pathADC,listADC(uslices(j)).name);
        listImagesADC{j} = uint8(dicomread(fnameSlice));
        listInfoADC(j) = dicominfo(fnameSlice);

        [tmpAngle tmpTrans] = computeSliceTransformation(listImagesADC{j});
        listSliceTransformationsADC(j,1,1) = tmpAngle;
        listSliceTransformationsADC(j,2,1) = tmpTrans;
    end
    
    fnameTransformation = fullfile(destDir,strcat(studyNumber,'.mat'));
    save(fnameTransformation,'listInfoADC','listSliceTransformationsADC','sizeADC');

%    pathDTI = fullfile(rootData,studyNumber,'DTI');
%    listDTI = dir(fullfile(pathDTI,'*.dcm'));
    
%load DTI for this study for reference/comparisons
    %preallocate cell/struct arrays
    %    tmpDTIfname = fullfile(pathDTI,listDTI(1).name);
    %    tmpDTIinfo = dicominfo(tmpDTIfname);
        
    %    numAllDTI = size(listDTI,1);
    %    sizeDTI = size(dicomread(tmpDTIfname));
    %    allImagesDTI = cell(numAllDTI, 1);
    %    allInfoDTI = repmat(tmpDTIinfo, numAllDTI, 1);

    %load all DTI/info to reference
    %    for j = 1:numAllDTI
    %        fnameSlice = fullfile(pathDTI,listDTI(j).name);
    %        allImagesDTI{j} = dicomread(fnameSlice);
    %        allInfoDTI(j) = dicominfo(fnameSlice);
    %    end          

    
    %compute DTI slices by closest slice location
        %listSlicesDTI = cell(numel(uslices),1);
        %for j = 1:numel(uslices)
        %    location = listInfoADC(j).SliceLocation;
        %end
end
end