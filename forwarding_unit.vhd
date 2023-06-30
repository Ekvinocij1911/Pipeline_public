----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/05/2023 09:01:57 PM
-- Design Name: 
-- Module Name: forwarding_unit - Behavioral
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

entity forwarding_unit is
Port (
        rs1_address_id : in std_logic_vector(4 downto 0);
        rs2_address_id : in std_logic_vector(4 downto 0);
        rs1_address_ex : in std_logic_vector(4 downto 0);
        rs2_address_ex : in std_logic_vector(4 downto 0);
        rd_we_mem : in std_logic;
        rd_address_mem : in std_logic_vector(4 downto 0);
        rd_we_wb : in std_logic;
        rd_address_wb : in std_logic_vector(4 downto 0);
        alu_forward_a : out std_logic_vector(1 downto 0);
        alu_forward_b : out std_logic_vector(1 downto 0);
        branch_forward_a : out std_logic;
        branch_forward_b : out std_logic
         );
end forwarding_unit;

architecture Behavioral of forwarding_unit is

begin
alu_forward_a <= "00";
alu_forward_b <= "00";
branch_forward_a <= '0';
branch_forward_b <= '0';

process (rs1_address_id, rs2_address_id, rs1_address_ex, rs2_address_ex, rd_we_mem, rd_address_mem, rd_we_wb, rd_address_wb) is
begin
if (rd_we_wb = '1' and rd_address_wb /= "00000") then
    if (rs1_address_ex = rd_address_wb) then
        alu_forward_a <= "01";
    end if;
    if (rs2_address_ex = rd_address_wb) then
        alu_forward_b <= "01";
    end if;
end if;
if (rd_we_mem = '1' and rd_address_mem /= "00000") then
    if (rs1_address_ex = rd_address_mem) then
        alu_forward_a <= "10";
    end if;
    if (rs2_address_ex = rd_address_mem) then
        alu_forward_b <= "10";
    end if;
    if (rs1_address_id = rd_address_mem) then
        branch_forward_a <= '1';
    end if;
    if (rs2_address_id = rd_address_mem) then
        branch_forward_b <= '1';
    end if;
end if;
    
end process;

end Behavioral;
