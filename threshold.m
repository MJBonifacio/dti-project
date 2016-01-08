function thresholded_image = threshold(img, min)
    rows = size(img,1);
    cols = size(img,2);
    thresholded_image = zeros(rows,cols);
    
    for row = 1:rows
        for col = 1:cols
            if img(row,col) >= min
                thresholded_image(row,col) = 1;
            end
        end
    end
end