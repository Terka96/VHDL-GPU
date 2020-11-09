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
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

package model_presets is

subtype MM_ADDRESS is integer range 0 to 22;
constant AVAILABLE_TRIANGLES : integer := 22;
type MODEL_MEM is array (0 to 22) of MOD_TRIANGLE;

constant light_norm_X_const : FLOAT16 := x"3b8a";
constant light_norm_Y_const : FLOAT16 := x"338a";
constant light_norm_Z_const : FLOAT16 := x"338a";

constant matrix_pp_const : TRANSFORM_MATRIX := (
(x"1acb",x"0000",x"442a",x"0000"),
(x"0000",x"4400",x"0000",x"c400"),
(x"bc29",x"0000",x"12ca",x"482f"),
(x"c414",x"0000",x"1aa7",x"5097")
);


constant model_const : MODEL_MEM :=(
empty_m_tri,
(x"3cb5",x"3a13",x"b644",x"0000",x"3c00",x"0000",x"0000",x"0000",x"3644",x"3a13",x"3cb5",x"0000",x"3c00",x"0000",x"0000",x"3c00",x"b644",x"3a13",x"bcb5",x"0000",x"3c00",x"0000",x"3c00",x"0000"),
(x"3644",x"bbf5",x"3cb5",x"b729",x"0000",x"3b27",x"0000",x"0000",x"bcb5",x"bbf5",x"3644",x"b729",x"0000",x"3b27",x"0000",x"3c00",x"3644",x"3a13",x"3cb5",x"b729",x"0000",x"3b27",x"3c00",x"0000"),
(x"bcb5",x"bbf5",x"3644",x"bb27",x"0000",x"b729",x"0000",x"0000",x"b644",x"bbf5",x"bcb5",x"bb27",x"0000",x"b729",x"0000",x"3c00",x"bcb5",x"3a13",x"3644",x"bb27",x"0000",x"b729",x"3c00",x"0000"),
(x"b644",x"bbf5",x"bcb5",x"0000",x"bc00",x"8000",x"0000",x"0000",x"bcb5",x"bbf5",x"3644",x"0000",x"bc00",x"8000",x"0000",x"3c00",x"3cb5",x"bbf5",x"b644",x"0000",x"bc00",x"8000",x"3c00",x"0000"),
(x"3cb5",x"bbf5",x"b644",x"3b27",x"0000",x"3729",x"0000",x"0000",x"3644",x"bbf5",x"3cb5",x"3b27",x"0000",x"3729",x"0000",x"3c00",x"3cb5",x"3a13",x"b644",x"3b27",x"0000",x"3729",x"3c00",x"0000"),
(x"b644",x"bbf5",x"bcb5",x"3729",x"0000",x"bb27",x"0000",x"0000",x"3cb5",x"bbf5",x"b644",x"3729",x"0000",x"bb27",x"0000",x"3c00",x"b644",x"3a13",x"bcb5",x"3729",x"0000",x"bb27",x"3c00",x"0000"),
(x"3644",x"3a13",x"3cb5",x"0000",x"3c00",x"0000",x"0000",x"3c00",x"bcb5",x"3a13",x"3644",x"0000",x"3c00",x"0000",x"3c00",x"3c00",x"b644",x"3a13",x"bcb5",x"0000",x"3c00",x"0000",x"3c00",x"0000"),
(x"bcb5",x"bbf5",x"3644",x"b729",x"0000",x"3b27",x"0000",x"3c00",x"bcb5",x"3a13",x"3644",x"b729",x"0000",x"3b27",x"3c00",x"3c00",x"3644",x"3a13",x"3cb5",x"b729",x"0000",x"3b27",x"3c00",x"0000"),
(x"b644",x"bbf5",x"bcb5",x"bb27",x"0000",x"b729",x"0000",x"3c00",x"b644",x"3a13",x"bcb5",x"bb27",x"0000",x"b729",x"3c00",x"3c00",x"bcb5",x"3a13",x"3644",x"bb27",x"0000",x"b729",x"3c00",x"0000"),
(x"bcb5",x"bbf5",x"3644",x"0000",x"bc00",x"8000",x"0000",x"3c00",x"3644",x"bbf5",x"3cb5",x"0000",x"bc00",x"8000",x"3c00",x"3c00",x"3cb5",x"bbf5",x"b644",x"0000",x"bc00",x"8000",x"3c00",x"0000"),
(x"3644",x"bbf5",x"3cb5",x"3b27",x"0000",x"3729",x"0000",x"3c00",x"3644",x"3a13",x"3cb5",x"3b27",x"0000",x"3729",x"3c00",x"3c00",x"3cb5",x"3a13",x"b644",x"3b27",x"0000",x"3729",x"3c00",x"0000"),
(x"3cb5",x"bbf5",x"b644",x"3729",x"0000",x"bb27",x"0000",x"3c00",x"3cb5",x"3a13",x"b644",x"3729",x"0000",x"bb27",x"3c00",x"3c00",x"b644",x"3a13",x"bcb5",x"3729",x"0000",x"bb27",x"3c00",x"0000"),
(x"c453",x"bba7",x"4453",x"3c00",x"0000",x"0000",x"0000",x"0000",x"c453",x"4460",x"4453",x"3c00",x"0000",x"0000",x"3c00",x"0000",x"c453",x"bba7",x"c453",x"3c00",x"0000",x"0000",x"0000",x"3c00"),
(x"c453",x"bba7",x"c453",x"0000",x"0000",x"3c00",x"0000",x"0000",x"c453",x"4460",x"c453",x"0000",x"0000",x"3c00",x"3c00",x"0000",x"4453",x"bba7",x"c453",x"0000",x"0000",x"3c00",x"0000",x"3c00"),
(x"4453",x"bba7",x"4453",x"0000",x"0000",x"bc00",x"0000",x"0000",x"4453",x"4460",x"4453",x"0000",x"0000",x"bc00",x"3c00",x"0000",x"c453",x"bba7",x"4453",x"0000",x"0000",x"bc00",x"0000",x"3c00"),
(x"c453",x"bba7",x"c453",x"0000",x"3c00",x"0000",x"0000",x"0000",x"4453",x"bba7",x"c453",x"0000",x"3c00",x"0000",x"3c00",x"0000",x"c453",x"bba7",x"4453",x"0000",x"3c00",x"0000",x"0000",x"3c00"),
(x"4453",x"4460",x"c453",x"0000",x"bc00",x"0000",x"0000",x"0000",x"c453",x"4460",x"c453",x"0000",x"bc00",x"0000",x"3c00",x"0000",x"4453",x"4460",x"4453",x"0000",x"bc00",x"0000",x"0000",x"3c00"),
(x"c453",x"4460",x"4453",x"3c00",x"0000",x"0000",x"3c00",x"0000",x"c453",x"4460",x"c453",x"3c00",x"0000",x"0000",x"3c00",x"3c00",x"c453",x"bba7",x"c453",x"3c00",x"0000",x"0000",x"0000",x"3c00"),
(x"c453",x"4460",x"c453",x"0000",x"0000",x"3c00",x"3c00",x"0000",x"4453",x"4460",x"c453",x"0000",x"0000",x"3c00",x"3c00",x"3c00",x"4453",x"bba7",x"c453",x"0000",x"0000",x"3c00",x"0000",x"3c00"),
(x"4453",x"4460",x"4453",x"0000",x"0000",x"bc00",x"3c00",x"0000",x"c453",x"4460",x"4453",x"0000",x"0000",x"bc00",x"3c00",x"3c00",x"c453",x"bba7",x"4453",x"0000",x"0000",x"bc00",x"0000",x"3c00"),
(x"4453",x"bba7",x"c453",x"0000",x"3c00",x"0000",x"3c00",x"0000",x"4453",x"bba7",x"4453",x"0000",x"3c00",x"0000",x"3c00",x"3c00",x"c453",x"bba7",x"4453",x"0000",x"3c00",x"0000",x"0000",x"3c00"),
(x"c453",x"4460",x"c453",x"0000",x"bc00",x"0000",x"3c00",x"0000",x"c453",x"4460",x"4453",x"0000",x"bc00",x"0000",x"3c00",x"3c00",x"4453",x"4460",x"4453",x"0000",x"bc00",x"0000",x"0000",x"3c00"),
others => empty_m_tri);

end model_presets;

package body model_presets is

end model_presets;
