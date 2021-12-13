
library(lme4) # This is the package that we need for using LMMs
library(lmerTest)

summary.err.subj.load

lmm_RT <- lmer(RT1 ~ BlockType + (1|SubjectID), data=summary.rt.subj.load)
anova(lmm_RT)

lmm_Err <- lmer(AbsReportVsTarget ~ BlockType + (1|SubjectID), data=summary.err.subj.load)
anova(lmm_Err)


anov_RT <- aov(RT1 ~ BlockType, data = summary.rt.subj.load)
summary(anov_RT)
TukeyHSD(anov_RT)

anov_Err <- aov(AbsReportVsTarget ~ BlockType, data = summary.err.subj.load)
summary(anov_Err)
TukeyHSD(anov_Err)
