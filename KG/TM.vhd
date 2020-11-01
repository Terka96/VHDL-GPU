----------------------------------------------------------------------------------
-- TEXTURE MEMORY
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.definitions.all;
use work.texture.all;


entity TM is
  port(
			clk : in std_logic; --system clock
			addr : in INT_COORDS;
			rd_out : out std_logic := '0';
			color : out COLOR24
		);
end TM;

architecture Behavioral of TM is


begin
  process (clk) is
  variable addr_out : INT_COORDS := ("0000000000000","0000000000000");
  variable memory : TEXTURE_MEM := texture_memory_const;

--others => (others => x"ffffff"));

  begin
    if falling_edge(clk) then
	   if addr_out /= addr then
	     addr_out := addr;
		  rd_out <= '0';
		else
		  rd_out <= '1';
		end if;
		color <= memory(to_integer(addr.coord_Y))(to_integer(addr.coord_X));
	 end if;
  end process;

end Behavioral;

