#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(tidyverse)
library(janitor)
library(learnr)


dashboardPage(
    dashboardHeader(),
    dashboardSidebar(
        sidebarMenu(
            menuItem("1: Dice Rolls", tabName = "dice", icon = icon("dice")),
            menuItem("2: Visualise", tabName = "visualise", icon = icon("chart-bar")),
            menuItem("3: Observed v. Expected", tabName = "compare", icon = icon("equals")),
            menuItem("4: Test", tabName = "test", icon = icon("question"))
        )
    ),
    dashboardBody(
        tabItems( # Tab content
            
            tabItem(tabName = "dice",
                    ######################## TAB DICE
                    ####### INPUT ELEMENTS: DICE ROLLING
                    fluidRow(
                    #### CONTENT
                    ### ROLL ONE TIME 
                    ### ROLL FIVE TIMES
                    ### ROLL TEN TIMES
                    ### RESET ON ROLL?
                        column(4, align = "center",
                               box(title = "Controls", width = 12,
                                   actionButton(inputId = "roll_one", "Roll One Time", width = '100%'),
                                   actionButton(inputId = "roll_five", "Roll Five Times", width = '100%'),
                                   actionButton(inputId = "roll_ten", "Roll Ten Times", width = '100%'),
                                   br(), br(),
                                   div(style = "display:inline-block;",
                                       radioButtons(inputId = "ui_reset", label = "Reset data on roll?", choiceNames = c("No", "Yes"), choiceValues = c(FALSE, TRUE), selected = FALSE, inline = TRUE, width = '100%')
                                   )
                                   ),
                               box(title = "Is my die fair or loaded?", width = 12,
                                   htmlOutput("ui_fair_or_loaded"))
                        ),
                        column(8,
                               box(title = "Dice Rolls Data", width = 12,
                                   div(style = "font-size: 18px;", htmlOutput("ui_data") )
                                   ),
                               box(title = "Tally of rolls", width = 12,
                                   div(style = "font-size: 18px;", tableOutput("ui_tally"), )
                                   )

                               )
                    )
                    
                    ),
            
            tabItem(tabName = "visualise",
                    ######################## TAB VISUALISE
                    #### CONTENT
                    ### Histogram of dice roll data
                    fluidRow(
                    column(2),
                    column(8,
                           box(title = "Histogram of Dice Rolls", width = 12,
                               plotOutput("ui_rollhist", width = "100%", height = "600px"))),
                    column(2)
                    )
            ),
            
            tabItem(tabName = "compare",
                    ######################## TAB COMPARE
                    #### CONTENT
                    ### OBSERVED HISTOGRAM
                    ### EXPECTED HISTOGRAM
                    
                    fluidRow(
                        column(6, box(title = "Histogram of Observed Dice Rolls", width = 12,
                                      plotOutput("ui_rollhist2", width = "100%", height = "500px"))),
                        column(6, box(title = "Histogram of Expected Dice Rolls (if Die was Fair)", width = 12,
                                      plotOutput("ui_rollhistexpected", width = "100%", height = "500px")))
                        
                    )
                    
                    
            ),
            
            tabItem(tabName = "test",
                    ######################## TAB TEST
                    
                    fluidRow(
                        column(2),
                        column(8, 
                               box(title = "Difference between our observed dice roll outcomes and what we would expect if the die were fair", width = 12,
                                   plotOutput("ui_histsuperimposed"))),
                        column(2)),
                    
                    fluidRow(
                        column(2),
                        column(8,
                               box(width = 12,
                                   title = "Testing whether the difference between our observed and expected scores is statistically significant in R",
                                   markdown("Is the difference between what we observed with our dice rolls and what we would expect if the die were completely fair **large enough** and **consistent enough** that we can be confident that it is loaded or unfair in some way? How can we quantify this difference and our confidence? We can test this with something called a **Chi-squared (χ2) goodness-of-fit test**. Follow the guided tutorial below to see an example of how to perform this test in R.")
                                   )
                               ),
                        column(2)
                    ),
                    
                    fluidRow(
                        column(2),
                        column(8,
                               box(width = 12,
                                   title = "Tutorial: Performing a Chi-Squared Goodness of Fit Test in R",
                                   markdown("### Setting up our Chi-Squared Test  
                                            We can use the `janitor` R package to perform a chi-squared test and to calculate the summary statistics it requires. 
                                            To calculate a chi-squared statistic and a p-value, we need to know two things: the number of rolls of each face that we would have *expected* in our entire sample *if the die were fair*, and the number of rolls for each face we *observed* from our sample.<br><br>
                                            We can start by summarising our frequency counts for each face of the die by using `janitor`'s `tabyl()` function. This function works just like `table()`, but outputs a tabyl/data.frame object rather that can be easier to work with than the base `table()`'s Table object. We save the results to a new object in our global environment called `dice_rolls_summary`.    
                                            \  
                                            \  "),
                                   br(),
                                   includeMarkdown(path = "codechunk-1.Rmd"),
                                   actionButton("ui_runcode1", label = "Run Code", icon = icon("redo"), width = "100%"),
                                   br(), br(),
                                   div(style = "text-align: left;",
                                       HTML("<code style = 'display:block; white-space: pre-wrap; text-indent:0; padding: 10px; background: black; text-align: left; color: white;'>"),
                                        h4("Output"),
                                        textOutput("ui_tabyl1"),
                                       HTML("</code>")
                                       ),
                                   markdown("<br>We know that if the die were fair, we would *expect* each face to be rolled an equal number of times. 
                                            This is easy to calculate because it is equal to the total number of rolls in our sample divided by the number of possible outcomes (faces). In this case, there are six faces on the die so, for example, if we rolled the die 60 times, we would expect each face to come up around 10 times in our sample. 
                                            <br><br>
                                            In this case, we can use `mutate()` from our `dplyr` package to add the expected counts to our new tabyl. We first use the `sum()` function to calculate the total, and then divide that by the number of faces on the die (6). We save the result in a new variable in the tabyl called `expected`. In this case, the expected count should be the same for every face. We overwrite our `dice_rolls_summary` object with our updated tabyl that includes expected counts.  
                                            "),
                                   br(),
                                   includeMarkdown(path = "codechunk-2.Rmd"),
                                   actionButton("ui_runcode2", label = "Run Code", icon = icon("redo"), width = "100%"),
                                   br(), br(),
                                   div(style = "text-align: left;",
                                       HTML("<code style = 'display:block; white-space: pre-wrap; text-indent:0; padding: 10px; background: black; text-align: left; color: white;'>"),
                                       h4("Output"),
                                       textOutput("ui_tabyl2"),
                                       HTML("</code>")
                                   ),
                                   br(),
                                   markdown("### Running our Chi-Squared Test
                                            <br>We've now completed all of the processing of the data we need to perform a chi-squared test in `R`. The chi-squared test is very versatile, and can be used to test a wide range of hypotheses. 
                                            Before we run our chi-squared test, we need to know exactly what it is testing. In this case, our chi-squared test is testing a null hypothesis that the die we are rolling is fair (and not loaded). In other words, that every face on the die has an equal chance of coming up from a roll. We can write our null hypothesis as:
                                            
                                            * H<sub>0</sub>: Every face on the die has an equal probability of being rolled.
                                              
                                            In R, chi-squared tests can be performed using the `chisq.test()` function, but we also need to provide it with some arguments that correspond with the hypothesis we are trying to test.<br><br>
                                            Remember, you can check the documentation for any function in `R` by typing `?` following by the function in the `R` console. Check the documentation for chi-squared test by typing `?chisq.test()` and clicking on link to the documentation for the function from the `stats` package.<br><br>
                                            There are three arguments we need to focus on for us to test whether our observed dice rolls are significantly different to what we would have expected to have observed if the die were fair: `x`, `p`, and `rescale.p`.  
                                              
                                            * `x` = A numeric vector of our *observed* counts.
                                            * `p` = A numeric vector of *probabilities* for each outcome *under our null hypothesis* (in this case, if our die is fair)
                                            * `rescale.p` = A logical value (*TRUE* or *FALSE*) for whether we are using *expected counts* in `p` that need to be transformed into probabilities first
                                              
                                            In this case, we know that our observed counts are stored in our summary data tabyl, and can be found in the `dice_rolls_summary$n` column. So in our chi-squared test function our argument for `x =` should be `dice_rolls_summary$n`. 
                                            We also know that we have a column for our expected counts that is saved to `dice_rolls_summary$expected`, so we can use that as our argument to `p =`. 
                                            We also know that these expected counts are not probabilities and need to be rescaled, so we will set the argument `rescale.p =` to `TRUE`.
                                            If we put that all together we get the following code:  
                                            "),
                                   br(),
                                   includeMarkdown(path = "codechunk-3.Rmd"),
                                   actionButton("ui_runcode3", label = "Run Code", icon = icon("redo"), width = "100%"),
                                   br(), br(),
                                   div(style = "text-align: left;",
                                       HTML("<code style = 'display:block; white-space: pre-wrap; text-indent:0; padding: 10px; background: black; text-align: left; color: white;'>"),
                                       h4("Output"),
                                       textOutput("ui_chisq"),
                                       HTML("</code>")
                                   ),
                                   br(),
                                   markdown("### Interpreting our test results  
                                            Let's recap what the output from our chi-squared test results mean:  
                                            
                                            * `X-squared` = This is the actual chi-squared statistic, it is used along with the degrees of freedom (df) to calculate a p-value for the test.
                                            * `df` = df stands for 'Degrees of Freedom' and is equal to the number of possible outcomes minus one. This value is used in many statistical tests to scale our p-value to account for the fact that larger samples are needed to test something that has a very large number of possible outcomes.
                                            * `p-value` = Our p-value is what we use to test our null hypothesis. In this case, that the die is fair. It tells us the probability that we would have observed the number of rolls of each face that we observed in our sample *if* the die *were* fair. A more general way to think of this is that it is the probability that the difference between what we observed and what we would have expected could have happened as a result of the randomness in our sample. For example, if we got a p-value of 0.5, this means we would expect to get this kind of deviation from what we would expect around 50 per cent of the time.
                                              
                                            It is typical to choose a 'cut-off' for our p-value under which we decide to reject the null hypothesis (that the die is fair), because we conclude that the probability of a sample with the characteristics we observed is so low that the null hypothesis could not possibly be the best explanation of the relationship we observe (that explanation being that all faces on a die have equal probabilities of being rolled). 
                                            Often in the social sciences we set this cut-off to 5%, or p = 0.05. This is sometimes called a 'critical value' or an 'alpha'.  
                                            
                                            Why 5%? There is no strong reason, but the practice of setting our confidence value to 5% emerged from it being viewed as the best balance between risks of a Type I error - rejecting a true null hypothesis by mistake - and a Type II error - failing to reject a false null hypothesis.
                                              
                                            If the p-value for our test is less than 0.05 (sometimes written as p < 0.05), we should reject the null hypothesis that the die is fair. Remember that sometimes p-values can be very small and may be output in R using scientific notation. For example, 5e-12 which means five times ten to the power of negative 12 (5 * 10^-12), which is equal to 0.000000000005. Some people like to think of this as '5 with 12 zeroes in front', which is fine but don't forget that the first of those zeroes has a decimal point after it!"),
                                   br(),
                                   markdown("### Questions and reflections
                                            
                                            * Given the result above, should the null hypothesis that the die is fair be rejected or not?
                                            * What does this imply about our die? Do you think it fair or loaded?
                                            * Check whether your die was fair or loaded on the first tab: was your guess from observing the rolls and the data correct? Was what the chi-squared test result suggested correct?
                                            * Try resetting the web page/roll counter and seeing how the p-value changes as you increase or decrease the number of rolls. What happens?
                                            * Thinking about the last question and the first exercise, how does this match up to your own confidence about whether you feel the die is loaded or fair as you continue to roll it? 
                                            
                                            ")
                                   

                                   )),
                        column(2)
                    )
                    
                    
            )
            
        )
    )
)