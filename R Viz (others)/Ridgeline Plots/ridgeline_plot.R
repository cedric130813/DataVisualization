# library
library(ggridges)
library(ggplot2)

# Diamonds dataset is provided by R natively
head(diamonds)

# basic example
ggplot(diamonds, aes(x = price, y = cut, fill = cut)) +
  geom_density_ridges() +
  theme_ridges() + 
  theme(legend.position = "none")

# Shape variation
# library
library(ggridges)
library(ggplot2)
library(dplyr)
library(tidyr)
library(forcats)

# Load dataset from github
data <- read.table("https://raw.githubusercontent.com/zonination/perceptions/master/probly.csv", header=TRUE, sep=",")
data <- data %>% 
  gather(key="text", value="value") %>%
  mutate(text = gsub("\\.", " ",text)) %>%
  mutate(value = round(as.numeric(value),0)) %>%
  filter(text %in% c("Almost Certainly","Very Good Chance","We Believe","Likely","About Even", "Little Chance", "Chances Are Slight", "Almost No Chance"))

# Plot
data %>%
  mutate(text = fct_reorder(text, value)) %>%
  ggplot( aes(y=text, x=value,  fill=text)) +
  geom_density_ridges(alpha=0.6, stat="binline", bins=20) +
  theme_ridges() +
  theme(
    legend.position="none",
    panel.spacing = unit(0.1, "lines"),
    strip.text.x = element_text(size = 8)
  ) +
  xlab("") +
  ylab("Assigned Probability (%)")

# Color relative to numeric value
# library
library(ggridges)
library(ggplot2)
library(viridis)
library(hrbrthemes)

# Plot
ggplot(lincoln_weather, aes(x = `Mean Temperature [F]`, y = `Month`, fill = ..x..)) +
  geom_density_ridges_gradient(scale = 3, rel_min_height = 0.01) +
  scale_fill_viridis(name = "Temp. [F]", option = "C") +
  labs(title = 'Temperatures in Lincoln NE in 2016') +
  theme_ipsum() +
  theme(
    legend.position="none",
    panel.spacing = unit(0.1, "lines"),
    strip.text.x = element_text(size = 8)
  )

# -----------------
# Plot
ggplot(chickwts, aes(x = `weight`, 
                     y = `feed`, 
                     fill = ..x..)) +
  geom_density_ridges_gradient(scale = 1, 
                               rel_min_height = 0.2) +
  scale_fill_viridis(name = "weight (gm)", 
                     option = "A", 
                     alpha = 0.6) +
  labs(title = 'Chick Weights by Feed',
       subtitle = "Ridgeline plot showing distribution of Chick Weights based on the type of feed used",
       caption = "January 2024 | @cedric130813",
       tag = "") +
  theme(
    legend.position="right",
    legend.spacing.x= unit(1.0, 'cm'),
    panel.spacing = unit(0.01, "lines"),
    strip.text.x = element_text(size = 8)
  )+
  theme_ft_rc()

#---------------
# Another Chickweight Dataset

# library
library(ggridges)
library(ggplot2)
library(viridis)
library(hrbrthemes)
library(data.table)
chickwts2 = read.csv("ChickWeight.csv")

chickwts2$Diet = factor(chickwts2$Diet)

ggplot(chickwts2, aes(x = `weight`, 
                     y = `Diet`, 
                     fill = ..x..)) +
  geom_density_ridges_gradient(scale = 0.8, 
                               rel_min_height = 0.2) +
  scale_fill_viridis(name = "weight (gm)", 
                     option = "A", 
                     alpha = 0.6) +
  labs(title = 'Chick Weights by Feed',
       subtitle = "Ridgeline plot showing distribution of Chick Weights based on the type of feed used",
       caption = "January 2024 | @cedric130813",
       tag = "") +
  theme(
    legend.position="right",
    legend.spacing.x= unit(1.0, 'cm'),
   panel.spacing = unit(0.01, "lines"),
    strip.text.x = element_text(size = 8)
  )+
  theme_ft_rc()

?geom_density_ridges_gradient
# Note that due to limitations in R's graphics system, 
# transparency (alpha) has to be disabled for gradient fills.

#-------------------------------
# Another variant which highlights tails probabilities in blue

# library
library(ggridges)
library(ggplot2)
library(viridis)
library(hrbrthemes)
library(data.table)

# load dataset
chickwts2 = read.csv("ChickWeight.csv")
chickwts2$Diet = factor(chickwts2$Diet)

levels(chickwts2$Diet) = c("Normal Diet", 
                           "10% Protein Replacement", 
                           "20% Protein Replacement",
                           "30% Protein Replacement")

ggplot(chickwts2, aes(x = `weight`, 
                      y = `Diet`,
                      fill=0.5 - abs(0.5 - stat(ecdf))))+
  stat_density_ridges(
    geom = "density_ridges_gradient", calc_ecdf = TRUE,
    quantiles = 2, quantile_lines = F
  )+
  labs(title = 'Chick Weights by Feed',
       subtitle = "Ridgeline plot showing distribution of Chick Weights based on the type of feed used\nThe diets used varied based on % of protein in diet compared to normal diet",
       caption = "January 2024 | @cedric130813",
       tag = "") +
  scale_fill_gradient(low = "darkblue", high = "white",
                      name = "Tail probability")+
  theme(
    legend.position="right",
    legend.spacing.x= unit(1.0, 'cm'),
    panel.spacing = unit(0.01, "lines"),
    strip.text.x = element_text(size = 8)
  )+
  theme_ft_rc()

