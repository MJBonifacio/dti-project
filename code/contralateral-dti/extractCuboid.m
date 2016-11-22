function [win] = extractCuboidNoReshape(img, pty, ptx, winSize)
x = floor(winSize/2);
win = zeros(winSize, winSize, numel(pty), 'single');

for i=1:numel(pty)
  win(:,:,i) = img(pty(i)-x:pty(i)+x, ptx(i)-x:ptx(i)+x);
end
