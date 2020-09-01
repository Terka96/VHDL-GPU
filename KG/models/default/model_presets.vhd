library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

package model_presets is

subtype MM_ADDRESS is integer range 0 to 16;
constant AVAILABLE_TRIANGLES : integer := 12;

--tyl/przod/lewa/prawa/dol/gora
constant model_const : MODEL_MEM :=(
empty_m_tri,
((x"bc00",x"bc00",x"bc00",x"0000",x"0000",x"bc00",x"3c00",x"0000"), (x"3c00",x"3c00",x"bc00",x"0000",x"0000",x"bc00",x"0000",x"3c00"), (x"bc00",x"3c00",x"bc00",x"0000",x"0000",x"bc00",x"0000",x"0000")),
((x"3c00",x"bc00",x"bc00",x"0000",x"0000",x"bc00",x"3c00",x"3c00"), (x"3c00",x"3c00",x"bc00",x"0000",x"0000",x"bc00",x"0000",x"3c00"), (x"bc00",x"bc00",x"bc00",x"0000",x"0000",x"bc00",x"3c00",x"0000")),
((x"bc00",x"3c00",x"3c00",x"0000",x"0000",x"3c00",x"0000",x"0000"), (x"3c00",x"3c00",x"3c00",x"0000",x"0000",x"3c00",x"0000",x"3c00"), (x"bc00",x"bc00",x"3c00",x"0000",x"0000",x"3c00",x"3c00",x"0000")),
((x"bc00",x"bc00",x"3c00",x"0000",x"0000",x"3c00",x"3c00",x"0000"), (x"3c00",x"3c00",x"3c00",x"0000",x"0000",x"3c00",x"0000",x"3c00"), (x"3c00",x"bc00",x"3c00",x"0000",x"0000",x"3c00",x"3c00",x"3c00")),
((x"bc00",x"3c00",x"3c00",x"bc00",x"0000",x"0000",x"3c00",x"0000"), (x"bc00",x"bc00",x"bc00",x"bc00",x"0000",x"0000",x"0000",x"3c00"), (x"bc00",x"3c00",x"bc00",x"bc00",x"0000",x"0000",x"0000",x"0000")),
((x"bc00",x"bc00",x"3c00",x"bc00",x"0000",x"0000",x"3c00",x"3c00"), (x"bc00",x"bc00",x"bc00",x"bc00",x"0000",x"0000",x"0000",x"3c00"), (x"bc00",x"3c00",x"3c00",x"bc00",x"0000",x"0000",x"3c00",x"0000")),
((x"3c00",x"3c00",x"bc00",x"3c00",x"0000",x"0000",x"0000",x"0000"), (x"3c00",x"bc00",x"bc00",x"3c00",x"0000",x"0000",x"0000",x"3c00"), (x"3c00",x"3c00",x"3c00",x"3c00",x"0000",x"0000",x"3c00",x"0000")),
((x"3c00",x"3c00",x"3c00",x"3c00",x"0000",x"0000",x"3c00",x"0000"), (x"3c00",x"bc00",x"bc00",x"3c00",x"0000",x"0000",x"0000",x"3c00"), (x"3c00",x"bc00",x"3c00",x"3c00",x"0000",x"0000",x"3c00",x"3c00")),
((x"bc00",x"bc00",x"3c00",x"0000",x"bc00",x"0000",x"3c00",x"0000"), (x"3c00",x"bc00",x"bc00",x"0000",x"bc00",x"0000",x"0000",x"3c00"), (x"bc00",x"bc00",x"bc00",x"0000",x"bc00",x"0000",x"0000",x"0000")),
((x"3c00",x"bc00",x"3c00",x"0000",x"bc00",x"0000",x"3c00",x"3c00"), (x"3c00",x"bc00",x"bc00",x"0000",x"bc00",x"0000",x"0000",x"3c00"), (x"bc00",x"bc00",x"3c00",x"0000",x"bc00",x"0000",x"3c00",x"0000")),
((x"bc00",x"3c00",x"bc00",x"0000",x"3c00",x"0000",x"0000",x"0000"), (x"3c00",x"3c00",x"bc00",x"0000",x"3c00",x"0000",x"0000",x"3c00"), (x"bc00",x"3c00",x"3c00",x"0000",x"3c00",x"0000",x"3c00",x"0000")),
((x"bc00",x"3c00",x"3c00",x"0000",x"3c00",x"0000",x"3c00",x"0000"), (x"3c00",x"3c00",x"bc00",x"0000",x"3c00",x"0000",x"0000",x"3c00"), (x"3c00",x"3c00",x"3c00",x"0000",x"3c00",x"0000",x"3c00",x"3c00")),
others => empty_m_tri);

constant light_norm_X_const : FLOAT16 := x"3565";
constant light_norm_Y_const : FLOAT16 := x"34c3";
constant light_norm_Z_const : FLOAT16 := x"bb24";

--side
constant matrix_pp_const : TRANSFORM_MATRIX := (
(x"4350",x"0000",x"3ffd",x"c715"),
(x"0000",x"4400",x"0000",x"c600"),
(x"b7fb",x"0000",x"3b4e",x"435e"),
(x"bfd3",x"0000",x"4329",x"4c97")
);

--front
--variable matrix_pp : TRANSFORM_MATRIX := (
--(x"417e",x"0000",x"0000",x"0000"),
--(x"0000",x"417e",x"0000",x"0000"),
--(x"0000",x"0000",x"bc02",x"439d"),
--(x"0000",x"0000",x"bc00",x"4400")
--);

end model_presets;

package body model_presets is

end model_presets;
