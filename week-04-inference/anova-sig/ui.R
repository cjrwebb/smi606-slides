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

dashboardPage(
    dashboardHeader(),
    dashboardSidebar(
        sidebarMenu(
            menuItem("1: Sampling", tabName = "anova", icon = icon("console", lib = "glyphicon")),
            menuItem("2: Plots", tabName = "plots", icon = icon("console", lib = "glyphicon")),
            menuItem("3: Mean Diff Plot", tabName = "meandif_plot", icon = icon("console", lib = "glyphicon")),
            menuItem("4: ANOVA test", tabName = "anova_test", icon = icon("console", lib = "glyphicon"))
        )
    ),
    dashboardBody(
        tabItems( # Tab content
            
            tabItem(tabName = "anova",
                    ######################## ANOVA Resampling
                    ####### INPUT ELEMENTS: RESAMPLING
                    fluidRow(
                        column(2),
                        column(7, 
                               HTML("<h3>Are children more likely to live in deprived neighbourhoods in the North of England or in the South of England?</h3>")
                        ),
                        column(3)
                             ),
                    fluidRow(
                    #### CONTENT
                    ### Sample 100 neighbourhoods
                    ### Sample 200 neighbourhoods
                    ### Sample 300 neighbourhoods
                    ### Reset
                        column(6, 
                               box(width = "100%",
                                   title = "Last Sample Means",
                               HTML("Below are the mean values for the North and South of England's IDACI Score showing the percentage of children living in poverty for the average North and South neighbourhood in the last sample.<br>"),
                               tableOutput("mean_diff"),
                               HTML("<b>Number of samples collected</b>"),
                               textOutput("number_samples")
                               )),
                        column(6,
                               box(title = "Collect a new sample of neighbourhoods", width = "100%",
                               HTML("In this example, we are trying to determine whether rates of child poverty are higher in neighbourhoods in the North of England or whether they are higher in neighbourhoods in the South of England.<br>
                                    We have some arbitrary restrictions on how many neighbourhoods we can sample. You can click the below resample buttons as many times as you like to collect more samples.<br>"),
                               actionButton("sample30", label = "Re-sample with 30 Neighbourhoods", width = "100%"),
                               actionButton("sample60", label = "Re-sample with 60 Neighbourhoods", width = "100%"),
                               actionButton("sample100", label = "Re-sample with 100 Neighbourhoods", width = "100%"),
                               actionButton("sample200", label = "Re-sample with 200 Neighbourhoods", width = "100%"),
                               actionButton("sample500", label = "Re-sample with 500 Neighbourhoods", width = "100%"),
                               actionButton("reset", label = "Reset all samples", width = "100%")
                               )
                               )
                    
                    )
                    
                ),
            
            tabItem(tabName = "plots",
                    fluidRow(
                        column(6, box(width = "100%", plotOutput("plot_samples"))),
                        column(6, box(width = "100%", plotOutput("plot_means")))
                    )
                    
                ),
            
            tabItem(tabName = "meandif_plot",
                    fluidRow(
                        column(2),
                        column(7, box(width = "100%", plotOutput("meandif_plot"))),
                        column(3)
                    )
                    
            ),
            
            tabItem(tabName = "anova_test",
                    fluidRow(
                        column(2),
                        column(7, box(width = "100%", 
                                      HTML("
                                           
                                           <h3>ANOVA (Analysis of Variance) Test</h3>
                                           
                                           A relevant statistical test for testing the statistical significance of the mean of a continuous variable across different groups (either a categorical/nominal or ordinal variable) is the ANOVA test — when you have only two groups you can also use the Student's t-test.
                                           <br><br>
                                           An ANOVA test tests the following null hypothesis:
                                           <br><br>
                                           H<sub>0</sub>: The difference between the means of all groups in a continuous dependent variable is equal to zero.
                                           <br><br>
                                           In other words, that there is no difference on average in the scores of a continuous dependent variable. 
                                           Here, our continuous dependent variable is the Income Deprivation Affecting Children Index for neighbourhoods and our grouping categorical variable is whether the neighbourhood is in the North or the South of England.
                                           <br><br>
                                           We can run an ANOVA test in R using the following code: 
                                           <br><br>
                                           <code style = 'display:block; white-space: pre-wrap; text-indent:0; padding: 10px; background: black; text-align: left; color: white;'>
idaci_aov <- aov(idaci ~ north, data = sample_data)<br>
summary(idaci_aov)
                                           </code>
                                           <br><br>
                                           For the last sample of data you collected, this gives us the following output:
                                           <br><br>
                                           "),
                                      verbatimTextOutput("anova_test"),
                                      HTML("
                                           <br><br>
                                           
                                           The <code>aov()</code> function gives us the following output:
                                           <br>
                                           
                                           <ul>
                                             <li>Df</li>
                                             <li>Sum Sq</li>
                                             <li>Mean Sq</li>
                                             <li>F value</li>
                                             <li>Pr(>F)</li>
                                           </ul>
                                           
                                           The important output for here is the F value and the Pr(>F) value. 
                                           <br><br>
                                           The Pr(>F) value is the p-value from our ANOVA test. If this value is less than our critical value (usually 0.05), we would reject the null hypothesis that the difference between the groups is zero.
                                           <br><br>
                                           If you resampled a large number of samples you should be able to see that this probability approximately matches up with what we would expect from a normal distribution curve drawn on top of all of the resampled mean differences.
                                           <br><br>
                                           <h3>Multiple Comparisons</h3>
                                           
                                           You may have noticed a problem with the ANOVA test that you could come across: what happens if you have multiple groups but only one pair of them differs significantly?
                                           Under a standard ANOVA F test, you will get a significant value if any of the groups mean values differ consistently and/or by a large amount — but this doesn't tell you which ones!
                                           <br><br>
                                           We can use a 'postestimation' test called Tukey's Honest Significant Differences (HSD) test to identify which of our groups differ significantly. In this example, it is not really relevant as we only have two groups, so if we have a significant ANOVA test we know that the difference is between the North and South. However, we can still run the Tukey HSD test.
                                           <br><br>
                                           We can run a Tukey HSD postestimation test in R using the following code and the <code>TukeyHSD()</code> function: 
                                           <br><br>
                                           <code style = 'display:block; white-space: pre-wrap; text-indent:0; padding: 10px; background: black; text-align: left; color: white;'>
idaci_aov <- aov(idaci ~ north, data = sample_data)<br>
TukeyHSD(idaci_aov)
                                           </code>
                                           <br><br>
                                           This code gives us the following output, when run on the last random sample of neighbourhoods you 'collected':
                                           <br><br>
                                           
                                           "),
                                      verbatimTextOutput("tukey_hsd"),
                                      HTML("
                                           
                                           <br><br>
                                           
                                           The Tukey HSD test gives us a table with rownames representing each comparison of groups and the following columns:
                                           
                                           <ul>
                                            <li>diff: The difference between the two groups means</li>
                                            <li>lwr: The lower bound of the predicted 95% of differences between the means</li>
                                            <li>upr: The upper bound of the predicted 95% of differences between the means</li>
                                            <li>p adj: The adjusted p-value for the difference in means between the groups</li>
                                           </ul>
                                           
                                           <br>
                                           
                                           Here, the lwr and upr parts of the table tell you the predicted 95% range of values around the mean difference identified in your sample, assuming that these differences are normally distributed.
                                           <br><br>
                                           Again, the important part here is the p-value. This is interpreted in the same way as the general ANOVA test above, but now the null hypothesis relates to the specific comparison being made rather than just a test of whether there are any statistically significant differences between all groups that could be compared.
                                           
                                           <h3>Tasks</h3>
                                           
                                           <ul>
                                            <li>Practice running some different resamples and interpreting the p-values that result</li>
                                            <li>What happens to the p-values on average when you collect a larger sample compared to a smaller one?</li>
                                            <li>Collect a large number of samples of different sizes (e.g. 50-100 samples) and see how well the distribution of mean differences in tab 3 matches up with the p-values from the ANOVA and TukeyHSD tests</li>
                                            <li>Try and get a small difference in means in a random sample and then compare how the p-value changes with a large difference in means from a random sample of the same size.</li>
                                           </ul>
                                           
                                           <br><br><br><br><br>
                                           
                                           ")
                                      )
                               ),
                        column(3)
                    ),
                    fluidRow(
                        #column(6, tableOutput("print_test")),
                        #column(6, tableOutput("print_test_olddata"))
                    )
                    
            )
                    
                    
                    
            )
            
        )
    )
