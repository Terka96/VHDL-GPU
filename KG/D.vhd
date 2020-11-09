----------------------------------------------------------------------------------
-- DRIVER/SETUP
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
use IEEE.STD_LOGIC_1164.all;
use work.definitions.all;
use work.model_presets.all;

entity D is
	port(
			clk : in std_logic; --system clock
			data_out : out MOD_TRIANGLE;
			cu_rd : in std_logic_vector(1 to CU_COUNT);
			cu_ce : out std_logic_vector(1 to CU_COUNT) := (others => '0')
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
variable triangle_address : MM_ADDRESS := 0;
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
		else
			cu_ce <= (others => '0');
		end if;
	else	--data_preloaded = '0'
		if mm_rd = '1' and triangle_address < AVAILABLE_TRIANGLES then
			triangle_address := triangle_address + 1;
			data_preloaded := '1';
		end if;     
		cu_ce <= (others => '0');
	end if;
	i := i + 1;
end if;
address <= triangle_address;
end process;

end Behavioral;

