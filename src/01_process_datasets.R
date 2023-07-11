
#### code for processing and analyzing the beetool dataset


### here, we load and process the bee data 
file<-(paste0(root_data_in,"/beetoolALL2023.csv"))
beetool<-data.table::fread(file)
head(beetool)

beemap<-st_as_sf(beetool, coords=c("decimalLatitude","decimalLongitude"), crs=4326) 
#rm(beetool)

#remove ones with no data on month of sighting
beemap<-beemap[!is.na(beemap$month),]

#plot(beemap$geometry)
max(beemap$year)
min(beemap$year)

#filter prior to 1960
beemaps<-beemap[beemap$year >= 1960,]


#look at some characteristics
unique(beemaps$individualCount)
hist(beemap$coordinateUncertaintyInMeters)
unique(beemap$coordinateUncertaintyInMeters)
max(beemap$coordinateUncertaintyInMeters)

length(unique(beemap$species))
unique(beemaps$basisOfRecord)
unique(beemaps$institutionCode)
unique(beemaps$dateIdentified)
unique(beemaps$identifiedBy)


###let's filter out some more things
#remove iNaturalist
beemap_noInat<-beemaps[!beemaps$institutionCode == "iNaturalist",]

#remove all that are not observations or related
specimens<-c("HUMAN_OBSERVATION",
"OCCURRENCE",
"MACHINE_OBSERVATION",
"LIVING_SPECIMEN")

beemap_filt<-beemap_noInat[beemap_noInat$basisOfRecord %in% specimens,]

#remove any with uncertainty > 500m

beemap_filt<-beemap_filt[!beemap_filt$coordinateUncertaintyInMeters >= 500,]


st_write(beemap_filt, paste0(root_dir,"/beemap_filtered_f.shp"))

       