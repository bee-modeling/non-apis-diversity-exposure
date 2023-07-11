### non-apis diversity 

### 00 Setup of directories and file paths

# Edited by E. Paulukonis October 2022

library(sp)
library(sf)
library(stars)
library(rgeos)
library(rgdal)
library(terra)
library(raster)
library(stars)
library(abind)
library(dplyr)
library(ggplot2)
library(cowplot)
library(grid)
library(foreign)
library(progress)
library(parallel)
library(foreach)
library(gridExtra)
library(stringr)
library(smoothr)
library(exactextractr)
library(data.table)
library(gtools)
library(gstat)

library(beecoSp)


who_is_running<-'eap'
#who_is_running<-'stp'
if(Sys.info()[4]=="LZ2626UTPURUCKE"){
  root_dir <- file.path("c:", "git", "pollinator_probabilistic_loading")
}else if (Sys.info()[4]=="LZ26EPAULUKO"){
  root_dir <- 'C:/Users/EPAULUKO/OneDrive - Environmental Protection Agency (EPA)/Profile/Documents/GitHub/non-apis-diversity-exposure'
}else{
  root_dir <- file.path("/work", "HONEYBEE", who_is_running, "non-apis-diversity-exposure")
}
print(root_dir)

memory.limit(size=56000)

root_data_in <- file.path(root_dir, "data")
root_src <- file.path(root_dir, "src")
cdl_dir_all<-file.path(root_data_in, "CDL")
pest_dir<-file.path(root_data_in, "output_pesticides")
