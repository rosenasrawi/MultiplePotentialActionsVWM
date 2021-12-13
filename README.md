# MultiplePotentialActionsVWM

This repository contains the analysis code for the project MultiplePotentialActionsVWM - work in progress. There are two folders "behaviour" and "EEG", each containing subfolders.
See below for a decription of how to navigate these folders and files for analysis.

## Behavior

### prepare
rn2_load_logfiles.m				      # To create one csv file from all logfiles
rn2_open_behavior_data.R		    # Make some changes to this csv file (cleaned, extra columns etc.)
							                  # Changes the csv file logfiles_combined_header_rn2.csv
rn2_combined_logfile.m			    # Open this csv and export to a .mat file

### after
rn2_epoch_conditions.R			    # Calculate all the necessary summaries for stats & plotting
rn2_plot_behavior_data.R			  # Plot the main behaviour data
rn2_behavior_stats.R			      # Statistics main effect load on RT & precision

## EEG

rn2_gen_param.m 				        # For all the general parameters

### _functions
rn2_errorbarplot                # Function to add errorbars to time-course plots
rn2_ftclusterstat1D             # Function to run clusterstat on the 1D time-course data
rn2_ftclusterstat2D             # Function to run clusterstat on the 2D time-frequency data

### pre-processing
rn2_encoding_ICA_components.m					# Find eye-movement related ICA components
rn2_get_usable_trials.m							  # Find bad trials

### tfr load1v2v4
rn2_encoding_load1v2v4_get_time_frequency.m		      # get and save pp TFR contrasts load1v2v4
rn2_encoding_load1v2v4_GA_time_frequency.m		      # grand average
rn2_encoding_load1v2v4_stats_time_frequency.m		    # get and save stats for these contrasts
rn2_encoding_load1v2v4_plot_GA_time_frequency.m	    # plot them

### tfr similarity
rn2_encoding_similarity_get_time_frequency.m			  # get and save pp TFR contrasts similarity
rn2_encoding_similarity_GA_time_frequency.m			    # grand average
rn2_encoding_similarity_stats_time_frequency.m		  # get and save stats for these contrasts
rn2_encoding_similarity_plot_GA_time_frequency.m	  # plot them

### tfr performance
rn2_encoding_performance_get_time_frequency.m		    # get and save pp TFR contrasts performance
rn2_encoding_performance_GA_time_frequency.m		    # grand average
rn2_encoding_performance_stats_time_frequency.m		  # get and save stats for these contrasts
rn2_encoding_performance_plot_GA_time_frequency.m	  # plot them
