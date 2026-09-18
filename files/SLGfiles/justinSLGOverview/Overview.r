############################################################
##Pakistan Economic Data Example
##Author: Justin Post - Fall 2014
##Data taken from G.R. Pasha and Muhammad Akbar Ali Shah (2004)
############################################################

#Read data into a matrix
data<-matrix(ncol=6,byrow=TRUE,c(
 20.30, 19.55, 0.2671, 3286, 68.924, 22.2, 
 20.08, 19.82, 0.1166, 3248, 71.033, 22.5 ,
 21.89, 19.76, 0.1178, 3373, 73.205, 22.8 ,
 22.73, 20.10, 0.0779, 3676, 75.444, 23.2 ,
 23.62, 19.98, 0.0663, 3715, 77.516, 23.4 ,
 24.15, 20.23, 0.1072, 3750, 80.130, 23.7 ,
 24.70, 20.30, 0.1237, 3815, 82.580, 24.0 ,
 25.27, 20.42, 0.1000, 3882, 84.254, 26.2 ,
 25.85, 20.31, 0.0448, 3931, 87.758, 26.5 ,
 26.40, 20.33, 0.0836, 4047, 90.480, 26.9 ,
 26.96, 20.61, 0.0746, 4423, 93.286, 27.2 ,
 27.93, 20.67, 0.0483, 4349, 96.180, 27.5 ,
 28.70, 20.92, 0.0387, 4544, 99.162, 27.9 ,
 28.99, 20.66, 0.3884, 4573, 102.230, 28.0 ,
 29.99, 20.73, 0.3087, 4595, 105.409, 28.1 ,
 30.82, 20.73, 0.3854, 4543, 108.678, 28.3 ,
 31.78, 20.77, 0.3886, 4589, 111.938, 28.6 ,
 31.78, 20.96, 0.2910, 4656, 111.938, 34.9 ,
 31.94, 21.06, 0.4112, 4849, 113.610, 36.0 ,
 32.45, 21.40, 0.2129, 4809, 116.470, 37.2 ,
 33.29, 21.51, 0.6121, 4852, 119.390, 38.4 ,
 33.60, 21.55, 0.4291, 4998, 122.361, 39.6 ,
 34.42, 21.68, 0.1231, 5072, 125.387, 40.9 ,
 36.84, 21.98, 0.5120, 4992, 128.421, 42.2 ,
 37.73, 21.96, 0.4001, 4924, 131.510, 43.6 ,
 38.59, 21.93, 0.4014, 4992, 134.511, 45.0 ,
 40.40, 21.99, 0.4423, 5081, 137.512, 47.1 ,
 41.20, 21.99, 0.4328, 5128, 140.473, 52.0 ),dimnames=list(c(),c("Y","X1","X2","X3","X4","X5")))


#check on data
head(data)

#Work with centered data for ease
#get 'design matrix'
X<-data[,2:6]-matrix(apply(X=data[,2:6],FUN=mean,MARGIN=2),ncol=5,nrow=dim(data)[1],byrow=TRUE)

#Check pairwise scatterplots
pairs(X)

#Find Correlation matrix of X's
cor(X)

########################################################
#Obtain principal components decomposition of correlation matrix
########################################################
pc<-princomp(x=X,cor=TRUE)

#see summary of pc decomp
summary(pc)
plot(pc)

#obtain first pc vector
loadings(pc)
round(loadings(pc)[,1],3)


################################################
#Visualization of eigenvectors for just x1 and x2
#Use covariance matrix here for plotting
pc2<-princomp(x=X[,1:2],cor=FALSE)
summary(pc2)

eigen1<-round(loadings(pc2)[,1],3)
eigen2<-round(loadings(pc2)[,2],3)

plot(X[,1],X[,2],xlim=c(-1.5,1.5),ylim=c(-1.5,1.5),main="Scatterplot with PC axes",xlab="x1",ylab="x2")
abline(0,eigen1[2]/eigen1[1], col="orange", lwd=2)    # first PCA axis, largest variance
abline(0,eigen2[2]/eigen2[1], col="blue", lwd=2)   # second PCA axis, smallest variance
legend(-1,0.6, c("PC.1","PC.2"), lty=c(1,1), col=c("orange","blue"), lwd=c(2,2))

	
################################################
#Get ridge regression fits and create a plot
#Load required library
library(MASS)

#Get grid of df values to use (each corresponds to a different lambda)
df<-seq(from=5,to=0,length=500)

#Function to find the lambda corresponding to a certain df (used with uniroot)
dffunction<-function(X,rrpar,df){
sum(diag(X%*%solve(t(X)%*%X+rrpar*diag(dim(X)[2]))%*%t(X)))-df
}

#Find lambda for each df using the uniroot function
lambda<-c(rep(0,length(df)-1))
for (j in 2:(length(df)-1)){
lambda[j]<-uniroot(dffunction,df=df[j],interval=c(0,10000000000000),X=data[,2:6])$root
}

#need an infinite lambda to get d=0, or lambda[length(d)]=Inf will treat as a special case

#Get Ridge Regression solutions, the last row of Ridge will be 0's (infinite lambda)
#Create `response vector' (centered to eliminate intercept
Y<-data[,1]-mean(data[,1])

Ridge<-rbind(coef(lm.ridge(Y~X-1,lambda=lambda)),c(rep(0,5)))
dimnames(Ridge)<-c()

#5 columns have the estimate beta coefficients
head(Ridge)

plot(df,Ridge[,1],type="l",ylim=c(min(Ridge),max(Ridge)),col="Red",xlab="Degrees of Freedom",ylab="Estimate")
title("Ridge Regression Solution Path", line = 2.5)
lines(df,Ridge[,2],col="Blue")
lines(df,Ridge[,3],col="Pink")
lines(df,Ridge[,4],col="Orange")
lines(df,Ridge[,5],col="Brown")










