#########################################################################
##Distribution of min/max and joint distribution of min/max
##Justin Post - Fall 2014
#########################################################################

#Max and min dist of n Beta random variables
set.seed(12341)
#set the number of samples we'll do to estimate the distribution
N<-100000
#set the parameters of the beta distribution
alpha<-beta<-2
#set the number of RVs in our random sample
n<-5

#now we'll take N samples of n observations from the beta(alpha, beta) distribution
#Create the data and store it in a matrix - rows represent data sets
samples<-matrix(rbeta(n=n*N,shape1=alpha,shape2=beta),nrow=N,ncol=n,byrow=TRUE)

#Now find the maximum from each sample (i.e. the max value in each row)
maxvalues<-apply(FUN=max,X=samples,MARGIN=1)
minvalues<-apply(FUN=min,X=samples,MARGIN=1)

#set the plot window to allow for four plots at once
par(mfrow=c(2,2))
#Have R wait on mouse click for next sample
par(ask=TRUE)


for(i in c(1:151,1000,N)){
	#plot the beta(alpha,beta) density in the (1,1) pane
	plot(x=seq(from=0,to=1,by=0.01),y=dbeta(x=seq(from=0,to=1,by=0.01),shape1=alpha,shape2=beta),type="l",
	main=paste("Beta(",alpha,",",beta,") density"),ylab="f(y)",xlab="y",xlim=c(0,1),
	ylim=c(0,max(dbeta(x=seq(from=0,to=1,by=0.01),shape1=alpha,shape2=beta)+0.25)))

	#put the vertical bars on the sides
	segments(x0=0,y0=0,x1=0,y1=dbeta(x=0,shape1=alpha,shape2=beta))
	segments(x0=1,y0=0,x1=1,y1=dbeta(x=1,shape1=alpha,shape2=beta))

	#Put a histogram of the sample values on the (1,2) pane
	samplebreaks<-cut(maxvalues[1:i],breaks=seq(from=0,to=1,by=0.05))
	clr<-c(rep("white",length(seq(from=0,to=1,by=0.05))))
	minbreaks<-cut(minvalues[1:i],breaks=seq(from=0,to=1,by=0.05))
	maxbreaks<-cut(maxvalues[1:i],breaks=seq(from=0,to=1,by=0.05))
	clr[maxbreaks[i]]<-"red"
	clr[minbreaks[i]]<-"blue"
	hist(samples[i,],main=paste("Sample ",i,"'s histogram of values"),freq=TRUE,xlab="Observed y values",xlim=c(0,1),breaks=seq(from=0,to=1,by=0.05),col=clr)
	abline(h=0)

	#now place the histogram of the maximum on the (2,1) pane
	clr<-c(rep("white",length(seq(from=0,to=1,by=0.05))))
	clr[maxbreaks[i]]<-"red"
	maxhist<-hist(maxvalues[1:i],main=paste("Histogram of maximum values for ",i," sample(s)"),freq=TRUE,xlab="Observed values of the Maximum",xlim=c(0,1),breaks=seq(from=0,to=1,by=0.05),col=clr)
	abline(h=0)

	#now place the histogram of the minimum on the (2,2) pane
	clr<-c(rep("white",length(seq(from=0,to=1,by=0.05))))
	clr[minbreaks[i]]<-"blue"
	minhist<-hist(minvalues[1:i],main=paste("Histogram of minimum values for ",i," sample(s)"),freq=TRUE,xlab="Observed values of the Minimum",xlim=c(0,1),breaks=seq(from=0,to=1,by=0.05),col=clr)
	abline(h=0)

	if ((i>30)&&(i<151)){
		par(ask=FALSE)
		Sys.sleep(0.1)
	}else if (i==151) {
		par(ask=TRUE)
	}
}



#################################################################33
##Now 3-d plot of joint distribution

#grid of xy values to plot over
xgrid<-ygrid<-seq(from=0,to=1,by=0.05)

#set plotting window
par(mfrow=c(2,2))
#ask to move plot ahead
par(ask=TRUE)

#Now look through each obsevation and add 1 if values fall in that grid point
for(i in c(1:151,500,1000,5000,N)){

	#matrix to store which grid point the value fell into
	z<-matrix(0,nrow=length(xgrid),ncol=length(ygrid))
	for (j in 1:i){
		z[min(which((minvalues[j]<=ygrid)==TRUE)),min(which((maxvalues[j]<=xgrid)
		==TRUE))]<-z[min(which((minvalues[j]<=ygrid)==TRUE)),min(which((maxvalues[j]<=xgrid)==TRUE))]+1
	}

	#plot 3d of joint
	persp(x=xgrid,y=ygrid,z=z,main="Joint Distribution of Min and Max",xlab="Min Values", ylab="Max Values",zlab="Joint",theta=-45,phi=15,d=5)

	#Put a histogram of the sample values on the (1,2) pane
	samplebreaks<-cut(maxvalues[1:i],breaks=seq(from=0,to=1,by=0.05))
	clr<-c(rep("white",length(seq(from=0,to=1,by=0.05))))
	minbreaks<-cut(minvalues[1:i],breaks=seq(from=0,to=1,by=0.05))
	maxbreaks<-cut(maxvalues[1:i],breaks=seq(from=0,to=1,by=0.05))
	clr[maxbreaks[i]]<-"red"
	clr[minbreaks[i]]<-"blue"
	hist(samples[i,],main=paste("Sample ",i,"'s histogram of values"),freq=TRUE,xlab="Observed y values",xlim=c(0,1),breaks=seq(from=0,to=1,by=0.05),col=clr)
	abline(h=0)

	#now place the histogram of the maximum on the (2,1) pane
	clr<-c(rep("white",length(seq(from=0,to=1,by=0.05))))
	clr[maxbreaks[i]]<-"red"
	maxhist<-hist(maxvalues[1:i],main=paste("Histogram of maximum values for ",i," sample(s)"),freq=TRUE,xlab="Observed values of the Maximum",xlim=c(0,1),breaks=seq(from=0,to=1,by=0.05),col=clr)
	abline(h=0)

	#now place the histogram of the minimum on the (2,2) pane	
	clr<-c(rep("white",length(seq(from=0,to=1,by=0.05))))
	clr[minbreaks[i]]<-"blue"
	minhist<-hist(minvalues[1:i],main=paste("Histogram of minimum values for ",i," sample(s)"),freq=TRUE,xlab="Observed values of the Minimum",xlim=c(0,1),breaks=seq(from=0,to=1,by=0.05),col=clr)
	abline(h=0)

	if ((i>30)&&(i<151)){
		par(ask=FALSE)
		Sys.sleep(0.1)
	}else if (i==151) {
		par(ask=TRUE)
	}
}

