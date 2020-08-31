library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

package cube_presets is

constant cube_model_const : MODEL_MEM :=(
empty_m_tri,
((x"bc00",x"3c00",x"bc00",x"0000",x"0000",x"bc00",x"0000",x"0000"), (x"3c00",x"3c00",x"bc00",x"0000",x"0000",x"bc00",x"0000",x"3c00"), (x"bc00",x"bc00",x"bc00",x"0000",x"0000",x"bc00",x"3c00",x"0000")),	--tyl
((x"bc00",x"bc00",x"bc00",x"0000",x"0000",x"bc00",x"3c00",x"0000"), (x"3c00",x"3c00",x"bc00",x"0000",x"0000",x"bc00",x"0000",x"3c00"), (x"3c00",x"bc00",x"bc00",x"0000",x"0000",x"bc00",x"3c00",x"3c00")),	--tyl
((x"bc00",x"3c00",x"3c00",x"0000",x"0000",x"3c00",x"0000",x"0000"), (x"3c00",x"3c00",x"3c00",x"0000",x"0000",x"3c00",x"0000",x"3c00"), (x"bc00",x"bc00",x"3c00",x"0000",x"0000",x"3c00",x"3c00",x"0000")),	--przod
((x"bc00",x"bc00",x"3c00",x"0000",x"0000",x"3c00",x"3c00",x"0000"), (x"3c00",x"3c00",x"3c00",x"0000",x"0000",x"3c00",x"0000",x"3c00"), (x"3c00",x"bc00",x"3c00",x"0000",x"0000",x"3c00",x"3c00",x"3c00")),	--przod
((x"bc00",x"3c00",x"bc00",x"bc00",x"0000",x"0000",x"0000",x"0000"), (x"bc00",x"bc00",x"bc00",x"bc00",x"0000",x"0000",x"0000",x"3c00"), (x"bc00",x"3c00",x"3c00",x"bc00",x"0000",x"0000",x"3c00",x"0000")),	--lewa
((x"bc00",x"3c00",x"3c00",x"bc00",x"0000",x"0000",x"3c00",x"0000"), (x"bc00",x"bc00",x"bc00",x"bc00",x"0000",x"0000",x"0000",x"3c00"), (x"bc00",x"bc00",x"3c00",x"bc00",x"0000",x"0000",x"3c00",x"3c00")),	--lewa
((x"3c00",x"3c00",x"bc00",x"3c00",x"0000",x"0000",x"0000",x"0000"), (x"3c00",x"bc00",x"bc00",x"3c00",x"0000",x"0000",x"0000",x"3c00"), (x"3c00",x"3c00",x"3c00",x"3c00",x"0000",x"0000",x"3c00",x"0000")),	--prawa
((x"3c00",x"3c00",x"3c00",x"3c00",x"0000",x"0000",x"3c00",x"0000"), (x"3c00",x"bc00",x"bc00",x"3c00",x"0000",x"0000",x"0000",x"3c00"), (x"3c00",x"bc00",x"3c00",x"3c00",x"0000",x"0000",x"3c00",x"3c00")),	--prawa
((x"bc00",x"bc00",x"bc00",x"0000",x"bc00",x"0000",x"0000",x"0000"), (x"3c00",x"bc00",x"bc00",x"0000",x"bc00",x"0000",x"0000",x"3c00"), (x"bc00",x"bc00",x"3c00",x"0000",x"bc00",x"0000",x"3c00",x"0000")),	--dol
((x"bc00",x"bc00",x"3c00",x"0000",x"bc00",x"0000",x"3c00",x"0000"), (x"3c00",x"bc00",x"bc00",x"0000",x"bc00",x"0000",x"0000",x"3c00"), (x"3c00",x"bc00",x"3c00",x"0000",x"bc00",x"0000",x"3c00",x"3c00")),	--dol
((x"bc00",x"3c00",x"bc00",x"0000",x"3c00",x"0000",x"0000",x"0000"), (x"3c00",x"3c00",x"bc00",x"0000",x"3c00",x"0000",x"0000",x"3c00"), (x"bc00",x"3c00",x"3c00",x"0000",x"3c00",x"0000",x"3c00",x"0000")),	--góra
((x"bc00",x"3c00",x"3c00",x"0000",x"3c00",x"0000",x"3c00",x"0000"), (x"3c00",x"3c00",x"bc00",x"0000",x"3c00",x"0000",x"0000",x"3c00"), (x"3c00",x"3c00",x"3c00",x"0000",x"3c00",x"0000",x"3c00",x"3c00")),	--góra
others => empty_m_tri);

constant light_norm_X_const : FLOAT16 := x"3565";
constant light_norm_Y_const : FLOAT16 := x"34c3";
constant light_norm_Z_const : FLOAT16 := x"bb24";

--side
constant matrix_pp_const : TRANSFORM_MATRIX := (
(x"43d4",x"0000",x"4046",x"c795"),
(x"0000",x"4538",x"0000",x"c7d5"),
(x"b827",x"0000",x"3b9b",x"43c0"),
(x"bffd",x"0000",x"4350",x"4cb0")
);

--front
--variable matrix_pp : TRANSFORM_MATRIX := (
--(x"417e",x"0000",x"0000",x"0000"),
--(x"0000",x"417e",x"0000",x"0000"),
--(x"0000",x"0000",x"bc02",x"439d"),
--(x"0000",x"0000",x"bc00",x"4400")
--);

end cube_presets;

package body cube_presets is

end cube_presets;
