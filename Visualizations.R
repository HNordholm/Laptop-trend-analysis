
#Loading neccesary packages
library(tidyverse)

#Load data 
laptopclean <- read.csv("C:/Users/hampu/OneDrive/Skrivbord/laptopmining/laptopclean.csv")

#Data cleaned in mySQL workbench.
#Let's start!

#Top 10 most expensive laptops by company on average 
top10expensive<- laptopclean %>% 
  group_by(Company) %>% 
  summarize(averageprice=mean(priceUSD)) %>% 
  arrange(desc(averageprice)) %>% 
  slice_head(n=10)

#Barchart visualization DESC left to right 
ggplot(top10expensive, aes(x =reorder(Company,-averageprice), y=averageprice)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  theme_minimal() +
  labs(title = "Top10 AVGprices of laptops by company",
  x = "Company",y = "AVGprice(USD)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


#Average price by type
avgpbytype <- laptopclean %>%
  group_by(TypeName) %>%
  summarize(avgpbytype = mean(priceUSD))

#Barchart visualization DESC average price by type 
ggplot(avgpbytype, aes(x = reorder(TypeName, -avgpbytype),y=avgpbytype,
    fill = avgpbytype)) +
    geom_bar(stat = "identity") +
    labs(title = "Average price by type",
    y = "AVGprice(USD)") +
    scale_fill_gradient(low ="lightblue",high="darkblue") +
    theme_minimal() +
    theme(axis.text.x=element_text(angle =45,hjust = 1))

# Let's visualize the difference in prices between laptops with 
# IPSpanel and laptops without IPSpanel 

#AVgprice IPS panel
ggplot(laptopclean, aes(x =ips_panel,y=priceUSD,fill=ips_panel)) +
  geom_bar(stat = "summary", fun = "mean", position = "dodge") +
  labs(title = "Price comparison:IPS panel/non-IPS panel",
  x = "IPS panel",
  y = "Average price(USD)")

#AVGprice touchscreen
ggplot(laptopclean, aes(x=touchscreen,y=priceUSD,fill=touchscreen)) +
  geom_bar(stat = "summary", fun = "mean", position = "dodge") +
  labs(title = "Price comparison:Touchscreen/non-touchscreen",
  x = "Touchscreen",
  y = "Average price(USD)")

#Barchart AVGprice resolution category
ggplot(laptopclean, aes(x = resolution_category,
  y = priceUSD, fill = resolution_category))+
  geom_bar(stat = "summary", fun = "mean", position = "dodge",fill="steelblue")+
  labs(title = "AVGprice by resolutioncategory",
  x = "resolution",
  y = "Average Price (USD)")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#Barchart AVGprice by CPUbrand
ggplot(laptopclean, aes(x = cpubrand,
  y = priceUSD, fill=cpubrand))+
  geom_bar(stat="summary",fun= "mean",position="dodge",fill="steelblue")+
  labs(title = "AVGprice by CPUbrand",
  x = "CPUbrand",
  y = "Average Price (USD)")+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#Price distribution 
ggplot(laptopclean,aes(x = priceUSD))+
  geom_histogram(binwidth = 100,fill = "skyblue",color="black")+
  labs(title = "Distribution of price in USD",
  x = "Price(USD)",
  y = "Frequency")+
  theme_minimal()

#ramGB distribution 
ggplot(laptopclean,aes(x=ramGB))+
  geom_histogram(binwidth=3,fill="skyblue",color="black")+
  labs(title = "Distribution of ramGB",
  x = "ramGB",
  y = "Frequency")+
  theme_minimal()

#memoryGB distribution 
ggplot(laptopclean,aes(x=memoryGB))+
  geom_histogram(binwidth=150,fill="skyblue",color="black")+
  labs(title = "Distribution of ramGB",
  x = "ramGB",
  y = "Frequency")+
  theme_minimal()

#Weight distribution 
ggplot(laptopclean,aes(x=weightKG))+
  geom_histogram(binwidth=0.1,fill="skyblue",color="black")+
  labs(title = "Distribution of weight in KG",
  x="KG",
  y="Frequency")+
  theme_minimal()


#Inches distribution
ggplot(laptopclean,aes(x=Inches))+
  geom_histogram(binwidth=0.8,fill="skyblue",color="black")+
  labs(title = "Distribution of inches",
  x="inches",
  y="Frequency")+
  theme_minimal()



