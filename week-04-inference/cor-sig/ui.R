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
            menuItem("1: Sampling", tabName = "sample", icon = icon("console", lib = "glyphicon")),
            menuItem("2: Plots", tabName = "plots", icon = icon("console", lib = "glyphicon")),
            menuItem("3: All Correlations Plot", tabName = "corplots", icon = icon("console", lib = "glyphicon")),
            menuItem("4: Correlation Significance", tabName = "cortest", icon = icon("console", lib = "glyphicon"))
        )
    ),
    dashboardBody(
        tabItems( # Tab content
            
            tabItem(tabName = "sample",
                    ######################## ANOVA Resampling
                    ####### INPUT ELEMENTS: RESAMPLING
                    fluidRow(
                        column(2),
                        column(7,
                               HTML("<h3>Are children living in more deprived neighbourhoods more or less likely to smoke cigarettes at age 15?</h3><br>")
                               ),
                        column(3)
                    ),
                    fluidRow(
                    #### CONTENT
                    ### Sample 100 neighbourhoods
                    ### Sample 200 neighbourhoods
                    ### Sample 300 neighbourhoods
                    ### Reset
                        column(6, # Correlation results
                               
                               box(title = "Results", width = "100%",
                                   tableOutput("cor_results"))
                               
                               ),
                        column(6,
                               box(title = "Collect a new sample of neighbourhoods", width = "100%",
                               HTML("In this example, we are trying to determine whether rates of child poverty are higher in neighbourhoods in the North of England or whether they are higher in neighbourhoods in the South of England.<br>
                                    We have some arbitrary restrictions on how many neighbourhoods we can sample. You can click the below resample buttons as many times as you like to collect more samples."),
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
                        column(2),
                        column(7, box(width = "100%", plotOutput("plot_samples"))),
                        column(3)
                    )
                    
                ),
            
            tabItem(tabName = "corplots",
                    fluidRow(
                        column(2),
                        column(7, box(width = "100%", plotOutput("plot_cors"))),
                        column(3)
                    )
                    
            ),
            
            tabItem(tabName = "cortest",
                    fluidRow(
                        column(2),
                        column(7,
                               box(width = "100%",
                                   HTML("
                                        
                                        <h3>Testing the statistical significance of a correlation</h3>
                                        
                                        The statisical significance of a correlation is tested using t-statistic which tests the following null hypothesis:
                                        <br><br>
                                        
                                        <ul>
                                        <li>H<sub>0</sub>: The population correlation coefficient is not significantly different from zero.</li>
                                        </ul>
                                        <br>
                                        The t-statistic uses the nature of normally distributed correlation coefficients around specific sample sizes to make this inference. See the histogram of all of the multiple samples you have taken on Tab 3.
                                        <br><br>
                                        We can get the results from this test in R using the following code:
                                        
                                        <code style = 'display:block; white-space: pre-wrap; text-indent:0; padding: 10px; background: black; text-align: left; color: white;'>
cor.test(sample_data$idaci, sample_data$smoking, use = 'complete.obs', method = 'pearson')
                                        </code>
                                        <br><br>
                                        For the sample you last 'collected', the correlation t-test results were:
                                        <br><br>
                                        
                                        "),
                                   
                                   verbatimTextOutput("cor_test"),
                                   HTML("
                                        
                                        <br><br>
                                        This test gives us a range of information in the output, including:
                                        
                                        <ul>
                                        <li>t statistic: t statistic used to calculate p-value</li>
                                        <li>df: Degrees of freedom (sample size minus 2)</li>
                                        <li>p-value: p-value for comparing with critical value</li>
                                        <li>95 percent confidence interval: range of sample correlation coefficients within 95% of the estimated normal distribution based on this sample's mean</li>
                                        </ul>
                                        
                                        <br>
                                        
                                        When reporting results you should report the t-statistic and degrees of freedom as well as the p-value so that readers can check that the p-value calculation is accurate (if they wish to).
                                        
                                        <br><br>
                                        
                                        If the p-value is less than the critical value for your study (usually 0.05), this means that we would not expect to see a correlation coefficient of this magnitude (in either direction) with a sample size this large if the correlation in the population as a whole was actually zero. In 
                                        other words, this result would be very unlikely if the reality is that there was no relationship between the two variables. As such, we can reject the null hypothesis.
                                        
                                        <br><br>
                                        
                                        If the p-value is greater than the critical value for the study (again, usually 0.05), we would fail to reject the null hypothesis as the correlation we observed in our sample is 
                                        within the realms of what we would be likely to observe if the overall relationship between the two values in the population was zero.
                                        
                                        <h3>Tasks</h3>
                                        
                                        <ul>
                                        <li>Practice interpreting the p-value and correlation coefficient for multiple different samples of the data.</li>
                                        <li>Try collecting lots of samples at each level of sample size (30, 60, 100, 200, 500) — for example, 50 to 100 of each — what happens to the distribution of correlation coefficients across all the samples as the sample size of each is increased?</li>
                                        </ul>
                                        
                                        
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
