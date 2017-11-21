function str = makeTime(num)

sec = floor(mod(num,60));
msec = mod(num,60) - sec;
min = floor(num/60);
if(msec)
    str = [num2str(min,'%02d') ':' num2str(sec,'%02d') '.' num2str(round(msec*1000),'%03d')];
else
    str = [num2str(min,'%02d') ':' num2str(sec,'%02d')];
end