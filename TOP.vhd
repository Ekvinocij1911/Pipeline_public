----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/28/2023 04:46:38 AM
-- Design Name: 
-- Module Name: TOP - Behavioral
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

entity TOP is
Port (
        clk : in std_logic;
        instr_mem_address : out std_logic_vector(31 downto 0);
        instr_mem_read : in std_logic_vector(31 downto 0);
        data_mem_address : out std_logic_vector(31 downto 0);
        data_mem_read : in std_logic_vector(31 downto 0);
        data_mem_write : out std_logic_vector(31 downto 0);
        data_mem_we : out std_logic_vector(3 downto 0)
         );
end TOP;

architecture Behavioral of TOP is
signal instruction_s : std_logic_vector(31 downto 0);
--signal pc_next_sel_s, pc_en_s, if_id_flush_s, if_id_en_s, rd_we_s, branch_forward_a_s, branch_forward_b_s, branch_condition_s, alu_b_mux_s, mem_to_reg_s : std_logic;
--signal alu_forward_a_s, alu_forward_b_s : std_logic_vector(1 downto 0);
--signal alu_op_s : std_logic_vector(4 downto 0);

signal mem_to_reg_s : std_logic := '0';
signal alu_op_s : std_logic_vector(4 downto 0):= (others => '0');
signal alu_b_mux_s : std_logic := '0';
signal rd_we_s : std_logic := '0';
signal pc_next_sel_s : std_logic := '0';
--data_mem_we <= (others => '0');
signal alu_forward_a_s : std_logic_vector(1 downto 0) := "00";
signal alu_forward_b_s : std_logic_vector(1 downto 0) := "00";
signal branch_forward_a_s : std_logic := '0';
signal branch_forward_b_s : std_logic := '0';
signal if_id_flush_s : std_logic := '0';
signal pc_en_s : std_logic := '1';
signal if_id_en_s : std_logic := '1';
signal branch_condition_s : std_logic := '0';

begin



Data: entity work.data_path(Behavioral)
        port map(
            clk => clk,
            instr_mem_adress_o => instr_mem_address,
            instr_mem_read_i => instr_mem_read,
            instruction_o => instruction_s,
            
            data_mem_adress => data_mem_address,
            data_mem_i => data_mem_write,
            data_mem_o => data_mem_read,
            
            pc_next_sel => pc_next_sel_s,
            pc_en => pc_en_s,
            if_id_flush => if_id_flush_s,
            if_id_en => if_id_en_s,
            rd_we => rd_we_s,
            branch_forward_a => branch_forward_a_s,
            branch_forward_b => branch_forward_b_s,
            branch_condition => branch_condition_s,
            alu_forward_a => alu_forward_a_s,
            alu_forward_b => alu_forward_b_s,
            alu_b_mux => alu_b_mux_s,
            alu_sel => alu_op_s,
            mem_to_reg_sel => mem_to_reg_s
                    );

Control: entity work.control_path(Behavioral)
            port map(
                    clk => clk,
                    instruction => instruction_s,
                    branch_condition => branch_condition_s,
                    mem_to_reg => mem_to_reg_s,
                    alu_op => alu_op_s,
                    alu_src => alu_b_mux_s,
                    rd_we => rd_we_s,
                    pc_next_sel => pc_next_sel_s,
                    data_mem_we => data_mem_we,
                    alu_forward_a => alu_forward_a_s,
                    alu_forward_b => alu_forward_b_s,
                    branch_forward_a => branch_forward_a_s,
                    branch_forward_b => branch_forward_b_s,
                    if_id_flush => if_id_flush_s,
                    pc_en => pc_en_s,
                    if_id_en => if_id_en_s
                        );

end Behavioral;
