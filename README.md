
Welcome to the repository for the Laptop price prediction and feature analysis project. This project includes statistical methods such as multiple linear regression (MLR) and hypothesis testing to analyze and predict laptop prices based on various features. Additionally, exploratory data analysis (EDA) and data cleansing have been performed using MySQL. R-syntax separated into visualizations,MLR-modeling and hypothesis testing. PDF document provides a guide to statistical methods.

## Project objective

### Data preparation

Including a full data cleansing process in mySQL, outlier detection using z-score in R for statistical analysis. 

### Visualizations (EDA/model diagnostic) 

Exploratory data analysis with ggplot2, visualizing key findings.
MLR-model diagnostic with ggplot2. 

### Model building  

Multiple linear regression models conducted in R. 

### Model evaluation 

Metrics such as R-squared and RMSE were used to assess model performance. 

### Model diagnostic 

Ensure MLR-assumptions

### Hypothesis testing 

Investigating significant price differences between laptops with and without certain features using statistical tests like the Mann-Whitney U test, given non-normally distributed data.

## Key insights

### Brand

Most Expensive: Razer ($2139), LG ($1342), MSI ($1101)

Least Expensive: Vero ($139), Mediacom ($188), Chuwi ($200)

### Laptop types


Most Expensive: Workstations ($1455), Gaming laptops ($1106)

Least Expensive: Netbooks ($444), Notebooks ($503)

### Memory Configurations


Most Expensive: 1TB SSD + 1TB HDD ($2317), 512GB SSD + 1TB Hybrid ($2071)


Least Expensive: 16GB SSD ($143), 32GB SSD ($182)

### Screen resolutions


Most Expensive: QuadHD


Most Common: FullHD (492 laptops)

### Operating systems


Most Popular: Windows 10

### MLR and hypothesis testing highlights

Significant features from MLR model(3):
Touchscreen: Adds $102.47
IPS Panel: Adds $72.51
RAM (GB): Each GB adds $64.42
Intel CPU: Adds $166.74
macOS: Adds $436.43


Model Performance: Improved model (R-squared = 0.60, RMSE = 253.05) after handling outliers and heteroscedasticity.

## Hypothesis testing results


Touchscreen: Laptops with touchscreens are significantly more expensive (p-value: 1.726e-12).


IPS Panel: Laptops with IPS panels are significantly more expensive (p-value: < 2.2e-16).

# Contributors and contact 
Hampus Nordholm - https://www.linkedin.com/in/hampus-nordholm-0a39941a4/
