library(tidyverse)
library(tidytuesdayR)
library(ggx)
library(patchwork)

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

p2023 = ggplot(data=isc_2023, 
       mapping=aes(x=group, y=title))+
  geom_raster(aes(fill=funded))

p2023

p2022 = ggplot(data=isc_2022, 
               mapping=aes(x=group, y=title))+
  geom_raster(aes(fill=funded))

p2021 = ggplot(data=isc_2021, 
               mapping=aes(x=group, y=title))+
  geom_raster(aes(fill=funded))

p2020 = ggplot(data=isc_2020, 
               mapping=aes(x=group, y=title))+
  geom_raster(aes(fill=funded))

p2023 + p2022

