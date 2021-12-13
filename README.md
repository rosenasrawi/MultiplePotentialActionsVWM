## MultiplePotentialActionsVWM

This repository contains the analysis code for the project MultiplePotentialActionsVWM - work in progress. There are two folders "behaviour" and "EEG", each containing subfolders. See below for a decription of how to navigate these folders and files for analysis.

### Behavior

#### prepare
_rn2_load_logfiles.m_ – **To create one csv file from all logfiles.** <br/>
_rn2_open_behavior_data.R_ – **Make some changes to this csv file (cleaned, extra columns etc.)** <br/>
_rn2_combined_logfile.m_ – **Open this csv and export to a .mat file** <br/>

#### after
_rn2_epoch_conditions.R_ – **Calculate all the necessary summaries for stats & plotting** <br/>
_rn2_plot_behavior_data.R_ – **Plot the main behaviour data** <br/>
_rn2_behavior_stats.R_ – **Statistics main effect load on RT & precision** <br/>

### EEG

_rn2_gen_param.m_ – **For all the general parameters** <br/>

#### _functions
_rn2_errorbarplot.m_ – **Function to add errorbars to time-course plots** <br/>
_rn2_ftclusterstat1D.m_ – **Function to run clusterstat on the 1D time-course data** <br/>
_rn2_ftclusterstat2D.m_ – **Function to run clusterstat on the 2D time-frequency data** <br/>

#### pre-processing
_rn2_encoding_ICA_components.m_ – **Find eye-movement related ICA components** <br/>
_rn2_get_usable_trials.m_ – **Find bad trials** <br/>

#### tfr load1v2v4
_rn2_encoding_load1v2v4_get_time_frequency.m_ – **Get and save pp TFR contrasts load1v2v4** <br/>
_rn2_encoding_load1v2v4_GA_time_frequency.m_ – **Grand average** <br/>
_rn2_encoding_load1v2v4_stats_time_frequency.m_ – **Get and save stats for these contrasts** <br/>
_rn2_encoding_load1v2v4_plot_GA_time_frequency.m_ – **Plot them** <br/>

#### tfr similarity
_rn2_encoding_similarity_get_time_frequency.m_ – **Get and save pp TFR contrasts similarity** <br/>
_rn2_encoding_similarity_GA_time_frequency.m_ – **Grand average** <br/>
_rn2_encoding_similarity_stats_time_frequency.m_ – **Get and save stats for these contrasts** <br/>
_rn2_encoding_similarity_plot_GA_time_frequency.m_ – **Plot them** <br/>

#### tfr performance
_rn2_encoding_performance_get_time_frequency.m_ – **Get and save pp TFR contrasts performance** <br/>
_rn2_encoding_performance_GA_time_frequency.m_ – **Grand average** <br/>
_rn2_encoding_performance_stats_time_frequency.m_ – **Get and save stats for these contrasts** <br/>
_rn2_encoding_performance_plot_GA_time_frequency.m_ – **Plot them** <br/>
