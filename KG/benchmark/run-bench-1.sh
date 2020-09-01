#!/bin/sh
cd work
#add xilinx ipcore sources
ghdl -i --work=xilinxcorelib /opt/Xilinx/14.7/ISE_DS/ISE/vhdl/src/XilinxCoreLib/*.vhd
#add xilinx ipcore configuration files
ghdl -i ../../ipcore_dir/*.vhd
#add our sources
ghdl -i ../../*.vhd
#select texture and model packages
ghdl -i --work=work ../../textures/tb1/texture.vhd
ghdl -i --work=work ../../models/tb1/model_presets.vhd
#build
ghdl -m -g -Pxilinxcorelib --warn-unused --ieee=synopsys master_tb
#create run directory and symlinks
DATE=`date '+%Y-%m-%d_%H%M'`
DIRNAME=../runs/run_${DATE}_tb1${1}
mkdir $DIRNAME
mkdir $DIRNAME/frames
ln -s $DIRNAME run_logs
ln -s $DIRNAME/frames frames
#RUN
ghdl -r master_tb --stop-time=100ms
#nice parameters: --wave=vga.ghw --disp-tree=inst --stop-time=20000ns
#clean symlinks
rm run_logs frames
