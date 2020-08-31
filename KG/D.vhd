----------------------------------------------------------------------------------
-- DRIVER/SETUP
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.definitions.all;
--use IEEE.NUMERIC_STD.ALL;

entity D is
	port(
			clk : in std_logic; --system clock
			data_out : out MOD_TRIANGLE;
			cu_rd : in std_logic_vector(1 to CU_COUNT);
			cu_ce : out std_logic_vector(1 to CU_COUNT)
			);
end D;

architecture Behavioral of D is

component MM is
  port(
			clk : in std_logic; --system clock
			address_in : in MM_ADDRESS;
			rd_out : out std_logic;
			data_out : out MOD_TRIANGLE
		);
end component;
signal address : MM_ADDRESS := 0;
signal mm_rd : std_logic;

begin

MM_entity : MM port map(
		clk => clk,
		address_in => address,
		rd_out => mm_rd,
		data_out => data_out
	);

process(clk,mm_rd) is
variable triangle_address : MM_ADDRESS := 1;
variable data_preloaded : std_logic := '0';
variable i : integer := 1;
begin
if rising_edge(clk) then
	if data_preloaded = '1' then
		if i > CU_COUNT then
			i := 1;
		end if;
		if cu_rd(i) = '1' then
			cu_ce(i) <= '1';
			data_preloaded := '0';
			triangle_address := triangle_address + 1;
		else
			cu_ce <= (others => '0');
		end if;
	else	--data_preloaded = '0'
		if mm_rd = '1' and triangle_address <= AVAILABLE_TRIANGLES then			--to trzeba ten +1 czy nie? :o
			data_preloaded := '1';
			cu_ce <= (others => '0');
		end if;
	end if;
	i := i + 1;
end if;
address <= triangle_address;
end process;

end Behavioral;

