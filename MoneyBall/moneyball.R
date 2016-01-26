# Get R set up
# Install R https://cran.r-project.org/bin/macosx/R-3.2.2.pkg​
# Install R-Studio - https://download1.rstudio.org/RStudio-0.99.484.dmg
install.packages('devtools')
install.packages('pryr')

library(devtools)
library(pryr)

############################
# Identify the question
############################

# What is the minimum requirement to make it to the playoffs?

############################
# Understand the data
############################

# Use the baseball file and make sure it is named "baseball.csv"
# to get a local file- set working directory to the data folder
# (Session > Set Working Directory > Choose directory)  OR setwd("x")
baseball = read.csv("baseball.csv")

# Understand what the variables mean

# Team              = Team
# League            = Which league they are in
# Year              = What year this data comes from
# RS                = Runs Scored
# RA                = Runs allowed
# W                 =	wins
# OBP     	        = on-base percentage
# SLG	              = Slugging percentage- total bases/at bats
# BA      	        = Batting average
# Playoffs	        = Did they make the playoffs?
# RankSeason	      = Their rank during the regular season?
# RankPlayoffs      = Their rank during the playoffs?
# G	                = Games played
# OOBP	            = Opponents On-Base Percentage
# OSLG	            = Opponents Slugging percentage


###########################
# Explore the data
###########################

# See the dataset
View(baseball)

# See the first 6 rows of the dataset
head(baseball)

# What types of variables are in this data set? Get the structure.
str(baseball)

# We won't be able to use all of these variables why?  (Subset to only include moneyball years)
moneyball = subset(baseball, Year < 2002)
str(moneyball)

# What can we learn from this visualization?
plot(moneyball)

# What can we learn from this?
plot(moneyball$OBP ~ moneyball$BA)

# How many games does a baseball team need to win to get to the playoffs- Domo (95)

# How does a baseball team win a game?
# The A's computed that they needed to score 135 more points than they allowed in order to win 95
# games.  Let's see if we can verify this.
# Compute Run Difference and add as a new field.
moneyball$RD = moneyball$RS - moneyball$RA
str(moneyball)

# Run one linear regression
WinsReg = lm(W ~ RD, data=moneyball)
summary(WinsReg)

# What do all of these numbers mean?
# 88% explained by runs difference

# Show the plot of the variables
plot(moneyball$W ~ moneyball$RD)

# Plot our regression on the graph
abline(WinsReg, col = "red")

# Let's use this model to predict how many runs we need to win 95 games. WHITE BOARD TIME! y=mx+b
# or wins=.1058(runs difference) + 80.8814
# OR 95 <= .1058(runs difference) + 80.8814 OR RD >= (95-80.8814)/.1058
(95-80.8814)/.1058

# Ok, so now that we know that we need to score 135 more runs that our competitors this season, the
# question becomes, how do score more runs?
# Most other teams at the time looked at BA but the A's discovered that OBP and SLG were better
# predictors of runs scored.  
# Thus, BA was overvalued by the industry.  Let's confirm that.

# We want to find the best predictor of RS
# Regression model to predict runs scored
RunsReg = lm(RS ~ OBP + SLG + BA, data=moneyball)
summary(RunsReg)

# If you look at our coefficients, we see that the coefficient for batting average is negative.
# This says that all other things being equal, a team with a higher batting average will score fewer
# runs, but this is a bit counterintuitive.
# What's going on here is a case of multicollinearity. These three hitting statistics are highly
# correlated, so it's hard to interpret our model.
# Let's see if we can remove Batting Average, the variable with the negative coefficient and the least
# significance, to see if we can improve the interpretability of our model.
RunsReg = lm(RS ~ OBP + SLG, data=moneyball)
summary(RunsReg)

# In our dataset we also have OOBP and OSLG which is opponent data against our picher and fielders-
# let's create a model for how many runs we'll allow
RunsReg = lm(RA ~ OOBP + OSLG, data=moneyball)
summary(RunsReg)

# So now, let's try and predict how many games the 2002 A's will win
# we are estimating with team stats off general performance from last year
# if we look at 2001 stats OAK had OBP of .345 and SLG of .439
# our linear equation was -804.63+2737.77*(OBP)+1584.91*(SLG)
NYRS = -804.63+2737.77*(.345)+1584.91*(.439)
print(NYRS)

# that's our estimate for runs they should get
# our estimate for RA next season comes from our RA Linear equation -837.38+2913.60*(OOBP)+1514.29*(OSLG)
# our 2001 stats for OOBP .308 and OSLG was .38
NYRA = -837.38+2913.60*(.308)+1514.29*(.38)
print(NYRA)

# Now we can predict the number of wins for 2002
# the equation for that was wins=.1058(runs difference) + 80.8814
NYW = .1058*(NYRS-NYRA) + 80.8814
print(NYW)

# Let's compare that to actual performance in 2002- the A's actually had 800 RS, 654 RA and 103 Wins

# If you want to generate a new row with predicted values you can do so using predict(x.lm, new_values)
# and I think rbind.fill to add the new row/data and push it into Domo
create(moneyball, name = "put a name in here", description = "put a description in here")
