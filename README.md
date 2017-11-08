# Social Data Analytics Workshop Series: Introduction to Data Science with R
Hi! My name is Matt Denny, I am a grad student in the Department of Political Science and Social Data Analytics, an NSF Big Data Social Science IGERT Fellow, and the instructor for this workshop series. I will be posting all relevant materials for this workshop series on this page. 

## Preliminaries

You can email me at <mdenny@psu.edu> or <matthewjdenny@gmail.com> with any questions. There are lots of additional materials available on my website at: <http://www.mjdenny.com/>, but you will only need to look at the stuff linked to from this page in oder to be successful in this workshop series. To download all of the materials associated with this workshop series, you will want to start by downloading a GUI client for Git. 

* For Windows: <https://windows.github.com/>
* For Mac: <https://mac.github.com/>
* For Linux, you may have to rely on the command line, although <https://git-scm.com/downloads/guis> has some options (depending on your distro).

You will then want to `clone` this repo onto your computer using either the 

    https://github.com/matthewjdenny/SoDA-Workshop-Series-Introduction-to-Data-Science.git

link and your client or by clicking the "Clone in Desktop" button on the right hand side of the page. If you want to directly edit the files posted here and track your changes, you can copy individual files into another directory and create your own Git repo with the files in it. If you are not sure what any of the above meant, don't worry!  We will go over using Github at the beginning of the first workshop, so there is no need to spend too much time trying to figure Github out. If you are at some point during this workshop series, and it is also not essential for you to learn the material. If you want to learn more about GitHub and how to use it, check out this  [**[Github pictorial]**](http://www.mjdenny.com/Data_Science_Tools.html). Welcome to these workshops!

##  Workshop Schedule


1. **8-31-17: Introduction and Installing and Setting up R and RStudio**:
    * In this workshop, we covered installing and setting up R and RStudio, and how to set up RStudio to maximize your workflow. I also provided an overview of the workshop series, which can be found in the slides.
    * You can find the sldies for this workshop [here](https://github.com/matthewjdenny/SoDA-Workshop-Series-Introduction-to-Data-Science/blob/master/Workshop_Materials/Workshop_1-Introduction.pptx), or go to the /Workshop_Materials subdirectory.
    * To make things easier, I have created a video tutorial that will walk you through installing R and RStudio on your computer. You can check it out by clicking on the video below:
    [![Downloading and Installing R and RStudio](https://img.youtube.com/vi/0FWXWnPuxrs/0.jpg)](https://www.youtube.com/watch?v=0FWXWnPuxrs "Click on this screenshot to watch the video! ")
    * Download R here: [https://cran.r-project.org/](https://cran.r-project.org/)
    * Download RStudio here: [https://www.rstudio.com/products/rstudio/download/](https://www.rstudio.com/products/rstudio/download/)
    * For Mac users, get X-Code Command Line Tools by following this tutorial: [http://osxdaily.com/2014/02/12/install-command-line-tools-mac-os-x/](http://osxdaily.com/2014/02/12/install-command-line-tools-mac-os-x/)
    * Here is a link to my pictorial on setting up R and RStudio: [http://www.mjdenny.com/Data_Science_Tools.html](http://www.mjdenny.com/Data_Science_Tools.html). There is also a bit on using GitHub, which I highly recommend!
 
 2. **9-7-17: Getting Started with R Programming**:
    * In this workshop, we will get started writing our first R commands. In particular, we will learn about defining variables, writing comments, doing some basic math, comparing variables, and printing information to the R console. This is the stuff I use most often in my day-to-day workflow, and will form the foundation for the more advanced programming concepts we learn throughout this series.
    * You can find the slides for this workshop [here](https://github.com/matthewjdenny/SoDA-Workshop-Series-Introduction-to-Data-Science/blob/master/Workshop_Materials/Workshop_2-Basic_R_Programming.pptx).
    * You can download the R script for this workshop [here](https://github.com/matthewjdenny/SoDA-Workshop-Series-Introduction-to-Data-Science/blob/master/Workshop_Scripts/Workshop_2-Basic_R_Programming.R).
    
3. **9-14-17: Basic Programming and Data Structures in R**:
    * In this workshop, we will wrap up covering some programming basics in R, and then get into the five basic data structures we will be using throughout this workshop series. Values, vectors, matrices, data.frames and lists provide a powerful and flexible toolbox for representing social science data. We will learn how these different data structures can be used separately and together to represent complex social science datasets.
    * You can find the slides for this workshop [here](https://github.com/matthewjdenny/SoDA-Workshop-Series-Introduction-to-Data-Science/blob/master/Workshop_Materials/Workshop_3-Programming_and_Datastructures.pptx).
    * You can download the R script for this workshop [here](https://github.com/matthewjdenny/SoDA-Workshop-Series-Introduction-to-Data-Science/blob/master/Workshop_Scripts/Workshop_3-Basic_Datastructures.R).
    
 4. **9-21-17: WORKSHOP POSTPONED**: I am getting over a nasty cold and am not sure my voice can last for an hour, so we are postponing this workshop until next week, see you all then!
 
 5. **9-28-17: Data Structures and Subsetting in R**:
    * In this workshop, we will keep covering basic data structures in R: dealing with matrices, data.frames, and list objects. We will also learn about subsetting and indexing these objects, so we can begin to access and chop up the data structures we create. This workshops is where you should finally start to see some of the data structures you are more familiar with (like spreadsheets), and learn how to extract useful bits of information from those data. 
    * You can download the R script for this workshop [here](https://github.com/matthewjdenny/SoDA-Workshop-Series-Introduction-to-Data-Science/blob/master/Workshop_Scripts/Workshop_3-Basic_Datastructures.R).
    
  
 6. **10-5-17: NO WORKSHOP**: SoDA Job Candidate will be visiting so there will be no workshop this week.
  
 7. **10-12-17: Data I/O and R Packages**:
    * In this workshop, we will finally move beyond the basic functionality provided by defaul in R, and learn about how to extend that functionality by using R packages. We will make use of one such package (rio), to read in (and write out) data from many different formats to R (SAS, Sata, Excel, Minitab, SPSS, etc.).  
    * You can find the slides for this workshop [here](https://github.com/matthewjdenny/SoDA-Workshop-Series-Introduction-to-Data-Science/blob/master/Workshop_Materials/Workshop_5-Data_IO_and_Packages.pptx).
    * You can download the R script for this workshop [here](https://github.com/matthewjdenny/SoDA-Workshop-Series-Introduction-to-Data-Science/blob/master/Workshop_Scripts/Workshop_5-Data_IO_and_Packages.R).
   
8. **10-19-17: Looping and Conditionals**:
    * In this workshop we will begin to give R a "brain". First, we will teach it how to repeat tasks for us, such as adding numbers together. Next, we will learn the syntax for executing code only if some condition(s) are met. Finally, we will combine these concepts so that we can automate the process of checking through data and taking some actions dependent on what the program finds. We will then apply our skills to a real-world example.
    * You can find the slides for this workshop [here](https://github.com/matthewjdenny/SoDA-Workshop-Series-Introduction-to-Data-Science/blob/master/Workshop_Materials/Workshop_6-Looping_and_Conditionals.pptx).
    * You can download the R script for this workshop [here](https://github.com/matthewjdenny/SoDA-Workshop-Series-Introduction-to-Data-Science/blob/master/Workshop_Scripts/Workshop_6-Looping_and_Conditional_Statements.R).
    * You can download the example data for this workshop [here](https://github.com/matthewjdenny/SoDA-Workshop-Series-Introduction-to-Data-Science/blob/master/Workshop_Data/Looping_Conditionals_Example_Data.RData)
    
9. **10-26-17: Functions**:
    * In this workshop, we will start to think about writing R code that is useful for more than just the specific task we are doing at the moment. In R, functions are way of taking some code that works for one task, and making it easily applicable to other similar tasks. We have already encountered functions (like sum()), and we will learn how to define our own functions. Functions also allow us to build in automatic checks that we are not making data management mistakes, and we will go through a function template to make this easier going forward. Functions are great, lets learn how to use them!
    * You can find the slides for this workshop [here](https://github.com/matthewjdenny/SoDA-Workshop-Series-Introduction-to-Data-Science/blob/master/Workshop_Materials/Workshop_7-Functions.pptx).
    * You can download the first R script for this workshop [here](https://github.com/matthewjdenny/SoDA-Workshop-Series-Introduction-to-Data-Science/blob/master/Workshop_Scripts/Workshop_7-Functions.R).
     * You can download the second R script for this workshop [here](https://github.com/matthewjdenny/SoDA-Workshop-Series-Introduction-to-Data-Science/blob/master/Workshop_Scripts/Workshop_7-Additional_Functions.R).
     
10. **11-2-17: Managing Multiple Datasets**:
    * In this workshop, we will begin to synthesize what we have learned so far and apply it to managing multiple complex datasets. The primary activity we will cover in this workshop will be a worked example managing 11 large relational datasets and extracting useful information from them using loops and conditionals. We will also make use of loops and lists to help us store and easily access the 11 datasets we will be working with. Finally, we will start to put our data management skills together with what we know about functions to automate and generalize the process of reading in and cleaning data. 
    * You can find the slides for this workshop [here](https://github.com/matthewjdenny/SoDA-Workshop-Series-Introduction-to-Data-Science/blob/master/Workshop_Materials/Workshop_8-Managing_Multiple_Datasets.pptx).
    * You can download the R script for this workshop [here](https://github.com/matthewjdenny/SoDA-Workshop-Series-Introduction-to-Data-Science/blob/master/Workshop_Scripts/Workshop_8-Managing_Multiple_Datasets.R).
     * You can download the data for this workshop [here](https://github.com/matthewjdenny/SoDA-Workshop-Series-Introduction-to-Data-Science/blob/master/Workshop_Data/Workshop_8-Data.zip). Be sure to unzip the file when you download it and save the extracted folder somewhere where you can find it.

11. **11-9-17: Working with Text Data**:
    * In this workshop, we will cover the basics of manipulating and representing text data in R. Learning how to chop up, manipulate, and extract bits of text from string (text) data is a critical skill for working with messy data, web scraping, and for conducting text as data analyses. We will start by diving into the stringr libraries for extracting a replacing parts of strings, and then work with the quanteda library for forming and manipulating document-term matrices. The skills we cover here will form the basis for a series of lectures of web-scraping this spring.  
    * You can find the slides for this workshop [here](https://github.com/matthewjdenny/SoDA-Workshop-Series-Introduction-to-Data-Science/blob/master/Workshop_Materials/Workshop_8-Managing_Multiple_Datasets.pptx).
    * You can download the R script for this workshop [here](https://github.com/matthewjdenny/SoDA-Workshop-Series-Introduction-to-Data-Science/blob/master/Workshop_Scripts/Workshop_8-Managing_Multiple_Datasets.R).
     
    
   
