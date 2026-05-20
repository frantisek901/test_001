################# Import csv PUFs as R dataframe #################
# Creation: 13 jan 2025
# Last Edit: 11 mar 2025
# Author: Francois Keslair
# Purpose:
# - Assemble all PUFS
# - Extract tagged NAs
# - Assign variable labels
# - Assign value labels
# - The user must save PIAAC_Cycle2 manually
 

library(tidyverse)
library(haven)
library(labelled)
library(readr)

#### we first check the file is sourced and not run. Otherwise readline does not work!!!
FileIsSourced<-sys.status()$sys.calls  %>% as.list %>% 
               map(as.character) %>%  
               unlist %>% 
              {"source" %in% .}

if(!FileIsSourced) {
    stop("You must source this file instead of running it")
    }
 
 #### we first ask for the path where CSVs are
 
folder_csv <- readline("Type here the full path of the folder where the PUFs are located:\n") %>%  
              normalizePath()



#### we load the dictionary. It must be located in the same directory as the PUFs 
invisible(readline(prompt="Make sure to have the dictionary file (label_data_PIAAC.rds) saved here as well. Press [enter] to continue\n\n\n"))


dictionary <- readRDS(paste0(folder_csv,
                              "/label_data_PIAAC.rds"))

value_labels <-dictionary$value_labels 
variable_labels <- dictionary$label %>%  as.list





list_csv<- list.files(path=folder_csv,pattern="prg.*p2.csv",full.names = TRUE)

# list_csv<- list.files(path=folder_csv,pattern="*.csv",full.names = TRUE)



#### And now import and append all csv files
#### caution: we must import all variables as character in order to preserve missing codes (.n, .v etc)

 
PIAAC_Cycle2 <- list_csv %>%  lapply(FUN = function(csv) {
                                      cat("importing ",csv,"\n")
                                      read.csv(csv,
                                      sep = ";",
                                      colClasses = "character") %>%  as_tibble()
                                      }
                            )

cat("We append country databases into a single one... \n\n\n")
PIAAC_Cycle2<-PIAAC_Cycle2 %>% reduce(rbind) 

  



##we assign missing codes in numeric variables to tagged NAs
cat("We apply labels and encode NAs... \n\n\n")
doublelbl_vars <- dictionary %>%  filter(col_type=="dbl+lbl") %>%  pull(variable)
double_vars <- dictionary %>%  filter(col_type=="dbl") %>%  pull(variable)
 

#we have to disable warnings: turning character variables into double+tagged generates innocuous warnings
oldw <- getOption("warn")
options(warn = -1)

PIAAC_Cycle2 <- PIAAC_Cycle2 %>% mutate(across(all_of(doublelbl_vars),
                             ~case_when( str_detect(.x, "^\\..")==TRUE ~tagged_na(str_sub(.x,2,2)),
                                         .x=="." ~ NA,
                                         NA ~ NA,
                                         TRUE ~as.double(.x))
                             )
                      ) %>% mutate(across(all_of(double_vars),as.double))
                      
options(warn = oldw)

##we assign label to variables

PIAAC_Cycle2 <- PIAAC_Cycle2 %>% mutate(across(everything(),
                             ~labelled(.x,label=variable_labels[[cur_column()]])
                             )
                        )

##we assign value labels to variables

var_with_valuelabels <- dictionary %>% mutate(length_value_labels=value_labels %>% map(length)) %>% 
                                    filter(col_type=="dbl+lbl"  & length_value_labels>0 ) %>% 
                                    pull(variable)


PIAAC_Cycle2 <- PIAAC_Cycle2 %>% mutate(across(all_of(var_with_valuelabels),
                             ~labelled(.x,label=label_attribute(.x),
                                       labels=value_labels[[cur_column()]]
                                       )
                             )
                )


cat("PIAAC_Cycle2 is created as a tibble.\n
    All variables have variable labels (from the labelled package).
    Value labels were created for non-character variables (from the labelled package). 
    Missing codes for non-character variables were imported as tagged NAs (from the haven package)\n\n")
cat("You can save this file if you wish.")
