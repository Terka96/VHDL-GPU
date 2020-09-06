----------------------------------------------------------------------------------
-- METRICS
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use work.definitions.all;

entity metrics is
	port(
		clk : in std_logic;	--system clock
		cu_rd : in std_logic_vector(1 to CU_COUNT);
		cu_ce : in std_logic_vector(1 to CU_COUNT);
		fb_rd : in std_logic;
		cu_pc_data : in std_logic_vector(1 to CU_COUNT);
		pc_fb_data : in std_logic;
		cu_tex_load_en : in std_logic_vector(1 to CU_COUNT);
		cu_tex_rd : in std_logic_vector(1 to CU_COUNT);
		operation_number : in CU_INTEGERS;
		instruction_number : in CU_INTEGERS;
		pixel_drawn : in std_logic
	);
end metrics;

architecture Behavioral of metrics is
type instruction_distribution is array(0 to END_PROGRAMME) of integer;
type operation_distribution is array(0 to 15) of integer;
type cu_instruction_distribution is array(1 to CU_COUNT) of instruction_distribution;
type cu_operation_distribution is array(1 to CU_COUNT) of operation_distribution;
begin

time_series : process (clk) is
	file file_pointer: text open write_mode is "run_logs/time_series";
	variable l : line;
	variable space : string(1 to 1) := " ";
	
	
	variable generated_pixels : integer := 0;
	variable drawn_pixels : integer := 0;
	variable cycles_instruction : cu_instruction_distribution := (others => (others => 0));
	variable cycles_operation : cu_operation_distribution := (others => (others => 0));
	variable count_instruction : cu_instruction_distribution := (others => (others => 0));
	variable count_operation : cu_operation_distribution := (others => (others => 0));
	variable last_operations : CU_INTEGERS := (others => 0);
	variable last_instructions : CU_INTEGERS := (others => 0);
	variable cu_utilization : CU_INTEGERS := (others => 25000);
	variable fb_utilization : integer :=25000;
	variable prepared_texels : integer := 0;
	variable cycles_cu_waiting_for_pixel_poll : CU_INTEGERS := (others => 0);
	variable cycles_cu_waiting_for_texel : CU_INTEGERS := (others => 0);
	variable cycles : integer := 0;
begin
	--data collection
	if rising_edge(clk) then
		cycles := cycles + 1;
		for i in 1 to CU_COUNT loop
			cycles_instruction(i)(instruction_number(i)) := cycles_instruction(i)(instruction_number(i)) + 1;
			cycles_operation(i)(operation_number(i)) := cycles_operation(i)(operation_number(i)) + 1;
			if last_operations(i) /= operation_number(i) then last_operations(i) := operation_number(i); count_operation(i)(operation_number(i)) := count_operation(i)(operation_number(i)) + 1; end if;
			if last_instructions(i) /= instruction_number(i) then last_instructions(i) := instruction_number(i); count_instruction(i)(instruction_number(i)) := count_instruction(i)(instruction_number(i)) + 1; end if;
			if cu_pc_data(i) = '1' then cycles_cu_waiting_for_pixel_poll(i) := cycles_cu_waiting_for_pixel_poll(i) + 1; end if;
			if cu_tex_load_en(i) = '1' then cycles_cu_waiting_for_texel(i) := cycles_cu_waiting_for_texel(i) + 1; end if;
			if cu_rd(i) = '1' then cu_utilization(i) := cu_utilization(i) - 1; end if;
			if cu_tex_rd(i) = '1' then prepared_texels := prepared_texels + 1; end if;	--tylko jeden na raz moze byc rd
		end loop;
		if fb_rd = '1' then fb_utilization := fb_utilization - 1; end if;
		if pixel_drawn = '1' then drawn_pixels := drawn_pixels + 1; end if;
		if pc_fb_data = '1' then generated_pixels := generated_pixels + 1; end if;
	end if;
	
	--output
	if cycles >= 25000 then --with 50MHz clk it is 0.5ms
		write(l,now);
		write(l,space);
		write(l,integer'image(generated_pixels));
		write(l,space);
		write(l,integer'image(drawn_pixels));
		write(l,space);
		write(l,integer'image(prepared_texels));
		write(l,space);
		write(l,integer'image(fb_utilization));
		writeline(file_pointer,l);
		for i in 1 to CU_COUNT loop
			write(l,integer'image(i));
			write(l,space);
			write(l,integer'image(cu_utilization(i)));
			write(l,space);
			write(l,integer'image(cycles_cu_waiting_for_pixel_poll(i)));
			write(l,space);
			write(l,integer'image(cycles_cu_waiting_for_texel(i)));
			write(l,space);
			for j in 0 to END_PROGRAMME loop
				write(l,integer'image(cycles_instruction(i)(j)));
				write(l,space);
			end loop;
			for j in 0 to 15 loop
				write(l,integer'image(cycles_operation(i)(j)));
				write(l,space);
			end loop;
			for j in 0 to END_PROGRAMME loop
				write(l,integer'image(count_instruction(i)(j)));
				write(l,space);
			end loop;
			for j in 0 to 15 loop
				write(l,integer'image(count_operation(i)(j)));
				write(l,space);
			end loop;
			writeline(file_pointer,l);
		end loop;
		cycles := 0;
		generated_pixels := 0;
		drawn_pixels := 0;
		cycles_instruction := (others => (others => 0));
		cycles_operation := (others =>(others => 0));
		cu_utilization := (others => 25000);
		fb_utilization := 25000;
		prepared_texels := 0;
		cycles_cu_waiting_for_pixel_poll := (others => 0);
		cycles_cu_waiting_for_texel := (others => 0);
	end if;
end process;


end Behavioral;

