library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

package definitions is

subtype FLOAT16 is std_logic_vector(15 downto 0);
subtype COLOR24 is std_logic_vector(23 downto 0);

constant SCREEN_WIDTH : integer := 320;
constant SCREEN_HEIGHT : integer := 240;
constant HALF_SCREEN_WIDTH_F : FLOAT16 := x"5900"; --x"5d00";
constant HALF_SCREEN_HEIGHT_F : FLOAT16 := x"5780"; --x"5b80";
constant CU_COUNT : integer := 1;

type TRANSFORM_MATRIX is array (0 to 3,0 to 3) of FLOAT16;

type INT_COORDS is
  record
     coord_X			: signed( 12 downto 0 );
     coord_Y			: signed( 12 downto 0 );
  end record;


subtype register_addr is integer range 1 to 128;

type operation is ( OP_W4D, OP_NOP, OP_FMUL, OP_FDIV, OP_FADD, OP_FSUB, OP_FF2I, OP_FI2F, OP_FJLT0, OP_FMAX0, OP_MIN, OP_MAX, OP_INC, OP_JGT, OP_MOV, OP_TEX, OP_SH, OP_OUT, OP_JUMP, OP_LDM);

type instruction is
  record
  	op					: operation;
  	sc					: integer range 0 to 15;
   	regA				: register_addr;
  	regB				: register_addr;
   	JWB					: integer range 0 to 512;
  end record;
  
--JUMP LABELS
constant WAIT_FOR_DATA : integer :=				1;
constant BEGIN_FORY : integer := 				220;
constant BEGIN_FORX : integer := 				224;
constant CONTINUE_FORX : integer :=				270;
constant CONTINUE_FORY : integer :=				275;
constant END_PROGRAMME : integer :=				281;
  
type programme is array(1 to 281) of instruction;

constant cu_programme : programme :=(
--PIERWSZY WIERZCHOLEK:
(OP_W4D,0,1,1,1),		--WAIT_FOR_DATA
(OP_LDM,0,1,1,49),		--LOAD_TRIANGLE_TO_REGISTERS
(OP_LDM,0,2,1,50),
(OP_LDM,0,3,1,51),
(OP_LDM,0,4,1,52),
(OP_LDM,0,5,1,53),
(OP_LDM,0,6,1,54),
(OP_LDM,0,7,1,55),
(OP_LDM,0,8,1,56),
(OP_LDM,0,9,1,57),
(OP_LDM,0,10,1,58),
(OP_LDM,0,11,1,59),
(OP_LDM,0,12,1,60),
(OP_LDM,0,13,1,61),
(OP_LDM,0,14,1,62),
(OP_LDM,0,15,1,63),
(OP_LDM,0,16,1,64),
(OP_LDM,0,17,1,65),
(OP_LDM,0,18,1,66),
(OP_LDM,0,19,1,67),
(OP_LDM,0,20,1,68),
(OP_LDM,0,21,1,69),
(OP_LDM,0,22,1,70),
(OP_LDM,0,23,1,71),
(OP_LDM,0,24,1,72),
(OP_FMUL,0,96,49,1),
(OP_FMUL,0,97,50,2),
(OP_FADD,0,1,2,1),
(OP_FMUL,0,98,51,2),
(OP_FADD,0,1,2,1),
(OP_FADD,0,99,1,30),	--v1W
(OP_FMUL,0,84,49,2),
(OP_FMUL,0,85,50,3),
(OP_FADD,0,2,3,2),
(OP_FMUL,0,86,51,3),
(OP_FADD,0,2,3,2),
(OP_FADD,0,87,2,2),
(OP_FDIV,0,2,30,2),
(OP_FMUL,0,2,100,2),
(OP_FADD,0,2,100,27),	--v1X
(OP_FMUL,0,88,49,2),
(OP_FMUL,0,89,50,3),
(OP_FADD,0,2,3,2),
(OP_FMUL,0,90,51,3),
(OP_FADD,0,2,3,2),
(OP_FADD,0,91,2,2),
(OP_FDIV,0,2,30,2),
(OP_FMUL,0,101,102,3),
(OP_FMUL,0,2,3,2),
(OP_FADD,0,2,101,24),	--v1Y
(OP_FMUL,0,92,49,2),
(OP_FMUL,0,93,50,3),
(OP_FADD,0,2,3,2),
(OP_FMUL,0,94,51,3),
(OP_FADD,0,2,3,2),
(OP_FADD,0,95,2,2),
(OP_FDIV,0,2,30,21),	--v1Z
(OP_FMUL,0,52,103,4),
(OP_FMUL,0,4,104,4),
(OP_FMUL,0,53,103,5),
(OP_FMUL,0,5,105,5),
(OP_FADD,0,4,5,4),
(OP_FMUL,0,54,103,5),
(OP_FMUL,0,5,106,5),
(OP_FADD,0,4,5,4),
(OP_FMAX0,0,4,1,18),	--v1L	DRUGI WIERZCHOLEK:
(OP_FMUL,0,96,57,1),
(OP_FMUL,0,97,58,2),
(OP_FADD,0,1,2,1),
(OP_FMUL,0,98,59,2),
(OP_FADD,0,1,2,1),
(OP_FADD,0,99,1,29),	--v2W
(OP_FMUL,0,84,57,2),
(OP_FMUL,0,85,58,3),
(OP_FADD,0,2,3,2),
(OP_FMUL,0,86,59,3),
(OP_FADD,0,2,3,2),
(OP_FADD,0,87,2,2),
(OP_FDIV,0,2,29,2),
(OP_FMUL,0,2,100,2),
(OP_FADD,0,2,100,26),	--v2X
(OP_FMUL,0,88,57,2),
(OP_FMUL,0,89,58,3),
(OP_FADD,0,2,3,2),
(OP_FMUL,0,90,59,3),
(OP_FADD,0,2,3,2),
(OP_FADD,0,91,2,2),
(OP_FDIV,0,2,29,2),
(OP_FMUL,0,101,102,3),
(OP_FMUL,0,2,3,2),
(OP_FADD,0,2,101,23),	--v2Y
(OP_FMUL,0,92,57,2),
(OP_FMUL,0,93,58,3),
(OP_FADD,0,2,3,2),
(OP_FMUL,0,94,59,3),
(OP_FADD,0,2,3,2),
(OP_FADD,0,95,2,2),
(OP_FDIV,0,2,29,20),	--v2Z
(OP_FMUL,0,60,103,4),
(OP_FMUL,0,4,104,4),
(OP_FMUL,0,61,103,5),
(OP_FMUL,0,5,105,5),
(OP_FADD,0,4,5,4),
(OP_FMUL,0,62,103,5),
(OP_FMUL,0,5,106,5),
(OP_FADD,0,4,5,4),
(OP_FMAX0,0,4,1,17),	--v2L	TRZECI WIERZCHOLEK:
(OP_FMUL,0,96,65,1),
(OP_FMUL,0,97,66,2),
(OP_FADD,0,1,2,1),
(OP_FMUL,0,98,67,2),
(OP_FADD,0,1,2,1),
(OP_FADD,0,99,1,28),	--v3W
(OP_FMUL,0,84,65,2),
(OP_FMUL,0,85,66,3),
(OP_FADD,0,2,3,2),
(OP_FMUL,0,86,67,3),
(OP_FADD,0,2,3,2),
(OP_FADD,0,87,2,2),
(OP_FDIV,0,2,28,2),
(OP_FMUL,0,2,100,2),
(OP_FADD,0,2,100,25),	--v3X
(OP_FMUL,0,88,65,2),
(OP_FMUL,0,89,66,3),
(OP_FADD,0,2,3,2),
(OP_FMUL,0,90,67,3),
(OP_FADD,0,2,3,2),
(OP_FADD,0,91,2,2),
(OP_FDIV,0,2,28,2),
(OP_FMUL,0,101,102,3),
(OP_FMUL,0,2,3,2),
(OP_FADD,0,2,101,22),	--v3Y
(OP_FMUL,0,92,65,2),
(OP_FMUL,0,93,66,3),
(OP_FADD,0,2,3,2),
(OP_FMUL,0,94,67,3),
(OP_FADD,0,2,3,2),
(OP_FADD,0,95,2,2),
(OP_FDIV,0,2,28,19),	--v3Z
(OP_FMUL,0,68,103,4),
(OP_FMUL,0,4,104,4),
(OP_FMUL,0,69,103,5),
(OP_FMUL,0,5,105,5),
(OP_FADD,0,4,5,4),
(OP_FMUL,0,70,103,5),
(OP_FMUL,0,5,106,5),
(OP_FADD,0,4,5,4),
(OP_FMAX0,0,4,1,16),	--v3L	RZUTOWANIA:
(OP_FF2I,0,27,1,82),
(OP_FF2I,0,26,1,81),
(OP_FF2I,0,25,1,80),
(OP_FF2I,0,24,1,79),
(OP_FF2I,0,23,1,78),
(OP_FF2I,0,22,1,77),	--PARAMETRY DZIELENIE PRZEZ W:
(OP_FDIV,0,21,30,21),
(OP_FDIV,0,20,29,20),
(OP_FDIV,0,19,28,19),
(OP_FDIV,0,18,30,18),
(OP_FDIV,0,17,29,17),
(OP_FDIV,0,16,28,16),
(OP_FDIV,0,55,30,15),
(OP_FDIV,0,63,29,14),
(OP_FDIV,0,71,28,13),
(OP_FDIV,0,56,30,12),
(OP_FDIV,0,64,29,11),
(OP_FDIV,0,72,28,10),	--ODWROTNOSCI W:
(OP_FDIV,0,107,30,30),
(OP_FDIV,0,107,29,29),
(OP_FDIV,0,107,28,28),	--BOUNDING BOX:
(OP_MIN,0,82,81,76),
(OP_MIN,0,76,80,76),
(OP_MIN,0,78,79,75),
(OP_MIN,0,75,77,75),
(OP_MAX,0,82,81,74),
(OP_MAX,0,74,80,74),
(OP_MAX,0,78,79,73),
(OP_MAX,0,73,77,73),
(OP_MIN,0,109,73,73),
(OP_MIN,0,108,74,74),
(OP_MAX,0,111,75,75),
(OP_MAX,0,111,76,76),
(OP_MOV,0,76,1,83),  --AREA:
(OP_FSUB,0,25,27,1),
(OP_FSUB,0,23,24,2),
(OP_FMUL,0,1,2,1),
(OP_FSUB,0,22,24,2),
(OP_FSUB,0,26,27,3),
(OP_FMUL,0,2,3,2),
(OP_FSUB,0,1,2,31),
(OP_FJLT0,0,31,1,END_PROGRAMME),	--WSPOLRZEDNE BARYCENTRYCZNE DLA (minX,minY):
(OP_FI2F,0,76,1,9),
(OP_FI2F,0,75,1,8),
(OP_FSUB,0,9,26,1),
(OP_FSUB,0,22,23,2),
(OP_FMUL,0,1,2,1),
(OP_FSUB,0,8,23,2),
(OP_FSUB,0,25,26,3),
(OP_FMUL,0,2,3,2),
(OP_FSUB,0,1,2,32),
(OP_FSUB,0,9,25,1),
(OP_FSUB,0,24,22,2),
(OP_FMUL,0,1,2,1),
(OP_FSUB,0,8,22,2),
(OP_FSUB,0,27,25,3),
(OP_FMUL,0,2,3,2),
(OP_FSUB,0,1,2,33),
(OP_FSUB,0,9,27,1),
(OP_FSUB,0,23,24,2),
(OP_FMUL,0,1,2,1),
(OP_FSUB,0,8,24,2),
(OP_FSUB,0,26,27,3),
(OP_FMUL,0,2,3,2),
(OP_FSUB,0,1,2,34),		--DELTY BARYCENTRYCZNE:
(OP_FSUB,0,22,23,40),
(OP_FSUB,0,24,22,42),
(OP_FSUB,0,23,24,44),
(OP_FSUB,0,26,25,41),
(OP_FSUB,0,25,27,43),
(OP_FSUB,0,27,26,45),	--FORKI:
(OP_JGT,0,75,73,END_PROGRAMME),					--BEGIN_FORY
(OP_MOV,0,32,1,46),
(OP_MOV,0,33,1,47),
(OP_MOV,0,34,1,48),
(OP_JGT,0,76,74,CONTINUE_FORY),					--BEGIN_FORX
(OP_FJLT0,0,46,1,CONTINUE_FORX),
(OP_FJLT0,0,47,1,CONTINUE_FORX),
(OP_FJLT0,0,48,1,CONTINUE_FORX),	--NORMALIZACJA WSPOLRZEDNYCH BARYCENTRYCZNYCH:
(OP_FDIV,0,46,31,5),
(OP_FDIV,0,47,31,6),
(OP_FDIV,0,48,31,7),	--INTERPOLACJE:
(OP_FMUL,0,5,30,1),
(OP_FMUL,0,6,29,2),
(OP_FADD,0,1,2,1),
(OP_FMUL,0,7,28,2),
(OP_FADD,0,1,2,1),
(OP_FDIV,0,107,1,35),	--W
(OP_FMUL,0,5,15,1),
(OP_FMUL,0,6,14,2),
(OP_FADD,0,1,2,1),
(OP_FMUL,0,7,13,2),
(OP_FADD,0,1,2,1),
(OP_FMUL,0,35,1,36),	--TU
(OP_FMUL,0,5,12,1),
(OP_FMUL,0,6,11,2),
(OP_FADD,0,1,2,1),
(OP_FMUL,0,7,10,2),
(OP_FADD,0,1,2,1),
(OP_FMUL,0,35,1,37),	--TV
(OP_FMUL,0,5,18,1),
(OP_FMUL,0,6,17,2),
(OP_FADD,0,1,2,1),
(OP_FMUL,0,7,16,2),
(OP_FADD,0,1,2,1),
(OP_FMUL,0,35,1,38),	--L
(OP_FMUL,0,5,21,1),
(OP_FMUL,0,6,20,2),
(OP_FADD,0,1,2,1),
(OP_FMUL,0,7,19,2),
(OP_FADD,0,1,2,1),
(OP_FDIV,0,107,1,39),	--Z		SKALOWANIE I RZUTOWANIE:
(OP_FMUL,0,36,110,36),
(OP_FMUL,0,37,102,1),
(OP_FMUL,0,1,110,37),
(OP_FF2I,0,36,1,36),
(OP_FF2I,0,37,1,37),
(OP_FF2I,0,38,1,38),
(OP_TEX,0,36,37,1),
(OP_SH,0,76,75,1),
(OP_OUT,0,1,1,1),
(OP_FADD,0,46,40,46),					--CONTINUE_FORX
(OP_FADD,0,47,42,47),
(OP_FADD,0,48,44,48),
(OP_INC,0,76,1,76),
(OP_JUMP,0,1,1,BEGIN_FORX),
(OP_FADD,0,32,41,32),					--CONTINUE_FORY
(OP_FADD,0,33,43,33),
(OP_FADD,0,34,45,34),
(OP_MOV,0,83,1,76),
(OP_INC,0,75,1,75),
(OP_JUMP,0,1,1,BEGIN_FORY),
(OP_JUMP,0,1,1,WAIT_FOR_DATA)			--END_PROGRAMME
);


--type MOD_VERTEX is
--  record
--     geom_X				: FLOAT16;
--     geom_Y				: FLOAT16;
--     geom_Z				: FLOAT16;
--     norm_X				: FLOAT16;
--     norm_Y				: FLOAT16;
--     norm_Z				: FLOAT16;
--     tex_U				: FLOAT16;
--     tex_V				: FLOAT16;
--  end record;

type PIXEL is
  record
	 position			: INT_COORDS;
     color				: COLOR24;
     depth				: FLOAT16;
  end record;

type MOD_TRIANGLE is array(1 to 24) of FLOAT16;
type CU_PIXELS is array (1 to CU_COUNT) of PIXEL;
type CU_TEX_COORDS is array (1 to CU_COUNT) of INT_COORDS;
type CU_INTEGERS is array (1 to CU_COUNT) of integer;


constant empty_m_tri : mod_triangle := ( x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", 
 x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000",
 x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000");


function to_char(value : std_logic_vector(3 downto 0)) return character;
function to_char(value : std_logic) return character;
function to_ascii(SLV8 :STD_LOGIC_VECTOR (7 downto 0)) return CHARACTER;
function to_str (SLV8 :STD_LOGIC_VECTOR (7 downto 0)) return string;

end package definitions;

package body definitions is

FUNCTION to_char(value : std_logic) RETURN CHARACTER IS
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

FUNCTION to_char(value : std_logic_vector(3 downto 0)) RETURN CHARACTER IS
BEGIN
    CASE value IS
        WHEN "0000" =>     RETURN '0';
        WHEN "0001" =>     RETURN '1';
		  WHEN "0010" =>     RETURN '2';
		  WHEN "0011" =>     RETURN '3';
		  WHEN "0100" =>     RETURN '4';
		  WHEN "0101" =>     RETURN '5';
		  WHEN "0110" =>     RETURN '6';
		  WHEN "0111" =>     RETURN '7';
		  WHEN "1000" =>     RETURN '8';
		  WHEN "1001" =>     RETURN '9';
		  WHEN "1010" =>     RETURN 'A';
		  WHEN "1011" =>     RETURN 'B';
		  WHEN "1100" =>     RETURN 'C';
		  WHEN "1101" =>     RETURN 'D';
		  WHEN "1110" =>     RETURN 'E';
		  WHEN "1111" =>     RETURN 'F';
        WHEN OTHERS =>  RETURN '0';
    END CASE;
end function;
	 
function to_ascii (SLV8 :STD_LOGIC_VECTOR (7 downto 0)) return CHARACTER is
	constant XMAP :INTEGER :=0;
	variable TEMP :INTEGER :=0;
begin
	for i in SLV8'range loop
		TEMP:=TEMP*2;
		case SLV8(i) is
			when '0' | 'L' => null;
			when '1' | 'H' => TEMP :=TEMP+1;
			when others => TEMP :=TEMP+XMAP;
		end case;
	end loop;
	return CHARACTER'VAL(TEMP);
end to_ascii;

function to_str (SLV8 :STD_LOGIC_VECTOR (7 downto 0)) return string is
begin
	case SLV8 is
		when x"00" => RETURN "0";
		when x"01" => RETURN "1";
		when x"02" => RETURN "2";
		when x"03" => RETURN "3";
		when x"04" => RETURN "4";
		when x"05" => RETURN "5";
		when x"06" => RETURN "6";
		when x"07" => RETURN "7";
		when x"08" => RETURN "8";
		when x"09" => RETURN "9";
		when x"0A" => RETURN "10";
		when x"0B" => RETURN "11";
		when x"0C" => RETURN "12";
		when x"0D" => RETURN "13";
		when x"0E" => RETURN "14";
		when x"0F" => RETURN "15";
		when x"10" => RETURN "16";
		when x"11" => RETURN "17";
		when x"12" => RETURN "18";
		when x"13" => RETURN "19";
		when x"14" => RETURN "20";
		when x"15" => RETURN "21";
		when x"16" => RETURN "22";
		when x"17" => RETURN "23";
		when x"18" => RETURN "24";
		when x"19" => RETURN "25";
		when x"1A" => RETURN "26";
		when x"1B" => RETURN "27";
		when x"1C" => RETURN "28";
		when x"1D" => RETURN "29";
		when x"1E" => RETURN "30";
		when x"1F" => RETURN "31";
		when x"20" => RETURN "32";
		when x"21" => RETURN "33";
		when x"22" => RETURN "34";
		when x"23" => RETURN "35";
		when x"24" => RETURN "36";
		when x"25" => RETURN "37";
		when x"26" => RETURN "38";
		when x"27" => RETURN "39";
		when x"28" => RETURN "40";
		when x"29" => RETURN "41";
		when x"2A" => RETURN "42";
		when x"2B" => RETURN "43";
		when x"2C" => RETURN "44";
		when x"2D" => RETURN "45";
		when x"2E" => RETURN "46";
		when x"2F" => RETURN "47";
		when x"30" => RETURN "48";
		when x"31" => RETURN "49";
		when x"32" => RETURN "50";
		when x"33" => RETURN "51";
		when x"34" => RETURN "52";
		when x"35" => RETURN "53";
		when x"36" => RETURN "54";
		when x"37" => RETURN "55";
		when x"38" => RETURN "56";
		when x"39" => RETURN "57";
		when x"3A" => RETURN "58";
		when x"3B" => RETURN "59";
		when x"3C" => RETURN "60";
		when x"3D" => RETURN "61";
		when x"3E" => RETURN "62";
		when x"3F" => RETURN "63";
		when x"40" => RETURN "64";
		when x"41" => RETURN "65";
		when x"42" => RETURN "66";
		when x"43" => RETURN "67";
		when x"44" => RETURN "68";
		when x"45" => RETURN "69";
		when x"46" => RETURN "70";
		when x"47" => RETURN "71";
		when x"48" => RETURN "72";
		when x"49" => RETURN "73";
		when x"4A" => RETURN "74";
		when x"4B" => RETURN "75";
		when x"4C" => RETURN "76";
		when x"4D" => RETURN "77";
		when x"4E" => RETURN "78";
		when x"4F" => RETURN "79";
		when x"50" => RETURN "80";
		when x"51" => RETURN "81";
		when x"52" => RETURN "82";
		when x"53" => RETURN "83";
		when x"54" => RETURN "84";
		when x"55" => RETURN "85";
		when x"56" => RETURN "86";
		when x"57" => RETURN "87";
		when x"58" => RETURN "88";
		when x"59" => RETURN "89";
		when x"5A" => RETURN "90";
		when x"5B" => RETURN "91";
		when x"5C" => RETURN "92";
		when x"5D" => RETURN "93";
		when x"5E" => RETURN "94";
		when x"5F" => RETURN "95";
		when x"60" => RETURN "96";
		when x"61" => RETURN "97";
		when x"62" => RETURN "98";
		when x"63" => RETURN "99";
		when x"64" => RETURN "100";
		when x"65" => RETURN "101";
		when x"66" => RETURN "102";
		when x"67" => RETURN "103";
		when x"68" => RETURN "104";
		when x"69" => RETURN "105";
		when x"6A" => RETURN "106";
		when x"6B" => RETURN "107";
		when x"6C" => RETURN "108";
		when x"6D" => RETURN "109";
		when x"6E" => RETURN "110";
		when x"6F" => RETURN "111";
		when x"70" => RETURN "112";
		when x"71" => RETURN "113";
		when x"72" => RETURN "114";
		when x"73" => RETURN "115";
		when x"74" => RETURN "116";
		when x"75" => RETURN "117";
		when x"76" => RETURN "118";
		when x"77" => RETURN "119";
		when x"78" => RETURN "120";
		when x"79" => RETURN "121";
		when x"7A" => RETURN "122";
		when x"7B" => RETURN "123";
		when x"7C" => RETURN "124";
		when x"7D" => RETURN "125";
		when x"7E" => RETURN "126";
		when x"7F" => RETURN "127";
		when x"80" => RETURN "128";
		when x"81" => RETURN "129";
		when x"82" => RETURN "130";
		when x"83" => RETURN "131";
		when x"84" => RETURN "132";
		when x"85" => RETURN "133";
		when x"86" => RETURN "134";
		when x"87" => RETURN "135";
		when x"88" => RETURN "136";
		when x"89" => RETURN "137";
		when x"8A" => RETURN "138";
		when x"8B" => RETURN "139";
		when x"8C" => RETURN "140";
		when x"8D" => RETURN "141";
		when x"8E" => RETURN "142";
		when x"8F" => RETURN "143";
		when x"90" => RETURN "144";
		when x"91" => RETURN "145";
		when x"92" => RETURN "146";
		when x"93" => RETURN "147";
		when x"94" => RETURN "148";
		when x"95" => RETURN "149";
		when x"96" => RETURN "150";
		when x"97" => RETURN "151";
		when x"98" => RETURN "152";
		when x"99" => RETURN "153";
		when x"9A" => RETURN "154";
		when x"9B" => RETURN "155";
		when x"9C" => RETURN "156";
		when x"9D" => RETURN "157";
		when x"9E" => RETURN "158";
		when x"9F" => RETURN "159";
		when x"A0" => RETURN "160";
		when x"A1" => RETURN "161";
		when x"A2" => RETURN "162";
		when x"A3" => RETURN "163";
		when x"A4" => RETURN "164";
		when x"A5" => RETURN "165";
		when x"A6" => RETURN "166";
		when x"A7" => RETURN "167";
		when x"A8" => RETURN "168";
		when x"A9" => RETURN "169";
		when x"AA" => RETURN "170";
		when x"AB" => RETURN "171";
		when x"AC" => RETURN "172";
		when x"AD" => RETURN "173";
		when x"AE" => RETURN "174";
		when x"AF" => RETURN "175";
		when x"B0" => RETURN "176";
		when x"B1" => RETURN "177";
		when x"B2" => RETURN "178";
		when x"B3" => RETURN "179";
		when x"B4" => RETURN "180";
		when x"B5" => RETURN "181";
		when x"B6" => RETURN "182";
		when x"B7" => RETURN "183";
		when x"B8" => RETURN "184";
		when x"B9" => RETURN "185";
		when x"BA" => RETURN "186";
		when x"BB" => RETURN "187";
		when x"BC" => RETURN "188";
		when x"BD" => RETURN "189";
		when x"BE" => RETURN "190";
		when x"BF" => RETURN "191";
		when x"C0" => RETURN "192";
		when x"C1" => RETURN "193";
		when x"C2" => RETURN "194";
		when x"C3" => RETURN "195";
		when x"C4" => RETURN "196";
		when x"C5" => RETURN "197";
		when x"C6" => RETURN "198";
		when x"C7" => RETURN "199";
		when x"C8" => RETURN "200";
		when x"C9" => RETURN "201";
		when x"CA" => RETURN "202";
		when x"CB" => RETURN "203";
		when x"CC" => RETURN "204";
		when x"CD" => RETURN "205";
		when x"CE" => RETURN "206";
		when x"CF" => RETURN "207";
		when x"D0" => RETURN "208";
		when x"D1" => RETURN "209";
		when x"D2" => RETURN "210";
		when x"D3" => RETURN "211";
		when x"D4" => RETURN "212";
		when x"D5" => RETURN "213";
		when x"D6" => RETURN "214";
		when x"D7" => RETURN "215";
		when x"D8" => RETURN "216";
		when x"D9" => RETURN "217";
		when x"DA" => RETURN "218";
		when x"DB" => RETURN "219";
		when x"DC" => RETURN "220";
		when x"DD" => RETURN "221";
		when x"DE" => RETURN "222";
		when x"DF" => RETURN "223";
		when x"E0" => RETURN "224";
		when x"E1" => RETURN "225";
		when x"E2" => RETURN "226";
		when x"E3" => RETURN "227";
		when x"E4" => RETURN "228";
		when x"E5" => RETURN "229";
		when x"E6" => RETURN "230";
		when x"E7" => RETURN "231";
		when x"E8" => RETURN "232";
		when x"E9" => RETURN "233";
		when x"EA" => RETURN "234";
		when x"EB" => RETURN "235";
		when x"EC" => RETURN "236";
		when x"ED" => RETURN "237";
		when x"EE" => RETURN "238";
		when x"EF" => RETURN "239";
		when x"F0" => RETURN "240";
		when x"F1" => RETURN "241";
		when x"F2" => RETURN "242";
		when x"F3" => RETURN "243";
		when x"F4" => RETURN "244";
		when x"F5" => RETURN "245";
		when x"F6" => RETURN "246";
		when x"F7" => RETURN "247";
		when x"F8" => RETURN "248";
		when x"F9" => RETURN "249";
		when x"FA" => RETURN "250";
		when x"FB" => RETURN "251";
		when x"FC" => RETURN "252";
		when x"FD" => RETURN "253";
		when x"FE" => RETURN "254";
		when x"FF" => RETURN "255";
		when others => RETURN "0";
	end case;
end to_str;



end definitions;
