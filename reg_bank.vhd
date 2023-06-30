----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2023 12:13:21 AM
-- Design Name: 
-- Module Name: reg_bank - Behavioral
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

--***************OPIS MODULA*********************
--Registarska banka sa dva interfejsa za citanje 
--podataka i jednim interfejsom za upis podataka.
--Broj registara u banci je 32.
--WIDTH je parametar koji odredjuje sirinu podataka
-- u registrima.
--***********************************************

entity reg_bank is
--generic (WIDTH : positive := 32);
Port (
        clk : in std_logic; -- Sinhronizacioni signali
       -- reset : in std_logic;
        
        rs1_adress : in std_logic_vector (4 downto 0); -- Interfejs 1
        rs1_data : out std_logic_vector (31 downto 0);
        
        rs2_adress : in std_logic_vector (4 downto 0); -- Interfejs 2
        rs2_data : out std_logic_vector (31 downto 0);
        
        rd_adress : in std_logic_vector (4 downto 0); -- Interfejs za upis
        rd_data : in std_logic_vector (31 downto 0);
        rd_we : in std_logic
         );
end reg_bank;

architecture Behavioral of reg_bank is
 type registar is array (0 to 31) of std_logic_vector (31 downto 0);
 signal reg_file: registar :=(others => "00000000000000000000000000000000");
begin
  
 write_reg_file: process (clk) is -- Upis u rd registar
 begin
 if (clk'event and clk = '0') then 
    if (rd_we = '1') then
    reg_file(to_integer(unsigned(rd_adress))) <= rd_data;
    end if;
    end if;
 end process;
 
 rs1_data <= reg_file(to_integer(unsigned(rs1_adress))); -- Asinhrono citanje
 rs2_data <= reg_file(to_integer(unsigned(rs2_adress)));
 --rs2_data <= (others => '1');
end Behavioral;
