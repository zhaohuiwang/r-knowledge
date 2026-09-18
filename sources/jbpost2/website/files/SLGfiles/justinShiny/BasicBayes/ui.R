###########################################################################
##R Shiny App to plot different possible posterior distributions from coin example
##Justin Post - Spring 2015
###########################################################################

#Load package
library(shiny)

# Define UI for application that draws the prior and posterior distributions given a value of y
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Posterior Distributions for Coin Example"),
  
  # Sidebar with a slider input for the number of successes
  fluidRow(
    column(3,
      sliderInput("yvalue",
                  "Y=Number of Successes",
                  min = 0,
                  max = 30,
                  value = 15),
      br(),
      h4("Hyperparameters of the prior distribution."),
      h5("(Set to 1 if blank.)"),
      numericInput("alpha",
                  label=h5("Alpha Value (> 0)"),value=1,min=0,step=0.1),
      numericInput("beta",
                   label=h5("Beta Value (> 0)"),value=1,min=0,step=0.1)
    ),

    #Show a plot of the prior    
    column(4,
         plotOutput("priorPlot")
           ),
    # Show a plot of the posterior distribution
    column(5,
        plotOutput("distPlot")
    )
  )
))

