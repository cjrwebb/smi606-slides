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
library(learnr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    
    # Dice roll functions - Set up
        # Initiate dice rolls environment variable to be empty
    dice_rolls <- reactiveValues(rolls = numeric())
        # Randomly set whether the dice will be fair or loaded on startup
    fair <- sample(c(TRUE, FALSE), 1, replace = TRUE)
    
    # Dice roll functions - dice rolling
    roll_dice <- function(nrolls = 1, fair_die = fair) {
        
        if (fair_die == TRUE) {
        
            sample(x = 1:6, size = nrolls, replace = TRUE)
            
        } else {
            
            sample(x = 1:6, size = nrolls, replace = TRUE, prob = c(0.05, 0.1, 0.15, 0.2, 0.2, 0.3))
            
        }
        
        
    }
    
    # Dice roll functions - Collecting dice roll data
    add_dice_rolls <- function(nrolls = 1, reset = FALSE) {
        
        if (reset == FALSE) {
            
            dice_rolls$rolls <- c(dice_rolls$rolls, roll_dice(nrolls))
            
        } else {
            
            dice_rolls$rolls <- roll_dice(nrolls)
            
        }
        
    }
    
    output$ui_data <- renderText({
        
        paste(dice_rolls$rolls)
        
    })
    
    output$ui_fair_or_loaded <- renderText({
        
        paste("<details><summary>Click to reveal whether your die is fair or loaded.</summary>", 
              ifelse(fair == FALSE, "<details><summary>Are you sure you want to know? No cheating!</summary><br>Your die is loaded! It is more likely to roll high numbers.</details>", 
                                    "<details><summary>Are you sure you want to know? No cheating!</summary><br>Your die is fair! It is not any more likely to roll one number any more often than another.</details>"), 
              "</details>")
        
    })
    
    
    observeEvent(input$roll_one, {
        
        dice_rolls$rolls <- add_dice_rolls(1, reset = input$ui_reset)
        
    })
    
    observeEvent(input$roll_five, {
        
        dice_rolls$rolls <- add_dice_rolls(5, reset = input$ui_reset)
        
    })
    
    observeEvent(input$roll_ten, {
        
        dice_rolls$rolls <- add_dice_rolls(10, reset = input$ui_reset)
        
    })
    
    output$ui_rollhist <- renderPlot({
        
        tibble(rolls = dice_rolls$rolls) %>%
            ggplot() +
            geom_histogram(aes(x = rolls),  fill = "#028EC1", size = 3, colour = "white", bins = 6) +
            theme_minimal() +
            ylab("Frequency Count") +
            xlab("Number on the Die") +
            scale_x_continuous(breaks = seq(1, 6, 1)) +
            theme(text = element_text(size = 18))
        
    })
    
    output$ui_rollhist2 <- renderPlot({
        
        tibble(rolls = dice_rolls$rolls) %>%
            ggplot() +
            geom_histogram(aes(x = rolls),  fill = "#028EC1", size = 3, colour = "white", bins = 6) +
            theme_minimal() +
            ylab("Frequency Count") +
            xlab("Number on the Die") +
            scale_x_continuous(breaks = seq(1, 6, 1)) +
            theme(text = element_text(size = 18))
        
    })
    
    output$ui_tally <- renderTable(
        
        tibble(rolls = dice_rolls$rolls) %>% 
            janitor::tabyl(rolls) %>%
            as_tibble() %>%
            mutate(percent = percent*100,
                   rolls = as.integer(rolls),
                   n = as.integer(n)) %>%
            rename(`Roll outcome` = rolls, `Number of times rolled` = n, `Percent of all rolls (%)` = percent)

    )
    
    
    output$ui_rollhistexpected <- renderPlot({
        
        number_of_rolls <- length(dice_rolls$rolls)
        expected_per_face <- number_of_rolls/6
        
        roll_tally <- tibble(rolls = dice_rolls$rolls) %>% 
            janitor::tabyl(rolls) %>% as_tibble(.)
        
        tibble(rolls = 1:6,
               count = expected_per_face) %>%
            ggplot() +
            geom_histogram(aes(x = rolls, y = count), stat = "identity", 
                           fill = "#606061", size = 3, colour = "white", bins = 6) +
            theme_minimal() +
            ylab("Frequency Count") +
            xlab("Number on the Die") +
            scale_x_continuous(breaks = seq(1, 6, 1)) +
            scale_y_continuous(limits = c(0, max(roll_tally$n))) + # make sure y limits match observed
            theme(text = element_text(size = 18))
        
    })
    
    output$ui_histsuperimposed <- renderPlot({
        
        number_of_rolls <- length(dice_rolls$rolls)
        expected_per_face <- number_of_rolls/6
        
        observed_rolls <- tibble(rolls = dice_rolls$rolls) %>% 
            janitor::tabyl(rolls) %>% select(-percent) %>% as_tibble(.)
        
        expected_rolls <- tibble(rolls = 1:6,
               n = expected_per_face)
        
        diff_rolls <- expected_rolls %>% select(-rolls)
        
        diff_rolls$n <- observed_rolls$n - expected_rolls$n
        
        o_e_data <- bind_cols(observed_rolls, expected_rolls, diff_rolls, .name_repair = "unique") %>%
            rename(observed_face = 1, observed_n = 2,
                   expected_face = 3, expected_n = 4,
                   diff_n = 5)
        
        o_e_data <- o_e_data %>%
            mutate(
                diff_negative = ifelse(diff_n < 0, TRUE, FALSE),
                ostack1 = ifelse(diff_n < 0, observed_n, observed_n - diff_n),
                ostack2 = abs(diff_n), # absolute difference to stack on top
                stack_id = ifelse(diff_negative == TRUE, "mediumorchid", "skyblue1")
            )
        
        tibble(
            face = c(o_e_data$expected_face, o_e_data$expected_face),
            n = c(o_e_data$ostack1, o_e_data$ostack2),
            stack = c(rep("#028EC1", 6), o_e_data$stack_id)
        ) %>%
            mutate(stack = factor(stack, levels = c("mediumorchid", "skyblue1", "#028EC1")),
                   alpha = ifelse(stack == "#028EC1", 1,
                                  ifelse(stack == "skyblue1", 1, 0.5))) %>%
            ggplot() +
            geom_histogram(aes(x = face, y = n, fill = stack, alpha = alpha), stat = "identity") +
            scale_fill_identity() +
            scale_alpha_identity() +
            theme_minimal() +
            ylab("Frequency Count") +
            xlab("Number on the Die") +
            scale_x_continuous(breaks = seq(1, 6, 1)) +
            theme(text = element_text(size = 18))
        
        
        
    })
    
    
    observeEvent(input$ui_runcode1, {
    
    output$ui_tabyl1 <- renderPrint({
        
        dice_rolls_summary <- tabyl(isolate(dice_rolls$rolls)) # Isolate stops output from updating unless button is clicked
        dice_rolls_summary
        
    }) })
    
    
    observeEvent(input$ui_runcode2, {
        
    output$ui_tabyl2 <- renderPrint({
        
        dice_rolls_summary <- tabyl(isolate(dice_rolls$rolls))
        
        dice_rolls_summary <- dice_rolls_summary %>%
            mutate(expected = sum(n) / 6)
        dice_rolls_summary
        
    }) 
    
    })
    
    
    observeEvent(input$ui_runcode3, { 
        
    output$ui_chisq <- renderPrint({
        
        dice_rolls_summary <- tabyl(isolate(dice_rolls$rolls))
        
        dice_rolls_summary <- dice_rolls_summary %>%
            mutate(expected = sum(n) / 6)

        chisq.test(x = dice_rolls_summary$n, p = dice_rolls_summary$expected, rescale.p = TRUE)
        
    }) })
    
    
})
