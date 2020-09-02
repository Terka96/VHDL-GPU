----------------------------------------------------------------------------------
-- MODEL MEMORY
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.definitions.all;
use work.model_presets.all;


entity MM is
  port(
			clk : in std_logic; --system clock
			address_in : in MM_ADDRESS;
			rd_out : out std_logic := '0';
			data_out : out MOD_TRIANGLE
		);
end MM;

architecture Behavioral of MM is

begin
  process (clk) is
  variable address_out : MM_ADDRESS := 0;
  variable memory : MODEL_MEM := model_const;

  begin
    if rising_edge(clk) then
	   if address_out /= address_in then
	     address_out := address_in;
		  rd_out <= '0';
		else
		  rd_out <= '1';
		end if;
		data_out <= memory(address_out);
	 end if;
  end process;

end Behavioral;

