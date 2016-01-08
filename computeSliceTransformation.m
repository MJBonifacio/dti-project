function [angle,translation] = computeSliceTransformation(image)
%takes an 8 bit scan, computes angle needed to rotate and translate image
%to maximize correlation over vertical midline reflection

%constants
angleRange = 61;
pixelRange = 41;


%find optimal angle
    head = threshold(image,sliceThresholdIntensity(image));
    headReflected = reflectVertically(head);
    angleCorrs = zeros(angleRange,1);
    
    minAngle = floor(angleRange/2)*-1;
    
    for theta = minAngle:(minAngle + angleRange - 1)
         tempCorr = max(normxcorr2(headReflected, imrotate(head,theta)));
         angleCorrs(theta + round(angleRange/2)) = max(tempCorr(:));
    end
    
    index = find(angleCorrs==max(angleCorrs));
    angle = (index - round(angleRange/2))/2;
    %divide the optimal correlation angle by 2 to get the angle that will
    %rotate our brain to be parallel with the y-axis
    
%find optimal translation
    headRotated = imrotate(head,angle);
    pixelCorrs = zeros(pixelRange,1);
    
    minPixels = floor(pixelRange/2)*-1;
    
    for pixels = minPixels:(minPixels + pixelRange -1)
        transHead = imtranslate(headRotated,[pixels,0]);
        reflectedTransHead = reflectVertically(transHead);
        pixelCorrs(pixels + round(pixelRange/2)) = corr2(transHead,reflectedTransHead);
    end
    
    translation = find(pixelCorrs==max(pixelCorrs)) - round(pixelRange/2);
   
end