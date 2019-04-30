function sample = scaleAudio(gui,sample)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



thrLo = gui.audio.thrLo;
thrHi = gui.audio.thrHi;

sample(sample<thrLo) = thrLo;
sample(sample>thrHi) = thrHi;
sample = (sample - thrLo)/(thrHi-thrLo);
