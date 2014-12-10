DataScienceForBusiness
======================

Material for the DePaul Data Science Course

To start with, I'd like to point to my collection of "getting started in R" resources. There are a lot of great tools, tutorials, and resources out there, and I'm not going to try to reinvent them.  However I will try to point you in the right direction. 

### R
Download and install **R**.  Yes you can google it, [google knows](https://github.com/search?q=user%3Agoogle+language%3AR&ref=searchresults&type=Code) all about R already.

### R Studio
Unless you're already in love with another IDE, use [**R Studio**](http://www.rstudio.com/) for your development.  You can download desktop version [HERE](http://www.rstudio.com/products/rstudio/download/).  R Studio is also a great resource in general.

### Git
Unless you're forced to do something else, use **git** for your version control. In Windows the [git tool](http://git-scm.com/downloads) is amazing, install it wtih the extra command line tools.  You may have heard of [github.com](https://github.com) (oh, look you're here now!).  Github uses git, and is also a great resource. 

### Text Editor
You will also need a text editor for taking a quick look at files.  I like Sublime Text, and I gladly pay for it. http://www.sublimetext.com/
I also use [SciTE](http://www.scintilla.org/SciTE.html) (Scientific Text Editor), because it's really fast, easy and lightweight.  I also have a version of SciTE [on my personal website](http://geneorama.com/downloads/wscite.zip) with some R specific customizations, just unzip it and use it without installing anything.

### Getting help
You can get help the old way by subscribing to r-help, which is perfect if you're a masochist.  For everyone else there's [Stackoverflow](http://stackoverflow.com/questions/tagged/R).  Always search before you ask, and do follow posting guidelines.  You can also search old r-help archives using something called [markmail](http://r-project.markmail.org/).

For high level "how tos", search for your topic in [r-bloggers](http://www.r-bloggers.com/), which is an amazing collection of R related blogs.

### Cheatsheets
I'm putting both versions of the mother of all R cheatsheets.

* R cheat sheet v1: http://cran.r-project.org/doc/contrib/Short-refcard.pdf
* R cheat sheet v2: http://cran.r-project.org/doc/contrib/Baggott-refcard-v2.pdf
* Shiny cheat sheet: http://shiny.rstudio.com/articles/cheatsheet.html
* Markdown / Knitr cheat sheet: http://shiny.rstudio.com/articles/rm-cheatsheet.html

### Learning R references

* http://www.cookbook-r.com/
* http://www.r-statistics.com/

Also R's built in documentation is incredibly valuable, but it's also dense for beginners

* http://cran.r-project.org/faqs.html
* http://cran.r-project.org/manuals.html

### Using R the "Gene" way

I rely heavily on the `data.table` package.  You can install it with `install.packages("devtools")`.  You can learn more in the [data.table FAQ](http://cran.r-project.org/web/packages/data.table/vignettes/datatable-faq.pdf), which is also available within R once you download the package.  For help, check out [Stackoverflow](http://stackoverflow.com/questions/tagged/data.table) again, but with "questions tagged data.table".  Also, their [github repo](https://github.com/Rdatatable/data.table/) has an (overwhelming) amount of info!

Probably the single best thing in R is the `data.frame`.  However, I use `data.table` which is an "enhanced" data.frame.  The data.table uses a very different mindset, and it's a little hard to get used to, but it's worth it.  The performance is vastly superior and the syntax is much easier once you've gotten the hang of it.  Now I never switch back to data.frame just so that I don't get confused / muddled with the old way of doing things.

Lastly, you can download my package using `devtools`, which can install R libraries directly from github (amazing, right?).  I use a lot of utilities from my library, so you might as well get it.
Start R and type:
```R
install.packages("devtools") ## Get devtools from CRAN
library(devtools)            ## Load devtools into R
install_github("geneorama/geneorama")
```
If it doesn't install, open an issue on this project (see issues on the right) and I'll update the instructions.
