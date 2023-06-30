----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2023 11:28:06 PM
-- Design Name: 
-- Module Name: data_path - Behavioral
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

entity data_path is
Port (
    clk : in std_logic; -- Sinhronizacioni signali
    --reset : in std_logic;
    
    instr_mem_adress_o : out std_logic_vector (31 downto 0); -- Memorija za instrukcije
    instr_mem_read_i : in std_logic_vector (31 downto 0);
    instruction_o : out std_logic_vector (31 downto 0);
    
    data_mem_adress : out std_logic_vector (31 downto 0); -- Memorija za podatke
    data_mem_i : out std_logic_vector (31 downto 0);
    data_mem_o : in std_logic_vector (31 downto 0);
    
    pc_next_sel : in std_logic; -- Kontrolni signali
    pc_en : in std_logic;
    if_id_flush : in std_logic;
    if_id_en : in std_logic;
    rd_we : in std_logic;
    branch_forward_a : in std_logic;
    branch_forward_b : in std_logic;
    branch_condition : out std_logic;
    alu_forward_a : in std_logic_vector (1 downto 0);
    alu_forward_b : in std_logic_vector (1 downto 0);
    alu_b_mux : in std_logic;
    alu_sel : in std_logic_vector (4 downto 0);
   -- data_mem_we : in std_logic_vector (3 downto 0);
    mem_to_reg_sel : in std_logic
     );
end data_path;

architecture Behavioral of data_path is
signal pc_nesto : integer := 0;
signal add_2_s, instruction, rs1_data_s, rs2_data_s : std_logic_vector (31 downto 0);
signal pc_o_s : std_logic_vector (31 downto 0) := (others => '0');
signal rd_data_s, pre_add_2_s, imm_s, mem_add_s, rs1_ex_s, rs2_ex_1_s, rs2_ex_2_s, imm_ex_s, instruction_ex_s  :  std_logic_vector (31 downto 0);
signal alu_1_s, alu_2_s, instruction_mem_s, instruction_wb_s, alu_res_s : std_logic_vector (31 downto 0);
signal rs1_instruction , rs2_instruction : std_logic_vector(4 downto 0); 

begin

 --initialization: process is
--begin
--pc_i_s <= (others => '0');
--end process;

data_mem_adress <= mem_add_s;
instr_mem_adress_o <= pc_o_s;

PC: process (clk) is

begin
if (clk'event and clk = '1' and pc_en = '1') then 
    --if (pc_en = '1') then
   if (pc_next_sel = '0') then
    pc_o_s <= std_logic_vector(std_logic_vector(to_unsigned(pc_nesto,32)));
       pc_nesto <= pc_nesto + 4;                             
    else
    pc_o_s <= std_logic_vector((shift_left(unsigned(imm_s),1)) + unsigned (pre_add_2_s)); --OBRATI PAZNJU NA SABIRANJE SA UNSIGNED
    end if;
    end if;
    --end if;
end process;





IF_ID_reg: process (clk) is
begin
    if (clk'event and clk = '1' and if_id_en = '1') then
       if (if_id_flush = '0') then
            instruction <= instr_mem_read_i;
           -- pre_add_2_s <= pc_o_s;
            else
            instruction <= (others => '0');
            --pre_add_2_s <= (others => '0');
            end if;
            end if;
end process;

rs1_instruction <= instruction(19 downto 15);
rs2_instruction <= instruction(24 downto 20); 

bank: entity work.reg_bank(Behavioral)
        port map (
        clk => clk,
       -- reset => ;
        
        rs1_adress => rs1_instruction,
        rs1_data => rs1_data_s,
        
        rs2_adress => rs2_instruction, --rs2_instruction,
        rs2_data => rs2_data_s,
        
        rd_adress => instruction_wb_s (11 downto 7), -- OBRATI PAZNJU
        rd_data => rd_data_s,
        rd_we => rd_we
 );



imm: entity work.immediate(Behavioral)
        port map (
                  instruction => instruction,
                  imm_ext => imm_s
                   );

condition: process (rs1_data_s, rs2_data_s, mem_add_s, branch_forward_a, branch_forward_b, instruction) is
            begin
            if (instruction (14 downto 12) = "000") then
                if (branch_forward_a = '0' and branch_forward_b = '0') then
                    if (rs1_data_s = rs2_data_s) then
                        branch_condition <= '1';
                        else
                        branch_condition <= '0';
                        end if;
                elsif (branch_forward_a = '0' and branch_forward_b = '1') then
                    if (rs1_data_s = mem_add_s) then
                         branch_condition <= '1';
                         else
                         branch_condition <= '0';
                         end if;
                elsif (branch_forward_a = '1' and branch_forward_b = '0') then
                    if (rs2_data_s = mem_add_s) then
                          branch_condition <= '1';
                          else
                          branch_condition <= '0';
                          end if;
                else
                    branch_condition <= '1';
                end if;
                
                
                elsif (instruction (14 downto 12) = "101") then
                                if (branch_forward_a = '0' and branch_forward_b = '0') then
                                    if (rs1_data_s >= rs2_data_s) then
                                        branch_condition <= '1';
                                        else
                                        branch_condition <= '0';
                                        end if;
                                elsif (branch_forward_a = '0' and branch_forward_b = '1') then
                                    if (rs1_data_s >= mem_add_s) then
                                         branch_condition <= '1';
                                         else
                                         branch_condition <= '0';
                                         end if;
                                elsif (branch_forward_a = '1' and branch_forward_b = '0') then
                                    if (rs2_data_s >= mem_add_s) then
                                          branch_condition <= '1';
                                          else
                                          branch_condition <= '0';
                                          end if;
                                else
                                    branch_condition <= '1';
                                end if;
                 else branch_condition <= '0';
                 end if;
            end process;
    
ID_EX_reg: process (clk) is
            begin
                if (clk'event and clk = '1') then
                    rs1_ex_s <= rs1_data_s;
                    rs2_ex_1_s <= rs2_data_s;
                    imm_ex_s <= imm_s;
                    rs2_ex_2_s <= rs2_data_s;
                    instruction_ex_s <= instruction;
                end if;
            end process;

AL: process (alu_forward_a, rs1_ex_s, rd_data_s, mem_add_s) is
        begin
        if (alu_forward_a = "00") then
            alu_1_s <= rs1_ex_s;
        elsif (alu_forward_a = "01") then
            alu_1_s <= rd_data_s;
        elsif (alu_forward_a = "10") then
            alu_1_s <= mem_add_s;
        else
            alu_1_s <= (others => '0');
        end if;
        end process;
        
    process (alu_b_mux, alu_forward_b, rs2_ex_2_s, rd_data_s, mem_add_s, imm_ex_s) is
        begin
        if (alu_b_mux = '0') then
            if (alu_forward_a = "00") then
                    alu_2_s <= rs2_ex_2_s;
                elsif (alu_forward_a = "01") then
                    alu_2_s <= rd_data_s;
                elsif (alu_forward_a = "10") then
                    alu_2_s <= mem_add_s;
                else
                    alu_2_s <= (others => '0');
                end if;
        else
            alu_2_s <= imm_ex_s;
        end if;
        end process;

aritemticko_logicka_jedinica: entity work.ALU(Behavioral)
                                    port map( a => alu_1_s,
                                              b => alu_2_s,
                                              op => alu_sel,
                                              res => alu_res_s
                                              );

EX_MEM_reg: process (clk) is
                begin
                if (clk'event and clk = '1') then
                    mem_add_s <= alu_res_s;
                    data_mem_i <= rs2_ex_2_s;
                    instruction_mem_s <= instruction_ex_s;
                end if;
                end process;

--process (mem_add_s) is
--begin

--end process;

MEM_WB_reg: process (clk) is
                begin
                if (clk'event and clk = '1') then
                    if (mem_to_reg_sel = '0') then
                        rd_data_s <= mem_add_s;
                    else
                        rd_data_s <= data_mem_o;
                    end if;
                instruction_wb_s <= instruction_mem_s;
                end if;
                end process;

--process (pc_o_s, mem_add_s) is
--begin
instruction_o <= instruction;
--end process;

end Behavioral;
