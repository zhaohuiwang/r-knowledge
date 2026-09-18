###########################################################################
##Example layouts
##Justin Post - Spring 2015
###########################################################################

# shinyUI(fluidPage(
#   #in here you design the page layout.
#   #fluidRow will create a row
#   fluidRow(
#     #now you can use a pre-made layout (easiest) 
#     sidebarLayout( 
#       sidebarPanel("left side by default"),
#       mainPanel("put the main shiny stuff here")
#     )
#   )
# ))



shinyUI(fluidPage(
  #in here you design the page layout.
  #fluidRow will create a row
  fluidRow(
    #alternatively, use column() to specify your own layout
    column(9, "Stuff here---------------------------------------------------------------------------------------------------------------"),
    column(3, "more stuff here--------------------------------")
  ), #columns must add up to 12 in total width
  fluidRow( #can nest rows in columns
    column(6,
           fluidRow(column(6,"even more stuff!--------------------------"),
                    column(6,"yes more stuff------------------"))
    ),
    column(6,"last stuff---------------------------------")
  )
))