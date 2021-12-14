#### Description ####

# This script loads the behavioral data .csv file
# Calculates the aggregate (for each subject) and summary (across subjects)
# For each dependent variable (RT, abs error) and condition (memory load, item similarity)

#### Clean workspace ####

rm(list=ls())

#### Load packages from library ####

library(Rmisc)
library(dplyr)
library(data.table)

#### Load data file ####

path = '/Users/rosenasrawi/Documents/VU PhD/Projects/rn2 - Load 1vs2vs4/Data/logfiles/'
setwd(path)

combined_filename = 'logfiles_combined_header_rn2.csv'

data = read.csv(combined_filename)

#### Memory load ####

# Decision time (RT1)

summary.rt.subj.load = aggregate(data = data, RT1 ~ SubjectID + BlockType, mean)

summary.rt.subj.load$BlockType = as.factor(summary.rt.subj.load$BlockType)

summary.rt.load = summarySEwithin(data = summary.rt.subj.load,
                                  measurevar = "RT1",
                                  withinvars = "BlockType",
                                  idvar = "SubjectID")

# Error (degrees)

data$AbsReportVsTarget = abs(data$ReportVsTarget)

summary.err.subj.load = aggregate(data = data, AbsReportVsTarget ~ SubjectID + BlockType, mean)

summary.err.subj.load$BlockType = as.factor(summary.err.subj.load$BlockType)

summary.err.load = summarySEwithin(data = summary.err.subj.load,
                                   measurevar = "AbsReportVsTarget",
                                   withinvars = "BlockType",
                                   idvar = "SubjectID")

#### Item similarity ####

# Decision time (RT1)

summary.rt.subj.itemsim = aggregate(data = data, RT1 ~ SubjectID + ItemSimilarity, mean)
summary.rt.subj.itemsim = summary.rt.subj.itemsim[summary.rt.subj.itemsim$ItemSimilarity != "NaN",]

summary.rt.itemsim = summarySEwithin(data = summary.rt.subj.itemsim,
                                     measurevar = "RT1",
                                     withinvars = "ItemSimilarity",
                                     idvar = "SubjectID")

# Error (degrees)

summary.err.subj.itemsim = aggregate(data = data, AbsReportVsTarget ~ SubjectID + ItemSimilarity, mean)


summary.err.subj.itemsim = summary.err.subj.itemsim[summary.err.subj.itemsim$ItemSimilarity != "NaN",]

summary.err.itemsim = summarySEwithin(data = summary.err.subj.itemsim,
                                      measurevar = "AbsReportVsTarget",
                                      withinvars = "ItemSimilarity",
                                      idvar = "SubjectID")
