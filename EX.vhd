----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/16/2026 10:18:04 PM
-- Design Name: 
-- Module Name: EX - Behavioral
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
use IEEE.numeric_std .all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EX is
 Port ( RD1: in std_logic_vector(31 downto 0);
        ALUSrc: in std_logic;
        RD2: in std_logic_vector(31 downto 0);
        Ext_Imm: in std_logic_vector(31 downto 0);
        sa: in std_logic_vector(4 downto 0);
        func: in std_logic_vector( 5 downto 0);
        ALUOp: in std_logic_vector( 1 downto 0);
        PC_4:in std_logic_vector (31 downto 0);
        zero:out std_logic;
        SF: out std_logic;
        ALURes: out std_logic_vector(31 downto 0);
        Branch_Address: out std_logic_vector(31 downto 0));
        
end EX;

architecture Behavioral of EX is
  signal B: std_logic_vector(31 downto 0);
  signal ALUCtrl: std_logic_vector(2 downto 0);
  signal Ext_ImmShift: std_logic_vector(31 downto 0);
  signal C: std_logic_vector( 31 downto 0);
  
begin

     process(RD2,Ext_Imm,ALUSrc)
       begin
         if(ALUSrc='0') then
             B<=RD2;
         else
             B<=Ext_Imm;
         end if;
    end process;
    
    
    process(ALUOp,func)
       begin
        case ALUOp is
        when "01"=> 
           case func is
           when "000001"=>ALUCtrl<="001";
           when "000010"=>ALUCtrl<="010";
           when "000011"=>ALUCtrl<="011";
           when "000100"=>ALUCtrl<="100";
           when "000101"=>ALUCtrl<="101";
           when "000110"=>ALUCtrl<="110";
           when "000111"=>ALUCtrl<="000";
           when "001000"=>ALUCtrl<="111";
           when others=>ALUCtrl<=(others=>'X');
           end case;
        when "10"=>ALUCtrl<="001";
        when "11"=>ALUCtrl<="010";
        when others=>ALUCtrl<=(others=>'0');
        end case;
        end process;
   
  Ext_ImmShift<= Ext_Imm( 29 downto 0) & "00";
  Branch_Address<=Ext_immShift+PC_4;
  
    process(RD1,B,ALUCtrl,sa)
       begin
       
       case ALUCtrl is
        when "001"=>C<=RD1+B;
        when "010"=>C<=RD1-B;
        when "011"=>C<=to_stdlogicvector( to_bitvector(B) sll conv_integer (sa));
        when "100"=>C<=to_stdlogicvector( to_bitvector(B) srl conv_integer (sa));
        when "101"=>C<=RD1 and B;
        when "110"=>C<=RD1 or B;
        when "111"=>C<=to_stdlogicvector( to_bitvector(B) sll conv_integer (RD1));
        when "000"=> if signed(RD1)<signed(B) then C<=X"00000001";
                                              else C<=X"00000000";
                                              end if;
         when others=>C<=(others=>'X');                                 
        end case;
       end process;
       
AlURes<=C;        
zero<='1' when C=0 else '0';
SF<=C(31);
end Behavioral;
