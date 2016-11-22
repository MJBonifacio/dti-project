function [win] = extractCuboidNoReshape(img, pty, ptx, winSize)

% F = makeLMfilters;
% 
% yGrad = filter2(F(20:30,20:30,7), img,'same');
% xGrad = filter2(F(20:30,20:30,10), img,'same');
% 
% mod   = sqrt(xGrad.^2 + yGrad.^2);
% angle = atan2(yGrad, xGrad);

x = floor(winSize/2);
%x2 = ceil(sqrt(2) * x);

win = zeros(winSize, winSize, numel(pty), 'single');

for i=1:numel(pty)        
%    if( mod(pty(i), ptx(i)) > 0.1)
%        theta = double(180*angle(pty(i), ptx(i))/pi);
%        tmp = img(pty(i)-x2:pty(i)+x2, ptx(i)-x2:ptx(i)+x2);
%        patch = imrotate(tmp, -theta, 'bicubic', 'crop');
%        win(:,:,i) = patch(x2-x:x2+x,x2-x:x2+x);
%    else
        win(:,:,i) = img(pty(i)-x:pty(i)+x, ptx(i)-x:ptx(i)+x);
%    end  
end

