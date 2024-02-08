library(tidyverse)
library(data.table)
library(reshape2)
library(viridis)
library(hrbrthemes)

heridata = read.csv("heritage.csv")

# Convert an object into a molten data frame
# melt converts long format to wide format data
# cast takes long-format data and casts it into wide-format data*
heridata = melt(heridata,value.name = "value")

heridata$country = factor(heridata$country, levels = c("Sweden","Denmark","Norway"))

totals = heridata %>%
  group_by(variable) %>%
  summarize(total = sum(value))

ggplot(heridata, aes(fill=country, y=value, x=variable)) + 
  geom_bar(position="stack", stat="identity")+
  scale_fill_manual(values = c("#3274D8", "#F05440", "#283250")) +
  ggtitle("A few world heritage sites",
          subtitle = "Stacked bar chart of the number of World Heritage sites in Denmark,\nNorway and Sweden in 2004 and 2022") +
  theme_ipsum() +
  ylab("")+
  xlab("")+
  labs(caption = "@cedric130813 | #TidyTuesday")+
  geom_text(aes(label = value), colour = "white", position = position_stack(vjust = 0.5)) +
  geom_text(data = totals,aes(x=variable, y=total, label = total, fill=NULL,fontface = "bold"), nudge_y = 3)+
  theme(plot.title = element_text(size = 15), 
        plot.subtitle = element_text(size = 10) 
  ) 

  #?geom_text
# ----------------------------
install.packages("ggpubr")
library(ggpubr)

ggdotchart(heridata, x = "variable", y = "value",
           color = "country",                                # Color by groups
           palette = c("#3274D8", "#F05440", "#283250"), # Custom color palette
           sorting = "descending",                       # Sort value in descending order
           add = "segments",                             # Add segments from y = 0 to dots
           rotate = T,                                # Rotate vertically
           group = "country",                                # Order by groups
           dot.size = 5.5,                               # Large dot size
           label = heridata$value,                        # Add mpg values as dot labels
           font.label = list(color = "white", size = 7, 
                             vjust = 0.5,face="bold")
) + labs(caption = "@cedric130813 | #TidyTuesday") +
  ggtitle(label = "A few world heritage sites",subtitle = "Cleveland dot plot of the number of World Heritage sites in Denmark,\nNorway and Sweden in 2004 and 2022")+
  theme(plot.title = element_text(size = 15,face = "bold"), 
        plot.subtitle = element_text(size = 10)) + ylab("") + xlab("")
        