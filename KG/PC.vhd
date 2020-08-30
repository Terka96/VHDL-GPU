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
			fb_pixel_out <= cu_pixel_in(i);
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

