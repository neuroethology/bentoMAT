function str = makeTime(num)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



sec = mod(num,60);
msec = sec - floor(sec);
min = floor(num/60);
if(msec)
    str = [num2str(min,'%02d') ':' num2str(sec,'%06.3f')];
else
    str = [num2str(min,'%02d') ':' num2str(sec,'%02d')];
end