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

#set project_name "1_led_blink"
#set project_name "2_knight_rider"
#set project_name "3_stopwatch"
set project_name "4_frequency_counter"

cd $project_name
source block_design.tcl
