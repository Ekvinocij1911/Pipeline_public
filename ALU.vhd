----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2023 04:09:47 AM
-- Design Name: 
-- Module Name: ALU - Behavioral
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
use ieee.math_real.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
generic (WIDTH: positive := 32);
Port (
        a : in std_logic_vector (WIDTH - 1 downto 0);
        b : in std_logic_vector (WIDTH - 1 downto 0);
        op : in std_logic_vector (4 downto 0);
        res : out std_logic_vector (WIDTH - 1 downto 0)
        -- zero : out std_logic; -- POGLEDAJ
        -- carry : out std_logic -- POGLEDAJ
         );
end ALU;

architecture Behavioral of ALU is

begin
 process (a,b,op) is
 begin
 if (op = "00000") then
  res <= std_logic_vector(unsigned(a) and unsigned(b)); -- I
 elsif (op = "00001") then
  res <= std_logic_vector(unsigned(a) or unsigned(b)); -- ILI
 elsif (op = "00010") then
  res <= std_logic_vector(unsigned(a) + unsigned(b)); -- SABIRAC
 elsif (op = "00110") then
  res <= std_logic_vector(unsigned(a) - unsigned(b)); -- ODUZIMAC
 elsif (op = "01000") then
  res <= std_logic_vector(unsigned(a) xor unsigned(b)); -- ISKLJUCIVO ILI
 elsif (op = "01001") then
  res <= std_logic_vector(shift_right(unsigned(a),to_integer(unsigned(b)))); -- !!! POMERANJE U DESNO ZA B MESTA !!!
 else
  res <= (others => '0'); -- NISTA NE RADI
 end if;
 
 end process;

end Behavioral;
