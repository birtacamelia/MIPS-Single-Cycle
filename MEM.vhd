----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2026 12:18:37 AM
-- Design Name: 
-- Module Name: MEM - Behavioral
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

entity MEM is
  Port( clk: in std_logic;
        en: in std_logic;
        MemWrite: in std_logic;
        Address: in std_logic_vector(31 downto 0);
        WriteData: in std_logic_vector( 31 downto 0);
        ALURes_out: out std_logic_vector(31 downto 0);
        MemData: out std_logic_vector(31 downto 0));
        
        
end MEM;

architecture Behavioral of MEM is
 type mem_type is array ( 0 to 63) of std_logic_vector ( 31 downto 0);
 signal memo: mem_type:= (X"00000004", --N
                          X"00000001", -- prirmul numar din sir
                          X"00000002",
                          X"00000003", 
                          X"00000004", 
                          others => X"00000000");
begin

       process(clk)
        begin
         if(rising_edge (clk)) then 
          if en='1' and MemWrite='1' then 
            MEMO(conv_integer(Address(7 downto 2)))<=WriteData;
          end if;
        end if;
       end process;
       
       MemData<=MEMO(conv_integer (Address(7 downto 2)));
       ALURes_out<=Address;
       
end Behavioral;
