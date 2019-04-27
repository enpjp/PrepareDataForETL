# Function to parse lat long to UKNG
#' Lat. Long to GBNG
#'
#' This function takes lat long vectors and output format UKNG
#'
#' @param Lat Vector list
#' @param Long Vector list
#'
#' @return GBNG with letters
#' @export Lat.Long.to.GBNG
#' @importFrom "magrittr" "set_colnames"
#' @importFrom "graphics" "filled.contour" "par"
#' @importFrom "grDevices" "colorRampPalette"
#' @importFrom "stats" "na.omit"
#' @importFrom "ggplot2" "ggplot" "aes" "geom_point" "geom_line" "fortify" "geom_polygon"
#' @importFrom "rgeos" "plot"
#' @importFrom "rnrfa" "osg_parse"
#'
#'
Lat.Long.to.GBNG <- function(Lat, Long) {

  ### shortcuts
  ukgrid <- "+init=epsg:27700"
  latlong <- "+init=epsg:4326"
  bng <- '+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=airy +datum=OSGB36 +units=m +no_defs'

  ### Create coordinates variable
  coords <- cbind(Longitude = as.numeric(as.character(Long)),
                  Lattitude = as.numeric(as.character(Lat)))
  coords_df <- as.data.frame(coords)

  # Check which rows have correctly formated Lat Long

  valid.rows <- with( coords_df,
                      grepl("^[0-9.+-]*$", Longitude) &
                      grepl("^[0-9.+-]*$", Lattitude)
                      )
  valid.rows.df <- valid.rows %>% as.data.frame()
  colnames(valid.rows.df) <- c("Valid.Lat.Long")


  # # Need to drop the rows which have NAs
  temp.my.coords_df <-  coords_df[valid.rows,]
  temp.my.data <-  coords_df[valid.rows,]

  ### Create the SpatialPointsDataFrame
  dat_SP <- sp::SpatialPointsDataFrame(temp.my.coords_df,
                                   data = temp.my.data,
                                   proj4string = sp::CRS(latlong))

  ## Convert
  dat_SP_BNG <- sp::spTransform(dat_SP, sp::CRS(bng))
  # Finally have Eastings and Northings appended to the data frame
  df_working <- as.data.frame(dat_SP_BNG)

  # Need to rename the columns

  colnames(df_working)[3] <- c("Easting")
  colnames(df_working)[4] <- c("Northing")


  # Trim the leading digit as this is only used to set the grid ref letters
  #df_working$Easting_trimmed <- round((df_working$Easting/100000)%%1,4) %>% as.character %>% substr(3,10)
  df_working$Easting_trimmed <- df_working$Easting %>% as.character %>% substr(2,6)
  df_working$Easting_lookup <- df_working$Easting %>% as.numeric() %>% substr(1,1)
  #Easting_trimmed_vector <- df_working$Easting_trimmed
  df_working$Northing_trimmed <- df_working$Northing %>% as.character  %>% substr(2,6)
  df_working$Northing_lookup <- df_working$Northing %>% as.numeric() %>% substr(1,1)
  #Northing_trimmed_vector <- df_working$Northing_trimmed

  # Need to look up the grid letter from the National Grid Lookup
  UKNG_Lookup <- array(  c(
    "SV", "SQ", "SL", "SF", "SA", "NV", "NQ", "NL", "NF", "NA", "HV", "HQ", "HL",
    "SW", "SR", "SM", "SG", "SB", "NW", "NR", "NM", "NG", "NB", "HW", "HR", "HM",
    "SX", "SS", "SN", "SH", "SC", "NX", "NS", "NN", "NH", "NC", "HX", "HS", "HN",
    "SY", "ST", "SO", "SJ", "SD", "NY", "NT", "NO", "NJ", "ND", "HY", "HT", "HO",
    "SZ", "SU", "SP", "SK", "SE", "NZ", "NU", "NP", "NK", "NE", "HZ", "HU", "HO",
    "TV", "TQ", "TL", "TF", "TA", "OV", "OQ", "OL", "OF", "OA", "JV", "JQ", "JL",
    "TW", "TR", "TM", "TG", "TB", "OW", "OR", "OM", "OG", "OB", "JW", "JR", "JM"
  ),
  dim = c(13, 7), dimnames = NULL
  ) %>% as.data.frame()
  # lookup Matrix

  for (my.row.number in 1: nrow(df_working) ) {

    #grid_letters <- UKNG_Lookup[df_working$Northing_lookup[my.row.number],df_working$Easting_lookup[my.row.number]] %>% as.character()
    easting <- df_working$Easting_lookup[my.row.number] %>% as.numeric()
    northing <- df_working$Northing_lookup[my.row.number] %>% as.numeric()
    grid_letters <- UKNG_Lookup[northing+1,easting+1] %>% as.character()

    df_working$GridRef <- paste(grid_letters,df_working$Easting_trimmed[my.row.number], df_working$Northing_trimmed[my.row.number], sep ="")

    temp.my.data$GridRef[my.row.number] <- df_working$GridRef[my.row.number]

  }
  # Now Build the output data
  # Make a grid ref column filled with NAs
  valid.rows.df$GridRef <- NA
  # Now add the valid grid refs
  valid.row.numbers <- which(valid.rows.df$Valid.Lat.Long)

  valid.rows.df$GridRef[valid.row.numbers] <- df_working$GridRef[valid.row.numbers]

  return(valid.rows.df)

}

