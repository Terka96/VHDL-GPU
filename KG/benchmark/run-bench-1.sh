#!/bin/sh

###############################################################
# Copyright 2020 Piotr Terczyński
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated           
# documentation files (the "Software"), to deal in the       
# Software without restriction, including without limitation 
# the rights to use, copy, modify, merge, publish,           
# distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to
# do so, subject to the following conditions:
#
# The above copyright notice and this permission notice 
# shall be included in all copies or substantial portions of
# the Software.
#
# 		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF 
# ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
# THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
# PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS 
# OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR   
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
###############################################################

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

