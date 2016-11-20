function filled_mask = fill_mask(img)
%fills any area between left/right limits of value "1" in a binary mask
rows = size(img,1);
cols = size(img,2);
filled_mask = img;

for row = 1:rows    
    %finds first "1" in row
    leftLimit = 3;
    while img(row,leftLimit)==0
        leftLimit = leftLimit + 1;
        if leftLimit == cols
            break;
        end
    end
            
    %finds first "1" starting from end of row
    rightLimit = cols-3;
    while img(row,rightLimit)==0
        rightLimit = rightLimit - 1;
        if rightLimit == 1
            break;
        end
    end
    
    if rightLimit>leftLimit
        for i = leftLimit+1:rightLimit-1
            filled_mask(row,i)=1;
        end
    end
end
end