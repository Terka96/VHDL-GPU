#!/bin/sh
rm work1/*
cd work1
#add xilinx ipcore sources
ghdl -i --work=xilinxcorelib /opt/Xilinx/14.7/ISE_DS/ISE/vhdl/src/XilinxCoreLib/*.vhd
#add xilinx ipcore configuration files
ghdl -i ../../ipcore_dir/*.vhd
#add our sources
ghdl -i ../../*.vhd
#select texture and model packages
ghdl -i ../../textures/tb1/texture.vhd
ghdl -i ../../models/tb1/model_presets.vhd
#build
#note: http://ghdl.free.fr/ghdl/IEEE-library-pitfalls.html
ghdl -m -g -Pxilinxcorelib --warn-unused --ieee=synopsys -fexplicit master_tb
#create run directory and symlinks
DATE=`date '+%Y-%m-%d_%H%M'`
DIRNAME=../runs/run_${DATE}_tb1${1}
mkdir $DIRNAME
mkdir $DIRNAME/frames
ln -s $DIRNAME run_logs
ln -s $DIRNAME/frames frames
#RUN
ghdl -r master_tb --stop-time=250ms
#nice parameters: --wave=vga.ghw --disp-tree=inst --stop-time=20000ns
#make report
../plot_graphs.py run_logs/ 
#clean symlinks
rm run_logs frames

