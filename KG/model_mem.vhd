----------------------------------------------------------------------------------
-- MODEL MEMORY
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.numeric_std.all;
use work.definitions.all;


entity model_mem is
  port(
			clk : in std_logic; --system clock
			address_in : in MM_ADDRESS;
			rd_out : out std_logic := '0';
			data_out : out MOD_TRIANGLE
		);
end model_mem;

architecture Behavioral of model_mem is
type mem is array (0 to 255) of MOD_TRIANGLE;

begin
  process (clk) is
  variable address_out : MM_ADDRESS := 0;
  variable memory : mem := ( 
((x"bc00",x"3c00",x"bc00",x"0000",x"0000",x"bc00",x"0000",x"0000"), (x"3c00",x"3c00",x"bc00",x"0000",x"0000",x"bc00",x"0000",x"3c00"), (x"bc00",x"bc00",x"bc00",x"0000",x"0000",x"bc00",x"3c00",x"0000")),
((x"bc00",x"bc00",x"bc00",x"0000",x"0000",x"bc00",x"3c00",x"0000"), (x"3c00",x"3c00",x"bc00",x"0000",x"0000",x"bc00",x"0000",x"3c00"), (x"3c00",x"bc00",x"bc00",x"0000",x"0000",x"bc00",x"3c00",x"3c00")),
((x"bc00",x"3c00",x"3c00",x"0000",x"0000",x"3c00",x"0000",x"0000"), (x"3c00",x"3c00",x"3c00",x"0000",x"0000",x"3c00",x"0000",x"3c00"), (x"bc00",x"bc00",x"3c00",x"0000",x"0000",x"3c00",x"3c00",x"0000")),
((x"bc00",x"bc00",x"3c00",x"0000",x"0000",x"3c00",x"3c00",x"0000"), (x"3c00",x"3c00",x"3c00",x"0000",x"0000",x"3c00",x"0000",x"3c00"), (x"3c00",x"bc00",x"3c00",x"0000",x"0000",x"3c00",x"3c00",x"3c00")),
((x"bc00",x"3c00",x"bc00",x"bc00",x"0000",x"0000",x"0000",x"0000"), (x"bc00",x"bc00",x"bc00",x"bc00",x"0000",x"0000",x"0000",x"3c00"), (x"bc00",x"3c00",x"3c00",x"bc00",x"0000",x"0000",x"3c00",x"0000")),
((x"bc00",x"3c00",x"3c00",x"bc00",x"0000",x"0000",x"3c00",x"0000"), (x"bc00",x"bc00",x"bc00",x"bc00",x"0000",x"0000",x"0000",x"3c00"), (x"bc00",x"bc00",x"3c00",x"bc00",x"0000",x"0000",x"3c00",x"3c00")),
((x"3c00",x"3c00",x"bc00",x"3c00",x"0000",x"0000",x"0000",x"0000"), (x"3c00",x"bc00",x"bc00",x"3c00",x"0000",x"0000",x"0000",x"3c00"), (x"3c00",x"3c00",x"3c00",x"3c00",x"0000",x"0000",x"3c00",x"0000")),
((x"3c00",x"3c00",x"3c00",x"3c00",x"0000",x"0000",x"3c00",x"0000"), (x"3c00",x"bc00",x"bc00",x"3c00",x"0000",x"0000",x"0000",x"3c00"), (x"3c00",x"bc00",x"3c00",x"3c00",x"0000",x"0000",x"3c00",x"3c00")),
((x"bc00",x"bc00",x"bc00",x"0000",x"bc00",x"0000",x"0000",x"0000"), (x"3c00",x"bc00",x"bc00",x"0000",x"bc00",x"0000",x"0000",x"3c00"), (x"bc00",x"bc00",x"3c00",x"0000",x"bc00",x"0000",x"3c00",x"0000")),
((x"bc00",x"bc00",x"3c00",x"0000",x"bc00",x"0000",x"3c00",x"0000"), (x"3c00",x"bc00",x"bc00",x"0000",x"bc00",x"0000",x"0000",x"3c00"), (x"3c00",x"bc00",x"3c00",x"0000",x"bc00",x"0000",x"3c00",x"3c00")),
((x"bc00",x"3c00",x"bc00",x"0000",x"3c00",x"0000",x"0000",x"0000"), (x"3c00",x"3c00",x"bc00",x"0000",x"3c00",x"0000",x"0000",x"3c00"), (x"bc00",x"3c00",x"3c00",x"0000",x"3c00",x"0000",x"3c00",x"0000")),
((x"bc00",x"3c00",x"3c00",x"0000",x"3c00",x"0000",x"3c00",x"0000"), (x"3c00",x"3c00",x"bc00",x"0000",x"3c00",x"0000",x"0000",x"3c00"), (x"3c00",x"3c00",x"3c00",x"0000",x"3c00",x"0000",x"3c00",x"3c00")),


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

