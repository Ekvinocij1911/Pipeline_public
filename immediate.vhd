----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2023 10:10:22 PM
-- Design Name: 
-- Module Name: immediate - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity immediate is
Port (
        instruction : in std_logic_vector (31 downto 0);
        imm_ext : out std_logic_vector (31 downto 0)
         );
end immediate;
-- OBRATI PAZNJU NA SRLI!!!
architecture Behavioral of immediate is

begin
 process (instruction) is
 begin
 if (instruction (6 downto 0) = "0110011") then -- R TIP INSTRUKCIJE, NE KORISTI SE IMMEDIATE
  imm_ext <= (others => '0');
 elsif (instruction (6 downto 0) = "0010011") then -- SRLI, XORI, ADDI
  if (instruction (31) = '0') then
  imm_ext (31 downto 12) <= (others => '0');
  imm_ext (11 downto 0) <= instruction (31 downto 20);
  else
  imm_ext (31 downto 12) <= (others => '1');
  imm_ext (11 downto 0) <= instruction (31 downto 20);
  end if;
 elsif (instruction (6 downto 0) = "0100011") then -- SW
  if (instruction (31) = '0') then
  imm_ext (31 downto 12) <= (others => '0');
  imm_ext (11 downto 5) <= instruction (31 downto 25);
  imm_ext (4 downto 0) <= instruction (11 downto 7);
  else
  imm_ext (31 downto 12) <= (others => '1');
  imm_ext (11 downto 5) <= instruction (31 downto 25);
  imm_ext (4 downto 0) <= instruction (11 downto 7);
  end if;
 elsif (instruction (6 downto 0) = "0000011") then -- LW
  if (instruction (31) = '0') then
  imm_ext (31 downto 12) <= (others => '0');
  imm_ext (11 downto 0) <= instruction (31 downto 20);
  else
  imm_ext (31 downto 12) <= (others => '1');
  imm_ext (11 downto 0) <= instruction (31 downto 20);
  end if;
 elsif (instruction (6 downto 0) = "1100011") then -- BGE, BEQ
  if (instruction (31) = '0') then
  imm_ext (31 downto 12) <= (others => '0');
  imm_ext (11) <= instruction (31);
  imm_ext (10) <= instruction (7);
  imm_ext (9 downto 4) <= instruction (30 downto 25);
  imm_ext (3 downto 0) <= instruction (11 downto 8);
  else
  imm_ext (31 downto 12) <= (others => '1');
  imm_ext (11) <= instruction (31);
  imm_ext (10) <= instruction (7);
  imm_ext (9 downto 4) <= instruction (30 downto 25);
  imm_ext (3 downto 0) <= instruction (11 downto 8);
  end if;
 else -- NEPOZNATA INSTRUKCIJA
 imm_ext <= (others => '0');
 end if; 
 
 end process;

end Behavioral;
