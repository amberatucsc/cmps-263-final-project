#amber oconnell
require(plyr)
require(ggplot2)
require(ggmap)
require(mapdata)
require(reshape2)
require(tm)

options(scipen=999)

setwd('~/Documents/cmps263/final project/')

#res_cap = read.csv("reservoir_capinfo.csv")
res_meta = read.csv("reservoir_metadata.csv")
res_tots = read.csv("area_reservoir_totals_forr.csv")
county_pop = read.csv("california_population_est.csv")
county_usg = read.csv("usco2010_cal_waterusage_est_bycounty.csv")
#res_todate = read.csv("reservoir_storage_todate.csv")
#res_rev = read.csv("CDEC_Stations.csv")

#res_rev_todate = merge(res_rev, res_todate, by.x='STA', by.y='station_id')

###graphing 
keeps = c('county', 'operations_agency', 'latitude', 'longitude')
resmeta_latlon = res_meta[,names(res_meta) %in% keeps]

# getting the map
mapcali <- get_map(location = "California", 
                      zoom = 6, scale = 2)

#plotting the map with some points on it
plot_res <- ggmap(mapcali) + geom_point(data = resmeta_latlon, aes(x = longitude, y = latitude, 
                                                  fill = 'red', 
                                                  alpha = 0.8), 
                       size = 1, shape = 21) +
            guides(fill=FALSE, alpha=FALSE, size=FALSE) #+ 
            #geom_text(aes(label = labels), vjust = 0, hjust = 0)


plot_restotals <- ggplot(data=res_tots, aes(x=factor(area), y=num_resr)) + 
  geom_bar(stat = "identity") + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

#melt cols, X2016_1000_af, X2017_1000_af
year_keeps <- c('area', 'X2016_1000_af', 'X2017_1000_af')
year_res_tots = res_tots[,names(res_tots) %in% year_keeps]
year_res_melt = melt(year_res_tots, id=c('area'))

plot_res20167 <- ggplot(data=year_res_melt, aes(x=factor(area), y=value, fill=variable)) +
                   geom_bar(stat = 'identity', position='dodge') +
                    theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
                      scale_fill_manual(values=color_palette)

#melt cols perc_ave, perc_cap
perc_keeps <- c('area', 'perc_ave', 'perc_cap')
perc_res_tots = res_tots[,names(res_tots) %in% perc_keeps]
perc_res_melt = melt(perc_res_tots, id=c('area'))

color_palette = c("#3399FF", "#33CC00")

plot_percres <- ggplot(perc_res_melt, aes(x=factor(area), y=value, fill=variable)) +
                  geom_bar(stat='identity', position='dodge') +
                    theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
                      scale_fill_manual(values=color_palette)

#populations per county                  
county_map <- map_data("county")
county_map_ca = subset(county_map, region=='california')
state_map <- map_data("state")
state_map_ca = subset(state_map, region=='california')
county_pop$subregion = trimws(removeWords(tolower(county_pop$County), 'county'))
county_pop$region = 'california'

ca_pop_map <- merge(county_map_ca, county_pop, by.x=c("region", "subregion"),
                  by.y=c("region", "subregion"))

final_map <- ggplot(ca_pop_map, aes(x=long, y=lat, group=group)) +
  geom_polygon(aes(fill=Population)) +
  expand_limits(x = ca_pop_map$long, y = ca_pop_map$lat) +
  coord_map("polyconic") + 
  geom_path( data = state_map_ca , colour = "white") + 
  ggtitle("Estimated Population for 2015 by County")

#usg per county 2010
county_usg$subregion = trimws(removeWords(tolower(county_usg$COUNTY), 'county'))
county_usg$region = 'california'

ca_usg_map <- merge(county_map_ca, county_usg, by.x=c('region', 'subregion'),
                    by.y=c("region", "subregion"), all.x=TRUE)

usg_map <- ggplot(ca_usg_map, aes(x=long, y=lat, group=group)) +
            geom_polygon(aes(fill=DO.TOTAL)) +
            expand_limits(x = ca_pop_map$long, y = ca_pop_map$lat) +
            coord_map("polyconic") + 
            geom_path( data = state_map_ca , colour = "white") + 
            ggtitle("Water Usage per County for 2010")




