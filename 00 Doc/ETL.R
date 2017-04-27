require(data.world)
require(dplyr)
require(csv)
require

conn <- data.world(token = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJwcm9kLXVzZXItY2xpZW50OnNpbmlzdGVycm9iZXJ0IiwiaXNzIjoiYWdlbnQ6c2luaXN0ZXJyb2JlcnQ6OjdhZDI2MzMxLWQxOWItNGE3YS1iYTJkLTUzM2EzMzRjY2MzMCIsImlhdCI6MTQ4NDY5NzI2Miwicm9sZSI6WyJ1c2VyX2FwaV93cml0ZSIsInVzZXJfYXBpX3JlYWQiXSwiZ2VuZXJhbC1wdXJwb3NlIjp0cnVlfQ.Lj0KjHrPb7-eIXIP_SWcKPoT5dv1aNotZqn4x54JbvqoBJgyLlvVq5-4Fgc-af0tItOIQUffLbK_jvDF0sMLYw")

df1 <- data.world::query(connection = conn,
                         type = "sql",
                         dataset = "thule179/s-17-dv-final-project",
                         "select 
                         A.AreaName,
                         A.`B01001_001`, 
                         A.`B01001_002`,
                         A.`B01001_003`,
                         A.`B01001_004`,
                         A.`B01001_005`,
                         A.`B01001_006`,
                         A.`B01001_007`,
                         A.`B01001_008`,
                         A.`B01001_009`,
                         A.`B01001_010`,
                         A.`B01001_011`,
                         A.`B01001_012`,
                         A.`B01001_013`,
                         A.`B01001_014`,
                         A.`B01001_015`,
                         A.`B01001_016`,
                         A.`B01001_017`,
                         A.`B01001_018`,
                         A.`B01001_019`,
                         A.`B01001_020`,
                         A.`B01001_021`,
                         A.`B01001_022`,
                         A.`B01001_023`,
                         A.`B01001_024`,
                         A.`B01001_025`,
                         A.`B01001_026`,
                         A.`B01001_027`,
                         A.`B01001_028`,
                         A.`B01001_029`,
                         A.`B01001_030`,
                         A.`B01001_031`,
                         A.`B01001_032`,
                         A.`B01001_033`,
                         A.`B01001_034`,
                         A.`B01001_035`,
                         A.`B01001_036`,
                         A.`B01001_037`,
                         A.`B01001_038`,
                         A.`B01001_039`,
                         A.`B01001_040`,
                         A.`B01001_041`,
                         A.`B01001_042`,
                         A.`B01001_043`,
                         A.`B01001_044`,
                         A.`B01001_045`,
                         A.`B01001_046`,
                         A.`B01001_047`,
                         A.`B01001_048`,
                         A.`B01001_049`,
                         B.`B19001_002`, 
                         B.`B19001_003`,
                         B.`B19001_004`, 
                         B.`B19001_005`, 
                         B.`B19001_006`, 
                         B.`B19001_007`, 
                         B.`B19001_008`, 
                         B.`B19001_009`, 
                         B.`B19001_010`, 
                         B.`B19001_011`, 
                         B.`B19001_012`, 
                         B.`B19001_013`, 
                         B.`B19001_014`, 
                         B.`B19001_015`, 
                         B.`B19001_016`,
                         B.`B19001_017`
                         from `uscensusbureau`.`acs-2015-5-e-agesex`.`USA_All_States` as A,
                         `uscensusbureau`.`acs-2015-5-e-income`.`USA_All_States` as B
                         where A.AreaName = B.AreaName"
                         )

df1Second <- data.world::query(connection = conn,
                               type = "sql",
                               dataset = "thule179/s-17-dv-final-project",         
                               "select
                               C.`Population (2010 Est.)`,
                               C.`Population % of USA`,
                               C.`Internet users June, 2010`,
                               C.`Internet Penetration`,
                               C.`Facebook users August, 2010`,
                               C.`Facebook Penetration`
                               from Facebook as C")

df_InternetConnectivity <- data.world::query(connection = conn, type = "sql",
                                             dataset = "thule179/s-17-dv-final-project",
                                             "SELECT c.State as State, `Internet Connectivity`.`No connection anywhere (%)` as NoConnectionAnywhere, `Internet Connectivity`.`No home connection, but connect elsewhere (%)`
as NoHomeConnection_ConnectElseWhere, `Internet Connectivity`.`Connect at home only (%)` as ConnectAtHomeOnly, 
                                          InternetUsageAtHome.`Internet Usage At Home` as InternetUsageAtHome, InternetUsageAtWork.`Internet Usage At Work` as InternetUsageAtWork,
                                          InternetUsageAtCoffeeShops.InternetUsageAtCoffeeShops as InternetUsageAtCoffeeShops,
                                          InternetUsage.InternetUsage as InternetUsage
                                          FROM `Internet Connectivity.xlsx/Internet Connectivity`as c, `Internet Connectivity.xlsx/InternetUsageAtHome` as h,
                                          InternetUsageAtCoffeeShops as s, InternetUsageAtWork as w, InternetUsage as i
                                          where c.State = h.State and s.State = h.State and h.State = w.State and w.State = i.State")

# Put males into age categories
male0to9 <- df1$B01001_003 + df1$B01001_004
male10to19 <- df1$B01001_005 + df1$B01001_006 + df1$B01001_007
male20to29 <- df1$B01001_008 + df1$B01001_009 + df1$B01001_010 + df1$B01001_011
male30to39 <- df1$B01001_012 + df1$B01001_013
male40to49 <- df1$B01001_014 + df1$B01001_015
male50to59 <- df1$B01001_016 + df1$B01001_017
male60to69 <- df1$B01001_018 + df1$B01001_019 + df1$B01001_020 + df1$B01001_021
male70to79 <- df1$B01001_022 + df1$B01001_023
male80andUp <- df1$B01001_024 + df1$B01001_025

# Put females into age categories
female0to9 <- df1$B01001_027 + df1$B01001_028
female10to19 <- df1$B01001_029 + df1$B01001_030 + df1$B01001_031
female20to29 <- df1$B01001_032 + df1$B01001_033 + df1$B01001_034 + df1$B01001_035
female30to39 <- df1$B01001_036 + df1$B01001_037
female40to49 <- df1$B01001_038 + df1$B01001_039
female50to59 <- df1$B01001_040 + df1$B01001_041
female60to69 <- df1$B01001_042 + df1$B01001_043 + df1$B01001_044 + df1$B01001_045
female70to79 <- df1$B01001_046 + df1$B01001_047
female80andUp <- df1$B01001_048 + df1$B01001_049

# Group income into categories
TenToThirtyK <- df1$B19001_002 + df1$B19001_003 + df1$B19001_004 + df1$B19001_005 + df1$B19001_006
ThirtyToFiftyK <- df1$B19001_007 + df1$B19001_008 + df1$B19001_009 + df1$B19001_010
FiftyToHundredK <- df1$B19001_011 + df1$B19001_012 + df1$B19001_013
HundredToHundredFiftyK <- df1$B19001_014 + df1$B19001_015
HundredFiftyPlus <- df1$B19001_016 + df1$B19001_017

# Bind all the categories into a data frame
df2 <- as.data.frame(cbind(State = df1$AreaName, TotalPopulation = df1$B01001_001, male0to9, male10to19, male20to29, male30to39, male40to49, male50to59, male60to69, male70to79, male80andUp, female0to9, female10to19, female20to29, female30to39, female40to49, female50to59, female60to69, female70to79, female80andUp, TenToThirtyK, ThirtyToFiftyK, FiftyToHundredK, HundredToHundredFiftyK, HundredFiftyPlus), stringsAsFactors = FALSE)

# Change the numeric columns to numeric.
df2[-1] <- as.data.frame(apply(df2[-1], 2, as.numeric))
df2 <- cbind(df2, df1Second)

# Do an inner join by State of df2 and InternetConnectivity
df2 <- merge(df2,df_InternetConnectivity, by ="State")

# remove \n line breaks and commas in rows to convert InternetUsage into numbers
df2[,'InternetUsage'] <- gsub(",","",df2[,'InternetUsage'])
df2[,'InternetUsage'] <- gsub("\n","",df2[,'InternetUsage'])
df2[,'InternetUsageAtCoffeeShops'] <- gsub(",","",df2[,'InternetUsageAtCoffeeShops'])
df2[,'InternetUsageAtCoffeeShops'] <- gsub("\n","",df2[,'InternetUsageAtCoffeeShops'])
df2[,'InternetUsageAtWork'] <- gsub(",","",df2[,'InternetUsageAtWork'])
df2[,'InternetUsageAtWork'] <- gsub("\n","",df2[,'InternetUsageAtWork'])
df2[,'InternetUsageAtHome'] <- gsub(",","",df2[,'InternetUsageAtHome'])
df2[,'InternetUsageAtHome'] <- gsub("\n","",df2[,'InternetUsageAtHome'])
df2$InternetUsage <- as.numeric(df2$InternetUsage)
df2$InternetUsageAtCoffeeShops <-  as.numeric(df2$InternetUsageAtCoffeeShops)
df2$InternetUsageAtWork <-  as.numeric(df2$InternetUsageAtWork)
df2$InternetUsageAtHome <-  as.numeric(df2$InternetUsageAtHome)

# get average internet usage per person for each State
df2$Avg_InternetUsage <- df2$InternetUsage
df2$Avg_InternetUsage <- df2$InternetUsage / df2$TotalPopulation

# get average internet usage at work
df2$Avg_InternetUsageAtWork <- df2$InternetUsageAtWork
df2$Avg_InternetUsageAtWork <- df2$InternetUsageAtWork / df2$TotalPopulation

# get average internet usage at home
df2$Avg_InternetUsageAtHome <- df2$InternetUsageAtHome
df2$Avg_InternetUsageAtHome <- df2$InternetUsageAtHome / df2$TotalPopulation

# get average internet usage at coffee shops
df2$Avg_InternetUsageAtCoffeeShops <- df2$InternetUsageAtCoffeeShops
df2$Avg_InternetUsageAtCoffeeShops <- df2$InternetUsageAtCoffeeShops / df2$TotalPopulation

# Find high, medium, and low ranges of Internet Usage
sorted_df2 <- df2[order(df2$Avg_InternetUsage),] # sort df2 from lowest to highest based on avg_internet usage
low_range <- c(sorted_df2$Avg_InternetUsage[c(0: (51/3))]) # subset states with low Internet Usage
medium_range <- c(sorted_df2$Avg_InternetUsage[c((51/3): (2*51/3))]) # subset states with medium Internet Usage
high_range <- c(sorted_df2$Avg_InternetUsage[c((2*51/3) : 51)]) # subset states with high Internet Usage

# Find high, medium, and low ranges of Internert usage at work
sorted_df2_work <- df2[order(df2$Avg_InternetUsageAtWork ),]
low_range_work <- c(sorted_df2_work$Avg_InternetUsageAtWork[c(0: (51/3))]) 
medium_range_work <- c(sorted_df2_work$Avg_InternetUsageAtWork[c((51/3): (2*51/3))])
high_range_work <- c(sorted_df2_work$Avg_InternetUsageAtWork[c((2*51/3) : 51)])

# Find high, medium, and low ranges of Internert usage at home
sorted_df2_home <- df2[order(df2$Avg_InternetUsageAtHome ),] 
low_range_home <- c(sorted_df2_home$Avg_InternetUsageAtHome[c(0: (51/3))]) 
medium_range_home <- c(sorted_df2_home$Avg_InternetUsageAtHome[c((51/3): (2*51/3))])
high_range_home <- c(sorted_df2_home$Avg_InternetUsageAtHome[c((2*51/3) : 51)]) 

# Find high, medium, and low ranges of Internert usage at coffee shops
sorted_df2_coffee <- df2[order(df2$Avg_InternetUsageAtCoffeeShops),] 
low_range_coffee <- c(sorted_df2_coffee$Avg_InternetUsageAtCoffeeShops[c(0: (51/3))]) 
medium_range_coffee <- c(sorted_df2_coffee$Avg_InternetUsageAtCoffeeShops[c((51/3): (2*51/3))])
high_range_coffee <- c(sorted_df2_coffee$Avg_InternetUsageAtCoffeeShops[c((2*51/3) : 51)]) 

# Create column for Internet Usage Levels
df2$InternetUsageLevel <- df2$InternetUsage
df2$InternetUsageAtHomeLevel <- df2$InternetUsageAtHome
df2$InternetUsageAtWorkLevel <- df2$InternetUsageAtWork
df2$InternetUsageAtCoffeeShopsLevel<- df2$InternetUsageAtCoffeeShops

# Create a function to categorize internet usage level
UsageLevel <- function(col, low_range, medium_range, high_range ){
  for (i in 1:nrow(df2)){
    if(col[i] %in% low_range){
      col[i] = "Low"
    }
    if(col[i] %in% medium_range){
      col[i] = "Medium"
    }
    if(col[i] %in% high_range){
      col[i] = "High"
    }
  }
  result <- col
  return(result)
}

# Get internet usage level by category
df2$InternetUsageLevel <- UsageLevel(df2$Avg_InternetUsage,low_range,medium_range,high_range)
df2$InternetUsageAtHomeLevel <- UsageLevel(df2$Avg_InternetUsageAtHome, low_range_home, medium_range_home, high_range_home)
df2$InternetUsageAtWorkLevel <- UsageLevel(df2$Avg_InternetUsageAtWork, low_range_work, medium_range_work, high_range_work)
df2$InternetUsageAtCoffeeShopsLevel <- UsageLevel(df2$Avg_InternetUsageAtCoffeeShops, low_range_coffee, medium_range_coffee, high_range_coffee)

# export to csv
write.csv(df2,file="./CleanedInternetUsageByState.csv")
table(df2$InternetUsageAtWorkLevel)

interaction(df2$InternetUsageAtHomeLevel, df2$InternetUsageAtWorkLevel)
