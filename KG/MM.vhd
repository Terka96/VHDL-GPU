----------------------------------------------------------------------------------
-- MODEL MEMORY
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

