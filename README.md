# **B**ehavior **E**nsemble and **N**eural **T**rajectory **O**bservatory

Bento is a Matlab GUI for browsing and annotating joint calcium imaging + video datasets.

## Getting Started

Want to get a quick visual sense of what's going on in your data? Bento lets you browse and annotate behavioral and neural data, and makes it easy to organize and navigate trials within a batch of experiments.

### Prerequisites
* Matlab 2014b or later
* Microsoft Excel (for assembling of metadata. This requirement will be softened in the future.)

### Additional Resources
* [Piotr's Matlab Toolbox](https://pdollar.github.io/toolbox/) if behavior videos are in *.seq format
* [Source2D Toolbox](https://github.com/zhoupc/CNMF_E) (in ca_source_extraction) if using calcium traces extracted with CNMF_E
* [JSONLab](https://github.com/fangq/jsonlab) if using *.json files (eg for tracker output)

## Installation
The easiest way to keep your local version up to date is to clone this git repository; GitHub's software then lets you update to the latest version of the code at the press of a button.

A copy of the code is also posted to the Anderson lab private server, however this copy is less frequently updated.

## Creating your first experiment
Clicking "New Experiment" in the welcome menu brings up a window in which you can enter experiment metadata + paths to your data; entered text can be saved into an excel sheet ("Save info") and reloaded in subsequent sessions ("Edit experiment"/"Load experiment" in the main menu).

Bento assumes all of your data can be found within a common parent directory (possibly split among subdirectories.) Setting the path of this parent directory, then hitting "Launch File Finder", allows you to search for files within your parent directory and add them to the table.

You can link any combination of imaging data, behavior annotations, behavior movies, audio recordings, and tracking data (some of these are better supported than others at the moment.) A variety of data formats are supported for each field- see more below.

## Using the GUI
Coming soon.
