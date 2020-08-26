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
			cu_rd : in std_logic;
			cu_ce : out std_logic
			);
end D;

architecture Behavioral of D is

component model_mem is
  port(
			clk : in std_logic; --system clock
			address_in : in MM_ADDRESS;
			rd_out : out std_logic;
			data_out : out MOD_TRIANGLE
		);
end component;
signal address : MM_ADDRESS := 0;
signal mm_rd : std_logic;
signal triangle : MOD_TRIANGLE;

begin

MM_entity : model_mem port map(
		clk => clk,
		address_in => address,
		rd_out => mm_rd,
		data_out => triangle
	);

process(clk,mm_rd) is
variable triangle_address : MM_ADDRESS := 1;
variable data_preloaded : std_logic := '0';
variable reg_triangle : MOD_TRIANGLE := empty_m_tri;
begin
  if rising_edge(clk) then
    --TODO schedule work over CUs
    if cu_rd = '1' and data_preloaded = '1' then
	   data_out <= reg_triangle;
		cu_ce <= '1';
		data_preloaded := '0';
		triangle_address := triangle_address + 1;
	 else
	   cu_ce <= '0';
	 end if;
	 if mm_rd = '1' and data_preloaded = '0' then
		reg_triangle := triangle;
		data_preloaded := '1';
	 end if;
  end if;
address <= triangle_address;
end process;

end Behavioral;

