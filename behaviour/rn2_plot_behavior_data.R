#### Load packages from library ####

library(ggplot2)
library(wesanderson)
library(gridExtra)

#### Directory ####

SaveFigures = "/Users/rosenasrawi/Documents/VU PhD/Projects/rn2 - Load 1vs2vs4/Plots behavior/"

#### Reusable theme ####

text.theme = theme(plot.title = element_text(size = 15, 
                                             hjust = 0.5, 
                                             lineheight = 1.2,
                                             family = "Helvetica Neue", 
                                             face = "bold"),
                   axis.title.x = element_text(size = 14,
                                               family = "Helvetica Neue",
                                               face = "bold"),
                   axis.title.y = element_text(size = 14,
                                               family = "Helvetica Neue",
                                               face = "bold"),
                   axis.text.x = element_text(size = 13,
                                              family = "Helvetica Neue"),
                   axis.text.y = element_text(size = 13,
                                              family = "Helvetica Neue"),
                   panel.border = element_blank(),
                   panel.grid.major=element_blank(),
                   panel.grid.minor=element_blank(),
                   axis.line = element_line(colour = "black"))


legend.theme = theme(legend.position = "right",
                     legend.title = element_text(size = 11,
                                                 family = "Helvetica Neue",
                                                 face = "bold"))

legend.none = theme(legend.position = "none")

color_1 = wes_palette("Darjeeling1")[1] # Red
color_2 = wes_palette("Darjeeling1")[2] # Blue 
color_3 = wes_palette("Darjeeling1")[3] # Yellow

color_1 = 'firebrick3'
color_2 = 'darkslategray4'
color_3 = 'goldenrod2'

color_1 = "#8C45AC" # purple
color_2 = "#50AC7B" # green
color_3 = "#C98151" # orange

color_1 = "#9BC3E0" # blue light
color_2 = "#80A2BA" # blue medium
color_3 = "#546B7A" # blue dark

#color_1 = "#D0A1E6" # lilac 
#color_2 = "#B1E6C9" # light green
#color_3 = "#DBA884" # light orange

color_4 = wes_palette("Moonrise3")[2] # Pink
color_5 = wes_palette("Cavalcanti1")[4] # Blue-ish

#### Load ####

#### RT ####

ggplot(summary.rt.load, 
       aes(x = BlockType, y = RT1, col = BlockType, fill = BlockType, group = BlockType)) +
  
  scale_fill_manual(values = c(color_1,
                               color_2,
                               color_3),
                    name = "Memory load",
                    labels = c("Load 1", "Load 2", "Load 4")) + 
  
  geom_bar(stat = "identity", position = position_dodge(width = 0.1), alpha = 1, color = "black", width = 0.8, size = 0.5) +
  geom_line(data = summary.rt.subj.load, aes(group = SubjectID), color= "black", size = 0.4, alpha = 1) +
  
  geom_errorbar(aes(ymin = RT1-se, ymax = RT1+se), width = 0.1, 
                position = position_dodge(0.9), size = 0.5, color = "black") +  
  

  
  scale_x_discrete(name = "Memory load", labels = c("Load 1", "Load 2", "Load 4")) +
  scale_y_continuous("Decision time (ms)") +
  coord_cartesian(ylim = c(100,1600)) +
  
  theme_bw() +
  text.theme +
  legend.none

ggsave("Loads_RT.eps", path = SaveFigures, width=5, height=4)

#### Error ####

ggplot(summary.err.load, 
       aes(x = BlockType, y = AbsReportVsTarget, col = BlockType, fill = BlockType, group = BlockType)) +
  
  scale_fill_manual(values = c(color_1,
                               color_2,
                               color_3),
                    name = "Memory load",
                    labels = c("Load 1", "Load 2", "Load 4")) + 
  
  geom_bar(stat = "identity", position = position_dodge(width = 0.1), alpha = 1, color = "black", width = 0.8, size = 0.5) +
  geom_line(data = summary.err.subj.load, aes(group = SubjectID), color= "black", size = 0.4, alpha = 1) +
  
  geom_errorbar(aes(ymin = AbsReportVsTarget-se, ymax = AbsReportVsTarget+se), width = 0.1, 
                position = position_dodge(0.9), size = 0.5, color = "black") +
  
  scale_x_discrete(name = "Memory load", labels = c("Load 1", "Load 2", "Load 4")) +
  scale_y_continuous("Absolute error (degrees)") +
  coord_cartesian(ylim = c(2,35)) +
  
  theme_bw() +
  text.theme +
  legend.none

ggsave("Loads_ERR.eps", path = SaveFigures, width=5, height=4)


#### Precision general ####

report_vs_target = data.frame(SubjectID = as.factor(data$SubjectID), BlockType = as.factor(data$BlockType), ReportVsTarget = data$ReportVsTarget)

ggplot(report_vs_target, aes(x=ReportVsTarget, col = BlockType, group = BlockType)) +
  
  geom_density(aes(fill = BlockType), size = 0.5, alpha = 1, show.legend = FALSE) + 
  stat_density(geom = "line", position = "identity", size = 0, show.legend = FALSE) + 
  
  scale_color_manual(values = c("black",
                                "black",
                                "black"),
                     name = "Load",
                     labels = c("1", "2", "3")) +  
  
  scale_fill_manual(values = c(color_1,
                               color_2,
                               color_3),
                     name = "Load",
                     labels = c("1", "2", "3")) +  
  
  scale_x_continuous("Response deviation from target") +
  scale_y_continuous("Density") +
  
  coord_cartesian(ylim = c(0.0018,0.04), xlim = c(-83,83)) +
  
  theme_bw() +
  text.theme +
  legend.theme +
  guides(colour = guide_legend(override.aes=list(size=1)))

ggsave("General_Precision.eps", path = SaveFigures, width=5, height=4)

#### RT distribution general ####

RT_distributions = data.frame(SubjectID = as.factor(data$SubjectID), BlockType = as.factor(data$BlockType), RT = data$cleanRT1)

ggplot(RT_distributions, aes(x=RT, col = BlockType, group = BlockType)) +
  
  geom_density(aes(fill = BlockType), size = 0.5, alpha = 1, show.legend = FALSE) + 
  stat_density(geom = "line", position = "identity", size = 0, show.legend = FALSE) + 
  
  scale_color_manual(values = c("black",
                                "black",
                                "black"),
                     name = "Load",
                     labels = c("1", "2", "3")) +  
  
  scale_fill_manual(values = c(color_1,
                               color_2,
                               color_3),
                    name = "Load",
                    labels = c("1", "2", "3")) +  
  
  scale_x_continuous("Decision time (ms)") +
  scale_y_continuous("Density") +
  coord_cartesian(xlim = c(258,1500), ylim = c(0.00017,0.003))+

  theme_bw() +
  text.theme +
  legend.theme +
  guides(colour = guide_legend(override.aes=list(size=1)))

ggsave("RT_Distributions.eps", path = SaveFigures, width=5, height=4)


#### Item similarity ####


#### RT ####

ggplot(summary.rt.itemsim, 
       aes(x = ItemSimilarity, y = RT1, col = ItemSimilarity, fill = ItemSimilarity, group = ItemSimilarity)) +
  
  geom_bar(stat = "identity", position = position_dodge(width = 0.1), color = "black", width = 0.8, size = 0.5) +
  geom_errorbar(aes(ymin = RT1-se, ymax = RT1+se), width = 0.1, 
                position = position_dodge(0.9), size = 0.5, color = "black") +
  geom_line(data = summary.rt.subj.itemsim, aes(group = SubjectID), color= "grey", alpha = 0.5) +
  
  scale_fill_manual(values = c(color_1,
                               color_2,
                               color_2,
                               color_3),
                    name = "Memory load",
                    labels = c("Load 1", "Load 2 (sim)", "Load 2 (dif)", "Load 4")) +
  
  scale_x_discrete(name = "Memory load", labels = c("Load 1", "Load 2 (sim)", "Load 2 (dif)", "Load 4")) +
  scale_y_continuous("Decision time (ms)") +
  coord_cartesian(ylim = c(300,1200)) +
  
  theme_bw() +
  text.theme +
  legend.none

ggsave("ItemSimilarity_RT.png", path = SaveFigures, width=7, height=4)

#### Error ####

ggplot(summary.err.itemsim, 
       aes(x = ItemSimilarity, y = AbsReportVsTarget, col = ItemSimilarity, fill = ItemSimilarity, group = ItemSimilarity)) +
  
  geom_bar(stat = "identity", position = position_dodge(width = 0.1), color = "black", width = 0.8, size = 0.5) +
  geom_errorbar(aes(ymin = AbsReportVsTarget-se, ymax = AbsReportVsTarget+se), width = 0.1, 
                position = position_dodge(0.9), size = 0.5, color = "black") +
  geom_line(data = summary.err.subj.itemsim, aes(group = SubjectID), color= "grey", alpha = 0.5) +
  
  scale_fill_manual(values = c(color_1,
                               color_2,
                               color_2,
                               color_3),
                    name = "Memory load",
                    labels = c("Load 1", "Load 2 (sim)", "Load 2 (dif)", "Load 4")) +
  
  scale_x_discrete(name = "Memory load", labels = c("Load 1", "Load 2 (sim)", "Load 2 (dif)", "Load 4")) +
  scale_y_continuous("Absolute error (degrees)") +
  coord_cartesian(ylim = c(5,25)) +
  
  theme_bw() +
  text.theme +
  legend.none

ggsave("ItemSimilarity_ERR.png", path = SaveFigures, width=7, height=4)
