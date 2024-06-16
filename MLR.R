
#In this part, i will train a multiple regression model to predict price of laptops.
#Check MLR.pdf if you want a more detailed approach of the model evaluation. 

#Loading libraries
library(tidyverse)
library(ggplot2)
library(car)


#Load data 
laptopclean <- read.csv("C:/Users/hampu/OneDrive/Skrivbord/laptopmining/laptopclean.csv")

#checking data
glimpse(laptopclean)
str(laptopclean)
head(laptopclean)

#Delete variables that is not of interest for this model. 
laptopclean$Unnamed..0 <- NULL
laptopclean$Company <- NULL
laptopclean$TypeName <-NULL
laptopclean$ScreenResolution<-NULL
laptopclean$Cpu<-NULL
laptopclean$Memory<-NULL
laptopclean$Gpu<-NULL

#into factors->dummys
laptopclean$resolution_category <- factor(laptopclean$resolution_category)
laptopclean$touchscreen <- factor(laptopclean$touchscreen)
laptopclean$ips_panel <- factor(laptopclean$ips_panel)
laptopclean$cpubrand <- factor(laptopclean$cpubrand)
laptopclean$OpSys <- factor(laptopclean$OpSys)


#Splitting train/test data 80/20
set.seed(123)
train_index <- sample(nrow(laptopclean), 0.8 * nrow(laptopclean))
train_data <- laptopclean[train_index, ]
test_data <- laptopclean[-train_index, ]

#Set Linux to baseline OS
train_data$OpSys <- relevel(train_data$OpSys, ref = "Linux")

#Fit model(1)
model1<-lm(priceUSD ~.,data=train_data)
summary(model1)

#Predicted values on test data 
predictedtest<-predict(model1,newdata=test_data)

#Residuals for test data 
residualstest<-test_data$priceUSD-predictedtest

#RMSE
RMSE1<-sqrt(mean(residualstest^2))
print(RMSE1)

#training data fitted values 
fv1<-predict(model1,newdata=train_data)
#residuals training data 
restrain1<-train_data$priceUSD-fv1


ggplot(train_data, aes(x = fv1, y = restrain1)) +
  geom_point() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  labs(title = "Predicted values vs standardized residuals",
       x = "Predicted values",
       y = "Standardized residuals")

#Plot shows v-shaped pattern, indicating heteroscedasticity. 
#Assumption of homoscedasticity violated, lets modify the data 
#to check if we can improve the model.

#QQ-plot to check if residuals are normal distributed.

qqnorm(restrain1,col="black")
qqline(restrain1,col="red"

#Checking for multicollinearity 
vif(model1)


#R-squared model1:0.5721 
#RMSE model1:340.39

#Boxplots training data
boxplot(train_data$priceUSD,col="skyblue")
boxplot(train_data$ramGB,col="skyblue")

#histograms
hist(train_data$priceUSD,col="blue")
hist(train_data$ramGB,col="blue")

#There is outliers in priceUSD and ramGB which skews the distribution, let's
#remove them to conduct an hopefully improved model
train_data$outliers<-abs(scale(train_data$priceUSD))>3
train_data2<-train_data[!train_data$outliers,]
train_data$outliersGB<-abs(scale(train_data$ramGB))>3
train_data2<-train_data[!train_data$outliersGB,]

test_data$outliers<-abs(scale(test_data$priceUSD))>3
test_data2<-test_data[!test_data$outliers,]
test_data$outliersGB<-abs(scale(test_data$ramGB))>3
test_data2<-test_data[!test_data$outliersGB,]

#delete outliers TRUE/FALSE columns 
train_data2$outliers<-NULL
train_data2$outliersGB<-NULL

#Visualizations after removing outliers 
boxplot(train_data2$priceUSD,col="skyblue")
hist(train_data2$priceUSD,col="blue")
boxplot(train_data2$ramGB,col="skyblue")
hist(train_data2$ramGB,col="blue")


#Fit new model(2)
model2<-lm(priceUSD ~., data=train_data2)
summary(model2)

#R-squared improved, lets remove the insignificant independent 
#variables to simplify model.

#Fit model(3)
model3<-lm(priceUSD ~.-Inches-weightKG,data=train_data2)
summary(model3)

#Predicted values on test data (2) 
predictedtest2<-predict(model3,newdata=test_data2)

#Residuals for test data 
residualstest2<-test_data2$priceUSD-predictedtest2

#RMSE
RMSE2<-sqrt(mean(residualstest2^2))
print(RMSE2)

#training data fitted values 
fv2<-predict(model1,newdata=train_data2)
#residuals training data 
restrain2<-train_data2$priceUSD-fv2

ggplot(train_data2, aes(x = fv2, y = restrain2)) +
  geom_point() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  labs(title = "Predicted values vs standardized residuals",
       x = "Predicted values",
       y = "Standardized residuals")

#Results model 1:
#R-squared model1:0.5721 
#RMSE model1:340.39

#Results model 3:
#R-squared:0.6013
#RMSE:253.0471

