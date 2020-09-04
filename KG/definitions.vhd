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

type PIXEL is
  record
	  position			: INT_COORDS;
     color				: COLOR24;
     depth				: FLOAT16;
  end record;

type MOD_TRIANGLE is array (1 to 3) of MOD_VERTEX;
type CU_PIXELS is array (1 to CU_COUNT) of PIXEL;
type CU_TEX_COORDS is array (1 to CU_COUNT) of INT_COORDS;
type CU_INTEGERS is array (1 to CU_COUNT) of integer;

--JUMP LABELS
constant BEGIN_GEOMETRY : integer :=			1;
constant BEGIN_FORY : integer := 				71;
constant BEGIN_FORX : integer := 				72;
constant WAIT_FOR_TEXEL : integer :=			138;
constant WAIT_FOR_DATA_POLL : integer := 		140;
constant CONTINUE_FORX : integer :=				141;
constant CONTINUE_FORY : integer :=				142;
constant END_PROGRAMME : integer :=				143;

constant empty_m_tri : mod_triangle := ( 
(geom_X => x"0000", geom_Y => x"0000", geom_Z => x"0000", norm_X => x"0000", norm_Y => x"0000", norm_Z => x"0000", tex_U => x"0000", tex_V => x"0000"), 
(geom_X => x"0000", geom_Y => x"0000", geom_Z => x"0000", norm_X => x"0000", norm_Y => x"0000", norm_Z => x"0000", tex_U => x"0000", tex_V => x"0000"), 
(geom_X => x"0000", geom_Y => x"0000", geom_Z => x"0000", norm_X => x"0000", norm_Y => x"0000", norm_Z => x"0000", tex_U => x"0000", tex_V => x"0000")
);


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
