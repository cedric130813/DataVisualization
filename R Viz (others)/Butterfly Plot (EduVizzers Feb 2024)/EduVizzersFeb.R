# Load library
library(data.table)
library(tidyverse)
library(hrbrthemes)
library(patchwork)

# Load the dataset
EduData = read.csv("SPP_compared_to_SPS_Kindergarteners_20240131.csv")

View(EduData)
class(EduData)

# Replace <10 string with integer 
EduData[EduData$Count.of.Children.Served=="<10",3]=10
EduData$Count.of.Children.Served = as.integer(EduData$Count.of.Children.Served)
class(EduData$Count.of.Children.Served)

# https://www.njtierney.com/post/2022/08/09/ggplot-pyramid/

EduDataSPP = EduData %>%
  filter(Program.Year=="SPP 2018 - 2019 4 Year-Olds") %>%
  filter(Group %in% c("White","Vietnamese",
                 "Two or More Races","Spanish",
                 "Other Asian Languages","Other & Unknown Languages",
                 "Native Hawaiian/ Other Pacific Islander","Male","Hispanic/ Latino",
                 "Female","English","Chinese- All Dialects","Black/African-American",
                 "Asian","American Indian/ Alaskan Native","African Languages")) 

EduDataSPP$Group = factor(EduDataSPP$Group,levels = c("Native Hawaiian/ Other Pacific Islander","American Indian/ Alaskan Native","Vietnamese","Other & Unknown Languages","Other Asian Languages","Chinese- All Dialects","Spanish","African Languages","Asian","Hispanic/ Latino","Black/African-American","Two or More Races","White","Female","Male","English"))

EduDataSPS = EduData %>%
  filter(Program.Year=="SPS 2018 - 2019") %>%
  filter(Group %in% c("White","Vietnamese",
                      "Two or More Races","Spanish",
                      "Other Asian Languages","Other & Unknown Languages",
                      "Native Hawaiian/ Other Pacific Islander","Male","Hispanic/ Latino",
                      "Female","English","Chinese- All Dialects","Black/African-American",
                      "Asian","American Indian/ Alaskan Native","African Languages"))

EduDataSPS$Group = factor(EduDataSPS$Group,levels = c("Native Hawaiian/ Other Pacific Islander","American Indian/ Alaskan Native","Vietnamese","Other & Unknown Languages","Other Asian Languages","Chinese- All Dialects","Spanish","African Languages","Asian","Hispanic/ Latino","Black/African-American","Two or More Races","White","Female","Male","English"))
p1 = ggplot(EduDataSPS,
       aes(x = Count.of.Children.Served,
           y = Group,
           fill = Count.of.Children.Served)) + 
  geom_col(show.legend=FALSE) + 
  labs(subtitle ="SPS 2018 - 2019") + geom_text(aes(label = Count.of.Children.Served),colour="white")

p1 = p1 + theme_modern_rc() + theme(axis.text.y = element_blank(), 
        axis.ticks.y = element_blank(), 
        axis.title.y = element_blank(),
        axis.text.x = element_blank(), 
        axis.ticks.x = element_blank(),
        axis.title.x = element_blank())

p1 
 
p2 = ggplot(EduDataSPP,
       aes(x = -Count.of.Children.Served,
           y = Group,
           fill = Count.of.Children.Served)) + 
  geom_col(show.legend=FALSE) + labs(subtitle="SPP 2018 - 2019") +
  xlim(-4000, 0) + geom_text(aes(label = Count.of.Children.Served),colour="white")

p2 = p2 + theme_modern_rc() + theme(axis.text.x = element_blank(), 
                axis.ticks.x = element_blank(),
                axis.title.x = element_blank()) 

# The idea is to nest the plots under a common title
# From: https://patchwork.data-imaginist.com/articles/guides/annotation.html
# If you need to address only the theme of the patchwork itself (e.g. for making the patchwork title larger than the plot titles), 
# it can be done with the theme argument in plot_annotation()
patchwork = (p2+p1) + plot_annotation(title = "Comparing the demographics: SPP & SPS in 2018",
                                      subtitle = "EduVizzers (Feb 2024) made in R",
theme=theme(plot.title=element_text(hjust=0.5))+theme_modern_rc())

patchwork
