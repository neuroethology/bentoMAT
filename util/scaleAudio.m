function sample = scaleAudio(gui,sample)

thrLo = gui.audio.thrLo;
thrHi = gui.audio.thrHi;

sample(sample<thrLo) = thrLo;
sample(sample>thrHi) = thrHi;
sample = (sample - thrLo)/(thrHi-thrLo);