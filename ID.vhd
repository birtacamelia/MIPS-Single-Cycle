----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/06/2026 02:13:21 PM
-- Design Name: 
-- Module Name: ID - Behavioral
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
use IEEE.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ID is
  Port( clk: in std_logic;
        RegWrite: in std_logic;
        Instr: in std_logic_vector(25 downto 0);
        RegDst: in std_logic;
        en: in std_logic;
        ExtOp: in std_logic;
        WD: in std_logic_vector( 31 downto 0);
        RD1: out std_logic_vector( 31 downto 0);
        RD2: out std_logic_vector(31 downto 0);
        Ext_Imm: out std_logic_vector( 31 downto 0);
        func: out std_logic_vector( 5 downto 0);
        sa: out std_logic_vector( 4 downto 0));
        
        
end ID;

architecture Behavioral of ID is
  signal WA: std_logic_vector(4 downto 0);
  type RF_type is array ( 0 to 31) of std_logic_vector (31 downto 0);
  signal mem : RF_type :=( others=>X"00000000");
  
begin

  func<=Instr(5 downto 0);
  sa<=Instr(10 downto 6);
  
     process(ExtOp,Instr)
        begin
      if ExtOp='0' then 
         Ext_Imm(15 downto 0)<=Instr(15 downto 0);
         Ext_Imm(31 downto 16)<=(others=>'0');
      elsif ExtOp='1'then
         Ext_Imm(15 downto 0)<=Instr(15 downto 0);
         Ext_Imm(31 downto 16)<=(others=>Instr(15));
      end if; 
     end process;
     
     process(Instr,RegDst)
        begin
          if RegDst='0' then 
            WA<=Instr(20 downto 16);
          elsif RegDst='1' then
            WA<=Instr(15 downto 11);
          end if;
     end process;
     
      process(clk)
        begin
         if rising_edge(clk) then
           if en='1' and RegWrite='1' then
               mem(conv_integer(WA))<=WD;
           end if;
        end if;
     end process;
     
   RD1<=mem(conv_integer(Instr(25 downto 21)));
   RD2<=mem(conv_integer(Instr(20 downto 16)));
end Behavioral;
