#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Visualizing confidence intervals for proportions"),

    # Sidebar with all inputs
        sidebarPanel(
          h4("Select the following inputs:"),
          sliderInput("p",
                       "True population proportion:",
                       min = .01,
                       max = .90,
                       value = .5,
                       step = .01),
          sliderInput("n",
                      "Sample size:",
                      min = 5, 
                      max = 1000,
                      value = 20, 
                      step = 5),
          sliderInput("confLevel",
                        "Confidence level:",
                        min = .01,
                        max = .99,
                        value = .95, 
                        step = .01),
          sliderInput("numInt",
                      "Number of CIs:",
                      min = 1,
                      max = 200,
                      value = 1, 
                      step = 1),
          actionButton(inputId = 'goButton', label = 'Generate CIs!'),
          h4("Sample Size Check - "),
          h5("Does the CLT apply?"),
          textOutput('check')
        ),
    mainPanel(
        h3("Using this app:"),
        p("This app is designed to help you appreciate and understand what the 
          confidence level of a confidence interval actually means."),
        p("Recall that the confidence level refers to the proportion of all intervals 
          that would capture the true population parameter 
          if we actually knew it."),
        p("With this app you can experiment and play with this idea by randomly 
          generating a user-defined number confidence intervals. The app displays a plot 
          showing each of the confidence intervals and colors the intervals accoring to 
          whether or not they capture the true population proportion."),
        p("To get started, use the sliders to the left to select the population proportion,
          sample size, confidence level, and number of intervals you'd like to 
          generate. Then click 'Generate CIs!' A plot will appear with a summary
          of your parameter capture" ),
        p("Each click of 'Generate CIs' with regenerate a new collection of samples."),
        h3("Your Confidence Intervals:"),
        plotOutput('plot'),
        h3("Capture Summary:"),
        textOutput('numCap'),
        textOutput('perCap'),
        textOutput('meanProp')
        )
      )
    )


