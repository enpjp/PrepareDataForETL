# PrepareDataForETL
PhD Research

Welcome to the PrepareDataForETL wiki!

Each update to the master branch is tested using the [Travis CI](https://docs.travis-ci.com/) (Continuous Integration) tool and displays the automatically updated badge below to give confidence that this custom package is working. 

[![Build Status](https://travis-ci.com/enpjp/PrepareDataForETL.svg?branch=master)](https://travis-ci.com/enpjp/PrepareDataForETL)

# How to install this package
This package is currently designed to work with RStudio which can be downloaded from:
https://www.rstudio.com/products/rstudio/download/

The free version is fine.

## Windows users

A full installation of R is required. see these [instructions](https://github.com/enpjp/PrepareDataForETL/wiki/A-note-for-Windows-users) on how to do this. If you have missed out any of these steps you will probably get errors.

## Support video

The is a YouTube video of these instructions being used on a Mac at: [Go to YouTube Video](https://youtu.be/XMLLHJ3ZCuw)

[A note for Mac users.](https://github.com/enpjp/PrepareDataForETL/wiki/A-note-for-Mac-users)

## First steps

You will need to cut and paste  the code snippets below in the R console in RStudio.

If you have not updated R in a while update all your installed packages. This may take a while so get it to update all while you take a break.

     update.packages(ask = FALSE)

## Next

Install devtools:

     install.packages("devtools")

Load devtools. (The use of the quotes is different for install and library):

     library(devtools)

Install PrepareDataForETL

    install_github("enpjp/PrepareDataForETL")

And then:

     library(PrepareDataForETL)


*If you see any errors they are almost certainly due to your system requiring an update.* The current behaviour of install_github converts minor warnings into errors halting the install process. For example, if your R install is a minor version out of date, multiple warning messages may be generated during install informing you that dependencies were built with a more recent ersion of R.

Repeating these two steps will download any new updates from the remote file store.


## Using R studio
If you complete the install without errors then you will be able to create "markdown" files using my templates by going to:


File >> New file >> R Markdown... In the dialogue that opens select "From Template".

Look for: "01: A demonstration template" and select it. You system may also have other templates loaded as well. This one is marked as belonging to _PrepareDataForETL_.

Select a directory to save the file and give it a name. This is important as this test also saves some image files.

The final step is to use the "Knit" button and all being well you will end up with a nicely formatted PDF.

## Results

If you have ended up with a PDF and some saved images in a subdirectory called images, then the test has been successful! You have analysed the built in package data. 

## Next steps

The next steps will be to design templates that are user friendly and work with your data. This template can be modified, but you will need to be carefull. 

## Removing package software
If you want to delete the package from your system use:

    remove.packages("PrepareDataForETL")
