----------------------------------------------------------------------------------
-- VGA TEST BENCH
----------------------------------------------------------------------------------
-- Copyright 2020 Piotr Terczyński
--
-- Permission is hereby granted, free of charge, to any person
-- obtaining a copy of this software and associated           
-- documentation files (the "Software"), to deal in the       
-- Software without restriction, including without limitation 
-- the rights to use, copy, modify, merge, publish,           
-- distribute, sublicense, and/or sell copies of the Software,
-- and to permit persons to whom the Software is furnished to
-- do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice 
-- shall be included in all copies or substantial portions of
-- the Software.
--
-- 		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF 
-- ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
-- THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS 
-- OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR   
-- OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
-- SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use ieee.numeric_std.all;
use work.definitions.all;
use std.textio.all;

entity vga_tb is
	port (		
		clk : in std_logic;
		vga_vsync : in std_logic;
		vga_hsync : in std_logic;
		vga_clk : in std_logic;
		vga_r : in std_logic_vector( 7 downto 0 );
		vga_g : in std_logic_vector( 7 downto 0 );
		vga_b : in std_logic_vector( 7 downto 0 )
		);
end vga_tb;

architecture Behavioral of vga_tb is

begin

process (clk) is
    file file_pointer: text open write_mode is "frames/0";
	 variable l : line;
	 variable frame : integer := 0;
	 variable magic_number : string(1 to 2) := "P3";
	 variable resolution : string(1 to 11) := "320 240 255";--"640 480 255";
	 variable space : string(1 to 1) := " ";
begin
    if rising_edge(clk) then
		if vga_vsync = '1' then
			file_close(file_pointer);
			frame := frame +1;
			file_open(file_pointer,"frames/vga_f_"& integer'image(frame)&".ppm",write_mode);
			write(l,magic_number);
			writeline(file_pointer,l);
			write(l,resolution);
			writeline(file_pointer,l);

		end if;

       
		  write(l, to_str(vga_r));
		  write(l, space);
		  write(l, to_str(vga_g));
		  write(l, space);
		  write(l, to_str(vga_b));
		  writeline(file_pointer,l);

    end if;
end process;


end Behavioral;

