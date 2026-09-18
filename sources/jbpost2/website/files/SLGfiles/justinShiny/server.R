shinyServer(function(input,output){
})


# #######################################################
# ##Step 2, add plot Using the select player input
# #read in data used - any code prior to shinyServer will run once, at App startup
# bballdata<-read.csv("NBAShots.csv",header=TRUE)
# 
# shinyServer(function(input, output) {
#   #create output called `shotChart'
#   output$shotChart<-renderPlot({
#     #anything the user inputs, we find via input$...
#     name<-input$player
#     index<-which(bballdata[,6]==name)
#     
#     plot(x=bballdata[index,19],y=bballdata[index,20],ylim=c(-2.2,38.2),xlim=c(-25.0,25.0),
#          xlab="horizontal direction (ft)",ylab="vertical direction (ft)",main="Shot Locations")
#   })
# })


# #######################################################
# ##Step 3, add color coding to points
# #read in data used - any code prior to shinyServer will run once, at App startup
# bballdata<-read.csv("NBAShots.csv",header=TRUE)
# 
# shinyServer(function(input, output) {
#   
#     output$shotChart<-renderPlot({
#       name<-input$player
#       index<-which(bballdata[,6]==name)
#       col<-rep("black",length(index))
#       if (input$color){
#         col[which(bballdata[index,22]==1)]<-"Red"
#       }
#       
#       plot(x=bballdata[index,19],y=bballdata[index,20],ylim=c(-2.2,38.2),xlim=c(-25.0,25.0),
#            xlab="horizontal direction (ft)",ylab="vertical direction (ft)",main="Shot Locations",col=col)
#       if (input$color){
#         legend(x="topright",legend=c("Missed Shot","Made Shot"),col=c("Black","Red"),pch=16)
#       }
#       })
# })



# #######################################################
# ##Step 4, make it pretty
# 
# library(png)
# 
# #read in data used - any code prior to shinyServer will run once, at App startup
# bballdata<-read.csv("NBAShots.csv",header=TRUE)
# 
# shinyServer(function(input, output) {
#   
#     #prior to updating shots by time in game
#     output$shotChart<-renderPlot({
#       
#       #Get image
#       isolate(ima <- readPNG("court.png"))
#   
#       #Set up the plot area
#       isolate(plot(x=-25:25,ylim=c(-2.2,38.2),xlim=c(-25.0,25.0), type='n',xlab="horizontal direction (ft)",ylab="vertical direction (ft)",main="Shot Locations"))
#     
#       #Get the plot information so the image will fill the plot box, and draw it
#       isolate(lim <- par())
#       isolate(rasterImage(ima, lim$usr[1], lim$usr[3], lim$usr[2], lim$usr[4]))
#       isolate(grid())
#     
#       #Now plot shots
#       name<-input$player
#       index<-which(bballdata[,6]==name)
#       col<-rep("black",length(index))
#       if (input$color){
#         col[which(bballdata[index,22]==1)]<-"Red"
#       }
#       lines(x=bballdata[index,19],y=bballdata[index,20],col=col,type="p")
#       if (input$color){
#         legend(x="topright",legend=c("Missed Shot","Made Shot"),col=c("Black","Red"),pch=16)
#       }
#     })
# })




# #######################################################
# ##Step 5, add summary stuff
# library(png)
# 
# #read in data used - any code prior to shinyServer will run once, at App startup
# bballdata<-read.csv("NBAShots.csv",header=TRUE)
# 
# shinyServer(function(input, output) {
#   
#   #prior to updating shots by time in game
#   output$shotChart<-renderPlot({
#     
#     #Get image
#     isolate(ima <- readPNG("court.png"))
#     
#     #Set up the plot area
#     isolate(plot(x=-25:25,ylim=c(-2.2,38.2),xlim=c(-25.0,25.0), type='n',xlab="horizontal direction (ft)",ylab="vertical direction (ft)",main="Shot Locations"))
#     
#     #Get the plot information so the image will fill the plot box, and draw it
#     isolate(lim <- par())
#     isolate(rasterImage(ima, lim$usr[1], lim$usr[3], lim$usr[2], lim$usr[4]))
#     isolate(grid())
#     
#     #Now plot shots
#     name<-input$player
#     index<-which(bballdata[,6]==name)
#     col<-rep("black",length(index))
#     if (input$color){
#       col[which(bballdata[index,22]==1)]<-"Red"
#     }
#     lines(x=bballdata[index,19],y=bballdata[index,20],col=col,type="p")
#     if (input$color){
#       legend(x="topright",legend=c("Missed Shot","Made Shot"),col=c("Black","Red"),pch=16)
#     }
#   })
#   
#   #summary outputs  
#     output$summary<-renderTable({
#       name<-input$player
#       index<-which(bballdata[,6]==name)
#       summary(bballdata[index,c(18,23)])
#     })
#  
#     output$summary2<-renderTable({
#       name<-input$player
#       index<-which(bballdata[,6]==name)
#       matrix(c(round(mean(bballdata[index,22]),3),round(sqrt(mean(bballdata[index,22])*(1-mean(bballdata[index,22]))/length(index)),3)),nrow=2,ncol=1,dimnames=list(c("Mean","SD"),c("Proportion Made")))
#     })
#     
#     output$observations<-renderTable({
#       name<-input$player
#       index<-which(bballdata[,6]==name)
#       bballdata[index,c(2,12:20,23)]
#     })
# })


# #######################################################
# ##Step 6, add number of obs to print elements
# library(png)
# 
# #read in data used - any code prior to shinyServer will run once, at App startup
# bballdata<-read.csv("NBAShots.csv",header=TRUE)
# 
# shinyServer(function(input, output) {
#   
#   #prior to updating shots by time in game
#   output$shotChart<-renderPlot({
#     
#     #Get image
#     isolate(ima <- readPNG("court.png"))
#     
#     #Set up the plot area
#     isolate(plot(x=-25:25,ylim=c(-2.2,38.2),xlim=c(-25.0,25.0), type='n',xlab="horizontal direction (ft)",ylab="vertical direction (ft)",main="Shot Locations"))
#     
#     #Get the plot information so the image will fill the plot box, and draw it
#     isolate(lim <- par())
#     isolate(rasterImage(ima, lim$usr[1], lim$usr[3], lim$usr[2], lim$usr[4]))
#     isolate(grid())
#     
#     #Now plot shots
#     name<-input$player
#     index<-which(bballdata[,6]==name)
#     col<-rep("black",length(index))
#     if (input$color){
#       col[which(bballdata[index,22]==1)]<-"Red"
#     }
#     lines(x=bballdata[index,19],y=bballdata[index,20],col=col,type="p")
#     if (input$color){
#       legend(x="topright",legend=c("Missed Shot","Made Shot"),col=c("Black","Red"),pch=16)
#     }
#   })
#   
#   #summary outputs  
#     output$summary<-renderTable({
#       name<-input$player
#       index<-which(bballdata[,6]==name)
#       summary(bballdata[index,c(18,23)])
#     })
#  
#     output$summary2<-renderTable({
#       name<-input$player
#       index<-which(bballdata[,6]==name)
#       matrix(c(round(mean(bballdata[index,22]),3),round(sqrt(mean(bballdata[index,22])*(1-mean(bballdata[index,22]))/length(index)),3)),nrow=2,ncol=1,dimnames=list(c("Mean","SD"),c("Proportion Made")))
#     })
#     
#     output$observations<-renderTable({
#       name<-input$player
#       index<-which(bballdata[,6]==name)
#       head(bballdata[index,c(2,12:20,23)],n=min(input$numObs,length(index)))
#     })
# })


# #######################################################
# ##Step 7, add time dependent stuff
# library(png)
# 
# #read in data used - any code prior to shinyServer will run once, at App startup
# bballdata<-read.csv("NBAShots.csv",header=TRUE)
# 
# shinyServer(function(input, output) {
#   
#       output$shotChart<-renderPlot({
#       
#       #Get image
#       isolate(ima <- readPNG("court.png"))
#       
#       #Set up the plot area
#       isolate(plot(x=-25:25,ylim=c(-2.2,38.2),xlim=c(-25.0,25.0),type='n',xlab="horizontal direction (ft)",ylab="vertical direction (ft)",main="Shot Locations"))
#       
#       #Get the plot information so the image will fill the plot box, and draw it
#       isolate(lim <- par())
#       isolate(rasterImage(ima, lim$usr[1], lim$usr[3], lim$usr[2], lim$usr[4]))
#       isolate(grid())
#       
#       #Now plot shots
#       name<-input$player
#       timevalues<-input$time
#   
#       index<-which(bballdata[,6]==name)
#       playerdata<-bballdata[index,]
#       
#       indextime<-which(((playerdata[,23]>timevalues[1])*(playerdata[,23]<timevalues[2]))==1)
#       
#       col<-rep("black",length(indextime))
#       if (input$color){
#         col[which(playerdata[indextime,22]==1)]<-"Red"
#       }
#       lines(x=playerdata[indextime,19],y=playerdata[indextime,20],col=col,type="p")
#       if (input$color){
#         legend(x="topright",legend=c("Missed Shot","Made Shot"),col=c("Black","Red"),pch=16)
#       }
#     })
#   
#     output$summary<-renderTable({
#       name<-input$player
#       timevalues<-input$time
#           
#       index<-which(bballdata[,6]==name)
#       playerdata<-bballdata[index,]
#           
#       indextime<-which(((playerdata[,23]>timevalues[1])*(playerdata[,23]<timevalues[2]))==1)
#           
#       summary(playerdata[indextime,c(18,23)])
#     })
#         
#     output$summary2<-renderTable({
#       name<-input$player
#       timevalues<-input$time
#       
#       index<-which(bballdata[,6]==name)
#       playerdata<-bballdata[index,]
#       
#       indextime<-which(((playerdata[,23]>timevalues[1])*(playerdata[,23]<timevalues[2]))==1)
#       
#       matrix(c(round(mean(playerdata[indextime,22]),3),round(sqrt(mean(playerdata[indextime,22])*(1-mean(playerdata[indextime,22]))/length(indextime)),3)),nrow=2,ncol=1,dimnames=list(c("Mean","SD"),c("Proportion Made")))
#     })
#         
#     output$observations<-renderTable({
#       name<-input$player
#       timevalues<-input$time
#       
#       index<-which(bballdata[,6]==name)
#       playerdata<-bballdata[index,]
#   
#       indextime<-which(((playerdata[,23]>timevalues[1])*(playerdata[,23]<timevalues[2]))==1)
#   
#       head(playerdata[indextime,c(2,12:20,23)],n=min(input$numObs,length(indextime)))
#         })
# })


# ##################################################
# ##Step 8
# library(png)
# #First read in the data from a file
# bballdata<-read.csv("NBAShots.csv",header=TRUE)
# 
# shinyServer(function(input, output,session) {
# 
#     output$shotChart<-renderPlot({
#     
#     #Get image
#     isolate(ima <- readPNG("court.png"))
#     
#     #Set up the plot area
#     isolate(plot(x=-25:25,ylim=c(-2.2,38.2),xlim=c(-25.0,25.0),type='n',xlab="horizontal direction (ft)",ylab="vertical direction (ft)",main="Shot Locations"))
#     
#     #Get the plot information so the image will fill the plot box, and draw it
#     isolate(lim <- par())
#     isolate(rasterImage(ima, lim$usr[1], lim$usr[3], lim$usr[2], lim$usr[4]))
#     isolate(grid())
#     
#     #Now plot shots
#     name<-input$player
#     timevalues<-input$time
# 
#     index<-which(bballdata[,6]==name)
#     playerdata<-bballdata[index,]
#     
#     indextime<-which(((playerdata[,23]>timevalues[1])*(playerdata[,23]<timevalues[2]))==1)
#     
#     col<-rep("black",length(indextime))
#     if (input$color){
#       col[which(playerdata[indextime,22]==1)]<-"Red"
#     }
#     lines(x=playerdata[indextime,19],y=playerdata[indextime,20],col=col,type="p")
#     if (input$color){
#       legend(x="topright",legend=c("Missed Shot","Made Shot"),col=c("Black","Red"),pch=16)
#     }
#   })
#  
#   output$summary<-renderTable({
#     name<-input$player
#     timevalues<-input$time
#     
#     index<-which(bballdata[,6]==name)
#     playerdata<-bballdata[index,]
#     
#     indextime<-which(((playerdata[,23]>timevalues[1])*(playerdata[,23]<timevalues[2]))==1)
#     
#     summary(playerdata[indextime,c(18,23)])
#   })
#   
#   output$summary2<-renderTable({
#     name<-input$player
#     timevalues<-input$time
#     
#     index<-which(bballdata[,6]==name)
#     playerdata<-bballdata[index,]
#     
#     indextime<-which(((playerdata[,23]>timevalues[1])*(playerdata[,23]<timevalues[2]))==1)
#     
#     matrix(c(round(mean(playerdata[indextime,22]),3),round(sqrt(mean(playerdata[indextime,22])*(1-mean(playerdata[indextime,22]))/length(indextime)),3)),nrow=2,ncol=1,dimnames=list(c("Mean","SD"),c("Proportion Made")))
#   })
#   
#   #this produces a warning, but I'm not sure why... 
#   output$observations<-renderTable({
#     name<-input$player
#     timevalues<-input$time
#     
#     index<-which(bballdata[,6]==name)
#     playerdata<-bballdata[index,]
# 
#     indextime<-which(((playerdata[,23]>timevalues[1])*(playerdata[,23]<timevalues[2]))==1)
# 
#     head(playerdata[indextime,c(2,12:20,23)],n=min(input$numObs,length(indextime)))
#   })
#   
# 
# # first attempt at slider stuff
# #   observe({
# #     name<-input$player
# #     index<-which(bballdata[,6]==name)
# #     maxval<-max(bballdata[index,23])
# #     updateSliderInput(session,inputId="time",value=c(0,maxval))
# #     update
# #   })
# 
# #slider bar doesn't look right until you change player, not sure how to fix quite yet  
#   output$ui <- renderUI({
#     # Depending on max of time of shot, we'll create a different slider
#     name<-input$player
#     obs<-input$numObs
#     index<-which(bballdata[,6]==name)
#     maxval<-max(ceiling(max(bballdata[index,23])),48)
#     minval<-0
#     # UI component and send it to the client.
#     sliderInput("time", "Time of Shots During Game",
#                                   min = minval, max = maxval, value = c(minval,maxval),step=0.5)
#   })
# 
# })