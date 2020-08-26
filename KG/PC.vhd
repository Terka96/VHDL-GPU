----------------------------------------------------------------------------------
--PIXEL COLLECTOR
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.definitions.all;

entity PC is
	port(
			clk : in std_logic; --system clock
			fb_data_out : out std_logic;
			pixel_read : out std_logic;
			fb_pixel_out : out PIXEL;
			fb_rd : in std_logic;
			cu_data_in : in std_logic;
			cu_pixel_in : in PIXEL
			);
end PC;

architecture Behavioral of PC is

begin

process (clk) is
begin
if rising_edge(clk) then
	if fb_rd = '1' and cu_data_in = '1' then
		fb_pixel_out <= cu_pixel_in;
		fb_data_out <= '1';
		pixel_read <= '1';
	else
		fb_data_out <= '0';
		pixel_read <= '0';
	end if;
end if;
end process;
end Behavioral;

