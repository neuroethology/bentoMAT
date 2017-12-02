function str = makeTime(num)

sec = mod(num,60);
msec = sec - floor(sec);
min = floor(num/60);
if(msec)
    str = [num2str(min,'%02d') ':' num2str(sec,'%06.3f')];
else
    str = [num2str(min,'%02d') ':' num2str(sec,'%02d')];
end