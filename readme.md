ScadTools
=========

ScadTools is a OpenScad library.
It contains functions and modules to make OpenScad easier to use.

### Contents
[What it does](#what-it-does)<br>
[Installation](#installation)<br>
[Use](#use)<br>

What is does
------------

- [More control of the level of detail for a mesh][extend],
    extend the control of number of facets used to generate an arc
- Contains functions to [draft objects in a point list][draft]
  - Create [curves][curves] in a point list with functions.
    These can load with ```polygon()```
  - [Transform][transform] objects in a point list
  - Contains functions for working with [multmatrix][multmatrix]
- Contains some functions for [editing lists][list]
- Contains some math and helper functions
- Contains some functions and modules transform and edit objects
- Contains some configurable object modules

[extend]:     doc/extend.md
[draft]:      doc/draft.md
[curves]:     doc/draft.md#curves
[transform]:  doc/draft.md#transform-functions
[multmatrix]: doc/draft.md#multmatrix
[list]:       doc/list.md

Installation
------------

You must extract archive and copy 'tools.scad' and folder 'tools/' into a directory
and now you can use it here.
  
Or you can copy this into the library folder from OpenScad for global use.
The path for this directory depends on your system:

| OS       | Path
|----------|------
| Windows: | My Documents\OpenSCAD\libraries
| Linux:   | $HOME/.local/share/OpenSCAD/libraries
| MacOS:   | $HOME/Documents/OpenSCAD/libraries

You can reach this from OpenScad menu File->Show Library Folder.


Use
---

You can include the whole library with
```OpenSCAD
include <tools.scad>
```
  
You can load a specify libraries with
```OpenSCAD
include <tools. *** .scad>
```
Or even with `use`. But if you need this defined constants
you must include the file separately.
So you can keep the namespace clean.
```OpenSCAD
use <tools. *** .scad>
include <tools/constants.scad>
```
  
If you want to use some new functions from OpenScad from version 2019.05 in version 2015.03
you can include file 'compatibility.scad'.
```OpenSCAD
include <compatibility.scad>
```
