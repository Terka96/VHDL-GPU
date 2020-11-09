----------------------------------------------------------------------------------
-- TEXTURE MEMORY
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

