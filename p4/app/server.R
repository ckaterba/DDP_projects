#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)

# Define server logic required to draw a histogram
shinyServer(
  function(input, output) {
    n <- eventReactive(input$goButton, {input$n})
    p <- eventReactive(input$goButton, {input$p})
    ss <- eventReactive(input$goButton, {n()*p() >= 10 & n()*(1-p()) >=10})
    zCrit <- eventReactive(input$goButton,{qnorm( (1 - input$confLevel)/2, lower.tail = FALSE)})
    data <- eventReactive(input$goButton, {
      data <- tibble( sample =c(), pHat = c(), SE = c())
      for(i in 1:input$numInt){
        temp <- tibble( sample = c(i),
                        pHat = c(sum(rbinom(n(),1, p()))/n()), 
        )
        data <- bind_rows(data, temp)
      }
      data <- data <- data %>% mutate(
        SE = sqrt(pHat*(1-pHat)/n()),
        lower = pHat - zCrit()*SE, 
        upper = pHat + zCrit()*SE,
        capt_p = (p() >= lower & p() <= upper)) %>%
        pivot_longer(lower:upper, names_to = "bound", values_to = "value")
    })
    
    output$check <- renderText({
    if (ss()){ "Yup."} else{"Nope. Remember you need p*n >= 10 and (1-p)*n >= 10."}
    })
    output$plot <- renderPlot({
      if (ss()){
        pTitle <- paste0(input$numInt, " randomly generated ", input$confLevel*100, "% CI(s)")
        pSubTitle <- paste0("n = ", n(), " and the true pop. proportion is p = ", p())
        p <- ggplot(data(), aes(x= value, 
                              y = sample, 
                              group = sample,
                              color = capt_p)) +
          geom_point(size = 2) +
          geom_line() +
          geom_vline( xintercept = p(), color = "darkgray") +
          xlim(c(0,1)) +
          labs(title = pTitle, subtitle = pSubTitle) +
          xlab("interval range") + ylab("sample #")
        p
      } else{
        return(NULL)
      }
    })
    output$numCap <- renderText(if(ss()){paste0("# of intervals capturing p: ", sum(data()$capt_p)/2)
      }else{NULL})
    output$perCap <- renderText(if(ss()){paste0("% of intervals capturing p: ", (sum(data()$capt_p)/2)/input$numInt)
                                                }else{NULL})
    output$meanProp <- renderText(if(ss()){paste0("mean sample proportion: ", mean(data()$pHat))}else{NULL})
  })
