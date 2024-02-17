library(tidyverse)
library(tidytuesdayR)
library(ggx)
library(patchwork)
library(hrbrthemes)

isc_grants <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-02-20/isc_grants.csv')

# year	integer	The year in which the grant was awarded.
# group	integer	Whether the grant was awarded in the spring cycle (1) or the fall cycle (2).
# title	character	The title of the project.
# funded	integer	The dollar amount funded for the project.
# proposed_by	character	The name of the person who requested the grant.
# summary	character	A description of the project.
# website	character	The website associated with the project, if available.

isc_grants$group = factor(isc_grants$group)
levels(isc_grants$group)

ggplot(data=isc_grants, 
       mapping=aes(x=year))+
  geom_bar()+
  gg_("add 'Hello World' as plot title")

isc_2023 = filter(isc_grants, year == 2023)
isc_2022 = filter(isc_grants, year == 2022)
isc_2021 = filter(isc_grants, year == 2021)
isc_2020 = filter(isc_grants, year == 2020)

f = ggplot(isc_2020, aes(x=group, y=funded))

f + geom_col()
f + geom_boxplot()

# non ggplot2 version
library(treemap)

treemap(isc_2023,
        index="title",
        vSize="funded",
        type="index"
)

treemap(isc_2022,
        index="title",
        vSize="funded",
        type="index"
)

treemap(isc_2021,
        index="title",
        vSize="funded",
        type="index"
)

treemap(isc_2020,
        index="title",
        vSize="funded",
        type="index"
)

# ggplot2 version
library(treemapify)
library(showtext)
font_add_google("Handlee", family = 'sans-serif')
showtext_auto()

p1 = ggplot(isc_2020, aes(area = funded, fill = funded, 
                          label = paste(title, funded, sep = "\n"))) +
  geom_treemap() + 
  geom_treemap_text(place = "topleft",
                    min.size = 7,
                    size = 9,reflow = T)+
  gg_("remove legend") +
  ggtitle("ISC 2020")+
  scale_fill_gradient(low = "#83F2F6", high = "#08ACB1", na.value = NA)

p1

p2 = ggplot(isc_2021, aes(area = funded, fill = funded, 
                          label = paste(title, funded, sep = "\n"))) +
  geom_treemap() + 
  geom_treemap_text(place = "topleft",
                    min.size = 8,
                    size = 9,reflow = T)+
  gg_("remove legend") +
  ggtitle("ISC 2021")+
  scale_fill_gradient(low = "lightblue", high = "#0080FF", na.value = NA)

p2

p3 = ggplot(isc_2022, aes(area = funded, fill = funded, 
                          label = paste(title, funded, sep = "\n"))) +
  geom_treemap() + 
  geom_treemap_text(colour = "black",
                    place = "topleft",
                    min.size = 8,
                    size = 9,
                    reflow = T)+
  ggtitle("ISC 2022")+
  scale_fill_gradient(low = "#E0A9E5", high = "#B75FCD", na.value = NA)+
  gg_("remove legend")

p3

p4 = ggplot(isc_2023, aes(area = funded, fill = funded, 
                          label = paste(title, funded, sep = "\n"))) +
  geom_treemap() + 
  geom_treemap_text(colour = "black",
                    place = "topleft",
                    min.size = 8,
                    size = 9,
                    reflow = T)+
  scale_fill_gradient(low = "yellow", high = "orange", na.value = NA)+
  gg_("remove legend")+
  ggtitle("ISC 2023")

p4

(p1+p2)/(p3+p4) + 
  plot_layout(guides='collect')+
  plot_annotation(title = "R Consortium ISC Grants - #TidyTuesday 2024-02-20",
                  subtitle = "The R Consortium Infrastructure Steering Committee (ISC) Grant Program will accept proposals again between Mar 1 and Apr 1, 2024\n (and then again in the fall). Check out how funded amounts changed over time.\n@cedric130813", 
                  theme = theme_ipsum_pub())
theme_classic()
