function rgbImage = getHSVmap(hSC)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



rows = 300;
columns = 300;
midX = columns / 2;
midY = rows / 2;
% Construct h image as uniform.
h = hSC * ones(rows, columns);
s = zeros(size(h));
v = zeros(size(h));
[s,v] = meshgrid((1:rows).^2,columns:-1:1);
s = s/rows.^2;
v = v/columns;

% Flip v right to left.
% Construct the hsv image.
hsv = cat(3, h, s, v);

% Construct the RGB image.
rgbImage = hsv2rgb(hsv);