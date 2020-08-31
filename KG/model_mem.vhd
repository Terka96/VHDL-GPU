----------------------------------------------------------------------------------
-- MODEL MEMORY
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.numeric_std.all;
use work.definitions.all;


entity MM is
  port(
			clk : in std_logic; --system clock
			address_in : in MM_ADDRESS;
			rd_out : out std_logic := '0';
			data_out : out MOD_TRIANGLE
		);
end MM;

architecture Behavioral of model_mem is

begin
  process (clk) is
  variable address_out : MM_ADDRESS := 0;
  variable memory : MODEL_MEM := ( 
  empty_m_tri,
  
--cube <-1,1>
((x"bc00",x"3c00",x"bc00",x"0000",x"0000",x"bc00",x"0000",x"0000"), (x"3c00",x"3c00",x"bc00",x"0000",x"0000",x"bc00",x"0000",x"3c00"), (x"bc00",x"bc00",x"bc00",x"0000",x"0000",x"bc00",x"3c00",x"0000")),	--tyl
((x"bc00",x"bc00",x"bc00",x"0000",x"0000",x"bc00",x"3c00",x"0000"), (x"3c00",x"3c00",x"bc00",x"0000",x"0000",x"bc00",x"0000",x"3c00"), (x"3c00",x"bc00",x"bc00",x"0000",x"0000",x"bc00",x"3c00",x"3c00")),	--tyl
((x"bc00",x"3c00",x"3c00",x"0000",x"0000",x"3c00",x"0000",x"0000"), (x"3c00",x"3c00",x"3c00",x"0000",x"0000",x"3c00",x"0000",x"3c00"), (x"bc00",x"bc00",x"3c00",x"0000",x"0000",x"3c00",x"3c00",x"0000")),	--przod
((x"bc00",x"bc00",x"3c00",x"0000",x"0000",x"3c00",x"3c00",x"0000"), (x"3c00",x"3c00",x"3c00",x"0000",x"0000",x"3c00",x"0000",x"3c00"), (x"3c00",x"bc00",x"3c00",x"0000",x"0000",x"3c00",x"3c00",x"3c00")),	--przod
((x"bc00",x"3c00",x"bc00",x"bc00",x"0000",x"0000",x"0000",x"0000"), (x"bc00",x"bc00",x"bc00",x"bc00",x"0000",x"0000",x"0000",x"3c00"), (x"bc00",x"3c00",x"3c00",x"bc00",x"0000",x"0000",x"3c00",x"0000")),	--lewa
((x"bc00",x"3c00",x"3c00",x"bc00",x"0000",x"0000",x"3c00",x"0000"), (x"bc00",x"bc00",x"bc00",x"bc00",x"0000",x"0000",x"0000",x"3c00"), (x"bc00",x"bc00",x"3c00",x"bc00",x"0000",x"0000",x"3c00",x"3c00")),	--lewa
((x"3c00",x"3c00",x"bc00",x"3c00",x"0000",x"0000",x"0000",x"0000"), (x"3c00",x"bc00",x"bc00",x"3c00",x"0000",x"0000",x"0000",x"3c00"), (x"3c00",x"3c00",x"3c00",x"3c00",x"0000",x"0000",x"3c00",x"0000")),	--prawa
((x"3c00",x"3c00",x"3c00",x"3c00",x"0000",x"0000",x"3c00",x"0000"), (x"3c00",x"bc00",x"bc00",x"3c00",x"0000",x"0000",x"0000",x"3c00"), (x"3c00",x"bc00",x"3c00",x"3c00",x"0000",x"0000",x"3c00",x"3c00")),	--prawa
((x"bc00",x"bc00",x"bc00",x"0000",x"bc00",x"0000",x"0000",x"0000"), (x"3c00",x"bc00",x"bc00",x"0000",x"bc00",x"0000",x"0000",x"3c00"), (x"bc00",x"bc00",x"3c00",x"0000",x"bc00",x"0000",x"3c00",x"0000")),	--dol
((x"bc00",x"bc00",x"3c00",x"0000",x"bc00",x"0000",x"3c00",x"0000"), (x"3c00",x"bc00",x"bc00",x"0000",x"bc00",x"0000",x"0000",x"3c00"), (x"3c00",x"bc00",x"3c00",x"0000",x"bc00",x"0000",x"3c00",x"3c00")),	--dol
((x"bc00",x"3c00",x"bc00",x"0000",x"3c00",x"0000",x"0000",x"0000"), (x"3c00",x"3c00",x"bc00",x"0000",x"3c00",x"0000",x"0000",x"3c00"), (x"bc00",x"3c00",x"3c00",x"0000",x"3c00",x"0000",x"3c00",x"0000")),	--góra
((x"bc00",x"3c00",x"3c00",x"0000",x"3c00",x"0000",x"3c00",x"0000"), (x"3c00",x"3c00",x"bc00",x"0000",x"3c00",x"0000",x"0000",x"3c00"), (x"3c00",x"3c00",x"3c00",x"0000",x"3c00",x"0000",x"3c00",x"3c00")),	--góra



others => empty_m_tri);

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

