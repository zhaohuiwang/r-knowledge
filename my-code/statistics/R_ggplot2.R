#http://r-statistics.co/Complete-Ggplot2-Tutorial-Part2-Customizing-Theme-With-R-Code.html
#https://tutorials.iq.harvard.edu/R/Rgraphics/Rgraphics.html#geometric_objects_and_aesthetics
#https://ggplot2.tidyverse.org/reference/
#http://www.sthda.com/english/articles/32-r-graphics-essentials/132-plot-grouped-data-box-plot-bar-plot-and-more/

# All plots are composed of the data, the information you want to visualise,
# and a mapping, the description of how the data’s variables are mapped to aesthetic attributes. 
# A layer is a collection of geometric elements and statistical transformations.
# Geometric elements, geoms for short, represent what you actually see in the plot: points, lines, polygons, etc.
# Statistical transformations, stats for short, summarise the data: for example, binning and counting observations to create a histogram, or fitting a linear model.


# Setup
  options(scipen=999)  # turn off scientific notation like 1e+06
  library(ggplot2)
  library(markdown)
  data("midwest", package = "ggplot2")  # load the data
  # midwest <- read.csv("http://goo.gl/G1K41K") # alt source 

# Init Ggplot
  ggplot(midwest, aes(x=area, y=poptotal))  # Aesthetic mappings.
  ggplot(midwest, aes(x=area, y=poptotal)) + geom_point() # create scatterplots. geom: geometric object

# Adjusting the X and Y axis limits
  # Method 1: By deleting the points outside the range
  g <- ggplot(midwest, aes(x=area, y=poptotal)) + geom_point() + geom_smooth(method="lm")  
  # set se=FALSE to turnoff confidence bands
  plot(g)
  
  # Delete the points outside the limits
  g + xlim(c(0, 0.1)) + ylim(c(0, 1000000))   # deletes points
  # g + xlim(0, 0.1) + ylim(0, 1000000)   # deletes points
  
  #Method 2: Zooming In
  # Zoom in without deleting the points outside the limits. 
  g <- ggplot(midwest, aes(x=area, y=poptotal)) +
    geom_point() +
    geom_smooth(method="lm")
  # As a result, the line of best fit is the same as the original plot.
  g1 <- g + coord_cartesian(xlim=c(0,0.1), ylim=c(0, 1000000))  # zooms in
  plot(g1)
  
  # Add Title and Labels
  g1 + labs(title="Area Vs Population", subtitle="From midwest dataset", y="Population", 
            x="Area", caption="Midwest Demographics")
  # or
  g1 + ggtitle("Area Vs Population", subtitle="From midwest dataset") + xlab("Area") + ylab("Population")
  
  
  # Full Plot call
  library(ggplot2)
  ggplot(midwest, aes(x=area, y=poptotal)) + 
    geom_point() + 
    geom_smooth(method="lm") + 
    coord_cartesian(xlim=c(0,0.1), ylim=c(0, 1000000)) + 
    labs(title="Area Vs Population", subtitle="From midwest dataset", 
         y="Population", x="Area", caption="Midwest Demographics")
  
# How to Change the Color and Size of Points/lines  
  library(ggplot2)
  ggplot(midwest, aes(x=area, y=poptotal)) + 
    geom_point(col="steelblue", size=3) +   # Set static color and size for points
    geom_smooth(method="lm", col="firebrick") +  # change the color of line
    coord_cartesian(xlim=c(0, 0.1), ylim=c(0, 1000000)) + 
    labs(title="Area Vs Population", subtitle="From midwest dataset", y="Population", x="Area", caption="Midwest Demographics")
  
  library(ggplot2)
  gg <- ggplot(midwest, aes(x=area, y=poptotal)) + 
    geom_point(aes(col=state), size=3) +  # Set color to vary based on state categories.
    geom_smooth(method="lm", col="firebrick", size=2) + 
    coord_cartesian(xlim=c(0, 0.1), ylim=c(0, 1000000)) + 
    labs(title="Area Vs Population", subtitle="From midwest dataset", y="Population", x="Area", caption="Midwest Demographics")
  plot(gg)
  #colo, size, shape, stroke (thickness of boundary) and fill (fill color) can be used to discriminate groupings.
  
  gg + theme(legend.position="None")  # remove legend
  gg + scale_colour_brewer(palette = "Set1")  # change color palette
  
  
# How to Change the X and Y Axis Text and its Location
  
  # Set the breaks
  gg + scale_x_continuous(breaks=seq(0, 0.1, 0.01)) # Change breaks
  # Had X been a date variable, scale_x_date could be used.
  # scale_y_continuous() is available for Y axis
  
  # Change breaks + label
  gg + scale_x_continuous(breaks=seq(0, 0.1, 0.01), labels = letters[1:11])
  # Let me demonstrate by setting the labels to alphabets from a to k (no meaning to it in this context).
  
  # Reverse X Axis Scale
  gg + scale_x_reverse()
  
  
  # Change Axis Texts
  gg + scale_x_continuous(breaks=seq(0, 0.1, 0.01), labels = sprintf("%1.2f%%", seq(0, 0.1, 0.01))) + 
    scale_y_continuous(breaks=seq(0, 1000000, 200000), labels = function(x){paste0(x/1000, 'K')})
  # user defined function
  # sprintf("%1.2f%%", seq(0, 0.1, 0.01)))  %1.2 specifies a format. The 1st of %% is a escape character.
  
  
  #  heuristic plot response variable vs features
  plot_lm_ci <- function(dta, x_var, y_var){
    plot1 <= ggplot(dta, aes_string(x=x_var, y=y_var)) +
      geom_point(shape=1) +  # using hollow circles
      geom_smooth(method=lm) # add linear regression line
    ggsave(plot1, file = paste0(output_dir, x_var, "_vs_"), y_var, "_ci.png",
           width =18, height=14, unit="cm", dpi=600)
  }
  plot_lm <- function(dta, x_var, y_var){
    plot1 <= ggplot(dta, aes_string(x=x_var, y=y_var)) +
      geom_point(shape=1) +  # using hollow circles
      geom_smooth(method=lm, # add linear regression line
                  se=FALSE)  # do not add shaded confidence region
    ggsave(plot1, file = paste0(output_dir, x_var, "_vs_"), y_var, "_ci.png",
           width =18, height=14, unit="cm", dpi=600)
  }
  plot_lm_ci <- function(dta, x_var, y_var){
    plot1 <= ggplot(dta, aes_string(x=x_var, y=y_var)) +
      geom_point(shape=1) +  # using hollow circles
      geom_smooth()          # add a loess smoothed fit curve with confidence region
  
    ggsave(plot1, file = paste0(output_dir, x_var, "_vs_"), y_var, "_ci.png",
           width =18, height=14, unit="cm", dpi=600)
  }
  plot_box <- function(dta, x_var, y_var){
    plot1 <= ggplot(dta, aes_string(x=x_var, y=y_var, group=x_var)) +
      geom_box() +
      geom_dotplot(binaxis = "y", stackdir="center", dotsize = 1) +
    ggsave(plot1, file = paste0(output_dir, x_var, "_vs_"), y_var, "_box.png",
           width =18, height=14, unit="cm", dpi=600)
  }
for (i in feature_list){
  print(i)
  dta = input_dataFrame
  x_var = i
  dta[, x_var] <- factor(dta[,x_var], levels = c("low", "medum", "high"))
  # take care of the factor order, default is alphabetic 
  plot_box(dta, x_var, "y_var_name")
}
  # Setup
  options(scipen=999)
  library(ggplot2)
  data("midwest", package = "ggplot2")
  theme_set(theme_bw())
  # midwest <- read.csv("http://goo.gl/G1K41K")  # bkup data source
  
  # Add plot components --------------------------------
  gg <- ggplot(midwest, aes(x=area, y=poptotal)) + 
    geom_point(aes(col=state, size=popdensity)) + 
    geom_smooth(method="loess", se=F) + xlim(c(0, 0.1)) + ylim(c(0, 500000)) + 
    labs(title="Area Vs Population", y="Population", x="Area", caption="Source: midwest")
  
  # Call plot ------------------------------------------
  plot(gg)
  
  
  
  # Base Plot
  gg <- ggplot(midwest, aes(x=area, y=poptotal)) + 
    geom_point(aes(col=state, size=popdensity)) + 
    geom_smooth(method="loess", se=F) + xlim(c(0, 0.1)) + ylim(c(0, 500000)) + 
    labs(title="Area Vs Population", y="Population", x="Area", caption="Source: midwest")
  
  # Modify theme components -------------------------------------------
  gg + theme(plot.title=element_text(size=20, 
                                     face="bold", 
                                     family="American Typewriter",
                                     color="tomato",
                                     hjust=0.5,
                                     lineheight=1.2),  # title
             plot.subtitle=element_text(size=15, 
                                        family="American Typewriter",
                                        face="bold",
                                        hjust=0.5),  # subtitle
             plot.caption=element_text(size=15),  # caption
             axis.title.x=element_text(vjust=10,  
                                       size=15),  # X axis title
             axis.title.y=element_text(size=15),  # Y axis title
             axis.text.x=element_text(size=10, 
                                      angle = 30,
                                      vjust=.5),  # X axis text
             axis.text.y=element_text(size=10))  # Y axis text
  
  # Demonstration of dual y-axes using sec.axis
  library(ggplot2)

  p <- ggplot(climate, aes(x = Timestamp))+ 
    geom_line(aes(y = air_temp, colour = "Temperature")) + 
    # adding the relative humidity data, transformed to match roughly the range of the temperature
    geom_line(aes(y = rel_hum/5, colour = "Humidity")) +
    # now adding the secondary axis, following the example in the help file ?scale_y_continuous
    # and, very important, reverting the above transformation 
    scale_y_continuous(sec.axis = sec_axis(~.*5, name = "Relative humidity [%]"))+
    # modifying colours and theme options
    scale_colour_manual(values = c("blue", "red")) +
    labs(y = "Air temperature [?C]",
                x = "Date and time",
                colour = "Parameter") + 
    theme(legend.position = c(0.8, 0.9))

  #@ http://r-statistics.co/ggplot2-Tutorial-With-R.html#1.%20The%20Setup
  
  
  library(ggplot2)
  ggplot(diamonds)  # if only the dataset is known.
  
  # if only X-axis is known. 
  # The Y-axis can be specified in respective geoms.
  ggplot(diamonds, aes(x=carat)) 
  # if both X and Y axes are fixed for all layers.
  ggplot(diamonds, aes(x=carat, y=price))  
  # Each category of the 'cut' variable 
  # will now have a distinct  color, once a geom is added.
  ggplot(diamonds, aes(x=carat, color=cut))  
  # Adding scatterplot geom (layer1) and smoothing geom (layer2).
  ggplot(diamonds, aes(x=carat, y=price, color=cut)) + 
    geom_point() + geom_smooth() 
  # Same as above but specifying the aesthetics inside the geoms.
  ggplot(diamonds) + 
    geom_point(aes(x=carat, y=price, color=cut)) + 
    geom_smooth(aes(x=carat, y=price, color=cut)) 
  
  #  If you want to have the color, size etc fixed 
  # (i.e. not vary based on a variable from the dataframe), 
  # you need to specify it outside the aes(), like this.
  ggplot(diamonds, aes(x=carat), color="steelblue")
  # Remove color from geom_smooth
  ggplot(diamonds) + 
    geom_point(aes(x=carat, y=price, color=cut)) + 
    geom_smooth(aes(x=carat, y=price)) 
  # same but simpler
  ggplot(diamonds, aes(x=carat, y=price)) + 
    geom_point(aes(color=cut)) + 
    geom_smooth()  
  
  # make the shape of the points vary with color feature.
  ggplot(diamonds, 
         aes(x=carat, y=price, color=cut, shape=color)) +
    geom_point()
  
  # add axis lables and plot title.
  # Note: If you are showing a ggplot inside a function, 
  # you need to explicitly save it and 
  # then print using the print(gg)
  gg <- ggplot(diamonds, aes(x=carat, y=price, color=cut)) + 
    geom_point() + 
    labs(title="Scatterplot", x="Carat", y="Price")  
  print(gg)
  # add title and axis text
  # set any to element_blank() and it will vanish entirely
  gg1 <- gg + theme(plot.title=element_text(size=30, face="bold"), 
                    axis.text.x=element_text(size=15), 
                    axis.text.y=element_text(size=15),
                    axis.title.x=element_text(size=25),
                    axis.title.y=element_text(size=25)) + 
    # change legend title(color is set by color attribute
    # at ggplot( , aes())based on cut,
    # here it change the legent title)
    scale_color_discrete(name="Cut of diamonds")
  # Had it been a continuous variable, use
  # scale_shape_continuous(name="legend title"
  # if your legend is based on a fill attribute on a continuous variable
  # scale_fill_continuous(name="legend title").
  print(gg1)
  
  # columns defined by 'cut'
  gg1 + facet_wrap( ~ cut, ncol=3) 
  # facet_wrap(formula) takes in a formula as the argument
  # the left side, row: color; the right side, column: cut
  gg1 + facet_wrap(color ~ cut)  
  # the scales of the X and Y axis are fixed to accomodate all points by default. 
  # to make the scales roam free making the charts look more evenly distributed
  gg1 + facet_wrap(color ~ cut, scales="free") 
  
  gg1 + facet_grid(color ~ cut)   # In a grid
  
  #@ https://rpubs.com/sinhrks/plot_ts
  library(ggfortify)
  # where AirPassengers is a 'ts' object
  autoplot(AirPassengers) + labs(title="AirPassengers")  
  
  #  Plot multiple timeseries on same ggplot
  
  # Approach 1:convert to dataframe, then add multiple layers
  # of time series one on top of the other
  data(economics, package="ggplot2")  # init data
  economics <- data.frame(economics)  # convert to dataframe
  ggplot(economics) + 
    geom_line(aes(x=date, y=pce, color="pcs")) + 
    geom_line(aes(x=date, y=unemploy, col="unemploy")) + 
    scale_color_discrete(name="Legend") + 
    labs(title="Economics") 
  # plot multiple time series using 'geom_line's
  
  # Approach 2: Melt the dataframe using reshape2::melt by 
  # setting the id to the date field. 
  # Then just add one geom_line and 
  # set the color aesthetic to variable 
  # (which was created during the melt).
  library(reshape2)
  df <- melt(economics[, c("date", "pce", "unemploy")], id="date")
  ggplot(df) + geom_line(aes(x=date, y=value, color=variable)) + 
    labs(title="Economics")
  # plot multiple time series by melting
  
  # The disadvantage with ggplot2 is that it is not possible to 
  # get multiple Y-axis on the same plot. 
  # To plot multiple time series on the same scale can 
  # make few of the series appear small. 
  # An alternative would be to facet_wrap it and 
  # set the scales='free'.
  
  df <- melt(economics[, c("date", "pce", "unemploy", "psavert")], id="date")
  ggplot(df) + geom_line(aes(x=date, y=value, color=variable))  + 
    facet_wrap( ~ variable, scales="free")
  
  # By default, ggplot makes a 'counts' barchart, meaning, 
  # it counts the frequency of items specified by the x aesthetic 
  # and plots it. In this format, 
  # you don't need to specify the Y aesthetic. However, 
  # if you would like the make a bar chart of the absolute number, 
  # given by Y aesthetic, you need to set stat="identity" 
  # inside the geom_bar.
  plot1 <- ggplot(mtcars, aes(x=cyl)) + geom_bar() + 
    labs(title="Frequency bar chart")  
  # Y axis derived from counts of X item
  print(plot1)
  
  df <- data.frame(var=c("a", "b", "c"), nums=c(1:3))
  plot2 <- ggplot(df, aes(x=var, y=nums)) + 
    geom_bar(stat = "identity")  
  # Y axis is explicit. 'stat=identity'
  print(plot2)
  
  # The gridExtra package provides the facility to 
  # arrage multiple ggplots in a single grid.
  library(gridExtra)
  grid.arrange(plot1, plot2, ncol=2)
  
  # Flipping coordinates
  df <- data.frame(var=c("a", "b", "c"), nums=c(1:3))
  ggplot(df, aes(x=var, y=nums)) + 
    geom_bar(stat = "identity") + 
    coord_flip() + 
    labs(title="Coordinates are flipped")
  
  #  Adjust X and Y axis limits
  # There are 3 ways to change the X and Y axis limits.
  
  # 1 Using coord_cartesian(xlim=c(x1,x2))
  # 2 Using xlim(c(x1,x2))
  # 3 Using scale_x_continuous(limits=c(x1,x2))
  # Warning: Items 2 and 3 will delete the datapoints that 
  # lie outisde the limit from the data itself. So, 
  # if you add any smoothing line line and such, 
  # the outcome will be distorted. 
  # Item 1 (coord_cartesian) does not delete any datapoint, but 
  # instead zooms in to a specific region of the chart.
  
  ggplot(diamonds, aes(x=carat, y=price, color=cut)) + 
    geom_point() + geom_smooth() + 
    coord_cartesian(ylim=c(0, 10000)) + 
    labs(title="Coord_cartesian zoomed in!")
  
  ggplot(diamonds, aes(x=carat, y=price, color=cut)) + 
    geom_point() + geom_smooth() + ylim(c(0, 10000)) +
    labs(title="Datapoints deleted: Note the change in smoothing lines!")
  #> Warning messages:
  #> 1: Removed 5222 rows containing non-finite values
  #> (stat_smooth). 
  #> 2: Removed 5222 rows containing missing values
  #> (geom_point).
  
  
  
  
  