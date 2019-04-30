# **B**ehavior **E**nsemble and **N**eural **T**rajectory **O**bservatory

Bento is a Matlab GUI for managing multimodal neuroscience datasets. It lets you browse and annotate behavioral and neural data, train behavior classifiers, and helps you organize and navigate trials within a batch of experiments.

![](/docs/bento_screenshot_plain.png?raw=true)

## Installation
The easiest way to keep your local version up to date is to clone this git repository. Bento requires the following software:
* Matlab 2014b or later
* Microsoft Excel (for assembling of metadata. This requirement will be softened in the future.)

#### Optional additional tools:
* [Piotr's Matlab Toolbox](https://pdollar.github.io/toolbox/) if you use *.seq format videos
* [Source2D Toolbox](https://github.com/zhoupc/CNMF_E) (in ca_source_extraction) if you use calcium traces extracted with CNMF_E
* [JSONLab](https://github.com/fangq/jsonlab) if you use our mouse tracker, MARS, and your MATLAB doesn't have native *.json support (pre-2017)


## Creating your first experiment
Click "New Experiment" in the welcome menu to open the Bento Experiment Manager:

![x](/docs/experiment_manger.png?raw=true)

Bento assumes all of your data can be found within a common Parent directory. Set the path of this Parent directory, then hit `Launch File Finder` to search for files within your Parent directory.

To add a file to your table, select that file in the File Finder, then select a cell of the Experiment Manager. Click `Add` to replace the contents of the selected cell, or `Append` to append your file to the cell's contents. You can link any combination of imaging data, behavior annotations, behavior movies, audio recordings, and tracking data. A variety of data formats are supported for each field- see more below.

After assembling an experiment, click `Save Info` to save the experiment to an Excel file. This file may be loaded back into the Manager, or edited in Excel.

When you're ready, click `Start Import` to exit the Experiment Manager and launch the Bento interface.

### Supported Data Formats
#### Calcium imaging data
* [CNMF-E output](https://github.com/zhoupc/CNMF_E)
* Any mat file containing a single matrix (any variable name)-- Bento will assume that matrix is arranged as neurons x time

#### Movies
* .seq format (used by [Piotr's Toolbox](https://pdollar.github.io/toolbox/))
* Any video type supported by Matlab's VideoReader (mp4, wav, avi...)

Multiple movies can be displayed simultaneously. Examples:
* `movie_1.avi;movie_2.avi` stacks movies vertically
* `movie_1.avi;;movie_2.avi` stacks horizontally

(vertical and horizontal stacking can be combined.)

#### Behavior annotations
* Bento .annot files
* Caltech behavior annotator (part of [Piotr's Toolbox](https://pdollar.github.io/toolbox/))
* Ethovision .txt files

Multiple annotations can be loaded simultaneously, and need not be in the same format. Example: `file_1.annot;file_2.annot;file_3.txt`

#### Audio data
* Linked .wav files will be converted to spectrograms (this sometimes takes a while) and displayed. The generated spectrograms will be saved to a .mat file in the same directory as the audio file, and re-loaded automatically on future use.

## Using the GUI
Coming soon.
