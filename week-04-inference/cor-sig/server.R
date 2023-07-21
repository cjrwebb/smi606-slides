#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(tidyverse)
library(janitor)

con_data <- read_csv("child-of-north-sample.csv")

# Shiny server logic
shinyServer(function(input, output) {


# Sampling and resampling functions ---------------------------------------

    # Initialise reactive values for holding all samples and current sample
    data_sample_idaci <- reactiveValues(idaci = numeric(), smoking_15_pc_2014 = numeric(), sample = numeric())
    old_samples       <- reactiveValues(idaci = numeric(), smoking_15_pc_2014 = numeric(), sample = numeric())
    
    
    # Random sample from data function
    sample_con <- function(sample = 60) {
        
        con_sample <- con_data %>% sample_n(size = sample)
        
        return(con_sample)
        
    }
    
    # Initial Sample
    initial_sample <- sample_con()
    
    data_sample_idaci$idaci <- initial_sample$idaci
    data_sample_idaci$smoking_15_pc_2014 <- initial_sample$smoking_15_pc_2014
    data_sample_idaci$sample <- 1
    
    # Initialise old samples
    old_samples$idaci <- initial_sample$idaci
    old_samples$smoking_15_pc_2014 <- initial_sample$smoking_15_pc_2014
    old_samples$sample <- rep(1, 60)
    
    # Function for clicking on the sample 30 neighbourhoods button
    observeEvent(input$sample30, {
        
        n_sample <- 30
        
        resample <- sample_con(n_sample)
        
        data_sample_idaci$idaci <- NULL
        data_sample_idaci$smoking_15_pc_2014 <- NULL
        data_sample_idaci$sample <- NULL
        
        data_sample_idaci$idaci <- resample$idaci
        data_sample_idaci$smoking_15_pc_2014 <- resample$smoking_15_pc_2014
        data_sample_idaci$sample <- max(old_samples$sample) + 1
        
        old_samples$idaci <- c(old_samples$idaci, data_sample_idaci$idaci)
        old_samples$smoking_15_pc_2014 <- c(old_samples$smoking_15_pc_2014, data_sample_idaci$smoking_15_pc_2014)
        old_samples$sample <- c(old_samples$sample, rep(data_sample_idaci$sample, n_sample))
        
        
    })
        
    # Function for clicking on the sample 60 neighbourhoods button
    observeEvent(input$sample60, {
        
        n_sample <- 60
        
        resample <- sample_con(n_sample)
        
        data_sample_idaci$idaci <- NULL
        data_sample_idaci$smoking_15_pc_2014 <- NULL
        data_sample_idaci$sample <- NULL
        
        data_sample_idaci$idaci <- resample$idaci
        data_sample_idaci$smoking_15_pc_2014 <- resample$smoking_15_pc_2014
        data_sample_idaci$sample <- max(old_samples$sample) + 1
        
        old_samples$idaci <- c(old_samples$idaci, data_sample_idaci$idaci)
        old_samples$smoking_15_pc_2014 <- c(old_samples$smoking_15_pc_2014, data_sample_idaci$smoking_15_pc_2014)
        old_samples$sample <- c(old_samples$sample, rep(data_sample_idaci$sample, n_sample))
        
        
    })
    
    # Function for clicking on the sample 200 neighbourhoods button
    observeEvent(input$sample100, {
        
        n_sample <- 100
        
        resample <- sample_con(n_sample)
        
        data_sample_idaci$idaci <- NULL
        data_sample_idaci$smoking_15_pc_2014 <- NULL
        data_sample_idaci$sample <- NULL
        
        data_sample_idaci$idaci <- resample$idaci
        data_sample_idaci$smoking_15_pc_2014 <- resample$smoking_15_pc_2014
        data_sample_idaci$sample <- max(old_samples$sample) + 1
        
        old_samples$idaci <- c(old_samples$idaci, data_sample_idaci$idaci)
        old_samples$smoking_15_pc_2014 <- c(old_samples$smoking_15_pc_2014, data_sample_idaci$smoking_15_pc_2014)
        old_samples$sample <- c(old_samples$sample, rep(data_sample_idaci$sample, n_sample))
        
    })
    
    # Function for sample 200
    observeEvent(input$sample200, {
        
        n_sample <- 200
        
        resample <- sample_con(n_sample)
        
        data_sample_idaci$idaci <- NULL
        data_sample_idaci$smoking_15_pc_2014 <- NULL
        data_sample_idaci$sample <- NULL
        
        data_sample_idaci$idaci <- resample$idaci
        data_sample_idaci$smoking_15_pc_2014 <- resample$smoking_15_pc_2014
        data_sample_idaci$sample <- max(old_samples$sample) + 1
        
        old_samples$idaci <- c(old_samples$idaci, data_sample_idaci$idaci)
        old_samples$smoking_15_pc_2014 <- c(old_samples$smoking_15_pc_2014, data_sample_idaci$smoking_15_pc_2014)
        old_samples$sample <- c(old_samples$sample, rep(data_sample_idaci$sample, n_sample))
        
    })
    
    # Function for sample 500
    observeEvent(input$sample500, {
        
        n_sample <- 500
        
        resample <- sample_con(n_sample)
        
        data_sample_idaci$idaci <- NULL
        data_sample_idaci$smoking_15_pc_2014 <- NULL
        data_sample_idaci$sample <- NULL
        
        data_sample_idaci$idaci <- resample$idaci
        data_sample_idaci$smoking_15_pc_2014 <- resample$smoking_15_pc_2014
        data_sample_idaci$sample <- max(old_samples$sample) + 1
        
        old_samples$idaci <- c(old_samples$idaci, data_sample_idaci$idaci)
        old_samples$smoking_15_pc_2014 <- c(old_samples$smoking_15_pc_2014, data_sample_idaci$smoking_15_pc_2014)
        old_samples$sample <- c(old_samples$sample, rep(data_sample_idaci$sample, n_sample))
        
        
    })
    
    # Reset function
    observeEvent(input$reset, {
        
        initial_sample <- sample_con()
        
        data_sample_idaci$idaci <- initial_sample$idaci
        data_sample_idaci$smoking_15_pc_2014 <- initial_sample$smoking_15_pc_2014
        data_sample_idaci$sample <- 1
        
        old_samples$idaci <- initial_sample$idaci
        old_samples$smoking_15_pc_2014 <- initial_sample$smoking_15_pc_2014
        old_samples$sample <- rep(1, 60)
        
    })
    


# Mean difference function ------------------------------------------------



    
    output$cor_results <- renderTable({
        
        n_samples_collected <- max(old_samples$sample, na.rm = TRUE)
        cor_sample <- cor(data_sample_idaci$idaci, data_sample_idaci$smoking_15_pc_2014, use = "complete.obs")
        sample_size <- length(data_sample_idaci$idaci)
        
        tibble(
            `Correlation between Poverty & Smoking` = cor_sample,
            `Sample size` = sample_size,
            `Total number of samples collected` = n_samples_collected
        )

        
    }, width = "100%")
    


    
# Plotting functions ------------------------------------------------------

# Plot sample

    # Not yet updated beyond here
    
    output$plot_samples <- renderPlot({
        
        sample_data <- tibble(
            idaci = data_sample_idaci$idaci,
            smoking = data_sample_idaci$smoking_15_pc_2014
        )
        
        sample_data %>%
            ggplot() +
            geom_point(aes(x = idaci, y = smoking)) +
            theme_minimal()
        
        
    })
    
    
    
# Plot correlations across all samples in histogram

    output$plot_cors <- renderPlot({
        
        all_cor_data <- tibble(
            idaci = old_samples$idaci,
            smoking = old_samples$smoking_15_pc_2014,
            sample = old_samples$sample
        ) %>%
            group_by(sample) %>%
            summarise(cor_idaci_smoking = cor(idaci, smoking, use = "complete.obs"))
        
        all_cor_data %>%
            ggplot() +
            geom_histogram(aes(x = cor_idaci_smoking), fill = "transparent", colour = "skyblue",
                           binwidth = 0.025) +
            geom_vline(xintercept = 0) +
            theme_minimal()
        
        
    })
    
    
# Cortest output ------------------------------------------------------
    
    output$cor_test <- renderPrint({
        
        sample_data <- tibble(
            idaci = data_sample_idaci$idaci,
            smoking = data_sample_idaci$smoking_15_pc_2014
        )
        
        cor.test(sample_data$idaci, sample_data$smoking, use = "complete.obs", method = "pearson")
       
    })
    

    
    
# Tester functions --------------------------------------------------------
    
    # Tester functions for printing current (working) and historic (old) data
    output$print_test <- renderTable({
        
        tibble(idaci = data_sample_idaci$idaci,
               smoking_15_pc_2014 = data_sample_idaci$smoking_15_pc_2014,
               sample = data_sample_idaci$sample
               ) 
        
    })
    
    output$print_test_olddata <- renderTable({
        
        tibble(idaci = old_samples$idaci,
               smoking_15_pc_2014 = old_samples$smoking_15_pc_2014,
               sample = old_samples$sample
        ) 
        
    })
    
    
    
})
