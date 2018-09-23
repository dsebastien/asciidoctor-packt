# AsciiDoctor Packt

## About
This repository is my fork of Greg Turnquist's AsciiDoctor packt repos:
* https://github.com/gregturn/asciidoctor-packt
* https://github.com/gregturn/packt-book-template

I've tried to regroup both in one as a starting point to work on my current book project.

Some of my modifications:
* put both projects together
* modified the build script and extended it to generate the output in a "dist" folder
* tried to improve the image loading in fodt files because I had problems with this on Windows
* added a Gemfile and some info to ease the setup and config
* added an AsciiDoctor file for variables, to be loaded in all chapters and avoid repetition
* added a template for new chapters

As with the original repositories:
* there are no guarantees provided. If you take this on you assume ALL risk. You have been warned.
* all the document styles embedded in this project are owned by Packt Publishing Ltd. (http://packtpub.com) and potentially subject to their
copyright notices.

## Installation and usage
* Grab this project with `git clone https://github.com/dsebastien/asciidoctor-packt.git`
* Install Ruby
* Update your Ruby environment: `gem update --system && gem update *`
* Install bundler with `gem install bundler` (https://bundler.io/)
* Install the necessary Ruby dependencies with `gem bundle`
* Install LiveReload in your browser of choice: http://livereload.com/extensions/
* Install xmllint (http://www.zlatkovic.com/libxml.en.html). Binaries for Windows: ftp://ftp.zlatkovic.com/libxml/
* Run ./build.sh and check out the results in the `dist` folder!

In the `dist` folder, you'll notice that you now have both html and fodt files. The fodt files are those that you can send to Packt. They're formatted using their styles.

## Conventions
Each AsciiDoctor file should respect this convention: ${TITLE}_${module}_${ROUND}.adoc
Those variables get defined in `build.sh`

Assets are organized in different folders under `assets`. The folders under must corresponding to the ${module} part of the adoc file names (e.g., 1, 2, 3, preface, ...)

If you have fragments, you should put them in the assets folder, along with the rest of the corresponding chapter's content.

## Configuration

### Book title
* Rename the AsciiDoctor files
* Edit `build.sh` to configure the book title accordingly (`TITLE` variable)
* Edit `variables.adoc` to adapt the title too

### Edition round
Edit `build.sh` and change the `ROUND`, then the correct files will be taken.

### Output folder
If you want to use a different destination folder for the generated files, you need to adapt the `Guardfile` and `build.sh`.

### Book global variables
Adapt the `variables.adoc` file

## How to...

### Manage chapters and parts
When you want to add/rename/remove chapters or other parts, make sure to also adapt the modules.txt file. In addition, review the `build.sh` script.

### Generate a final copy
Using AsciiDoctor, it's possible to compile ONE final copy. Packt doesn't need this, but YOU can enjoy it! This is done by default with the `TITLE_index_1stdraft.adoc`, which includes the other files. You can update it to include everything you need.

### Process fragments
The `build.sh` script can process fragments as you with. Adapt the script to apply specific rules/transformations to specific assets if you need.

### Troubleshooting fodt documents
If you wish to better see the structure of the generated fodt documents:
* Install xmllint (http://www.zlatkovic.com/libxml.en.html)
  * Binaries for Windows: ftp://ftp.zlatkovic.com/libxml/
* Adapt `build.sh` to call xmllint

IMPORTANT: In order to open FODT files on Fedora, you must have the **libreoffice-xsltfilter** package installed.

## Don't...
* Don't embed :author: or :title: attributes at the top. They end up getting printed which fouls up the product you must ship to Packt.
* Because asciidoc considers double-underscores indicators of emphasis, all styles names are edited to replace __ with _ to avoid clashing

## TODO
* annoying warning on Windows: Slim::Engine: Option :asciidoc is invalid
* fix images
  * position in FODT files. On my machine they don't appear next to the [[Insert image ...]] message 
  * images inlining is broken on Windows: Cannot read data. Most probably an encoding issue, but couldn't fix it so far
* fix live reload support
  * original approach in Guardfile doesn't work on Windows under MSYS. Guard-livereload doesn't like running there...
    * one option: replace Guard by npm
* modify the template to use 01, 02, ... as chapter names and adapt corresponding folder names and examples in the .adoc files.