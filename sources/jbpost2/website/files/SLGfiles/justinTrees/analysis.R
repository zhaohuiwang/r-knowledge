##############################################
##R File corresponding to analysis
##for SLG meeting 9/20/16
##Justin Post 
##############################################

#Replication of some analysis done in article:
#http://www.nature.com/articles/srep25963

#data available to download there or on SLG web
#description of variables available at 
#http://www.nature.com/articles/srep25963/tables/1


#install packages if needed
install.packages(c("rpart","dplyr","ggplot2","corrplot","rpart.plot"))
#load packages
library(rpart)
library(rpart.plot)
library(dplyr)
library(ggplot2)
library(corrplot)

#read in data
River<-tbl_df(read.csv("F:/SLG/Trees/data.csv",header=TRUE))
River

#attach data
attach(River)
#create new classification variable
River<-tbl_df(data.frame(River,Size.Class=ifelse(Size.km2.<15000,"Small",
                                          ifelse(Size.km2.<100000,"Medium",
                                          ifelse(Size.km2.<350000,"Sizeable",
                                          ifelse(Size.km2.<700000,"Large","Great"))))))
detach(River)
attach(River)

#######################################################################
##Table 2 recreation

#Find means of Rc, TSSC, TSSL, TOCL by each level of the Size variable
#Note - this only uses complete case analysis!
aggregate(cbind(Rc,TSSC.mg.L.,TSSL.g.m.2.a.1.,TOCL..g.m.2.a.1.)~Size.Class,FUN=mean,na.rm=TRUE,data=River)
#For each variable instead (slightly different here and there...)
#Rc
aggregate(Rc~Size.Class,FUN=mean,na.rm=TRUE,data=River)
aggregate(Rc~Size.Class,FUN=length,data=River)
  #combined
  data.frame(aggregate(Rc~Size.Class,FUN=mean,na.rm=TRUE,data=River),
           Count=aggregate(Rc~Size.Class,FUN=length,data=River)[,2])
#TSSC
data.frame(aggregate(TSSC.mg.L.~Size.Class,FUN=mean,na.rm=TRUE,data=River),
           Count=aggregate(TSSC.mg.L.~Size.Class,FUN=length,data=River)[,2])
#TSSL
data.frame(aggregate(TSSL.g.m.2.a.1.~Size.Class,FUN=mean,na.rm=TRUE,data=River),
           Count=aggregate(TSSL.g.m.2.a.1.~Size.Class,FUN=length,data=River)[,2])
#TOCL
data.frame(aggregate(TOCL..g.m.2.a.1.~Size.Class,FUN=mean,na.rm=TRUE,data=River),
           Count=aggregate(TOCL..g.m.2.a.1.~Size.Class,FUN=length,data=River)[,2])

#alternatively use dplyr
River %>% group_by(Size.Class) %>% summarise(mean(Rc,na.rm=TRUE))
River %>% group_by(Size.Class) %>% summarise(count=sum(!is.na(Rc)))
  #combined
  data.frame(River %>% group_by(Size.Class) %>% summarise(mean(Rc,na.rm=TRUE)),
      select(River %>% group_by(Size.Class) %>% summarise(count=sum(!is.na(Rc))),count))

###########################################################################
##Figure 2 recreation
  
#find correlation matrix using spearman's rank
Correlation<-cor(select(River,RD.mm.,MAP,Rc,MAT,DOCL,TOCL..g.m.2.a.1.,SOC...,QA,Vc...,S,POCL,
                      TSSL.g.m.2.a.1.,Size.km2.,LONG,TSSC.mg.L.,DOCC,BD.g.cm3.,POCC,RSCI...,LAT),
                      use="pairwise.complete.obs",method="spearman")

corrplot(Correlation,type="upper",title="Figure 2: Correlation matrix of variables.",tl.pos="lt")
corrplot(Correlation,type="lower",method="number",add=TRUE,diag=FALSE,tl.pos="n")


###########################################################################
##Figure 3a recreation

#create tree for Rc
rpart_tree<-rpart(formula=Rc~MAP+MAT+RSCI...+RD.mm.+S+Vc...,data=River,method="anova",cp=0.001)
#plot it
plot(rpart_tree)
text(rpart_tree)
#better plot
rpart.plot(rpart_tree)

#look at stats
printcp(rpart_tree)
plotcp(rpart_tree)

#prune it and replot
prune(rpart_tree,cp=0.009)
rpart.plot(prune(rpart_tree,cp=0.009))


#recreate with only the variables they ended with
rpart_tree<-rpart(formula=Rc~MAP+MAT,data=River,method="anova",cp=0.001)
#plot it
rpart.plot(rpart_tree)

#look at stats
printcp(rpart_tree)
plotcp(rpart_tree)

#prune it and replot
prune(rpart_tree,cp=0.02)
rpart.plot(prune(rpart_tree,cp=0.02))


###########################################################################
##Figure 4a recreation

#overwrite Size.Class to have proper ordering
River$Size.Class<-ordered(Size.Class,levels=c("Small","Medium","Sizeable","Large","Great"))
#to add coloring for points - need MAP variable first
River<-tbl_df(data.frame(River,MAT.Class=ifelse(MAP<600,"Semiarid",
                                                ifelse(MAP>=600 & MAP<850,"Moist",ifelse(MAP>=850 & MAP<1500,"Humid","Wet")))))
#reorder valeus
River$MAT.Class<-ordered(River$MAT.Class,levels=c("Semiarid","Moist","Humid","Wet"))

#create plot - base plotting object
g<-ggplot(data=River,aes(x=Size.Class,y=Rc))
#add layer for boxplots
g+geom_boxplot(lwd=1)
#fix y scale
g+geom_boxplot(lwd=1)+coord_cartesian(ylim=c(0,1))
#fix labeling
g+geom_boxplot(lwd=1)+coord_cartesian(ylim=c(0,1))+labs(title="MAP",x="Size")


#add layer for points
g+geom_boxplot(lwd=1)+coord_cartesian(ylim=c(0,1))+labs(title="MAP",x="Size")+
  geom_point()
#add coloring
g+geom_boxplot(lwd=1)+coord_cartesian(ylim=c(0,1))+labs(title="MAP",x="Size")+
  geom_point(aes(col=MAT.Class),size=4)


#add connecting lines for each group
g+geom_boxplot(lwd=1)+coord_cartesian(ylim=c(0,1))+labs(title="MAP",x="Size")+
  geom_point(aes(col=MAT.Class),size=4)+
  stat_summary(fun.y=mean,geom="line",lwd=2,aes(group=MAT.Class,col=MAT.Class))

#change background theme
g+geom_boxplot(lwd=1)+coord_cartesian(ylim=c(0,1))+labs(title="MAP",x="Size")+
  geom_point(aes(col=MAT.Class),size=4)+
  stat_summary(fun.y=mean,geom="line",lwd=2,aes(group=MAT.Class,col=MAT.Class))+
  theme_classic()




###########################################################################
##More about trees!

#######################################
#comparison to simple linear regression
g<-ggplot(data=River,aes(x=MAP,y=Rc))
#plot SLR between MAP and Rc
g+geom_point()+geom_smooth(method="lm",se=FALSE,lwd=1.25)

#fit tree with just MAP to predict Rc
rpart_tree<-rpart(formula=Rc~MAP,data=River,method="anova",cp=0.001)
#look at stats
printcp(rpart_tree)
plotcp(rpart_tree)

#prune it and replot
rpart.plot(prune(rpart_tree,cp=0.01))

#compare with SLR
fun<-function(MAP){ifelse(MAP<502,0.13,ifelse(MAP<703,
      0.21,ifelse(MAP<721,0.42,ifelse(MAP<893,0.29,
      ifelse(MAP<1554,0.46,ifelse(MAP<1612,0.59,
      ifelse(MAP<1644,0.32,0.57)))))))
}

#add regression tree prediction
g+geom_point()+geom_smooth(method="lm",se=FALSE,lwd=1.25)+
  stat_function(fun=fun,lwd=1.25)


########################################
#Consider this with two variables

install.packages("plot3D","plot3Drgl")
library(plot3D)
library("plot3Drgl")
scatter3D(x=MAP,y=MAT,z=Rc,pch=16,ticktype="detailed",
          xlab="MAP",ylab="MAT",zlab="Rc")
plotrgl()

#add in regression surface
fit<-lm(Rc~MAP+MAT,data=River)
summary(fit)
grid.lines = 40
x.pred <- seq(min(MAP), max(MAP), length.out = grid.lines)
y.pred <- seq(min(MAT), max(MAT), length.out = grid.lines)
xy <- expand.grid( MAP = x.pred, MAT = y.pred)
z.pred <- matrix(predict(fit, newdata = xy), 
                 nrow = grid.lines, ncol = grid.lines)
# scatter plot with regression plane
scatter3D(x=MAP, y=MAT, z=Rc, pch = 16, cex = 1, 
          theta = 20, phi = 20, ticktype = "detailed",
          xlab = "MAP", ylab = "MAT", zlab = "Rc",  
          surf = list(x = x.pred, y = y.pred, z = z.pred))
plotrgl()

#add in regression surface with interaction
fit<-lm(Rc~MAP+MAT+MAP*MAT,data=River)
summary(fit)
grid.lines = 40
x.pred <- seq(min(MAP), max(MAP), length.out = grid.lines)
y.pred <- seq(min(MAT), max(MAT), length.out = grid.lines)
xy <- expand.grid( MAP = x.pred, MAT = y.pred)
z.pred <- matrix(predict(fit, newdata = xy), 
                 nrow = grid.lines, ncol = grid.lines)
# scatter plot with regression plane
scatter3D(x=MAP, y=MAT, z=Rc, pch = 16, cex = 1, 
          theta = 20, phi = 20, ticktype = "detailed",
          xlab = "MAP", ylab = "MAT", zlab = "Rc",  
          surf = list(x = x.pred, y = y.pred, z = z.pred))
plotrgl()


#Obtain tree prediction
rpart_tree<-rpart(formula=Rc~MAP+MAT,data=River,method="anova",cp=0.001)
#look at stats and plot
printcp(rpart_tree)
plotcp(rpart_tree)
rpart.plot(rpart_tree)

#prune it and replot
rpart.plot(prune(rpart_tree,cp=0.01))

#add in regression surface with interaction
grid.lines = 40
x.pred <- seq(min(MAP), max(MAP), length.out = grid.lines)
y.pred <- seq(min(MAT), max(MAT), length.out = grid.lines)
xy <- expand.grid( MAP = x.pred, MAT = y.pred)
z.pred <- matrix(ifelse(xy[,1]<542 & xy[,2]>=5.2,0.1,
                  ifelse(xy[,1]<703 & xy[,1]>=542 & xy[,2]>=5.2,0.19,
                  ifelse(xy[,1]<703 & xy[,2]<5.2,0.25,
                  ifelse(xy[,1]<893 & xy[,2]>=12,0.27,
                  ifelse(xy[,1]<893 & xy[,2]<12,0.43,
                  ifelse(xy[,1]>1644,0.57,
                  ifelse(xy[,1]>=1612,0.32,
                  ifelse(xy[,1]>1554,0.59,
                  ifelse(xy[,1]<1554 & xy[,2]>=12,0.45,
                  ifelse(xy[,1]<1554 & xy[,2]<12,0.61,NA)))))))))), 
                 nrow = grid.lines, ncol = grid.lines)
# scatter plot with tree fit
scatter3D(x=MAP, y=MAT, z=Rc, pch = 16, cex = 1, 
          theta = 20, phi = 20, ticktype = "detailed",
          xlab = "MAP", ylab = "MAT", zlab = "Rc",  
          surf = list(x = x.pred, y = y.pred, z = z.pred))
plotrgl()



################################
##Assuming we want to model a constant in each region, the mean is optimal
##How are we doing the splits?
meansRSS<-function(df,mapval){
  index<-df$MAP<=mapval
  lowmean=mean(df$Rc[index],na.rm=TRUE)
  highmean=mean(df$Rc[!index],na.rm=TRUE)
  RSS=sum((df$Rc[index]-lowmean)^2,na.rm=TRUE)+sum((df$Rc[!index]-highmean)^2,na.rm=TRUE)
  return(list(lowmean=lowmean,highmean=highmean,RSS=RSS))
}

#possible value to split on
vals<-c(300,250,200,150,103,80,30,10)
for(i in vals){
  mapval<-arrange(data.frame(MAP),MAP)
  #find lower and upper means
  split<-meansRSS(df=data.frame(MAP,Rc),mapval=mapval[i,1])
  #create dataframe for plotting
  df2<-data.frame(min=min(MAP),max=max(MAP),mapval=mapval[i,1],lowmean=split$lowmean,highmean=split$highmean)

  #plot and put on   
  plot<-g+geom_point()+
    geom_segment(aes(x = min, y = lowmean, xend = mapval, 
                     yend = lowmean), data = df2,lwd=2,colour = "Red")+
    geom_segment(aes(x = mapval, y = highmean, xend = max, 
                     yend = highmean), data = df2,lwd=2,colour="Blue")+
    geom_text(aes(x=350,y=0.7,label=paste("RSS=",round(split$RSS,2))))
  print(plot)
}


