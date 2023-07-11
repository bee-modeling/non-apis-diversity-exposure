#### code for processing and analyzing the pesticide loading datasets


raw_CDL_all<- readRDS(file=paste0(cdl_dir_all,"/CDL/raw_CDL.RData"))
CDL<-lapply(raw_CDL_all, stack)
names(CDL)<-substring(names(CDL),5,6 )
rm(raw_CDL_all)


date <- '20210325' # date for aggregate estimates (bee toxic load)
cmp_date <- '20210325' # date for the compound-specific table 

all_states<-readOGR(root_data_in, layer = "cb_2018_us_state_500k") #read in states
all_states@data
states<-all_states$STUSPS


#states<-range$STUSPS #get all states associated with RPBB
rec <- reclasstables(filepath = paste0(pest_dir, "/beecosP/beetox_I_cdl_reclass.", date, ".csv"),
                     state = states,
                     year = 2008:2021,
                     write_reclass = T,
                     outfolder = paste0(pest_dir, "/beecosP/output/reclasskeys/insecticidestest"))
# specify path to CDL raster file


test_imi <- reclasstables(filepath = paste0(pest_dir,"/beecosP/beetox_cmpd_cdl_reclass_", cmp_date, "/IMIDACLOPRID.csv"),
                          state = states,
                          year = 2008:2021,
                          write_reclass = T,
                          outfolder = paste0(pest_dir, "/beecosP/output/reclasskeys/imidaclopridtest"))

#read in CDL from 2021
#from our own reclassed datasets
cdl_path <- paste0(cdl_dir_all, "/CDL2021.tif")

# contact toxicity for insecticides
for(i in 1:length(rec)){
  
CDL_reclass(rasterpath = cdl_path,
            reclasstable = rec[[i]],
            from = "value",
            to = "kg_ha",
            writerast = TRUE,
            outpath = paste0(pest_dir, "/output"),
            meanreclass = FALSE)

}
