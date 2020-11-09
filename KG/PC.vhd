----------------------------------------------------------------------------------
--PIXEL COLLECTOR
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
use ieee.numeric_std.all;
use work.definitions.all;

entity PC is
	port(
			clk : in std_logic; --system clock
			fb_data_out : out std_logic;
			pixel_read : out std_logic_vector(1 to CU_COUNT);
			fb_pixel_out : out PIXEL;
			fb_rd : in std_logic;
			cu_data_in : in std_logic_vector(1 to CU_COUNT);
			cu_pixel_in : in CU_PIXELS
			);
end PC;

architecture Behavioral of PC is

begin

process (clk) is
variable i : integer := 1;
begin
if rising_edge(clk) then
	if fb_rd = '1' then
		if i > CU_COUNT then
			i := 1;
		end if;
		if cu_data_in(i) = '1' then
			fb_pixel_out.position.coord_X <= cu_pixel_in(i).position.coord_X - 1;
			fb_pixel_out.position.coord_Y <= cu_pixel_in(i).position.coord_Y - 1;
			fb_pixel_out.color <= cu_pixel_in(i).color;
			fb_pixel_out.depth <= cu_pixel_in(i).depth;
			fb_data_out <= '1';
			pixel_read(i) <= '1';
		end if;
		i := i + 1;
	else
		fb_data_out <= '0';
		pixel_read <= (others => '0');
	end if;
end if;
end process;
end Behavioral;

