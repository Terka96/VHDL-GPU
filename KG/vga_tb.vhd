----------------------------------------------------------------------------------
-- VGA TEST BENCH
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use ieee.numeric_std.all;
--use ieee.std_logic_textio.all;
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
    file file_pointer: text open write_mode is "vga_output_tb.txt";
    variable line_el: line;
begin
    if rising_edge(clk) then
	--report time'image(now)&":"&" "&to_bstring(vga_hsync)&" "&to_bstring(vga_vsync)&" "&to_bstring(vga_r)&" "&to_bstring(vga_g)&" "&to_bstring(vga_b);

        -- Write the time
        write(line_el, time'image(now));
        write(line_el, ":");

        -- Write the hsync
        write(line_el, " ");
        write(line_el, to_char(vga_hsync));

        -- Write the vsync
        write(line_el, " ");
        write(line_el, to_char(vga_vsync));

        -- Write the red
        write(line_el, " ");
        write(line_el, to_char(vga_r(7)));
		  write(line_el, to_char(vga_r(6)));
		  write(line_el, to_char(vga_r(5)));
		  write(line_el, to_char(vga_r(4)));
		  write(line_el, to_char(vga_r(3)));
		  write(line_el, to_char(vga_r(2)));
		  write(line_el, to_char(vga_r(1)));
		  write(line_el, to_char(vga_r(0)));

        -- Write the green
        write(line_el, " ");
		  write(line_el, to_char(vga_g(7)));
		  write(line_el, to_char(vga_g(6)));
		  write(line_el, to_char(vga_g(5)));
		  write(line_el, to_char(vga_g(4)));
		  write(line_el, to_char(vga_g(3)));
		  write(line_el, to_char(vga_g(2)));
		  write(line_el, to_char(vga_g(1)));
		  write(line_el, to_char(vga_g(0)));

        -- Write the blue
        write(line_el, " ");
		  write(line_el, to_char(vga_b(7)));
		  write(line_el, to_char(vga_b(6)));
		  write(line_el, to_char(vga_b(5)));
		  write(line_el, to_char(vga_b(4)));
		  write(line_el, to_char(vga_b(3)));
		  write(line_el, to_char(vga_b(2)));
		  write(line_el, to_char(vga_b(1)));
		  write(line_el, to_char(vga_b(0)));
		  
		  
        writeline(file_pointer, line_el);

    end if;
end process;


end Behavioral;

