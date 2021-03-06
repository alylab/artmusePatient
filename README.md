# artmusePatient
code, data, &amp; stimuli for the following paper: https://www.biorxiv.org/content/10.1101/765222v2

Welcome to artmusePatient! Thanks for checking out the code.

The task files ‘artmusePatient.m’ and ‘artmusePatient_practice.m’ need to be in the same folder as the ‘stimuli’ and ‘practiceStimuli’ folders. Both scripts will require you to enter a subject number as well as subject initials. These files will output a ‘.mat’ and ‘.txt’ result files as well as print the behavioral results into the command window. When you have run through the task, you can place the two output files into the ‘data’ folder.

Within the ‘data’ folder, you can find ‘data_dictionary.rtf’ which details the variables at the header column for the ‘.txt’ file outputted by ‘artmusePatient.m’ and ‘artmusePatient_practice.m’.

Now you can run ‘artmusePatient_subjectAnalysis.m’ to analyze your individual data point. You will need to enter your subject number and initials for this script to analyze your data. 

Next, you can run the ‘lesion_vs_control.m’ script to group all the subject data, run t-tests, and plot the data.

We have also included ‘lesion_vs_control_mixed_ANOVA.m’, ‘lesion_vs_control_rmANOVA.m’, and ‘single_case_vs_controls_crawford_test.m’ for follow up analysis.

Be sure to read the instructions at the top of the scripts to ensure correct usage. If you run into any issue or have any questions, feel free to reach out to Nicholas Ruiz at nar2160@columbia.edu. Thank you!
