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
    data_sample_idaci <- reactiveValues(idaci = numeric(), north = logical(), sample = numeric())
    old_samples       <- reactiveValues(idaci = numeric(), north = logical(), sample = numeric())
    
    
    # Random sample from data function
    sample_con <- function(sample = 60) {
        
        sample_split_n = sample/2
        
        con_sample <- con_data %>% group_by(north) %>% sample_n(size = sample_split_n)
        
        return(con_sample)
        
    }
    
    # Initial Sample
    initial_sample <- sample_con()
    
    data_sample_idaci$idaci <- initial_sample$idaci
    data_sample_idaci$north <- initial_sample$north
    data_sample_idaci$sample <- 1
    
    # Initialise old samples
    old_samples$idaci <- initial_sample$idaci
    old_samples$north <- initial_sample$north
    old_samples$sample <- rep(1, 60)
    
    # Function for clicking on the sample 30 neighbourhoods button
    observeEvent(input$sample30, {
        
        n_sample <- 30
        
        resample <- sample_con(n_sample)
        
        data_sample_idaci$idaci <- NULL
        data_sample_idaci$north <- NULL
        data_sample_idaci$sample <- NULL
        
        data_sample_idaci$idaci <- resample$idaci
        data_sample_idaci$north <- resample$north
        data_sample_idaci$sample <- max(old_samples$sample) + 1
        
        old_samples$idaci <- c(old_samples$idaci, data_sample_idaci$idaci)
        old_samples$north <- c(old_samples$north, data_sample_idaci$north)
        old_samples$sample <- c(old_samples$sample, rep(data_sample_idaci$sample, n_sample))
        
        
    })
        
    # Function for clicking on the sample 60 neighbourhoods button
    observeEvent(input$sample60, {
        
        n_sample <- 60
        
        resample <- sample_con(n_sample)
        
        data_sample_idaci$idaci <- NULL
        data_sample_idaci$north <- NULL
        data_sample_idaci$sample <- NULL
        
        data_sample_idaci$idaci <- resample$idaci
        data_sample_idaci$north <- resample$north
        data_sample_idaci$sample <- max(old_samples$sample) + 1
        
        old_samples$idaci <- c(old_samples$idaci, data_sample_idaci$idaci)
        old_samples$north <- c(old_samples$north, data_sample_idaci$north)
        old_samples$sample <- c(old_samples$sample, rep(data_sample_idaci$sample, n_sample))
        
        
    })
    
    # Function for clicking on the sample 200 neighbourhoods button
    observeEvent(input$sample100, {
        
        n_sample <- 100
        
        resample <- sample_con(n_sample)
        
        data_sample_idaci$idaci <- NULL
        data_sample_idaci$north <- NULL
        data_sample_idaci$sample <- NULL
        
        data_sample_idaci$idaci <- resample$idaci
        data_sample_idaci$north <- resample$north
        data_sample_idaci$sample <- max(old_samples$sample) + 1
        
        old_samples$idaci <- c(old_samples$idaci, data_sample_idaci$idaci)
        old_samples$north <- c(old_samples$north, data_sample_idaci$north)
        old_samples$sample <- c(old_samples$sample, rep(data_sample_idaci$sample, n_sample))
        
    })
    
    # Function for sample 200
    observeEvent(input$sample200, {
        
        n_sample <- 200
        
        resample <- sample_con(n_sample)
        
        data_sample_idaci$idaci <- NULL
        data_sample_idaci$north <- NULL
        data_sample_idaci$sample <- NULL
        
        data_sample_idaci$idaci <- resample$idaci
        data_sample_idaci$north <- resample$north
        data_sample_idaci$sample <- max(old_samples$sample) + 1
        
        old_samples$idaci <- c(old_samples$idaci, data_sample_idaci$idaci)
        old_samples$north <- c(old_samples$north, data_sample_idaci$north)
        old_samples$sample <- c(old_samples$sample, rep(data_sample_idaci$sample, n_sample))
        
    })
    
    # Function for sample 500
    observeEvent(input$sample500, {
        
        n_sample <- 500
        
        resample <- sample_con(n_sample)
        
        data_sample_idaci$idaci <- NULL
        data_sample_idaci$north <- NULL
        data_sample_idaci$sample <- NULL
        
        data_sample_idaci$idaci <- resample$idaci
        data_sample_idaci$north <- resample$north
        data_sample_idaci$sample <- max(old_samples$sample) + 1
        
        old_samples$idaci <- c(old_samples$idaci, data_sample_idaci$idaci)
        old_samples$north <- c(old_samples$north, data_sample_idaci$north)
        old_samples$sample <- c(old_samples$sample, rep(data_sample_idaci$sample, n_sample))
        
    })
    
    # Reset function
    observeEvent(input$reset, {
        
        initial_sample <- sample_con()
        
        data_sample_idaci$idaci <- initial_sample$idaci
        data_sample_idaci$north <- initial_sample$north
        data_sample_idaci$sample <- 1
        
        old_samples$idaci <- initial_sample$idaci
        old_samples$north <- initial_sample$north
        old_samples$sample <- rep(1, 60)
        
    })
    


# Mean difference function ------------------------------------------------


    output$mean_diff <- renderTable({
        
        tibble(idaci = data_sample_idaci$idaci,
               north = data_sample_idaci$north,
               sample = data_sample_idaci$sample
        ) %>%
            group_by(north) %>%
            summarise(`Child Poverty Rate` = mean(idaci, na.rm=TRUE)) %>%
            rename(`North?` = north) 
        
    }, width = "100%")
    
    output$number_samples <- renderText({
        
        n_samples_collected <- max(old_samples$sample, na.rm = TRUE)
        
        n_samples_collected
        
    })

    
# Plotting functions ------------------------------------------------------

# Plot sample

    output$plot_samples <- renderPlot({
        
        all_data <- tibble(idaci = data_sample_idaci$idaci,
               north = data_sample_idaci$north,
               sample = data_sample_idaci$sample
        ) %>%
            mutate(
                north = ifelse(north == TRUE, "North", "South")
            )
        
        grouped_data <- tibble(idaci = data_sample_idaci$idaci,
               north = data_sample_idaci$north,
               sample = data_sample_idaci$sample
        ) %>%
            mutate(
                north = ifelse(north == TRUE, "North", "South")
            ) %>%
            group_by(north) %>%
            summarise(mean_idaci = mean(idaci, na.rm = TRUE))
        
        
        all_data  %>%
            ggplot() +
            geom_histogram(aes(x = idaci, col = north), binwidth = 5, fill = "transparent") +
            facet_grid(rows = vars(north)) +
            geom_vline(data = grouped_data, aes(xintercept = mean_idaci)) +
            theme_minimal() +
            ggtitle("North and South Histograms for this Sample (Vertical Line = Mean)")
        
    })
    
    
# Plot means from all samples
    
    output$plot_means <- renderPlot({
        
        means_data <- tibble(idaci = old_samples$idaci,
                             north = old_samples$north,
                             sample = old_samples$sample
                             ) %>%
                      mutate(
                            north = ifelse(north == TRUE, "North", "South")
                            ) %>%
                      group_by(sample, north) %>%
                      summarise(
                              mean_idaci = mean(idaci, na.rm = TRUE)
                               )
        
        means_data %>%
            ggplot() +
            geom_histogram(aes(x = mean_idaci, col = north), binwidth = 0.5, fill = "transparent") +
            facet_grid(rows = vars(north)) +
            theme_minimal() +
            ggtitle("Means of all samples")
        
    })
    
# Plot mean difference

    output$meandif_plot <- renderPlot({
        
        means_data <- tibble(idaci = old_samples$idaci,
                             north = old_samples$north,
                             sample = old_samples$sample
        ) %>%
            mutate(
                north = ifelse(north == TRUE, "North", "South")
            ) %>%
            group_by(sample, north) %>%
            summarise(
                mean_idaci = mean(idaci, na.rm = TRUE)
            )
        
        means_data <- means_data %>%
            ungroup() %>%
            group_by(sample) %>%
            summarise(mean_diff = mean_idaci[1] - mean_idaci[2])
        
        means_data %>%
            ggplot() +
            geom_histogram(aes(x = mean_diff), col = "skyblue", binwidth = 0.5, fill = "transparent") +
            theme_minimal() +
            geom_vline(xintercept = 0) +
            ggtitle("Mean difference between North and South") +
            scale_x_continuous(breaks = seq(-20, 20, 2))
        
        
    })
    
    
# ANOVA output ------------------------------------------------------
    
    output$anova_test <- renderPrint({
        
        sample_data <- tibble(idaci = data_sample_idaci$idaci,
               north = data_sample_idaci$north,
               sample = data_sample_idaci$sample
        ) %>%
            mutate(
                north = ifelse(north == TRUE, "North", "South")
            )
        
        sample_aov <- aov(idaci ~ north, data = sample_data)
        
        summary(sample_aov)
        
    })
    
    
    output$tukey_hsd <- renderPrint({
        
        sample_data <- tibble(idaci = data_sample_idaci$idaci,
                              north = data_sample_idaci$north,
                              sample = data_sample_idaci$sample
        ) %>%
            mutate(
                north = ifelse(north == TRUE, "North", "South")
            )
        
        sample_aov <- aov(idaci ~ north, data = sample_data)
        
        TukeyHSD(sample_aov)
        
    })
    
    
# Tester functions --------------------------------------------------------
    
    # Tester functions for printing current (working) and historic (old) data
    output$print_test <- renderTable({
        
        tibble(idaci = data_sample_idaci$idaci,
               north = data_sample_idaci$north,
               sample = data_sample_idaci$sample
               ) 
        
    })
    
    output$print_test_olddata <- renderTable({
        
        tibble(idaci = old_samples$idaci,
               north = old_samples$north,
               sample = old_samples$sample
        ) 
        
    })
    
    
    
})
