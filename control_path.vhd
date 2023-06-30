----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/05/2023 08:59:26 PM
-- Design Name: 
-- Module Name: control_path - Behavioral
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

entity control_path is
Port (
        clk : in std_logic;
        --reset : in std_logic;
        instruction : in std_logic_vector(31 downto 0);
        branch_condition : in std_logic;
        mem_to_reg : out std_logic;
        alu_op : out std_logic_vector(4 downto 0);
        alu_src : out std_logic;
        rd_we : out std_logic;
        pc_next_sel : out std_logic;
        data_mem_we : out std_logic_vector(3 downto 0);
        alu_forward_a : out std_logic_vector(1 downto 0);
        alu_forward_b : out std_logic_vector(1 downto 0);
        branch_forward_a : out std_logic;
        branch_forward_b : out std_logic;
        if_id_flush : out std_logic;
        pc_en : out std_logic;
        if_id_en : out std_logic
         );
end control_path;

architecture Behavioral of control_path is

signal branch_id, mem_to_reg_id, data_mem_we_id, alu_src_id, rd_we_id, rs1_in_use_id, rs2_in_use_id  : std_logic;
signal alu_2bit_op_id, alu_2bit_op_ex : std_logic_vector(1 downto 0);
signal rs1_address_id, rs2_address_id, rd_address_ex, rd_address_mem, rs1_address_ex, rs2_address_ex : std_logic_vector(4 downto 0);
signal mem_to_reg_ex, rd_we_ex, mem_to_reg_mem, control_pass, rd_we_mem, rd_we_wb : std_logic;
signal rd_address_wb : std_logic_vector(4 downto 0);
signal funct3_ex : std_logic_vector(2 downto 0);
signal funct7_ex : std_logic_vector(6 downto 0);
signal  data_mem_we_ex, data_mem_we_mem : std_logic;

begin

--mem_to_reg <= '0';
--alu_op <= (others => '0');
--alu_src <= '0';
--rd_we <= '0';
--pc_next_sel <= '0';
--data_mem_we <= (others => '0');
--alu_forward_a <= "00";
--alu_forward_b <= "00";
--branch_forward_a <= '0';
--branch_forward_b <= '0';
--if_id_flush <= '0';
--pc_en <= '1';
--if_id_en <= '1';

pc_next_sel <= branch_id and branch_condition;
if_id_flush <= branch_id and branch_condition;

dekoder: entity work.ctrl_decoder(Behavioral)
            port map(
                   opcode => instruction(6 downto 0),
                   branch => branch_id,
                   mem_to_reg => mem_to_reg_id,
                   data_mem_we => data_mem_we_id,
                   alu_src => alu_src_id,
                   rd_we => rd_we_id,
                   rs1_in_use => rs1_in_use_id,
                   rs2_in_use => rs2_in_use_id,
                   alu_2bit_op => alu_2bit_op_id 
                        );

hazard: entity work.hazard_unit(Behavioral)
            port map(
                   rs1_address_id => instruction(19 downto 15),
                   rs2_address_id => instruction(24 downto 20),
                   rs1_in_use => rs1_in_use_id,
                   rs2_in_use => rs2_in_use_id,
                   branch_id => branch_id,
                   rd_address_ex => rd_address_ex,
                   mem_to_reg_ex => mem_to_reg_ex,
                   rd_we_ex => rd_we_ex,
                   rd_address_mem => rd_address_mem,
                   mem_to_reg_mem => mem_to_reg_mem,
                   pc_en => pc_en,
                   if_id_en => if_id_en,
                   control_pass => control_pass
                        );
                        
forvrding: entity work.forwarding_unit(Behavioral)
            port map(
                rs1_address_id => instruction(19 downto 15),
                rs2_address_id => instruction(24 downto 20),
                rs1_address_ex => rs1_address_ex,
                rs2_address_ex => rs2_address_ex,
                rd_we_mem => rd_we_mem,
                rd_address_mem => rd_address_mem,
                rd_we_wb => rd_we_wb,
                rd_address_wb => rd_address_wb,
                alu_forward_a => alu_forward_a,
                alu_forward_b => alu_forward_b,
                branch_forward_a => branch_forward_a,
                branch_forward_b => branch_forward_b
                        );

aluuu: entity work.ALU_decoder(Behavioral)
            port map(
                  alu_2bit_op => alu_2bit_op_ex,
                  funct3 => funct3_ex,
                  funct7 => funct7_ex,
                  alu_op => alu_op        
                        );

ID_EX: process (clk) is
        begin
            if (clk'event and clk = '1') then
            if (control_pass = '0') then
                mem_to_reg_ex <= mem_to_reg_id;
                data_mem_we_ex <= data_mem_we_id;
                rd_we_ex <= rd_we_id;
                alu_src <= alu_src_id;
                alu_2bit_op_ex <= alu_2bit_op_id;
                funct3_ex <= instruction(14 downto 12);
                funct7_ex <= instruction(31 downto 25);
                rd_address_ex <= instruction(11 downto 7);
                rs1_address_ex <= instruction(19 downto 15);
                rs2_address_ex <= instruction(24 downto 20);
            else
            mem_to_reg_ex <= '0'; -- POGLEDAJ DA LI IDU SVE NULE ILI SE NISTA NE DESAVA (OSTAJE IZ PRETHODNOG)
            data_mem_we_ex <= '0';
            rd_we_ex <= '0';
            alu_src <= '0';
            alu_2bit_op_ex <= "00";
            funct3_ex <= "000";
            funct7_ex <= "0000000";
            rd_address_ex <= "00000";
            rs1_address_ex <= "00000";
            rs2_address_ex <= "00000";
            end if;
            end if;
        end process;

EX_MEM: process (clk) is
        begin
        if (clk'event and clk = '1') then
            mem_to_reg_mem <= mem_to_reg_ex;
            data_mem_we_mem <= data_mem_we_ex;
            rd_we_mem <= rd_we_ex;
            rd_address_mem <= rd_address_ex;
        end if;    
        end process;

MEM_WB: process (clk) is
        begin
        if (clk'event and clk = '1') then
            mem_to_reg <= mem_to_reg_mem;
            rd_we <= rd_we_mem;
            rd_address_wb <= rd_address_mem;
        end if;
        end process;

--process (branch_id, branch_condition) is
--begin        

--end process;

--process (data_mem_we_mem) is
--begin

--end if;
--end process;




process (data_mem_we_mem) is 
begin
if (data_mem_we_mem = '0') then -- NAKON 150PS JE NULA
    data_mem_we <= "0000";
    else
    data_mem_we <= "1111";
end if;
end process;


end Behavioral;
