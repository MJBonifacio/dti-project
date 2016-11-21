function reflectedImage = reflectVertically(img)
    rows = size(img,1);
    cols = size(img,2);
    reflectedImage = zeros(rows,cols);
    
    for row = 1:rows
        for col = 1:cols
            reflectedImage(row,(cols+1-col)) = img(row,col);
        end
    end
end