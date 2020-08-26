library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

package definitions is

subtype FLOAT16 is std_logic_vector(15 downto 0);
subtype COLOR24 is std_logic_vector(23 downto 0);

subtype MM_ADDRESS is integer range 0 to 255;
subtype TEX_ADDRESS is signed(9 downto 0);

type TRANSFORM_MATRIX is array (0 to 3,0 to 3) of FLOAT16;


type SCREEN_COORDS is
  record
     coord_X			: signed( 9 downto 0 );
     coord_Y			: signed( 9 downto 0 );
  end record;

type MOD_VERTEX is
  record
     geom_X				: FLOAT16;
     geom_Y				: FLOAT16;
     geom_Z				: FLOAT16;
     norm_X				: FLOAT16;
     norm_Y				: FLOAT16;
     norm_Z				: FLOAT16;
     tex_U				: FLOAT16;
     tex_V				: FLOAT16;
  end record;

type PROJ_VERTEX is
  record
    screen_X			: FLOAT16;
    screen_Y			: FLOAT16;
    depth				: FLOAT16;
	 light_L				: FLOAT16;
	 tex_U				: FLOAT16;
	 tex_V				: FLOAT16;
  end record;

type MOD_TRIANGLE is array (1 to 3) of MOD_VERTEX;
type PROJ_TRIANGLE is array (1 to 3) of PROJ_VERTEX;

type PIXEL is
  record
	  position			: SCREEN_COORDS;
     color				: COLOR24;
     depth				: FLOAT16;
  end record;

constant SCREEN_WIDTH : integer := 320;
constant SCREEN_HEIGHT : integer := 240;
constant TEX_SIZE : FLOAT16 := x"5400"; --64

--JUMP LABELS
constant BEGIN_FOR1 : integer :=					34;
constant BEGIN_FORDL1 : integer := 				64;
constant WAIT_FOR_DATA_POLL1 : integer :=		78;
constant CONTINUE_FORDL1 : integer :=			79;
constant CONTINUE_FOR1 : integer :=				80;
constant END_IF2 : integer :=						81;
constant BEGIN_FOR2 : integer :=					93;
constant BEGIN_FORDL2 : integer :=				124;
constant WAIT_FOR_DATA_POLL2 : integer := 	138;
constant CONTINUE_FORDL2 : integer :=			139;
constant CONTINUE_FOR2 : integer :=				140;
constant END_PROGRAMME : integer :=				141;

constant empty_m_tri : mod_triangle := ( 
(geom_X => x"0000", geom_Y => x"0000", geom_Z => x"0000", norm_X => x"0000", norm_Y => x"0000", norm_Z => x"0000", tex_U => x"0000", tex_V => x"0000"), 
(geom_X => x"0000", geom_Y => x"0000", geom_Z => x"0000", norm_X => x"0000", norm_Y => x"0000", norm_Z => x"0000", tex_U => x"0000", tex_V => x"0000"), 
(geom_X => x"0000", geom_Y => x"0000", geom_Z => x"0000", norm_X => x"0000", norm_Y => x"0000", norm_Z => x"0000", tex_U => x"0000", tex_V => x"0000")
);

constant empty_p_tri : proj_triangle := ( 
(screen_X => x"0000", screen_Y => x"0000", depth => x"0000", light_L => x"0000", tex_U => x"0000", tex_V => x"0000"), 
(screen_X => x"0000", screen_Y => x"0000", depth => x"0000", light_L => x"0000", tex_U => x"0000", tex_V => x"0000"), 
(screen_X => x"0000", screen_Y => x"0000", depth => x"0000", light_L => x"0000", tex_U => x"0000", tex_V => x"0000")
);


-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
--
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--

function to_bstring(slv : std_logic_vector) return string;
function to_bstring(sl : std_logic) return string;
function to_char(value : std_logic) return character;

end package definitions;

package body definitions is

FUNCTION to_char(value : STD_LOGIC) RETURN CHARACTER IS
BEGIN
    CASE value IS
        WHEN 'U' =>     RETURN 'U';
        WHEN 'X' =>     RETURN 'X';
        WHEN '0' =>     RETURN '0';
        WHEN '1' =>     RETURN '1';
        WHEN 'Z' =>     RETURN 'Z';
        WHEN 'W' =>     RETURN 'W';
        WHEN 'L' =>     RETURN 'L';
        WHEN 'H' =>     RETURN 'H';
        WHEN '-' =>     RETURN '-';
        WHEN OTHERS =>  RETURN 'X';
    END CASE;
END FUNCTION;



function to_bstring(sl : std_logic) return string is
  variable sl_str_v : string(1 to 3);  -- std_logic image with quotes around
begin
  sl_str_v := std_logic'image(sl);
  return "" & sl_str_v(2);  -- "" & character to get string
end function;

function to_bstring(slv : std_logic_vector) return string is
  alias    slv_norm : std_logic_vector(1 to slv'length) is slv;
  variable sl_str_v : string(1 to 1);  -- String of std_logic
  variable res_v    : string(1 to slv'length);
begin
  for idx in slv_norm'range loop
    sl_str_v := to_bstring(slv_norm(idx));
    res_v(idx) := sl_str_v(1);
  end loop;
  return res_v;
end function;

end definitions;
