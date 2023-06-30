----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/05/2023 09:00:59 PM
-- Design Name: 
-- Module Name: ALU_decoder - Behavioral
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

entity ALU_decoder is
Port (
        alu_2bit_op : in std_logic_vector(1 downto 0);
        funct3 : in std_logic_vector(2 downto 0);
        funct7 : in std_logic_vector(6 downto 0);
        alu_op : out std_logic_vector(4 downto 0)        
         );
end ALU_decoder;

architecture Behavioral of ALU_decoder is

begin
ALU_dec: process (alu_2bit_op, funct3, funct7) is
            begin
            if (alu_2bit_op = "00") then
                alu_op <= "00010";
            elsif (alu_2bit_op = "10") then
                if (funct7 = "0100000") then
                    alu_op <= "00110";
                elsif (funct7 = "0000000") then 
                    if (funct3 = "000") then
                        alu_op <= "00010";
                    elsif (funct3 = "111") then
                        alu_op <= "00000";
                    elsif (funct3 = "110") then
                        alu_op <= "00001";
                    else
                        alu_op <= "00000";
                    end if;
                else
                    alu_op <= "00000";
                end if;
            elsif (alu_2bit_op = "11") then
                if (funct3 = "000") then
                    alu_op <= "00010";
                elsif (funct3 = "100") then
                    alu_op <= "01000";
                elsif (funct3 = "101") then
                    alu_op <= "01001";
                else
                    alu_op <= "00000";
                end if;
            else
                alu_op <= "00000";
            end if;
            end process; 

end Behavioral;
