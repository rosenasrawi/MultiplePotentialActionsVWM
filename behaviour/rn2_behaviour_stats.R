#### Description ####

# NOTE: Make sure you have summary.rt.subj.load & [...]err.subj.load in your environment (obtained from running "rn2_summary_conditions.R")
# Statistical testing of the effect of memory load on RT and error using two one-way repeated measures ANOVAs
# Post-hoc comparisons for each memory load comparison using Tukey HSD

#### Run ANOVA and Tukey HSD ####

anov_RT <- aov(RT1 ~ BlockType, data = summary.rt.subj.load)
summary(anov_RT)
TukeyHSD(anov_RT)

anov_Err <- aov(AbsReportVsTarget ~ BlockType, data = summary.err.subj.load)
summary(anov_Err)
TukeyHSD(anov_Err)
