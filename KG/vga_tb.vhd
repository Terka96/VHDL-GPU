----------------------------------------------------------------------------------
-- VGA TEST BENCH
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use std.textio.all;
use work.definitions.all;

entity vga_tb is
	port (		
		clk : in std_logic;
		vga_vsync : in std_logic;
		vga_hsync : in std_logic;
		vga_clk : in std_logic;
		vga_r : in std_logic_vector( 7 downto 0 );
		vga_g : in std_logic_vector( 7 downto 0 );
		vga_b : in std_logic_vector( 7 downto 0 )
		);
end vga_tb;

architecture Behavioral of vga_tb is

begin

process (clk) is
    file file_pointer: text open write_mode is "frames/0";
	 variable l : line;
	 variable frame : integer := 0;
begin
    if rising_edge(clk) then
		if vga_vsync = '1' then
			file_close(file_pointer);
			frame := frame +1;
			file_open(file_pointer,"frames/vga_f_"& integer'image(frame)&".ppm",write_mode);
			write(l,"P3");
			writeline(file_pointer,l);
			write(l,"640 480 255");
			writeline(file_pointer,l);

		end if;

       
		  write(l, to_str(vga_r));
		  write(l, " ");
		  write(l, to_str(vga_g));
		  write(l, " ");
		  write(l, to_str(vga_b));
		  writeline(file_pointer,l);
		  
		  
		  --write(l, to_integer(unsigned(vga_r))));
		  --write(l, 'val(to_integer(unsigned(vga_g))));
		  --write(l, character'val(to_integer(unsigned(vga_b))));

    end if;
end process;


end Behavioral;

