----------------------------------------------------------------------------------
-- TEKSEL PROBER
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.definitions.all;
use ieee.numeric_std.all;

entity TP is
  port(
		clk : in std_logic; --system clock
		addr : in CU_TEX_COORDS;
		load_en : in std_logic_vector(1 to CU_COUNT);
		rd_out : out std_logic_vector(1 to CU_COUNT) := (others => '0');
		color : out COLOR24
	);
end TP;

architecture Behavioral of TP is

component TM is
  port(
			clk : in std_logic; --system clock
			addr : in INT_COORDS;
			rd_out : out std_logic := '0';
			color : out COLOR24
		);
end component;
signal address : INT_COORDS := ("0000000000000","0000000000000");
signal tex_rd : std_logic;

begin

TM_entity : TM port map(
		clk => clk,
		addr => address,
		rd_out => tex_rd,
		color => color
	);

process (clk) is
variable i : integer := 1;
type state is (POLL_TEX, RESPONSE, SCAN);
variable s : state := SCAN;
begin
if rising_edge(clk) then
	case s is
		when SCAN =>
			rd_out <= (others => '0');
			if load_en(i) = '1' then
				address <= addr(i);
				s := POLL_TEX;
			else 
				i := i + 1;
			end if;
			if i > CU_COUNT then
				i := 1;
			end if;
		when POLL_TEX =>
			rd_out(i) <= tex_rd;
			if tex_rd = '1' then
				s := RESPONSE;
			end if;
		when RESPONSE =>
			rd_out <= (others => '0');
			s := SCAN;
		end case;
end if;
end process;
end Behavioral;

