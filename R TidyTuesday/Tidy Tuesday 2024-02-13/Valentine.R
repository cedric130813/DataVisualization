# Load necessary library
library(ggplot2)
library(reshape2)
library(tidyverse)
library(tidytuesdayR)
library(wesanderson)

data <- tidytuesdayR::tt_load('2024-02-13')

historical_spending <- data$historical_spending
gifts_age <- data$gifts_age
gifts_gender <- data$gifts_gender

historical_spending = subset(historical_spending, select = -c(PercentCelebrating, PerPerson) )

# Melt the data frame for better plotting
melted_data <- melt(historical_spending, id.vars = "Year")

# Plot using ggplot2
ggplot(melted_data, aes(x = Year, y = value, fill = variable)) +
  geom_area() +
  labs(
    title = "Spending on Valentine's Day Gifts Over the Years",
    x = "Year",
    y = "Amount (USD)",
    fill = "Gift Type"
  ) + scale_fill_manual(values=wes_palette(n=7, name="Zissou1Continuous")) +
  theme_minimal() +
  theme(legend.position = "right")

