# ==================================================================================================
# make_project.tcl
#
# Simple script for creating a Vivado project from the project/ folder 
# Based on Pavel Demin's red-pitaya-notes-master/ git project
#
# Make sure the script is executed from redpitaya_guide/ folder
#
# by Anton Potocnik, 02.10.2016 - 14.12.2017
# ==================================================================================================

#set project_name "Led_blink"
#set project_name "Knight_rider"
#set project_name "Stopwatch"
#set project_name "Frequency_counter"
set project_name "Simple_moving_average"

cd $project_name
source make_project.tcl
