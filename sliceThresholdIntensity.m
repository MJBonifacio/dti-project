function i = sliceThresholdIntensity(image)
%takes an 8-bit brain scan and finds the appropriate intensity to threshold
%and isolate head region
image = uint8(image);
%make histogram of intensities, find its second derivative, save max
%intensity value
    h = imhist(image);
    testHist = h(3:250); %exclude extreme values -- complete black/white
    iMax = find(testHist==max(testHist));
    d2 = diff(diff(h));
    
%find the index of the second zero-crossing after the highest peak of
%intensities, which we take to be the dark background pixels. that will be
%our threshold.
    pos = true;
    if d2(iMax)<0
        pos = false;
    end
        
    zeroCrossingsRemaining = 2;
    
    i = iMax+1;
    while zeroCrossingsRemaining > 0
            if d2(i).*d2(i-1) < 0 
            %zero-crossing occured if product of adjacent second derivatives is
            %negative
                zeroCrossingsRemaining = zeroCrossingsRemaining - 1;
            end

        i = i+1;
    end
end