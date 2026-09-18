###########################################################################
##R Shiny App to plot basketball data
##Justin Post - Spring 2015
###########################################################################

###################################################
##Step 1 for basketball app
##Select input for player name
Load package
library(shiny)
PlayerNames<-read.csv("PlayerNames.csv",header=TRUE)[,2]

shinyUI(fluidPage(
  
  # Application title
  titlePanel("R Shiny Basketball App"),
  
  # Sidebar with options for the data set
  sidebarLayout(
    sidebarPanel(
      #put in a select box t select our player name, default to Lebron James
      #first you give it the name you'll use internally to reference the input, then the Label
      selectizeInput("player","Player:",selected="LeBron James",choices=levels(PlayerNames))
    ),
    mainPanel()
  )
))


# ###################################################
# ##Step 2, add plot to ui
# Load package
# library(shiny)
# PlayerNames<-read.csv("PlayerNames.csv",header=TRUE)[,2]
# 
# shinyUI(fluidPage(
#   
#   # Application title
#   titlePanel("R Shiny Basketball App"),
#   
#   # Sidebar with options for the data set
#   sidebarLayout(
#     sidebarPanel(
#       #put in a select box t select our player name, default to Lebron James
#       #first you give it the name you'll use internally to reference the input, then the Label
#       selectizeInput("player","Player:",selected="LeBron James",choices=levels(PlayerNames))
#     ),
#     mainPanel(plotOutput("shotChart"))
#   )
# ))


# ###################################################
# ##Step 3, add in color coding option
#Load package
# library(shiny)
# PlayerNames<-read.csv("PlayerNames.csv",header=TRUE)[,2]
# 
# shinyUI(fluidPage(
#   
#   # Application title
#   titlePanel("R Shiny Basketball App"),
#   
#   # Sidebar with options for the data set
#   sidebarLayout(
#     sidebarPanel(
#       #put in a select box t select our player name, default to Lebron James
#       #first you give it the name you'll use internally to reference the input, then the Label
#       selectizeInput("player","Player:",selected="LeBron James",choices=levels(PlayerNames)),
#       checkboxInput("color","Color Code Made/Missed")
#     ),
#     mainPanel(plotOutput("shotChart"))
#   )
# ))


# ###################################################
# ##Step 5, add in summary outputs
# #Load package
# library(shiny)
# 
# PlayerNames<-read.csv("PlayerNames.csv",header=TRUE)[,2]
# 
# shinyUI(fluidPage(
#   
#   # Application title
#   titlePanel("R Shiny Basketball App"),
#   
#   # Sidebar with options for the data set
#   sidebarLayout(
#     sidebarPanel(
#       selectizeInput("player","Player:",selected="LeBron James",choices=levels(PlayerNames)),
#       checkboxInput("color","Color Code Made/Missed")
#     ),
#     
#     # Show plots
#     mainPanel(
#       fluidRow(column(8,
#                plotOutput("shotChart")
#                ),
#                column(4,
#                       tableOutput("summary"),
#                       tableOutput("summary2")
#                )
#                )
#       )
#   ),
#   fluidRow(tableOutput("observations"))
# ))



# ####################################################################
# ##Step 6, add number of observations to print
# #Load package
# library(shiny)
# 
# PlayerNames<-read.csv("PlayerNames.csv",header=TRUE)[,2]
# 
# shinyUI(fluidPage(
#   
#   # Application title
#   titlePanel("R Shiny Basketball App"),
#   
#   # Sidebar with options for the data set
#   sidebarLayout(
#     sidebarPanel(
#       selectizeInput("player","Player:",selected="LeBron James",choices=levels(PlayerNames)),
#       checkboxInput("color","Color Code Made/Missed"),
#       numericInput("numObs",label="Number of Observations to Print",min=1,step=1,value=5)
#       ),
#     
#     # Show plots
#     mainPanel(
#       fluidRow(column(8,
#                plotOutput("shotChart")
#                ),
#                column(4,
#                       tableOutput("summary"),
#                       tableOutput("summary2")
#                )
#                )
#       )
#   ),
#   fluidRow(tableOutput("observations"))
# ))

# ####################################################################
# ##Step 7, add time stuff
# #Load package
# library(shiny)
# 
# PlayerNames<-read.csv("PlayerNames.csv",header=TRUE)[,2]
# 
# shinyUI(fluidPage(
#   
#   # Application title
#   titlePanel("R Shiny Basketball App"),
#   
#   # Sidebar with options for the data set
#   sidebarLayout(
#     sidebarPanel(
#       selectizeInput("player","Player:",selected="LeBron James",choices=levels(PlayerNames)),
#       checkboxInput("color","Color Code Made/Missed"),
#       numericInput("numObs",label="Number of Observations to Print",min=1,step=1,value=5),
#       sliderInput("time", "Time of Shots During Game",
#                   min = 0, max = 63, value = c(0,63)) #63 was maximum value of all players for time
#     ),
#     
#     # Show plots
#     mainPanel(
#       fluidRow(column(8,
#                plotOutput("shotChart")
#                ),
#                column(4,
#                       tableOutput("summary"),
#                       tableOutput("summary2")
#                )
#                )
#       )
#   ),
#   fluidRow(tableOutput("observations"))
# ))


# ################################################################3
# ##Step 8 Try to update the slider... not quite working right yet
# #Load package
# library(shiny)
# 
# PlayerNames<-read.csv("PlayerNames.csv",header=TRUE)[,2]
# 
# shinyUI(fluidPage(
#   
#   # Application title
#   titlePanel("R Shiny Basketball App"),
#   
#   # Sidebar with options for the data set
#   sidebarLayout(
#     sidebarPanel(
#       selectizeInput("player","Player:",selected="LeBron James",choices=levels(PlayerNames)),
#       checkboxInput("color","Color Code Made/Missed"),
#       numericInput("numObs",label="Number of Observations to Print",min=1,step=1,value=5),
# #       sliderInput("time", "Time of Shots During Game",
# #                   min = 0, max = 63, value = c(0,63)) #63 was maximum value of all players for time
#       uiOutput("ui")
#     ),
#     
#     # Show plots
#     mainPanel(
#       fluidRow(column(8,
#                plotOutput("shotChart")
#                ),
#                column(4,
#                       tableOutput("summary"),
#                       tableOutput("summary2")
#                )
#                )
#       )
#   ),
#   fluidRow(tableOutput("observations"))
# ))

