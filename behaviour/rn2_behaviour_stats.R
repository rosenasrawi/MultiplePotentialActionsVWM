# Make sure you have summary.rt.subj.load & [...]err.subj.load in your environment (obtained from running "rn2_epoch_conditions.R")

anov_RT <- aov(RT1 ~ BlockType, data = summary.rt.subj.load)
summary(anov_RT)
TukeyHSD(anov_RT)

anov_Err <- aov(AbsReportVsTarget ~ BlockType, data = summary.err.subj.load)
summary(anov_Err)
TukeyHSD(anov_Err)
