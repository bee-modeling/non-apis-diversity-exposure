
#### code for processing and analyzing the beetool dataset

dev.off()

#### BEE TOOL
### here, we load and process the bee data 
file<-(paste0(root_data_in,"/beetoolALL2023.csv"))
beetool<-data.table::fread(file)
head(beetool)


unique(beetool$identifiedBy)
unique(beetool$institutionCode)


#### EESC 
file<-(paste0(root_data_in,"/eescdata.csv"))
eesc<-data.table::fread(file)

head(eesc)
names(eesc)

eesc<-eesc[!is.na(eesc$decimalLatitude),]

eesc <-st_as_sf(eesc, coords=c("decimalLongitude","decimalLatitude"), crs=4326) 


#### convert bee tool ----
# 
# beemap<-st_as_sf(beetool, coords=c("decimalLongitude","decimalLatitude"), crs=4326) 
# rm(beetool)
# 
# #remove ones with no data on month of sighting
# #beemap<-beemap[!is.na(beemap$month),]
# 
# #plot(beemap$geometry)
# # max(beemap$year)
# # min(beemap$year)
# 
# #filter prior to 1960
# beemaps<-beemap[beemap$year >= 1960,]
# rm(beemap)
# 
# #remove rows with no info on ID
# beemap_filtf<-beemaps[!is.na(beemaps$gbifID),]
# 
# #remove rows that are not in the US
# beemap_filtf<-beemap_filtf[beemap_filtf$countryCode == "US",]
# 
# #let's remove any museum records
# specimens<-c("HUMAN_OBSERVATION",
#              "OCCURRENCE",
#              "MACHINE_OBSERVATION",
#              "LIVING_SPECIMEN")
# beemap_filtf<-beemap_filtf[beemap_filtf$basisOfRecord %in% specimens,]



#### What does the beetool richness and sample effort look like? ----


#state level 
US <- st_read(paste0(root_data_in,"/cb_2018_us_state_500k.shp"))
USd<-st_transform(US, crs = 4326)
USd$STATEFP<-as.numeric(USd$STATEFP)
USd<-USd[USd$STATEFP < 60 & USd$STATEFP != 15 & USd$STATEFP != 02,]



#county level
county <- st_read(paste0(root_data_in,"/tl_2021_us_county.shp"))
county<-st_transform(county, crs = 4326)
county$STATEFP<-as.numeric(county$STATEFP)
cnty<-county[county$STATEFP < 60 & county$STATEFP != 15 & county$STATEFP != 02,]



plot(st_geometry(USd), col = 'grey', border = 'grey',
     axes = TRUE)
plot(st_geometry(st_centroid(eesc)), pch = 3, col = 'red', add = TRUE)



#### STATE LEVEL 
#which rows intersect with each state?
bee_by_state<-st_intersects(USd,eesc)
#test<-bee_by_state[[1]]
# plot(USd$geometry)
# plot(beemap_filtf[test,], pch=19, col="green", add=TRUE);

#Fitler datasets by state
bee_by_state<-lapply(bee_by_state,function(x){eesc[x,]})

#species richness adn sample effort
bee_diversity_by_state<-sapply(bee_by_state, function(x) length(unique(x$species)))
bee_sample_effort_by_state<-sapply(bee_by_state, function(x) nrow(x))
USd$richness<-bee_diversity_by_state
USd$sampleeffort<-bee_sample_effort_by_state

plot(USd[11],pal=colorRampPalette(magma(10)))
plot(USd[12],pal=colorRampPalette(magma(10)))


#### COUNTY LEVEL 
#which rows intersect with each state?
eesc_by_cnty<-st_intersects(cnty,eesc)
#test<-bee_by_state[[1]]
# plot(USd$geometry)
# plot(beemap_filtf[test,], pch=19, col="green", add=TRUE);

#Fitler datasets by state
bee_by_county<-lapply(eesc_by_cnty,function(x){eesc[x,]})

#species richness adn sample effort
bee_diversity_by_county<-sapply(bee_by_county, function(x) length(unique(x$species)))
bee_sample_effort_by_county<-sapply(bee_by_county, function(x) nrow(x))
cnty$richness<-bee_diversity_by_county
cnty$sampleeffort<-bee_sample_effort_by_county

plot(cnty[19],pal=colorRampPalette(magma(10)))
plot(cnty[20],pal=colorRampPalette(magma(10)))



#### Spatial history----
#reduce to 1990s
eesc_year<-eesc[eesc$year >= 1990,]
beemap_by_county<-lapply(bee_by_county,function(x){eesc_year[x,]})

bee_temporal_cnty_yr<-sapply(bee_by_county, function(x){count(x,year)} )
bee_temporal_cnty_yr<-t(bee_temporal_cnty_yr)


proportion<-apply(bee_temporal_cnty_yr, 1, function(x)length(x[[2]])/33)


cnty$proportion<-proportion
plot(cnty[21],pal=colorRampPalette(magma(10)))


# st_write(beeab, paste0(root_dir,"/beemap_absence.shp"))

#### scrap
#look at some characteristics
# unique(beemaps$individualCount)
# hist(beemap$coordinateUncertaintyInMeters)
# unique(beemap$coordinateUncertaintyInMeters)
# max(beemap$coordinateUncertaintyInMeters)
# 
# length(unique(beemap$species))
# unique(beemaps$basisOfRecord)
# unique(beemaps$institutionCode)
# unique(beemaps$dateIdentified)
# unique(beemaps$identifiedBy)


###let's filter out some more things
#remove iNaturalist
#beemap_noInat<-beemaps[!beemaps$institutionCode == "iNaturalist",]


#remove any with uncertainty > 500m
#beemap_filt<-beemap_filt[!beemap_filt$coordinateUncertaintyInMeters >= 500,]
#head(beemap_filtf)
#st_write(beemap_filt, paste0(root_dir,"/beemap_filtered_f.shp"))



