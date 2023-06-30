----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/05/2023 09:00:02 PM
-- Design Name: 
-- Module Name: ctrl_decoder - Behavioral
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

entity ctrl_decoder is
Port (
        opcode : in std_logic_vector(6 downto 0);
        branch : out std_logic;
        mem_to_reg : out std_logic;
        data_mem_we : out std_logic;
        alu_src : out std_logic;
        rd_we : out std_logic;
        rs1_in_use : out std_logic;
        rs2_in_use : out std_logic;
        alu_2bit_op : out std_logic_vector(1 downto 0)  
         );
end ctrl_decoder;

architecture Behavioral of ctrl_decoder is

begin
dekoder: process (opcode) is
            begin
            if (opcode = "0110011") then
                alu_src <= '0';
                mem_to_reg <= '0';
                rd_we <= '1';
                data_mem_we <= '0';
                branch <= '0';
                alu_2bit_op <= "10";
                rs1_in_use <= '1';
                rs2_in_use <= '1';
            elsif (opcode = "0000011") then
                alu_src <= '1';
                mem_to_reg <= '1';
                rd_we <= '1';
                data_mem_we <= '0';
                branch <= '0';
                alu_2bit_op <= "00";
                rs1_in_use <= '1';
                rs2_in_use <= '0';
            elsif (opcode = "0100011") then
                alu_src <= '1';
                mem_to_reg <= '0';
                rd_we <= '0';
                data_mem_we <= '1';
                branch <= '0';
                alu_2bit_op <= "00";
                rs1_in_use <= '1';
                rs2_in_use <= '1';
            elsif (opcode = "1100011") then
                alu_src <= '0';
                mem_to_reg <= '0';
                rd_we <= '0';
                data_mem_we <= '0';
                branch <= '1';
                alu_2bit_op <= "01";
                rs1_in_use <= '1';
                rs2_in_use <= '1';
             elsif (opcode = "0010011") then
                alu_src <= '1';
                mem_to_reg <= '0';
                rd_we <= '1';
                data_mem_we <= '0';
                branch <= '0';
                alu_2bit_op <= "11";
                rs1_in_use <= '1';
                rs2_in_use <= '0';
            else
                alu_src <= '0';
                mem_to_reg <= '0';
                rd_we <= '0';
                data_mem_we <= '0';
                branch <= '0';
                alu_2bit_op <= "00";
                rs1_in_use <= '0';
                rs2_in_use <= '0';
            end if;
            end process;

end Behavioral;
