--------------------------------------------------------------------------------
--    This file is owned and controlled by Xilinx and must be used solely     --
--    for design, simulation, implementation and creation of design files     --
--    limited to Xilinx devices or technologies. Use with non-Xilinx          --
--    devices or technologies is expressly prohibited and immediately         --
--    terminates your license.                                                --
--                                                                            --
--    XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" SOLELY    --
--    FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY    --
--    PROVIDING THIS DESIGN, CODE, OR INFORMATION AS ONE POSSIBLE             --
--    IMPLEMENTATION OF THIS FEATURE, APPLICATION OR STANDARD, XILINX IS      --
--    MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION IS FREE FROM ANY      --
--    CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE FOR OBTAINING ANY       --
--    RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY       --
--    DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE   --
--    IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR          --
--    REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF         --
--    INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A   --
--    PARTICULAR PURPOSE.                                                     --
--                                                                            --
--    Xilinx products are not intended for use in life support appliances,    --
--    devices, or systems.  Use in such applications are expressly            --
--    prohibited.                                                             --
--                                                                            --
--    (c) Copyright 1995-2020 Xilinx, Inc.                                    --
--    All rights reserved.                                                    --
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--    Generated from core with identifier: xilinx.com:ip:floating_point:6.1   --
--                                                                            --
--    The Xilinx Floating-Point Operator is capable of being configured to    --
--    provide a range of floating-point operations. The core offers           --
--    addition, subtraction, multiplication, division, reciprocal,            --
--    square-root, reciprocal-square-root, absolute value, logarithm,         --
--    compare and conversion operations. High-speed, single-cycle             --
--    throughput is provided at a wide range of wordlengths that includes     --
--    both single and double precision. XtremeDSP slices can be used with     --
--    certain operations.                                                     --
--------------------------------------------------------------------------------

-- Interfaces:
--    S_AXIS_A
--    aclk_intf
--    aresetn_intf
--    aclken_intf
--    S_AXIS_B
--    M_AXIS_RESULT
--    S_AXIS_OPERATION

-- The following code must appear in the VHDL architecture header:

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT fpu_cmp_fb
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    s_axis_b_tvalid : IN STD_LOGIC;
    s_axis_b_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : fpu_cmp_fb
  PORT MAP (
    aclk => aclk,
    s_axis_a_tvalid => s_axis_a_tvalid,
    s_axis_a_tdata => s_axis_a_tdata,
    s_axis_b_tvalid => s_axis_b_tvalid,
    s_axis_b_tdata => s_axis_b_tdata,
    m_axis_result_tvalid => m_axis_result_tvalid,
    m_axis_result_tdata => m_axis_result_tdata
  );
-- INST_TAG_END ------ End INSTANTIATION Template ------------

-- You must compile the wrapper file fpu_cmp_fb.vhd when simulating
-- the core, fpu_cmp_fb. When compiling the wrapper file, be sure to
-- reference the XilinxCoreLib VHDL simulation library. For detailed
-- instructions, please refer to the "CORE Generator Help".

