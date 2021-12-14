#### Description ####

# This script loads the combined .csv logfiles (containing data for every subject) and its header
# It changes the names of the header, and adds variables "ItemSimilarity", "cleanRT1", and "FastVsSlow"
# Saves this as .csv

#### Clean workspace ####

rm(list=ls())

#### Load packages ####

library(Rmisc)
library(dplyr)
library(data.table)

#### Load data file ####

path = '/Users/rosenasrawi/Documents/VU PhD/Projects/rn2 - Load 1vs2vs4/Data/logfiles/'
setwd(path)

combined_filename = 'logfiles_combined_rn2.csv'
header_filename = 'logfile_header_rn2.csv'

data = read.csv(combined_filename)
header = read.csv(header_filename) # Just to check

#### Change the header ####

old_names = colnames(data)

new_names = c('SubjectID',       'SuperBlock',          'Block',                'BlockType', 
              'Trial',           'ITI',                 'LocColor1',            'LocColor2',
              'LocColor3',       'LocColor4',           'ColorLoc1',            'ColorLoc2',
              'ColorLoc3',       'ColorLoc4',           'OriLoc1',              'OriLoc2',
              'OriLoc3',         'OriLoc4',             'TargetColor',          'TargetLoc',
              'TargetOri',       'OtherPTargetColor',   'OtherPTargetLoc',      'OtherPTargetOri',
              'SameDif',         'ProbeOri',            'ReportOri',            'ReportVsTarget',
              'ReportVsProbe',   'TargetVsProbe',       'ReportVsOtherPTarget',
              'RT1',             'RT2',                 'RT3')

names(data) = new_names

#### Add similarity column ####

index.load1 = data$BlockType == 1
index.load2 = data$BlockType == 2
index.load4 = data$BlockType == 3

target.vs.ptarget = data$TargetOri - data$OtherPTargetOri

target.vs.ptarget[target.vs.ptarget >= 90] = target.vs.ptarget[target.vs.ptarget >= 90] - 180
target.vs.ptarget[target.vs.ptarget <= -90] = target.vs.ptarget[target.vs.ptarget <= -90] + 180

target.vs.ptarget = abs(target.vs.ptarget)

target.vs.ptarget[!index.load2] = 0
data$TargetVsPTarget = target.vs.ptarget
data$ItemSimilarity = target.vs.ptarget

med.item.sim = median(target.vs.ptarget[index.load2])

data$ItemSimilarity[data$TargetVsPTarget > med.item.sim & index.load2] = 'load2 more'
data$ItemSimilarity[data$TargetVsPTarget < med.item.sim & index.load2] = 'load2 less'
data$ItemSimilarity[data$TargetVsPTarget == med.item.sim & index.load2] = NaN
data$ItemSimilarity[index.load1] = 'load1'
data$ItemSimilarity[index.load4] = 'load4'

#### Clean data ####

histogram(data$RT1)

# Trials with DT slower / faster than 2.5 SD from mean

slow_trials_all = c()

for (sub in unique(data$SubjectID)){
  
  mean_sub = mean(data$RT1[which(data$SubjectID == sub)])
  sd_sub = sd(data$RT1[which(data$SubjectID == sub)]) * 2.5
  
  cutoff_slow = mean_sub + sd_sub
  
  slow_trials_sub = which(data$SubjectID == sub & data$RT1 > cutoff_slow)
  
  if (length(slow_trials_sub) >= 1){
    slow_trials_all = c(slow_trials_all, slow_trials_sub)
  }
  
}

slow_trials_all = as.numeric(slow_trials_all)

data$cleanRT1 = data$RT1
data$cleanRT1[slow_trials_all] = NaN
data$cleanRT1[which(data$RT1 >= 5000)] = NaN
data$cleanRT1[which(data$RT1 <= 200)] = NaN

data$removeRT1 = "good"
data$removeRT1[slow_trials_all] = "slow"
data$removeRT1[which(data$RT1 >= 5000)] = "slow"
data$removeRT1[which(data$RT1 <= 200)] = "fast"

histogram(data$cleanRT1)

#### Median split per subject (RT1) ####

med.RT1.subj = tapply(data$cleanRT1, list(data$SubjectID, data$BlockType), FUN = median, na.rm=TRUE)

data$SlowVsFast = data$cleanRT1

for (sub in unique(data$SubjectID)){
  for (load in 1:length(unique(data$BlockType))){
    sub.med = med.RT1.subj[sub,load]
    this.load = sort(unique(data$BlockType))[load]
    
    data$SlowVsFast[data$SubjectID == sub & data$BlockType == this.load & data$RT1 > sub.med] = 'slow'
    data$SlowVsFast[data$SubjectID == sub & data$BlockType == this.load & data$RT1 < sub.med] = 'fast'
    data$SlowVsFast[data$SubjectID == sub & data$BlockType == this.load & data$RT1 == sub.med] = NaN
  }
}

data$SlowVsFast[is.nan(data$cleanRT1)] = NaN

#### Median split per subject (errors) ####

data$AbsReportVsTarget = abs(data$ReportVsTarget)

med.err.subj = tapply(data$AbsReportVsTarget, list(data$SubjectID, data$BlockType), FUN = median, na.rm=TRUE)

data$PreciseVsUnprecise = data$AbsReportVsTarget

for (sub in unique(data$SubjectID)){
  for (load in 1:length(unique(data$BlockType))){
    sub.med = med.err.subj[sub,load]
    this.load = sort(unique(data$BlockType))[load]
    
    data$PreciseVsUnprecise[data$SubjectID == sub & data$BlockType == this.load & data$AbsReportVsTarget > sub.med] = 'unprecise'
    data$PreciseVsUnprecise[data$SubjectID == sub & data$BlockType == this.load & data$AbsReportVsTarget < sub.med] = 'precise'
    data$PreciseVsUnprecise[data$SubjectID == sub & data$BlockType == this.load & data$AbsReportVsTarget == sub.med] = NaN
  }
}

#### Save ####

write.table(data, 'logfiles_combined_header_rn2.csv', sep = ",")
