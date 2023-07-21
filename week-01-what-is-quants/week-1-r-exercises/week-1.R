###################################################################################################
############################ SMI606: Week 1 - Getting Started in R ################################
###################################################################################################

##########################################################################---- Exercise 1: Comments.

#' This is an R Script. You write all the code you want to keep a record of or run multiple 
#' times here.

#' Comments in an R Script always start with a #. If you want to write a long comment
#' that goes across multiple lines you can start your comment with #'. This will automatically
#' keep adding new #' symbols at the start of each line (when you press enter) until you 
#' delete them. 

# This is a regular comment (without an ' ).

# Task 1: Try writing a comment below.






##########################################################################---- Exercise 2: Objects.

#' Before you start doing these exercises, you should have been shown how to navigate Rstudio.
#' The first thing we will learn about in R is different types of objects that can be 
#' saved in the environment and how to save them.
#' Sometimes objects are referred to as 'variables', but because we use this term in quantitative
#' social sciences in another context, I am going to use objects.
#' 
#' Objects store information in them, including entire datasets. They are named so that
#' we can call them into use. There are a few rules with naming objects:
#'   1. They must not contain any spaces, unless they are enclosed with ` symbols
#'   2. They must not include any special characters, e.g. @, $, #, or similar
#'   3. They must not start with a number

#' Objects can be assigned using the assignment operator: <- 
#' Alternatively, you can use = as an assignment operator: =
#' However, we generally save = for use within functions or transformations.



# Example: Assigning an object
# Highlight the code below and either click "Run" above or press Ctrl/Cmd and the Enter key
# to complete the assignment. You should see a new object appear in the Environment pane.

module_leader <- "Dr. Calum Webb"

# Task: Assign your own name to an object called my_name




#' Printing the values of an assigned object to the console.
#' Now that we have assigned an object we can print its value to the console or use
#' it in all kinds of other ways.



# Example: Printing an object to a console
# Highlight the code below and press Ctrl + Enter key to run it, or click Run above

module_leader

# Task: Now try printing the object you created, my_name, to the console below.



##################################################################---- Exercise 2.1 Object Classes.

#' There are many different types (or classes) of object that do different things. For example,
#' the two objects we added above are both 'character' type objects. The class of an object 
#' defines what can be done with it. 
#' 
#' There are seven classes we will commonly see and use:
#'   1. Numeric/Double/Integer
#'   2. Character/String
#'   3. Logical
#'   4. Factor
#'   6. Vector
#'   7. Data Frame (and similar, e.g. tibble, data.frame)
#'   
#' Let's start with the first four.
#' 


################################################################## ---- Exercise 2.1.1 Numeric.

# Example: A numeric object.
#' As you probably guessed, a numeric or double object is an object/variable that is completely
#' expressed in numbers (e.g. 1, 2, 3; 0.1, 0.2, 0.3). For example, we can assign the number 
#' 1 to an object below and then print it to the console:

number_one <- 1
number_one

# Task: Assign the number 2 to an object called number_two below




#' Example: We can then manipulate numeric vectors using mathematical functions (in
#' other words, use the R console like a calculator). For example:

number_one + number_two # addition
number_two * number_two # multiplication
number_one / number_two # division
number_two^number_two # powers


#' Of course, you don't need to save every number you want to use into a named
#' object to do basic computations. E.g.

1 + 2
2 * 2
1 / 2
2^2


################################################################## ---- Exercise 2.1.2 Character.

#' The second common object we use in R is a string or character object/variable.
#' We already saw this used when we assigned the module_leader and my_name objects.
#' Obviously, because these are characters/names/text we cannot use mathematical
#' functions on them. For example, see what happens when we try to add together
#' two module_leader objects

module_leader + module_leader

#' This might seem obvious, but you will probably see this error a lot of you are using data
#' that hasn't been cleaned up first (e.g. there are lots of numbers but also characters like
#' "NA" or "Missing".)
#' 
#' Always be aware of character variables - the easy way to tell if something is a character
#' rather than a number or other type of variable is to see if it's enclosed in "quotation
#' marks". Characters/strings always have quotation marks.


################################################################## ---- Exercise 2.1.3 Logical

#' The next type of object/variable on our list is the 'logical' variable/object. Logical variables
#' can only accept two values: TRUE or FALSE. These can sometimes be used for distinguishing whether
#' someone is in a control or a treatment group, e.g. treatment = TRUE

#' Only either TRUE or FALSE in all caps, or T or F, are valid logical values. True, true, False, and
#' false are not generally interpreted as local, but instead as strings or objects.

x <- TRUE
y <- FALSE

#' Logical objects actually do have a numeric value - TRUEs count as one and FALSEs count as 0

x + y
TRUE + FALSE

x * y
TRUE * FALSE


################################################################## ---- Exercise 2.1.3 Factor

#' Factor variables are some of the most difficult to work with and are essentially named
#' numeric variables, or character variables with numbers or orders attached (if you prefer).
#' 
#' They are usually used when there is an order to the valid values in the variable, for
#' example in a Likert Scale you might want an explicit order of 1 = Not at all, 2 =
#' Not likely, 3 = Neither likely nor unlikely, 4 = Likely, 5 = Certainly
#' 
#' You might also want to use a factor if you are trying to plot a categorical variable 
#' in a certain order (e.g. you want the largest categories to be plotted first).

#' Factors have to be created using a function - ignore this for now and just run the
#' code, we will visit functions in a moment.

likely <- factor(x = "Likely", 
                 levels = c("Not at all", 
                            "Not likely", 
                            "Neither", 
                            "Likely", 
                            "Certainly"),
                 ordered = TRUE)

likely

#' Notice how when you print the likely object to the console you are also given all
#' of the possible levels and where they are in an ordered list below.

#' Remember that I said a factor variable is a bit like a character variable with numbers
#' attached to all of the possible values it can take? You can see that this is the case
#' if you run the following function, which converts what it is given into the numeric
#' variable equivalent

as.numeric(likely)

#' 'Likely' is the fourth value in the ordered list of levels, so it can be converted 
#' numerically to 4. However note that, unlike logical variables, you cannot directly
#' add together factors. For example...

likely + likely

#' returns an error, not what we might expect (8).



##########################################################################---- Exercise 2.2.1: Functions.

#' As you saw, we are now starting to get to the point where we cannot just use mathematical expressions
#' to do everything we need to do (e.g. creating a factor object). We needed to use something else called 
#' a function.  
#' 
#' Functions are, basically, sets of instructions to R which ask it to take some information you give it 
#' and then turn it into something else in the output, or to save as a new object. They look like regular
#' objects but are always followed by a pair of brackets which contain the arguments needed.
#' 
#' Let's go through a couple of the inbuilt R functions. We've already see the 'factor' function. Here are
#' some others...
#' 
#' The class() function returns the class of an object provided. For example...

class(likely)

# Task: use the class() function to get the class of the module_leader object we created earlier.



#' The sqrt() function returns the square root of a given number or set (vector) of numbers

sqrt(16)

# Task: Use the sqrt function to calculate the square root of 3481



#' Because there are so many different functions across R and its packages, and because functions
#' can become very complex, it's important that they are well documented for troubleshooting, or so 
#' that we can remind ourselves about which arguments are needed. It is easy to bring up the 
#' documentation for any function in R by typing ? following by the function name (without a space)
#' in our R script or R console/
#' 
#' For example, we can call the help documentation for the sqrt() function by running...

?sqrt

# Task: How would you bring up the documentation for the class() function?


#########################------------------- 2.2.2 How to understand function usage and arguments

#' Let's load the help documentation of a more complicated function we will be using later in the
#' module: lm(). Don't worry too much about what it does yet, we just want to read the documentation

?lm

#' There are two especially important heading in the documentation: Usage and Arguments.
#' 
#' Usage provides the general structure of the function and all important arguments.
#' 
#' You will notice that some of the arguments have = signs and values after the = signs, whereas
#' some are just words. Arguments with = signs mean that they have a default value and do not need to 
#' be specified unless you want to change this default.
#' 
#' Arguments with no = sign, e.g. formula, data, subset, weights in the lm() function are arguments
#' that the user must provide, though some of these are optional. You can find out which are
#' optional by looking in the detailed arguments section. 
#' 
#' Arguments provides a description of each of the arguments in the Usage text in turn.
#' 
#' Lastly, it is not necessary for us to spell out every argument if we know what order they are in.
#' By default, R assumes that you enter the value for each argument in the order they appear in the
#' usage list (e.g. for lm() you would enter formula first, then data, then subset, and so on). This
#' is why we did not need to write sqrt(x = 16) earlier on.
#' 
#' However, it is probably better for your memory if you do explicitly state your arguments - it can
#' also help prevent errors. As you can see below, being explicit with the sqrt() function returns the
#' same outcome as not being explicit.
#' 

sqrt(x = 16)
sqrt(16)

###################################################------------------- 2.2.3 Writing our own functions

#' If we like, we can also write our own functions, though it is unlikely you will need to do this
#' in this module or even as a practicing social scientist. However, it can be useful to see how
#' it works.

double_and_add_two <- function (number) {
  
  number <- number * 2 # Double number and overwrite number
  number <- number + 2 # Add two and overwrite number
  return(number)       # Return the result 
  
}

double_and_add_two(number = 10)


#' Notice how the name of the function is the object that is assigned, 
#' designated by the use of 'function', with the arguments following in
#' brackets. Within the curly braces {} we then have the operations that the
#' function does in order.


##################################################################---- Exercise 2.3 Vectors.

#' Okay, now we know what kind of forms our variables/objects can take and how to use functions
#' we can move onto a more important aspect: vectors. Vectors are what we use when we want to 
#' record more than one entry into an object.

#' The function for creating a vector from a set of values is c() (which stands for combine).
#' For example, we can create two vectors below:

some_numbers <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
some_fruit <- c("Apple", "Banana", "Orange", "Peach", "Pear")

some_numbers
some_fruit

# Task: Try creating a vector that contains the names of 3 of your favourite movies,
#       tv shows, or music artists.




#' We can use the same mathematical expressions and most functions on vectors in exactly
#' the same way we can with single-value objects. For example, we can
#' 
#' Multiply every value in some_numbers by two

some_numbers*2

#' Square every value in some_numbers

some_numbers^2


#' This includes the class() function
#' 
#' Task: use the class() function to check the type of vector that 'some_fruit' is.




#' It is generally a good idea to only use values of the same type in your vectors - it is 
#' also worth checking them when you load in a new dataset as the vectors not being the type
#' you think they should be is often the course of an error.
#' 
#' Task: For example try creating a vector that includes the following: 1, "Banana", 2, "Banana",
#' 3, "Banana", 4 — then check what class the vector you created is. How might this cause 
#' problems?






##################################################################---- Exercise 2.4 Dataframes/sets

#' Finally, we have arrived at the most important part: full datasets. R features a range of 
#' (not very interesting) built in dataframes that we can use quickly before we cover how to read
#' in data. For example, try printing out the 'USArrests' dataset in the console.

USArrests

#' Task: Check the class of the USArrests data




#' Data frames and other forms of datasets in R (such as tibbles, a much neater kind of data 
#' storage option we'll explore in the next two sections) are essentially just collections of
#' vectors - with the important characteristics that all of these vectors are the same length
#' (the number of entries in each).
#' 
#' A good dataset should be Tidy - where every row corresponds with one observation (e.g. one
#' person, event, or year) and every column corresponds with one variable (e.g. age, income, 
#' height, weight, etc.)
#' 
#' Let's try creating a dataframe with two vectors, let's start by using our "some_fruit" vector:

some_fruit

#' And let's create a vector of preference for each, say, a rating between 1 and 5 with 5 being
#' very positive and 1 being very negative (and 3 being indifference).

module_leader_ratings <- c(3, 4, 3, 4, 2)

#' Task: create a vector of length = 5 of your ratings for the fruit in the vector some_fruit
#' as above. Remember to give it a name and save it to the environment by assigning it to that
#' name.




#' Now we can stitch these vectors together to create a data frame and save it as 
#' 'fruit_preferences'.

fruit_preferences <- data.frame(some_fruit, module_leader_ratings)


#' If you assign a new value to a name that is already in the global environment then this object
#' will be overwritten with the new values. 
#' 
#' Task: For example, try overwriting fruit_preferences but with the vector of your own ratings 
#' instead of the 'module_leader_ratings'.





#' We can also get specific vectors back out of dataframes using the dollar sign ($) operator
#' after the dataframe name. For example, to get only the 'some_fruit' vector back out of the
#' fruit_preferences dataframe we can run:

fruit_preferences$some_fruit

#' This is very useful to know because some functions might ask explicitly for a vector to be
#' provided, rather than a dataset and pointer to the column/variable

#' We can also get specific entries, e.g. the first entry in the vector, by using subscripts (
#' square brackets after the vector)

fruit_preferences$some_fruit[1]

#' Note: unlike many other programming languages, R counts positions starting from 1 rather than
#' zero. 

#' Task: try extracting the value in the third position of the some_fruit vector stored in the
#' fruit_preferences dataframe





################################################################---- Exercise 3.1: Installing Packages.

#' We will often want to use more than the base R functionality we have been using so far. However,
#' we don't necessarily want to end up having to program all of our own functions - and this would
#' be a huge waste of effort when so many people have already done the work on them!
#' 
#' We can get access to more functions by installing packages that are contributed to the R CRAN 
#' repository by authors across the world - there are tens of thousands of open source R packages.
#' 
#' To install R packages you need to be connected to the internet and then run the install.packages()
#' function. 
#' 
#' It is generally considered bad practice to use install.packages() in a script file because leaving
#' it there means you will be reinstalling all of your packages every time you run the script. This
#' also means you would be installing software on other peoples' computers, possibly without them
#' realising, if you shared your script with others! For this reason, we generally install packages
#' directly from the console (the pane below).
#' 
#' One package (or rather, collection of packages) we will be using a lot is called the tidyverse.
#' The tidyverse contains a large number of additional functions that make reading data, creating
#' graphs, and manipulating columns and rows much easier.



#' Task: Install the tidyverse package by running install.packages("tidyverse") in the console below.
#' Note the " marks around the name of the package.




#' Check that the tidyverse package has installed using the 'Packages' tab of the lower right pane.


##########################################################---- Exercise 3.2: Using package functions.

#' Now that we have installed our first package, how do we use it? By default, R does not load 
#' package functions (other than base R functions) unless you tell it to. This is because different
#' package authors might have used the same names for their functions without knowing, which 
#' causes them to be overwritten and leaves you in a situation where it's hard to know why something
#' isn't working. 
#' 
#' If we want to use a package without loading all of its functions we can 'call' it using its name 
#' followed by two colons (::).
#' 
#' For example, we can run the 'tidyverse_logo()' function by running the following code:


tidyverse::tidyverse_logo()



#################################################################---- Exercise 4.1: Loading Packages.

#' However, we often do want to load all of the functions in a package, especially in the tidyverse
#' where they all work together. We can do this be 'taking the package out of the library' using
#' the library() function. For example, you can load the tidyverse package by running:

library(tidyverse)

#' You can now use all of the tidyverse functions without having to call the package first with
#' tidyverse:: ; for example:

tidyverse_logo()

######################################################---- Exercise 4.2: Using the tidyverse.

#' One of the most useful packages that the tidyverse includes is 'dplyr' - a package for the
#' manipulation of data. dplyr contains many functions that we will use, but one of interest 
#' is an alternative format to a dataframe called a 'tibble' that prints much more nicely 
#' than the default.
#' 
#' For example, let's try loading USArrests again but this time as a tibble using the as_tibble()
#' function.

USArrests_tibble <- as_tibble(USArrests)
USArrests_tibble

#' Notice how, rather than printing out the entire thing, it cuts off after ten entries as it 
#' assumes you probably don't need to see them all (whereas dataframe will print out hundreds
#' by default).
#' 
#' However, notice also that it has also removed the rownames (the US states). This is more a 
#' result of a poor decision by the creator of the USArrests dataset to use the row names to 
#' include important information. We can restore these names using the rownames_to_column()
#' function from the tibble package before we turn the data into a tibble

USArrests_2 <- rownames_to_column(USArrests)
USArrests_2 <- as_tibble(USArrests_2)
USArrests_2

#' As you might be seeing, this involves quite a lot of writing and rewriting to objects in the
#' environment, which can make it quite hard to read when you revisit it. The tidyverse also 
#' includes something called the 'magrittr' operator (%>%) -- sometimes called a pipe -- 
#' which allows you to 'pipe' the result from a previous function into the next function. 
#' For example, we can do the above two steps in one go with the following code:

rownames_to_column(USArrests) %>%
  as_tibble()

#' Notice that we do not need to repeat 'USArrests' in the second function in our chain, it 
#' assumes that the result from the last step is what is being used in the primary argument
#' for the next step. 
#' 
#' However, some functions do not play well with pipes and need you to be explicit about saying
#' that you want to use the results from the last step in an argument for the next step. You can
#' do this by using a full stop (.), which is used in a pipe to designate the result from the 
#' previous step.
#' 
#' For example:

rownames_to_column(USArrests) %>%
  as_tibble(x = .)



###############################################################---- Exercise 5: Reading External Data.

#' It is unlikely that we will be entering our data straight into R and stitching together vectors
#' into datasets, but knowing these basics is important to being able to diagnose errors and come
#' up with creative solutions to problems you might have for which you need to develop your
#' own functions.
#' 
#' Most of the time we will be reading in data that has been created and saved in another format.
#' 
#' Some common formats include:
#' 
#'   * .csv (Comma Separated Values)
#'   * .xls/.xlsx (Microsoft Excel file)
#'   * .sav (SPSS Data File)
#'   * .dta (Stata Data File)
#'
#' In the files you downloaded from Blackboard you should find three dataset files: MPs.csv,
#' simd.sav, and england-health-2011.dta 
#' 
#' Base R can read in .csv files without any additional packages, but simd.sav (a SPSS Data file)
#' and .dta (a Stata data file) will require us to load an additional package.
#' 
#' The base R way to read in a csv file is:

read.csv("MPs.csv")

#' The tidyverse way to read in a csv file is through the similarly names read_csv() - if in doubt
#' tidyverse always uses underscores (_) rather than full stops (.)

read_csv("MPs.csv")

#' As you can see, the tidyverse method reads in the script in the much more readable 'tibble'
#' format.
#' 
#' Task: Read in the MPs.csv file using read_csv() and save it to a new object called mp_data




#' To read in SPSS and Stata data files we will need to install the 'haven' package.
#' 
#' Task: Based on how you installed the tidyverse package, write into the *console* the script
#' required to install the haven package.



#' Task: Once you have installed the haven package, load it from the library using the same 
#' function you loaded the tidyverse with above. Remember to add this below (although, in
#' practice, we would try and group together all of our library() functions at the top of
#' our scripts).



#' Now that we've loaded haven we can use the read_dta and read_spss functions to read in our
#' simd.sav and england-health-2011.dta data files. You can view all of the functions in a 
#' package in Rstudio by typing in the package's name, followed by two colons ::, and then hitting
#' the tab key on your keyboard (above caps lock).
#' 
#' Let's load in the .sav file...

simd <- read_sav("simd.sav")
simd

#' Task: Now you write the script to read in the .dta file





#' Great - now we know how to read in data and use some basic functions and expressions in R.
#' Next week we will start applying statistical methods to the data we can read in.



####################################################################################---- End

#' Well done for getting this far! It is normal to be feeling anxious or overwhelmed about all
#' of this new information and about a skill that you haven't had the chance to develop yet.
#' 
#' Programming is best learned through persistence, immersion, experimentation, and repetition.
#' This is why it is so apt that we use the term 'programming languages'. Just like a language
#' you don't know, everything will feel unintelligible and overwhelming at first - different 
#' people will speak in slightly different ways and you will also have to wrestle with the 
#' subtleties of etiquette and cultural differences or preferences! Don't let the discomfort
#' of having to learn something so incredibly alien to you cause paralysis!
#' 
#' If you try to learn a little every day, revisit things you have learned regularly,
#' ask others for help (or google questions to see if someone else has asked and had them 
#' answered already - something we all do), you will eventually start building familiarity,
#' recall, and - eventually - fluency. Anyone can learn R with time, patience, initiative,
#' and guidance.

#######################################################################---- Week 1 Challenge

# Read in the pokemon.csv dataset, change the type1 column to a factor type 
# and then filter the dataset to include only bug type Pokemon (you will have to
# do your own independent reading to find out how to do this!)

# Then, write a help request post on the class discussion board (on Blackboard)
# about the first error you get (and how you fixed the bug, if you did fix it!)




