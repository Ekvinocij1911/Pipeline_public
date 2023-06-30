----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/05/2023 09:01:35 PM
-- Design Name: 
-- Module Name: hazard_unit - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hazard_unit is
Port ( 
       rs1_address_id : in std_logic_vector(4 downto 0);
       rs2_address_id : in std_logic_vector(4 downto 0);
       rs1_in_use : in std_logic;
       rs2_in_use : in std_logic;
       branch_id : in std_logic;
       rd_address_ex : in std_logic_vector(4 downto 0);
       mem_to_reg_ex : in std_logic;
       rd_we_ex : in std_logic;
       rd_address_mem : in std_logic_vector(4 downto 0);
       mem_to_reg_mem : in std_logic;
       pc_en : out std_logic;
       if_id_en : out std_logic;
       control_pass : out std_logic
        
        );
end hazard_unit;

architecture Behavioral of hazard_unit is

begin


process (rs1_address_id, rs2_address_id, rs1_in_use, rs2_in_use, branch_id, rd_address_ex, mem_to_reg_ex, rd_we_ex, rd_address_mem, mem_to_reg_mem) is begin
pc_en <= '1';
if_id_en <= '1';
control_pass <= '0';
if (branch_id = '0') then
    if (((rs1_address_id = rd_address_ex and rs1_in_use = '1') or (rs2_address_id = rd_address_ex and rs2_in_use = '1')) and mem_to_reg_ex = '1' and rd_we_ex = '1') then
        pc_en <= '0';
       if_id_en <= '0';
        control_pass <= '1';
    end if;
elsif (branch_id = '1') then 
    if ((rs1_address_id = rd_address_ex or rs2_address_id = rd_address_ex) and rd_we_ex = '1') then
       pc_en <= '0';
        if_id_en <= '0';
        control_pass <= '1';
    elsif ((rs1_address_id = rd_address_mem or rs2_address_id = rd_address_mem) and mem_to_reg_mem = '1') then
        pc_en <= '0';
        if_id_en <= '0';
        control_pass <= '1';
    end if;
end if;
end process;
end Behavioral;
