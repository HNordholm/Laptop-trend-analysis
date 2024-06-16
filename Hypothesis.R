

#Libraries 
library(tidyverse)
library(ggplot2)

#Load data 
laptopclean <- read.csv("C:/Users/hampu/OneDrive/Skrivbord/laptopmining/laptopclean.csv")


#Subset data touchscreen, ips_panel into groups yes/no
touchscreen_yes <- laptopclean$priceUSD[laptopclean$touchscreen=="yes"]
touchscreen_no <- laptopclean$priceUSD[laptopclean$touchscreen=="no"]
ipspanel_yes <- laptopclean$priceUSD[laptopclean$ips_panel=="yes"]
ipspanel_no <- laptopclean$priceUSD[laptopclean$ips_panel=="no"]

#summary stat
summary(touchscreen_yes)
summary(touchscreen_no)
summary(ipspanel_yes)
summary(ipspanel_no)


#Histograms touchscreen 
hist(touchscreen_yes,col="blue")
hist(touchscreen_no,col="blue")

#Histograms ips-panel
hist(ipspanel_yes,col="blue")
hist(ipspanel_no,col="blue")

#Normality test touchscreen
shapiro.test(touchscreen_yes)
shapiro.test((touchscreen_no))

#normality test ips-panel
shapiro.test(ipspanel_yes)
shapiro.test(ipspanel_no)

#Touchscreen and ips-panel yes/no does not follow a normal distribution, normality
#test (shapiro wilk) rejecting null:s with p-value:s > 0.05 

#Densityplot touchscreen yes/no
ggplot(laptopclean, aes(x = priceUSD, fill = touchscreen)) +
  geom_density(alpha = 0.4) +
  labs(title = "Densityplot of laptop prices by touchscreen",
       x = "Price(USD)",
       fill = "Touchscreen") +
  theme_minimal()

#Densityplot ips-panel yes/no
ggplot(laptopclean,aes(x=priceUSD,fill=ips_panel))+
  geom_density(alpha=0.4)+
  labs(title="Densityplot of laptop prices by IPS-panel",
  x="Price(USD)",
  ill="ips_panel")+
  theme_minimal()

#Whitney hypothesis testing, touchscreen

testTSmedian <- wilcox.test(touchscreen_yes,touchscreen_no,
alternative="greater",correct=TRUE)
#print result 
print(testTSmedian)

#Whitney hypothesis testing, ips-panel

testIPSpanel<- wilcox.test(ipspanel_yes,ipspanel_no,
alternative="greater",correct=TRUE)
#print result
print(testIPSpanel)





