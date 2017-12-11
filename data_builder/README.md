# Loading your data into Bento

## Introduction
The Data Builder is a Matlab interface for linking together different files associated with an experiment. 

## Data format
Data in Bento is broken down by trials, where one "trial" is a single stimulus or task. For each trial, you must provide a value for each of the following __required parameters__:

- Animal number
- Session number (a session could correspond to one day of recording, eg)
- Trial number
- Stimulus identity (eg "male intruder", "looming disk", "reach left". Can be left blank if desired.)

You may then link __experimental data files__ (containing, eg, imaging, video, or audio data) with that trial. Supported files and their required/optional inputs are listed in the following section.

## Experimental data files
For each experiment type, Bento requires some metadata containing sampling rate and the time data started/stopped being collected. This can sometimes be entered manually, but using log files generated during your experimental sessions is always safer if possible!

### Microendoscopic imaging data (Inscopix)
- __Required__:
	- __Imaging log file__ (.txt), **__OR__** the __framerate__ (in Hz) and the __start time__ of recording (in HH:MM:SS.SSS format.) If you downsample Ca movies before performing trace extraction, be sure to adjust the framerate accordingly.
- __Optional__:
	- __Calcium movie__ (.tif, .mp4, .avi, .wmv), either raw or filtered/motion-corrected. If you would like to link multiple versions of the movie (eg before/after filtering), you must add them as separate elements.
	- __DF/F traces__ (.mat), either the .mat file produced by trace extraction using CNMF, or a .mat file containing a single matrix of dimensions (neurons x time). If your DF/F framerate is different from that of your calcium movie, they must be added as separate elements.

### Fiberphotometry imaging data
- __Required__:

- __Optional__:

### Electrophysiology data (openEphys)
- __Required__:

- __Optional__:

### Behavior video data
- __Required__:

- __Optional__:

### Behavior audio data
- __Required__:

- __Optional__:





## Saving data
Two save formats are available; both formats can be used both to visualize data in Bento and to load data into Matlab for further analysis.

### .txt files for quick viewing
Bento links your data by creating a small __.txt__ file that stores the path to each associated file, plus some extracted metadata (see below for details). __As a result__, changing the name or location of data on your computer will cause this .txt file to break. However, this approach allows for quick browsing of data without eating up additional space on your hard drive.

### .mat files for packaging data
If you would like to create a more permanent archive, Bento can package a subset of your data into a Matlab structure and save it in a __.mat__ file. To save space, video data (from Ca2+ imaging, behavior videos, etc) are not saved (although you can save paths to video files), however extracted quantities (DF/F traces, behavior annotations, tracking data) are.
